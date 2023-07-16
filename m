Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8B49443
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35E3C433CA;
	Sun, 16 Jul 2023 21:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544545;
	bh=Go+3eKanODPQVKnV1QnMIrC75/lXwO2PkPnkMfOn2oA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ECT5d5diCXHo8bURXVIe57IrwH3LVPYaT55I2eb0E/Np71GzQcUGWtEUntEplKCwC
	 fSmOAVmBorLnsgdHECB59B6DWbXGccZoyiGERfCXmTdxh7yjb1uTsifR2DxSsYeO2g
	 U59ZQuj5PrDb+/agN7Dl9Qr1uBqTthk1hxAJleZaJ4gtKJsKCutWsOB4+ssCclqi5/
	 H9dWxEzsXwaori9qPClLzwpRbupwk9Ahieh4tVmZfRl24pHmhdyqWIGn9qVn3eme22
	 Pf5Swp61Fy74Mc9DWDxTGwXq9nrTn7ONg7lOy18b9YDt4vbk8A7gQZNsWJcUnRxvOG
	 XtfE91WRSD4iA==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:51:24 +0100
Subject: [PATCH 28/35] kselftest/arm64: Add GCS as a detected feature in
 the signal tests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-28-bf567f93bba6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1828; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Go+3eKanODPQVKnV1QnMIrC75/lXwO2PkPnkMfOn2oA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGalnGeU3K7oX3kc7kc1vOCWlIGVrULEZrhSEdLZ
 vws1w6CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmpQAKCRAk1otyXVSH0AFnB/
 9US05dk0B/KCfZYMHoYXXScr7LLlbQV9vVecVF7KEFOCMc4EuaMKkGy1uQfpsJ0o9xGpwumm9m1qG8
 p9K1kLmFInC+9t6XitfcPIRPnKUxan5FQ3yiLuUWWVu+tmyJX2kWaffOTAuKj7zO25Pwt2c9YW5oEa
 f9VjL6uJP9BDwSSRNbN7mBs9zRr+yc9wX4u0gvytmfyGkk0jEWoHm8dF/xwK5qyFYXm4giL26Q8iFG
 354GpQCiMKtFPNDO8A4H9GdYiNecTC7cDsCOSsa7a/giwNB848wAuQmV6vpgDwXDhUhupaTLe9yjoB
 yXFF55Ml7rxGBuJJFbC4EDNdyHgRPd
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

