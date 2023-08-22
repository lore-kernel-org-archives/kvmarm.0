Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8911CA0A
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 14:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD285C433C8;
	Tue, 22 Aug 2023 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692713057;
	bh=fYSc6YldDz9f4Wg0F4vCCpyazEEr65gHlcDJxqefLXM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dRAAsGX9NQcMTa6eDbu6Tqs9RxRB5S5O4R9jCuHb2OQzuZkg4eItQ1lYOm3LAkrrB
	 7oYfctWxhLj/jt70PAvNfFtMY9G9e5i+ecr7xA61ELZwQo6kHP/NWVFIAiIu3f+3+4
	 H90+VbQOlXvBNgtiFTibSSe2vAvRZ/sQby+T6aJt/RBGpCqiiKW4cLZlkwdWAQDtbq
	 Gp+Tdz+PPhLjTSw2Af0B1azcJik4Q51rrKko9u9U++73PXF/LZMSBnctKSHhse3OFE
	 kKAL8bKKirnLI2q5/Y0dwJ6qjf0+DP4mkM8ysdhjYYQlorvtaS6vniIxJ/giKUdQA9
	 Nl+zR7rAwwaWg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 22 Aug 2023 14:56:45 +0100
Subject: [PATCH v5 12/37] arm64/mm: Map pages for guarded control stack
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-arm64-gcs-v5-12-9ef181dd6324@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1756; i=broonie@kernel.org;
 h=from:subject:message-id; bh=fYSc6YldDz9f4Wg0F4vCCpyazEEr65gHlcDJxqefLXM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk5L/5PuMIq9BeN3C01qO5ocLYTnlKxWd1K2qibZTk
 qwPJmcmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZOS/+QAKCRAk1otyXVSH0IUQB/
 9L+p/pe8VJG6Xh+181btNdS+8+jqn1Yk5PtFIxvU5J2m5z8vS9N1POMNvUX0r6O/SW5UoitDMDdz0L
 8CJpwAh9YougsmhMN8+JzS5SAPv/Vh51y37mtNY5GfahOxketQtY1D2P955vTu0cDrsG/4l753eld4
 3M591bLEc2Ke1tUf7tpsjZQR7VebXEdd5Lm+zcDr3e3JJGV5xLbv/uKjAVvUxxc5+Nx5aGTL+XpL4z
 qsnKGvb334j8M7hf84I4o1U0+ir3YzDo7udMaAZjAybVwDbLhJaD2XOHfiVzmTyps9zwcoJ7lVgFyw
 qCXDWPEi9HXbD8VkR+zsq41rp1BVF0
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Map pages flagged as being part of a GCS as such rather than using the
full set of generic VM flags.

This is done using a conditional rather than extending the size of
protection_map since that would make for a very sparse array.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/mman.h |  6 ++++++
 arch/arm64/mm/mmap.c          | 13 ++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/mman.h b/arch/arm64/include/asm/mman.h
index c21849ffdd88..4c4615867713 100644
--- a/arch/arm64/include/asm/mman.h
+++ b/arch/arm64/include/asm/mman.h
@@ -61,6 +61,12 @@ static inline bool arch_validate_flags(unsigned long vm_flags)
 			return false;
 	}
 
+	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
+		/* An executable GCS isn't a good idea */
+		if (vm_flags & (VM_EXEC | VM_ARM64_BTI))
+			return false;
+	}
+
 	return true;
 
 }
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 8f5b7ce857ed..e6fc7ef83ea1 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -79,9 +79,20 @@ arch_initcall(adjust_protection_map);
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags)
 {
-	pteval_t prot = pgprot_val(protection_map[vm_flags &
+	pteval_t prot;
+
+	/* If this is a GCS then only interpret VM_WRITE. */
+	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
+		if (vm_flags & VM_WRITE)
+			prot = _PAGE_GCS;
+		else
+			prot = _PAGE_GCS_RO;
+	} else {
+		prot = pgprot_val(protection_map[vm_flags &
 				   (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
+	}
 
+	/* VM_ARM64_BTI on a GCS is rejected in arch_valdiate_flags() */
 	if (vm_flags & VM_ARM64_BTI)
 		prot |= PTE_GP;
 

-- 
2.30.2

