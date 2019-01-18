From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 03/12] Makefile: [HACK] Work around GCC 8 warnings :(
Date: Fri, 18 Jan 2019 16:14:12 +0000
Message-ID: <1547828061-20462-4-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5332C4A319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FEwS7rTq9BBN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:23 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D3F24A3C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:21 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Some of these are relatively harmless lazy coding issues; others
are overzealousness on the part of the compiler (in some cases, the
code is provably safe, yet GCC warns anyway).

Turning the warnings off locally is not nice, but better than
turning them off globally.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 Makefile | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index c4faff6..e8e9376 100644
--- a/Makefile
+++ b/Makefile
@@ -42,6 +42,7 @@ OBJS	+= builtin-stat.o
 OBJS	+= builtin-pause.o
 OBJS	+= builtin-resume.o
 OBJS	+= builtin-run.o
+CFLAGS-builtin-run.o = -Wno-format-truncation -Wno-stringop-truncation
 OBJS	+= builtin-setup.o
 OBJS	+= builtin-stop.o
 OBJS	+= builtin-version.o
@@ -63,9 +64,11 @@ OBJS	+= vfio/core.o
 OBJS	+= vfio/pci.o
 OBJS	+= virtio/blk.o
 OBJS	+= virtio/scsi.o
+CFLAGS-virtio/scsi.o = -Wno-stringop-truncation
 OBJS	+= virtio/console.o
 OBJS	+= virtio/core.o
 OBJS	+= virtio/net.o
+CFLAGS-virtio/net.o = -Wno-sizeof-pointer-memaccess -Wno-stringop-truncation
 OBJS	+= virtio/rng.o
 OBJS    += virtio/balloon.o
 OBJS	+= virtio/pci.o
@@ -82,6 +85,7 @@ OBJS	+= net/uip/udp.o
 OBJS	+= net/uip/buf.o
 OBJS	+= net/uip/csum.o
 OBJS	+= net/uip/dhcp.o
+CFLAGS-net/uip/dhcp.o = -Wno-stringop-truncation
 OBJS	+= kvm-cmd.o
 OBJS	+= util/init.o
 OBJS    += util/iovec.o
@@ -93,6 +97,7 @@ OBJS	+= util/strbuf.o
 OBJS	+= util/read-write.o
 OBJS	+= util/util.o
 OBJS	+= virtio/9p.o
+CFLAGS-virtio/9p.o = -Wno-restrict
 OBJS	+= virtio/9p-pdu.o
 OBJS	+= hw/vesa.o
 OBJS	+= hw/pci-shmem.o
@@ -439,10 +444,10 @@ endif
 %.o: %.c
 ifeq ($(C),1)
 	$(E) "  CHECK   " $@
-	$(Q) $(CHECK) -c $(CFLAGS) $(CFLAGS_DYNOPT) $< -o $@
+	$(Q) $(CHECK) -c $(CFLAGS-$@) $(CFLAGS) $(CFLAGS_DYNOPT) $< -o $@
 endif
 	$(E) "  CC      " $@
-	$(Q) $(CC) -c $(c_flags) $(CFLAGS_DYNOPT) $< -o $@
+	$(Q) $(CC) -c $(CFLAGS-$@) $(c_flags) $(CFLAGS_DYNOPT) $< -o $@
 
 
 #
-- 
2.1.4
