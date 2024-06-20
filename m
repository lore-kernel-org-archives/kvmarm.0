Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D671B47A5
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902038; cv=none; b=dDL8qVMNkHEssiC4Lb/NpJgWmpy3FTUXCwtvfifiKzNU7DqzVxBrR+d2ota/Jkf/jSpTVm4M9PmgFPsEs54f6cG7TN1qhK3N48mlSg+h44FQ29AoB8oguDmu695PNoZCetKXxAdDTExpWZCgg5+jAK+QMM5N93TwU+zjURTwklM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902038; c=relaxed/simple;
	bh=MNEsSbek93dEnKdVXcnjLptk0/WvLnHiuamXW0WR44Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lldtu1zkoj9LLRBOuOnqju1BZWDiNcMVGdP/KxFRYi7rIKSYo9OpWhmBxGudlE/9hWLTNTaO5avE9aTzywI6rmbHoCJEieHj/zW3tMm4Atvm9PoHVt3h6IdZq06m2Hrw302F8vQvEwmpKbIpT5imPdbgn7jUikEuYUd90kqyeWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rsK+rQQ+; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rsK+rQQ+"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OrPYUpaXTuyZ913QZ9yyjlNewzvBDOPiUFlx9T7Nkio=;
	b=rsK+rQQ+9aA/3JKjxRutx3Pi7Aun4Y0Akv0UNklkxhdcuKVFgZjGzKCsO00McNlrT+/4xZ
	0SON5H7smqXy31KH8a3mAcVSDz+JJ1osKXrW2/fENUzd1WLOvx8GfJasygRMsv7l2DAKBA
	wdIWNT8+x3Ewn3g2O5RSVLXTchla9mU=
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
Subject: [PATCH v3 07/15] KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
Date: Thu, 20 Jun 2024 16:46:44 +0000
Message-ID: <20240620164653.1130714-8-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
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

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/fpsimd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index d948f1c684ca..947486a111e1 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -190,11 +190,14 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
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
2.45.2.741.gdbec12cfda-goog

