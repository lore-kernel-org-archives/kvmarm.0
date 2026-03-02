Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65450337BBD
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452635; cv=none; b=f8cSI2j8l9DR5gHOWurzojrviOhwlIBUkPJkmdUhcgQhnrwKA9CwZCzwHR+azWtE0EbhBQ1EWUZ1UMYaglUT+8clwsIm9eohXcy9QRgHS6BDkwF/XikU9eu/BWehTqXUg8O+Qtk4/uh3Gmshvp53jCryUF31cKx9KNYgK5NiWSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452635; c=relaxed/simple;
	bh=03KzXW9o4wnm5Pioh4GRaVPRsT8qGqkIjVh3cZzOc2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2slRkXq4+FyjMX4zBiCnQSN5AoflSpMvVfJsCEAq1/225hxymBZAWuYAngwMMGYbKwVz4sO+Wzz7qLcghafbnS3G1+jQhzBLuyWzzci5W1kLwTsSB1T65H+NIIQst1kII7dFMJZqwvDs9alhchGEObv6tUIi/pVtYi2hFaPLww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTrjRrBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTrjRrBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9C1C2BCB0;
	Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452635;
	bh=03KzXW9o4wnm5Pioh4GRaVPRsT8qGqkIjVh3cZzOc2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTrjRrBAJoMNmuG4YH/dXUGZjwNJp6WEejIhEOZ1YBd2QLTrI2nTq+rF+3g8LrM9K
	 ZxsztjR8jMMJq3obolgt6KcsFi0CDCphv2MyzWbCHRUd5fjBbY7MZtRlBt1/hq+37n
	 bHuW8PIcZ1bMFvHobRycqvVy0R8hvQkdTa6Rr1JxvnAN+GSogcqS2N6Y28FmVITq6l
	 OnV075GNbHfUTAayAy4u+ecDDFoX3Ag0aPf2SgctFnWXniSlOVByVLt+fmCPq1f60L
	 HVAymUt8rOLy+VIfFIVw9M2nrbMzxZ16Ae4RzMJIk3wpgdyUJrTieXDVJDrDkRlODV
	 GCSczdrcvV2Aw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1th-0000000FDFJ-1H7U;
	Mon, 02 Mar 2026 11:57:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 02/11] arm64: Add a helper setting a feature field to its safe value
Date: Mon,  2 Mar 2026 11:56:43 +0000
Message-ID: <20260302115653.1517326-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302115653.1517326-1-maz@kernel.org>
References: <20260302115653.1517326-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to make the code more readable, add a simple helper
setting a given field to its safe value, and update the only
user so far. More will be added later.

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 28fc77443ccd3..102c5bac4d502 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -926,6 +926,11 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
 	return reg;
 }
 
+static u64 arm64_ftr_set_safe_value(const struct arm64_ftr_bits *ftrp, s64 reg)
+{
+	return arm64_ftr_set_value(ftrp, reg, ftrp->safe_val);
+}
+
 s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 				s64 cur)
 {
@@ -1066,9 +1071,8 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
 		if (ftrp->visible)
 			user_mask |= ftr_mask;
 		else
-			reg->user_val = arm64_ftr_set_value(ftrp,
-							    reg->user_val,
-							    ftrp->safe_val);
+			reg->user_val = arm64_ftr_set_safe_value(ftrp,
+								 reg->user_val);
 	}
 
 	val &= valid_mask;
-- 
2.47.3

