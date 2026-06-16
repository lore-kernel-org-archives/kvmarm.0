Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168545BD7B
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624528; cv=none; b=haYR9pyDzhoHZ5am7GszBsW/L5pQE5/5DCMEOpxayuc+5WeD2szILxWEl3vzPRuY9A6TI8FwPFqv5BjHpw15BC6yIBDcYsm9onCdvEwDY0WIq+dgzRe3F1FRVczd1k+C7A/GDUZb0yQFnUBFviEGnGVv4KsLiqmtpF+Zv4tZ3iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624528; c=relaxed/simple;
	bh=+EPAm01oMZR6vmeTgpUHROfcf1fZOMGaAY6f3ecYeus=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uT2O2PWuzUoDidwxHx5GIK5sR7CS//XHQqO94YNbsq1XowFo5SilenmVqo3GbVauTzgvXeIQIGafCso0gw8MY79SUSdFFzoLJSkifxtMzKOPt/Dnyp+k89aK6GyJDwL3pvwO5Cy8aBq+X6m0KKdzgyA+AVxfTNR/r17yYsgYrFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RCLBXXC+; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RCLBXXC+"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490e547f3cfso49807145e9.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624525; x=1782229325; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5yEFgPXn8B9bdRFZCXWSa8UhuAuZNwO3v29Jko7dXc=;
        b=RCLBXXC+5nPAJOsys68i75Szzn5rDbX4tlAQyaQsrBb3bV3gpIsAio9e0qtJd3SmtQ
         F4cJ5RO17qBd0pgx/PyA2Havgho8dnH3ITI2M8ytmQcWOXLgy85N3U0p/SBDQQV6d8Ej
         ap4pVhxKDbPnvC0DyiRmxDF8TNltuYX1BqI/fx9C/pjrWGTrtwAXJ5GlIAoSsotIXcNy
         b9dpWxYIKCLb0fn1BgbwXzsTBx8E9S1N45pgDoAKs/xuKfFcV5qLVaJfDnTXTPe0M0Ze
         hC8U7qiuFGuB3kmmmJGd+RMjPq2UFxj2IwuyGE6KMcMHRleZBmGEGpVHFsOMHGUP3uct
         24Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624525; x=1782229325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5yEFgPXn8B9bdRFZCXWSa8UhuAuZNwO3v29Jko7dXc=;
        b=hxZS5Dot1MAaStSnSo0JDxq1CYakXCNo9I117NlDsP1gUrSv2ZOeJgeS5Ouono9PZI
         oTN5fToSn4LLq+JAWiE5191aJmkBvCAGRS8TsjGPyiZIJZLHtNLzqJM0fVzyG9udBhAo
         5s4HsPuJgIeMbvntl8ppdLQlRPNY2weZ4jSd9SaZrXBWAbhfd3UPqksQ8OyXsBlpLtNz
         5uU5vmfQIytDyUViL8Zc2MX9i0iSpcZnEb7BsLQ6OD23pZ6dEjsTQ/Jcack4QHD4X77d
         VlpPMIX6S0MmzrrW1E/6dYpvx/2IOXzoKHlgwDT8WbnOP1OX3oDZCeQMuwF5oeruog9J
         yRzg==
X-Forwarded-Encrypted: i=1; AFNElJ9sZcPVVjmw8kFQ3IW+iAQoXORCpBGtejp+Hu1KUf2/6rJ4PpKYnzu2PhFB/CnFKjM1erK+lpU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwO7shHCDOyb6iITqMdyl1WZhn4oXwOJem0zQSjKtvKZvlJNUw1
	OvAjwWka69WwJt9eqxApTR7S1vXAQN28LUbpfdzAhr1C3L+l+cxnHbXU6jRbOatIWrxWIe7WB0i
	AzYTV+09Dt9aXpD5gzhrrjnUi0ksKnw==
X-Received: from wmxa14-n1.prod.google.com ([2002:a05:600d:644e:10b0:490:b555:8215])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:33a9:b0:492:2f59:4969 with SMTP id 5b1f17b1804b1-492333ca3c3mr224855e9.22.1781624524184;
 Tue, 16 Jun 2026 08:42:04 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:43 +0000
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616154149.2763214-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-2-sebastianene@google.com>
Subject: [PATCH v4 1/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
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
index 1af722771178..c64c704f22f8 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
 static bool has_version_negotiated;
 static hyp_spinlock_t version_lock;
 
+static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
+{
+	int reg;
+
+	for (reg = first_reg; reg <= 17; reg++) {
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

