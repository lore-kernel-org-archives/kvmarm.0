Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755D28BF0
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7CBC43391;
	Mon, 31 Jul 2023 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690811460;
	bh=Z3injfV8td0LqFLeGew+/6AX1Y4kpAJIpTs5MPlZTRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=k3YNCVgYLsgC7I6xYzEDFO+Vmi0WhkU4SktWcd8Nm0Vo89TlCvZBycZ7voKApGHEC
	 V6MZkrm/40djJvKb7iZQj+PkClbQW1Lmw2/syzWw4I8zmblgwD5KnW+jTNFWVEjhFt
	 Im+kx/njeqKjHQLrl6rI/59COJ/U6X2Z+zlzpWZb6tTkTPTdzILJ9q5X/oIZPfNtLx
	 YsPUY/BmonW0TjFsLzbfUrqLBl9bQ9hHMSjHDLnHvCFVtDOW0+CKR3gPP8A/0N6AXP
	 Z0V3c8QcBCOGy56LPU4SycoAdhbYULHEBhhR4EYmxFsP4FDmzn5b2wu0jp7rRJ8eYV
	 uKV8NlDhdQDtQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 31 Jul 2023 14:43:11 +0100
Subject: [PATCH v3 02/36] arm64: Document boot requirements for Guarded
 Control Stacks
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230731-arm64-gcs-v3-2-cddf9f980d98@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1640; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Z3injfV8td0LqFLeGew+/6AX1Y4kpAJIpTs5MPlZTRs=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkx7wVRPBwF81QwuAAfHka+YbfJBsFwj9E3IMNNrus
 2znQhqaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZMe8FQAKCRAk1otyXVSH0DKpB/
 9pHBhjhaJjZB9lpMdNi3cp0cv7iYnygYFRTHP2i2jHJCFZWkjIM9q5ZGzHbz0XxziD2Jvfu0FQSK6U
 yoTifQAlyZyMgOjcb0twJlVDLNIvgiy3AuvE2CnpPNMUq56YZDqX8wMVDUXfr7I0B9C+LL8H14OGvi
 Px0q6QR2PE/xHeVpTwhUR7r6sgg455oDOWRZp6WWwtq32a8MEy3v/tHxADQtn+5P1OxfL6skkPINyH
 Qd4/Z8wzHZoZMqRunTBaJaA95Dxo6lxhNRuv32JApLGdr48EipVoC+Q7qGZNQm+SCKfiO06QoUiEE0
 ftju6NNrgqaB/gxFusDcRrQAtMuqi1
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

FEAT_GCS introduces a number of new system registers, we require that
access to these registers is not trapped when we identify that the feature
is detected.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/arch/arm64/booting.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index b57776a68f15..de3679770c64 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -411,6 +411,28 @@ Before jumping into the kernel, the following conditions must be met:
 
     - HFGRWR_EL2.nPIRE0_EL1 (bit 57) must be initialised to 0b1.
 
+ - For features with Guarded Control Stacks (FEAT_GCS):
+
+  - If EL3 is present:
+
+    - SCR_EL3.GCSEn (bit 39) must be initialised to 0b1.
+
+ - If the kernel is entered at EL1 and EL2 is present:
+
+    - HFGITR_EL2.nGCSEPP (bit 59) must be initialised to 0b1.
+
+    - HFGITR_EL2.nGCSSTR_EL1 (bit 58) must be initialised to 0b1.
+
+    - HFGITR_EL2.nGCSPUSHM_EL1 (bit 57) must be initialised to 0b1.
+
+    - HFGRTR_EL2.nGCS_EL1 (bit 53) must be initialised to 0b1.
+
+    - HFGRTR_EL2.nGCS_EL0 (bit 52) must be initialised to 0b1.
+
+    - HFGWTR_EL2.nGCS_EL1 (bit 53) must be initialised to 0b1.
+
+    - HFGWTR_EL2.nGCS_EL0 (bit 52) must be initialised to 0b1.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented

-- 
2.30.2

