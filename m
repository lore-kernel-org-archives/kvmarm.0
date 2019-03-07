From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 01/16] Makefile: Only compile vesa for archs that need
 it
Date: Thu,  7 Mar 2019 08:36:02 +0000
Message-ID: <1551947777-13044-2-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 970094A455
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kp1E0RXUjvBp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:26 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 659A74A49D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:26 -0500 (EST)
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
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
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The vesa framebuffer is only used by architectures that explicitly
require it (i.e. x86). Compile it out for architectures not using it, as
its current implementation might not work for them.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c4faff6..288e467 100644
--- a/Makefile
+++ b/Makefile
@@ -94,7 +94,6 @@ OBJS	+= util/read-write.o
 OBJS	+= util/util.o
 OBJS	+= virtio/9p.o
 OBJS	+= virtio/9p-pdu.o
-OBJS	+= hw/vesa.o
 OBJS	+= hw/pci-shmem.o
 OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
@@ -219,6 +218,8 @@ else
 endif
 
 ifeq (y,$(ARCH_HAS_FRAMEBUFFER))
+	OBJS	+= hw/vesa.o
+
 	CFLAGS_GTK3 := $(shell pkg-config --cflags gtk+-3.0 2>/dev/null)
 	LDFLAGS_GTK3 := $(shell pkg-config --libs gtk+-3.0 2>/dev/null)
 	ifeq ($(call try-build,$(SOURCE_GTK3),$(CFLAGS) $(CFLAGS_GTK3),$(LDFLAGS) $(LDFLAGS_GTK3)),y)
-- 
1.9.1
