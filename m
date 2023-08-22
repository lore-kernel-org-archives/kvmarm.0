Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC54B1C9F0
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 14:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C568CC433AD;
	Tue, 22 Aug 2023 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692713032;
	bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mlWvTaQN07byyUzf1CBPUuiCl9atcm+iFpXcZmmFNSmydMgUfR9Rw39AUOJUkgAlY
	 2ZhFmfLAiOVE0KR5rqzK64Y9wa+362rOFL2nSiv41fd+92xgrMb5lXRk9amGjzDiPl
	 imKu7mTPRF/okPy2sPUrCYGFbC/oj4SsClfRrGG6wEht1n0l52rv+nkpo5tVAWT/SV
	 R0y/z2PghYtCsriK0v7vPuUS/hca6R6jYYbOMSH1xbdzhbXFvp9XQjG7QyZrcZaRH2
	 2lCoZdZXeFCb7YWDwQzZy/SaAlMuy3Ta7YsUBu07sb6hEvORsAGhsAW6ZfM5sbCzQa
	 tRmUlf7VQmSYA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 22 Aug 2023 14:56:41 +0100
Subject: [PATCH v5 08/37] arm64/gcs: Provide copy_to_user_gcs()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-arm64-gcs-v5-8-9ef181dd6324@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1292; i=broonie@kernel.org;
 h=from:subject:message-id; bh=BppDdcqjtJzUfuzafP5lgvHCeya4NknqM0BAXJ7ap7w=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBk5L/2Me+ug3ePxzuzvoPm/hkwGj724zhTCzq2OzFW
 adIGHHOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZOS/9gAKCRAk1otyXVSH0HRNB/
 9IUqNzEcbTEiNkLKuvna5fOzaKYr0ARo6fUoTtLXYMcvFVGLqvFurGEIYTQ62h+JPsILa7aMNFnw4z
 VXRj2dmEWVI3pLWCLOr3qPOUTG+Vktj+ZmWNDlYliT8wxXwdr1uot7HkFAXMEMubHo+4yqgCyOzuBV
 D7Jazz4z1qhrfGraLs5Xba8n6eWy1dwiwOMOrOvyFmPFsamJeSsZAJ/AKIdra5hSkwWVGy0bh2I7YI
 nrtiIi9lgKkLnDsm2UMZiz2E6I91LWEdbrTyYOYaiTLKFYwfYf8GCOZRqeu08XGB9WIoOT5blki5S6
 PMPDPPcgWVE8jZnwHus3N+ebSV+EmD
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

