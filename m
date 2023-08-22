Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6ED7F
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 14:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EEFC433CD;
	Tue, 22 Aug 2023 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692713145;
	bh=H5XnWdFwxjuGxEH72kUlpbP8cfBTQj97MLlaTYR448U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dIUxNRrQkD1AC9FBGH+9l0U9ZvUnTLslHNuzmoBYliSNiMjoHbh5dJU/cPaxEgnvQ
	 fMyAmRdE1xxwHRmv2U0FDuaP0YabymuRE8p0HIUJdDHdd18evke32ASlni9odJAKqm
	 kJOGYpk59tFXT22PC74wYB0KIJoWfCpeiU5hhDWUB9vH/IwGogNDkAhhlDJaR2e373
	 LaFNUIb/I4uzxYcTrr/taSDf1/Nn2KftPmQOmW8Q1wQ8E6JrC7klyzXff58QuUzCTL
	 c3dqlJL3znAzBR6J4dn2qXFtJNYquax4v2ho5W2IWp4/tesIKEI19VWSJXP5CLEOMF
	 0fTJUjT2+MvZA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 22 Aug 2023 14:56:59 +0100
Subject: [PATCH v5 26/37] arm64: Add Kconfig for Guarded Control Stack
 (GCS)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-arm64-gcs-v5-26-9ef181dd6324@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1334; i=broonie@kernel.org;
 h=from:subject:message-id; bh=H5XnWdFwxjuGxEH72kUlpbP8cfBTQj97MLlaTYR448U=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk5MAEgUhGnrifDQTFSNQG5IJMFO4vUClMyRD9oH4B
 Sm9h0T+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZOTABAAKCRAk1otyXVSH0JoWB/
 4ztlxfSdMS7IVWSbChfjGpFHRePzfGZHEaisYlp3k0kgZx8bcwjiV3o02hzm5zftIak8w79jWQSmd3
 aN3YkxU5jhpqq63aESrUMuKSdYOeIUwRDsu+s8slntzbARzAKK5Efjuzees8q/RKdd91jRnEOBAxgD
 HUsvaCGLSybMULc1imROdMfNWAef8n0HAHB6WQCtfcoBe7Pmv6V2eFz++vPOyyYRthGKShLfjHO9CF
 joqJBr0GX+lqZ//ckS4sVPKa8Aop/jc6SHwCaKJ1UCZx+6yMg1Q1o1EuCa3Mad1di9PSbfEMe6d6Qf
 5Zt2G62F0VAglOrKBiG+LBDf7/bObx
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Provide a Kconfig option allowing the user to select if GCS support is
built into the kernel.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/Kconfig | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a2511b30d0f6..b5ef1a698770 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2093,6 +2093,25 @@ config ARM64_EPAN
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

