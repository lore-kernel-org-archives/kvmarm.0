Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A3D17736
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 22:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F93EC43395;
	Mon,  7 Aug 2023 22:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691445771;
	bh=S97P7xSs7G2VtUJIV0J+B0XZVXkpwW1tCMSo+ZYUeDw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LmByAeAoBQ6Sp+qeln7IRkPK8b8wrlI6vP0ofLetjqcYdI6c9SbhWyBuSYq2RoSwN
	 3JO0aAXKdoRD23voxo/lqdNaqV57fxooeda4xnKjr+wxZMXRxhLSwT+Hbj5gtWUnjx
	 jcnvujnN9lwpXcPbHCmcgom37ArWn78GbgkBNUaTWEcASiIxCK5juxR+QU6y+Kc2Ie
	 ODoPlpYmz279tMnFraV0cvT/MNMrXmEqJDxYzbicOy1+2iSSFUfgVRsbtBQmHqrzl5
	 mptrmONoM/Fx4ZkkVJSzCKJ0RK86o7Ht6ePo21JzNnm6bong7aocdDash7K7cQThJ0
	 JXlxq+OTI4P9g==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 07 Aug 2023 23:00:18 +0100
Subject: [PATCH v4 13/36] arm64/gcs: Allow GCS usage at EL0 and EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230807-arm64-gcs-v4-13-68cfa37f9069@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2248; i=broonie@kernel.org;
 h=from:subject:message-id; bh=S97P7xSs7G2VtUJIV0J+B0XZVXkpwW1tCMSo+ZYUeDw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk0Wmid4tbAShf3/PL65tMRoJhAzK985+MbY4zQtG4
 AWS8TpmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZNFpogAKCRAk1otyXVSH0CFGB/
 42uOHFOxkOrcFRMVwpLJPgCLRzodl3cgSROjQsafe2+XD0+fK02+FgoeVHgdLqtPqq5N3sdA2m1NFC
 wKkpNYS34teaHEl9hOZ0klAa3BxjU0mX8SkxQJs42+1wjLmkrDfqn27T8AU7+TwyMyEfw8yYhl54k2
 P3snTqZ5i361G8meD0Aj6L3se3eWta4/vr/VfdRFPdYtq6Nhlyrr+CahCp26Cif+4KISBrWrxkESkd
 0UX9I+tKDTWYEBnx+8P7Acc54KBHUof2annb0trLelaSOAmRXdcwMrbujlRLpqVY1gWF1kibG9ytG1
 pKhWa7ssyTMMZyk+OqAVU/vr6HACcs
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

There is a control HCRX_EL2.GCSEn which must be set to allow GCS
features to take effect at lower ELs and also fine grained traps for GCS
usage at EL0 and EL1.  Configure all these to allow GCS usage by EL0 and
EL1.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 17 +++++++++++++++++
 arch/arm64/include/asm/kvm_arm.h   |  4 ++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 8e5ffb58f83e..45f3a7dcfd95 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -27,6 +27,14 @@
 	ubfx	x0, x0, #ID_AA64MMFR1_EL1_HCX_SHIFT, #4
 	cbz	x0, .Lskip_hcrx_\@
 	mov_q	x0, HCRX_HOST_FLAGS
+
+        /* Enable GCS if supported */
+	mrs_s	x1, SYS_ID_AA64PFR1_EL1
+	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
+	cbz	x1, .Lset_hcrx_\@
+	orr	x0, x0, #HCRX_EL2_GCSEn
+
+.Lset_hcrx_\@:
 	msr_s	SYS_HCRX_EL2, x0
 .Lskip_hcrx_\@:
 .endm
@@ -186,6 +194,15 @@
 	orr	x0, x0, #HFGxTR_EL2_nPIR_EL1
 	orr	x0, x0, #HFGxTR_EL2_nPIRE0_EL1
 
+	/* GCS depends on PIE so we don't check it if PIE is absent */
+	mrs_s	x1, SYS_ID_AA64PFR1_EL1
+	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
+	cbz	x1, .Lset_fgt_\@
+
+	/* Disable traps of access to GCS registers at EL0 and EL1 */
+	orr	x0, x0, #HFGxTR_EL2_nGCS_EL1_MASK
+	orr	x0, x0, #HFGxTR_EL2_nGCS_EL0_MASK
+
 .Lset_fgt_\@:
 	msr_s	SYS_HFGRTR_EL2, x0
 	msr_s	SYS_HFGWTR_EL2, x0
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 58e5eb27da68..9c84e200217b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -94,8 +94,8 @@
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
-#define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
+#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En | HCRX_EL2_GCSEn)
+#define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_GCSEn)
 
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))

-- 
2.30.2

