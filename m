Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D0B17736
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 22:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B665AC433CB;
	Mon,  7 Aug 2023 22:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691445759;
	bh=aGB9MytFbopKILsUP0kPuxTbIpt9GJuR7uXvXLP6vLo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=B7+8io7JEg/LIWoZNhiKlYaOzexSqBArV056/ScJvMpxGs2kYB4Okzkzol5kScHYE
	 55HMmJFzcyF8LtgXCBJKWR7eLCptLh/oMa3OwoCIW/lmiSswqdleH9vkIljQqqI1NG
	 HLehvcCG393fnl1siFCS/s7UzNZzDQUk8j/IEVppVkDJ+oI6SfDcO/ioLRso4uqmWd
	 0nFYrpM45VWM6oql/4rbBGH9Bwejm80beYj84++Sz29XVXXPZ08K9bNizQdES4ri9s
	 TnarJsT6SfHg4wd1fb/cH2kV7WdxLpv3PjSjRekkZcxhPwSttByrH0KzubjmRIB62N
	 obTS3NSXeRxEw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 07 Aug 2023 23:00:16 +0100
Subject: [PATCH v4 11/36] arm64/mm: Map pages for guarded control stack
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230807-arm64-gcs-v4-11-68cfa37f9069@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1124; i=broonie@kernel.org;
 h=from:subject:message-id; bh=aGB9MytFbopKILsUP0kPuxTbIpt9GJuR7uXvXLP6vLo=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk0WmgYE5sTjIW0s7MSSUHBmNdoL8mADFajoHMlxxa
 sLCcTiKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZNFpoAAKCRAk1otyXVSH0CQmB/
 4hCrLHpUMmcfdaL24W2A5mDkcuuBM88bAHrKma9GqNW27peedUqdX7QojJVVcc8Pti+JDlRJQlF6eA
 QZEKYM3bKTE3mosdO+93NlHTPGn7gi26Pt1S42K8kRxwwm3mJo1gL/HQE1ao9d0KZg9o9LHWjR9UsG
 hAoZdZeodWYeIhnbOvuyIXIfGKTlRPnEOtzr//cVzV6vxPF3kggLcSNXBGXhBYJxComChKV/1oWfxG
 tHKcsX37YMulc8njZNNNcc7c79OcVYO4TFDHmUNkosm8ee1zIH4H+rIteZ0Pyhx3nAnQLUDe23kVjg
 n0K3NwP/ZpHSz6lX1gqzfW1nyN7hWy
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Map pages flagged as being part of a GCS as such rather than using the
full set of generic VM flags.

This is done using a conditional rather than extending the size of
protection_map since that would make for a very sparse array.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/mm/mmap.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 8f5b7ce857ed..8f40198cd44e 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -79,8 +79,18 @@ arch_initcall(adjust_protection_map);
 
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
 
 	if (vm_flags & VM_ARM64_BTI)
 		prot |= PTE_GP;

-- 
2.30.2

