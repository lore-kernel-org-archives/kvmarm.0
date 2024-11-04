Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414FA1C07EF
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727167; cv=none; b=RM+mv08Ed/q+bAj+UzI9R52zwszajuCKPRuJIEroQx9/p1t8zwK1O9to64E3EWuiwvz0fLD/r9C642dZYM7iAARok4NDBB+hUgN7hREeylSJRmAjtyCybWzJX39dpRedo1qZU+icOiIkYb29yAHKdtwqTCD4xWgyld7TEwvNx7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727167; c=relaxed/simple;
	bh=YF61Zz8W/fAcQVVljHeekQ+P84vuNKPylXeZYVhXxSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YyvnMkqNsW+UjlwxPasuXXEOR5vhWYrtQHbEQgDNd2qMtRPOmak8H3xpurYZGYcQoHkpmakJ2vI16LeUmCqdoudYLhvehLWiJ38j3gX0tUCCCsh6n9SrsJPP0puxh6l+e9x0+rRCexX3bVOWL4UgBKEIbL8snc7iygeNDFzuBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pRur53+V; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pRur53+V"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea33aad097so60949307b3.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727164; x=1731331964; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0O9w3V8+9zARf3Lj4YZXmAy+l2Op+F1G9lpGS1sACo4=;
        b=pRur53+V+/iCDBrNx5NLynYnB2v/GWCuBr2+YmyYHw1krkJ/+LLdTAWNROGIqtCkDb
         /b0OGE1ubxnjerng3JdaSCK9rmmTlCBPSg8OkFNEsC/ieNZP9+u7nIZNe9iUd1bWPwSx
         Yz6tbYXcw5Kn7aO21T/jTYsk+6F0enLvQ6zulAIXjgcl0NISSucwVTHqAxD45GB98QJ0
         oWDVR1qMTOR/47KTlPnEsVLMIyt5CWYgfFa1hu51wYc6+GzuLKKnjEw+J6ONmpuU54Zu
         AZJnSCfMb+XzhcupztW3a5HgIzkqZ21U/Sa4KWs5GaDQeEMC5VuXCGkTrihugbR9I36z
         EU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727164; x=1731331964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0O9w3V8+9zARf3Lj4YZXmAy+l2Op+F1G9lpGS1sACo4=;
        b=XsK20OBC/LeBFSYo2+MJowSOxa5HBVvgw8JG7RFEA5eRvHk5O0cpwe3lAXI5z2gTwg
         7jWKi3m1pu9C5klsYjEZHZiUzCkf1dHiMmkQhciK8p7X8clRFEWWjS12/jHGMxhE5du6
         bKoaQ/o3aoMLnsWdY9SkzRjg9VqQAR1+g8hlx/CeXvoIGX8/kNr9CJ8qy37QlvFlb8/M
         wllGDdSO7eDeAFCm9B5b214R8y01Pg/6n2MJbJM0I0uOv5xuCuHrd/YSPpKAXSBG17hw
         8F4VaNZz/OH6xgUDF2mGCTMuonAc+iUtYcWS6H30XJ5FX3JhUFqu6Q3t3UwnP8TZQR0A
         RJBg==
X-Forwarded-Encrypted: i=1; AJvYcCUNbI+IWQeRYDCPyR+53dUez7BJzTGctxPOOhiBRX5kMioXWKCwoaCwaIxD4aUXy6ZWqN0GJfQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqAsuHIle0RDP6ETaQ0yzv2lvH2+c5q+5QzVHj7pLGgbGTy6ze
	64WUv5sI07dLYep6rACGncegPtFtlxd6irHpGnrehB0c3VdL1WS5AMDnWj49g9SrD5mL29iu1zv
	nKXHOQQ==
X-Google-Smtp-Source: AGHT+IEDxrAcP3xldoLSP2+yxUBuV6Ttuyw9HdeltMFShnVNq/HJr7ENXf3J/L5hnJ5D4xci+Np8Djaz59df
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a5b:24f:0:b0:e0b:f6aa:8088 with SMTP id
 3f1490d57ef6-e30e8d353edmr30619276.1.1730727164243; Mon, 04 Nov 2024 05:32:44
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:32:01 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-16-qperret@google.com>
Subject: [PATCH 15/18] KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 19 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 24 +++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index acb36762e15f..4b93fb3a9a96 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,6 +70,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 554ce31882e6..6ec64f1fee3e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -44,6 +44,7 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
+kvm_pte_t __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 21c8a5e74d14..904f6b1edced 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -331,6 +331,24 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	cpu_reg(host_ctxt, 1) = ret;
 }
 
+static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, gfn, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	kvm_pte_t ret = 0;
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
@@ -552,6 +570,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_relax_guest_perms),
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
+	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7c2aca459deb..a6a47383135b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1558,3 +1558,27 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *
 
 	return ret;
 }
+
+kvm_pte_t __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	kvm_pte_t pte = 0;
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_unshare_guest(vm, &phys, ipa);
+	if (ret)
+		goto unlock;
+
+	pte = kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return pte;
+
+}
-- 
2.47.0.163.g1226f6d8fa-goog

