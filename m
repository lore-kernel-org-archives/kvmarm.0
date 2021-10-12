Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FD9C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E55D61076
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E55D61076
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A404A531;
	Tue, 12 Oct 2021 00:36:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UC-T8L4lPkHI; Tue, 12 Oct 2021 00:36:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48A254B0DD;
	Tue, 12 Oct 2021 00:36:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 204F64A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJxPWOAwWqHM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:28 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9F034B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:28 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 c10-20020a17090ab28a00b0019ce70ee349so10145803pjr.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8dyVGfAnuSsD7UrU7Jpca57tmjUFZ9tgf846YFvtQus=;
 b=MU5wc9JaWIkqs29sBWrh9t/iwC/kaoJ0NbY49k7DmIsTXOhYUOst5jf47tHAdYplYv
 s2V/XLrwYcA4Mv5dh1FdsxjCEYnW40QVgHx4byeiyvEe9Va9sdxhyVFsNSfqqv+PAdlw
 XQrL9Ew8SGxpg/yAa+r13xCPIeizCn8QOrrxFJChjV7PZHwcNOfYUM6AiPmWqJpUDVCy
 zw/gQ9dsLwe/zZyWyXwGE+I5/9pmg61jrGOjK2YUg3jaOC2fueAUgeCLuh94hkD15QJC
 Rk1ataJtSA9zTN84rcsHGwiSQJs5q0AhdLfWIgzKlAsk9FfBiL3xyGJEhSONxSQunrRk
 w9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8dyVGfAnuSsD7UrU7Jpca57tmjUFZ9tgf846YFvtQus=;
 b=QnugLuHmesYsY3AXaBQXrzg5+qyhQ2vw38hUycUBYQFjJmCkanFQfNQgRLYu1SxoR4
 UoJuO15Ce4qWmsZaNjcntlNS594LdcR2/oOwM6k3mrIzW8tCDE7OxxJZm4B6DFOmFEds
 OwCEtaglpd/DYjNgPJUjphqHgVmqBBb7azACsJnhI7FjiBvLVSj41LHOlbFl50XMg54B
 bfgWCMvYUV42XoGDBAYGYcmHQG2ccz9Apl5+jYCxGbvN1+1Jq8XkD+iF3vsLMned5zWs
 B3ksOqVtkZ85Mv3FF1yPrnklDUESFoJQCXtCp0Br/Bdq/uE3D+c/5z+BLoT85PAR5hOg
 4LsA==
X-Gm-Message-State: AOAM531kOnE3UK57OaKap05x+P+BCJrlxMPD3eWtVsNVeSaip83VL7o9
 5qcxGHwXZ9YbRtBa4zK33LVYvXKWTWg=
X-Google-Smtp-Source: ABdhPJytscYTGanXbYPD6/p7iTUsHexrmM0h47PIy7A3vZnUsTqBd51ijOyJtUhF1C1RuP4Fw6JbzZfhKzM=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:aa7:9047:0:b0:44b:e142:8b0d with SMTP id
 n7-20020aa79047000000b0044be1428b0dmr29594344pfo.45.1634013387945; Mon, 11
 Oct 2021 21:36:27 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:16 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-7-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 06/25] KVM: arm64: Make ID_AA64PFR0_EL1 writable
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
userspace.

The CSV2/CSV3 fields of the register were already writable and values
that were written for them affected all vCPUs before. Now they only
affect the vCPU.

Return an error if userspace tries to set SVE field of the register
to a value that conflicts with SVE configuration for the guest (via
KVM_ARM_VCPU_INIT).  SIMD/FP/SVE fields of the requested value are
validated according to Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/arm.c              |  18 -----
 arch/arm64/kvm/sys_regs.c         | 122 +++++++++++++++++-------------
 3 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 69af669308b0..691cb6ee0f5c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -131,9 +131,6 @@ struct kvm_arch {
 	unsigned long *pmu_filter;
 	unsigned int pmuver;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
-
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
 };
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 45ca72a37872..820f35051d77 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -114,22 +114,6 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
-static void set_default_spectre(struct kvm *kvm)
-{
-	/*
-	 * The default is to expose CSV2 == 1 if the HW isn't affected.
-	 * Although this is a per-CPU feature, we make it global because
-	 * asymmetric systems are just a nuisance.
-	 *
-	 * Userspace can override this as long as it doesn't promise
-	 * the impossible.
-	 */
-	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv2 = 1;
-	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv3 = 1;
-}
-
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -155,8 +139,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
-
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2fe3121d50ca..63eb207b387f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -292,6 +292,70 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = id_reg->sys_val;
 }
 
+static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	int fp, simd;
+	bool vcpu_has_sve = vcpu_has_sve(vcpu);
+	bool pfr0_has_sve = id_aa64pfr0_sve(val);
+
+	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
+	if (simd != fp)
+		return -EINVAL;
+
+	/* fp must be supported when sve is supported */
+	if (pfr0_has_sve && (fp < 0))
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_sve ^ pfr0_has_sve)
+		return -EPERM;
+
+	return 0;
+}
+
+static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
+{
+	u64 limit;
+
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	limit = id_reg->sys_val;
+
+	limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_AMU));
+	if (!system_supports_sve())
+		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+
+	/*
+	 * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
+	 * isn't affected.  Userspace can override this as long as it
+	 * doesn't promise the impossible.
+	 */
+	limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
+		   ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
+		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
+
+	id_reg->vcpu_limit_val = limit;
+}
+
+static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+				     struct id_reg_info *idr)
+{
+	return vcpu_has_sve(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE)));
+}
+
+static struct id_reg_info id_aa64pfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR0_EL1,
+	.init = init_id_aa64pfr0_el1_info,
+	.validate = validate_id_aa64pfr0_el1,
+	.get_reset_val = get_reset_id_aa64pfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -300,7 +364,9 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
  * validation, etc.)
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
-static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+};
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *rd, u64 val)
@@ -1136,15 +1202,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
-	case SYS_ID_AA64PFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
-		break;
 	case SYS_ID_AA64PFR1_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 		if (kvm_has_mte(vcpu->kvm)) {
@@ -1261,48 +1318,6 @@ static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
 	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
 }
 
-static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       const struct kvm_one_reg *reg, void __user *uaddr)
-{
-	const u64 id = sys_reg_to_index(rd);
-	u8 csv2, csv3;
-	int err;
-	u64 val;
-
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
-
-	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
-	 */
-	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* Same thing for CSV3 */
-	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd, false);
-	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
-		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
-	if (val)
-		return -EINVAL;
-
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3 ;
-
-	return 0;
-}
-
 /* cpufeature ID register user accessors */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1590,8 +1605,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	ID_SANITISED(ID_AA64PFR0_EL1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
