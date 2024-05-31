Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1476913210F
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 23:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197271; cv=none; b=WI5sfoIYe3oxtIBep4Vmq5NUNKFOqbISJ6tqXHD6yWrfs2MnSRXFlTdAz3tF/v5FFiLxwtg3t00tdEGl53idv3Y8AeCITWD23ieMNR/figa3P97sdGnrbS79gcJ+7Qg3bQZ0m72K2YST+DQUavt4RCUltZF7WA9qSqV568iuxxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197271; c=relaxed/simple;
	bh=R7yIcMpUMHz2/6zuVxreAZEvfkw8+EJoWnedY5S6AkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWgZS9t1f6Xy08eq8ao25jIHl4ULyAdr+w7vKxwjw1STAycaTQgjYetAg87pa+Ccg9V7X3RyUMyprOEOVMfI4Jdntk5Vacw4E47MDprKSqMZPE+Jxf2rPrUnPFgi0v+Q7WVA7u/fb7kG5jMAkXGHWJ1LpOtTFMHbfGlcryIAvo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nLfSr2EE; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nLfSr2EE"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dLj+sS8bfnZwsflhlK/uP7qt7UV7JOO+rAZQrmf8q6c=;
	b=nLfSr2EEbO95NdG9Oe3fiY7I4IlfLAJmwDyBxT76SnPf5cf/lB0xt9TrCwqgdyJUtPizhC
	5mtzE6zKcCwYLmDRyEYvNGcPJfiIgqn0Q5N31XxSKn2hr40OVmt4/Q68i5800GYrVh6qBp
	agv3nsiy/1MVMRgvhTNLJjBtMTbS59U=
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
Subject: [PATCH 08/11] KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
Date: Fri, 31 May 2024 23:13:55 +0000
Message-ID: <20240531231358.1000039-9-oliver.upton@linux.dev>
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

It is possible that the guest hypervisor has selected a smaller VL than
the maximum for its nested guest. As such, ZCR_EL2 may be configured for
a different VL when exiting a nested guest.

Set ZCR_EL2 (via the EL1 alias) to the maximum VL for the VM before
saving SVE state as the SVE save area is dimensioned by the max VL.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/fpsimd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 53168bbea8a7..bb2ef3166c63 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -193,11 +193,14 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			 * Note that this means that at guest exit ZCR_EL1 is
 			 * not necessarily the same as on guest entry.
 			 *
-			 * Restoring the VL isn't needed in VHE mode since
-			 * ZCR_EL2 (accessed via ZCR_EL1) would fulfill the same
-			 * role when doing the save from EL2.
+			 * ZCR_EL2 holds the guest hypervisor's VL when running
+			 * a nested guest, which could be smaller than the
+			 * max for the vCPU. Similar to above, we first need to
+			 * switch to a VL consistent with the layout of the
+			 * vCPU's SVE state. KVM support for NV implies VHE, so
+			 * using the ZCR_EL1 alias is safe.
 			 */
-			if (!has_vhe())
+			if (!has_vhe() || (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)))
 				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
 						       SYS_ZCR_EL1);
 		}
-- 
2.45.1.288.g0e0cd299f1-goog

