Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EC79443
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94855C433CA;
	Sun, 16 Jul 2023 21:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544533;
	bh=pU/Cpaxis09XYO6pS+Tm9irl4OV1fzcTdHAFs+JXaiE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rWGbpHGpAPUGRkeHBlxB3u7YFF02VUBqBH3DDfi/zq+uR3bo5c9/02qDMlbROcq1a
	 TOxZq+swTzl/Cn9rsFrq0fkp5SOMZ9rQdBdNmFqBC1WAmool8nFYx21GlscpJIPaX5
	 Hj4VHZuaIdAexXk06rf4SIr9g7kTQlHiAqUekjYGnvRjB0F6hrvpboYOjI/7sNGzH6
	 vO0/Sk0ndEyBZ5Xb7JXIentYaOHaqbRU2SiE/17mQ8tYAWW9MdndQvzgrHI+Gte1+R
	 I25r1VajxxALbkW5eIIXj+twrpfKo9XBumj5mL0llLHJuRgO6RoUYB0fbwIFe2mCnI
	 xdT5wxQd/9Vww==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:51:22 +0100
Subject: [PATCH 26/35] arm64: Add Kconfig for Guarded Control Stack (GCS)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-26-bf567f93bba6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1333; i=broonie@kernel.org;
 h=from:subject:message-id; bh=pU/Cpaxis09XYO6pS+Tm9irl4OV1fzcTdHAFs+JXaiE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGajNEQmje9r0OAkZ6IXOyAN5ruAxFmeetfHxjAC
 LDyTfAyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmowAKCRAk1otyXVSH0JhGB/
 4uEom4k4x+430HQzhyHP2BDhwiv0Xo2K1mTO20ue7Lk8Wti2gS+bFt3j5ucEpMEwtZzUpbv9aFHg8g
 yVDFSa62TJm4VnlCyDGJgQ8tJrySIzQDdUWaW4NsZkCYMvzaHn7Io9BSwTN7Zseo4HDAFXeuVN+KcI
 6W/YOWtqN+FpSOZSkAOtNDCCtHC+Bnwr5v6a6FDSO91/wXPICZ9z5JG71wr/l8ddWrbzhdD+2lp/5O
 sqSoPHL3zXgrAcCHuCXDKtfj+XAC/YXjHy8TdZgS0bh4tp9AbE5iob7yXE/SpJfC8W3JOO8pyrZA3r
 LZHn0cmojWthyoDyKu+QYIQJkyHsLU
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Provide a Kconfig option allowing the user to select if GCS support is
built into the kernel.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/Kconfig | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7856c3a3e35a..e1aeeda13c52 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2091,6 +2091,25 @@ config ARM64_EPAN
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
+endmenu # "2022 archiectural features"
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y

-- 
2.30.2

