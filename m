Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145491CD2E
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707475051; cv=none; b=S5LnGJTkBfVdL6+fl4t3/RUF45SLsRgiWUVva9ZyLU/UinP6s5CgyU9/sg0W/0540D/3/aJsi5VnBnOcFUmE52zWCafHCqxnKsbazASu5tpXBb8VBIoDs0J1zKsZXNNQqdFeRbncKidOpiiZbkg0Nj1fK5xi+/0jgYi6ZG7GlGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707475051; c=relaxed/simple;
	bh=gREOrAGSPJgndiqESZcjrywvzLWOugfVaiU57m46WW0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mb9dk61HONhRTtDsG+1T7UWv+yBU21Ie/EbUeIHNphuY59fbDG9dGJVou9Lrg1UqLOmsy4tFokC0HCbDCUOujvH863xrEPsTTvtCUWDFt9R9xqf1iVpkvsecvPeb1qVpPl9I5IduTj6IEdWOTRR01TfTlEbAjcXAjSakbTwCYbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83C20DA7;
	Fri,  9 Feb 2024 02:38:11 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F15A23F5A1;
	Fri,  9 Feb 2024 02:37:27 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v1] KVM: arm64: print Hyp mode
Date: Fri,  9 Feb 2024 10:37:19 +0000
Message-Id: <20240209103719.3813599-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print which of the hyp modes is being used (hVHE, nVHE).

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>
---

From what I could tell there isn't a way to tell which of the two modes was
actually booted in, and this could be useful for looking at log outputs.

 arch/arm64/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..090dbc954157 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2591,7 +2591,8 @@ static __init int kvm_arm_init(void)
 	} else if (in_hyp_mode) {
 		kvm_info("VHE mode initialized successfully\n");
 	} else {
-		kvm_info("Hyp mode initialized successfully\n");
+		char mode = cpus_have_final_cap(ARM64_KVM_HVHE) ? 'h' : 'n';
+		kvm_info("Hyp mode (%cVHE) initialized successfully\n", mode);
 	}
 
 	/*
-- 
2.25.1

