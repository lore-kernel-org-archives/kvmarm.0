Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15962DF72;
	Thu, 26 Oct 2023 12:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rg50Lsre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61B9C4339A;
	Thu, 26 Oct 2023 12:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698324426;
	bh=Es1HQrf2Y34+Fy2pSDeaIOdQfdboYR0FuIcMBXlX4+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rg50LsreK3vPIQnUFmO4QXkUaZiJ5uu+B1PwlgA+dWT2+hvnlSu8CfejYBS0jIOqN
	 jm6KPhs9etVVGyPwD3sEzY3TZwQh4hptv7k4MGp1X3G2IAOJCp8HeuBqF06vbriFgk
	 qkvDIr/xldrQYb3bFlPSKifIR7Ir8baQSuxKCxS5NzHbK8kdC1UL56z2OD12o++szv
	 49aiBP6I8e31ZVskSWCtYq99rxIkhvDT+DXwDeGPZZHsSsOzONPW24DPqcCjsUSwCJ
	 NIVKhB47bS7xGcEF7iJPEc5Gd6gWtvf6uboipUivt8bN0CryYGLbDCMPUqCXLu3DRZ
	 jT1jdbWsALl0A==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 26 Oct 2023 13:44:24 +0100
Subject: [PATCH 10/21] arm64/fpsimd: Enable host kernel access to FPMR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-arm64-2023-dpisa-v1-10-8470dd989bb2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1028; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Es1HQrf2Y34+Fy2pSDeaIOdQfdboYR0FuIcMBXlX4+E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlOl+cDio3fVDOG6FkTnDOEe/llr5xX9J3YDZxYQ5e
 4EBVfGqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZTpfnAAKCRAk1otyXVSH0KuWB/
 4v50sXhUz0JQ6Df8E+uf8uNMaUfxkYmtpSyW2zLhk5PHHVGCQsyVHKygDY+oINIJP1Am//8A0dhZ5o
 1RCYO7dDqCw+olrIQO8LKLKOFNn+tL1rkaIAJVSWu5+qhUkV3m0Tfaux/6l93zI3ginnkp8ohyaucZ
 wQt5hoE35RQPa/3xJvassbTstV9c02LKJ/mLw2J0zTBtHzJFf0WttobhzE7Ej+i2tqIT/SLAzVshlq
 jQrdtUDqraR9V4BddiTiGc77Wb4Dxav58X25YbyXOvf20gm0ZAIjOrz8E9cLDXp4MVUvLZTDt+7FeH
 lWSYXaEk3FeQwEanSBHA3FPQScEbHx
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

FEAT_FPMR provides a new generally accessible architectural register FPMR.
This is only accessible to EL0 and EL1 when HCRX_EL2.EnFPM is set to 1,
do this when the host is running. The guest part will be done along with
context switching the new register and exposing it via guest management.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1095c6647e96..ef033c6c745c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -103,7 +103,7 @@
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 #define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
-#define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
+#define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))

-- 
2.30.2

