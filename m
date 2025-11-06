Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC96F2E7F3F
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440266; cv=none; b=u1DgrnY6VkbQQEmYnKRCfWBKbSQyspuQngaEeEHYitnO4X9WHuTzxSOfax3X3sZwss7lsfU7deCCw7L9Lx49jIecu3NrrP30VoH3bfJDtN/4uGH/CoMkC02Yr1nkpkWc571TxjPVx84pqmMR0FjAEX32yqKnc6LamIQlBm4nHTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440266; c=relaxed/simple;
	bh=rH7qgbDeFMO703zYzaW/OJSQqAt1KpmJKbvdmlyfnWc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AEqExX1aZsZPNfDMbR2pjVNtLS+5XyG0jKWPp1AtE+9Whk0cmY1URIrdcmmUlTc5oM9NnI742gp6WWuOEBta4RU857eAnm/8F35/jZWGRgq1C1+SZzRTk1xs1O+5QDUII+UxZzRWvj9tm+29n90ewpR1rdxdvgsUvSosiUZ3LrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DxqqEWAc; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DxqqEWAc"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429c5da68e5so1154348f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 06:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762440263; x=1763045063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P7EffVnVauLlhDfmlQCcv2Y3+uVzlHVp+gu1a0fxy8E=;
        b=DxqqEWAcYsOdmv2s6wOUw0VjX/bv6cngiuOm1eAghe8OvYk+GHgOedgJsRYBSL7o/v
         /2Uat9XM+bVXl25EpfbHthKIzsELt7ThN2HckWuVsJyHumbuIC01mtYKhNUINzzsTFVv
         FHwIp+mv57ZjhY+8MythQOI92ZdhLdse6R82QUbEqx35Aez77w394JJkKJCVjZe8g7Vs
         A+blRa+q5lPHobLVEhyswmAw5RvH2/ATB+feuxWN6qydNiKTbUgqrcHHqyLAafSDx1xk
         PQoXv0VF+aUPGh01wIreYgpbf34Kzqa2knRAMCD21vgiom9h6FNKv1fpIOE/5rgYrYlL
         KDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440263; x=1763045063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7EffVnVauLlhDfmlQCcv2Y3+uVzlHVp+gu1a0fxy8E=;
        b=l30tAjgkUIaLKskvbmnom8wJa4OGI1Cp+JTbzAJeZhIFLrIE2L78Gn6t/bGPqMej0/
         ubOhxadZUA5DCsdKXECpVjaXXvfbK5iyIIZhJNTH4i52fybyG/TxrW2whTJ/D5f9YnxQ
         RVLWcJyRkqKBI4RWFYEJKPGhPTFiEYiXshY+/+7kIIodGK+D3x9HueWdV3FGJENkP+XS
         wbB3k9+Vu/yLAuYr/SF+tmjxWyqwg9jXxQ98QNbolKCV6QRI5VgR3rvO9MFILgj7llH3
         VSvErucztZSf/EUYbouZcgPItk1JQt3tvnF30KPEzp+99NrmOLlx8AKtVoOPR+3BqEQw
         qnTw==
X-Gm-Message-State: AOJu0YyfjGUXQ6exiNY/nLEKsWQ8rnUM9kpuwc6RdI58ppjJQhA2z//o
	i13pKFqdQvLAKF5U3ffjZGwzwYqqVUEWP3YxNflQpzettuVZL7hipM8M6DHw1US5n17j4j/a8p1
	3eTJkra6brS/BkRE2ZWKszAmdDBPI4eMx9JmeUMI3qn01i1ackvi7uKdpch5PDAwOz41jrqguam
	OtILEUIsRAfl/8HOkm8+qPmIQK7ZVRiQQ=
X-Google-Smtp-Source: AGHT+IGzPIs4yUyp+6UXJhAzMkFp36VtzGI2h7GEa6J21ujrjoiWaogpRDCbFX9snCJSgthaq9rVJA7/qQ==
X-Received: from wrbfr8.prod.google.com ([2002:a05:6000:2a88:b0:425:57c9:52a0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1848:b0:429:cb8b:b58e
 with SMTP id ffacd0b85a97d-429eb1a2b33mr3770171f8f.28.1762440263044; Thu, 06
 Nov 2025 06:44:23 -0800 (PST)
Date: Thu,  6 Nov 2025 14:44:17 +0000
In-Reply-To: <20251106144418.2847443-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251106144418.2847443-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106144418.2847443-6-tabba@google.com>
Subject: [PATCH v2 5/5] KVM: arm64: Define FAR_MASK for fault IPA offset
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This 12-bit FAR mask is hard-coded as 'GENMASK(11, 0)' in several places
to reconstruct the full fault IPA.

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
2.51.2.1041.gc1ab5b90ca-goog

