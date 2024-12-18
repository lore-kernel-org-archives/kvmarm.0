Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0384F1FECD2
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550899; cv=none; b=TM4/2+8Ew5Ol8pRwqaRw3eDfZNJsaWGBUqz9oH7C79RJhDLnSzAySp4DhgNj4Zt1xbSHGyPldKmWOScgfgfCP0zyf05Gq7kHhQBcSqjrFqT1QzMYmNNWEvt9o0ctCqzQD8u0hNhJvX3H6g67mH9yqHfJifj8t7K7IKdv64iYCVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550899; c=relaxed/simple;
	bh=VHkI+xI3NqI9eZVdmCX7dePYvpUYmj5JDY02voc3Pfk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YxM292XFc9Fzdy1qii79/DTN89Bon+EGapeHeylrjB6DAcgV+JNr3+qIqpa8hxNQtDd6klSZPyG1I5isJJKoB1EGcQq3DofmSJOmJALJWDMoIAYIY6ar6RReEKuwsGH4+ZeAWKULHr1znJLIrTZFjorDSZHraM8HrnWiGOsEzno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zrNhD/Q+; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zrNhD/Q+"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3f4cbbbbcso4589964a12.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550895; x=1735155695; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WyQ2FY+PZ6PTObIJ7L2BgknDpmScKnttO8f3zJ1YOCk=;
        b=zrNhD/Q+5WVekvY1iECxcQMarbr5T5tZR8GHCB64boJfZ2BS1DZGLBsE8MmpaQzUMM
         oSz2ZwZBq8ZXt1iSoZ9QcHSnukLQu9rpAodqLDsD9Cc1CqAOXqZg7C16ECXu6Lkpoe8o
         Kn9SQVbUucrrxTudNRganOL0gPpGIn3jTFihuZPdHFzg8mwzfw4Djx6/NURH5desQRxv
         6GfNQcoBh6NYllRcyqQmdGu8A1q6eOJTc4Ko12Ap3YNuvQZtTccyarXnLKzV3grhCm5S
         imEvWNpzQj53SdNYuuq5P5yYcHdAzX3dSB68Xvhv9rm3KyWtutrDXN4f60WNJYSO4L36
         nW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550895; x=1735155695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WyQ2FY+PZ6PTObIJ7L2BgknDpmScKnttO8f3zJ1YOCk=;
        b=OeMP9E1SYevRAU1pAtZz6qY5WbkqQcgESHE6ZrOO5404KR4AXnuhRkKUxLQ10Soork
         XE1Xf7GJ79fu6fWmm0xkRlqvK0HTAX0qfksgtEXkQsUZZe/eeLBA1FMegyCJKfM1w+0e
         u2I2ESpRZVx9CFlx1UzkDEkK0DsUksaEmeSErWLBMQwPfTluB2TM2Cq3nzZw2Bv5CN7I
         SLcMuDpLq3Z+6jINWI4deTMpShakzaNn1YVxRXtKV6Tvt2aLTNgEN7QAuw465E2yMNrK
         18yIPnfcPPKb+dXrwHu8QKie2i/chE9YiAwSO7HFIxj05kh9ZvOQwP9M0LFIGt5hRqDb
         3NNg==
X-Forwarded-Encrypted: i=1; AJvYcCXgB5AB+dSsSdIps4oD1G+ir1DtyfA66maYvO2SNjqO3SgbzliuSDU8GP4pl8PrZGGw7cGkcTU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/+Eu9cc6Fwc6IVV8b0owJYIYRVX8suEXB86wmW+9aqPmdI//H
	d1r/OlMkPP1QDSOFC3d0Tj38FCCgL+wS4Nw5EqUlj6HSe5b3w3LLSIWtxxHVyqjHZ0Kcl/TjJyr
	GPR2ooA==
X-Google-Smtp-Source: AGHT+IFwRaet79zZrR2QrxOid1hTv5/CbYmoBwkgLrd14LNjLEatI9Bw+MwfUFU8CYpCEQ+YTYRLzjjywJcU
X-Received: from edbev26.prod.google.com ([2002:a05:6402:541a:b0:5d1:26ae:9f05])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:40c9:b0:5d0:bcdd:ffa8
 with SMTP id 4fb4d7f45d1cf-5d7ee3772bdmr3504055a12.1.1734550895452; Wed, 18
 Dec 2024 11:41:35 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:56 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-16-qperret@google.com>
Subject: [PATCH v4 15/18] KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Plumb the kvm_pgtable_stage2_mkyoung() callback into pKVM for
non-protected guests. It will be called later from the fault handling
path.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 19 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 20 +++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4f97155d6323..a3b07db2776c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,6 +70,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 74bd6c72fff2..978f38c386ee 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -45,6 +45,7 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
 int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
+int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 616e172a9c48..32c4627b5b5b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -324,6 +324,24 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	cpu_reg(host_ctxt, 1) = ret;
 }
 
+static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, gfn, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		goto out;
+
+	ret = __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -538,6 +556,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
+	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 0e42c3baaf4b..eae03509d371 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1549,3 +1549,23 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *
 
 	return ret;
 }
+
+int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_shared_guest(vm, &phys, ipa);
+	if (!ret)
+		kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.1.613.gc27f4b7a9f-goog

