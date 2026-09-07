Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1DB501F4E
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801589; cv=none; b=IzhmI6dvRDCUHQrN8KYAdZmwsp/gdGZ1Pf9lNOG7u5eFgio7C29gfAr3IKQ0DE3hnEw/mazoTEMVR2PCjWNjw9CHw/f3qdd5koZr4pTKNJpf2UI/Sp1k7n+0QDWsBptNu8Gy4qr1WoQuDa2ITlMEkW3aIkJXx3B3ZqndE67eM2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801589; c=relaxed/simple;
	bh=NbKk/Hdzgc8mwGs1OGNkYIpfW6nhoT838QZM7abSr8A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cwh9km4/sFsxgwvF4ptZnrhmbypn22SYrG95fh0+BlpmPE9FQDTMTlJwfol/cQx4q7l2vfBl2Idcq39WgGjUehmEd2cygvgTmRD5kt16oJHbW+y5OgNExe5Ar9ZvOp881K+06zGIw54SYUjPBnZb4l9kEJ0JS6U6irowBxXyuGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=erVVKo/w; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="erVVKo/w"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a7fa60bb5dso2483716a12.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801586; x=1789406386; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KmIWpzhFDJoaOM2vzu23v41LySXrh6uszkNkTVUH7Ao=;
        b=erVVKo/wxnNFCQJ6jWqjBP/O3guErClna9dUKVw89R81s2pF1xP4kSJmpKvBLVeBuG
         mEyw5EKuhPHtdIxjbkKADdY+MwidXuIQ42dXdPh+LZOYuGdE9/KREtBKn+Lo+8MMY8nN
         XIYUy54CnAHe+IQpUbETMIaHJiXIfFO6XohFsMNr30zmUBxqqBzj6IgXGQUvQ0N5liVK
         RGuqN4UlcCb5mVmoJ7W3OxgYq/TYT2ZqEPbClsxSgWzDgl0QwNciozgykKNcWW6XUM5z
         oPiQrmG7WhVf8MRB9xrx/Jf+rF4hLoTEbzEMG+aJRAkbk/bUFHLHkE/50heCOvmlyRjy
         2PUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801586; x=1789406386;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KmIWpzhFDJoaOM2vzu23v41LySXrh6uszkNkTVUH7Ao=;
        b=j7ObL0NrT9y/z4smKU+Ff4z6WQgZHB3O+/tc0boi12e+ppiXyIfz8DjN2ZRVJdCqAq
         Bg0yymN65vf9kiYu5oU5ZsS7hZWEupwgOFcld8gF5mp5LE4M0uuDcLNyHORFLvQ7PnDE
         RA24WiP8I4OXzk00/yNsTXlYt944WmUnljcM+E7o+5kW1BAQwGouYAgyRuM3IbogD1iA
         mJgwtYjt+9hCbncpylkQ0kIt9sN0Exj+KOY5KXQSNSiLqfsyFYwrM+xFBcHHucmxhrVw
         CT6OVO4Uxz3mkw+FEGq1s36gCAd13IN96fgQfMnY5hHw//Xmh2l1maBZJj56u9qZr83a
         dX4w==
X-Forwarded-Encrypted: i=1; AKwUvBxXieLm19h4Va07DHhw8fAZ1+zivw8tXQfIdgFCexz+GvXUwui2vA0GtGpQ3ojbTJtRN1Zi9Uk=@lists.linux.dev
X-Gm-Message-State: AFuF++nZB+Bg3QCajoWst1corphaPMF7vHkNzsUKoGCenZUdjwdXFU9y
	yDQTlLlh//4bIxr1VT+Np511MIJaAGAY/WEYrvBupJpL1eVeggvVdNAj1mNylzpNjTs7aez2494
	0UoE/bq3MJZwi42fjGr7smpAHfy+E5Q==
X-Received: from edyv10.prod.google.com ([2002:a05:6402:184a:b0:6a3:670b:43f1])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4585:b0:6a7:ee56:8153 with SMTP id 4fb4d7f45d1cf-6a7ee5681d5mr6951962a12.33.1788801585853;
 Mon, 07 Sep 2026 10:19:45 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:29 +0000
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260907171930.4037166-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-8-sebastianene@google.com>
Subject: [PATCH v9 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Introduce a helper method ffa_check_unused_args_sbz to enforce strict
arguments checking when the hypervisor acts as a relayer between the
host and Trustzone.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 96 ++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 2281ac2e42fc..5ad74ab265b5 100644
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
 
@@ -486,6 +516,11 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	int ret = 0;
 	size_t mem_region_len = FFA_MEM_REGION_SZ(hyp_ffa_version);
 
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -589,6 +624,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	int ret = 0;
 	u64 handle;
 
+	if (ffa_check_unused_args_sbz(ctxt, 4)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	handle = PACK_HANDLE(handle_lo, handle_hi);
 
 	hyp_spin_lock(&host_buffers.lock);
@@ -780,6 +820,11 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
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
@@ -829,6 +874,11 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
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
@@ -876,9 +926,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
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
@@ -895,6 +951,11 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
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
@@ -916,7 +977,7 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, reserved, ctxt, 2);
 	struct arm_smccc_1_2_regs *args;
 
-	if (reserved) {
+	if (ffa_check_unused_args_sbz(ctxt, 5) || reserved) {
 		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
 		return;
 	}
@@ -942,6 +1003,11 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
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
@@ -963,6 +1029,11 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
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
@@ -972,6 +1043,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
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
 	struct arm_smccc_1_2_regs res = {0};
@@ -1000,6 +1085,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 
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
@@ -1046,6 +1136,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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
2.55.0.979.g7e5102b832-goog

