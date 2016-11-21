From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH] configure: honour $ARCH and $CROSS_COMPILE
Date: Mon, 21 Nov 2016 18:22:50 +0000
Message-ID: <20161121182250.13186-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA60C403F1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 13:21:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fM7CQ909a-1t for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Nov 2016 13:21:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 795DC402A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 13:21:34 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

Both environment variables seem to be standard in cross-compilation
environments, especially with Linux.
Let the configure script take those into account when setting the default
values for --arch and --cross-prefix. Explicitly specifying the latter
on the configure command line still works as expected.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi,

this maybe a personal itch to scratch here, since I set these two
variables in my environment via a (sourced) script here and never have
to care about the particular cross-compiler prefix, for instance.
It looks rather generic, though, so I was wondering if this is useful
upstream as well.

Cheers,
Andre.

 configure | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 995c8fa..9bb38ba 100755
--- a/configure
+++ b/configure
@@ -8,8 +8,9 @@ objdump=objdump
 ar=ar
 addr2line=addr2line
 arch=`uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/'`
+[ -n "$ARCH" ] && arch="$ARCH"
 host=$arch
-cross_prefix=
+cross_prefix=${CROSS_COMPILE}
 endian=""
 pretty_print_stacks=yes
 
-- 
2.9.0
