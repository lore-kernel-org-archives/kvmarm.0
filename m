Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A812356C6
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167453; cv=none; b=khTLaIStTPpzSxPAf6qB+dqCpGQFSlBfk/JSyDRIheysik0V6uccChcvtIx3BMoqSjGJ84m7IVk0W/DRygqzacWAhlcnCRMKzIFEOrpQ6rhsuYB41ybipEY5/rrgUpFoKyptv1l0tnUR6W3wyacHAYmKvyz5HXey851fPcvG2qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167453; c=relaxed/simple;
	bh=UrVxdD15CWzA7wot5nb34iSJalGMyLmizhXK/wJXqkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZHyNYamXW/hbW5GAyCrrzrBwJkm01T6+LsloDiB4m+DcvvtAOolPoFIf+liooKRACKxqQPob+g2WC6e+jE94J6r70s9KQbnX48t90UEMarplZ9LvFpZbr8S3IIHwbLu8qztZyRb3E0GCnrK/VNELPm8i9JzKr/ypKwmRcVZIlwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2EDA1595;
	Tue, 17 Jun 2025 06:37:09 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E7E7A3F673;
	Tue, 17 Jun 2025 06:37:28 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	stable@vger.kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 1/7] KVM: arm64: VHE: Synchronize restore of host debug registers
Date: Tue, 17 Jun 2025 14:37:12 +0100
Message-Id: <20250617133718.4014181-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250617133718.4014181-1-mark.rutland@arm.com>
References: <20250617133718.4014181-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM runs in non-protected VHE mode, there's no context
synchronization event between __debug_switch_to_host() restoring the
host debug registers and __kvm_vcpu_run() unmasking debug exceptions.
Due to this, it's theoretically possible for the host to take an
unexpected debug exception due to the stale guest configuration.

This cannot happen in NVHE/HVHE mode as debug exceptions are masked in
the hyp code, and the exception return to the host will provide the
necessary context synchronization before debug exceptions can be taken.

For now, avoid the problem by adding an ISB after VHE hyp code restores
the host debug registers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 502a5b73ee70c..73881e1dc2679 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -167,6 +167,9 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
+
+	if (has_vhe())
+		isb();
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
-- 
2.30.2

