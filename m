Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6352EC542
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261152; cv=none; b=Hm3JrYoZgs1cH9/ZUdaCM0t7s1oMDyzRAFDNcIlgkeZme29SXHa3vcIlo6tWtUi2CHOebmBU77myGQlzGp02vYTvv/V+zrap/Y1HkSCQh8WC+4MAwMHwPT4tDmBhwvpLpogvS1mwDv+JLvgPqKaPCEqj34TIrTOIF1Qkpfr3dpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261152; c=relaxed/simple;
	bh=g0+8um30tNRJg/0GXRdi4gujSr793XJM+gEEHYwBfF8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LeVsCRFOzqxyVI0zi3S9E6ib1mKeY9VtbiqVDx3Z0lO+PmnjP3S9S4DrP9BtiKJYW4lOYhf/mngi84kmT3UkW/hvAy3CVuwCc+RPqiwJijzT21TrN6gn3tQ2pFLY8Wp6NO72bLr5f4t/JBj6bAJVaDszueY1uaEckyLnQvW6w7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qd/MDuco; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qd/MDuco"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477212937eeso38460165e9.2
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261147; x=1762865947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tEhk53Kdg2McQ7kEFZChXYgWniYrcrYlWUXlRqKFifw=;
        b=Qd/MDuco0a9XEoItUOGw+paCgvQPzmVLnYqZriYcd//w6q7x+rBVHj1dxIYPlqOgqZ
         /TDB8VLHNa+rIKPx2OxNlsutHouoWBmca46mEnb1iX1P7odPtN9B378kRIrH+gfLa0Z0
         ieP8L5L7H3rESdpcXsfzgvMGkgku1z6/4JLD2HsurHa5zS2+52XVJzBEfb+gMhcnECrI
         02QqFcctIwk8cqoW87taBGaNxlTLYX9w9JXkgj8DJOozP1hmJefq1z/PnMVAiwqjpFWd
         v2Nhecu+Z+0u+Wrd/K7AKN7LWE+C0zELNLuz64vmZ52llXSqLWgG5P7rfR4fP92TYSfA
         NzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261147; x=1762865947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEhk53Kdg2McQ7kEFZChXYgWniYrcrYlWUXlRqKFifw=;
        b=Tu8dHeMQxOwq1Q7VowW7YXTyBxVREyTFhsvkIHUyyLusPe1igVllrO8OdweAsYl9si
         gn0B/KcWhU63UrjYNx/6/u+MbLdIvssf/k56SuEFhdkfgOb7dLsMyqIhFqTvD2jSAHdj
         vJeeOXVfT7VA0JC6Wyx6u0x9y1Xx6O/iwTDEhhdZfO7vYBmeNP/L7T4bQWi16ok91tqF
         3KdE9sofsEMNYsr2Ppg5fxvYaYdHGUIxCmE5Ku4oz46YhYZfJ+o0q+vc7e1XmCuEOrg+
         S9moftGwLW00b4Cp5HnXmU5pZU264kp85i0/Wtg+OVG5vBbUL8FFDrGm4ZA/iKIlFYvb
         Vyww==
X-Gm-Message-State: AOJu0YzNTrbBnSdf+hIEoCpUMvwq6V1nhGLJmUUHCkywz1PPLvPfgnby
	vuMiH1cZoza5ysTt0F+NmGUNcqF7GdC8ia1DB3UnB/meebmHIv6QFbBL3V8G5ifO1ZX1fyVMlXT
	/AEr4CICHjFkxDSQHGWmhkAsLW3SedAaZetC4UkCe0XQ8VDCX66P8xflo6d0VlgcBQcwYjqEEPB
	EQm/mX30HB5/eSv7NnBSQvIGaSWFemjBs=
X-Google-Smtp-Source: AGHT+IEZahmzHvSbXgcmOaFfnt77ZN5FH4+ydq37xDaR1EeBlo2SdF0monKofs2zPRa1hAPchxrZ2/XsdQ==
X-Received: from wmfv3.prod.google.com ([2002:a05:600c:15c3:b0:477:561f:772c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5252:b0:46f:b42e:e394
 with SMTP id 5b1f17b1804b1-477308b0a6amr150505065e9.41.1762261147550; Tue, 04
 Nov 2025 04:59:07 -0800 (PST)
Date: Tue,  4 Nov 2025 12:58:59 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-2-tabba@google.com>
Subject: [PATCH v1 1/8] KVM: arm64: Route MOPS exceptions to EL2 when guest
 lacks support
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

MOPS exceptions must be routed to the hypervisor (EL2) when the guest
does not support the feature. If the guest does support MOPS, exceptions
should be handled by the guest at EL1.

The existing logic was inverted: exceptions were trapped to EL2 (by
setting HCRX_EL2_MCE2) when the guest supported MOPS, and left to be
handled at EL1 when it did not.

Fix this by moving the setting of HCRX_EL2_MCE2 from the feature-check
block to the 'else' block, ensuring exceptions are only trapped to EL2
when the guest cannot handle them.

Fixes: 84de212d739e ("KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e..0f8311263edf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -684,7 +684,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
 
 		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
-			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_MSCEn;
+		else
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
 
 		if (kvm_has_tcr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
-- 
2.51.2.997.g839fc31de9-goog

