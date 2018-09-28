#include "class_list.h"

int main(int argc, char *argv[]) {
	//arguments check
	if (argc<3) {
		cout << "There is no input bim or reference bim!\n";
		return 1;
	}

	size_t found[2];
	unsigned int chr[2], pos[2], flag=0;
	double maf[2];
	string temp[4], path, id;
	ifstream input[4];
	ofstream output[2];

	path = argv[2];	// reference input
	temp[0] = path + ".bim";
	input[2].open(temp[0].c_str());
	temp[0] = path + ".frq";
	input[3].open(temp[0].c_str());
	found[0] = path.find_last_of('/');
	temp[1] = path.substr(found[0]+1);

	path = argv[1];	// target input
	temp[0] = path + ".bim";
	input[0].open(temp[0].c_str());
	temp[0] = path + ".frq";
	input[1].open(temp[0].c_str());

	temp[0] = path + ".overlap";
	output[0].open(temp[0].c_str());	// target bim	
	temp[0] = temp[1] + ".overlap";
	output[1].open(temp[0].c_str());	// reference bim

	if (input[0].is_open()==0||input[1].is_open()==0||input[2].is_open()==0||input[3].is_open()==0||output[0].is_open()==0||output[1].is_open()==0) {
		cout << "input or output file is not open\n";
		return 1;
	}

	while (input[0].good()&&!input[0].eof()) {
		if (flag!=1) {
			getline(input[0],temp[0]);
			if (temp[0]=="\0") continue;
			found[0] = temp[0].find('	');
			chr[0] = atoi(temp[0].substr(0,found[0]).c_str());
			found[1] = temp[0].find('	',found[0]+1);
			found[0] = temp[0].find('	',found[1]+1);
			found[1] = temp[0].find('	',found[0]+1);
			pos[0] = atoi(temp[0].substr(found[0]+1,found[1]-found[0]-1).c_str());
			getline(input[1],temp[2]);
		}

		if (flag<2) {
			if (!input[2].good()||input[2].eof()) break;
			getline(input[2],temp[1]);
			if (temp[1]=="\0") continue;
			found[0] = temp[1].find('	');
			chr[1] = atoi(temp[1].substr(0,found[0]).c_str());
			found[1] = temp[1].find('	',found[0]+1);
			found[0] = temp[1].find('	',found[1]+1);
			found[1] = temp[1].find('	',found[0]+1);
			pos[1] = atoi(temp[1].substr(found[0]+1,found[1]-found[0]-1).c_str());
			getline(input[3],temp[3]);
		}

		if (chr[0]==chr[1]) {
			if (pos[0]==pos[1]) {
				found[1] = temp[2].find_last_of(' ');
				found[0] = temp[2].find_last_of(' ',found[1]-1);
				maf[0] = atof(temp[2].substr(found[0]+1,found[1]-found[0]-1).c_str());

				found[1] = temp[3].find_last_of(' ');
				found[0] = temp[3].find_last_of(' ',found[1]-1);
				maf[1] = atof(temp[3].substr(found[0]+1,found[1]-found[0]-1).c_str());

				if (abs(maf[0]-maf[1])<0.3) {
					found[0] = temp[0].find("\t");
					found[1] = temp[0].find("\t",found[0]+1);
					output[0] << temp[0].substr(found[0]+1,found[1]-found[0]-1) << endl;

					found[0] = temp[1].find("\t");
					found[1] = temp[1].find("\t",found[0]+1);
					output[1] << temp[1].substr(found[0]+1,found[1]-found[0]-1) << endl;
				}
				flag = 1;
			}
			else if (pos[0]>pos[1])
				flag = 1;
			else
				flag = 2;
		}
		else if (chr[0]>chr[1])
			flag = 1;
		else
			flag = 2;

	}
	
	input[0].close();
	input[1].close();
	input[2].close();
	input[3].close();
	output[0].close();
	output[1].close();
	return 0;
}
