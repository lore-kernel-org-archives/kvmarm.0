Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856059444
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 21:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC2FC43142;
	Sun, 16 Jul 2023 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689544419;
	bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N6Pc2CDP2Fb/CWuUDjX3L2i0ZPs0IpSy9dO8henIB7I6mnpUje22Hdq7vEkPoDu4g
	 xlUhGW7pGAfAaNvDt/AWVxPC9oVQigNpTWBFs3yT8OmZrnurbVB6ZSH47hJ8kJHGps
	 /CKIzVsFqEyOneTsq1XBiXSubk3NPS/GJ53et7TS5RCXk8P8JPg9TJv7ADl3cE+jMR
	 2Lv7yqFwLn763rYXqdfJmftd7l7TfWFXs77BEpS4ZRGT1pc7HfxAL+znSFso1IKx1B
	 OWq8cE8ajUxaBeQT9T5L2qJfdtU3Rk+8gE/R1JgbzSnLYpvSNL/Kk+RDrNFzSoSKjD
	 hOnLbmzUYvqMw==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 16 Jul 2023 22:51:04 +0100
Subject: [PATCH 08/35] arm64/gcs: Provide copy_to_user_gcs()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230716-arm64-gcs-v1-8-bf567f93bba6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1292; i=broonie@kernel.org;
 h=from:subject:message-id; bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBktGaVbZOcNR1zm48d/PDpByZZT+P9TDlC/pnz5eN6
 pCwzjnmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZLRmlQAKCRAk1otyXVSH0NbvB/
 wMIKD7ugV+VGhtSx4GuImqrZE4Tt0v3p8oBLZxXnjjkk1AYFsZ51ITwpSRYveuCeKhGKo5TdlPUqq5
 TGV7QEaKfNACSPh5SL7WiaECcFcN2MFP4z0THUL92xm6KgWL8A5oYlnHOIbNrYSp5p+HKE5VzgWCLS
 Bel51HElY2q2sRqHhDjGaBnNawBEB+529JBmGA4cJrZWRzpq1QDAAlDitHTbFgXJqkPHlYS0HrDocs
 7p5w7QGKS/6G7JCZKBJOh6NXwMc697BG+KkqF9GoRnNKL5uLZxWkUHt86kkP+CXzx2r70LhZbSffyb
 gkXMfL//6nmpK2o0vvxfDTXp2gd7H/
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order for EL1 to write to an EL0 GCS it must use the GCSSTTR instruction
rather than a normal STTR. Provide a copy_to_user_gcs() which does this.
Since it is not possible to store anything other than a 64 bit value the
interface is presented in terms of 64 bit values, using unsigned long
rather than u64 due to sparse.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/uaccess.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 22e10e79f56a..24aa804e95a7 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -445,6 +445,26 @@ static inline int gcssttr(unsigned long __user *addr, unsigned long val)
 	return err;
 }
 
+static inline int copy_to_user_gcs(unsigned long __user *addr,
+				   unsigned long *val,
+				   int count)
+{
+	int ret = -EFAULT;
+	int i;
+
+	if (access_ok((char __user *)addr, count * sizeof(u64))) {
+		uaccess_ttbr0_enable();
+		for (i = 0; i < count; i++) {
+			ret = gcssttr(addr++, *val++);
+			if (ret != 0)
+				break;
+		}
+		uaccess_ttbr0_disable();
+	}
+
+	return ret;
+}
+
 #endif /* CONFIG_ARM64_GCS */
 
 #endif /* __ASM_UACCESS_H */

-- 
2.30.2

