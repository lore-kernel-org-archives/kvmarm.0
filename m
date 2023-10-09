Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4878714F72
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 12:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRXCf3IP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8334C433C7;
	Mon,  9 Oct 2023 12:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696853499;
	bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nRXCf3IP04mxomb59+FPqFvNeFFferKhb4+ll7uI89/W4+e78a9mJLKf6QHmmidyZ
	 7z/5VLjrJo6vvICYH6T3MNNBcCIhgo75AlS8oAhFsH1H5oXIAIVbO2GHLOc9Eql7EU
	 RuYStvvqFpSYuwqfKGoTedCsXt9rmPTpIcWvtooljyquoQ64vzqW8B5Xu4Y9r5G/UA
	 plNxb2NEue4mStms8VLWFaRhrYwe97jxi1zX0PuJQe0xXV6B9IJkAYchVqYB3jLDBd
	 FnewL1JOM+NuyhQP2NYJZGT/0b8pkoa2zX+S21Dg32uCsDkp8n2wdKXEvkGQVMCCsg
	 L0ZVIbqvSMc2Q==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 09 Oct 2023 13:08:43 +0100
Subject: [PATCH v6 09/38] arm64/gcs: Provide copy_to_user_gcs()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231009-arm64-gcs-v6-9-78e55deaa4dd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1292; i=broonie@kernel.org;
 h=from:subject:message-id; bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhlTltzOS1pv1T2Ztq80/z91/JcylNk5K+4vYp581J1n+ysaV
 t9R1MhqzMDByMciKKbKsfZaxKj1cYuv8R/NfwQxiZQKZwsDFKQAT+fyd/Z/uYTmT+1qcLE1xGh8jeb
 hqPLTWviyYlseUlDmfQ9vbuD8gk/Pf1ojqStkZFcHrH2p1lUdbGqcYKC/RsBUN/M64lfmh38OyE3Mr
 EnLz5fQW7Y7fWZa76o6UzRE1HqMlE3ftmxPv+HShlMf7ujvscjo+f28EMz+qyLjo+lnMmW2Hf1PxRM
 1+kw0JjCIbH2lJrN7LpCDYU5O4YsoaGfaQgBU9P7w5r9Y+L89lv7X2k92ETtOEVLf234Esp8UNwgUf
 rpjy6tV++VelIc4+03NYfzsKCYXMmBfmO8H18gE5O3X/jzK6UZsO373dcnPZ0Uczlshf5j62av3F96
 xcV1zy1ynv3fr5hcWvMqn2UsGLAA==
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

