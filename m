Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC7F18C15
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 12:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5tE8lnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1117C433C9;
	Mon,  9 Oct 2023 12:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696853640;
	bh=Go+3eKanODPQVKnV1QnMIrC75/lXwO2PkPnkMfOn2oA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z5tE8lnmdXjuy2FqbmQSDL/utDLHfOoZ4eKkj7w/pFe+3P01nqhLYlWUbu46Kb66T
	 MQggDAPnYeq7fIffhSX2fspIXyhKvHV3fcYzejotBmZFk0/3MKUyi/jRYi5wNt5K+X
	 Oa54ejUABuIC3+Js8winzFrZE+yubCehE6R1fsFaKY82wL9X3leYnlD8DgFEeJC1Wt
	 vRFhGhw4q2GODqA4+lX1CM7HM2u3IvA003ToN+sKy1g4py3QVoI+lxBQqzVi5BRe8B
	 QNxy5na8NSMcK74IKtvdeJxxYDIFj9484A4tWvzdF6gUaaprljtOF3zzC/XcH3gwSs
	 f+M/VlaD8QrCg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 09 Oct 2023 13:09:03 +0100
Subject: [PATCH v6 29/38] kselftest/arm64: Add GCS as a detected feature in
 the signal tests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231009-arm64-gcs-v6-29-78e55deaa4dd@kernel.org>
References: <20231009-arm64-gcs-v6-0-78e55deaa4dd@kernel.org>
In-Reply-To: <20231009-arm64-gcs-v6-0-78e55deaa4dd@kernel.org>
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
 Florian Weimer <fweimer@redhat.com>, Christian Brauner <brauner@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1828; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Go+3eKanODPQVKnV1QnMIrC75/lXwO2PkPnkMfOn2oA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlI+2oIo6FOsWYrBJln/h48RApJUprOroIIr+6v3AC
 j4QlW3qJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZSPtqAAKCRAk1otyXVSH0KBKB/
 4rQ16IAS5wQp6WQY1eD2bS9klRAJX/EGZrEuSxlVT2NgqoWHdyR64Ppf4FG1FKuUqvMND5hTvoNO5r
 j6KcnXXEnvj1rbqL+4p87ulL7NX44680MNQJqrr2ev8vbbzXgOZpLp8yKaAV+ZTeW3adrfCoHaRd68
 4vj9950qxYJkRIpQs3PWHIQl7LTy0wFOhiBvvyeygH8sAlKEce8j/t0SCSj1+irzRPsWT7VolGRuoz
 26oZ3vn8jKDTn8gqey9cIe2Kg+tDLrK/FU+K4451nNXAvOqRl7LoBBpIbrg5H0LgHewcu+t0rhnLyW
 9vQzfxF+XMWgy4/GxIOBR1MUoAluz0
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In preparation for testing GCS related signal handling add it as a feature
we check for in the signal handling support code.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/signal/test_signals.h       | 2 ++
 tools/testing/selftests/arm64/signal/test_signals_utils.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/test_signals.h b/tools/testing/selftests/arm64/signal/test_signals.h
index 1e6273d81575..7ada43688c02 100644
--- a/tools/testing/selftests/arm64/signal/test_signals.h
+++ b/tools/testing/selftests/arm64/signal/test_signals.h
@@ -35,6 +35,7 @@ enum {
 	FSME_BIT,
 	FSME_FA64_BIT,
 	FSME2_BIT,
+	FGCS_BIT,
 	FMAX_END
 };
 
@@ -43,6 +44,7 @@ enum {
 #define FEAT_SME		(1UL << FSME_BIT)
 #define FEAT_SME_FA64		(1UL << FSME_FA64_BIT)
 #define FEAT_SME2		(1UL << FSME2_BIT)
+#define FEAT_GCS		(1UL << FGCS_BIT)
 
 /*
  * A descriptor used to describe and configure a test case.
diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.c b/tools/testing/selftests/arm64/signal/test_signals_utils.c
index 0dc948db3a4a..89ef95c1af0e 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.c
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.c
@@ -30,6 +30,7 @@ static char const *const feats_names[FMAX_END] = {
 	" SME ",
 	" FA64 ",
 	" SME2 ",
+	" GCS ",
 };
 
 #define MAX_FEATS_SZ	128
@@ -329,6 +330,8 @@ int test_init(struct tdescr *td)
 			td->feats_supported |= FEAT_SME_FA64;
 		if (getauxval(AT_HWCAP2) & HWCAP2_SME2)
 			td->feats_supported |= FEAT_SME2;
+		if (getauxval(AT_HWCAP2) & HWCAP2_GCS)
+			td->feats_supported |= FEAT_GCS;
 		if (feats_ok(td)) {
 			if (td->feats_required & td->feats_supported)
 				fprintf(stderr,

-- 
2.30.2

