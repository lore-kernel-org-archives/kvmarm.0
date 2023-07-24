Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F456AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8046C43215;
	Mon, 24 Jul 2023 12:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690202903;
	bh=9XX9E5bnVFdIImff20pSxEMqbLIiek/DMAIXfYv+R4o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g5luj1FmydDH077cQIwSyyoHieIwMfmKCK/e93g5iEwilx9smr8BVk1w6xeaL+6mA
	 Q1GRl3c4ApcUsR4GkPHzK7b5whWMHkhcaoBr9sjiEt0zR6k8EsWy15b6rqPOq6LW1q
	 EzNSZgSqvyPU9yuwVH/92zLXDowX8R5WCYIDRtybva1+73HnIBMj0sbWg8Ix+4ND7L
	 tWubSRJhCfudxBLr+mvqx6KQWFxA0XX0TyMnnSn7Pjic+phNSmcJr6AP5y3Dtom/66
	 XofRC+1mVVQIFKX3T7AsWQletZUCN5ZP8uQsu/3w+mBciZlIcp96AQ9JvJt4yvzC0o
	 WXYL5cpKvNHSg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 24 Jul 2023 13:46:00 +0100
Subject: [PATCH v2 13/35] arm64/el2_setup: Allow GCS usage at EL0 and EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230724-arm64-gcs-v2-13-dc2c1d44c2eb@kernel.org>
References: <20230724-arm64-gcs-v2-0-dc2c1d44c2eb@kernel.org>
In-Reply-To: <20230724-arm64-gcs-v2-0-dc2c1d44c2eb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1466; i=broonie@kernel.org;
 h=from:subject:message-id; bh=9XX9E5bnVFdIImff20pSxEMqbLIiek/DMAIXfYv+R4o=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkvnKTRmQLErEFRBBYg+Wbp1aqvIROIrxg58PycEEj
 0Ca8O2uJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZL5ykwAKCRAk1otyXVSH0PeWB/
 43JSGiLX6LknAkLSD0zagOZzi4Y1yVo7nGNH51v7xJ7whHCsfvpoJNdIpvQGPh45crFz//2hx4t1fC
 BYKaQhm3AjI7TftskMYTu7Zp0PomNd9+8vxQ40d4MXiN0n4s/3EenpAm0P+dHOhzbsvlgftw0G/snF
 F/BkDxmVhH9JwOsIzECiA/+/WlS3QCsQHozivU2FJcJMbp1+1b5YIAKbqOjudCE7TiYTn/67OYXX10
 7Znmss95RUIGq5jrXZqJrlETZfMgTOyqrm2yCaqz/+elkAV+/9+H52fF264XY2aV0HYdKAU09IUDz/
 7rT8PWTrrne0LMXoQ/8PvFeFVSRFKK
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

There is a control HCRX_EL2.GCSEn which must be set to allow GCS
features to take effect at lower ELs and also fine grained traps for GCS
usage at EL0 and EL1.  Configure all these to allow GCS usage by EL0 and
EL1.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

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

-- 
2.30.2

