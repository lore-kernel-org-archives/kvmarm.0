Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24F847ECD8
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327234; cv=none; b=BhhO0SuuU1/s177NIGWeShRzdT8FF6P7GCF8zyqhLim7vJdzr9QM0ZRV4k41+/q5+cD9BHBl2TtQhwAT6VtD0HWtEWa7x2rXUiGndrsQi7ZLG0UvVQQkZy8vjtUs3t61ajtWPxEborv6rMwNx3I055J1JqAQwiLtydJQNuruKfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327234; c=relaxed/simple;
	bh=77hq13VK/L4ffHj3n97i3bGO0isGHkXXwe3+Lt3FlK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cA4aIou+KFSYleDq4TbzJ68AJgQXsQA9P/Rf/y0ZjF0On8DLGAibLPkBB0wU0lzt5pvrIAhqDXFJn8IvJMH15SDUo5JACHlAYoTOpaBpMxJgsv+bwcygkdNvHDZkfJSnOA68xH1w6LJbMSLaTbhE8waHE9+P0p60R2AXrLgGR0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jNGWykfe; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jNGWykfe"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c1c25c44d15so110805166b.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327229; x=1785932029; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p06tmEqCmuR7vgGiUUXccyUpu5ULn3Qw0OUPDBKfaJ8=;
        b=jNGWykfe6TRs8kWnkrnfbaLSqmpG4hPQh08kvZum6RLZv45IrHulrxTfxzsGKZxOd2
         BsYI4HNjD73ExqXDF15T6oXCE73pSJT5XMYVwnBK/HnbWnQI53UISelieo8TWJ2etYBC
         Pg6gmIgJ7wa0MQfXzZUAL83eRVYPaaxBrpmS92e50UttybW1ByQOgZocv0h1E3n9Oqv/
         fKZ9upB0YPNkvsjyFHUgJhR5Qa+R4Op7Q2qg8KIkm8DVs3yjww43nJfsNKihN5KmUImZ
         NWUF1V20O1sjXTe4KQwdmElf3pwRtBiNwMLr3npaMJGfDb/y8AEtkvWPU3NthZ7IHjxu
         nRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327229; x=1785932029;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p06tmEqCmuR7vgGiUUXccyUpu5ULn3Qw0OUPDBKfaJ8=;
        b=GRLJ99DWrRY4Vp6MOV04Ijl1S57cfY7mnNS7BJ/qH3rIjidGNos8VWGQMhKh+zEsLQ
         JTJ7tys+RURoNuZgUilw0SockHxl9aslg1SLjUuic0xoUzjWl9nAsYV/MizWGRghKyOU
         HR92rOnn0GjLYrzULTgnsFGERsuMjrrskGkALe8+r3VuVxzccJ8/fIpyxOYzT9b/7azq
         N0bKk/puX3vjCy92UnHTCdWon0z+jP/0oo3WS/jDtzjozPGwiwXnO2wyfmsYJuk+jFuB
         cD9rmK3K9HdtfloMT5+p6YZ5pza2Azhjg/7H8s45PQWXUBMdGzkssPUYjIN8LCcrJQ+p
         6XjQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqapr3J64hw+JPB/gIT909lRKppsjFbCyzeLQA4LoIpB27SjqvMnOhiTdBBKaEFJISo8fe4UCk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yze6fOYpVNYOOUUKT9WfyPJfQE2C8f3XEuVF9JwW+rowLC+Fbsy
	qvD216tka5bbJl4FxgSWS7kwzdPtJ+gaomuO0FbeIFXzP5FDFB9OFvsI+Zr20S7JqJ/xSCSqn4h
	iN+U9O1Zp3ayl5WVo9K7TDBocHkX0bQ==
X-Received: from ejbgr25.prod.google.com ([2002:a17:906:e2d9:b0:c01:db91:5d49])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:fd18:b0:c15:cd7c:fcf0 with SMTP id a640c23a62f3a-c1f71e93eeamr320466266b.1.1785327229138;
 Wed, 29 Jul 2026 05:13:49 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:07 +0000
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260729121306.1519473-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-9-sebastianene@google.com>
Subject: [PATCH v8 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
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
2.55.0.487.gaf234c4eb3-goog

