From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/27] KVM: vgic: add virt-capable compatible strings
Date: Thu,  2 Apr 2015 11:05:05 +0100
Message-ID: <1427969131-8445-2-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E5684AD2A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4qpWsBr7l0Cx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 05:57:49 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F284B4AD13
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:48 -0400 (EDT)
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Several dts only list "arm,cortex-a7-gic" or "arm,gic-400" in their GIC
compatible list, and while this is correct (and supported by the GIC
driver), KVM will fail to detect that it can support these cases.

This patch adds the missing strings to the VGIC code. The of_device_id
entries are padded to keep the probe function data aligned.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Michal Simek <monstr@monstr.eu>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 0cc6ab6..86cec79 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1865,8 +1865,10 @@ static struct notifier_block vgic_cpu_nb = {
 };
 
 static const struct of_device_id vgic_ids[] = {
-	{ .compatible = "arm,cortex-a15-gic", .data = vgic_v2_probe, },
-	{ .compatible = "arm,gic-v3", .data = vgic_v3_probe, },
+	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_probe, },
+	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_probe, },
+	{ .compatible = "arm,gic-400",		.data = vgic_v2_probe, },
+	{ .compatible = "arm,gic-v3",		.data = vgic_v3_probe, },
 	{},
 };
 
-- 
2.1.4
