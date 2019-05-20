#The mtools utilities are only tested with currently supported (non End-of-Life) versions of the MongoDB server. As of April 2018, that includes MongoDB 3.2 or newer.
#You need to have Python 2.7.x or 3.6.x installed in order to use mtools. Other versions of Python are not currently supported.

git clone git://github.com/rueckstiess/mtools.git
cd mtools
python setup.py install

yum install gcc

pip install psutil
pip install pymongo
pip install matplotlib
pip install numpy