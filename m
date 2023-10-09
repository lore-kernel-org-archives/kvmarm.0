Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E54414F72
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 12:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uW2YvwkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC675C433CB;
	Mon,  9 Oct 2023 12:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696853485;
	bh=dnQiLWCQEIWy/Xq7xUVmoEvPZ7/L9XTfsPiddNnhH8A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uW2YvwkTEs3ksNnBeyCkmHvcg7Hg45MTQOrvX344Mz095Y2nBmnaK61KvKyW5feOb
	 f+HQRctmZfEFAzdsuUP4ETQaCQOOmd0zQw8Z4ksCz6K9hEhCwCPfvutNq6j2WD6vmj
	 4pZr9m/47nVQFEVwotHX0Esp6jxSPTzu8BCaa0T9mYgV7uNgC2U8xiw1lhPXIW7knn
	 ELoN/tObaoGVa+rdJP5Z5qYUZYF3VtUWJEpFVOSJFOS6A9HGzHFORbRPu9ErGrSjQC
	 8zpmiTl07f7AolAPvTFvKuOG/xJLeHqxbUiM5buTP5J+4fA3i09lEyQKTacVUD5oPS
	 grZRCB+QM3npg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 09 Oct 2023 13:08:41 +0100
Subject: [PATCH v6 07/38] arm64/sysreg: Add definitions for architected GCS
 caps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231009-arm64-gcs-v6-7-78e55deaa4dd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1361; i=broonie@kernel.org;
 h=from:subject:message-id; bh=dnQiLWCQEIWy/Xq7xUVmoEvPZ7/L9XTfsPiddNnhH8A=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlI+2WHMOtW7oALvhLQJzuMUteJm/EdFfby1ez8IFL
 vZyYW8OJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZSPtlgAKCRAk1otyXVSH0CRDB/
 44i2mEo1C6AV0kBavJlNrHUoe01OCdzz/4EZVGIvfLNMche/CoZDy2oB/+y3rrHCMkeSEwFG4KcFyC
 VnY88Rj9OOm0uZVKN9lUzQ9Aboh+Bi3RgzyK8XcLr9nza0lytLsRy9LRhol8LKzq3qVAiv/79KB5mQ
 6qpMbIMPk0FLn6qsC/iAjW/tbSgEmSfH00+X8llt831T8OpphOjxb8HdOOpRpV34JrA44UIyFWAtxX
 dkrGQX6Gpxd4DhjR16V1xYXaJiITXqvrJ1xhJf43u7igOOFiEW7N5vuix/L6mtmFwahxXcJFwM7/XT
 FmiKMyTaKx8MiwzpDMZjLMwG5iuqwL
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The architecture defines a format for guarded control stack caps, used
to mark the top of an unused GCS in order to limit the potential for
exploitation via stack switching. Add definitions associated with these.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 38296579a4fd..6a550781d71e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -994,6 +994,26 @@
 
 #define PIRx_ELx_PERM(idx, perm)	((perm) << ((idx) * 4))
 
+/*
+ * Definitions for Guarded Control Stack
+ */
+
+#define GCS_CAP_ADDR_MASK		GENMASK(63, 12)
+#define GCS_CAP_ADDR_SHIFT		12
+#define GCS_CAP_ADDR_WIDTH		52
+#define GCS_CAP_ADDR(x)			FIELD_GET(GCS_CAP_ADDR_MASK, x)
+
+#define GCS_CAP_TOKEN_MASK		GENMASK(11, 0)
+#define GCS_CAP_TOKEN_SHIFT		0
+#define GCS_CAP_TOKEN_WIDTH		12
+#define GCS_CAP_TOKEN(x)		FIELD_GET(GCS_CAP_TOKEN_MASK, x)
+
+#define GCS_CAP_VALID_TOKEN		0x1
+#define GCS_CAP_IN_PROGRESS_TOKEN	0x5
+
+#define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
+					       GCS_CAP_VALID_TOKEN)
+
 #define ARM64_FEATURE_FIELD_BITS	4
 
 /* Defined for compatibility only, do not add new users. */

-- 
2.30.2

