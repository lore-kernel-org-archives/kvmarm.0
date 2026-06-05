Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446143D564D
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780685601; cv=none; b=E01rTChsve7KQcLi6dgRoHswYuVCtYJlcaU3Ggmp0jHMWc0eihsFIiwuRuERA2wOCkZv8QM92Sx5K6MI4MbMw5UglUKhCWM6NBtKJaoC7MSMY49aoTGQ07mJfcH+ZsvWKS8yXS5mVLikPbIacR2A29srmAPco7dfPfwUljHuTFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780685601; c=relaxed/simple;
	bh=LXJ4N9M7Q2HKVuHJiqod/o5k82b/D7efOXXT+s8XorA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SxoPVtD57ctW5AY4NpjcKeFk1rP414EmzGVJJwqGm+FZthR9lvMGaHdJzjwALYtHD/0oz9yePzkx034E6USyQw16M6IEBg5MWl42Fn6Mraseh5Ia7WYvf7a6C47HaSR07E9HIiSXnJvXI+lWHbp8I63QuDhw3RzXv62/nVPKg+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AMI5okhr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AMI5okhr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A84947D8;
	Fri,  5 Jun 2026 11:53:13 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D85C3F7D8;
	Fri,  5 Jun 2026 11:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780685598; bh=LXJ4N9M7Q2HKVuHJiqod/o5k82b/D7efOXXT+s8XorA=;
	h=From:To:Cc:Subject:Date:From;
	b=AMI5okhrpHUmhc5NVTNmDPnAOcbbGme/mmAAZmNe98E9+W2v3TU3lBPqxHGunxbZ1
	 G4QEg14jmqDdYWMJhgb0+sF6MYCihH4r3gzPtUTJ6I6/OURExxvW24WLcln3bzDeZE
	 VFEHXDmxegfxEzB0N7eqIHJ3TM1bnfIveyeEjOrk=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH] KVM: arm64: Fix block mapping validity check in stage-1 walker
Date: Fri,  5 Jun 2026 19:52:55 +0100
Message-ID: <20260605185255.2431996-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the 64K granule size, FEAT_LPA determines whether a level 1 mapping
is allowed. Using the result of has_52bit_pa() is too restrictive, as it
also checks the selected output addressi size in TCR.(I)PS. Fix it by
only checking FEAT_LPA.

Fixes: 5da3a3b27a01 ("KVM: arm64: Expand valid block mappings to FEAT_LPA/LPA2 support")
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/at.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 2ddb5b5a055e..30e6fa8ac07c 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -564,15 +564,18 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	/* Block mapping, check the validity of the level */
 	if (!(desc & BIT(1))) {
 		bool valid_block = false;
+		bool lpa = kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, PARANGE, 52);
 
 		switch (BIT(wi->pgshift)) {
 		case SZ_4K:
 			valid_block = level == 1 || level == 2 || (wi->pa52bit && level == 0);
 			break;
 		case SZ_16K:
-		case SZ_64K:
 			valid_block = level == 2 || (wi->pa52bit && level == 1);
 			break;
+		case SZ_64K:
+			valid_block = level == 2 || (lpa && level == 1);
+			break;
 		}
 
 		if (!valid_block)
-- 
2.43.0

