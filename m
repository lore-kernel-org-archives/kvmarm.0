From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC kvm-unit-tests PATCH 1/8] configure: make it run-able from outside source tree
Date: Thu,  6 Apr 2017 20:07:20 +0100
Message-ID: <20170406190727.5624-2-alex.bennee@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170406190727.5624-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is a first step to enabling out-of-tree builds for
kvm-unit-tests. When you invoke configure like this:

  ../tree.git/configure [args]

It will detect we the case and:

  - link ../tree.git/Makefile to the build-dir
  - ensure lib is created with a correct lib/asm
  - set SRCDIR in the config.mk

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 configure | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 8821f37..223809c 100755
--- a/configure
+++ b/configure
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
 ld=ld
@@ -102,12 +103,12 @@ elif [ "$arch" = "ppc64" ]; then
 else
     testdir=$arch
 fi
-if [ ! -d $testdir ]; then
+if [ ! -d $srcdir/$testdir ]; then
     echo "$testdir does not exist!"
     exit 1
 fi
-if [ -f $testdir/run ]; then
-    ln -fs $testdir/run $testdir-run
+if [ -f $srcdir/$testdir/run ]; then
+    ln -fs $srcdir/$testdir/run $testdir-run
 fi
 
 # check if uint32_t needs a long format modifier
@@ -135,18 +136,27 @@ fi
 rm -f lib_test.c
 fi
 
+# Are we in a separate build tree? If so, link the Makefile
+# so that 'make' works.
+if test ! -e Makefile; then
+    echo "linking Makefile..."
+    ln -s "${srcdir}/Makefile" .
+fi
+
 # link lib/asm for the architecture
 rm -f lib/asm
 asm=asm-generic
-if [ -d lib/$arch/asm ]; then
-	asm=$arch/asm
-elif [ -d lib/$testdir/asm ]; then
-	asm=$testdir/asm
+if [ -d $srcdir/lib/$arch/asm ]; then
+	asm=$srcdir/lib/$arch/asm
+elif [ -d $srcdir/lib/$testdir/asm ]; then
+	asm=$srcdir/lib/$testdir/asm
 fi
+mkdir -p lib
 ln -s $asm lib/asm
 
 # create the config
 cat <<EOF > config.mak
+SRCDIR=$srcdir
 PREFIX=$prefix
 HOST=$host
 ARCH=$arch
-- 
2.11.0
