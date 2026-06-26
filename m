Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B0E3E558F
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459975; cv=none; b=V6+RQeh9ddgGsgtYNdzewYw4Sfp+qq/XdTcEgyezpZ0OJ4u1ob6XtaLer2UMxbc8sCPqj8rhZnF7FubrZxr4wgSPcoa3kgCouZnycP1sRv2UPfluHgEyIST2IDkPPA7zIIy2fQfiytdaWO9JtpHiJANTjz4AfCU348mGanaLEIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459975; c=relaxed/simple;
	bh=eE2/zIbvUThmkY0IodA/j7VzneBn/uehTrxCUWlaRbY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EGHGZXb0qiHJRN1ByYJkYSfEMoOk1DtOJzHrHme2hzTM+Qe4Ps7Jlbu6PsAjDgOb1ids/BmZCEKgxHeOT/ZjsS1pR9iSDNf81Jvnate5xg0CiKnzvmi86wCXpsqX62bfzwrtcmB4ot6FpPIhiEmTUz3v3YM2f6P5pA8cbs5L8l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XzvWmVUP; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XzvWmVUP"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c11f2b9f62fso51185366b.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459973; x=1783064773; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jIcuoAolmWdxAL1Cj0MO5LGeOmqPiUF61NhnhxY/T3c=;
        b=XzvWmVUPwAI1BfGvUb2CK7x5cwasMla906g7B+kJkyV5eFQWJYFkM5cVA/heJFtjVl
         nSIlKDY8KUVennISHHtaM0Fpf1aWEnY5V9CWFjSuJtXcXYiC+vrVsjh3DIKjJihu7oNp
         9h52gMprNdFyVfmdJU3Or0BQfD105FFJcCmu4TsJB1DIFvactO/V+e4IAgMM4QItbLIC
         6duffoDIm9rkn7wZwdPSccdFeKVs/DcPY9Dyc+52YCBGyHkrBinRwqVyOBLpcHuDC4no
         tEjRmPUII1Jn8bPcIZv5bbsDvZZ+KQmSIrYWY0oDY5LhIrCfibivDmhK/l0Ne80fQOPy
         BKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459973; x=1783064773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIcuoAolmWdxAL1Cj0MO5LGeOmqPiUF61NhnhxY/T3c=;
        b=qrT0o+a10s9M4mj8bOesrd4WgvLH7NoU6u9vY1doYbFiD1yQ0oz12uUI35LNlDVG8e
         ARsX+RXrT9lWlgk88hiBTN68H/HjWAFbQt8RBCnL5lOjNKYzgiWEgyFym51KtfvWnu3e
         Un8EcDprtxph2uXxQVoK2PUKqVz2CHr00plGJ8Q4CwuIwaLiJR9g+spbdIHgE66z6Yt6
         46MZQMhA+HhREYXscLg3pSTx6IGu6GPecSG4tSQDTemtuhSiIkO5HqAN+y562WQ8Ftko
         wFy1p3XemHgVZqPRQNRKdPAqmk01fj5FAtFlLR3IeJSyv69bnD8kQmRv3ukuNMvqgywb
         3aSg==
X-Forwarded-Encrypted: i=1; AHgh+RolT++JXKw4eRwZCEBPluSvZ3tYNQ415+QC1DoGU0+q/xy604BhSGy3ABBINf8I+iLfKAboLxQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMPh4K8OtGOjgNxL+g0FitGKuCo+tFqv7ynH75JMNVWRQMMzse
	J1a3I45yv9z4SY60ZlX+CUovw06nR+NEy/F0NNiCfPbt9R27Sk76RtYHpRXX4XK3P+GzExpcOra
	KkQAUk3QzshRyME1WfmcgPmoNhTtAxA==
X-Received: from ejbqx9.prod.google.com ([2002:a17:906:fcc9:b0:c0e:81cf:b184])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7201:b0:bd5:151d:2d31 with SMTP id a640c23a62f3a-c1205d8ac1dmr387442666b.13.1782459972081;
 Fri, 26 Jun 2026 00:46:12 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:45 +0000
In-Reply-To: <20260626074545.433234-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626074545.433234-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-8-sebastianene@google.com>
Subject: [PATCH v6 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
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
 arch/arm64/kvm/hyp/nvhe/ffa.c | 96 ++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 712811e89435..bd50ddc5b61c 100644
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
+	if (FFA_MINOR_VERSION(hyp_ffa_version) >= 2)
+		end_reg = ARM_SMCCC_IS_64(func_id) ? 17 : 7;
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

