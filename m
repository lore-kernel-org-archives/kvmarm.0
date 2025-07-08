Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C952E5B3E
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995724; cv=none; b=F9GYo7f4XreQmcMixNq5W6pIF80sHHl8Zztog7ID52S74ObcPew66XW3/L98otplVimpyWCgv7miAAck6f+8anRJXPCVj30aPggG3dKRhOh/IZs4mdtsp14YxCV4U4+RdF0pQxAQvjq9OkbsLbVP2cZwBikZWnTEdVOpVyrJUB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995724; c=relaxed/simple;
	bh=nq4t7RsoKmYLyF2RFZRX1L0n+n2imQ3z834Vi+27PRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=flMhJhNug2n+fHzQAfH735eYjbZ7kYdQ3FIwd0dKpWRxmEhD8Kj13D3GJSIcWlxpZM0FFkjdfAAg9zbDu8UnGcZmcGFj5tSaUBEK6gYOFG9py2hD/pWzi5bCpH4vZEeb+7HP/uEbo/LUw79cCOGXC/4lqP9IXZUwXk0qKQUzUmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fXFrPcBx; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fXFrPcBx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMa/66PffwYavXsjVTBE4+av2vAOd7SSWa6vEv40cGY=;
	b=fXFrPcBx0spxhiUuKtXzs/Li/bNcgdpf9j3qufvXBLBPiCsasCc1weNZ+FHQDUoRRWX5/0
	U+U+TAip1OwyZz1MmT8bV+2su2V+ZLZmejtPWgf1Me/ztsXarCeVl5296jZsZ0mtbRPnba
	qqG8eogHbciluke+LBDyijrqMt8empQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 23/27] KVM: arm64: Don't retire MMIO instruction w/ pending (emulated) SError
Date: Tue,  8 Jul 2025 10:25:28 -0700
Message-Id: <20250708172532.1699409-24-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM might have an emulated SError queued for the guest if userspace
returned an abort for MMIO. Better yet, it could actually be a
*synchronous* exception in disguise if SCTLR2_ELx.EASE is set.

Don't advance PC if KVM owes an emulated SError, just like the handling
of emulated SEA injection.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/mmio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 573a6ade2f4e..54f9358c9e0e 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -72,7 +72,7 @@ unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len)
 	return data;
 }
 
-static bool kvm_pending_sync_exception(struct kvm_vcpu *vcpu)
+static bool kvm_pending_external_abort(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
 		return false;
@@ -90,6 +90,8 @@ static bool kvm_pending_sync_exception(struct kvm_vcpu *vcpu)
 		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
 		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC):
 		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
+		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SERR):
+		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SERR):
 			return true;
 		default:
 			return false;
@@ -113,7 +115,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 * Detect if the MMIO return was already handled or if userspace aborted
 	 * the MMIO access.
 	 */
-	if (unlikely(!vcpu->mmio_needed || kvm_pending_sync_exception(vcpu)))
+	if (unlikely(!vcpu->mmio_needed || kvm_pending_external_abort(vcpu)))
 		return 1;
 
 	vcpu->mmio_needed = 0;
-- 
2.39.5

