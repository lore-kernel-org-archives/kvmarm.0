Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5744471D
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567735; cv=none; b=VoUN2DKvAcnmsgeKCehgnhIwc4m90iAALipkcdQDQJyc/j4n7SVHgIE+BvZ21T3CMCnA52x0hbVm59WUmLWWDzfp5+2qYP3AopuOTyhHU4cRuj5GPo17Qew56KpWs+P6TpsmpAoxk69LK5ygIAV83ToJBuYTEMaeboyqF8Eg/9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567735; c=relaxed/simple;
	bh=jrRio3n2o9F6x5hj91Ymetg8JMXzO0NlutaTPnp5k9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A2/SyR+tt+MsKqG58Ap+TujdHSVtJQIXhhy6Xu0b+Ach1LUXnY4FUFYjKPFy8h+LIj+H49sum/yBKac/Vx2uLpw79B7WbAktH5X/JC0zmISCvPyPln5lMwDfaw3Ob0JfxxcsR6uR0wyom85XJ8rTR5GKRxeJRN2sNyhyXbmQePM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W/sV9aKA; arc=none smtp.client-ip=209.85.221.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W/sV9aKA"
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47485fde05aso6123388f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567728; x=1785172528; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jN40ZfNJMy0FjY6srncII1llPxzne/Kt/F9K6awJPaQ=;
        b=W/sV9aKA3Pz1ufOjN+xoB1anJ/L8JOXGDD5XwRquIC4gYHyRdqtE/dA/qtlyErM8BN
         gmcHmjF5pao9/M6ICIycb+ixjLRsZyJ1W42EFiMperYuKo+jmz0U+myykC5LVABLNUjm
         o4R8FKNvdOgQiuiaR14Nx2Wo+Wc63Z0KBGFAMHHp9cykh8uWeJZwyRZ6nZSGpyVodIXX
         LWoe8KDS4gommViw2ZB7D5MfY9qq00Lx3ijnZhFUgo35ZgaRwhlqT/mO5SXFBhlLnF61
         iReWcp8rXyRAQfNt3Qazj7E8c/71YN5WVREp8WRi22w4sr80ppPzVyFTEIFdYfxVQwhu
         JHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567728; x=1785172528;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jN40ZfNJMy0FjY6srncII1llPxzne/Kt/F9K6awJPaQ=;
        b=gb+ZYhDhknprE806NUYtsNpszELj899Yl08abZRtAJj8XnY1LDmJzN5R/tESQ1MjhJ
         JNN5ATYxSPCiP0ZyBSyICufCulW+GfSh/Ar3VaE6eUpBIop+3qJPaY4WfLZApEZ/nee2
         NacRl8JtkFlqX+dFZ66KWeFLbIs0eBXZZJnLETWHGe6hRYq7BJXgJu/bytQI8nPGIIkh
         51OlOMkWxF7CsPKXrJkIKUFWNUovQiB1X9jVhH8FJzdETr0RRvG6lS7Ssuf8xeYdfXwg
         qf5Fu7tUb/0pkGjMdIvNnGGR7aMJsljgH/YcrUGrBE+U1nL5IweAZtLBwBR2qH8giHdM
         fnyg==
X-Forwarded-Encrypted: i=1; AHgh+Rr5lbKCSLqtfGQvRTzglaKJJ8G6wiTPM93nb/xTdmFrFLHy/dHFWMcUpJcc4q7Ta9+BntiBC0I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6qqnowPFCjNBENrhljf83WdGsd/NEHuCRrQQEWHtunsOXYL8V
	TmV5/1ROJ52g+7q7j4OuJ3Xd/vryd2x7vQZNCW/9ib+g9vf1g+pkCKdh8ftiknGK7Sv/EV+KDAV
	4XyGqDZs/ixyxfGZxguigEA==
X-Received: from wmhf19.prod.google.com ([2002:a7b:cc13:0:b0:493:bb29:af53])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3515:b0:493:be13:98b with SMTP id 5b1f17b1804b1-4954a50c47emr162780435e9.23.1784567728133;
 Mon, 20 Jul 2026 10:15:28 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:04 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-9-vdonnefort@google.com>
Subject: [PATCH v3 08/17] KVM: arm64: Add reclaim interface for the pKVM heap alloc
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Introduce a host interface to reclaim donated memory from the pKVM heap
allocator back to the host.

It specifically provides two helpers that will make it easier to
create a shrinker for pKVM:

  pkvm_hyp_reclaimable()
  pkvm_hyp_relaim()

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b77acfd7d1c8..0c3126179704 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -90,6 +90,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 439b91fc8aec..346365e76ef2 100644
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
@@ -766,6 +802,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
 	HANDLE_FUNC(__pkvm_hyp_topup),
+	HANDLE_FUNC(__pkvm_hyp_reclaim),
+	HANDLE_FUNC(__pkvm_hyp_reclaimable),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d26e7435d34d..a82e773a1c2d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -115,6 +115,29 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
 	return ret;
 }
 
+static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
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
+static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
+{
+	return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
+}
+
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
-- 
2.55.0.229.g6434b31f56-goog

