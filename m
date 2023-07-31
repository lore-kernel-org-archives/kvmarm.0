Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0077818AF0
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191C2C433C8;
	Mon, 31 Jul 2023 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690811493;
	bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=khHWcmOuBjaxE6JfX6GKCY29ifsNWk4hwBIAjFtpU0ZtoFnNnO8HiOedg/p0qOS+X
	 QjvPxW7wdCDJ0bV8bocXa05z28tQRD5qC4cFot7/G6Wfk+xgFnSWI+YrJ0NxGhUhzd
	 5946m10rse8O7jOZXXbv+bi4k+tJIL8D8PP/zZJrecrTo9/aj6s7j8bYufzh3fCH7K
	 PMyf1ypqSVvSaFDjRlqwjA7yAx+B4+SMjsDTDSqQlY0NkwQjLQuM02V5ei14rww0Yi
	 0mPL6O8tAmmPckdqBUeFaxSCb8XvkuMs02vXYdQBdPm/dd5DDKRtOuQ0lrc5S86gQO
	 IMaMlrmbjBYeQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 31 Jul 2023 14:43:16 +0100
Subject: [PATCH v3 07/36] arm64/gcs: Provide copy_to_user_gcs()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230731-arm64-gcs-v3-7-cddf9f980d98@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1292; i=broonie@kernel.org;
 h=from:subject:message-id; bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkx7wZKQDFG7EFJkc2bMF4eSCe/iZHqCnXTSHwFYE6
 WnETetqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZMe8GQAKCRAk1otyXVSH0CjAB/
 9j+3rmzIjlTy5tKEIChK3iUWQnC1T22r1pFnN8c4M5Nd8WsaibvRYbBF3EbhUZyJQdmsvQpZeY5AJ9
 xiHNOnUw+b+9wwioD+caREB9fc5TaEqYGg22UEz786dKDsCbB93fknph1PD0ZW4CnqiRRvboDNuf9f
 +zfadgAbTpHSArpqN83t6fsLk3mVbGb8owzBVY+WoUxUIk8Mun3G3aQV1Xy5ArSNe0Swks3x9a9xb2
 dwVkdmtzGhd9ihuKD1ex2bjSFy38IQFidmvngCD/KC5Ws4H8zF110fSGWDzVJ1ivGTpLOecnPtkBKv
 Mf0goLJ09W8M+KNU6Mc0G5FsKGd5C7
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

