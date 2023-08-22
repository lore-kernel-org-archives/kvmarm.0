Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759A59443
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 14:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3089FC433AB;
	Tue, 22 Aug 2023 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692713013;
	bh=8dG7a5zhnwPAZeiNFnvKUhXNUal9236c6/e90HmcsCA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gxgJUaQvy5XcROS6md5Iyq3IvRwllUFGSh7/wGQ7eqaMtdeiVs0DM0K3WdbkTzacE
	 hZsYqB5ynIrK9bj8ilHCgmFyTR7YuvCa1BStsMUe0bucTXynu/hUaEOrIITUY8fHiU
	 Mzrda+1IW6rodx6yXxbM9SkXxBWIR5SbPSTJEfxzJN5a5dBv6OVfT7B8sXDIAcWZFe
	 oHwBCJoaYkJxmgOGzbOfdHAZ/wsKW1rIRiUwjqurKNkTNEF+Xhd6f7EJspjQLoYaC3
	 NOSIOa6QGwvsnJG6Ka7XP8gxlDU7cj2/2oMlZ1ybfpewshExT4I7RIns+k8x+i4Hwe
	 UwJdj0K5HCI2w==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 22 Aug 2023 14:56:38 +0100
Subject: [PATCH v5 05/37] arm64/sysreg: Add new system registers for GCS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-arm64-gcs-v5-5-9ef181dd6324@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1873; i=broonie@kernel.org;
 h=from:subject:message-id; bh=8dG7a5zhnwPAZeiNFnvKUhXNUal9236c6/e90HmcsCA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk5L/zCtdFWzHnlWug8mDyrQBzQGAK0DHuPph0D8Ch
 GC3bJQuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZOS/8wAKCRAk1otyXVSH0AZ3B/
 92STkyE/qyhuJXP8cvdO4zowiqGHxKDQVlkdGEvqFsUNmFill+z3hdsi4uH9CPfBs70iMMIt9eXawf
 5wCSSXuW5L6RwsU5/7qOYbsXRRk+kQ79UMHdrClm5s9UGgrVgeJ7jo15JjHDnUyYFhg3Nxqh0UKp9F
 cPOlTxdUfRq8/lrupQINYygUX/LVSkP2qdaFynvhkZkvKsTu+RHIlTI4rdCPJZ9Lq4DJA9Z32kIFKy
 LxvSAIX4IpcdnjgpmeWj/BxQ+mcR6reN9mim7fGdG4EhzZHrUPXDhI4gJ0kIGPWvaMA0Qa4UTJ7L0s
 6wc0Ugx5e7MBzxYnOIyCRkX3Fg6ygf
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

FEAT_GCS introduces a number of new system registers. Add the registers
available up to EL2 to sysreg as per DDI0601 2022-12.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 65866bf819c3..20c12e65a304 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1780,6 +1780,41 @@ Sysreg	SMCR_EL1	3	0	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+SysregFields	GCSCR_ELx
+Res0	63:10
+Field	9	STREn
+Field	8	PUSHMEn
+Res0	7
+Field	6	EXLOCKEN
+Field	5	RVCHKEN
+Res0	4:1
+Field	0	PCRSEL
+EndSysregFields
+
+Sysreg	GCSCR_EL1	3	0	2	5	0
+Fields	GCSCR_ELx
+EndSysreg
+
+SysregFields	GCSPR_ELx
+Field	63:3	PTR
+Res0	2:0
+EndSysregFields
+
+Sysreg	GCSPR_EL1	3	0	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
+Sysreg	GCSCRE0_EL1	3	0	2	5	2
+Res0	63:11
+Field	10	nTR
+Field	9	STREn
+Field	8	PUSHMEn
+Res0	7:6
+Field	5	RVCHKEN
+Res0	4:1
+Field	0	PCRSEL
+EndSysreg
+
 Sysreg	ALLINT	3	0	4	3	0
 Res0	63:14
 Field	13	ALLINT
@@ -2010,6 +2045,10 @@ Field	4	DZP
 Field	3:0	BS
 EndSysreg
 
+Sysreg	GCSPR_EL0	3	3	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
 Sysreg	SVCR	3	3	4	2	2
 Res0	63:2
 Field	1	ZA
@@ -2209,6 +2248,14 @@ Sysreg	SMCR_EL2	3	4	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	GCSCR_EL2	3	4	2	5	0
+Fields	GCSCR_ELx
+EndSysreg
+
+Sysreg	GCSPR_EL2	3	4	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
 Sysreg	DACR32_EL2	3	4	3	0	0
 Res0	63:32
 Field	31:30	D15
@@ -2268,6 +2315,14 @@ Sysreg	SMCR_EL12	3	5	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	GCSCR_EL12	3	5	2	5	0
+Fields	GCSCR_ELx
+EndSysreg
+
+Sysreg	GCSPR_EL12	3	5	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
 Sysreg	FAR_EL12	3	5	6	0	0
 Field	63:0	ADDR
 EndSysreg

-- 
2.30.2

