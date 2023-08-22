Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975667F
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 14:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D8DC433C8;
	Tue, 22 Aug 2023 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692713219;
	bh=o3F0gqwirOzTh8gwGkZMmsXM7Yu/yi+gPnGo/AGnFQM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Lodozd7lEcs8J8FHBWLzVHqcOediGHFTgfJTa8pByGLpGgE9Q/VT6PR8A4mOPzYND
	 0KSwGzmqkW7hGOD0yjOwIlAVM5Tgey2CgQIQAzDxCQtAduKwx3YTSwqwT2ykASKHZ+
	 gsbGmVZFTV2NezkO3DVeHrsFeKeoBprifsT1k9Hdhhz8I9ppAJNE3rKe0X2XyIolrU
	 SR/2hnR8YcJaBeRb3a6+UDlBVdgD4NYymWgF2gb8gL3OEL5eP9J2wsIK+135u1b1YE
	 L0py6zI5WnusoyHZZm5LHVDhTfEoPicpqiNM6HhpE9bbUMYdCfKB+MrMU/oqnYlKnD
	 l9rK9n4JLQ9EQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 22 Aug 2023 14:57:10 +0100
Subject: [PATCH v5 37/37] kselftest/arm64: Enable GCS for the FP stress
 tests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-arm64-gcs-v5-37-9ef181dd6324@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3085; i=broonie@kernel.org;
 h=from:subject:message-id; bh=o3F0gqwirOzTh8gwGkZMmsXM7Yu/yi+gPnGo/AGnFQM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk5MANh6zZuU8eIQ51uNZ/NOE2FMu2W5WwarFAKQ4/
 z+TXFFWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZOTADQAKCRAk1otyXVSH0GsJB/
 4wKNrGwCSwijToaO8YpJXzGD9AtXsF3A1WkYgSJizhypJazSZrPix+J3YxSC6VvSvp1yAyxQ6HEqpE
 sDL1EvYX9GSXJbRnHsPE3Jm0uQjbCZRWa8nPi5dJgslWqF5/lALnitZADjBWV+hiyjLEt6kg5wbbyO
 Ls+zjygM+M8lBrHe0oOBiR5bRJZD9RcB+6HIAW+lqniWADoj7cdAfOa28StXYilwhXMffRAs7XX274
 knCUAPnvn3q3YnF36F/uqXOqYBTfGa+vzZSO4I5X2FpWi8fWnaUVmHfnI7/vjtkMGISJn7FhFBJWIj
 sTYdbVsWLxUbx4Jex1+ysaixwFtpt7
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While it's a bit off topic for them the floating point stress tests do give
us some coverage of context thrashing cases, and also of active signal
delivery separate to the relatively complicated framework in the actual
signals tests. Have the tests enable GCS on startup, ignoring failures so
they continue to work as before on systems without GCS.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/fp/assembler.h   | 15 +++++++++++++++
 tools/testing/selftests/arm64/fp/fpsimd-test.S |  2 ++
 tools/testing/selftests/arm64/fp/sve-test.S    |  2 ++
 tools/testing/selftests/arm64/fp/za-test.S     |  2 ++
 tools/testing/selftests/arm64/fp/zt-test.S     |  2 ++
 5 files changed, 23 insertions(+)

diff --git a/tools/testing/selftests/arm64/fp/assembler.h b/tools/testing/selftests/arm64/fp/assembler.h
index 9b38a0da407d..7012f9f796de 100644
--- a/tools/testing/selftests/arm64/fp/assembler.h
+++ b/tools/testing/selftests/arm64/fp/assembler.h
@@ -65,4 +65,19 @@ endfunction
 	bl	puts
 .endm
 
+#define PR_SET_SHADOW_STACK_STATUS      72
+# define PR_SHADOW_STACK_ENABLE         (1UL << 0)
+
+.macro enable_gcs
+	// Run with GCS
+	mov	x0, PR_SET_SHADOW_STACK_STATUS
+	mov	x1, PR_SHADOW_STACK_ENABLE
+	mov	x2, xzr
+	mov	x3, xzr
+	mov	x4, xzr
+	mov	x5, xzr
+	mov	x8, #__NR_prctl
+	svc	#0
+.endm
+
 #endif /* ! ASSEMBLER_H */
diff --git a/tools/testing/selftests/arm64/fp/fpsimd-test.S b/tools/testing/selftests/arm64/fp/fpsimd-test.S
index 8b960d01ed2e..b16fb7f42e3e 100644
--- a/tools/testing/selftests/arm64/fp/fpsimd-test.S
+++ b/tools/testing/selftests/arm64/fp/fpsimd-test.S
@@ -215,6 +215,8 @@ endfunction
 // Main program entry point
 .globl _start
 function _start
+	enable_gcs
+
 	mov	x23, #0		// signal count
 
 	mov	w0, #SIGINT
diff --git a/tools/testing/selftests/arm64/fp/sve-test.S b/tools/testing/selftests/arm64/fp/sve-test.S
index 4328895dfc87..486634bc7def 100644
--- a/tools/testing/selftests/arm64/fp/sve-test.S
+++ b/tools/testing/selftests/arm64/fp/sve-test.S
@@ -378,6 +378,8 @@ endfunction
 // Main program entry point
 .globl _start
 function _start
+	enable_gcs
+
 	mov	x23, #0		// Irritation signal count
 
 	mov	w0, #SIGINT
diff --git a/tools/testing/selftests/arm64/fp/za-test.S b/tools/testing/selftests/arm64/fp/za-test.S
index 9dcd70911397..f789694fa3ea 100644
--- a/tools/testing/selftests/arm64/fp/za-test.S
+++ b/tools/testing/selftests/arm64/fp/za-test.S
@@ -231,6 +231,8 @@ endfunction
 // Main program entry point
 .globl _start
 function _start
+	enable_gcs
+
 	mov	x23, #0		// signal count
 
 	mov	w0, #SIGINT
diff --git a/tools/testing/selftests/arm64/fp/zt-test.S b/tools/testing/selftests/arm64/fp/zt-test.S
index d63286397638..ea5e55310705 100644
--- a/tools/testing/selftests/arm64/fp/zt-test.S
+++ b/tools/testing/selftests/arm64/fp/zt-test.S
@@ -200,6 +200,8 @@ endfunction
 // Main program entry point
 .globl _start
 function _start
+	enable_gcs
+
 	mov	x23, #0		// signal count
 
 	mov	w0, #SIGINT

-- 
2.30.2

