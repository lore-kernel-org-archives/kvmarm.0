Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA20C3EE1FA
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372217; cv=none; b=oIJJaI70gNzwvq5JkjQ92IM9c4M5J0Av3OTenQQwRDIADzldO8ZrvK7naUS7qFN28yFQDHUiIFXSuPO8cRo43rRSQBVph56v1KdV0E2NTdm2607YE/awkZwpP/NMa/9HWDI98Mw2tmjD2wDsSob5dKXDdqzHeCbg+BuZOz+yEBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372217; c=relaxed/simple;
	bh=pWsb4LXB9ThVgvldcf9CnL/d7vmpsynGuhGjfwFYyJI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ufxAYeubiM+ABR5DARGIaRsPZNy68TWWBIobmAYk5tEyOCAZRXxep2tR1GC+Sb28ZXVd0lj+hcSUI1QXReGN6TEWVHKGqeTkg2W/mxBm/fk0os2IgUzzwhmhX5YJbUPzbV9deN/fuykSn3ZeAizV9FiOB7QkYf+s+Vde+3DvUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NEudNW4m; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NEudNW4m"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d121c4271so7765695f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372214; x=1777977014; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GmmNYOk+NsHl9ECni3ZP17QcbrO127/DqtR017v434Y=;
        b=NEudNW4mpnGZA+XbwPJ03NpTtRM4WpKwx4mXOTh9qR+J8YZu3b0MCOKzU+UBiTgLRa
         nqiuENr3pXXS9d1SQe7t2E5jWN9voPS+nInP8mbDgkZRI2Bgevh/OYpH8l/CNGoqZkdY
         jeap+BdwFKDlTQkhBcmJwhTp86dmvFLyHsj+dLziux18RaHihdjvxA6uGXYz5l21Gp9y
         MBnxn+kSOlDpywjuz+a9nLUiRRCcflDqBoK+PB9sXjfqJUCVvtUTPxpOtFXlPm34aaLJ
         1H2f2lIhKyIVFTweNW+lp1XJEVpT4NhwsPfUsuZUeVXdr7MEjjKFdv4kMsvObxoS/TVw
         uJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372214; x=1777977014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GmmNYOk+NsHl9ECni3ZP17QcbrO127/DqtR017v434Y=;
        b=fweFiNE+eUxHGpUxVG5W3syM2Ed2Yi71jy22T7/nX/S7UklwrzbE1iLoUoI73rhH9T
         Sl66EMqlL0mQRtL2Ov1Cdql2Xr8WsII3w49vV1g292cC6rxNlPIghD3TXvWAoMj+NKTz
         eePmWiVClFb27cvwuvXsLDpteALeYR7xPRmRiTng1dQzaK99MrlosUlW6aoJdf2ItImx
         PHVwEngvIJhFzeKu/2Bmu+i5eeClkD9VBvq/IrTC0Wzz+8Gl5+BM25q/i4+AK9IlxvFA
         fIfC0XNXr10JHVOW9S/MzUl2f86ybnohsuBuYSQ2XnWO62pr22EjRToBMiXwMr1+d5Fm
         KWfw==
X-Forwarded-Encrypted: i=1; AFNElJ+8IEOh36pP/QOTECtZDpfJeE+SAgbf4e0CAs+aYUOXn+U0m+VrICZNWbWrd+ej0YmkFS2r2/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIedlWc02FwxLPkXdHELk5P9Y2Hbulxh01+AskPLeB+vWpGZUA
	i0MO8/TAWP15LT/cetp/eP3MDry8UiJLoSU9WfKYPrwJA8Y3k6L69GD27sjjtSaLjPt0D/E1x5c
	VFw==
X-Received: from wrrn5.prod.google.com ([2002:adf:fe05:0:b0:439:d2b7:2393])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26c6:b0:43f:e7c9:2402
 with SMTP id ffacd0b85a97d-4464761c29fmr4504996f8f.3.1777372213972; Tue, 28
 Apr 2026 03:30:13 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:04 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-5-tabba@google.com>
Subject: [PATCH 4/8] KVM: arm64: Fix __deactivate_fgt macro parameter typo
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

__deactivate_fgt() declares its first parameter as "htcxt" but the body
references "hctxt". The parameter is unused; the macro silently captures
"hctxt" from the enclosing scope. Both existing callers
(__deactivate_traps_hfgxtr() and __deactivate_traps_ich_hfgxtr()) happen
to define a local "struct kvm_cpu_context *hctxt", so the macro works
by coincidence.

A future caller without an "hctxt" local in scope, or naming it
differently, would compile but bind to the wrong context. Align the
parameter name with the sibling __activate_fgt() macro.

The "vcpu" parameter remains unused in the body, kept for API symmetry
with __activate_fgt() (which uses it).

Fixes: f5a5a406b4b8 ("KVM: arm64: Propagate and handle Fine-Grained UNDEF bits")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 98b2976837b1..bf0eb5e43427 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -245,7 +245,7 @@ static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
 }
 
-#define __deactivate_fgt(htcxt, vcpu, reg)				\
+#define __deactivate_fgt(hctxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
 			       SYS_ ## reg);				\
-- 
2.54.0.545.g6539524ca2-goog

