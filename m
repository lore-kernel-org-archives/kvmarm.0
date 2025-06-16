Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76C63BB44
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115190; cv=none; b=JXwghMA779mCKz8BK9F3pXilgMWv0J7iMjyuxA6+Ex79IY6Ewho/wcYf19PkQiP2SLxKaC1YfEcXEb1YaEjPHPItZm3N22K71L1zxLkmMn4XRTUkp5ScGhpP40ZJ2gXCqctJsO8/moNk/q/hyFdieE5RlF+phXidWFw/0YVNvxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115190; c=relaxed/simple;
	bh=rF0Onj2vxUiBtuFjftTxLxwFJ7CHucCO4A7nI7PjJIE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j5wacIhzk8SE1sJ2OwPm+US1RVpO/q7rf0iyk32/i9ci6OWAFJtluAeRacQFH5P03/n8TOt8EYGRWT3JavCkvH1d+tVtq4Cvo24JYqt+Rn4nSuw2begeE1O/y62GfjJO52Pttffi2dto0tIMwxAHM/w+XqBfe/bi+2pzv3NM0zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I3TsMqig; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I3TsMqig"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sch2JKNwglEK+L3rGhOOEVV58J62dINCIpG0BaeyvC4=;
	b=I3TsMqigKMDZZmENIDteTQxr+xIcbDLAqyUYkgt1k7U684C1aW14+kH80cpSVpi3DfnOe2
	ZTQ1wtkiKJcivbXB/5vX9jVmHu11xjYkyWAU7dnPG/hjnGpsZxz6huKky6iXsul950K0+0
	gISLtCEtFEys6BCqTmVWyzcp9S2wxF8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 23/27] KVM: arm64: Don't retire MMIO instruction w/ pending (emulated) SError
Date: Mon, 16 Jun 2025 16:03:04 -0700
Message-Id: <20250616230308.1192565-24-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
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

