Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0EB2EB850
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810061; cv=none; b=ISan7ba09l30f/YaB45T+11PfHQ49/IyYyyuiS0+Wcv1/zgUBmbIsw9MprwrOHev9DGIMTKKQkPt5p8XaBnC+hFvGUffltJzb5Uup5bSoasyeDtqP+hLtCFIOr4EPatfFCZI9K302evlNYU7FojNAd/JpHgkKjnMLmsXbfScEqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810061; c=relaxed/simple;
	bh=ABhvefXpoIuEQ5mRvyqgcnHqEvoUbf3IKbz3Y8+eKrc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OHtzK/xMUrR5gYxjK+X+63osuY0sWVXX9IosQfecZoaZDIrG2k/A/4MAV0d8cpr6hM/CPCdaeOo6OL18E4P+dhdnwBVBcYRv9BZRA8PS4iTPzRj0xah/hVkfOoX7C180IhkugOARVD92KceK670IGeffvX9l/QdKetMy9uXJ6FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p4zG0/lb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p4zG0/lb"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244581ce13aso29201385ad.2
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810060; x=1756414860; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qF0NqksTmsFEMXYPOijW2W+Po4z2kEGBRHxGZcBCgsM=;
        b=p4zG0/lbhckrXx1TRhslWFfhqqv+t46VPOgV5K9QA4v6QrBgK1PmjRS03ddbZkCKJW
         OO/yyCsJX1WS4O5lxcaSOZbmjVyJv4dPaoqoKVl1Vg+Bd4aMoAHysnmFb4fL+qPAz+80
         oK0agxXGRkyEWg3zMSdhDCZpgXSJBsy1h1bSJrspV8aCrlFXYLcuyk908/GoyBNZPd7J
         hhhMgI2Ei9QImRVpO7ft33iv5cpK0ymMw4PYnKHCNhdKA3ELZKt9u+HHIT9OVFRXGnAw
         Nw6TjHMDd+LiphjKTPII+N1S+KxjxWS2PhX8b2pzv4oEDYVzUFz3/i/LCV1/Jjgx4oow
         BZdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810060; x=1756414860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qF0NqksTmsFEMXYPOijW2W+Po4z2kEGBRHxGZcBCgsM=;
        b=rIG5gC/r+1hfccaAL9pfyavnv0GJ3aksMQ6B4eJF0N3bQ3KzxzxxiYsz0TblA1Q4im
         d1YKF9XjRkkqAD5KBQWhO5RTrjT2kIJ/0Ep81OdvypzQaVTyuq+bp+z6vE4Zp/Wv95V8
         G67eLl9UeQoyMqtzcAXEQR+YhAkB2C0WzsKzZql6aKy/x2rwXjTagSxlzGsvwP3fYaPL
         +tkUgPCWxO8yEYYRMuatFq39VLoUnQxFCAN+jFQMQUBW8n1Zju6a+IefJJJ7+iF35Q0v
         AmZfz6pNkT41c0sFd+p554OuaNfszcRcvaw8paZXKc9cI/5bSZ+XQ3Q+SENdmM9+ziKM
         O5nQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWqirWqbfSVk/lLlx1PeekiPakuv9wfGlBmDpSmVBptM5kcHCP7IEYnyqXLop2G20EGTs86RY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmcxOYrSv+cJpekot3Osk0Hf1QzCAKcR8FLIhqbI4FNmdxTleY
	oK3QIkjkOyJ7qvkAFlIKwYfEOreiJMWR4FshJa4YPYr2D8OKd15Ky+IyHe19t1QJ+Wb0+Ydve+p
	QNN/iDw==
X-Google-Smtp-Source: AGHT+IG5Izpq2Sl1N9Hzv50wRfJpmndOfATaks3Z+gYK79D4NeWWn/zwR5Uaz/7EA8M4H+pgD0lOKvSxa0c=
X-Received: from plgv17.prod.google.com ([2002:a17:902:e8d1:b0:23c:7695:dcc5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce01:b0:240:52c8:2556
 with SMTP id d9443c01a7336-2462ef44433mr9049685ad.39.1755810059747; Thu, 21
 Aug 2025 14:00:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:34 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-9-seanjc@google.com>
Subject: [RFC PATCH 08/16] KVM: arm64: Add helper to get permission fault
 granule from ESR
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Extract KVM's code for getting the granule for a permission fault into a
standalone API that takes in a raw ESR, so that KVM can get the granule
from a local copy of the ESR instead of re-retrieving the value from the
vCPU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/esr.h         | 6 ++++++
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index e1deed824464..5bb99cfd184a 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -8,6 +8,7 @@
 #define __ASM_ESR_H
 
 #include <asm/memory.h>
+#include <asm/pgtable-hwdef.h>
 #include <asm/sysreg.h>
 
 #define ESR_ELx_EC_UNKNOWN	UL(0x00)
@@ -478,6 +479,11 @@ static inline bool esr_fsc_is_permission_fault(unsigned long esr)
 	       (esr == ESR_ELx_FSC_PERM_L(0));
 }
 
+static inline u64 esr_fsc_perm_fault_granule(unsigned long esr)
+{
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
+}
+
 static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 {
 	esr = esr & ESR_ELx_FSC;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fa8a08a1ccd5..8065f54927cb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -455,7 +455,7 @@ u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
 
 	BUG_ON(!esr_fsc_is_permission_fault(esr));
-	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
+	return esr_fsc_perm_fault_granule(esr);
 }
 
 static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
-- 
2.51.0.261.g7ce5a0a67e-goog

