Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275CE23E334
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452637; cv=none; b=MqFAr89hv8Ab34e+6q/DuqGKleZc7X0rOoANiWbs9ZRPPRUptIepDxMEfJjXmAnF3Mg1xJgvtTU0EEYqBm+4YbnXYGj5JEg+Ej4EtjWFJID3tNHwtuSJWgV12kT0dXFi78DeO+xx3AX6kVKZt/Kog6VmGrobuqUXUvWtF9wV/J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452637; c=relaxed/simple;
	bh=4NI4YbXlZQ+Hrykvr691ZaobjrUfrAdSa9UBSGJ1ROc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egm0TEbxfGLzEFYlhuX55QPwlB8dZnqrYyUr8VVvyT/l8ZbJUFbV7bDZOCP4PBNNJFScTmVDMosPEdnOSyy1frHhJvqQFszNEflzjf9su2xgEt3CVCUBMhVPkxTz3LaoApaIVlodf91TxhbEfB0mhZK0LDKctXaXf0k1K1pKaKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1y+ZBX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1y+ZBX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7082C2BCB0;
	Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452636;
	bh=4NI4YbXlZQ+Hrykvr691ZaobjrUfrAdSa9UBSGJ1ROc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1y+ZBX4+AMI+PWt0fDw3GJWRfFJD+TaLiJ+inPy9LqA0twVySXLAYufrEICbelyA
	 SaH15BBd7K/YrvSY0gccXzEhVhDtqbmGKhcMM6CJ++axfnuaqgpWgEOIWIwKoRNHDJ
	 +tCIOvDFUZReNL73qtFwgY7bhDnE7NsYtUYekGo62XypgIwJvx8HDTKqaGgyb9RSS5
	 rMXcVuVVz8EXwDrPg/D78cHRyutXGjG1WdBrgyBj0NQGRv/KrcMmrB5cb6M9px1tB7
	 bofpiligij0o3S+JPwLS+dQhoe5aCJW1EOJWiIjdN7cJcMVOsON9LdvTZlSJqzdrZX
	 ENgU5CIF4avNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1tj-0000000FDFJ-0WGu;
	Mon, 02 Mar 2026 11:57:15 +0000
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
Subject: [PATCH v2 10/11] arm64: Convert CONFIG_ARM64_BTI to FTR_CONFIG()
Date: Mon,  2 Mar 2026 11:56:51 +0000
Message-ID: <20260302115653.1517326-11-maz@kernel.org>
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

Even if the kernel doesn't use BTI and doesn't expose it to userspace,
it is still OK to expose the feature to the rest of the kernel including
KVM, as there is no additional state attached to this feature.

The only purpose of this change is to kill the last user of the
FTR_VISIBLE_IF_IS_ENABLED() macro.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 1af5f5b0c48a7..b3e94ad3f08a4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -318,8 +318,8 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_MTE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_SHIFT, 4, ID_AA64PFR1_EL1_MTE_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SSBS_SHIFT, 4, ID_AA64PFR1_EL1_SSBS_NI),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_BTI),
-				    FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_BT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_BTI, VISIBLE, HIDDEN),
+		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_BT_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
-- 
2.47.3

