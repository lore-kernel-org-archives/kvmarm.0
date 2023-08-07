Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E574D17736
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 22:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD7C4339A;
	Mon,  7 Aug 2023 22:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691445734;
	bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AN8K1d1hM+FECwj4m7Q44SZ/vVwNunzEI3mgs/rR++hEMNfIoQxRuwsnk0qjuB3lV
	 D1ZNx1pKCHk+jlGJrGhqOh03ixH+zIDWje3WQslo/D1VjOd106bw3/Sewy6jMx+PPV
	 TA3QA7zrb5an0KKiv99PBqXcJNXT2FaKbYHwnhgdJud2Ks3fkjqiuhhdAI5ZR0azGN
	 gknfBNDDPh/z83GWTFPRA2GBxjxry8PKjojl8sQPGAWKpAcNgul5FcX/4RCaCGUKEV
	 ijrUeUtz+vIZ5kFF/s+GbtITiEDIGroF1ALAUkgPiZNea9bSzwDHJ0/UFAtzrojDet
	 Jw0fbUZ3jTnXw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 07 Aug 2023 23:00:12 +0100
Subject: [PATCH v4 07/36] arm64/gcs: Provide copy_to_user_gcs()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230807-arm64-gcs-v4-7-68cfa37f9069@kernel.org>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
In-Reply-To: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1292; i=broonie@kernel.org;
 h=from:subject:message-id; bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk0WmdqU/RL8wRY7UGOdRitXWgZrgqu1X0IXUshUit
 KIiqVCSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZNFpnQAKCRAk1otyXVSH0AZQB/
 9tN3nl/ebmiN0afW08bZaife7HUkEpbCB5l0jP7cgS+5CXXeUu/MNd+a4iyvAqFyTbsmhnZovZGciH
 45jKvN0Wdj0v5UmZg8g2WhgEe8qrw9mJWRhS0xBR+xWz4XygskhCKc1gMDQFx+gVWkUnq3pbWwBmjc
 /XoE7pKFNO5K69hJIwETGuwcI9Sdjy3SY1si4ogJax+9xc0hV1/WRt1U1pEsjFbMsgi/15vufsROHp
 rVgmckZKCqz/Vgchnf4MUtrhlDduB4TDrKphXTQZca8fdLK3COFpPcYEm8U8rjs95G070cRz6cN2fw
 CPy0cLZ9DhsR8Cq008YQs8AYbWifzV
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

