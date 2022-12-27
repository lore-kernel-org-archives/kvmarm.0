Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AA0624
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 17:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1236C43392;
	Tue, 27 Dec 2022 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672160733;
	bh=eiOTtOIQC2LWiLXrEgqlIouB8FKMBFOz8vwMffgOfdo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mm1QHSNrCADbHiWNnmmj+KCg2o5MRxvQ+lXbtBSW1PEU9BcPh4IaFHqU08Lz4hwM7
	 SSaIcY0jMRhh9wQBXyQ1RaULfbI3U3Bs9fXPD7Ege/aI9roeBI27YwGsKWG1wemmCq
	 Ikrymti+Uxd4WVuQrdWH5//hKXpvBFh66YJc1FT+50nndzL7fSYWPzoUsEV88brdPk
	 tjqd6fmqLo7KLIL4fa1HtDJIqKLfZha/Oea/mUAw2+kN4rG2BP9dLzOI+sfZQhVzc5
	 Rv0Vb8tukeqKgFkJJYzQJDqCjAmUwUzqsYkf81/ANC2MFWT8i93FvSBBXsgM+XBQO0
	 GUz1z9iC6++hg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 27 Dec 2022 17:05:03 +0000
Subject: [PATCH v2 1/3] arm64/sysreg: Add definition for ICC_NMIAR1_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221208-arm64-isr-el1-v2-1-89f7073a1ca9@kernel.org>
References: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
In-Reply-To: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=596; i=broonie@kernel.org;
 h=from:subject:message-id; bh=eiOTtOIQC2LWiLXrEgqlIouB8FKMBFOz8vwMffgOfdo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjqyXXOEHn6WxIKev+t89gmeA6Sw8ZUaD44ImykQUW
 cE2DCbyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6sl1wAKCRAk1otyXVSH0AnhB/
 4/Yn7IXb07e9aImQQJz/AW2bFB5uPmUSxaFqdBPKMOOMqN7dW4OVEnrrY9FS2Tahf2PxAahb3YT60A
 jPGA01wSHgK6mIl+WKGsUXIsGypQRsXwtsX6P+0+EHipi9YEMwGSurfCuyC0QDpYKyAlM5eFmkn7aX
 JehGgkaQUnZeb+JSIbcvsDix7yxX3U1sMoF1IOZLGqIsraB26KpIPbw7WcknU9c0WjG/C9ti566nwd
 n8Z/6kXE2+AKKL4ZyVFCuc7QkOcXUbzkSKabza350XcKcdztkG9HGGvfA1OpyJhqbwZMcooq7r36SA
 BPwL96XtopnjcifI4HYVpEjukwYslf
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

FEAT_NMI adds a new interrupt status register for NMIs, ICC_NMIAR1_EL1.
Add the definition for this register as per IHI0069H.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 184e58fd5631..50ef5e5bff02 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1842,3 +1842,8 @@ Field	23:16	LD
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
