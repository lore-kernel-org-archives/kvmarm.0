Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A614429
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BDAC433C8;
	Mon, 31 Jul 2023 13:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690811536;
	bh=AFWazg68H0m9wjDZ4noTEGRptXvqnY78FqkUfPNC3A0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qc9Cd3nsgAyvcnwoo8kjfvODViUMK/JrpplYrZmumxrpWFJkJgxfoQAAtQmXEy0Lk
	 +BPICxB2b5iJoYLZwa0Jy5i1GxG9YIrojweNPdWyJVzG1jxxxRPdKVcGGNfBZEQN3d
	 wsyQTHgkf2Uli6I54jqcE+RO9BXn+IUy/XBzVw71H52zCnwD+UnFVmUMjzhkXeisKT
	 ndonCSJ6lvOmOBKfDsHnCf8OPCWOfK3Ab38QA5IevbVuoJI+Nd3ztF9g/4q46sXqwz
	 4ifG4jd0dqb7O5FLA4kXSOlehpBDXmsKLitwge5sUvbAwDZ3wl385xQYSuc/oRzuY9
	 NQbLtaaDejXyA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 31 Jul 2023 14:43:23 +0100
Subject: [PATCH v3 14/36] arm64/idreg: Add overrride for GCS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230731-arm64-gcs-v3-14-cddf9f980d98@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1796; i=broonie@kernel.org;
 h=from:subject:message-id; bh=AFWazg68H0m9wjDZ4noTEGRptXvqnY78FqkUfPNC3A0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkx7wfsdqpq88pf21TmYD/kSPpHacilejyJipE9rew
 1epzW+eJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZMe8HwAKCRAk1otyXVSH0HDLB/
 4yUwsgP3uSC4+rw/h+6GLVLLbWnwEshdB3p5ype/gL221KLRVejx6eisgNL+pRT0FoOZasEebBFy7V
 l3F4UOacmzLSyAjRqciWaUncXUx9KC1IpVzU1S28E79KFcLF2vy+7j7EImZ8BKfvXMTxZGsE/GD1Um
 9vmoI+8hK1BDY37dFDU4ybU203laJL21E1mO+eha2WzkwBUpZPwvvOADhgRsAhRugj9ZH2/+OVOO9i
 nKw/U0a4c7zTjo4m/ynqmyH4Q5Kve+hBrUTt7EX1y92BhSlWCUq7CE12LfbYdf5AFCm0sa+xlUQNy9
 KrHgEE14UYJyMKjTyCJ53jOgHgF8Xz
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Hook up an override for GCS, allowing it to be disabled from the command
line by specifying arm64.nogcs in case there are problems.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +++
 arch/arm64/kernel/idreg-override.c              | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a1457995fd41..86662eed3003 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -418,6 +418,9 @@
 	arm64.nobti	[ARM64] Unconditionally disable Branch Target
 			Identification support
 
+	arm64.nogcs	[ARM64] Unconditionally disable Guarded Control Stack
+			support
+
 	arm64.nopauth	[ARM64] Unconditionally disable Pointer Authentication
 			support
 
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 2fe2491b692c..49269a5cff10 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -99,6 +99,7 @@ static const struct ftr_set_desc pfr1 __initconst = {
 	.override	= &id_aa64pfr1_override,
 	.fields		= {
 		FIELD("bt", ID_AA64PFR1_EL1_BT_SHIFT, NULL ),
+		FIELD("gcs", ID_AA64PFR1_EL1_GCS_SHIFT, NULL),
 		FIELD("mte", ID_AA64PFR1_EL1_MTE_SHIFT, NULL),
 		FIELD("sme", ID_AA64PFR1_EL1_SME_SHIFT, pfr1_sme_filter),
 		{}
@@ -178,6 +179,7 @@ static const struct {
 	{ "arm64.nosve",		"id_aa64pfr0.sve=0" },
 	{ "arm64.nosme",		"id_aa64pfr1.sme=0" },
 	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
+	{ "arm64.nogcs",		"id_aa64pfr1.gcs=0" },
 	{ "arm64.nopauth",
 	  "id_aa64isar1.gpi=0 id_aa64isar1.gpa=0 "
 	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "

-- 
2.30.2

