From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 13/14] TEMPORARY: update public headers for kvm_irq_routing_msi extension
Date: Mon, 20 Jul 2015 14:02:15 +0100
Message-ID: <1437397336-21385-14-git-send-email-andre.przywara@arm.com>
References: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch is preliminary and updates the headers from a kernel with
extended IRQ routing support (for ARM). It should be replaced by a
proper header update once IRQ routing support is upstream.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/kvm.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 39428d1..71ba749 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -828,7 +828,10 @@ struct kvm_irq_routing_msi {
 	__u32 address_lo;
 	__u32 address_hi;
 	__u32 data;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 devid;
+	};
 };
 
 struct kvm_irq_routing_s390_adapter {
-- 
2.3.5

