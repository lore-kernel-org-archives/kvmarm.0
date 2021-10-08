Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17410C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:58:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFA0E6113E
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AFA0E6113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5264C4B160;
	Fri,  8 Oct 2021 09:58:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kxcyhQ6WZOmv; Fri,  8 Oct 2021 09:58:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3606F4B102;
	Fri,  8 Oct 2021 09:58:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A76634B102
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GuQvpAV04vrn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 09:58:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75FF74B089
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:52 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2839E61039;
 Fri,  8 Oct 2021 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633701531;
 bh=NVbzQ35Z52Znz8dA7HLlPUIzmjGtwNnE/zkgMUVad5k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=IG2j3V4PSaXd4QbkhdY5fPc3NLcWzoiyw7dTzNN3I3RLqz67KBvk17f8zPzDKc1eq
 dXMyRk7AKmt2A56Zh900osINw2J022lubOKwwHIJjAG/8/E07hwEOBVTut+VzPjhrZ
 mJhuufQEmLHYdN28i5EXQHHZg+RByWyUiTXjgcD12o9tm6cjcXsyZH2gAzm0CEkgB3
 791s2EdTkoH2Dc9U05+9YZR7gBZgffPWDF0IHlL3fHslX2FAc1bGkxQHCDeHlJ50gV
 g0/gi8hMmQLsOlJJWYH/p3CS/JUxP8JsB7t2G1TOsd7MDJaXLH4TlF35YjrOaJAZrJ
 /KxgRPk3TVJAQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/6] KVM: arm64: Turn __KVM_HOST_SMCCC_FUNC_* into an enum
 (mostly)
Date: Fri,  8 Oct 2021 14:58:34 +0100
Message-Id: <20211008135839.1193-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211008135839.1193-1-will@kernel.org>
References: <20211008135839.1193-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

From: Marc Zyngier <maz@kernel.org>

__KVM_HOST_SMCCC_FUNC_* is a royal pain, as there is a fair amount
of churn around these #defines, and we avoid making it an enum
only for the sake of the early init, low level code that requires
__KVM_HOST_SMCCC_FUNC___kvm_hyp_init to be usable from assembly.

Let's be brave and turn everything but this symbol into an enum,
using a bit of arithmetic to avoid any overlap.

Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/877depq9gw.wl-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h | 44 +++++++++++++++++---------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e86045ac43ba..43b5e213ae43 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -44,31 +44,35 @@
 #define KVM_HOST_SMCCC_FUNC(name) KVM_HOST_SMCCC_ID(__KVM_HOST_SMCCC_FUNC_##name)
 
 #define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
-#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			1
-#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
-#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
-#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
-#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		8
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		9
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		10
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		11
-#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
-#define __KVM_HOST_SMCCC_FUNC___pkvm_init			15
-#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp		16
-#define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
-#define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
-#define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
-#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			20
 
 #ifndef __ASSEMBLY__
 
 #include <linux/mm.h>
 
+enum __kvm_host_smccc_func {
+	/* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
+	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
+	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
+	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
+	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
+	__KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs,
+	__KVM_HOST_SMCCC_FUNC___pkvm_init,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
+	__KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector,
+	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
+	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
+};
+
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
 #define DECLARE_KVM_NVHE_SYM(sym)	extern char kvm_nvhe_sym(sym)[]
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
