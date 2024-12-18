Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A511FE45A
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550894; cv=none; b=pjhZzTo6vLwuk7GRWPXyVIhXMeYr/3wqxtMh4S2Oladgdtwgm3YbPeIIVd/IHYy7b6Qi8AMDBIQwlpWkVoz4gWvqZHz7ZxN9+EITQpcnBdVBmBITo4L4WY0oVOrjLKRBeZWtqdeu5DOV7YxLasCQuwNpUZwUt//tCDhfgJbo1/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550894; c=relaxed/simple;
	bh=UkdLM8hoJ6w+8YFWeumdtyRPMzl/t7iCJss3ecsy7+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i6ly/ORypKGiXbXps1sR3BTu98rAF0sENXTlhjSd1MUteyc1NsDxHRvbwtKNJ3XTcjsZ5if/WEXiY4Gx3lVHsw1eyDlyU5Z37eao/tXGyNhWjzBgYfhe6BpQ4gQ6lZSWzH4HJ3OqjK9LUiD8piQDoePT0UudGprdzkR5v3XH30s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gT7lsZNd; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gT7lsZNd"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa622312962so703449666b.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550891; x=1735155691; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sMqHHJAbkvVqmc+ZvuoP/w2AMJ0PvS+huStDXnV02UA=;
        b=gT7lsZNdlnJnxeEcfciyBhF/YvMWmdmBtycGh7kwxk6ueMvR9EXvVTQ4a6M1uqShFQ
         tPLAMolyKdCvyULAabFzHeq7cl5s0Af15lTTVagjcOnOqZ7vuLR2O5mXy5ksgMlcvbXM
         2PxnSMyXfSmu+SpDLF4XLwHwvmyhc6/VRiJnjsJl4cdy+QetXUf9CHb/Ss/7W0pRkWxK
         RSWbHYLB+431wytPmONmXRtmUpZqooZTlol/7yjI6F1E/vYYgrCAmkiRno7JoLvvar/3
         fdirBcGaPXgVGAArXabvmLWLjarGDfme+2dTE++YMaQhTfLnHK68pGNL7shO1UE+UUph
         TmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550891; x=1735155691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sMqHHJAbkvVqmc+ZvuoP/w2AMJ0PvS+huStDXnV02UA=;
        b=nUr54ZEi1ccFsf96pTgYwCVNgxOJt92MfE1hZFnDXGTTl0hrkDdt8yIdj9zlp14yIp
         B1CQkMSwSe2pm1WwJF8SqZqFaEw7csck5oiSxwkYT3jA0pBWY8epBfFymMfh+gGPs7gl
         SI6wjrXrP9UFWYElV4OWj7HykJcjaOvJWAcdwCn5LAIq6trNQYl8XPMhrUMoRi1sXmYs
         KAbnZy4klsvJ1JX/tIX1AiX9rdHSRu34pVwUCeUAImlACdwuhuf9FJCXjGtLe5SGlK7R
         L7n+4+f/89Rhhzidj48ec5wBTgksj/cbxEsLt08eTURPte1hEhnrA7qM27RtF0WMMv7E
         uhvg==
X-Forwarded-Encrypted: i=1; AJvYcCUWoDdqQeOIqTW+LaNVBFjS1XqTKnyJWWLQ7BCDB9SOh+ZGfoHKAv1oUcAcrpuvRDHvKxjhZXU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx68fo+MbgsGCIxX3yUJBiaFke1/MYlSancQAWvLwwjUEU4kcj6
	nDtHVlmOjI21zyWn5ZDi8iHsHVCsKICJxVpowKOv43WmTJSwq7pFmSPDpwHaGuxxK4kkx5IoE26
	nyrLZbg==
X-Google-Smtp-Source: AGHT+IHbX6RfegUQG4Dmsb1kyEyr86HPklOi6/oJALVsWc4EPf0tNeL14jIjXsZpNMuUN7pNAqXTgRwlD+AP
X-Received: from ejdcw14.prod.google.com ([2002:a17:907:160e:b0:aa6:a21b:2ad])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:6a20:b0:aab:8a24:d5a5
 with SMTP id a640c23a62f3a-aabf47a746dmr378800466b.30.1734550890875; Wed, 18
 Dec 2024 11:41:30 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:54 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-14-qperret@google.com>
Subject: [PATCH v4 13/18] KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a new hypercall to remove the write permission from a
non-protected guest stage-2 mapping. This will be used for e.g. enabling
dirty logging.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 21 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 +++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 66ee8542dcc9..8663a588cf34 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -68,6 +68,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 181aec2d5bc1..0bbfb0e1734c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -43,6 +43,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
+int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 287e4ee93ef2..98d317735107 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -283,6 +283,26 @@ static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ct
 	cpu_reg(host_ctxt, 1) = ret;
 }
 
+static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	struct pkvm_hyp_vm *hyp_vm;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	hyp_vm = get_np_pkvm_hyp_vm(handle);
+	if (!hyp_vm)
+		goto out;
+
+	ret = __pkvm_host_wrprotect_guest(gfn, hyp_vm);
+	put_pkvm_hyp_vm(hyp_vm);
+out:
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -495,6 +515,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
+	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index aa8e0408aebb..94e4251b5077 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1511,3 +1511,22 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 
 	return ret;
 }
+
+int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+{
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_shared_guest(vm, &phys, ipa);
+	if (!ret)
+		ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, PAGE_SIZE);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.1.613.gc27f4b7a9f-goog

