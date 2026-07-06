Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DF43F88AA
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360472; cv=none; b=mD4pqVIFNFvug41DdFpbrcygQkVfpK8oiixkXayjZG3GXJceJj5UjQkJU8nKdd4WcxpxZ5kmaUqcm2PlgBUkEeSNZaYF2JxhSxPdJmYr2BJm46WTQ4mdpOzmMS0ZlBnfER1Lqm/Y40aIvpoCtBD9lACC0uaLfXzF4TcxK3CnEcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360472; c=relaxed/simple;
	bh=2vWBbDGwcG+rDezv69RGdmCTZnJAFQ1jcVxj9/rJKqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N1HyWTH0pJGF+q6Kj1M4n/rfFlE5LHjzDDitas2okxVmb3a/jqBNKpCatxVK4gLH6eBOmNtnJn9/X0/i1qX+hXgojhP7EQqv3o4rMSK/HvOT++nrBp3mTkBQrK+bSRQ836h3gGJLv/1Fy1cni7pfRTAYNv3ZKvbv2ZFhYLqUTK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vsBX6eUA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vsBX6eUA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493dc8408fdso7395725e9.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360468; x=1783965268; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1cEKllUDRF88QZantA4oZWA6R1GfNmcP8NTDHKSoM1g=;
        b=vsBX6eUAcGH7azBmZwN+bG6rRDymnm2S3C+2h+vtQ4yqTYvVt3rANIrjd1jt7XUuKG
         lKzkvaQNe3rXX/8TuPE8nAFicrpVTtlk+h9H/WGEnUrv4ExZ+WqQWyMBDQXZMUpJCLfx
         4I+sen99gxJTKQ1fNHwmpZFgA3+EE6bJx4MZRGdqxzFhz1vd8SAoOqjC0VMTkQ1F1Xlb
         Y96/BBHuQEW0INJatrcE7oKyPW64uayIv7O8BLLwrofNATpfhzx68+Py0R38K1Qef15v
         0TfpFb6FRAJW9onpXm1Z/xpVov2qlJhzzgL25wmNomxR8ecUVUqoDu9tyd4L8PT7/hoF
         kMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360468; x=1783965268;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1cEKllUDRF88QZantA4oZWA6R1GfNmcP8NTDHKSoM1g=;
        b=dnXX5ZMexMmdKj7hA1HU5bB8QsEKwSO+bRrJxuvJ90gFExXK4DcWmv2OsEmdxw6Ihl
         Rfy34g4QszvQwk/JELu5RO44Y5XhZ7uEuT4ACZzaOhX4z9tNcIxikYdtHhO4t2AqTjfg
         iPs66ml4jMSMJbzukj/4aFxMbfysdO/l79tXqyDsyso0ER3ImYXdLcZwwcN+AN81UBHa
         pWCbiGgr0nZwZrN86WZHEiQaAr0NtQpDbtNfPkhj89lswP4IZjxBfvfe58it5kSG2pk1
         VbNUR7vbZoRi5qwB11ySNHoc+clSMUcNjSwm0YdeZFHleroNWxskfvfmveOpd5ob87NN
         h/zg==
X-Forwarded-Encrypted: i=1; AHgh+Rp3aZCv1Lyqr7FWDJwMykJKS83UU+uH+iOTGHuLitkM5qtdusUNvQSiIn44KzFG1U639VlUiSE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNeTBJ/fHOFbIS+HH7bJD5E1rQc7Ynzb6QlZJ86x9z2AnL6ww9
	oAs7waQAQT+ro2CQhQEf/BCrCwiKtFLeDplJhWI6CU+Ox3+//KW3xUjssrvDWRRJWcgMPPPkh6x
	QgCafMO14xUqMqOsPOkWEOw==
X-Received: from wmbg16.prod.google.com ([2002:a05:600c:a410:b0:493:d230:b1f0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6413:10b0:493:cefc:d113 with SMTP id 5b1f17b1804b1-493df0b6a9amr14684925e9.5.1783360468200;
 Mon, 06 Jul 2026 10:54:28 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:03 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-7-vdonnefort@google.com>
Subject: [PATCH v2 06/18] KVM: arm64: Add topup interface for the pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a host HVC interface and a host side helper to allow refilling
the pKVM heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..681b7bf8ac08 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -114,6 +114,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 74fedd9c5ff0..870f7870bb62 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,6 +17,10 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+enum pkvm_topup_id {
+	PKVM_TOPUP_HYP_ALLOC,
+};
+
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3c69de698f4..e270a974fa37 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -15,6 +15,7 @@
 #include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -632,6 +633,30 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
 	cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
 }
 
+static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, head, host_ctxt, 2);
+	DECLARE_REG(unsigned long, nr_pages, host_ctxt, 3);
+	struct kvm_hyp_memcache host_mc = {
+		.head = head,
+		.nr_pages = nr_pages,
+	};
+	int ret;
+
+	switch (id) {
+	case PKVM_TOPUP_HYP_ALLOC:
+		ret = hyp_alloc_topup(&host_mc);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	cpu_reg(host_ctxt, 1) = ret;
+	cpu_reg(host_ctxt, 2) = host_mc.head;
+	cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
+}
+
 static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
@@ -762,6 +787,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__pkvm_hyp_topup),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8324a6a1bc48..e2c8714e8ccc 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -85,6 +85,33 @@ void __init kvm_hyp_reserve(void)
 		 hyp_mem_base);
 }
 
+static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
+{
+	struct kvm_hyp_memcache mc;
+	struct arm_smccc_res res;
+	int ret;
+
+	init_hyp_memcache(&mc);
+	ret = topup_hyp_memcache(&mc, nr_pages);
+	if (ret)
+		goto err;
+
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__pkvm_hyp_topup), id, mc.head,
+			  mc.nr_pages, &res);
+	if (WARN_ON_ONCE(res.a0 != SMCCC_RET_SUCCESS)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = res.a1;
+	mc.head = res.a2;
+	mc.nr_pages = res.a3;
+
+err:
+	free_hyp_memcache(&mc);
+	return ret;
+}
+
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

