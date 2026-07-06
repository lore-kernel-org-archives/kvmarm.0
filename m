Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09333BF673
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360477; cv=none; b=B08des633fAQraVLi20sy4yz4fQD8tfT2xLTINtcqch2oTLG4GlF7vJhSJcPdaYXM6TZdHUQvK8pDbD69EKkP13ChQeVahbPVobfbFbrexPCXrdzmW8MWO/+/1kjuGtb9T4A6ilojHwe0+DPi8HScmx+N2mh4o7S1dfIzttDqM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360477; c=relaxed/simple;
	bh=ltjw/zBfy/Q2HaCy5Hyz/FBotjetzh2uXLTndJfujC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=klLIJ65T+yf2/iMjYSVxcjNcBCPI/1Cgd6tbzPyCFgNPZugvy64h+okKs9Y7zrDfif/3seLf6ivFM12GlLOd4je71pK3qmSgUjrKiMz9U3uEMCQ1vmPsfMF+qWa46kf5eh5S5wuTpYskMor1ua1PL5hDM6/zEHnqEiV87Fv0sVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QwAdjqs5; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QwAdjqs5"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493bd1716b4so21652615e9.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360472; x=1783965272; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZzdJHXVuXMAee7pvhjvjmYNerb4Ls3nAVJtLDckvOmI=;
        b=QwAdjqs52KIVfnSvp1kDx/9C4FxQftn4g5zL5DZwt4LGqbycc53frQUktowcPtqCFA
         jVya4XVrUxM/F+OEWLI4LSJCpJ8BVUFAAfm8q4oM8vxg7Gh+CdkxhFp3cSwMNpn3hoU9
         dWBvOVltgnEwfhKe3PoRY8SkfwNEfes5EoqyYXGsZnaucoHbaxb9axFyP2vm9j56HGeX
         mrIRJSD2Wz+kRUeCmIknKdooeGuVUBFVRV3+teWkcrSGbQAh4CwPi81jiay6guykxQ5T
         ShMwqx3NDf2HuU6P/GkSiaFYlfI8+ulaTWLyLxDJN0BHqTNGL3EvlmZ87bw8vI19Od9R
         VnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360472; x=1783965272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZzdJHXVuXMAee7pvhjvjmYNerb4Ls3nAVJtLDckvOmI=;
        b=RoaNjlRxEwPAaKHl3+drQjisJO/fC4U877kxJq5pJe2GutqrKJSD+A5OgJfOWgDyRe
         8/rSuODJrcvKMQUIYeq2pEz7rIMQ+dzCpKZCYn9M4Fum25GaT9J+x23JDna11ZAuny8q
         nyufgfKVQUexcJN9SSUYmXr7/X1qLEknAcLs12MOYbGOprR02tu59saejgFDhyjmcB9f
         iitZxxVj5kJ1aq01JyTDfgsXWMaW/kqsHU2NL2lQtyMqXU+d5v4uz3+ZMEFfc/u8xBm+
         ea9X05HQrj/dDfdP9Mw8KjB1mtLrVRl5M/tKeCqKOoQWfBZvve6HzzsVFdhgTDPC1GF5
         8qPQ==
X-Forwarded-Encrypted: i=1; AHgh+RrbGgdiYTOgJ50EhjJOG//JHMHsC9aS/fsgogxbcE1Xb/xM67zWNOMQz/t2E63Dn9qTC12oaN0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTJqFCzM31MhdjAEemVdb/KdhJco5S6inpBWlYkXRcayRgMUsK
	ep8XxZxqs94f9ig/lRZcnOqhTxgERCaIgFkCfmM0zIMLxv92bIRXf7hM1AJf0OvAns7KOoh4FJU
	fN8lVozuZW/HWdNGEIZp+cQ==
X-Received: from wmog11.prod.google.com ([2002:a05:600c:310b:b0:490:b2e5:e62d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19c6:b0:493:b03c:5650 with SMTP id 5b1f17b1804b1-493df06d8cdmr18356455e9.19.1783360471797;
 Mon, 06 Jul 2026 10:54:31 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:06 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-10-vdonnefort@google.com>
Subject: [PATCH v2 09/18] KVM: arm64: Add reclaim interface for the pKVM heap alloc
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a host interface to reclaim donated memory from the pKVM heap
allocator back to the host.

It specifically provides two helpers that will make it easier to
create a shrinker for pKVM:

  pkvm_hyp_reclaimable()
  pkvm_hyp_relaim()

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 681b7bf8ac08..b427ef790b15 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -115,6 +115,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 99daa985856f..3a8590d1793e 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -21,6 +21,9 @@ enum pkvm_topup_id {
 	PKVM_TOPUP_HYP_ALLOC,
 };
 
+unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target);
+unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id);
+
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e270a974fa37..8fbebe64a93d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -657,6 +657,42 @@ static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
 }
 
+static void handle___pkvm_hyp_reclaim(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
+	DECLARE_REG(unsigned long, target, host_ctxt, 2);
+	struct kvm_hyp_memcache host_mc = {};
+	int ret = 0;
+
+	switch (id) {
+	case PKVM_TOPUP_HYP_ALLOC:
+		hyp_alloc_reclaim(&host_mc, target);
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
+static void handle___pkvm_hyp_reclaimable(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
+	unsigned long reclaimable = 0;
+
+	switch (id) {
+	case PKVM_TOPUP_HYP_ALLOC:
+		reclaimable = hyp_alloc_reclaimable();
+		break;
+	default:
+		reclaimable = 0;
+	}
+
+	cpu_reg(host_ctxt, 1) = reclaimable;
+}
+
 static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
@@ -788,6 +824,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 	HANDLE_FUNC(__pkvm_hyp_topup),
+	HANDLE_FUNC(__pkvm_hyp_reclaim),
+	HANDLE_FUNC(__pkvm_hyp_reclaimable),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index adc418076cb0..eb4c60a0db5a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -115,6 +115,28 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
 	return ret;
 }
 
+unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
+{
+	struct kvm_hyp_memcache mc;
+	struct arm_smccc_res res;
+	unsigned long reclaimed;
+
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__pkvm_hyp_reclaim), id, target, &res);
+	if (WARN_ON_ONCE(res.a0 != SMCCC_RET_SUCCESS) || WARN_ON_ONCE(res.a1))
+		return 0;
+
+	init_hyp_memcache(&mc);
+	mc.head = res.a2;
+	mc.nr_pages = reclaimed = res.a3;
+	free_hyp_memcache(&mc);
+
+	return reclaimed;
+}
+
+unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
+{
+	return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
+}
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

