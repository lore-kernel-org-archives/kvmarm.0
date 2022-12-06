Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E66A6AB3
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 13:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD76C43470;
	Tue,  6 Dec 2022 13:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670332341;
	bh=BQ7I6eN+6GZ/o5t5Vk4K6cshxfRrAyFnFSi5m4uTojg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVXFCmitgr1jR7vDk5LgZNioDJXpiVxYCvhCCxyLNrmaNUd5dCzUjJnGsIrAnGaHD
	 Sxuea4iqB9Nkm4EYIBfV1z683mTqG2GjyNY+3ERPyr102FFCi8Ca8Io6avfeXjf6c+
	 BYdZrQ/8GnB1K4Sox4MxWl5DDs4eQ3EpGyQgUPuZ3xGssIy58JtgSN7WzpzWG3VWMu
	 HJkr8Dswr8DzvKRtBmqFtAkww6lj4bfWPf7jdH87xuMtK3UJSacW7YkQT41rwl/qDM
	 Y2+py5PG+saErCpqvSya3qHbLVwJs6kWnqfFGDCt4gYj2lrrGyjGeDQNONnqGUEH1z
	 t/Jjs+96sj/xA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 2/3] arm64/sysreg: Add definition of ISR_EL1
Date: Tue,  6 Dec 2022 13:11:43 +0000
Message-Id: <20221206131144.115774-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221206131144.115774-1-broonie@kernel.org>
References: <20221206131144.115774-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=701; i=broonie@kernel.org; h=from:subject; bh=BQ7I6eN+6GZ/o5t5Vk4K6cshxfRrAyFnFSi5m4uTojg=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjjz+OOOLN0FUshrdiNy93qhEC4keUgDrC3s0fn6P4 8eod0BiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY48/jgAKCRAk1otyXVSH0L/CCA CAz0XVylfIZgbfAjJ87ngX5TtMzF3DH/2utr4FxakBF+l2eMSvDFBBt9crffAnMtlF+XjVEYQusboj WUOXWCzy7RUl5fnqWcPhcV/HwGPPo1x0qIVVozd98drjZ73xM90jTGzBEeAEq5XCvww4c5/sLPT/D+ 9nfr5/HMqVwDjGEUsIwK5mRPasb/uv53doU+qixgLSj1uINbDFyCwuUf1YkIXAR4OxMDjTf7DMqEnh EAVycx2BeWVqk+BHgfEdvScto4zJ9u2u/sW9rkp8V0fdPE9BdhJ9AiCQ7LStSNgToo4Bf4Yz0helvf Z58MuuWKRjSsI+QpKvMz0CtEIkElYp
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Add a definition of ISR_EL1 as per DDI0487I.a. This register was not
previously defined in sysreg.h, no functional changes.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 5d0d2498c635..3660e680b7f5 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1079,6 +1079,16 @@ Res0	15:8
 Field	7:0	LR
 EndSysreg
 
+Sysreg	ISR_EL1	3	0	12	1	0
+Res0	63:11
+Field	10	IS
+Field	9	FS
+Field	8	A
+Field	7	I
+Field	6	F
+Res0	5:0
+EndSysreg
+
 Sysreg	ICC_NMIAR1_EL1	3	0	12	9	5
 Res0	63:24
 Field	23:0	INTID
-- 
2.30.2

