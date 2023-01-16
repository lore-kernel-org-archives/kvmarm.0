Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA6746B7
	for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 16:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8AEC4339B;
	Mon, 16 Jan 2023 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673885144;
	bh=IF1quKqg+yElU9WKsumd6E0tB3MlCV6VyNC67qHTYmE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X+FpTNxOrVVr2XJPTVmBRhF75JX8jrWE7OAePTaDp8o0n0ebWmpZqprKd/KCP89aQ
	 y3u4Cm7H4uSzF5VFkfwvFQJoeibQ1LVRo9/Jm4l6SOpoVi2WJZAo5hkW/kBSq03FiA
	 KccdAFGLt/WmbPjYbcmHtS3iWJyooqZ5W3NeRZRk1Sd3UuXypGREoJCBTwPpt2nC+j
	 DR/OeNzxtFUorAs+5wrlHSA/ttCue3qTjYoOD812HcYbMB13sSX5+/j9JM80GKHFQC
	 AhdRj912U36nTwVG3o9SeUnhaN5vQRiCodETX94WfuiYGnb+7P1zZSzHpGBuECih97
	 fTBrf4gHCpyUA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 16 Jan 2023 16:04:40 +0000
Subject: [PATCH v4 05/21] arm64/esr: Document ISS for ZT0 being disabled
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221208-arm64-sme2-v4-5-f2fa0aef982f@kernel.org>
References: <20221208-arm64-sme2-v4-0-f2fa0aef982f@kernel.org>
In-Reply-To: <20221208-arm64-sme2-v4-0-f2fa0aef982f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Shuah Khan <shuah@kernel.org>
Cc: Alan Hayward <alan.hayward@arm.com>, 
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-77e06
X-Developer-Signature: v=1; a=openpgp-sha256; l=647; i=broonie@kernel.org;
 h=from:subject:message-id; bh=IF1quKqg+yElU9WKsumd6E0tB3MlCV6VyNC67qHTYmE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjxXWlpJRXFnj2eCYzluuUhTiIC3s2a4Een0uGhqtB
 KpEnVNmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY8V1pQAKCRAk1otyXVSH0HbpB/
 9ilE5gyKtxbv9+SnaoOPYCXE67Fwt3bQrmrCq9/8r6YNg7ka9cSVJIopU/gkIUBqKn1ZQIJ6pC6R1c
 jLeT3MDQctpnL7CNvzdPojdIo6N79XIP8I8GG/T51lWUSCVaXyylqVzO4QOZxgJnJbueaa8GBz7c4I
 XvqU77GI7upcBWkWbYsz1UJK4fHvFIDifY9wqbtS0uFDtSkaSe7N4hiFxGMDKd2OYagIzqmpenyycI
 U8RpdMmf2Pv03NDOFH+goau3fO2XfzF4vROuSf5b2GfqTB1lhUzH1pRnI5L1xvjWypCJx0T3DufRlj
 L+9Zlbg/I2Xm1ALJNnaM69mag00nZK
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME2 defines a new ISS code for use when trapping acesses to ZT0, add a
definition for it.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/esr.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 15b34fbfca66..5f3271e9d5df 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -341,6 +341,7 @@
 #define ESR_ELx_SME_ISS_ILL		1
 #define ESR_ELx_SME_ISS_SM_DISABLED	2
 #define ESR_ELx_SME_ISS_ZA_DISABLED	3
+#define ESR_ELx_SME_ISS_ZT_DISABLED	4
 
 #ifndef __ASSEMBLY__
 #include <asm/types.h>

-- 
2.34.1

