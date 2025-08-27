Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEE341ABD
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756289995; cv=none; b=uushsKBhmM8fDtEEPe8QnKyarjVS4nMrHTf77DTyNMxEeowWs/1YZNM+vm3oXdXDQG6+PD8CBxBPL5VyacHrUYWlcC8qX/h+HIu9zXLcchFk0aUcG12vl0jymvExRrbMVjJ13Nwbpyb6tAYe11HbiWjpDs1EAw5a5Dfm/bnqqq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756289995; c=relaxed/simple;
	bh=8ePvjdtT1zZeDzpNtpZHjiu6IHtH8iG4d59JdpTYeXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j2oBrSELwMm2B7BbHwMTmr3bUZcVCgbVB2GuYlSaOM13xyCu1SBvcPg2gUZdcoviakwrFTREBjC2sMI6aC1AbU8bIhFdlkt98lvNRA6G1ipRIVA9nRXuPe73QA1Is0VP+ub+8w2ADLbtVMg+dqyhSC5VtTn+xwgem/STBorl5us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aUEgSB5p; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aUEgSB5p"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afcb7a3a160so670017266b.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289992; x=1756894792; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pWlEEa9FdUN2zJcQtqepJKUAvgcsiNc6jwdCVzIXab0=;
        b=aUEgSB5ppkZXoI+vxvEJxfUkKOE8G8lKIWe0XIgxVKX6HXPHj4rLdCuH8dIK5Bu2bw
         rDx2/pEZfTrum6aWIOpsG3vrvxlJ8hxBAX1wVVj3zmBAP+kZwkvrQU+qW6bOnYuXyQYQ
         8Do6qeTW3AHJv9tJ8L8aXd3mc4TuEjOfQuiNZi8I/ystsTExxsCRXWq4eO4Ap04Vj3YW
         +6uH8nkMB6ijcIaYVsVt7mPQcFZr8HECkZoUQ66rKFE9AKw0E8TphZU56naIxSZBoJwL
         C43OB4ciAZjw1aSkttF+gO4Fwfotq2h2NJGqKXhHgBR76jVmPSOSoNijEFROkkRLrrrd
         Heng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289992; x=1756894792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pWlEEa9FdUN2zJcQtqepJKUAvgcsiNc6jwdCVzIXab0=;
        b=o2epbZcIkxUBwmTchywOJ2POJxv50hEMwjZ2q9ExW4cCGOXe6WYdrPLXiqHGD/TA2p
         Cikfb7GsQhq1W1SX28NQrP/9TY/7XHK5XRutk/xu3cb8bCj57EFcw+y06Ca5dsxkqEKI
         305nOFbyPwYWz2OAJaK3ZENqsoCGqksHx0e7fXYPMRlyRJVgYy0q+44cRGK2ppdW2HjY
         qLTTrl5TQ+FHx60eBgKbeZ0GSIOtiZ9LT8X5Cq29bvHAMGmzEpLxnRWYJ6uw02A49Cn5
         WB5uqWzhaY4iWpvgtWxGCOfw9bBuRF9wLMQcdd7nkhRQhKK5qRz49blNCl1+NsjISAuf
         rwwQ==
X-Gm-Message-State: AOJu0Yw3S6A1pC1hvNHDtmgjprYIq8EuOia7Z4YGR7vjk/QIuXCBndJJ
	hABFMNppsW0WrppfrdMUFthcD8jC4IDpCnfJDwMsxVv3nxBbBT1HBoryxs9EHfRN3jKrmWD60eM
	bnLXj3vxUJZr7VgASAspna6H/wcUGnC3/cQtmnSE9FBOLteQkARAwLyM6GStyZZjk7Yie/wLSbp
	CQwh/I/aJdwMu2tp2h1XMSGBJr/wX7ycg=
X-Google-Smtp-Source: AGHT+IFxJhReaSFTqpPGeb6pKgScnDIt4APx3m4DP6X9fzvN0CY8gtebf6nCyPV1qcYxfxLc8vvJN/9tnA==
X-Received: from ejcsp8.prod.google.com ([2002:a17:907:3948:b0:afc:aa8a:a50d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:a4c:b0:afe:6fdf:c27a
 with SMTP id a640c23a62f3a-afe6fdfc8d3mr1146661666b.33.1756289991787; Wed, 27
 Aug 2025 03:19:51 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:41 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-2-tabba@google.com>
Subject: [PATCH v3 1/9] KVM: arm64: Add build-time check for duplicate
 DECLARE_REG use
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The DECLARE_REG() macro provides a convenient way to create a local
variable initialized from a cpu context in the hyp trap handlers.
However, a common error is to use the macro multiple times in the same
scope with the same register index, but for different logical purposes.

This results in valid C code that compiles without error, but introduces
subtle bugs where a developer expects two different variables to hold
values from two different registers, when in fact they are both sourced
from the same one.

To prevent this entire class of bugs, modify the DECLARE_REG() macro
to declare a dummy variable whose name is derived from the register
index. If the macro is used again with the same index in the same
scope, the compiler will fail with a "redeclaration of variable"
error, turning a subtle runtime bug into an obvious build-time failure.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
Note: I considered a more restrictive compile-time check to also enforce
that the register indexes are sequential and without gaps. However,
achieving this without requiring significant refactoring of all the call
sites results in too much churn. This patch catches most (or all) of the
related issues we have run into in practice.
---
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
index 1e6d995968a1..ba5382c12787 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -12,7 +12,8 @@
 #include <asm/kvm_host.h>
 
 #define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
-#define DECLARE_REG(type, name, ctxt, reg)	\
+#define DECLARE_REG(type, name, ctxt, reg)					\
+				__always_unused int ___check_reg_ ## reg;	\
 				type name = (type)cpu_reg(ctxt, (reg))
 
 #endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
-- 
2.51.0.261.g7ce5a0a67e-goog

