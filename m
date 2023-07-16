Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C709443
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB808C43391;
	Sun, 16 Jul 2023 21:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544539;
	bh=6C9vpUKzxaC1YPufnnUpE8qHeuHqYjFB9iVUxK25t6w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qRa+YtE7yvYvcODmiwXlBSh4F1vfSwmQsxOYCCQHdyb7+9c2QZaWomxYvuS8kAIhp
	 714G1h1smywg2+5j2TZEfjSY4jKrv7pSFsPmWoRlS0zeS6ohrJTmnPvVIi14ff21D8
	 JDffHX6QBQP9aOIkracyewUb01/PrSGXzH4WmI+M4og6H7vnCvlW8GNZs+SChNn2N3
	 CFO4IYgetGBzac0xoAbaU0lbR8qvrMLJ3zH0bVfQcPnzspiFpfFuWqBx87Ho0dw9Vh
	 P14G/ouU2IXhzfq4tdx9JGoiCtFadeEMcbJpJfckv7oSDxvR+DrHoPw2gwKEtpbUZO
	 WD42Obeggb7Jg==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:51:23 +0100
Subject: [PATCH 27/35] kselftest/arm64: Verify the GCS hwcap
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-27-bf567f93bba6@kernel.org>
References: <20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org>
In-Reply-To: <20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, 
 Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
 Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, 
 "Rick P. Edgecombe" <rick.p.edgecombe@intel.com>, 
 Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1205; i=broonie@kernel.org;
 h=from:subject:message-id; bh=6C9vpUKzxaC1YPufnnUpE8qHeuHqYjFB9iVUxK25t6w=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGakI2DafnLEN0xPOYtS8rBwoQOkhbNIa3aIl3+T
 kLXsS3CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmpAAKCRAk1otyXVSH0C6mB/
 wOqidQ+86Oz6oompV7K5g7vr0TQDYT17lne0KPFqCuXH52UJc3v5g1bWEBZCf72AIeUyxqIlXL1eo+
 fCOPXyV5gx9kIxzNL5ZchfzMMppq9l2z8iGxIDidnZ6Rwu88A8zTi11YTTgcJawGzWSHPi5x0M4tYS
 kmZDonpfdL3p2LhjP7t0nhltgDjNqnE0LdDpgk1M6KoClhQX7tBC0Y++yuKtA8RVSwE87k+oaTYNUW
 ieQNE9JyTJnXTC1B5QfO3otl1F+D47QHyh9/+ktlmXTv5gfNRDIydVmDscZmRd4N7GYcn9T2SDLx4b
 kNoA3+dO/UVfdsAY+7oBJuc+B6wbTC
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Add coverage of the GCS hwcap to the hwcap selftest, using a read of
GCSPR_EL0 to generate SIGILL without having to worry about enabling GCS.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/abi/hwcap.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
index d4ad813fed10..38844e4c5aae 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -39,6 +39,17 @@ static void cssc_sigill(void)
 	asm volatile(".inst 0xdac01c00" : : : "x0");
 }
 
+static void gcs_sigill(void)
+{
+	unsigned long *gcspr;
+
+	asm volatile(
+		"mrs	%0, S3_3_C2_C5_1"
+	: "=r" (gcspr)
+	:
+	: "cc");
+}
+
 static void mops_sigill(void)
 {
 	char dst[1], src[1];
@@ -223,6 +234,14 @@ static const struct hwcap_data {
 		.cpuinfo = "cssc",
 		.sigill_fn = cssc_sigill,
 	},
+	{
+		.name = "GCS",
+		.at_hwcap = AT_HWCAP2,
+		.hwcap_bit = HWCAP2_GCS,
+		.cpuinfo = "gcs",
+		.sigill_fn = gcs_sigill,
+		.sigill_reliable = true,
+	},
 	{
 		.name = "MOPS",
 		.at_hwcap = AT_HWCAP2,

-- 
2.30.2

