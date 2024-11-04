Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F2F1C1AB4
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727169; cv=none; b=nNPLYUUvPQZdsr+CsmAPfSc/JVO+gz0t17F4NJZ2DveXDMHBa0O0fhfrMnhRbmLonII2EGEgzaOVvPZ0WFXnVH+xfnwVtbdxd/mhS944BqQuiTpqTqz+QmLrP7QDR1gJ/5zC3WIVnOtOp6qHGdxlbHdbQELXPrXh71GpC70LnTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727169; c=relaxed/simple;
	bh=ku4yYhSRmdVla3VIfq3sTP3ec1Je+nU+DhLa+IVQGS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LiRhEgZ/dBQvFdTW5dthzg6gXabzKrVXlP9H3A0kGtHZnF0ob7zV1mQE71SAujtVBU2k+Yj6wolRCNPENBqKxY3xwcmAtsMz61+S0d/nzDW9I5SpSgNUgeIpiUku260Yqanyc5Ylyzqb4A1Jih5dqqpDUjetjGdCp2TvR6cEdqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kGOfLQ1d; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kGOfLQ1d"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a9a2ae49a32so344705266b.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727166; x=1731331966; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA9nOaF/CPva03eUOIXNUH1DNhxgj/qlCLjHWmvoHj8=;
        b=kGOfLQ1duyHPTPosIJa2gkHhMaS7AzSHD/YpforeijvmMM8vGdQ1rMv9MmZqIgvreT
         pnqB+73RVWuG5tiIr6KSpKh07pkyiO2HsInQClMa8cJmulq9CscxVfcKO/m//0naBEEz
         gKowGD3NDL9r8L1R3d6nhH/S2BzHs92cSGm5E4Vr/JYy1kDkd0yhxBk64v/6mHMq+i/Q
         LHk3XVSM2I+5koWy/dIPunFQ1c89MY0l9HLdyoJF47eWoRrC75iLe1wu4Nx8GMS+ae8B
         +v8bcHrmSjk3zyc60inKVk/L3SqvSn/Pee62/BVpUsyU05n+7Bl/uwQMj91EiXQ0DsdQ
         O3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727166; x=1731331966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA9nOaF/CPva03eUOIXNUH1DNhxgj/qlCLjHWmvoHj8=;
        b=ieZoHB135MSjda3+c+OlK06hKFNlxdmrl498RhT/SIqjFiN5jWQwzCs4a2UTAa0QH5
         rjCI7Rq2aJb5gxSzhFH2QLjfOIgFkphB51W0qNi3DYd3R61WuEUPol+CCtawujpTYFrW
         2pKXmsOeyl67yn/3RDTW4erVNH75dCiqLIv+nrIseTQkSPgQVrBftZ21UDA9pZG8zR4i
         w1XkavbxEJZvcqtcaopd/+VdqAWME4Kd3HyPyzyziV2T5JuEYNBRQHpoDrozv7yFXwCh
         52I5M4BpmvjPDb1JTMclgJwXPucWokpualjD4QwN8kqwKN58L5DkKjj7vODTpDor6Yj1
         ZcmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyOBWSB5CUe2DCS1r/wG2eQ1fPdd1UuCy0GZP6+gQB7q56aAndAt410oU4PVPbX8inEx3M4Rg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzC1cyQTbyFoKMwAw959SSRQAJcm5vvNR2pL/GvgczQQrpyOmFQ
	hW9hukTwNDFGa4D6px6bEDqsfJ45zublOtBVsT2DgxzOdPC8bKoL+RIdrfoa2RYh8527zBg8sja
	16tIeyQ==
X-Google-Smtp-Source: AGHT+IHKDJEbkEfKj/R2W9nSJpi/mLwlZYh9Ih88dIXHNCkRftaPK88SGfUQc4OzczUSSCQEg5KywaFPE6uv
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:c20a:b0:a99:fa8a:9772 with SMTP id
 a640c23a62f3a-a9e50868dd1mr396366b.2.1730727166509; Mon, 04 Nov 2024 05:32:46
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:32:02 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-17-qperret@google.com>
Subject: [PATCH 16/18] KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a new hypercall to flush the TLBs of non-protected guests. The
host kernel will be responsible for issuing this hypercall after changing
stage-2 permissions using the __pkvm_host_relax_guest_perms() or
__pkvm_host_wrprotect_guest() paths. This is left under the host's
responsibility for performance reasons.

Note however that the TLB maintenance for all *unmap* operations still
remains entirely under the hypervisor's responsibility for security
reasons -- an unmapped page may be donated to another entity, so a stale
TLB entry could be used to leak private data.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4b93fb3a9a96..1bf7bc51f50f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -88,6 +88,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
+	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 904f6b1edced..1d8baa14ff1c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -396,6 +396,22 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
+static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	struct pkvm_hyp_vm *hyp_vm;
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	hyp_vm = get_pkvm_hyp_vm(handle);
+	if (!hyp_vm)
+		return;
+
+	__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
+	put_pkvm_hyp_vm(hyp_vm);
+}
+
 static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -588,6 +604,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
+	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
-- 
2.47.0.163.g1226f6d8fa-goog

