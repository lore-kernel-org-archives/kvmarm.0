Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E0214A84
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273615; cv=none; b=FS+fHkqpOIzRMEtm3eE4N9N5ti9xAO+F3XolHrXM1AXWK2lnMzgjKRT1PzBMRGoec1GKpDNz4vXWNIzXQHIuQs+01CgX0bI+9eu2aBdpbNKERWVWYuitvbJafmHwpLqAwrMFBpf4eBFj0ReKPiBy9sjSz1llP3u+ZC0CKBkboV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273615; c=relaxed/simple;
	bh=zKCUSjVz3cIU/w/OoCor7X8dBnq3eXyDAyja505kohg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i+0eiOXFJdZoN5mtYiD6NxImZxoKhZnZZsqgB1mA/2UhuAfy9aokxZGXbhBhQSeqbL5hE7qSiEcjwYAJW6Orgoio8eEOqQ1vpAW7v3jbFrsajXkjXrr38Tg9WE7GLw3jnaTYbOQKGWwb5MfFyzuzv3zRldtWa0lmv6j//uBfA0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FOdKcbqy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FOdKcbqy"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6eeb5ee73f0so31081157b3.3
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732273613; x=1732878413; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TmRVGUs6nkxwhsO2iucDTdvS5A9kO2wSDYZR/UjMPwg=;
        b=FOdKcbqyI+yKYltVKVqfcNvBAaYFO55Ys8fndxxp/CZvPFSS6b24190bpgPkh/L0G7
         beiw4VR+LGbPsU7495iViEuAgBcBFGeW6wHU5jZP4n9kBDE7vo5AnRAbSPaL4exyC9Uf
         IWgDWBI6Ac10AFwlnXAgvFEEOPfr0y2jH7JkPLeVvPH9IWmniFJDXkR8SvAUnsJ5n1KO
         dOKjsBHfGh3YkJvIK8X/DgeaqNh+/N7G1zS+V9r5HXSlGvx5BMT6sicOFqKRItvUeu/u
         kmclLYnAE9XzLtdPkNLCQ+ODIK/gUmhAEMcshvjyXVXdiuyyQ5Xd38M+zq8nJTi/nddT
         PR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732273613; x=1732878413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TmRVGUs6nkxwhsO2iucDTdvS5A9kO2wSDYZR/UjMPwg=;
        b=DCtWiWq1g+rHx/9itZbytPZclUKf4agAKfgyoswoe/2JI+kzHd38TWQryuzE9GpBbl
         Cr0djzagV9tZEmQnElGXAyI9bSMHLTZTj+UaZa2FH0YPtHvV5ErFPUSLlbqJH2OBouWR
         jru0xadVZNkyXpNaKk+VLAmppl/Eya6+kPxIz8GWh1TDxxlTJygjQEDVc8TgLuZ7uE5R
         kx3tHFFcq0WhA8+53KGb5PKxwSw8s9MqnQMnN85B99JHR1O7i7vY/tUXVDSkHLmNi3rY
         f8BPEajqkDcyF7oVpDfdFCTIsiFzRijW4c00k5vn7P55CtSXMOR5SIzq0qrPZsrqu3cn
         OpTQ==
X-Gm-Message-State: AOJu0YwINMfU2efeEG4HTg1UDN0dsfHCnOtAjknzCYJGvW0zQ6n5UDTe
	Ac1u1TEWs7YmuUOWXevJ3dKWM3se2wzPnstogzQxBP5hJlaEnnJaVe0U9FDINNiaWFB4Sn5Y1zB
	iURduLW9SoKRFiZ4iTY/YwhjxSaKHuvIcZqw0IAFm8IPBfa3CM/wO5O+ebLP/XGHut0czhvz5Bm
	b/2hWu+YxNnNXvYoIP4q03vCZqX5g=
X-Google-Smtp-Source: AGHT+IFDY0g1fhzMzp9VrckEOC6u+svSMuwV073QrPa2hQhhHhGdZ5PW9AlHSxPAec4RYBV0SLxm6U1zdA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:d809:0:b0:6e2:12e5:356f with SMTP id
 00721157ae682-6eee0a3cd59mr62337b3.3.1732273612814; Fri, 22 Nov 2024 03:06:52
 -0800 (PST)
Date: Fri, 22 Nov 2024 11:06:22 +0000
In-Reply-To: <20241122110622.3010118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241122110622.3010118-13-tabba@google.com>
Subject: [PATCH v2 12/12] KVM: arm64: Fix the value of the CPTR_EL2 RES1
 bitmask for nVHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Since the introduction of SME, bit 12 in CPTR_EL2 (nVHE) is TSM
for trapping SME, instead of RES1, as per ARM ARM DDI 0487K.a,
section D23.2.34.

Fix the value of CPTR_NVHE_EL2_RES1 to reflect that, and adjust
the code that relies on it accordingly.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 2 +-
 arch/arm64/include/asm/kvm_emulate.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3e0f0de1d2da..24e4ac7c50f2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -300,7 +300,7 @@
 #define CPTR_EL2_TSM	(1 << 12)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
-#define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
+#define CPTR_NVHE_EL2_RES1	(BIT(13) | BIT(9) | GENMASK(7, 0))
 #define CPTR_NVHE_EL2_RES0	(GENMASK(63, 32) |	\
 				 GENMASK(29, 21) |	\
 				 GENMASK(19, 14) |	\
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7b3dc52248ce..6602a4c091ac 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -640,8 +640,8 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 
 		if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
 			val |= CPTR_EL2_TZ;
-		if (cpus_have_final_cap(ARM64_SME))
-			val &= ~CPTR_EL2_TSM;
+		if (!cpus_have_final_cap(ARM64_SME))
+			val |= CPTR_EL2_TSM;
 	}
 
 	kvm_write_cptr_el2(val);
-- 
2.47.0.371.ga323438b13-goog

