Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2FFC4740C
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A26B920828
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A26B920828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3964A5DB;
	Mon,  9 Sep 2019 09:49:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZvXPgT13+8RB; Mon,  9 Sep 2019 09:49:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 175A54A5D2;
	Mon,  9 Sep 2019 09:49:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E254A4E8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pWvvx2lN1izL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 09:49:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6C34A5E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7B5E1AED;
 Mon,  9 Sep 2019 06:49:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DC553F59C;
 Mon,  9 Sep 2019 06:49:19 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 12/17] KVM: arm/arm64: vgic: Make function comments match
 function declarations
Date: Mon,  9 Sep 2019 14:48:02 +0100
Message-Id: <20190909134807.27978-13-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

Since commit 503a62862e8f ("KVM: arm/arm64: vgic: Rely on the GIC driver to
parse the firmware tables"), the vgic_v{2,3}_probe functions stopped using
a DT node. Commit 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init:
implement kvm_vgic_hyp_init") changed the functions again, and now they
require exactly one argument, a struct gic_kvm_info populated by the GIC
driver. Unfortunately the comments regressed and state that a DT node is
used instead. Change the function comments to reflect the current
prototypes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-v2.c | 7 ++++---
 virt/kvm/arm/vgic/vgic-v3.c | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 96aab77d0471..e67945020b45 100644
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
index 0c653a1e5215..30955d162a01 100644
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
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
