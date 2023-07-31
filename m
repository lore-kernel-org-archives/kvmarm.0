Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6984429
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AA8C433C8;
	Mon, 31 Jul 2023 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690811518;
	bh=viG5anxcCcnETy6WTEqLj0O+gpdZleg7ylSYSUDSWcI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mSSSKzu/+QPBBakkr45wlX9iKeJxSV3cpcmQLgAc4ESbF/iG02+RnaTU3bQ5T4R1R
	 Kw6LX+osxC9ep54R3iYjYNgQ+6DT6w7VDzmxi98o2AEGXQOppTzll2hpPv3eBxu/B2
	 rwMAkkj7K0zr+kT0apzE2k+Tue7Fgxe5UejX54nFqsn7yoFZPLCZJCkxh1wT6qRBxg
	 wdoK63KoGSo5kBnLWsJAnOBxxKxS7UmF+wY79mBh/GPrFVaCENDT4L5MC8AbRw+wNf
	 MQMBzeYPtbwAUNwOXLFT1KOQnCTxZve755M5cURARwYJUkYgPsMg/IE/rbeDS9hkit
	 7twM1r/XoxEag==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 31 Jul 2023 14:43:20 +0100
Subject: [PATCH v3 11/36] arm64/mm: Map pages for guarded control stack
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230731-arm64-gcs-v3-11-cddf9f980d98@kernel.org>
References: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
In-Reply-To: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkx7wcNNzB4eHbwePmvMbzyb2eKoUsPKpySJhqxMYO
 VO/4ZKaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZMe8HAAKCRAk1otyXVSH0E3bB/
 9kkSCSHClFMS8SVmSHhi/kdEidEpwq32cAUbFcwXkdeJjv/CrJsT5T8aku4YfmN1sY57bMYWiOFJCR
 rFY9qUYZhNPKyVK111nZII+nZtmV4F3UkxDrfeEkNH6xkOECetiv67QQOmgxwuMd6Mql/p94935ORh
 jgjiwaG54dImasHCJz8MxPQKdfrNGJHycnUS11u+lW7Vy0+tdh6Q90ATBtt0mrn8zi11TrpPzLB6lQ
 zhmwTiknW/gyPJFn9WIj1tzw3E3areua+5W8q1LF2N58SVUiovl4RgsSDgWKBCRuV7TMOgnVg8piHU
 Q4ZHM9VIPmML5AZAJsLnLlvAfvCar1
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

