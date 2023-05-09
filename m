Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C5719524
	for <kvmarm@lists.linux.dev>; Tue,  9 May 2023 14:23:49 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADD6E1596;
	Tue,  9 May 2023 07:24:33 -0700 (PDT)
Received: from e126864.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A1123F663;
	Tue,  9 May 2023 07:23:46 -0700 (PDT)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/11] kselftest/arm64: add MOPS to hwcap test
Date: Tue,  9 May 2023 15:22:35 +0100
Message-Id: <20230509142235.3284028-12-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230509142235.3284028-1-kristina.martsenko@arm.com>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the MOPS hwcap to the hwcap kselftest and check that a SIGILL is not
generated when the feature is detected. A SIGILL is reliable when the
feature is not detected as SCTLR_EL1.MSCEn won't have been set.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 tools/testing/selftests/arm64/abi/hwcap.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
index 93333a90bf3a..d4ad813fed10 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -39,6 +39,20 @@ static void cssc_sigill(void)
 	asm volatile(".inst 0xdac01c00" : : : "x0");
 }
 
+static void mops_sigill(void)
+{
+	char dst[1], src[1];
+	register char *dstp asm ("x0") = dst;
+	register char *srcp asm ("x1") = src;
+	register long size asm ("x2") = 1;
+
+	/* CPYP [x0]!, [x1]!, x2! */
+	asm volatile(".inst 0x1d010440"
+		     : "+r" (dstp), "+r" (srcp), "+r" (size)
+		     :
+		     : "cc", "memory");
+}
+
 static void rng_sigill(void)
 {
 	asm volatile("mrs x0, S3_3_C2_C4_0" : : : "x0");
@@ -209,6 +223,14 @@ static const struct hwcap_data {
 		.cpuinfo = "cssc",
 		.sigill_fn = cssc_sigill,
 	},
+	{
+		.name = "MOPS",
+		.at_hwcap = AT_HWCAP2,
+		.hwcap_bit = HWCAP2_MOPS,
+		.cpuinfo = "mops",
+		.sigill_fn = mops_sigill,
+		.sigill_reliable = true,
+	},
 	{
 		.name = "RNG",
 		.at_hwcap = AT_HWCAP2,
-- 
2.25.1

