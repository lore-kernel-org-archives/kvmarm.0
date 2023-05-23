Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7444C77
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 18:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9ACC433A0;
	Tue, 23 May 2023 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684866983;
	bh=NuUDB+s2fxCd02gyUF/+pz6UWNHOrX4UeDzZX2n8uUc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uQBAUREh60Gr1FLdpcLEhzxRCksz9Y59IU3sZk8ecYC0PxV52TlFVyqV8JVsjAO1e
	 eOU1bdYgNjcH15Yk1hZT2wqy8VHsMNmiXfSQ2rtNoqJEg7obIm+FekSas+RsNhwpAD
	 Pk1+o7ioFd49CkNI/SK2to/Q5i4/bWvM/ccNsIIEvK1Gw0lHZu5iiCdd//GDrYQddS
	 Qwy0IiFOp/TODBoiIfhjPPEjKOAPaTAhjy0tYN8FWsSYpG9MpLT0QLeN8tYfn7oN2/
	 rlIQikzHROkhWdbBRwVXRXlQt32Cu3cMeIO18O1ma8nlISAONAx1SQzNdhrW9a21NW
	 VwFeVzMSsBJSQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 23 May 2023 19:35:58 +0100
Subject: [PATCH v2 1/7] arm64/sysreg: Convert MDCCINT_EL1 to automatic
 register generation
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-arm64-syreg-gen-v2-1-e0064336e2dd@kernel.org>
References: <20230419-arm64-syreg-gen-v2-0-e0064336e2dd@kernel.org>
In-Reply-To: <20230419-arm64-syreg-gen-v2-0-e0064336e2dd@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, 
 Shaoqin Huang <shahuang@redhat.com>
X-Mailer: b4 0.13-dev-bfdf5
X-Developer-Signature: v=1; a=openpgp-sha256; l=1459; i=broonie@kernel.org;
 h=from:subject:message-id; bh=NuUDB+s2fxCd02gyUF/+pz6UWNHOrX4UeDzZX2n8uUc=;
 b=owEBbAGT/pANAwAKASTWi3JdVIfQAcsmYgBkbQecpBPJq6dmdM6ZsngIix8E2wh+AuFVeFOY6dnO
 UT1QwvqJATIEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZG0HnAAKCRAk1otyXVSH0CiGB/
 iPDxlXd7O+xziutS6ElVO72oLguJ1A+14z/QJR/XUzGlPjqDJYZsXJrmMYAw+/6AfO8Ve82JCNZuVB
 uPmea3L0uBx2kFCaAg139pN4nq27EnmnGYeuUaDdIp9v54HV6f7y42VPuXjKcnhsZiyB0IoZy/z00s
 /l6+dZ486iYtuzO7riQVcSnQAZn5ZKGP4kJgvSn+Y5qnoDeRl4I5326LNM645zPeqXTiiI1jwbi+xE
 +EUB+KstMZop+V//YMZxN2Nyb2Ma8PYQTwOB2Q8vceJpwiDU1qr4RoHP2ppZtPARCifK5gxMq69lNu
 GO4R5kCjrUbOblJUyZRlrCuRcbMoM=
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Convert MDCCINT_EL1 to automatic register generation as per DDI0616
2023-03. No functional change.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 1 -
 arch/arm64/tools/sysreg         | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e72d9aaab6b1..3d69bda0e608 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -135,7 +135,6 @@
 #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
 
 #define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
-#define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
 #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
 #define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
 #define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index c9a0d1fa3209..df7a7ba97b43 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -48,6 +48,13 @@
 # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
 # item ACCDATA) though it may be more taseful to do something else.
 
+Sysreg	MDCCINT_EL1	2	0	0	2	0
+Res0	63:31
+Field	30	RX
+Field	29	TX
+Res0	28:0
+EndSysreg
+
 Sysreg ID_PFR0_EL1	3	0	0	1	0
 Res0	63:32
 UnsignedEnum	31:28	RAS

-- 
2.30.2

