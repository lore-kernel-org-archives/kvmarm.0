Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50178380FD7
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250202; cv=none; b=qd/50DEcrxBh1rppMpIn6spb1gFCIYU0iopw6W+u03neuh5fY6MK61QWwq4J+znyivT33EYUocOtF0oGHSq/nhRH+2xlQLB4jdIceVaXJ9GakpWZlb/24qgqYX0JWXgtJY54cn08QC2kglxBvgz91v0gDSdG/WG2GjUVqb+T1TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250202; c=relaxed/simple;
	bh=739qbsvTuKB4HJ3oduWtton+T/Vex1gpAv7YOiZ1kno=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XPSD+QXNmG/ESv8Q5PielXLgC/v55lhCRPBsvBWz/Ht3SRcOOmqwjYpsvNeiWEvJ0wPScfeEDrEcz+X36Pypb0q9XdDgF2wINj8zfTV4y/oiDJ4QFOVIepxAo3J9HsTxO6XPDUrJHOVScC+TqJzYcpcSOcsGZmK9CHdEy2Bu+Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F0weS9Ui; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F0weS9Ui"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c252c2ffeb8so504520866b.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250198; x=1788854998; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EY/D94kuwUw3EuPTsso237XfSk0Z/pXvWdO7f/q58aY=;
        b=F0weS9UiUPPCEY8RYtTOd6lh8ZTXitr/vl6SykOUpVm+rkoD82HjEGcFCQCgyAaNJC
         OikoLerP5YaIkbz+5RE5QCy0F7G67MM+KJU0qwZKZYk0bm/25uycDb0qOWuA04gkepxO
         geWzjx2AhLCT3AzwjX2L4apUaTvsD60I5u/FAhIdS9v8eVKKZcxaYjXVbff287+4jAt/
         vUriBMfBmGkQrh2O35/hNRfH1s2bOMZj8hC84EhDZ7cMqOi3wUIoU2JogedqwhAAK1cp
         LdiTNYKE2abqEsbgV8GkgML/vSgV6CYxgkusT38tILOsPCvaPBJS3lcPLtF1UbFaku0G
         D0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250198; x=1788854998;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EY/D94kuwUw3EuPTsso237XfSk0Z/pXvWdO7f/q58aY=;
        b=Qr7+uI3zOgfXxxXwnYoczoLHnBM7Lzk0g3JdVQeBo+Xbv72jMQAALsB2+K+4jVPBGs
         mPm/641Rwxc3S7h8BSApbwjjmpuaMg2MyVL/OlowAhpRzAuEGgRj40+1EQB3TeDCDHOg
         tg8+pdoRXDMV6ILSVk3IIhoGXPVLx7ygNNUW0njQKtckFtFD50qVdHJ5IN+/zWA8Y808
         ef+Ge9rlDeSEVYhg5Yk22+MFlfq8KwB17uD3T/X42vDHngZCq73hbl/WgfG+BO0wky6C
         uC6P1UDorBWq1cfKDaseeEYWokqP6PQj9a1RZgUPh9gDQvgMwcGGX/0L+RECiv+nTHyj
         zKjg==
X-Forwarded-Encrypted: i=1; AHgh+RrYkDEVVKOdyRqWk/3r6rrukL7PPdnPqwyEzsP8QQlGcjj6rLixjwpFxbrL4HGQjgARuH6q+Rw=@lists.linux.dev
X-Gm-Message-State: AFuF++kmX2AnLIHQk00YAoCv12l0roy+jpfjlwAmyh69OIaj2a9Pk00t
	MU4y0yAtehdlBwD9bi5V50P7GtHf7+0aYV8WNfPKv3glLQ7oTnqfd5eOKfZdlJfPIJSHtB9xlGh
	IR2JGUa6ccw35S9fDbPzHCA==
X-Received: from ejen10.prod.google.com ([2002:a17:906:88a:b0:beb:e0ab:b990])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94c1:b0:c25:6230:dfcd with SMTP id a640c23a62f3a-c256230e4d2mr1626513366b.15.1788250198134;
 Tue, 01 Sep 2026 01:09:58 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:31 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-9-vdonnefort@google.com>
Subject: [PATCH v5 08/18] KVM: arm64: Add reclaim interface for the pKVM heap alloc
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
index de59e89318fa..fc3c52b03154 100644
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
index 0e590261f1cc..62567560e1a5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -851,6 +851,42 @@ static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
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
@@ -960,6 +996,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
 	HANDLE_FUNC(__pkvm_hyp_topup),
+	HANDLE_FUNC(__pkvm_hyp_reclaim),
+	HANDLE_FUNC(__pkvm_hyp_reclaimable),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 9cd23978481c..fec819a9dc78 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -115,6 +115,50 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
 	return ret;
 }
 
+static unsigned long __pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
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
+static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
+{
+	unsigned long reclaimed = 0;
+
+	while (reclaimed < target) {
+		/* Arbitrary limit to avoid blocking in EL2 for too long */
+		unsigned long r = __pkvm_hyp_reclaim(id, min(target - reclaimed, 16));
+
+		if (!r)
+			break;
+
+		reclaimed += r;
+		if (reclaimed >= target)
+			break;
+
+		cond_resched();
+	}
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
2.55.0.897.gb25b4bd76c-goog

