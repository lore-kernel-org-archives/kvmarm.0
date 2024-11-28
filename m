Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E92B198A11
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797345; cv=none; b=Wih04UnNrKpdpz2jrOWnn9vLhZ/wKZr8e9tQcl+ClRv3pIv53d02//rEd4kgjDtTWYdnfWgjiNlTiWfum8gZBcGnHwDeTEyaEbPsYLQ9NG7tOn202sLWSCK6lqOcXgKT0vDEXFWMOUEKH+Z3h3dZL9/ka+uTv4qmmPdEJB23cjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797345; c=relaxed/simple;
	bh=MTY2H3Auab2VIXlBY0r2PYSSEKu0VmctnjJ6ypbLHwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hVeM1lPB2NwRw/LmttzPQKfoMGgFADCInnZu9MC1LMWtqhoXkGbeqF4mmiaFVGkjUG3LkvVZkTRmQXjQDmCHN8M5QEyEEt0+VqkSbwn74d0mpEhKQZSBVK/WL1BqcTC/RRIYvykvo+yW/ZvKyOsk9oObtrI1+HyPS+dYAYgAb64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QX6VOuMv; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QX6VOuMv"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3822ecd84b3so399148f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797342; x=1733402142; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGNx4KryUAWkUrEyK556nEdWmNkAb7CXLB+nZikEwWs=;
        b=QX6VOuMveoURoCu7zab/cEpMWywLOxsfc31pxx+UvtKmaL2bViwASDvd5hCL70ywC/
         oKo+3hOC30TYHCkGVeJRKLZT9T04BkXDitM0HhF593kyyX9t+qYAhTNUrkxGj+1EbAox
         EanbW6Q9a+Mm8PAjuJ+UJVQx8nIWNujzRNf9pi9BBysFmUkADaqV6r8h06RdWqxZOrbg
         FS8rqIA3Ik2L/6KHkQzdZPS2B58KfwpbKp8dPpvsMy2aj/DJUgE9H4bUMQ0BTGOrzBV+
         gso1E3NH27qJ2aF4UI2gxyi0U9CrvR7fi0qdCwTNbGbcFNomzT6O3rEdazWJS9CuNhUt
         wCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797342; x=1733402142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGNx4KryUAWkUrEyK556nEdWmNkAb7CXLB+nZikEwWs=;
        b=s6TSjNV+NqD0nLtprr1nZTmeQEgdmJNgkCK8ssF3oO+Ajn3GoAG6asPmV5M4bHvGPE
         icXg8x6UVFJAZDM7B0EP+VY3AYGyvYIvIe1HlDbmGeoAdTRw4KkOi0UP3awlKlOTsV8b
         R1FSm8TH/6fZDmlDfmQ7A1Ut+AqKMy+52imWbYMsZQP8vu2PVOlXHIw4h4GqJ1ZjCDKO
         xRFiJaI3WbRdj6l5Ap8Rg+ed3kcZWh1gkYcQqQRDT0+0SW4fGmrihhRVnUdDs95gNiau
         r93w6pABjE8dR9Odx8q8PhX/mvSuXMd8WKnAoRgj4NRNIDIxNL1Vpgry/UGKdF0m0773
         REqg==
X-Gm-Message-State: AOJu0YwRN/tS6DgjDGiKYZWWWDv9jOYOpcFnRiEnOAq03ClkkhdEPhHw
	lS8ADAJv59CJCwWdCdo8IDXW8uQnqKyRzTrX+ylgpZlwv9013TugTcpz0npFQKysUNZfkFei6z+
	8KDfRSERuyibCXhrawj4WZhNNXrgPYOysMQtByfCBqpIcnsreNfP3vkVnctzRc02+mtBY8w/kwe
	zcsHz3IM/pLrq3iQxqhhGQQzZxdVU=
X-Google-Smtp-Source: AGHT+IFLI3Jh7eWipSkuJnJEhB0CPELVPrf0f9jEJFqCsPBLEldQwio+BPzXSPDF2U9CoUeaJI7R6c0Vvw==
X-Received: from wrfi10.prod.google.com ([2002:a5d:584a:0:b0:382:5479:b8cf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4708:b0:37d:4fe9:b6a4
 with SMTP id ffacd0b85a97d-385c6edc3f2mr5536291f8f.50.1732797341940; Thu, 28
 Nov 2024 04:35:41 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:12 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-13-tabba@google.com>
Subject: [PATCH v3 12/15] KVM: arm64: Fix the value of the CPTR_EL2 RES1
 bitmask for nVHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
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
2.47.0.338.g60cca15819-goog

