Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB2BC433E6
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 17:12:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDB3323A1E
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 17:12:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDB3323A1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E59A4B377;
	Fri,  8 Jan 2021 12:12:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0LkibXB4zC5X; Fri,  8 Jan 2021 12:12:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EA024B450;
	Fri,  8 Jan 2021 12:12:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D67044B28C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 12:12:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LCyVHzvQ0wmQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 12:12:28 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B967E4B398
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 12:12:28 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E38B523A01;
 Fri,  8 Jan 2021 17:12:27 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxvJK-0067u8-6p; Fri, 08 Jan 2021 17:12:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to
 __vgic_v3_get_gic_config()
Date: Fri,  8 Jan 2021 17:12:15 +0000
Message-Id: <20210108171216.2310188-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108171216.2310188-1-maz@kernel.org>
References: <20210108171216.2310188-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, shameerali.kolothum.thodi@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 ardb@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 +++---
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 7 ++++++-
 arch/arm64/kvm/vgic/vgic-v3.c      | 4 +++-
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 8a33d83ea843..37b9cd3e458e 100644
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
index bde658d51404..3dc7f0c4fa94 100644
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
@@ -118,7 +118,7 @@ static const hcall_t *host_hcall[] = {
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
index 9cdf39a94a63..8e7bf3151057 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -583,9 +583,11 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
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
