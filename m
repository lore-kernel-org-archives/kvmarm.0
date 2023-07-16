Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8E39444
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4103C433C9;
	Sun, 16 Jul 2023 21:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544388;
	bh=Z3injfV8td0LqFLeGew+/6AX1Y4kpAJIpTs5MPlZTRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N+Py4rEKJjLcKslfUQhgfO1OLzM2rGuwjpOszMNXo+y2NlpsFHeY3dbTRq/heqKTb
	 wCotmXx42Mh4PFe5yqcrpQXV5HgTXSOOBEZ0RghiFHyfOaEpsg06fHhTe/tHw/6OcC
	 BTi00ukC4eUl1XRMgUsAcmJBP7sjQxXyLeTfrrXdgYTCff4OLLtV6gVZjP8iCXVcKB
	 P6nPf6DSHHfQz0nOcp8DDAG7JTMQcPwLVb6A5VLrHSwjq+I6/Q3R2TD5f/rPdDi8zy
	 3R8S3ECtvSSDliWtVW2gcieOb6yEb9YfvQqE8rjxrvgADtdRuLMv9zHcIhdhHgr48K
	 TLshLQx2OIL8w==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:50:59 +0100
Subject: [PATCH 03/35] arm64: Document boot requirements for Guarded
 Control Stacks
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-3-bf567f93bba6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1640; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Z3injfV8td0LqFLeGew+/6AX1Y4kpAJIpTs5MPlZTRs=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGaRKKWoYO6shp83J7bdF2HDjv/deCuL6Bh7YBpr
 XGGHoyKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmkQAKCRAk1otyXVSH0DHnB/
 4m4xAjhCNKrOG833NrlQvIqQ8SUd4K5W5qh5Ps/ZgIVd+0dZkeIAFcRu2fAfuuHQl4Sg+SRkRdWPge
 eeiRzTVTFyv2RXMEQOPvtv1m5NUn4oCojVB4hywZSC/rE9XrRGNDjGZyEOO2ylprq2nf3mDYWjstJh
 9jCBGUEEhqXr1LT17uFMA1zEsO7JJeQ33aTE6kDdjYlBrhTZq43pRfEROGeW7Dhgjx3sd6KCVltGCU
 WGPGxd+7M83m+GVw87chK92IZYO0+Fe1tKdfMfbfNslHg415niWo8ao4Tm76iYPut036lAZhbttboW
 zekDSpXoOfhPseiRPDqOQA1eWCZErE
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

