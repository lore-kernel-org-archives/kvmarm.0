Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4623E6394
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508567; cv=none; b=nA7IS1d4jfzTrSeNdJfsnhUn5oTwwBrtixnc8SpdFYw74RDCVtjcc5LS00z8mYlNawdHsro3x6pJHXlw/J0Sehs/xwX1ry+Pi2wwdw8sxpVlhFJjT67ENZWwx3H6/My4LzNQV4x1l2N9ggsxQLx65QKnpS78r2jBNCjKJ8luypM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508567; c=relaxed/simple;
	bh=O0BlKQ+P8eQYIllrreYA3L4asmz4nYdHLXvP3eCYt1M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TFn1T/oQ2N+hPH0pyyzntx5b0xOTVHimr+Fr2CvYa8wwq3OYHhsh82GnfAQVWUVk87abqhFGuFfBV/3RvdbdMuqVFN4wxK+EIzQgYbd/n5hPjuIra3yJwyH5CaOqHih0DU9S/k2run7x+hIBDyw9CT09hWEXTDA9SM21Zmh1dOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MZdhLi3s; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MZdhLi3s"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f6d70223dso908117f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508564; x=1786113364; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kr3XOqzgbSiP3lCApiAxZrrNJKAnhGQTg8lRWdy7DEg=;
        b=MZdhLi3s4kUbhTzPcbYmGj2W2KeRaPBj1TEjAf/NYf3ddBvdP5jio0VIZaakRKofDv
         j/whwQPxFrqkefZWFjePgM9CPETjF0YwfVuAC4muvJuy7CpHaopwhzmIuJyOJm/G0Ovi
         I5jRF1nLpXe0E1jbxqREFWEOvYAgFtgsMkEJMIwADK0C1NKlItGIs61gu8wExnbEr3ak
         Kwt62rPLSS0pZwP8zfwhRUP9YSutc4hpZ6WDahZGGW4TsO9xkCEJjNyJ5ME9TX9d5hND
         BOSnLf/q9q422CFpFG4GV9N66A0i3PV6mFUa5zjn81naNHhbYZ9fMxnJ2zYjkMgPstp7
         m3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508564; x=1786113364;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kr3XOqzgbSiP3lCApiAxZrrNJKAnhGQTg8lRWdy7DEg=;
        b=eCpjDub9Ze+UL7zvcvJJTuchye5kTbbgh54jwbigeKmap0ELnfv/kRHOQ5MOq7vml9
         5QHbjKjSMC0HBxyBQyVVUcFI4iuNDx+1E3EYomE+0emgDRrqVA68YJ9Qby4hM91EN+R5
         0g7No/7LHsScznwHudbFQpkGdA/EHhb8yz+e2Kv8wHbnnVLvWPtlNEZNKe4xZS5SCTrf
         NaA8Ys+xuhf0TnFRdW8X19hiOGHtc8aYULZpPGBurt8JnQArO1dA0PzR65X0bnrBP6NI
         6HoOoImAnNrAqeU2dUCNmG4pEBEHn1o7FNjuTzwIUFRMoqWRXwBNaTKAxR65sYfqEvA/
         MNGQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNTkQGt0TUIU4RQhpcZmyvIX1kOPYDXNd/1VBUatpUl5tqz/jOrZQxPhgQoN6BoH4oqRZo0Oo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6v7CUrKP7pGjYQ67ezOJXGNJYbSgnGZW/+utrrRSENwcAh+CM
	ayClP3El1LlEfMvyE8ZWwEDFsRopjOKjUttCz+zVQbqqGHxNuAy5Gr7OyLwx/qaPy/H3FTtlu7M
	Y6L3xKG12vRIM7W9dyXiTxQ==
X-Received: from wrqz15.prod.google.com ([2002:a5d:440f:0:b0:47f:86af:60e6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f49:0:b0:47f:921f:3a35 with SMTP id ffacd0b85a97d-47fd2b2ca9cmr4817215f8f.37.1785508563682;
 Fri, 31 Jul 2026 07:36:03 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:32 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-9-vdonnefort@google.com>
Subject: [PATCH v4 08/17] KVM: arm64: Add reclaim interface for the pKVM heap alloc
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a host interface to reclaim donated memory from the pKVM heap
allocator back to the host.

It specifically provides two helpers that will make it easier to
create a shrinker for pKVM:

  pkvm_hyp_reclaimable()
  pkvm_hyp_relaim()

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

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
2.55.0.508.g3f0d502094-goog

