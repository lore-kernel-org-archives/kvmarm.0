Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744A01E503C
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222295; cv=none; b=eX8xWG2ixJbk7IAKA8do62u4wPg9mkYcKpG3XnJGF6yVVtyxbqUEPFGpyPirlADkD9tRm0GC2G5teqMMI0GWhnGfmfTY+qfap0/8NWcG1X/xAWKcpn1C+L9wcM3YsowRvadH8FKpxpf6aCXPEnkkfOv1xXvSAJSY6aL6tqO6d5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222295; c=relaxed/simple;
	bh=C7bckg4iK+Kx8bfAXOZsZZOVRcvYB+OWUiAnJRxcvxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S+5BuXvIhKleehyZTCIcnIO8kSHb3s78DZKrZfgFn//aGyjXQi9N/tpRFVsk4t/f6zl1wxHXdKSDGhFQZ5vjMnJ9djd6F1UIP5qdoxPPVb7J0T6oVXPvWWtFDL6DcLuJOf0ESwoXkgTbtZmPI+F3mcK50m7/WZZpmuG+opK6nts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LdXbhtWN; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LdXbhtWN"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa525192412so354090466b.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222292; x=1733827092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eYizfs5ugNIRCne9WipVM8NnIjcJOlVcRn/zTXEmfg0=;
        b=LdXbhtWNatzrXfF6ADepTvFE5en04ROIkpKlWgOChKWx+6t7u+CR1lHjtZkeqAxTur
         AQL2o5gCxJR8ebBKuSrvCcWj+V8Tvhr2kvQXY3mOwHc1Pbaqw5PnbwcrebHiJc+Pkc01
         IL33pzmPnXIofaDPEIhoRdm1mj/87WwPuui9OW+AU7/m6feQAWSW/FiKIWngfuvXDKWH
         hnJktkbq2pv4+SIoWssjHgZfLkW2nVp/h7pegm2OzLNLYbiEWsVAUnniz6TP37Y7Z3UM
         v6QM91UkoHSZ7kR4EqM+NJVv2Y9qaZ/+dcp178AUKcQ3m2JXc0wfcSmyhubxTpxW2f1B
         2F1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222292; x=1733827092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eYizfs5ugNIRCne9WipVM8NnIjcJOlVcRn/zTXEmfg0=;
        b=vuBOcN2jjNJREiuwfl2zYWugNTwjTsW04LIqHcvmyd8CC4bCmQIsjtxnWcQtvEhGO8
         sJO7nw6ZPtER430E8ZGMwqe5uHr5R7PGn9y14Slfw0shL+gLYBpReR2evMV1mqlB1wDH
         UcQSzrIMq/1+mUnTKmSlpzUwf7yKj0BGdKksEvbXaa5QOE27KPU6jCsJ/luKwTXCeRp7
         avwe8AWtWFV6l/jpk5bfkfWRRrwWHzIsM3veyVOy0XRV8YhhG1VZNKiaTTslrlQQwSLk
         urpa38zL9y1Tz9ckLIfEGwBBzJGp8QBf5fbpQCHDv5qMOUIKS4AcRHwqxlTwEwimuoZ9
         ApJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUX3PRmIifdv/ATxA3ePO4/U5ZxZR2gtBmEYcTK1R6KCh0H63Yk+K2AFJU2vjlUUGHXfRCrZ0k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyuYTDsBBmh/BZrpv4lS7PimYLVf8/CoC1c/qNZ3L8XGF/H5bl
	v3xzgHecOmZZKUHGNYhSdFPnnzHF95guPa/4Q/IWhmcnI4dGFmruzrLg5fRCICOacMO8EXEuiLC
	iop2TSg==
X-Google-Smtp-Source: AGHT+IHy5ejf0OiCrkEdWE2fH7ml0DEW+PK/xc+o7UbY9Xx9O7ZNOT6ubaPhP/xD9o/HpxIVzCb6WRgnDi57
X-Received: from edix21.prod.google.com ([2002:a50:d615:0:b0:5d0:a9a6:5abc])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7703:b0:aa5:1a75:dcd9
 with SMTP id a640c23a62f3a-aa5f7f1ad71mr161678366b.48.1733222291421; Tue, 03
 Dec 2024 02:38:11 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:33 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-17-qperret@google.com>
Subject: [PATCH v2 16/18] KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
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
index 6178e12a0dbc..df6237d0459c 100644
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
index de0012a75827..219d7fb850ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -398,6 +398,22 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
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
@@ -582,6 +598,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
+	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
-- 
2.47.0.338.g60cca15819-goog

