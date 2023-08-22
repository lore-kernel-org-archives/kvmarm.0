Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8697F
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 14:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F5CC433C7;
	Tue, 22 Aug 2023 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692713151;
	bh=6C9vpUKzxaC1YPufnnUpE8qHeuHqYjFB9iVUxK25t6w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uJR6Rmf+qWK78zBrJ5KatjzpBt/zfdeHYWwr0S//dMcWGE/DklAiD0RhbylsxjuWq
	 AgW1xD+vCT8fH4tWjcKaygQxQXqyRBWHqWl09eE14J9DoxhVhh4Yuxkh8C1GZjXCmB
	 8a7+5Rt6n+xYiEgdrgb5L1OLIhEv6rFxTiXck/AowYaULVrkRP/z3DQMLLHLboATCL
	 DCMroNXGQ9wQaG6Rx3KRLCmfLwgN4KXOXvDGj4NCrhcBwgkNhiG94BGzp4p9/QgUtc
	 zlGsBWjQHBN3swarNNezk7L3qxgdGmTNqSvSpYUEtNG9NhR51bf1MhYUQx8sKdW470
	 XVy8F9R33hVZQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 22 Aug 2023 14:57:00 +0100
Subject: [PATCH v5 27/37] kselftest/arm64: Verify the GCS hwcap
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-arm64-gcs-v5-27-9ef181dd6324@kernel.org>
References: <20230822-arm64-gcs-v5-0-9ef181dd6324@kernel.org>
In-Reply-To: <20230822-arm64-gcs-v5-0-9ef181dd6324@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk5MAFVY0DMZDd3of+ZsoKYtYgu7+iC/vtAH2sxv5S
 Ct/vCAyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZOTABQAKCRAk1otyXVSH0HMgB/
 9PlNyibc4TgMe/I+kZC9KpcT9K77mdlW2wxZPsDRhN/T0euRO6+H37S+U/5XE0hkgbi0It5Iq9BZO4
 oQ+7+SQ1m28ZtNjMYXIn4akZXZDhCp2swX5UmH8AFn0AopKhVs8GOQhbObnt/ZonAFdC5dnn5djvDe
 s4wgV6nTaGOARPBZQSliJVVycQgxOqW8juxwQh3V8vJSscDRi9h2yvANzIlzbRB7LwyIcWYQ8ld3be
 hi2eNHC7QcQvJK8m/jioaJCHMNO+L3U48Urgtxk0Y+FngycnuKgpxPxpSTwBtQjK02La5/10LeU9C4
 LvOKY8d6wzNW8Doj/s6E0saM25SmOA
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

