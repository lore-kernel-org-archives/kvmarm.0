Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED723FC5D9
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725778; cv=none; b=EHFCva3mENW2mNnPkKKjMI6m5bkJCrjkRcluGdVJbh7yS/sU5Um/IALtHL23l/orSzi8lUyRccQ2uEyNCGwnQ/8t+RrQOK1NZNyNfYqpAgDgoharsmwH6/0DyWp4QNpILCbfNIY7Aweuk00MYOJt71jzdAGxkibUGYyitqcitd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725778; c=relaxed/simple;
	bh=tKYP+GZEflyKSlmPC4K0hHDZmwBpOjHjHt0haihLqJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I80rsy8CGsYV++1qwJA7Wnax/RhM/rtL6vO0W4vM/NvDXWbt7ZxCX7u6njgClzrwxpTzIq9UZKJcYrx7duDM5zD9sZF33C/3NuorrYwaQXxmQnytk1Bl1CxNK7sB4LYk1C3gEVh7ntKy8B9I9wXAjfi5kB/ZylRampJubtbR8u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VdNoKaEr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VdNoKaEr"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4926e6e3d78so15989765e9.3
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725773; x=1783330573; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Nwcle4m1xhjtWQ5cG6kqMRZxeBIvD7DoAMnMMXwmNs=;
        b=VdNoKaErNzN7TTPInRS97ISvem1YgOWjKYxqxgm1/7L+tEXqrRbHI3dOKsZA+kKCqR
         nzmYbw6+jcvPEOWCOjpOmMGbLf9RTVMKdJx5WcOE2RIJsz5XeLKi4h1xYLUiPvMpeWCl
         I9YPlZGMJL2pZFmrtJCVf1nWU4yDLqlhPpE+Gp+ozcBAf4q/2JGDoLDpjw4AFFsqC3am
         Gt5711/9+6YxB7wzlgApXyClg02MGKmXGrgIbCu1LPdMfbB3Eayyyz1D8Gk3pEmnc2Bw
         29nRzD7ij6jFi6Jq4ZNGxEU1uwekOlhsqNdNIS6U2V5yKrUGUBv50C7Kx2WX7nGRo0fD
         CTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725773; x=1783330573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Nwcle4m1xhjtWQ5cG6kqMRZxeBIvD7DoAMnMMXwmNs=;
        b=Yi+O7OzwjCdGuwyZwVYsKiNMnEgSOwcyOfCTzGRUk7FafSq1dy9BPZBS6o4WxzJNHs
         KT2W7O5ZgtKOu2C8tIImC1krZ2CBSfVU4pLz39itNYdyRFHntJSzukY2fWbjQs057Jsi
         yXkluDEo68YfYZMPJR8hlYc6w2PN48U8xd2TBKGRIxPKZsEtLjiIwZYrY+QKTV+8r1GE
         1Q0/vzGspE4NcEv+WhTwB9mZ8p+W9BfHdC7m1g+YgwP+8WMp+hxWzJnadDNrtHB1edLC
         eQXjJNpYKJ5aTLgE78oL9SpBfHtpCbrwPuz/R/HBs7tAbJiE1KuaXRHImh1bLzDDPZ91
         zoww==
X-Forwarded-Encrypted: i=1; AFNElJ+rLwxrbQ7tQruXFXgUlp0puRiwgW1QPXvcW4QGjV1CVzgA50ScftrYmeT9MXMGekChOfFAThs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya+rF8w5oXsGv5W5djG0E/wPeSEnlHD2C9Dt7Hq/ZNcf8CpeAP
	+fpiMtBh+LxD92oJEI8xw3HU+05pWKG5oSdNlXQwvt9ureQgsrtuDcdqq48h5zntbYOIk5A/cF3
	RbTf5W7i2BcwaK/zKSf1kjVw76OuJiA==
X-Received: from wmnk7.prod.google.com ([2002:a05:600c:1687:b0:493:b0fe:519e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1554:b0:493:b307:6777 with SMTP id 5b1f17b1804b1-493b307689dmr19016065e9.22.1782725773023;
 Mon, 29 Jun 2026 02:36:13 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:54 +0000
In-Reply-To: <20260629093558.2425257-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260629093558.2425257-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-4-sebastianene@google.com>
Subject: [PATCH v7 3/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification unbind call and forward
the message to Trustzone.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 331d9d0d8287..d52d7c4d5e7f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -678,7 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
@@ -897,6 +896,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, reserved, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (reserved) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
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
@@ -962,6 +982,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BIND:
 		do_ffa_notif_bind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_UNBIND:
+		do_ffa_notif_unbind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

