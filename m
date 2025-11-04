Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8001A2EC57B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261158; cv=none; b=oi9U35HNEM7JwbbGdKRA00m2ZdhPN2vI+/D4M2a9WRZSyYgCzarX0boBLBLjCERpza1hjhFbgLGEZvCUItH9gpmfm4IX7iRPdLOLig0ovC1spev6/cFCnWZBsCe5FpOhDf88yYBsFWsVuSqRp1Dh5W+VSplwwdEG+lWe3FlrHHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261158; c=relaxed/simple;
	bh=weHZWsgI6gE723gtYQPU+G+nUSfn7eU9j54RBYV+r+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dCvOuly/J7M7rm89JA1ysT+0AbzyVR+/waOeaxAxhHexWwrF4EegINVB2IbCi8XVr1roOVS7cAbmEU8Pw72u7OWwoVcox6+pdlnaj1z5R78ldB6RG6wnHz7sdNhJ7XInz8f1jN5/bUXeT6rT/sgEMgEkcnerf7flsbPKMYuylT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gpBJ8AS6; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gpBJ8AS6"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429cd08586cso1372965f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261155; x=1762865955; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MzfKs1meZcxc8aIEgTcF+NFofqdV4KwxCeiYS7QeFos=;
        b=gpBJ8AS63H7Inq/mV+k+D7YFfmWy8M1aY+TVB8WNPpbaV+L8xgDvRWR/Kd9JgAfCRO
         jgWDZnA2b6zMDra79l04XeH8ivdfy4NDDyodtg0aMpi+ml4+mXf10l+zdS6GsCquu/Jc
         jzAX7nKIORsehYJWTmnoJZ13z1yw3JvGtyUSx66Fk9XxhQzZnxF9a67+7yKixlTCzu1Z
         VD3dgZZbBn6LWVt3Vss0ikdqoK2jS9HJMef/f7aTG6Va/2AOgGQQsYcfCrRb5/ZZai6X
         HtEyVFF0FXEiZd7djcf6mAXTLHVKLsER3zY77e3qIK5zXmzrKtGQ1IRupF8ATvn1Aiav
         g1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261155; x=1762865955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzfKs1meZcxc8aIEgTcF+NFofqdV4KwxCeiYS7QeFos=;
        b=U/Fi798uWHQwEWJyytEH1lSh97lD0JX6txdVAN99108SSdNlkz4FCE26K18iqW95mE
         Ghar//IZbGxWgxxfPvT46mA60epmCGIGWgVBD86IWpcGfuSS0p888iHRYbJzyQr/6wEq
         FvgG90uIjRD2HqAg7dtt0BhfOTzIdW3cF63UFYFja27emO9Fsikol6HKYanVqrcFidjH
         lQvG4h1ty+BYzaOKRQ/dfPuMlMzXKaT+lHIZTsYbwQmTVvf4mEuRu8a9xLsiVKurXwsS
         lXxk6focXdwe6a5vv+Mz4hIqUrW17uH2KLpZe4zFFHNapmjr4UIGAuUhi6if1s8WdeGR
         GD7Q==
X-Gm-Message-State: AOJu0Yz/+2RGU4QJqB+K1nRxAHI3nVAWYyl7NlvR8sMp5pyV8b1Jo82t
	OMAcIonCNS5kJaQm4ce/jfOUXl+R9Kz/Lidv9rj75VJjblbStKaFXAWpXC4ADG4r5CHzJGi7QqC
	axXCiKMtVlG8G7zvdrwdsAeCt035+pz2rmZxXNGM9jH3g0Ysb/YDCWRrxjkCNDzNdFRvqku8adD
	ip+8NVncvbPwsV0xBDtdaSt7iy8IvTFBk=
X-Google-Smtp-Source: AGHT+IHRYkO1/tIR1WAYAGStfsC6IBdc1crqUFMXQPt0Cl2jnlOTPv06xz5lhIxv8lUeuZzRrMw74GcB9g==
X-Received: from wmbg22.prod.google.com ([2002:a05:600c:a416:b0:477:14b8:19f6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e52:b0:471:734:53c3
 with SMTP id 5b1f17b1804b1-477308a0e33mr131579625e9.24.1762261154822; Tue, 04
 Nov 2025 04:59:14 -0800 (PST)
Date: Tue,  4 Nov 2025 12:59:06 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-9-tabba@google.com>
Subject: [PATCH v1 8/8] KVM: arm64: Define FAR_MASK for faulting IPA offset
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This 12-bit FAR mask is hard-coded as 'GENMASK(11, 0)' in several places
to reconstruct the full faulting IPA.

Define FAR_MASK for this value in the shared header and replace all
open-coded instances to improve readability.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h         | 2 ++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 2 +-
 arch/arm64/kvm/inject_fault.c            | 2 +-
 arch/arm64/kvm/mmu.c                     | 4 ++--
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..e995e9b3a0c4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -343,6 +343,8 @@
 #define PAR_TO_HPFAR(par)		\
 	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
 
+#define FAR_MASK GENMASK_ULL(11, 0)
+
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
 #define kvm_arm_exception_class \
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 78579b31a420..22898ed4dd6f 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -44,7 +44,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	/* Build the full address */
 	fault_ipa  = kvm_vcpu_get_fault_ipa(vcpu);
-	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
 
 	/* If not for GICV, move on */
 	if (fault_ipa <  vgic->vgic_cpu_base ||
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index dfcd66c65517..8ef3453696a2 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -258,7 +258,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	unsigned long addr, esr;
 
 	addr  = kvm_vcpu_get_fault_ipa(vcpu);
-	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+	addr |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
 
 	__kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu), addr);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..21a9442f9b1e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1959,7 +1959,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 		/* Falls between the IPA range and the PARange? */
 		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
-			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
 
 			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
 		}
@@ -2059,7 +2059,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * faulting VA. This is always 12 bits, irrespective
 		 * of the page size.
 		 */
-		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+		ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
 		ret = io_mem_abort(vcpu, ipa);
 		goto out_unlock;
 	}
-- 
2.51.2.997.g839fc31de9-goog

