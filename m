Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA52317736
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 22:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8415C433CA;
	Mon,  7 Aug 2023 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691445854;
	bh=6C9vpUKzxaC1YPufnnUpE8qHeuHqYjFB9iVUxK25t6w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aNAspYX8YMDa4S1UOfbvx8zWfswbqBEz2wJe7nfM0pWFTYZgpasCip1sxspsbK1qs
	 /ctFJQYBpm7aljWAEoddRMJF5WmAQCiy0iBDZYT5uSPQXATQIPS9q50niTcPxSoYYk
	 U7X+2GqIufk6btPdrinnoTk4hj8wM7DiUAFP7dlkMqbK/aAWLB1jFFgmzAvPnQhJUU
	 oXDcFIObaNQGJy0w483/tdaMENDzBL3QS97hz+z2fp/xbLo6OxHbD5nUXVeaLIwxqG
	 NryQH3iy3EX4Hs9w39NpKQdf6CVUtGS5BHj7u+SZrrV/4S85G4qoG9XZQYOA2P/wW+
	 CAywrJ9cKhinw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 07 Aug 2023 23:00:31 +0100
Subject: [PATCH v4 26/36] kselftest/arm64: Verify the GCS hwcap
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230807-arm64-gcs-v4-26-68cfa37f9069@kernel.org>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
In-Reply-To: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
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
X-Mailer: b4 0.13-dev-034f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1205; i=broonie@kernel.org;
 h=from:subject:message-id; bh=6C9vpUKzxaC1YPufnnUpE8qHeuHqYjFB9iVUxK25t6w=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk0WmsQXm1Nq46jBWok7xLjTNPIAVH3O++MCR+eGVU
 IlIReyiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZNFprAAKCRAk1otyXVSH0HEYB/
 0WPQNCRQxW5vYJJYV581n2TRG7EYT3pL7OPOKjvTDLv3U3bWOAdKBA69F+CMA2Cf9vB5QMcZPf8HbY
 F9VwARZ4J1JwbrXW8xotnruPFWMpZzyIdAgg8/YIU5lOzFtpFhSGm0hhnEjxK16rlpCflpZSVjVpnW
 OEQq6+W2PsvmhAgpMBYG5P2z/J1gUpUOqhoiDMNyFDYHNjd7tmG4yj+BHiaCXNRfWATS33Y1kRDx42
 XRZ3wQ8i8jAjo3JO7pX95L7caAT8EAOfI+ZGgvR+1aHYzcbx2sehURn+5lDFBzXVM+CE8PTpXIUXLc
 VfOqijnQtnB8bltlyq6L9mWoafWwPE
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

