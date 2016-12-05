From: Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC 05/15] arm/arm64: GICv3: add cpu count
Date: Mon,  5 Dec 2016 22:46:36 +0100
Message-ID: <1480974406-29345-6-git-send-email-eric.auger@redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2753C4027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OQ8hYyWym553 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 16:46:24 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58492404EF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:24 -0500 (EST)
In-Reply-To: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Add a new cpu_count field in gicv3_data indicating the
number of redistributors. This will be useful for enumeration
of their resources such as LPI pending tables.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3.h | 1 +
 lib/arm/gic-v3.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index ed330af..039b7c2 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -58,6 +58,7 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_base[NR_CPUS];
 	unsigned int irq_nr;
+	unsigned int cpu_count;
 };
 extern struct gicv3_data gicv3_data;
 
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index 6246221..9921f4d 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -12,12 +12,14 @@ void gicv3_set_redist_base(size_t stride)
 	void *ptr = gicv3_data.redist_base[0];
 	u64 typer;
 
+	gicv3_data.cpu_count = 0;
 	do {
 		typer = gicv3_read_typer(ptr + GICR_TYPER);
 		if ((typer >> 32) == aff) {
 			gicv3_redist_base() = ptr;
 			return;
 		}
+		gicv3_data.cpu_count++;
 		ptr += stride; /* skip RD_base, SGI_base, etc. */
 	} while (!(typer & GICR_TYPER_LAST));
 
-- 
2.5.5
