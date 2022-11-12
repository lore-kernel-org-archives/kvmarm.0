Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8955184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D36C43470;
	Sat, 12 Nov 2022 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266267;
	bh=dv+KVGFURAIGGp8DpF1u3V9vTqz2OYDx9+1P9dJ9++M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPI0zEGWVtZCcfKnO8fcswAJC8tRLx34xF9CVPHNkMupNH2YLGe2i9qxvjB6qi2by
	 d1zHKjUSbB/gGISdBlrTWK5Gcm8xM29R1PM00Htw/tspW8/7nnK1PV2ej2Ueks+yUp
	 w4Uhb0W6OnkL3uYoI/8b+Pka4/XaKXSMdUfp4jqLu1E9yCIzVE0ubylKix112IfsE7
	 ycZWZBG/COn2yxlWgYSSskCdw5aI5x3W4wBLdpkabCiayHiiB4liVJfCVotj7YVqU+
	 aBTMhOjTZDwCNefUpmiP9FVSrcuaKgWbuyc+VtEW8WIl9WXJI73gsT2WMt6nQQBus7
	 PcrR4Cin3mIWw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 02/14] arm64/sysreg: Add definition for ICC_NMIAR1_EL1
Date: Sat, 12 Nov 2022 15:16:56 +0000
Message-Id: <20221112151708.175147-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=594; i=broonie@kernel.org; h=from:subject; bh=dv+KVGFURAIGGp8DpF1u3V9vTqz2OYDx9+1P9dJ9++M=; b=owGbwMvMwMWocq27KDak/QLjabUkhuT8Hc+nHbmXVLlL/NqqNY3HauU5j4RGN7lWB6pYr3l7wqhu YY5ZJ6MxCwMjF4OsmCLL2mcZq9LDJbbOfzT/FcwgViaQKQxcnAIwEZVj7H/4Jh7oLXhT4rhs16WOLZ cnMoRz7sjvOLShSyeA69Bk9orQkkc91Rx69W8j1yptFzlc1/MvPb1Bzre5s6mpP2GBy8uVr6Pe71H6 qy+hzm65yejqpjwDdYkTd1uNgr3Pz0i/0JR/elbBjLpg75bQ96YCyc/Cq2q5pnvq7mxtSFdevGrPYU uOvMIzXgkzl+R9Lcu2e7HjwnY3g5Zl7VfzfmVsttMJ7LC9fmFa3QSTVMkr9cq6nK78fDbJG41Wsxfw TPv5bL5S1sf0qNKHyTminGenreuyes5j3ep8parPLe2w5cQ9EZOLT5uEMSqYi7fYpxw4u+N++PJ+Tp WAvuvrqxqcWmpXWE/xaDZzP1QNAA==
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

