Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B7482C60
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197260; cv=none; b=m/UnwntSCXK+rJewBN0xlkhEfrbbjZQKcfTItPmSqsKekFwlMCxSug9lMdQEYHMLiCrbPjYSuxpXBk5iFYBap5I2lbJBItlgfMnDM0XGs1qzS2EVty7hnSb1i0izQqfp4gu/ARkx9FottiW2HUak3KRxM98ZgnXHAemxZaAAdEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197260; c=relaxed/simple;
	bh=dMUw2WdIZGyeyPjbDPAEMq2gq7gWylZ6lGyECOA/OPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK2w2pMSqg5UfW52PP0zhZ+c8GeJ3Nk68wUPcSRSMxM5tSVHKjBRifXPLk02ODZgmqf+2xZTLxefE6n7Ow7kBha1ngZ6JIseNbTj9G3y8bs8i3Lh3dfrJlLzYg/0tjB5ZG7MNXWixMspgQWe7fg32uttFCW8etN9NQVbpJrvU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gPlvOMEW; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gPlvOMEW"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yDOpj0JAWU/kyX6VMSuC51c6rBO6d3wkNu+wfk0xV4g=;
	b=gPlvOMEWhS0VbGq+NbQlLbbmv+ZgzP4SMlGVTxnGM/8B/nFQc3HYxqTtRGHTOMoweRHI/V
	uIssixXH2EArMdsQwZmUSZoEZzsP6SICNPZipwqfiTUX4/YvBJHpMB1PThBCBvigD6FWaZ
	3WxTlN1K1zpKKc/eLL4QeUU+4V+j9zQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 02/11] KVM: arm64: nv: Forward SVE traps to guest hypervisor
Date: Fri, 31 May 2024 23:13:49 +0000
Message-ID: <20240531231358.1000039-3-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Similar to FPSIMD traps, don't load SVE state if the guest hypervisor
has SVE traps enabled and forward the trap instead. Note that ZCR_EL2
will require some special handling, as it takes a sysreg trap to EL2
when HCR_EL2.NV = 1.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h    | 4 ++++
 arch/arm64/kvm/handle_exit.c            | 3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3dd2d80d0cfb..e86de04ba1c4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -641,5 +641,9 @@ static inline bool guest_hyp_fpsimd_traps_enabled(const struct kvm_vcpu *vcpu)
 	return __guest_hyp_cptr_xen_trap_enabled(vcpu, FPEN);
 }
 
+static inline bool guest_hyp_sve_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	return __guest_hyp_cptr_xen_trap_enabled(vcpu, ZEN);
+}
 
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 59fe9b10a87a..e4f74699f360 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -217,6 +217,9 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
  */
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
+	if (guest_hyp_sve_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index b302d32f8326..428ee15dd6ae 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -348,6 +348,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)
 			return false;
+		if (guest_hyp_sve_traps_enabled(vcpu))
+			return false;
 		break;
 	default:
 		return false;
-- 
2.45.1.288.g0e0cd299f1-goog

