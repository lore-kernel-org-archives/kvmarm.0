Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7213D70819
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767801; cv=none; b=A5iLLvXsaF/W91vacCjV/M/pDhZ2coX2P/I3Frlrn4QRRgA5T2yypVP72ZojuQYWOX0e/y9t6fyIgZgTo/x68dhfWFfjIXSNrNxrzlk2uv4/ADcZxR1Q/w96HF9NJnUCtrBEad6v02ZJJ3CQM4XkTbnMzJMNr204iupczkNp51Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767801; c=relaxed/simple;
	bh=+oFpkbI7gOEUi3i3I5DQailLRFM2o3MeJqgmFT+bRKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DpnTlkCFPzUlGxUGdG2Ef5snVL9c+E+8MvmLZ6bzqQLMNnDgSjrmm1xGFt5PegTrP0ZYB2Nvq0UdxiKGx7VIGX4NyFQhL6/ZtPXabg4+223f1Hxqr6OHWph/QzlF8k7KziaT8qBicdgokUVrFmoiE7CvX/fVkv6j1jXvIwz8QV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VQ+fwsJ3; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VQ+fwsJ3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlCpTqgieoRR9eYK0tQLBaW1q+3K/7BBWsPXchZbcFI=;
	b=VQ+fwsJ3ngaeCwhApxmW/PlbWiTYfs8WHWocHJCsh3RdaZQrJD8F3SjgZcAuXIfLgJAlUo
	/JrXuUoBp+l/1ALUUKQA+alqhc5DX3kgx6UfWdoQM67/QPcK/KncDkBraFJruGOVa/G9o3
	Eg2/qkuldoDZ6icjJe2hFsyYZY04fZM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 06/16] KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
Date: Mon,  9 Dec 2024 10:09:16 -0800
Message-Id: <20241209180926.2161373-7-oliver.upton@linux.dev>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

No particular reason other than it isn't nice to look at.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/guest.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 12dad841f2a5..1fe097c67766 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -917,31 +917,24 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	int ret = 0;
-
 	trace_kvm_set_guest_debug(vcpu, dbg->control);
 
-	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (dbg->control & KVM_GUESTDBG_ENABLE) {
-		vcpu->guest_debug = dbg->control;
-
-		/* Hardware assisted Break and Watch points */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
-			vcpu->arch.external_debug_state = dbg->arch;
-		}
+	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
+		return -EINVAL;
 
-	} else {
-		/* If not enabled clear all flags */
+	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
 		vcpu->guest_debug = 0;
 		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
+		return 0;
 	}
 
-out:
-	return ret;
+	vcpu->guest_debug = dbg->control;
+
+	/* Hardware assisted Break and Watch points */
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
+		vcpu->arch.external_debug_state = dbg->arch;
+
+	return 0;
 }
 
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
-- 
2.39.5

