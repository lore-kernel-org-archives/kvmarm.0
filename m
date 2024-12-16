Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BDB20E339
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371920; cv=none; b=Euqz1UHIoNmJT08aFp5AdHVtLn6zHvQwocX4qV9TqELt78oDXdBLCsNdFonUn09GViiHRz7hQA5dRHKRZ8ceXAiZoJAjGCQsHaPLxsHW/u5bxW/enWzjpWfhnVg9A4PbOEdZJsdzDQTIQXj52a01NgInNKIZijPIv2F39Z5Riy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371920; c=relaxed/simple;
	bh=QvqoA8z+hgn6vgBY6ti5ESeXdlRlORzN/4hSA1c2Xrs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bYcnAFvLZd95bijUBede72mnnz2gCtVtdECYL2Ur0Jcv/bv1snfnTHnJ4cWupobCdq9q8Z1NrpDFNIUeXzLks24aSxCAjnnm2M228oI90TeNJynvojKBhNI3etqEp4zf98b6qLaESg9krPZRCkGoYwL0EBDBSANChC8uGkU6l4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=23a0rzbZ; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="23a0rzbZ"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa683e90dd3so159673266b.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371917; x=1734976717; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YOHiNJrZBpE7+WMk67gEyR4d7/2QuIAsHv8fTvzpm8=;
        b=23a0rzbZ/jM9KNP8eTqnfDwVoWUUf5z6ewBDR8G/QGOrDZxYDY7pSgIqktuYXIIN9g
         YcK+Md3oTrDSUK+1F61Z0wQyKKTNDWwW1mRHSOr+DEG1xEDLE0w9fopv2ObR5Go9y71a
         G0/dwdHoANLD8VHU8jpjgMCO0t3cnRzoQ0mgDpTPRzDhutszXB8M5w0ojKen/4cRl6oG
         u06+QEUiikVik7hd06M1s+IOaxf4kRMHUKCr36X+9vc+u1mJiuQw+Yo+4WX84ujH7LIg
         2NwU7siGmhMkOmHMM6FIEWflLaDA6fUTCiYVwYcAxQfmULKnYCfNTbtIM2qd1kvKV29Q
         DXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371917; x=1734976717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YOHiNJrZBpE7+WMk67gEyR4d7/2QuIAsHv8fTvzpm8=;
        b=gPpDHs3jvoJd8qMw6uSMPtdfHqD27CfSgr0tZdx6yfP5a7oZcYNFP6tAOGItuC/n3n
         fWj6CIzbuV+5kT5j/HsV+c5gsDqbxHAhqilD/UBZjLw1QcNgLKHJZAc7twMDBkBsGP1s
         DjppNc7bdeAZ+fJ5vnGmf/tQi99Djf24loPxgcCDoE1oEdDQSkAA27z2bH/EURCM/2yZ
         hXyNTkEhTQgusHq+MKr7JEPqcEp7RbiCFMwEw6KfUPAoq5FO6+a9CVSyahJ9rv+FhwjP
         lWF45qb1mwoZfiJzFAct6Zjyxl3fOd5BScxeG88zGGXk4WuPkUV0TukvznQWlLr99MDK
         kUVQ==
X-Forwarded-Encrypted: i=1; AJvYcCViFfL6ntXBhEqYkQvRvyK1wH03M//CBF3VSjTP0OHTV+cEG5PoC8hSbdraGUt2zZUBGa6oFgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvwnbWiWcvwIVo+OUd6/MuD6eqH2fNxOziJfPiyv9T2rTLm9Q4
	FcXPPlIlRLdx7zjRaDY5seM8zK67GcS9PUr6eg99sTIMfgFHkRKdU1NaNjh1KDfPoX8vXRWYqq7
	WiEUHCA==
X-Google-Smtp-Source: AGHT+IGwqENMAGZonee0eKfEqVGzhNKsT5jXcNwjSd/KRUBOe/TazOnE3jhEec1mHF2pcCq0KmtgL72Jbhuo
X-Received: from edyd3.prod.google.com ([2002:a05:6402:783:b0:5d1:f6fd:8acc])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:60d6:b0:aa6:730c:acd
 with SMTP id a640c23a62f3a-aab7792c704mr1428447066b.16.1734371917086; Mon, 16
 Dec 2024 09:58:37 -0800 (PST)
Date: Mon, 16 Dec 2024 17:58:00 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-16-qperret@google.com>
Subject: [PATCH v3 15/18] KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
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
index b3aaad150b3e..65c34753d86c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -44,6 +44,7 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
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

