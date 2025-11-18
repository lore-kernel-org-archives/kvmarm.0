Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833231C5D6A
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462295; cv=none; b=WGKByE65mi4ZIBHAML9lcIxiwMbmpVkjYcJ/X4eobdr3yRCAvKiGTGX8LTKrNRlMOtXh6d4pypDWGyidBZfubzjw5K8lMdPy2BrLdKuG1RqqppmhWZAn74UvTLDaW4PSN5ql0oVmabe4qY/oNkRogO5yGrc8HBzis93b9hJbECY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462295; c=relaxed/simple;
	bh=AHIAKTHu1jng16/69rXAAmwEO4giOQCGKN0y6PR2WQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L/ZGe/oz/0Eby7A2Kj8gNtBdUaThp/nMuXtCzEhKFFIg1tbkxCGzN7nvZkT5qlMX7gZ1jA89EP0cZoB+oyw4mBrYSbhXPBzPdpoSrOdI7wQNWns+1iYj1Z6FvqBXPodElp0w7ZlzGeq1bz2ok5RxFcdd/OpDtgXDS3Jlmrz9yBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JEKbfmIS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JEKbfmIS"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4776079ada3so53303925e9.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462292; x=1764067092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hEzrs1bcMGvMfGKWugW2xWeP/+eyY67q4E3S5ZrMLoc=;
        b=JEKbfmIS4WLlLNbFMHlkjR/qR0pXAZm5XAHUKc/b0ItaHw+wQlwcezrbF+t1XQLWGL
         e9uT2ugTXmQxxGn5vzXvqmPoshi975jA+yymt6k/cpbq03fpRPc/E186tKFt72yLWFJA
         8NjmR9Fe6HyYcGAbomJvXNXlvo0V3CGWDiWwA+/+fIWCaPgEj/8jn0ktx5g4moNxmZi3
         hoQH6Vak9iKhQMD9dVuA3SVBkBsDEu/B2D1n9hGY1T65owHoLItfEyWkpDGhRZXScCxl
         W7ac/Mv/+FEEnZU2RWB1m8gw1t13H9arDLRLs060+C1a/Mvpl4fLRIJg3PMHaFBCnnan
         RxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462292; x=1764067092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hEzrs1bcMGvMfGKWugW2xWeP/+eyY67q4E3S5ZrMLoc=;
        b=RtRGhKDLqtqsSJcL6VSu25J+QaW+6f9MEi61uur0K/g49W1abxQnTg3URzknYUGu+i
         0hL/CdO5Kos44r1zkecmgD478c7Dl9Ktt7Qpa58pusvwJzqYxs5y/AFN+i7t5B2L9PoJ
         W8JExQO4D2IqMH0weyl+baiAoN1clU/a3IIfNtEzdzQVrywxrnX8swyXyRnI5NZ4b4ij
         xautwjzVfaMt4vdnDnGKvFfubcrE8d/v/knv/DqSF3rYTV600EDeRfGofLos70Aq3Yka
         z1+/MsRRGZ2Dnvlfb31lPGxOJiUbRtwmjt/xfJ+AUUYRIdbF0206Kz6nzQdGeUxrgpDl
         gwTw==
X-Gm-Message-State: AOJu0YwjqigkZUg+ZK5DsYNHnXTTzm9Ioc2AAoftYjOgPpP37gr1QnUc
	rT7HJ4YlECc7skNt2BRN09+hhvQPAEUvSJ9TJCdDDinDHHZXxp4wB117FWka3kxDgKu2G4IplRP
	bKZGzSe1sSJrBrDOyCGfnj9wmotqIFxTF88/YmQyhn5ju2aFtLDVSxsYxMn+Xvs1JPFMivneWE1
	Jlxz3NND+bKOTrH3soLPiUe0FoSioh6a8=
X-Google-Smtp-Source: AGHT+IHFQDgqPSt+i42V89C82dLqTbY2fbZFbYSCIA/ML32nRVS15POSV+9Zopnaba7Rh3hzgq1EmMF8PQ==
X-Received: from wmbay36.prod.google.com ([2002:a05:600c:1e24:b0:477:7893:c737])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4453:b0:477:55ce:f3bc
 with SMTP id 5b1f17b1804b1-4778fe95e33mr139318735e9.19.1763462291876; Tue, 18
 Nov 2025 02:38:11 -0800 (PST)
Date: Tue, 18 Nov 2025 10:38:01 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-5-tabba@google.com>
Subject: [PATCH v5 4/9] KVM: arm64: Introduce helper to calculate fault IPA offset
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This 12-bit FAR fault IPA offset mask is hard-coded as 'GENMASK(11, 0)'
in several places to reconstruct the full fault IPA.

Introduce FAR_TO_FIPA_OFFSET() to calculate this value in a shared
header and replace all open-coded instances to improve readability.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h         | 2 ++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 2 +-
 arch/arm64/kvm/inject_fault.c            | 2 +-
 arch/arm64/kvm/mmu.c                     | 4 ++--
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..73abe697bc2d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -343,6 +343,8 @@
 #define PAR_TO_HPFAR(par)		\
 	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
 
+#define FAR_TO_FIPA_OFFSET(far) ((far) & GENMASK_ULL(11, 0))
+
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
 #define kvm_arm_exception_class \
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 78579b31a420..43d7dfa2c517 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -44,7 +44,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	/* Build the full address */
 	fault_ipa  = kvm_vcpu_get_fault_ipa(vcpu);
-	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+	fault_ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 
 	/* If not for GICV, move on */
 	if (fault_ipa <  vgic->vgic_cpu_base ||
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index dfcd66c65517..c9bbce017dee 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -258,7 +258,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	unsigned long addr, esr;
 
 	addr  = kvm_vcpu_get_fault_ipa(vcpu);
-	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+	addr |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 
 	__kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu), addr);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..5b159cf0d203 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1959,7 +1959,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 		/* Falls between the IPA range and the PARange? */
 		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
-			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+			fault_ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 
 			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
 		}
@@ -2059,7 +2059,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * faulting VA. This is always 12 bits, irrespective
 		 * of the page size.
 		 */
-		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+		ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 		ret = io_mem_abort(vcpu, ipa);
 		goto out_unlock;
 	}
-- 
2.52.0.rc1.455.g30608eb744-goog

