Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574B81427A
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 16:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22169C4339E;
	Mon, 22 May 2023 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684772577;
	bh=69OmJkjw4vz6UuLeKe32At8mP5D9dT1Jr6f+G95j73U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P0oRwEQgpRkPdhBxHeu7agzbs74NOm5xgfmcQuhrQ6W4Iw2JMQAEdXxvApnhT2rfr
	 6clQw4CzU34F3feic7LgFg8TOtm9yco78HkqnIeM6UHiWrr9PI/Aw4IpgGZuWmoYHS
	 dl/Up09B9J5wxDZxmEeDGtnMdnJM10kq3UiecQAJdf+/oCl7GjcaesXfMVyjtHOyVo
	 ryzvYxJpnFVdAVPBDQduNefFDoCAWLvcExKicHhex8fxH3fHGK9mShJiYqAhNd8VSh
	 /KyF4fiWG54fFSEbYAWbnU1iynqA56rnQ5n8Vb/Tj5aKgmuQgvbBzEU77OfLeVswxj
	 zBtpshvPYU+lg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 22 May 2023 17:22:42 +0100
Subject: [PATCH 3/5] arm64/sysreg: Convert MDSCR_EL1 to automatic register
 generation
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-arm64-syreg-gen-v1-3-936cd769cb9e@kernel.org>
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
In-Reply-To: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bfdf5
X-Developer-Signature: v=1; a=openpgp-sha256; l=1585; i=broonie@kernel.org;
 h=from:subject:message-id; bh=69OmJkjw4vz6UuLeKe32At8mP5D9dT1Jr6f+G95j73U=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBka5bVL7ffvgZ5ePbP2LQRm/DpBM5HR4e0vEsXs6NJ
 Yu3gJ8CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZGuW1QAKCRAk1otyXVSH0CtMB/
 40R9+nP6xmrfk5WVeaHV8vDixBon2zV1jf6yvfeZ8vy6iK2bTeIh635o0cvT6cw7TAU+A39yem3PU8
 advcTbZL5hUL2frw9DLpla4ccORKZkDea8BxjDzjIy75yXzJttgqM6TI13qq5XpNuvtDsAqJ91Gcfu
 fG5S+KG2mM2/MrfRGBmlb+ReqOY53AVShGH7OGHepGqbwBaosvsRXciodx9NMHbQZYA82gfxskLJ4u
 Px3PeFek0SCY9epF4euSZk6/l1A/KYkrjLZW7QvVxG+cHuQZhoDn4GqwEhbD/JyYoTaRtXKXW06Oxu
 ozL4j526nmNm6ii9nx0cWnpiFJDQ8v
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Convert MDSCR_EL1 to automatic register generation as per DDI0616 2023-03.
No functional change.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  1 -
 arch/arm64/tools/sysreg         | 28 ++++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4e48bb4dca6a..4ecae92b56b5 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -134,7 +134,6 @@
 #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
 #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
 
-#define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
 #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
 #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
 #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1699e87bc0b4..a5ae0e19fc9f 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -55,6 +55,34 @@ Field	29	TX
 Res0	28:0
 EndSysreg
 
+Sysreg	MDSCR_EL1	2	0	0	2	2
+Res0	63:36
+Field	35	EHBWE
+Field	34	EnSPM
+Field	33	TTA
+Field	32	EMBWE
+Field	31	TFO
+Field	30	RXfull
+Field	29	TXfull
+Res0	28
+Field	27	RXO
+Field	26	TXU
+Res0	25:24
+Field	23:22	INTdis
+Field	21	TDA
+Res0	20
+Field	19	SC2
+Res0	18:16
+Field	15	MDE
+Field	14	HDE
+Field	13	KDE
+Field	12	TDCC
+Res0	11:7
+Field	6	ERR
+Res0	5:1
+Field	0	SS
+EndSysreg
+
 Sysreg ID_PFR0_EL1	3	0	0	1	0
 Res0	63:32
 UnsignedEnum	31:28	RAS

-- 
2.30.2

