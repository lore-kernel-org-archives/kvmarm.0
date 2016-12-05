From: Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC 08/15] arm/arm64: ITS: enable LPIs at
 re-distributor level
Date: Mon,  5 Dec 2016 22:46:39 +0100
Message-ID: <1480974406-29345-9-git-send-email-eric.auger@redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF7040223
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I2-ukH0-CvHt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 16:46:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C8E840501
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:36 -0500 (EST)
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

This helper function enables the signaling of LPIs by the
redistributor to the connected PE.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h |  1 +
 lib/arm/gic-v3-its.c     | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 21054cb..3e36a2a 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -145,6 +145,7 @@ extern struct its_data its_data;
 
 extern int its_parse_baser(int i, struct its_baser *baser);
 extern void its_setup_baser(int i, struct its_baser *baser);
+extern void enable_lpi(u32 redist);
 
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index f577d5f..7c768a5 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -171,3 +171,18 @@ void init_cmd_queue(void)
 	writeq(0, its_data.base + GITS_CWRITER);
 	writeq(0, its_data.base + GITS_CREADR);
 }
+
+void enable_lpi(u32 redist)
+{
+	void *ptr;
+	u64 val;
+
+	if (redist >= gicv3_data.cpu_count)
+		report_abort("%s redist=%d >= cpu_count=%d\n",
+			     __func__, redist, gicv3_data.cpu_count);
+
+	ptr = gicv3_data.redist_base[redist];
+	val = readl(ptr + GICR_CTLR);
+	val |= GICR_CTLR_ENABLE_LPIS;
+	writel(val,  ptr + GICR_CTLR);
+}
-- 
2.5.5
