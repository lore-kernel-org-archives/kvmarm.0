Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9A5C433E6
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 802EC65090
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 802EC65090
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0494B15A;
	Fri,  5 Mar 2021 13:53:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id crrV-9K3EjYc; Fri,  5 Mar 2021 13:53:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45CF14B6F3;
	Fri,  5 Mar 2021 13:53:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF5194B6E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id owlVW45DRu-2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 13:53:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1C314B6FF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:05 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 01E9D650A4;
 Fri,  5 Mar 2021 18:53:05 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lIFZP-00HYFA-8k; Fri, 05 Mar 2021 18:53:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6/8] KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to
 __vgic_v3_get_gic_config()
Date: Fri,  5 Mar 2021 18:52:52 +0000
Message-Id: <20210305185254.3730990-7-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com,
 mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com,
 suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Howard Zhang <Howard.Zhang@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
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

As we are about to report a bit more information to the rest of
the kernel, rename __vgic_v3_get_ich_vtr_el2() to the more
explicit __vgic_v3_get_gic_config().

No functional change.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 +++---
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 7 ++++++-
 arch/arm64/kvm/vgic/vgic-v3.c      | 4 +++-
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 22d933e9b59e..9c0e396dd03f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -50,7 +50,7 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	5
 #define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
 #define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_ich_vtr_el2		8
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		8
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		9
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		10
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		11
@@ -192,7 +192,7 @@ extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
-extern u64 __vgic_v3_get_ich_vtr_el2(void);
+extern u64 __vgic_v3_get_gic_config(void);
 extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
 extern void __vgic_v3_init_lrs(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f012f8665ecc..8f129968204e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -67,9 +67,9 @@ static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
 	write_sysreg_el2(tmp, SYS_SCTLR);
 }
 
-static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
+static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
 {
-	cpu_reg(host_ctxt, 1) = __vgic_v3_get_ich_vtr_el2();
+	cpu_reg(host_ctxt, 1) = __vgic_v3_get_gic_config();
 }
 
 static void handle___vgic_v3_read_vmcr(struct kvm_cpu_context *host_ctxt)
@@ -118,7 +118,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_local_vmid),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__kvm_enable_ssbs),
-	HANDLE_FUNC(__vgic_v3_get_ich_vtr_el2),
+	HANDLE_FUNC(__vgic_v3_get_gic_config),
 	HANDLE_FUNC(__vgic_v3_read_vmcr),
 	HANDLE_FUNC(__vgic_v3_write_vmcr),
 	HANDLE_FUNC(__vgic_v3_init_lrs),
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 80406f463c28..005daa0c9dd7 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -405,7 +405,12 @@ void __vgic_v3_init_lrs(void)
 		__gic_v3_set_lr(0, i);
 }
 
-u64 __vgic_v3_get_ich_vtr_el2(void)
+/*
+ * Return the GIC CPU configuration:
+ * - [31:0]  ICH_VTR_EL2
+ * - [63:32] RES0
+ */
+u64 __vgic_v3_get_gic_config(void)
 {
 	return read_gicreg(ICH_VTR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 52915b342351..c3e6c3fd333b 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -574,9 +574,11 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
  */
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-	u32 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_ich_vtr_el2);
+	u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	int ret;
 
+	ich_vtr_el2 = (u32)ich_vtr_el2;
+
 	/*
 	 * The ListRegs field is 5 bits, but there is an architectural
 	 * maximum of 16 list registers. Just ignore bit 4...
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
