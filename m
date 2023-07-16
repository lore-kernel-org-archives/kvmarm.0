Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354279443
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F00BC433C8;
	Sun, 16 Jul 2023 21:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544558;
	bh=JCh6BoCIOxePO8zZIr/FO/CERnc7ZRYHEz9dpM/Qpg4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mvLNywoqXfGXI/ctEdvYGrd7JRs9EWxGSMKyuk+ykhRpKRZKRHZiuir9Q9MtcqXbC
	 fEDViBWIBTD3WdXcBR+p9Ec3fV+G3xrCCRLNQTh8hliPPF8DCfmZXR2tQdwhfj5Nju
	 cVZzR6x6/YvhJKwrG2JkrAHfmpSPyy605CxrUmupnYZ14nJejGr5QQpdl1F4cfaQnU
	 pxS/P5sabCOHPzeIRzZgRF97QJrQoRb8BRNWHLrYHC2RX7iLzCjA/UsOzgFk7sQJy/
	 gz/NWGnQhC26q4r1DlznLrPEOFsp7ht2HKCx9LrZXJ4Iq5qqfzB/0FzVZ9IcHEsZfX
	 KSjHG/vW1nIwA==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:51:26 +0100
Subject: [PATCH 30/35] kselftest/arm64: Allow signals tests to specify an
 expected si_code
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-30-bf567f93bba6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2627; i=broonie@kernel.org;
 h=from:subject:message-id; bh=JCh6BoCIOxePO8zZIr/FO/CERnc7ZRYHEz9dpM/Qpg4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGamoMzx7ez+FWeWsoKQdHkx722W3rsAxNs+L88l
 G76W02CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmpgAKCRAk1otyXVSH0BNIB/
 9X8d1OXFKpFp54/4hJike2qyV3vCa/nH/EGswkOhAAbGKZtvqRmPJFzUPACplmPpWM1LBcBPHDfWQm
 8xKycW/5sZo0DIodflYaBfFvLx/BSv+DAqiRAeabhAU6rcjWSZvvzMmsOwnZ0wTZlGUS6QGvwb9rL2
 AYopbAqh/ButTuvZnnni44xOYAA6WKJFY9H5grcDVZfGZSx2OWqy1fGNWzSHAJxTAYN6ETJQq8FsXA
 0UJd9Us5VlKCsMqlSyFZVlvO5XvOoNnMrSGVrNFgwvsO+RLoyu/Pg6vg8iCO81fNQbbtYDQx7PAEXP
 K/tIBHvCVN3HIaFqgJokRX8X3DXQZ5
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently we ignore si_code unless the expected signal is a SIGSEGV, in
which case we enforce it being SEGV_ACCERR. Allow test cases to specify
exactly which si_code should be generated so we can validate this, and
test for other segfault codes.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 .../testing/selftests/arm64/signal/test_signals.h  |  4 +++
 .../selftests/arm64/signal/test_signals_utils.c    | 29 ++++++++++++++--------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/test_signals.h b/tools/testing/selftests/arm64/signal/test_signals.h
index 7ada43688c02..ee75a2c25ce7 100644
--- a/tools/testing/selftests/arm64/signal/test_signals.h
+++ b/tools/testing/selftests/arm64/signal/test_signals.h
@@ -71,6 +71,10 @@ struct tdescr {
 	 * Zero when no signal is expected on success
 	 */
 	int			sig_ok;
+	/*
+	 * expected si_code for sig_ok, or 0 to not check
+	 */
+	int			sig_ok_code;
 	/* signum expected on unsupported CPU features. */
 	int			sig_unsupp;
 	/* a timeout in second for test completion */
diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.c b/tools/testing/selftests/arm64/signal/test_signals_utils.c
index 89ef95c1af0e..63deca32b0df 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.c
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.c
@@ -143,16 +143,25 @@ static bool handle_signal_ok(struct tdescr *td,
 			"current->token ZEROED...test is probably broken!\n");
 		abort();
 	}
-	/*
-	 * Trying to narrow down the SEGV to the ones generated by Kernel itself
-	 * via arm64_notify_segfault(). This is a best-effort check anyway, and
-	 * the si_code check may need to change if this aspect of the kernel
-	 * ABI changes.
-	 */
-	if (td->sig_ok == SIGSEGV && si->si_code != SEGV_ACCERR) {
-		fprintf(stdout,
-			"si_code != SEGV_ACCERR...test is probably broken!\n");
-		abort();
+	if (td->sig_ok_code) {
+		if (si->si_code != td->sig_ok_code) {
+			fprintf(stdout, "si_code is %d not %d\n",
+				si->si_code, td->sig_ok_code);
+			abort();
+		}
+	} else {
+		/*
+		 * Trying to narrow down the SEGV to the ones
+		 * generated by Kernel itself via
+		 * arm64_notify_segfault(). This is a best-effort
+		 * check anyway, and the si_code check may need to
+		 * change if this aspect of the kernel ABI changes.
+		 */
+		if (td->sig_ok == SIGSEGV && si->si_code != SEGV_ACCERR) {
+			fprintf(stdout,
+				"si_code != SEGV_ACCERR...test is probably broken!\n");
+			abort();
+		}
 	}
 	td->pass = 1;
 	/*

-- 
2.30.2

