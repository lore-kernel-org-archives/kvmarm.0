Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D1340BEE
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954738; cv=none; b=hZU2tB2hWV2Y4nw5jgIZOzcE6dL5oISJwBPB/W++elJoj/qGnVyRvkR87FtLrJP1Ce+PWZll9HcM+HMe3gXyeR5hBnjnti4yuadK6m67oh1TF2UUDykWLlJ0lF6Jr6cqgAw7Ez41+CXAahzXza8P+iNKdGM4UQwftd7B2K4Drnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954738; c=relaxed/simple;
	bh=yk9WzY1OkwwKygOrfXbh8Sv94QXjTL6XOZQWgvOLq/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SWrI1TZZtnmKoE7JpOjN9vIRN69HIJSvEPbKbNnRZKSAcKZko7CO8sclyo1cEXO5LTqvq0CuyC4oKr0R0HyDS2PGSX9TdV35ko/PJpBy3aDvfCoHYvYZZyRWUH+3lKD4RPEvDSsSwPu63A90EXBZ7zSGgi2lbAAHA2LdRtCMeKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbPkutwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbPkutwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA33C433A6;
	Mon, 22 Jan 2024 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954737;
	bh=yk9WzY1OkwwKygOrfXbh8Sv94QXjTL6XOZQWgvOLq/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbPkutwoDysvDIIRw2IfQ71aevSYsxGsqzZcd6el//5xsrkdAoXtxvCddH/awoyeq
	 15adomAt7yujT8fES8IRm0MRpUdFheNPTCVCosxtB5rb6NEsMgaXg01jHR2dK4IkWb
	 sE27N1WQPFqgdwYVZCEoTQjE6a92nMD25qlDdECYA6YfQs+GyYKcZKviN/VkPQRJ7p
	 TPxYCUQmjbvyfQeEWrEA4k28527Qz3HcKcqkyf4N2zSb2m3b0FCCffHwsYaOvtVAGE
	 nF8KNXYJ0UfcJUz4ut+yOlePY//udNBBlCg1wH//42LsbW9FhQE7s6crgpfDwj+fwX
	 UUFUiz5OABjqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0kx-00DjkQ-NR;
	Mon, 22 Jan 2024 20:18:55 +0000
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
Subject: [PATCH 01/25] arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
Date: Mon, 22 Jan 2024 20:18:28 +0000
Message-Id: <20240122201852.262057-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
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

