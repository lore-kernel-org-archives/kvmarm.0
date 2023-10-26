Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADED2DF72;
	Thu, 26 Oct 2023 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZ0MZpl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473F1C433A9;
	Thu, 26 Oct 2023 12:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698324449;
	bh=jvyJQ++Epw5Vr3/tG/z6+6Y9vzI/cjN2rH2C/CkHcMI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LZ0MZpl6XyIbRCQSR3qngzCxL25r+kMUZjp0l8dkBGoar7NqMu+KkcYButfhgnMUn
	 NOrfsRerpfvvDS8CM6dExs8+/voaf+gaqwBHae9vNvumhMGH2AONyYHTL68nSru1GY
	 BQoTyVwqDnoFIYG4GtDujyxTJasmvjAEJAyBu23YgTjL3nKNtCl5lx+y6+pglx+n+8
	 AKuVY03y2zLW94cepUY6KOdcOlvxK9wpx4TWtPLxv/deGCrNbgIH7XStTYJlp2iE7n
	 Vx5OLNGxVEo5eQEAhhf2Rh3tFJid/ylmgjDONqQBvJDfBzwyTFhdMQCgKRYFdA8DTF
	 FNHWpq4SVQmaQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 26 Oct 2023 13:44:31 +0100
Subject: [PATCH 17/21] kselftest/arm64: Handle FPMR context in generic
 signal frame parser
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-arm64-2023-dpisa-v1-17-8470dd989bb2@kernel.org>
References: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
In-Reply-To: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1642; i=broonie@kernel.org;
 h=from:subject:message-id; bh=jvyJQ++Epw5Vr3/tG/z6+6Y9vzI/cjN2rH2C/CkHcMI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlOl+hZwT3cvJYy1Fe0uSW7ilAIrLsfVqPDMGDJBj+
 sbstakqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZTpfoQAKCRAk1otyXVSH0Hv0B/
 4nU5Ksm38FJDiCveE6OFGBsnIzpJDyX5B6sIhBu3Hl0BRah5M1xTjHcMiIm+tZYNtK7A/5Z9igDFLn
 vNObblCdl7Pf26XGmZmPx7+GpFxwlq/nn5m/3nes5vNmxDpP90Xu27GOBXleBmDXoapTzQYpSR4tLo
 cZ71uqvXuuahXvfgmOaWvsaIwHtvghjgiyaXPqaWlx0Zlpe+PnvYO90G3vu8XSdKyDr4/WgJ8UeRDn
 he7bt6QgTMyill3+AVZfnF0RrEq8sNQSMkcEdwvh0FwSjyh/bzeRq/PRFgckvyBHTxt2G1bofy84dv
 z/899qHVwAUbBHauS2P+WXL652lg/n
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Teach the generic signal frame parsing code about the newly added FPMR
frame, avoiding warnings every time one is generated.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/signal/testcases/testcases.c | 8 ++++++++
 tools/testing/selftests/arm64/signal/testcases/testcases.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
index 9f580b55b388..674b88cc8c39 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
@@ -209,6 +209,14 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
 			zt = (struct zt_context *)head;
 			new_flags |= ZT_CTX;
 			break;
+		case FPMR_MAGIC:
+			if (flags & FPMR_CTX)
+				*err = "Multiple FPMR_MAGIC";
+			else if (head->size !=
+				 sizeof(struct fpmr_context))
+				*err = "Bad size for fpmr_context";
+			new_flags |= FPMR_CTX;
+			break;
 		case EXTRA_MAGIC:
 			if (flags & EXTRA_CTX)
 				*err = "Multiple EXTRA_MAGIC";
diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.h b/tools/testing/selftests/arm64/signal/testcases/testcases.h
index a08ab0d6207a..7727126347e0 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.h
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.h
@@ -19,6 +19,7 @@
 #define ZA_CTX		(1 << 2)
 #define EXTRA_CTX	(1 << 3)
 #define ZT_CTX		(1 << 4)
+#define FPMR_CTX	(1 << 5)
 
 #define KSFT_BAD_MAGIC	0xdeadbeef
 

-- 
2.30.2

