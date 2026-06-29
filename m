Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97C23FC5A7
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725788; cv=none; b=tErdZ6a2e+R9owANaqG8SCmhc9j0GjkpG0M1Q9sDPAOeWIFEs2nVwatZVrBLrLgySjzHmYJzC0gqef502L576LDW4rnCaPEe28xDYPqdZ0dkCoF7COySFEyZuT2PKgZ9xKDs+7BtYyX/zYYTVcs5r/o02aWH3Q6/tYdzdMWzH/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725788; c=relaxed/simple;
	bh=7/oUeWfPYnQUwQiE/7VSU2wWtnqYcHPR+rbqfIWy4Ps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EU4knEC/yWtbA1Wp6JLve1Ov4dSG4u2Qtq+sbeianUvZku1oVPb2ZcDCuO7ZYvuSrAzo7CiBM+wqWLa5cjKuE6QXloA8rRhG2zbIoQdPK9zwnlLMjQX+FgHiqS6B9aYBChrhKUBqrodIBVCyrdiAsZ27BEBN90oBmmEkleSRExk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i0FjMosL; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i0FjMosL"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46edff99956so1488128f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725783; x=1783330583; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=whfBl3Oi2rCM9H5B9AuU1XbX6JklFkv0AY/WgaO+6/Y=;
        b=i0FjMosL12qzW9fTmhBbjvoOuECmaEF+7XngJnOkrNVEpc6a7r5dzECNbmvUMOjpX9
         II1v4/ZMDDo2ErslNZymM9Y1rQKfCNGzWJN1dA7AmCZBq1hpN+MWYqi0SgW6zsIGOBeK
         qwVHJ7fNaVLG4il3vrey61FhJpW+71a5nK26rFPEeBctKddjsLMnROpOAGDE+ClqNyf1
         EZAkGPsth0dpJN3MffseAWzmqwyKseAFeKEr41q0K8cVdEeBZZ4fEgTGBW/kHBM4wysz
         DZtvPX0T9pHQ9vD0gzkr4WFF95e9Qz+eITiP98zITglvParl5xlnZM4x6w4eNIWkugcW
         Lf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725783; x=1783330583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=whfBl3Oi2rCM9H5B9AuU1XbX6JklFkv0AY/WgaO+6/Y=;
        b=hSPTutf9SVRqTDVLj6KvSFLBxOO+3xig6biTYde0LPHnJYroiutLcWG0lGr0CL5qef
         /cAu/Nh/NpAx/+aV471kILajCSaUmOadsH0p3yeAhdDRbB0nj10cCOyjTIsI3/hNKu5M
         waE8IVt1Et9jcxfAZdTS+SqqDoWVqPmXuctnMqL5ZFBzUznUvf7H2ACYJQBB6EQhVSK4
         nVKpwEz7BlX2AMSVgcW6tfk2kHQ47bVOu5+A3jzrcHAydq8dJIkxsKT5+xJTU6TlXdbi
         6fZXvmuwt9ALHtBILr8bmPi10CRbP25zhiN7m2Bi1oFkl0j9UwfiRu6uW3AY0J4LkJyK
         xTqw==
X-Forwarded-Encrypted: i=1; AFNElJ/dOagCKZmQXZX5gSqoV5iAEkHwmzd7OKLcYZi4D4OhURyGvYeKTRj+e6tgICJwmbHc/Qg78n0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJT+2OeP5skSVjcSHD9pveLfd0UoSLyHizhObyTLA1i+yClsp2
	OUtqiaqYtJssSRi0m40Mumq57BRZBhd12uTnoHpjHx9XUwWOIUOXV8paSQf5a5VRIEHpzoD2Dsi
	E1U9990VWCfgB/60jqQvM7HQLx5MSNg==
X-Received: from wmlm15.prod.google.com ([2002:a7b:ca4f:0:b0:487:3739:c5c4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c118:b0:492:6881:1114 with SMTP id 5b1f17b1804b1-49268811131mr188559705e9.0.1782725782622;
 Mon, 29 Jun 2026 02:36:22 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:58 +0000
In-Reply-To: <20260629093558.2425257-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260629093558.2425257-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-8-sebastianene@google.com>
Subject: [PATCH v7 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
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
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 96 ++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 712811e89435..334f8a28d942 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -74,6 +74,21 @@ static u32 hyp_ffa_version;
 static bool has_version_negotiated;
 static hyp_spinlock_t version_lock;
 
+static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
+{
+	DECLARE_REG(u32, func_id, ctxt, 0);
+	int reg, end_reg = 7;
+
+	if (hyp_ffa_version >= FFA_VERSION_1_2 && ARM_SMCCC_IS_64(func_id))
+		end_reg = 17;
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
@@ -242,6 +257,11 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
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
@@ -318,6 +338,11 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
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
@@ -424,6 +449,11 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 	int ret = FFA_RET_INVALID_PARAMETERS;
 	u32 nr_ranges;
 
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
 		goto out;
 
@@ -485,6 +515,11 @@ static void __do_ffa_mem_xfer(const u64 func_id,
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
@@ -584,6 +619,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	int ret = 0;
 	u64 handle;
 
+	if (ffa_check_unused_args_sbz(ctxt, 4)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	handle = PACK_HANDLE(handle_lo, handle_hi);
 
 	hyp_spin_lock(&host_buffers.lock);
@@ -764,6 +804,11 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
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
@@ -813,6 +858,11 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
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
@@ -860,9 +910,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
 				struct kvm_cpu_context *ctxt)
 {
+	DECLARE_REG(u32, func_id, ctxt, 0);
 	DECLARE_REG(u32, vmid, ctxt, 1);
 	struct arm_smccc_1_2_regs *args;
 
+	if (ffa_check_unused_args_sbz(ctxt, func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	if (vmid != HOST_FFA_ID) {
 		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
 		return;
@@ -879,6 +935,11 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, flags, ctxt, 2);
 	struct arm_smccc_1_2_regs *args;
 
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
 		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
 		return;
@@ -900,7 +961,7 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, reserved, ctxt, 2);
 	struct arm_smccc_1_2_regs *args;
 
-	if (reserved) {
+	if (ffa_check_unused_args_sbz(ctxt, 5) || reserved) {
 		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
 		return;
 	}
@@ -926,6 +987,11 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
 		return;
 	}
 
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	if (flags & GENMASK(15, 2)) {
 		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
 		return;
@@ -947,6 +1013,11 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
 		return;
 	}
 
+	if (ffa_check_unused_args_sbz(ctxt, 3)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	if (flags & GENMASK(31, 4)) {
 		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
 		return;
@@ -956,6 +1027,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_info_get(struct arm_smccc_1_2_regs *res,
+				  struct kvm_cpu_context *ctxt)
+{
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 1)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	hyp_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -984,6 +1069,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 
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
@@ -1030,6 +1120,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_GET:
 		do_ffa_notif_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_INFO_GET:
+	case FFA_FN64_NOTIFICATION_INFO_GET:
+		do_ffa_notif_info_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

