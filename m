Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617C5C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 15:09:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D61849F0B;
	Thu, 10 Feb 2022 10:09:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RFmmWGvEGovc; Thu, 10 Feb 2022 10:09:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A3B24A0FE;
	Thu, 10 Feb 2022 10:09:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C83CD49F53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 10:09:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wpfr2ZwAD65J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 10:09:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9D849F37
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 10:09:46 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A011DD6E;
 Thu, 10 Feb 2022 07:09:45 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51F963F718;
 Thu, 10 Feb 2022 07:09:44 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
 varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 3/4] configure: Make the --target option
 available to all architectures
Date: Thu, 10 Feb 2022 15:09:42 +0000
Message-Id: <20220210150943.1280146-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220210150943.1280146-1-alexandru.elisei@arm.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The arm and arm64 architectures got the --target option to support running
with either qemu or kvmtool as the virtual machine manager. Make --target
valid for the other architectures, in which case qemu will be the only
valid target.

Generating the $TARGET variable in config.mak regardless of the
architecture will make adding support for another VMM to run_tests.sh
easier.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/configure b/configure
index 6620e78ec09c..2720b7efd64a 100755
--- a/configure
+++ b/configure
@@ -22,7 +22,7 @@ pretty_print_stacks=yes
 environ_default=yes
 u32_long=
 wa_divide=
-target=
+target=qemu
 errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
@@ -38,8 +38,8 @@ usage() {
 	Options include:
 	    --arch=ARCH            architecture to compile for ($arch)
 	    --processor=PROCESSOR  processor to compile for ($arch)
-	    --target=TARGET        target platform that the tests will be running on (qemu or
-	                           kvmtool, default is qemu) (arm/arm64 only)
+	    --target=TARGET        target platform that the tests will be running on (default is qemu)
+	                           (qemu or kvmtool for arm and arm64, qemu for all other architectures)
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC                c compiler to use ($cc)
 	    --cflags=FLAGS         extra options to be passed to the c compiler
@@ -168,14 +168,22 @@ arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
 
-if [ -z "$target" ]; then
-    target="qemu"
-else
+case "$target" in
+qemu)
+    # All architectures support qemu as the target.
+    ;;
+kvmtool)
+    # Only arm and arm64 support running under kvmtool.
     if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
-        echo "--target is not supported for $arch"
+        echo "--target=$target is not supported for $arch"
         usage
     fi
-fi
+    ;;
+*)
+    echo "--target=$target is not supported for $arch"
+    usage
+    ;;
+esac
 
 if [ "$target_efi" ] && [ "$arch" != "x86_64" ]; then
     echo "--target-efi is not supported for $arch"
@@ -369,10 +377,8 @@ GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 TARGET_EFI=$target_efi
 GEN_SE_HEADER=$gen_se_header
+TARGET=$target
 EOF
-if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
-    echo "TARGET=$target" >> config.mak
-fi
 
 cat <<EOF > lib/config.h
 #ifndef _CONFIG_H_
-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
