Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6697F6AB3
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 13:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AEAC4347C;
	Tue,  6 Dec 2022 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670332338;
	bh=dv+KVGFURAIGGp8DpF1u3V9vTqz2OYDx9+1P9dJ9++M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj3eSEfe0clNKqCTNy8jbf15KqTWEZrWD2dggML10ZQ24Qz91dYR4qF/tV7cnqu5o
	 kjX1+qtuJLFpID+9LChtkQkKd3hArJ3zm4nVrVUa/vYIdvre+mEo616j3xmNb6Xch9
	 n2kSWX/iYaRPBW6DvgS6+0J28Zz/CTGzRT92dC/WX2XsMz/5SyecDI2NLBC5MHiTPu
	 NHmHznFZUbh99DZ0YvNXXXs1PlV8dOEH3eZhe3zdQCAmJX/Pt/dU5s+kYeWuZh1hgd
	 Vwux0/9hQMgQhFYULtOSU0AaGs86ZteSBNp+AeNTvglN5MYo9rUIMMGbbNnkekQ6Ys
	 x19bnhJyiL2Tg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 1/3] arm64/sysreg: Add definition for ICC_NMIAR1_EL1
Date: Tue,  6 Dec 2022 13:11:42 +0000
Message-Id: <20221206131144.115774-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221206131144.115774-1-broonie@kernel.org>
References: <20221206131144.115774-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=594; i=broonie@kernel.org; h=from:subject; bh=dv+KVGFURAIGGp8DpF1u3V9vTqz2OYDx9+1P9dJ9++M=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjjz+NlsTeYnm6F9aqrIHGfR8JxFVbgkV7USQ7rO3I Mn6hbDaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY48/jQAKCRAk1otyXVSH0CYzB/ 92eCEyQudjI7JjJ7e/lE3w/h4LXzBPc1SGI6fRJTxeR4xnDn/kbjavs7K50aT1mOHwFQneYkvkDtQF OmLZVFMWAdhagEqb9s5DH7ldeTwT+0Ke6o/3f0WWt6L1D+N/TknKKgiMb74LR2wMzdKYkA11LuAahL 3YNcKV/2oKG0Mkv7U8Z76BEsXTZeISqUX/3m4Q/MDhDkvZBpRvGslmvIhJYApAawOH3DV7kGaUy9yi TflCvJlg3hEhRU7vCiy1spT71ujRI1jEhRAzlPQhdRO3L2KNX0SiH/tTospaUEsdxqZBZfi/HPeMXK AwJiwrTPwhnCOrqDPa84NgSw60AnP2
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

FEAT_NMI adds a new interrupt status register for NMIs, ICC_NMIAR1_EL1.
Add the definition for this register as per IHI0069H.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 384757a7eda9..5d0d2498c635 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1078,3 +1078,8 @@ Field	23:16	LD
 Res0	15:8
 Field	7:0	LR
 EndSysreg
+
+Sysreg	ICC_NMIAR1_EL1	3	0	12	9	5
+Res0	63:24
+Field	23:0	INTID
+EndSysreg
-- 
2.30.2

