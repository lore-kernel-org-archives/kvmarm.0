Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479141DE896
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104701; cv=none; b=ptR27nx99MRNah51138hpBW3RiAQ1qa7p0/SBLF4wWzia+6i1y6zmqgYAcgoE7xlXIdj+jiIYeQACsgDAIyiXR/uhdATTLhwWnwn23mtkbDxUzMgiGjGIsgGHtTy2C6zVmhVNLO4HzrZ92NgRyo0DbfcSUxvpqK9sc6oF1JjwWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104701; c=relaxed/simple;
	bh=OLJlJKOeqvKyhXnMJKXzF+6/z4A1+xh7jHmNWrxKKsg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KdOR/IEG0BMUimkAv5hjNMkfkWbdOfTqoC5Jr7DWg/3GjYCIzIVWhnsJHnHNiGxcpaUP3Lc1oDFmCwAOOAtIjX1PArOplgKZ/su5cxBp3389hnTpvABqUPUyzfUowRDx1kNWw+9ObkQu5Tt9NIJh9+w23YYtzwmjV73dJ0Ec7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oF/Z3c/l; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oF/Z3c/l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTW9B0UfAW0+vnxUx4i1/fIr0zC83ABk+cgXUEJE7Gc=;
	b=oF/Z3c/lkqzDwv9JoT51qnAanzNTdW9XW6f68bIDDJQSP2y44Gxazg9ko5DekSMNval43w
	WA11rmey9TQKvyHC0r0O3uSkWOEQKFZ1DuzH8ACzsXmGMrCyOx7NDa5upjWKwWutcT6CZ0
	zsM3KywSf3dX0Rk4pjD2H3Vx2JYP6Cw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 07/15] KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
Date: Fri,  8 Nov 2024 14:24:11 -0800
Message-Id: <20241108222418.1677420-8-oliver.upton@linux.dev>
In-Reply-To: <20241108222418.1677420-1-oliver.upton@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/guest.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 962f985977c2..b72eec27adc7 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -921,27 +921,22 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
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

