Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A7F2D025;
	Thu, 26 Oct 2023 12:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ri2qxKBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F50C433C8;
	Thu, 26 Oct 2023 12:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698324411;
	bh=oFpKguHAi/AFRsar5DM/a5DMfjfPrq4L3XQpoObPzvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ri2qxKBQJNvGpLo9SqHrlKTLrhUlyEBtfOw6XZFetGY83LgK6khVhyFNkAlNaPGgM
	 EuzgIJ6+Q5RyFCqeRjHY2hSlz3CnuWvAnQhX2OMPSA/ZhYTSVr6Fnlirmv4P6tKzWF
	 uV61jkJaN9oE/cr74ZDZksfThi3iOFFDA1lWRkvSo3c3YE9RsPFW76U8qiKISn29+4
	 FwmVtH5mfvG2AaO/Ot4XHNpfymGAr62Sz0TluE4XF4z83AGUQ710L4FpikaHVt6Mzr
	 sOIK0Cue47t3T8tG1ZFJTZC9Cq5EFPhzBXF1Y5Dlnkis6FY/Q4SgIxzkQW8KHbHcDF
	 VH1TFGa1dkgVg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 26 Oct 2023 13:44:20 +0100
Subject: [PATCH 06/21] arm64/sysreg: Update SCTLR_EL1 for DDI0601 2023-09
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-arm64-2023-dpisa-v1-6-8470dd989bb2@kernel.org>
References: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
In-Reply-To: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=817; i=broonie@kernel.org;
 h=from:subject:message-id; bh=oFpKguHAi/AFRsar5DM/a5DMfjfPrq4L3XQpoObPzvM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlOl+YSxS2zmLvWTnTnwZBvqOKxHpSW7yOQbtpETEr
 08wWXiKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZTpfmAAKCRAk1otyXVSH0I7lB/
 4z2aZ2Oe6EpVndXZu3zbSqXy0VedKb+jf6LBimIDci4OA8eeoK2j8sPM7CL+pQ+4UAN50o2mLUJFoX
 yN9zE697Mv86xaeiE6hIxHV76tlbt/chlS6ZSXE5AQdzosMhqF7GOY5fG2CFjv97Pj30v4P0RPEFjy
 7MvXYvW6E9zSxnFlD88mq3qETlhqQuf7ewxi/GCZvNJrfc9HjimY6fUSnQgIDg2SV0xuuzQeXJkmXq
 gh9YzM/ua14nORpoTlfAIJC5SXeH6XOwsgZu9ya9np79UZtppI12RMSsFpDTj1pkkwXiYAT8aN0M0e
 HCqzbIruuXhWNjZjGqlutm4x6WBgwU
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

DDI0601 2023-09 defines some new fields in SCTLR_EL1 controlling new MTE
and floating point features. Update our sysreg definition to reflect these.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 91dd564ee4d3..97d0da472328 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1785,7 +1785,8 @@ Field	63	TIDCP
 Field	62	SPINTMASK
 Field	61	NMI
 Field	60	EnTP2
-Res0	59:58
+Field	59	TCSO
+Field	58	TCSO0
 Field	57	EPAN
 Field	56	EnALS
 Field	55	EnAS0
@@ -1814,7 +1815,7 @@ EndEnum
 Field	37	ITFSB
 Field	36	BT1
 Field	35	BT0
-Res0	34
+Field	34	EnFPM
 Field	33	MSCEn
 Field	32	CMOW
 Field	31	EnIA

-- 
2.30.2

