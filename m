Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20B03D47C5
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215651; cv=none; b=CyilDAKXZ6g975YFhZDcpSIGpJWn3sL53A+cqR9nI4ZJnlgpwS1nf+1X/4O8nnAlFS1Rbh5FQqP9r1o28tZmMEMgJZVKBhDaHXNcat/6Ou0qP09sljvZ+aJIGo544CccVvmuOd//KKy6J/Dpj7HzJmXMQINxgvHggVhHrRpq6RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215651; c=relaxed/simple;
	bh=ZemjVgeFdNSzNMq2VrYAhRUIQEkBVMoaTX9g1MbjW6E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=batLDpm3+Cfiu2vwI1ORsu86PHwKdh+JHCj0odsq0kgulI1/WM6W84Mk4aHpXNw9zUl0aukDFbRtCEyYcv4N3QSTUy8mPUb+X0zZSm61KpkczrbzQ1KnYoDDgUQ21ytx7NdO3PZBmDdK1SJ2DCPP8ZguDdtGaWu0xZDoVCJqvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HEAuQj+V; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEAuQj+V"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c0840dc2849so414833566b.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215648; x=1782820448; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=09b+kI/zkikg9+QKQPwRY6ZbJWum8PvSur8NwEqIQDI=;
        b=HEAuQj+VnFA1mzPuqJYYulpwRGdvtQTFu5Mflo32RA4hCCzI/mnJ6wZiRJe5r/Ymra
         n1S9QJbjMHRT5jfeO6zih9QZDlNVWKEV2NM1+BjkEF3giIvltHtNS8GLPqmC9ZwxPl5J
         78V7fafsyNlnKbYs21D9bYYuokE8Y1lxD3cs57xJmiu0eOsrazfPtDtfCkpXW0/ZANU7
         7vS5KWwzGsBWbV+05Coiiu5XTEX0XGAMAKoAwPJ/p11eKaPSUESnF/j2u4JKfx8OB8gR
         F/7xLsz25R3YVahOGAK8hR2nMnufreNA9mTjuKScJ4mBZrJyjPalgccXr2Y2+9I6384k
         /3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215648; x=1782820448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09b+kI/zkikg9+QKQPwRY6ZbJWum8PvSur8NwEqIQDI=;
        b=g+u4662RLs2pRnRGn8JiVe3Id8wDCa3jw2huDmfRBlBcx47rC7b1XYgj0+4gnKeZd8
         RqNkwYAvXxH/mPyeU2ZyF6zTH3gxRahgum7IWMlIyWnJg3g+BD7iQENPFjvhTvW4h0G6
         UC123AqOZGE97MwBF1f+pbeus+CTWiqBGwJQ3E88kRiFqAlEHFavvj5lFuhua531EdqH
         2wdHkkf4kDyUSixjn4Bp/UKANEMNNvkPx7RySW5Ht24+uE1TEmXozoLor9gmFwGVOdcp
         FuOWe66RyXTyJ7LjYLfZctlxmH7CCl+88CyeKO+mJZ+QCtowbfYB/9so4MsHbz1gWdMq
         dkQQ==
X-Forwarded-Encrypted: i=1; AFNElJ/+5pW3cbR6SbWUzNlED6Ep/2SDyU6P/qdjvlIn19QKKoHksngRgSy9iZ1NgSR+btZ8s6YbSCE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwM+LS88jS68OfPXXaW3UAZUgg9d9kVFUsEnl2gzlF/mxQoGFCN
	XcJ0br64/x21nirDqzUsofRvMFUQ/ZXYrPAEXOvclCR1QHNv9Ma9ogGL0mmz59wm7hYzcYl2oS1
	LIgWnvvwDR3aLia8sSfuvoK/AkRAlLg==
X-Received: from ejcse22.prod.google.com ([2002:a17:907:a396:b0:beb:297f:8f09])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:6a02:b0:c10:256:3d6a with SMTP id a640c23a62f3a-c107f9a5639mr127032566b.31.1782215647857;
 Tue, 23 Jun 2026 04:54:07 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:48 +0000
In-Reply-To: <20260623115354.632361-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260623115354.632361-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-2-sebastianene@google.com>
Subject: [PATCH v5 1/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Introduce a helper method ffa_check_unused_args_sbz to enforce strict
arguments checking when the hypervisor acts as a relayer between the
host and Trustzone.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 54 +++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..78bb043b33ee 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -71,6 +71,20 @@ static u32 hyp_ffa_version;
 static bool has_version_negotiated;
 static hyp_spinlock_t version_lock;
 
+static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
+{
+	DECLARE_REG(u32, func_id, ctxt, 0);
+	int reg, end_reg;
+
+	end_reg = ARM_SMCCC_IS_64(func_id) ? 17 : 7;
+	for (reg = first_reg; reg <= end_reg; reg++) {
+		if (cpu_reg(ctxt, reg))
+			return true;
+	}
+
+	return false;
+}
+
 static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
 {
 	*res = (struct arm_smccc_1_2_regs) {
@@ -239,6 +253,11 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 	int ret = 0;
 	void *rx_virt, *tx_virt;
 
+	if (ffa_check_unused_args_sbz(ctxt, 4)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
 	if (npages != (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out;
@@ -315,6 +334,11 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, id, ctxt, 1);
 	int ret = 0;
 
+	if (ffa_check_unused_args_sbz(ctxt, 2)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
 	if (id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out;
@@ -421,6 +445,11 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 	int ret = FFA_RET_INVALID_PARAMETERS;
 	u32 nr_ranges;
 
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
 		goto out;
 
@@ -482,6 +511,11 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
 
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -581,6 +615,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	int ret = 0;
 	u64 handle;
 
+	if (ffa_check_unused_args_sbz(ctxt, 4)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	handle = PACK_HANDLE(handle_lo, handle_hi);
 
 	hyp_spin_lock(&host_buffers.lock);
@@ -769,6 +808,11 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
 {
 	DECLARE_REG(u32, ffa_req_version, ctxt, 1);
 
+	if (ffa_check_unused_args_sbz(ctxt, 2)) {
+		res->a0 = FFA_RET_NOT_SUPPORTED;
+		return;
+	}
+
 	if (FFA_MAJOR_VERSION(ffa_req_version) != 1) {
 		res->a0 = FFA_RET_NOT_SUPPORTED;
 		return;
@@ -818,6 +862,11 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, flags, ctxt, 5);
 	u32 count, partition_sz, copy_sz;
 
+	if (ffa_check_unused_args_sbz(ctxt, 6)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	hyp_spin_lock(&host_buffers.lock);
 	if (!host_buffers.rx) {
 		ffa_to_smccc_res(res, FFA_RET_BUSY);
@@ -890,6 +939,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 
 	switch (func_id) {
 	case FFA_FEATURES:
+		if (ffa_check_unused_args_sbz(host_ctxt, 3)) {
+			ffa_to_smccc_res(&res, FFA_RET_INVALID_PARAMETERS);
+			goto out_handled;
+		}
+
 		if (!do_ffa_features(&res, host_ctxt))
 			return false;
 		goto out_handled;
-- 
2.55.0.rc0.786.g65d90a0328-goog

