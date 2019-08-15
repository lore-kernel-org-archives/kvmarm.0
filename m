Return-Path: <SRS0=wpUy=WL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667BDC31E40
	for <kvmarm@archiver.kernel.org>; Thu, 15 Aug 2019 09:56:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9C8421743
	for <kvmarm@archiver.kernel.org>; Thu, 15 Aug 2019 09:56:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9C8421743
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 254844A576;
	Thu, 15 Aug 2019 05:56:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4XStwFOlgkjO; Thu, 15 Aug 2019 05:56:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E13C64A56A;
	Thu, 15 Aug 2019 05:56:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9184A566
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Aug 2019 05:56:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GlL3+9UpMA+d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Aug 2019 05:56:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 389EE4A4E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Aug 2019 05:56:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5B4F28;
 Thu, 15 Aug 2019 02:56:35 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com
 [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5F25D3F706;
 Thu, 15 Aug 2019 02:56:34 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH] KVM: arm/arm64: vgic: Make function comments match function
 declarations
Date: Thu, 15 Aug 2019 10:56:22 +0100
Message-Id: <1565862982-9787-1-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: maz@kernel.org, julien.grall@arm.com, andre.przywara@arm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Since commit 503a62862e8f ("KVM: arm/arm64: vgic: Rely on the GIC driver to
parse the firmware tables"), the vgic_v{2,3}_probe functions stopped using
a DT node. Commit 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init:
implement kvm_vgic_hyp_init") changed the functions again, and now they
require exactly one argument, a struct gic_kvm_info populated by the GIC
driver. Unfortunately the comments regressed and state that a DT node is
used instead. Change the function comments to reflect the current
prototypes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 7 ++++---
 virt/kvm/arm/vgic/vgic-v3.c | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 96aab77d0471..27b1ddf71aa0 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -354,10 +354,11 @@ int vgic_v2_map_resources(struct kvm *kvm)
 DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
 
 /**
- * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
- * @node:	pointer to the DT node
+ * vgic_v2_probe - probe for a VGICv2 compatible interrupt controller
+ * @info:	pointer to the GIC description
  *
- * Returns 0 if a GICv2 has been found, returns an error code otherwise
+ * Returns 0 if the VGICv2 has been probed successfully, returns an error code
+ * otherwise
  */
 int vgic_v2_probe(const struct gic_kvm_info *info)
 {
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 0c653a1e5215..4874f3266bea 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -570,10 +570,11 @@ static int __init early_gicv4_enable(char *buf)
 early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 
 /**
- * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
- * @node:	pointer to the DT node
+ * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
+ * @info:	pointer to the GIC description
  *
- * Returns 0 if a GICv3 has been found, returns an error code otherwise
+ * Returns 0 if the VGICv3 has been probed successfully, returns an error code
+ * otherwise
  */
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
