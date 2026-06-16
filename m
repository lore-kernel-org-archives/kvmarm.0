Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065A142EEBB
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607267; cv=none; b=iyf48VyqDqTIJHGYblMZQXxSxPVky/HQi2AcAphnQmcZOuXgMyZxRUUlu6VcI542TXgNbchCU+wPJOcNd9OrWT34jYwDwCP+vguCyNsSZImoq2awdTS9bCae+UmT3DUIVpNOv21uuhapYfoqHP+BAX0z8NE/0rwFGJZ+Jgs4jl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607267; c=relaxed/simple;
	bh=aLy1aqQg9uKPDRV0yIlbf5EWWuvfUKXrVYINVrPNTmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d7OQHErdZP4EWW23aqfIOn3fSIO1oqtI9SmejfLdApyVe3knG3YroZowCWGEK5rig56jUKOPI1x4lbDbIo1sCbil2RVxT0U1I0zF6V5DlCapUHiocF+WU2xn/8c42yY6hyNz7V/MRfuI5k95RjeNjwU5sZ192vjyDY2xkNGtzEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=klGuyvoD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="klGuyvoD"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b3f53c81so19181685e9.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607264; x=1782212064; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b9YtP4kly16nC//zfpWqwF2dbg0H1K+4KeRXQuDtzJU=;
        b=klGuyvoDUy9RQ1qndNhmsDNNCfD9bhEFR4ZPZkPXR3UZhrX+10eY51kuWEFJlWTj4F
         +48om4ivSMBtdVr6RAt9bArYwux7T0su85GPx3ZJqPyrtvINoWLwmoTuMqvKFae8UggH
         ZpBGpDkYbXYwLUy9O9ohbIl+FK8CGCTTYvSix/iGihOa++MoYlIxMOJpHPtWDYV4E+kW
         jHZvaNv1uqroqUgh+ilUa8iu1ZvGbXNUtNjyq4iNExtZGedfuVZZw1Ds3pYBJ7rqxGra
         H+efkX31nb96sq0YlC1OCfEE8AuNkHM5fDX1OKYMWtT2UT9FXpTtUU/i8fDuNqcnFjPs
         Nv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607264; x=1782212064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9YtP4kly16nC//zfpWqwF2dbg0H1K+4KeRXQuDtzJU=;
        b=NPhlTcRedYVmRxLl/+o+6McXVOLAKbRFZuqqm823IoCHYbJEPfJDqhzlJVagWxNHjN
         pKtoRCKsZmza8NcOC/8loa25ke5FdgXai4cl6aqfsh943SKD2uGWQFdKyISnSQT+wsoV
         RMHhu3aKTVPi8MBsjg/m1rheVVobM5/SZsHQrZHYOe1JX3ofaq+/WL/hhDoE+xYnvBWc
         erpomhlHsCUIS05VtACfaIc0K81ICt4AMP28DTxngerwwDZBKpFvTUEiWEG0R26Axa9b
         6hWDwweRUB94FkgCUhqLQ50BQAY+KDr7/Ey90F0rmdGWw+JcgLUXhyon5oApv2mhCZ57
         +0zw==
X-Forwarded-Encrypted: i=1; AFNElJ9LpA6pjcAI+zBf3xvZalloWbjFz21WL2BFDSTd2aQdYtBHX9EUsE+XwwMi5dyj9rYVw/MHG2E=@lists.linux.dev
X-Gm-Message-State: AOJu0YymyJSnVdgL9PXPp9f9Eb9HnutVRtYU1I3z4ZbykKBDVHZHL/cQ
	6bmsdOjO9GweYL3nQIqeHCZO1ZCJMf+F5kpo5L61Pk1sq5zNYcCAq7UHeHD42JZkH5oYijnq6yU
	7t+MZuLnYkFnhY7+CI08NxBF3R9FrIw==
X-Received: from wmaw25.prod.google.com ([2002:a05:600c:6d59:b0:48a:5334:11e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f18:b0:490:c2a2:e91f with SMTP id 5b1f17b1804b1-4922ffc05f0mr43580905e9.35.1781607264086;
 Tue, 16 Jun 2026 03:54:24 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:08 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-2-sebastianene@google.com>
Subject: [PATCH v3 1/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
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
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..c723a21006aa 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
 static bool has_version_negotiated;
 static hyp_spinlock_t version_lock;
 
+static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
+{
+	int reg;
+
+	for (reg = first_reg; reg < 17; reg++) {
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
@@ -239,6 +251,11 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
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
@@ -315,6 +332,11 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
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
@@ -421,6 +443,11 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 	int ret = FFA_RET_INVALID_PARAMETERS;
 	u32 nr_ranges;
 
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
 		goto out;
 
@@ -482,6 +509,11 @@ static void __do_ffa_mem_xfer(const u64 func_id,
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
@@ -581,6 +613,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	int ret = 0;
 	u64 handle;
 
+	if (ffa_check_unused_args_sbz(ctxt, 4)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
 	handle = PACK_HANDLE(handle_lo, handle_hi);
 
 	hyp_spin_lock(&host_buffers.lock);
@@ -769,6 +806,11 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
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
@@ -818,6 +860,11 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
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
-- 
2.54.0.1136.gdb2ca164c4-goog

