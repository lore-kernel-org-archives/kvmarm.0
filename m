Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0741427A
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 16:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA37C433A0;
	Mon, 22 May 2023 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684772572;
	bh=FzovtixhHyDID3RroFvdlMrjlo2vz33VqdnD5NENejY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cc3Z97YKNg9nXngLP2sbbY40prIgld1TqJJLJJQ1h5FJxvhRKtbX2YpDmhus3lI//
	 ej5d0Mub4gRxJLqJUKU8Q1TW35JxK/o48MT+xZniufv4QEZ2EGJ1jsDDdQwPges5XD
	 ObUGMVPsl6D0p8oTuzWWKukDLOs22Ds06nvDnJydnxo4vxqXJgy+K+sfgkwBkxDNaV
	 O+YrIPpycJ7fuEvivUrcWqWiNWQyEfeYoRIzjBEsteqaXkJZYHL/qeoVGL1hMqNnZ1
	 A2tS/gcN52SjgwBkFmVqHEq+XIL18G56tBzKMsMbAFl1SShpj5o2129CBNxRggfujG
	 f3k7ZKWKHM01w==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 22 May 2023 17:22:40 +0100
Subject: [PATCH 1/5] arm64/sysreg: Remove some unused sysreg definitions
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-arm64-syreg-gen-v1-1-936cd769cb9e@kernel.org>
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
In-Reply-To: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bfdf5
X-Developer-Signature: v=1; a=openpgp-sha256; l=1048; i=broonie@kernel.org;
 h=from:subject:message-id; bh=FzovtixhHyDID3RroFvdlMrjlo2vz33VqdnD5NENejY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBka5bTOQmh6YBm5GAIe6KOw4KLzrietdti5W4movm2
 oPdkxQ6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZGuW0wAKCRAk1otyXVSH0Fp4B/
 96RE12Zk9Ru9IsJVSTKjxckaPNIMmsFnTa+lIHqkiha1EUClzNtahah2XEkhufQX8RQrPe/eWGmiD/
 nhs1vN3pgP55NpP1J4DKCrCYYdRbLpdDru4wwi365uuW/6qBLeCFkzDisv5d45d9XlgUs+fO1FTtSv
 BUdtR1c0NFUgKuAhW2MgB4tJmTPLxGGx/uG19rktS5b55Z83NZdWHapOSyxX3TONlRnVli42DP4iIn
 cs2gGPnER3qGV479EeN25lyzdvtinRZJQbRjSVpM3zaThBwb4yd9SPTo4doldIk12z6XejKACVLN3v
 cAPK4grUJseHoNSo1E/KurhTWZVHlL
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Since there are no references to OSDTRRX_EL1 or OSECCR_EL1 in the code
just remove the definitions rather than converting to automatic
generation.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9e3ecba3c4e6..6505665624d4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -134,11 +134,8 @@
 #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
 #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
 
-#define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
 #define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
 #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
-#define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
-#define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
 #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
 #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
 #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)

-- 
2.30.2

