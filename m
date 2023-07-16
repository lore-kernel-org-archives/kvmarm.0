Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426CE9444
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8C6C433D9;
	Sun, 16 Jul 2023 21:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544444;
	bh=viG5anxcCcnETy6WTEqLj0O+gpdZleg7ylSYSUDSWcI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SwCpkJ/re/3QSPdOxaSvPmTUXqWyUYkc1452Z6mBhqiKzmB5dXQ/cYeSPFblePc64
	 8UJ+5qbsQHPqRV7eXlUH7stZtlnPKB7kI/LWN+cxruPahvww4EdxtsoO+sI/tTn0EQ
	 qdNtuuJbES2trN5efTE+qv0nM1D/yG/Mim3jkmKJBLAwtXhWWtlmWthlc0A6bh9gXk
	 1C90UGVaHBe+F4P9Vy1v1jg6i6o58elJ5GmZlNCIB7YvkT5iri0JFOIA4f+OSbnjdJ
	 0x5z42vjeE3UCul3EOX6ZIBcyARUKPaIH7UVQriq9uQIjqWyf47XOUcN6EnZKBxx/p
	 gjk/S9RqX2LpA==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:51:08 +0100
Subject: [PATCH 12/35] arm64/mm: Map pages for guarded control stack
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-12-bf567f93bba6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1225; i=broonie@kernel.org;
 h=from:subject:message-id; bh=viG5anxcCcnETy6WTEqLj0O+gpdZleg7ylSYSUDSWcI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGaYY8P9SxztwbReqsOD4EXSgrju2yjwCdYsxO7X
 ObL/CRyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmmAAKCRAk1otyXVSH0CFjB/
 wITNeqHx2A9A/AJ1DNYpxUDzTwZ9+T8pd3XOVneuYwaTzi2MZZye6tNiKR7wiNv5QIUneXtkSg4tPn
 zzsu4E2T4EZd/99PiJr0CIU7iav1s9FW8s4SW7VitRAsaErFQQp+sBM6u7MnHrNS3iH+u4UBvtt9sl
 CKKObd7jfjgeFS+kmjiFsZSP9GjUQBkPW9DjXWJ8XNw7DkEK5KnmRY5yS5djZpGtZ7CGCkktenGhaQ
 5DQjV/3Lb+1ksoB7g/SRlkIZCrnv5us2Evkh/UXqNufRoWbsJa4du5YWevpf0T/TfT1TXYEmXm+NJ6
 PpE6d0otsGkuF72xIz5WxGxqAtuw7y
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Map pages flagged as being part of a GCS as such rather than using the
full set of generic VM flags.

This is done using a conditional rather than extending the size of
protection_map since that would make for a very sparse array.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/mm/mmap.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 8f5b7ce857ed..e2ca770920ed 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -79,8 +79,23 @@ arch_initcall(adjust_protection_map);
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags)
 {
-	pteval_t prot = pgprot_val(protection_map[vm_flags &
+	pteval_t prot;
+
+	/*
+	 * If this is a GCS then only interpret VM_WRITE.
+	 *
+	 * TODO: Just make protection_map[] bigger?  Nothing seems
+	 * ideal here.
+	 */
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

