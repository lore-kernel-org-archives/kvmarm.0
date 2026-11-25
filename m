Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621157;
	b=R7/zJ5tH2ihSR4hEW/v+ia3EbBWDCX2tURUPVRGOyGNd/S2xLS6Q/Tyb/uZbwcHVuo57
	 j4nE4i4VSQPOBMbjfZTILtNoVzVYqVl6D03NGtehobBkEaR7/G9ROPQkq2kqrz3F8RtBu
	 3YbaFOcg4694EDqxMBeXUFLBzLNWZaLPJ9d3jI864uXu1l6tg+n+CIBsLTiPXMSVZvQrM
	 OFyBJEeRKObX4WrmjZ+0nR14s9rf9MvNjhkCQLDfEoqv939kpYIYHo37ByGIyNGT7NodM
	 lBDcvn85Sa2sF0eSYG37yK1e+X6CUJFQDQxGlcGKZC1YaIVRaqUKB/qEcQAh2J/B6dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621157;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eCGx1X8DR+pHjH9W44J3Lh82/2sl2cpI/RianqMEYjE=;
	b=A0kec5STGzT1lGQVsH2gL3TT411WyLXWEvIbnywxhVRbiNGyLTbAxKPjCeCLzBEF0FXN
	 FBTiIeB9Ruy6O5l02sFdy2xbR8vrMUVmwgE75/kukMOtB3LwVxeWAb1IQuSsWOAKtGP4S
	 MApEii6HzcB2wmQ4wFb97In9jV73X4EJovQCNu+WIpi0jt1w/u2PXAtaOBClu/U0GS2Rj
	 IOjnZ0JXtdEFqdnqmoTz375ejU/g/0f1/eRjheRQ2Oql0jv4OePQ6hmvh0nqBvsaeVywe
	 suRiaohmD0W7cOYtYPV3ap321rGGP27B0xBMtqr2azHyx6usZNcf0U4WYAx8UKSfTvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="uEGoc/GK";
	arc=none smtp.remote-ip=95.215.58.8
Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36F1606A335
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E36F1606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uEGoc/GK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=plWnGSA+t40iciXF75RUGdCCByZ2c9Fur5xw/PdG3iQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621155; v=1; x=1796225955;
 b=uEGoc/GKCvssycowstrnGLuAYNix5t8Pc/tsZFyFww3d1R3QZXd1AiauzmkCYdr5ziZAf+Rq
 DZivHihoNF5+liWvKQJuiUXgeO2xc6S/Wfmd7O9EAIweS5pW1AQ7WYrRyjUlRcr5UqVLh6NXpAm
 T8kirCGpv0l8GVxnfDEM08cU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cccc4519f60a0c77;
	Wed, 25 Nov 2026 15:39:15 +0000
X-Mizu-Trace-ID: cccc4519f60a0c77
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/20] KVM: arm64: Only allow ptrauth for a pVM on a system with full ptrauth
Date: Wed, 25 Nov 2026 15:38:52 +0000
Message-ID: <20261125153911.106793-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 allows a protected VM both ptrauth features whatever the system
supports. An id_aa64isar1 override can leave a system with generic but
not address auth. EL2 then doesn't trap the guest's key accesses, but
it doesn't switch the keys either, since the switch is gated on
ARM64_HAS_ADDRESS_AUTH. The host can read and write the guest's
APGAKey.

Only allow the ptrauth features when the system has full ptrauth, as
the host does.

Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fd042d2b54624..155ac35069245 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -76,11 +76,14 @@ static inline void kvm_pkvm_vcpu_allowed_features(struct kvm *kvm,
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PMU_V3))
 		set_bit(KVM_ARM_VCPU_PMU_V3, allowed);
 
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS))
-		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed);
+	/* Without address auth, EL2 doesn't switch the guest's keys. */
+	if (system_has_full_ptr_auth()) {
+		if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS))
+			set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed);
 
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
-		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed);
+		if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
+			set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed);
+	}
 
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE))
 		set_bit(KVM_ARM_VCPU_SVE, allowed);
-- 
2.47.3

