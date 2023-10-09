Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A1118C15
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 12:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H39Ysk/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922A0C433C9;
	Mon,  9 Oct 2023 12:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696853626;
	bh=HKr5dcgoD1HRE8Dfu3M7S45WXlztyGX1cPv4uDvvFRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=H39Ysk/jv3RNdJhL+Jsv7sBxcXZHRih+ROezijJvWx9EN4JvZ8YLVnCFWuh5eiiAl
	 J3BcFT9L59aj2K0HyS0TQb5id7+eKSVp9IjZACZ4PEq4aEUJjOSP7GkJfDBzcp2Jrb
	 u93V6DlJLKNe93rxNaei3Ow4LXKe+OKHKlwDOxFWm1SDJ76Ri39wH5qX2/YhNNY5DJ
	 oZm3ml3SR7XSkXmMZ2NeCqJMYBJ305rEf0L35tZkyRCWXvoBdQFqFuMqNZgytHtcPR
	 nvWKeRmVjuWn6bsz71J5LB+/nVGpBcBAqwMVSDG3VYjbyzwNtsmi2AWTk0W5qcRWwU
	 zkc7oXD/SsHuA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 09 Oct 2023 13:09:01 +0100
Subject: [PATCH v6 27/38] arm64: Add Kconfig for Guarded Control Stack
 (GCS)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231009-arm64-gcs-v6-27-78e55deaa4dd@kernel.org>
References: <20231009-arm64-gcs-v6-0-78e55deaa4dd@kernel.org>
In-Reply-To: <20231009-arm64-gcs-v6-0-78e55deaa4dd@kernel.org>
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
 Florian Weimer <fweimer@redhat.com>, Christian Brauner <brauner@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1334; i=broonie@kernel.org;
 h=from:subject:message-id; bh=HKr5dcgoD1HRE8Dfu3M7S45WXlztyGX1cPv4uDvvFRM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlI+2m6LbrIKImLz43AhLYkdJ+mn8/n/WtjdVAC+Y3
 I5cZkuiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZSPtpgAKCRAk1otyXVSH0C9JB/
 9PeuQ7odFNzac2es7G1H21MYtcjVH9+a2Xh/QADOSwBO/AZwG1T+Q4oNOVnGIYZhsMy5AUgOtQDFOg
 zDd8RXL2Yzchc4BhE4Ekw1h1A8Fde16BC4U8J5YyfbQTWzzV5ZjYMZRgWLWLEmJ82HR2bI/yfKju2O
 yiag57d6zPB3jBl31kU7tVUGxpZ+W2N3e3w0Lsn0dB/LatGzkRPssH45VRWQSLCiWocphZV2S0FttF
 8NdpTgTettJANn4cQtR8Ybduqa7BR2LVBS9TWMxRVAdrv8KMfeizfOEaa1rfjudAGqmDa9T2OYofSN
 a9bEGUta99nzCir41mnHoSZ0Cwo785
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Provide a Kconfig option allowing the user to select if GCS support is
built into the kernel.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/Kconfig | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b10515c0200b..d235e725177b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2060,6 +2060,25 @@ config ARM64_EPAN
 	  if the cpu does not implement the feature.
 endmenu # "ARMv8.7 architectural features"
 
+menu "v9.4 architectural features"
+
+config ARM64_GCS
+	bool "Enable support for Guarded Control Stack (GCS)"
+	default y
+	select ARCH_USES_HIGH_VMA_FLAGS
+	help
+	  Guarded Control Stack (GCS) provides support for a separate
+	  stack with restricted access which contains only return
+	  addresses.  This can be used to harden against some attacks
+	  by comparing return address used by the program with what is
+	  stored in the GCS, and may also be used to efficiently obtain
+	  the call stack for applications such as profiling.
+
+	  The feature is detected at runtime, and will remain disabled
+	  if the system does not implement the feature.
+
+endmenu # "v9.4 architectural features"
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y

-- 
2.30.2

