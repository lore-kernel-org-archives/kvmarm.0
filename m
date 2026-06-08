Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB23D47C2
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937759; cv=none; b=BQiojPgWQ+F4ecZaK6zexvnfvKJkzCAUlAQxfV99DRFpusAxLakOL77c6g3XhbJwgrcxRuBFxtVKDuZIfAAYH6R4Cm3PuQ6bRuZ+0x5vnbo4ZDt2Ysm36qfOcfWl8B1Q+zK+hKxQzxyU1NJM+eFRZJq0lmYwRWYF9bpLLlTuvwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937759; c=relaxed/simple;
	bh=ZSf1agfoztRze1vMk/U42ZW5zDEwC5EzHMFs8OfgvCA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tVyhT2hYJtmy8Ip3d45p39ihUxBo9DMxSXnx1vpj2ShOg+cFCIePNBkNF1x9JMNjFr4bjug3R6/RBkx+sMQJ4ltKd08Q5y5NyosEZ5sPr1kYUJ6kVhbQxdd+uRyRx/NSsQMDIdAYurQj7OBn3h/zL8oluMjDUoERxX2xBEJ3p7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oMk98qCQ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oMk98qCQ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490ae3bcf4cso22634895e9.3
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937757; x=1781542557; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SgnNHCiglWyE1dRfo9bMlmn2W0ut6mUT68P6HrXKuCQ=;
        b=oMk98qCQ+/oOykF7si4baK0dF1l0K6MKNodygPiBjci+twtwJcYii7xAyvdXtJTygv
         LuE7NOqTCLZDkwQGE/XLf85QTIsV+gWcF4PU4K3jxqaOHyyCQTb9wrXCKL7FtQVJSdva
         ZMOXb5a8wYfsgQ+qsYhGpjaYbCap+jQkBqXRO/kGxHTqSrvZjmMLediEQUBS0wPvQszE
         tISAIbK3n9KwqlnxuobGflLWrD6ilXMPD7zN1MhNw6UH+tQ1XWyGhSqwX8gDlI0Go6Yj
         OnhUn0cdrAFnq1hwAAFu3l643nki32oQQzI1mUPqSlM9HeN8wZxBUzklmojHLMl3UmsU
         YQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937757; x=1781542557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SgnNHCiglWyE1dRfo9bMlmn2W0ut6mUT68P6HrXKuCQ=;
        b=tMjULyYJtFuSae8tF8mKqpvmnum9ol/+0EC2WT490VJA0C4WGX16vOXYxF8G9+Ftm0
         Rgyy4QkHV/m9zWBiurEIwbBAktjq73hcoobLo+hLQONQnmf+2+hj0+pPISA79hIREH5L
         EukXMegeld0OVMNg/9v/uTiZ7+usRCh6S6HNUIkhf2UQlos0jjwc68Q29Zd4tBrCwV6P
         TQXQu7Bf5xC3UUMKoXJ8Qo4r9K/Ryj7aXT73O6dBZZbmU5zi56tBjUPO79pPnysMYAOz
         0ccIcLBldLrI0gGg4aezHsaZcOZshpqBfARqzFDAhqq4hVazmJlx+tr5HdE1123AnNTx
         RH5A==
X-Forwarded-Encrypted: i=1; AFNElJ9C4ofdKCNSS+G8P5LsDq8K9XWs6GeCCgm5vUG7iLiWAba92bXurCkYkAS1Yk7ab5y86aaf5v4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3b7/bUg28DRNCZyAZzScOJIndPdopMiIuF4PyMC7fHTUyHbQw
	FKnj7/bETPV7BdXfdGxOEQyp0vqSHYkzIJ1oUuoJqqGLUF7GH9xypDk6c9MWHGeNBpM/lNO/e3Z
	l9WTvbtxtSQ6gRfLoMaen2jAKdwdZ+Q==
X-Received: from wmxb10-n1.prod.google.com ([2002:a05:600d:844a:10b0:490:bb60:cdf4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:620f:b0:490:b2c9:e284 with SMTP id 5b1f17b1804b1-490c2612c43mr262310685e9.30.1780937756547;
 Mon, 08 Jun 2026 09:55:56 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:43 +0000
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260608165549.1479409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-2-sebastianene@google.com>
Subject: [PATCH v2 1/7] KVM: arm64: Support FFA_NOTIFICATION_BITMAP_CREATE in
 host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification bitmap creation messages to be forwarded to
Trustzone from the host and introduce a helper to check for SBZ
register fields.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 36 ++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..c20d45191085 100644
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
@@ -676,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
@@ -862,6 +873,26 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_notif_bitmap_create(struct arm_smccc_1_2_regs *res,
+				       struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 3)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (vmid != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -920,6 +951,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BITMAP_CREATE:
+		do_ffa_notif_bitmap_create(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1064.gd145956f57-goog

