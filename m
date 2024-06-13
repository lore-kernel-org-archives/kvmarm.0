Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0E137905
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309930; cv=none; b=ljjBKiKeuQSBEAPNF6W30Z9iPDkWuqQn/oAq+pCvzBpzzmyEnNOngBCSUpg2Y72x3TEiTmepo6VSlV3mFytLK+JEKDWewllHRi/6oFDNof2qmabGMxL5VEqPfYRbXGqVFXNKq9lIojsS6IxGLx4Uk0KZ+SN9u9ZZ2GHvPDs0xnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309930; c=relaxed/simple;
	bh=vZpSDKJJKCBjmfKgXHhQnUdls4VJOb7g3qqn5Q0IhkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkyt0kB4JXZmetAp8/ZnvSudBTBhOQa1pbzlwuW3IjKYz+eu2oKw8VgrLw8w+TrybCWv6J+nNyZ+Jr07xBz6bWGuuiJWpXzUvyuNMOVUeKdQMh1qqY0fKHWLaI35B7VvOrubJQdw7gkqEtBUbsfGncVVu34FpusSwoscvHXL7eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OMQxiMpG; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OMQxiMpG"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/N4HwIRI6RfqJ7tdpRm7rKOSFshkwGH2p2wXo67EDDE=;
	b=OMQxiMpGOoL1yIxsLirg64xUne/nGRwrfF1POVPpRqb9rMyEaZUzwTKVR4QOCT8f9tNSqh
	80g8hCuZ2AZH88jAAjDL5Jj0vtyVMqESIdrsHv3d3MCIiDrkM+VN6kgqPW4r1Cu8DN1Mit
	QqzDc2YriDBUhf8UkMmrnmNpil3rfaA=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 09/15] KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
Date: Thu, 13 Jun 2024 20:17:50 +0000
Message-ID: <20240613201756.3258227-10-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
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
2.45.2.627.g7a2c4fd464-goog

