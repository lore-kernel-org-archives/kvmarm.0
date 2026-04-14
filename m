Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C87C8E6
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 00:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776125043; cv=none; b=Ch0O3Ljy7RjkXa9M3DKxPKDDJiragVTiDAkRmPny12sJ3Dqmc4Mhg2JlfGg903ZB857xq5Jlyr0/Tl9EwMwLY0/bqWYMWoTs2YPrafaeCPWw4LB/fhP7A3iK0HWmSY22m8F+TNh/f5fZWBHgfBa6ZS4/Rtg/Ltm5fE3f0FjMtqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776125043; c=relaxed/simple;
	bh=m6x/63nnfpg6KYUYTu5KqOD4nFrzdvwE6G7muugTYuY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CHfx4/9t7riGpNOcAjqbIRbdEHxu2aVvfChBJLUKLnBQf7fkLBuoTS3rsUTKgRLTcOTdaERs4vcSNJOhvOktLn40sVPpH0yZK5zeq07nVrRE2mG4BC/XC4u/oN/fpEJRSDadLJLQ0Di74MbD6oGbHL5LDj3z4FvTEV3Sp262Qao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pC5yaf0E; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pC5yaf0E"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C0914E26;
	Mon, 13 Apr 2026 17:03:54 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10E4F3F7B4;
	Mon, 13 Apr 2026 17:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776125039; bh=m6x/63nnfpg6KYUYTu5KqOD4nFrzdvwE6G7muugTYuY=;
	h=From:To:Cc:Subject:Date:From;
	b=pC5yaf0E+ADbte4ZRHujJmQZlq1k4KKzSDIIeiUoSp4HCnfLajY7PUTBZHYw06Tzo
	 S37+n/p64em1CL0VSJnWZ2ux1ojw4vpypkOe3HrHQpaBQsRJKolUyXYuQjJ+stZui5
	 AVPOPMSJTdZfVDpZl1+Ci/ZgQR0S5EaWg7DcY8Rk=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 0/4] KVM: arm64: Handle unsupported guest translation granule sizes
Date: Tue, 14 Apr 2026 01:03:30 +0100
Message-ID: <20260414000334.3947257-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v2 of fixing the granule size selection for software stage-1
and stage-2 walks. Thanks to Marc for the feedback on v1 ([1]).

* Changes from v1:

  - Take the entire (v)tcr value for TGx decode helpers.

  - Rename vtcr_to_walk_info() to setup_s2_walk() as preparation, also
    pass vcpu as the argument instead of kvm.

  - Use TCR_* instead of TCR_EL1_* definitions.

  - Return unsigned int instead of u64 when returning a granule shift.

  - Split unit changes in get_guest_mapping_ttl() and
    compute_tlb_inval_range() into its own patch.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260406164618.3312473-1-weilin.chang@arm.com/

Wei-Lin Chang (4):
  KVM: arm64: nv: Rename vtcr_to_walk_info() to setup_s2_walk()
  KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
  KVM: arm64: nv: Use literal granule size in TLBI range calculation
  KVM: arm64: Fallback to a supported value for unsupported guest TGx

 arch/arm64/kvm/at.c     | 125 ++++++++++++++++++++++++++--------
 arch/arm64/kvm/nested.c | 144 +++++++++++++++++++++++++++-------------
 2 files changed, 196 insertions(+), 73 deletions(-)

-- 
2.43.0

