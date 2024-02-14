Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3352B1A58B
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916713; cv=none; b=aqf6Vt7I4fvtaivx7a+UwyRyG3u/UI9kV8dg/3K+IPptVhCA6ZYAd7VvZlq0ErJpeLTPUAa8IBa3BeHgFS2bsjQu8OwU89l2yU5BcpyewKOO1Yz5rQR2ZlXZ0Y0TL6Pa3GJDhU6kMdeM1BZVyBNVMRTL06SBJqdgrTnc3VUzoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916713; c=relaxed/simple;
	bh=9Vsgu4gJOf4jI0IRQ9JR0eGd9nGeKlEuw7398GwLIoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W+LymkcA77KD7TaLM/OVkiorBdFcp/NQovdPZK022o3w6qKsHxXl8MEyTBlqQJDzwfKLMzA8hyDder/C+i5T1eucOMTOeVqJ62cq8MzGhimvPJgz6HEUaC2xZlAWQTgHkHPT56hFONkarw5pXlH9KtOg4QVgNK5a/Y/pEwHZiRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qnkp3rUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qnkp3rUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8F7C43394;
	Wed, 14 Feb 2024 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916713;
	bh=9Vsgu4gJOf4jI0IRQ9JR0eGd9nGeKlEuw7398GwLIoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qnkp3rUFxujG+y93w7Y6Yuk/Q8mBpb+zRkeMvpW0pwLqkzjkNMId954VKvOyjE63Q
	 uxxz3jopk81RI+5nqUbUUm3rV3OIVOJQHq/puFHceRmrL/MhlY5rJfUcnYclMbwQ92
	 sEmP3TxVDEjPXHWSzY6Vc68A6zp+y/PRG/URBz99Nx/ZneGkzDiKiJudtCQesgjUAu
	 BfhfrOUDJWT+Kzz1HCiZNYKFi9cYBFoCiCG3EhKDvZGUMCh8jBbVtIwXN+a0uBoUg7
	 tsvSN2a8AxdIY2PRqEuG1G6mPlhbqoDKrGBwXqpUwWrbfFw0T8/MKvd18ofZqcXGpa
	 b3iIjg/gS2rag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9i-00394l-Oa;
	Wed, 14 Feb 2024 13:18:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 01/26] arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
Date: Wed, 14 Feb 2024 13:18:02 +0000
Message-Id: <20240214131827.2856277-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite having the control bits for FEAT_SPECRES and FEAT_PACM,
the ID registers fields are either incomplete or missing.

Fix it.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index fa3fe0856880..53daaaef46cb 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1366,6 +1366,7 @@ EndEnum
 UnsignedEnum	43:40	SPECRES
 	0b0000	NI
 	0b0001	IMP
+	0b0010	COSP_RCTX
 EndEnum
 UnsignedEnum	39:36	SB
 	0b0000	NI
@@ -1492,7 +1493,12 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64ISAR3_EL1	3	0	0	6	3
-Res0	63:12
+Res0	63:16
+UnsignedEnum	15:12	PACM
+	0b0000	NI
+	0b0001	TRIVIAL_IMP
+	0b0010	FULL_IMP
+EndEnum
 UnsignedEnum	11:8	TLBIW
 	0b0000	NI
 	0b0001	IMP
-- 
2.39.2

