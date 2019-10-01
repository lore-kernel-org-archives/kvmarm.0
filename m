Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7682DECE589
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 09:21:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F34CD21855
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 09:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F34CD21855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D8E44A678;
	Tue,  1 Oct 2019 05:21:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id alRE+f9eR3MC; Tue,  1 Oct 2019 05:21:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5797E4A69F;
	Tue,  1 Oct 2019 05:21:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D8F4A69C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 05:21:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pr4UiNOVmtfY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 05:21:10 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44C914A678
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 05:21:10 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iFEL6-00019A-Fq; Tue, 01 Oct 2019 11:21:00 +0200
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/4] arm64: KVM: Replace hyp_alternate_select with has_vhe()
Date: Tue,  1 Oct 2019 10:20:36 +0100
Message-Id: <20191001092038.17097-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001092038.17097-1-maz@kernel.org>
References: <20191001092038.17097-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
 christoffer.dall@arm.com, yamada.masahiro@socionext.com, yuzenghui@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Masahiro Yamada <yamada.masahiro@socionext.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Given that the TLB invalidation path is pretty rarely used, there
was never any advantage to using hyp_alternate_select() here.
has_vhe(), being a glorified static key, is the right tool for
the job.

Off you go.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/hyp/tlb.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index c466060b76d6..eb0efc5557f3 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -67,10 +67,14 @@ static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
 	isb();
 }
 
-static hyp_alternate_select(__tlb_switch_to_guest,
-			    __tlb_switch_to_guest_nvhe,
-			    __tlb_switch_to_guest_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
+static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
+					     struct tlb_inv_context *cxt)
+{
+	if (has_vhe())
+		__tlb_switch_to_guest_vhe(kvm, cxt);
+	else
+		__tlb_switch_to_guest_nvhe(kvm, cxt);
+}
 
 static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
 						struct tlb_inv_context *cxt)
@@ -98,10 +102,14 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
 	write_sysreg(0, vttbr_el2);
 }
 
-static hyp_alternate_select(__tlb_switch_to_host,
-			    __tlb_switch_to_host_nvhe,
-			    __tlb_switch_to_host_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
+static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
+					    struct tlb_inv_context *cxt)
+{
+	if (has_vhe())
+		__tlb_switch_to_host_vhe(kvm, cxt);
+	else
+		__tlb_switch_to_host_nvhe(kvm, cxt);
+}
 
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
@@ -111,7 +119,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm, &cxt);
+	__tlb_switch_to_guest(kvm, &cxt);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -154,7 +162,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	if (!has_vhe() && icache_is_vpipt())
 		__flush_icache_all();
 
-	__tlb_switch_to_host()(kvm, &cxt);
+	__tlb_switch_to_host(kvm, &cxt);
 }
 
 void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
@@ -165,13 +173,13 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm, &cxt);
+	__tlb_switch_to_guest(kvm, &cxt);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host()(kvm, &cxt);
+	__tlb_switch_to_host(kvm, &cxt);
 }
 
 void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
@@ -180,13 +188,13 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest()(kvm, &cxt);
+	__tlb_switch_to_guest(kvm, &cxt);
 
 	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host()(kvm, &cxt);
+	__tlb_switch_to_host(kvm, &cxt);
 }
 
 void __hyp_text __kvm_flush_vm_context(void)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
