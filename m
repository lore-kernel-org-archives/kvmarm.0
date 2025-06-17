Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7973D21CA00
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167463; cv=none; b=TH+rgww4NF6jVaxUmod3PXMJJV6MMpVTmgYwjB2Ex6Ualojw0sgd4tuTczKwnBqbcDy1/Gvs891ZjT4s2Ql7yYAAD/prVeoN5wotvPw/0oacHBkziTQeqTK/lNtKVHzSLWBFvqEyjFKPAzdqmfMvvOZHZ6zjIUlnbkHt8lOBrss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167463; c=relaxed/simple;
	bh=CRrQrQa6BBj/BkMwaNWjh8/VRkAWGpg+AprDLpfOwfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lcbDF/5x0dzgiQOv4Wvn3bIjjMfqJjHh7dkWoKPVaRUmfW1rgcRJAbj4m6JnTaPjv/GsS40pTH9XUsrQhiZEHwfM6lSrbK/CRg5ggb/ONA3ZXEK+Cg3pqZHtZnm2ZFK4TlHJ0TRHeSY7hCSHEhWnu9EWraRUQbg2+4kvLdl3x14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDE061595;
	Tue, 17 Jun 2025 06:37:18 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2001B3F673;
	Tue, 17 Jun 2025 06:37:37 -0700 (PDT)
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
Subject: [PATCH 4/7] KVM: arm64: Remove ad-hoc CPTR manipulation from fpsimd_sve_sync()
Date: Tue, 17 Jun 2025 14:37:15 +0100
Message-Id: <20250617133718.4014181-5-mark.rutland@arm.com>
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

There's no need for fpsimd_sve_sync() to write to CPTR/CPACR. All
relevant traps are always disabled earlier within __kvm_vcpu_run(), when
__deactivate_cptr_traps() configures CPTR/CPACR.

With irrelevant details elided, the flow is:

handle___kvm_vcpu_run(...)
{
	flush_hyp_vcpu(...) {
		fpsimd_sve_flush(...);
	}

	__kvm_vcpu_run(...) {
		__activate_traps(...) {
			__activate_cptr_traps(...);
		}

		do {
			__guest_enter(...);
		} while (...);

		__deactivate_traps(....) {
			__deactivate_cptr_traps(...);
		}
	}

	sync_hyp_vcpu(...) {
		fpsimd_sve_sync(...);
	}
}

Remove the unnecessary write to CPTR/CPACR. An ISB is still necessary,
so a comment is added to describe this requirement.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e9198e56e784b..3206b2c07f82a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -69,7 +69,10 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (!guest_owns_fp_regs())
 		return;
 
-	cpacr_clear_set(0, CPACR_EL1_FPEN | CPACR_EL1_ZEN);
+	/*
+	 * Traps have been disabled by __deactivate_cptr_traps(), but there
+	 * hasn't necessarily been a context synchronization event yet.
+	 */
 	isb();
 
 	if (vcpu_has_sve(vcpu))
-- 
2.30.2

