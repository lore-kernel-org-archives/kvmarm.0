Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBB7198A11
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797342; cv=none; b=WXSol84jwkXbrY6v6Cr91dwMtGPC1iAo21UxxiVvlqS7cEgLoiZD65hrgX8my0+2L3Fmek5Xtpz5b91ipJm0cww4zQ46zaWd9HVJGkQwD257DPrhZjcGkT7IOip3KCU1ZiUfkzQu1u7tzphtmw7n99ntE/s+IQeB5J8oo6pRKiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797342; c=relaxed/simple;
	bh=XvHH0W/7V1pRBB3ZibOj0QhJUoHjo9dp2MjInUw/Lzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NT/kdD946ltTV3J2flP+Pi3xXA39dDRRFrB+T1bClHJnaJW+29TTYpOEgrC0ElWQbwG89bRL8YT2tn78ZMyehCksSkzN/2fxdh2vER4c8JFMUxlFOoQvRGOrrv7s48GMamv+BJMlSXn+4F48uhheOhTZ45BKZLHQdvJ/tSVjTo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HaCsg5za; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HaCsg5za"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4349f32c9a6so5855655e9.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797340; x=1733402140; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C3AEmgqEm+cvkyX+Y7gfd4xBQC+JlaYoJMIK/6vkrhU=;
        b=HaCsg5zaOGcE8Z9iMZsY1yrTVeIV/eWD6v8Sy55kCSZhgrxdippGNvuwjJu0zpiA7x
         s2m1cy7k89iLgjH5DUahjZLiByAsnMNUDoR9lI1mV5zXreJKdBbIr/Lj3gOYkFDo7WJO
         hNtWLLSyi0hXJFFCPn+5hff2CH/oUCc4jPNS582lAcQvlWJBgyxeWbDW+ZAdsjSUR4NY
         JY0kjxngCBdelMuEx/cpKZ87zvU+Gf6JWuwAARRRWXS7gh+p6qaO6oS86DrKA2GGaNyX
         mFy3RjE0xonaeMPVLve+XilfqTtx3inWonKU033MGTRrlb77AEKVKz1CXoQXWfoH02bu
         mreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797340; x=1733402140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3AEmgqEm+cvkyX+Y7gfd4xBQC+JlaYoJMIK/6vkrhU=;
        b=lfZFH/Sho7dx3brRd94qlAn6NqZpVwZqUpMGuXJME7VcUzR4pD/wHqBzaZrVMDP/3V
         va/kY0CLX20Nln/fS4c/AUl5TN9V1BzB2G/aJ51LFin1IcUbym2/OlJGzzbqRHITK5xG
         uIt7nyozEJpqMHI3lX61c9iaaTK4I8s5o+BxNoACOpU3jm2AkKQc5NsEXRq7Mc8SkaKq
         e8qKH4vzYwVDsrHfbexv8qKuX3H+Sw8pfykXOPlTgyKC3RgtiXzytZMpM0O5AH/Mb7ug
         awHgvYztUEgYg5+HdFvYQ2crI6uZaFgi+9Xg7cTEOSqt7eu9Ndaw9knP2nNhZHKzLToG
         ILSw==
X-Gm-Message-State: AOJu0Yyn5w6IjPUdvyyXm5rNjP+OcM6AN4hHb1dW+lcm0Jfj/ZfpOVVp
	8dCoSicwU4kwcX8CJRkKMyfN6sXy904d4h2ad6Ynsw26ViWDSwyHj6zgvZdwuNsZ81cjvd/PooX
	tLC2n4waQbbbmJ0rn9ExXDnHJIMPiJjwFPsNFY7uUXtbrdjnzjBB/2rMTq2lr9aWwOPcBr47Nee
	e8MXDoOI7MfxZyYU9jPTxziHfkGZI=
X-Google-Smtp-Source: AGHT+IGowe/R/6RjexkHq81NuzVdHzhVxL86z2B2+36Nlrd3p5Is0CztUoSrf2Y64aRbSlgs+xXTiAvw1Q==
X-Received: from wmmu24.prod.google.com ([2002:a05:600c:d8:b0:434:a8d7:e59b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b24:b0:434:a75b:5f59
 with SMTP id 5b1f17b1804b1-434a9dbb06cmr75327445e9.3.1732797340049; Thu, 28
 Nov 2024 04:35:40 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:11 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-12-tabba@google.com>
Subject: [PATCH v3 11/15] KVM: arm64: Refactor kvm_reset_cptr_el2()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fold kvm_get_reset_cptr_el2() into kvm_reset_cptr_el2(), since it
is its only caller. Add a comment to clarify that this function
is meant for the host value of cptr_el2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cf811009a33c..7b3dc52248ce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -619,7 +619,8 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
 		write_sysreg(val, cptr_el2);
 }
 
-static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
+/* Resets the value of cptr_el2 when returning to the host. */
+static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
@@ -643,13 +644,6 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 			val &= ~CPTR_EL2_TSM;
 	}
 
-	return val;
-}
-
-static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
-{
-	u64 val = kvm_get_reset_cptr_el2(vcpu);
-
 	kvm_write_cptr_el2(val);
 }
 
-- 
2.47.0.338.g60cca15819-goog

