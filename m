Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C81FF1C2
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550900; cv=none; b=ZLCz2VDW7u1fUu8V7t2nvCTwvT+J4EVhwRYms4TqqYlLd0C5WX0/kibx4RRMhZi+8KbLPTjeWu/uHDS11tsaJHun9hItrHmP49/1GVjkVnD3cfEGhobKezJCF6yda4CRex17yW0gA3xbbDZb/2L/lWlkE8BiKcJPgqIVvpkvDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550900; c=relaxed/simple;
	bh=2tobAH5K5EZR3mMhXSKXYYFzfChriI1rgilcYZ+TGx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nd/2EkBPcyCec7vXHczBIhltk5zOzU1cY4DFcH3yKUhjObzjbbdQVNeVhG/POohyrLdFZxJ/aHunqEKB3Sck9fnuws03oz0uf/tvtEP+zBhp9OD7llTFRAxGI4KKzcostbQLpt8U+TdKGspw+THEBffzYX1QO0vzM2q8mOj/qSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G7GD98zj; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G7GD98zj"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa698b61931so222058366b.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550897; x=1735155697; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkfvAMeAqasaarDCC25uz9tXymaAjZWepO/HImSI4Yg=;
        b=G7GD98zjxxMbNVCE7hjwZoOighws3M1l8yihafC23cWwdb8bjhRT7rt9ie4j3+UcPa
         Rbfpd0LH0xb5vqmiAPqhl8wRTh2ja/HBXMvuEhsy0VdTDFWAyOhJvDYm9JvlFcpZ2KO4
         CHpKA2cz1cg35mAiO7EvTj/V7l1lhFlqrJu7w+BGdyHtgxrs3pxK2HiW5n5TfXItY784
         rnVpNw0LdoQfbmzcq9NJ2nF1E86O37HhzyY7VmZb96z9jfEclhOLNyWotLk3PK+qwZtB
         waP0P7ortf9HBca3MiZkPzKbJcF0/L8fa5rWyr48Iqw7NuoRG8wERFjan8dcFIZW3zxH
         mZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550897; x=1735155697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkfvAMeAqasaarDCC25uz9tXymaAjZWepO/HImSI4Yg=;
        b=LsI1HdPN+tmaDVe5s87fxH3BJ+Ouvd09mycdvkCWJzZwJOwx1B9XX1VW1bx/hmPwl+
         vYvVIUaERYBb6+aIkiNkUZWsDb1TL5g6Mpgx0lWqQsEBlFyANv9yqwhAUuwDQxkw4Bvq
         dchTdgOYlVQBoZn6d9SuBms6LgZFszQdgB9wLCPCqxRR/rdzyuHTsQk7EJOVYFkbc6js
         YiiwqX39GkjrcBPXIdtFRSL3FdAShKW/oW7kOgG6RD0tP0EaHixfZg4UKKf+5EUsxHoL
         d4be2Lp7LT+4R2w52SXzDvFjw+7VfJOjZo/QZMYO6PXCdAdsWTGxbkH99Uf7JHRubfSJ
         c1kw==
X-Forwarded-Encrypted: i=1; AJvYcCWTLVQhdxbTX3nnodt2eeR4cCXMNvZofwk7M1L2lPljv+1HxkJrOfYhJHfmUlL/cxBnPEAJecU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyT5+DNryZpssVgUkSRxz5EDuQpT2ywu6xSctfQMo1SiyIyjgKz
	KFvkisXBviI1T/GDUueWcm/EbaMaSj/dIMfIkzqI2LTKO0N1+hiPB/tfSJdTnzWe8nrPUjCNZH/
	qvwmRBg==
X-Google-Smtp-Source: AGHT+IGSBECViplx1U+nRtyXTDKvrUbyI+0W4ITB//TrX14agtn1suD5UatvN7l8zoDc+3G2GrjvLEAvKgAZ
X-Received: from edb22.prod.google.com ([2002:a05:6402:2396:b0:5d7:f279:523e])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2550:b0:5d2:7270:611f
 with SMTP id 4fb4d7f45d1cf-5d7ee3ff1famr4439977a12.22.1734550897647; Wed, 18
 Dec 2024 11:41:37 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:57 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-17-qperret@google.com>
Subject: [PATCH v4 16/18] KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
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

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a3b07db2776c..002088c6e297 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
+	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 32c4627b5b5b..130f5f23bcb5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -389,6 +389,22 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
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
+	hyp_vm = get_np_pkvm_hyp_vm(handle);
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
@@ -573,6 +589,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
+	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
-- 
2.47.1.613.gc27f4b7a9f-goog

