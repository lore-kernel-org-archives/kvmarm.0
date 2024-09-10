Received: from mx.astralinux.ru (mx.astralinux.ru [89.232.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2213E17624C;
	Tue, 10 Sep 2024 08:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.232.161.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725958307; cv=none; b=pTw16oDpze/TJTxhyhkHl8NMK2PrMk1vol7ou59iqtrXrS8Kqp8iPpZ1RCoAJo1q6Pki/LLuVmC8aLLdZrsrnSuwrdh2o9F/RWXGYAmA3gMfqy7B4muDFoMkavzBz/qbi8GxretUW4eWPoK6jLD1J4F1kaqQj5NUp9ON1RsNWzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725958307; c=relaxed/simple;
	bh=XVGXGzADbsLu3p+a2MUO3UozEei62Ba2NCZZ3KNQTWM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H7IiOhEO2DdcPczIEvMtC3WZhkr2dWolWDz0emhlsPk06AQhfKVK8pCHeQ6CzM61Olwx+uqVVjLMXKAqIhuANVmKN+wedczWnvwVxndfjNX9436wfpZETT151IqzqgpSNyaBJHEgMANWp0nvVToqp7ZiKjQzFM0pl/C+iXAF8eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=89.232.161.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from [10.177.185.111] (helo=new-mail.astralinux.ru)
	by mx.astralinux.ru with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <abelova@astralinux.ru>)
	id 1snwZS-00BYd3-TK; Tue, 10 Sep 2024 11:49:58 +0300
Received: from rbta-msk-lt-106062.astralinux.ru (unknown [10.177.20.58])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4X2y983ntBz1c0mR;
	Tue, 10 Sep 2024 11:51:08 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: Marc Zyngier <maz@kernel.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH v2] arm64: KVM: define ESR_ELx_EC_* constants as UL
Date: Tue, 10 Sep 2024 11:50:16 +0300
Message-Id: <20240910085016.32120-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <865xr5856r.wl-maz@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DrWeb-SpamScore: 0
X-DrWeb-SpamState: legit
X-DrWeb-SpamDetail: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddgtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfftfghgfeunecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeetnhgrshhtrghsihgruceuvghlohhvrgcuoegrsggvlhhovhgrsegrshhtrhgrlhhinhhugidrrhhuqeenucggtffrrghtthgvrhhnpeevhfduuefhueektdefkedvgfekgfekffegvdetffehfefhffejhfehveevudeigfenucffohhmrghinheplhhinhhugihtvghsthhinhhgrdhorhhgnecukfhppedutddrudejjedrvddtrdehkeenucfrrghrrghmpehhvghloheprhgsthgrqdhmshhkqdhlthdquddtiedtiedvrdgrshhtrhgrlhhinhhugidrrhhupdhinhgvthepuddtrddujeejrddvtddrheekmeegleehjeekpdhmrghilhhfrhhomheprggsvghlohhvrgesrghsthhrrghlihhnuhigrdhruhdpnhgspghrtghpthhtohepudefpdhrtghpthhtohepmhgriieskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprggsvghlohhvrgesrghsthhrrghlihhnuhigrdhruhdprhgtphhtthhopeholhhivhgvrhdruhhpthhonheslhhinhhugidruggvvhdprhgtphhtthhopehjrghmvghsrdhmohhrshgvsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihukhhirdhpohhulhhoshgvsegrrhhmrd
 gtohhmpdhrtghpthhtohephihuiigvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepkhhvmhgrrhhmsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhvtgdqphhrohhjvggttheslhhinhhugihtvghsthhinhhgrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuffhrrdghvggsucetnhhtihhsphgrmhemucenucfvrghgshem
X-DrWeb-SpamVersion: Dr.Web Antispam 1.0.7.202406240#1725912977#02
X-AntiVirus: Checked by Dr.Web [MailD: 11.1.19.2307031128, SE: 11.1.12.2210241838, Core engine: 7.00.65.05230, Virus records: 12167075, Updated: 2024-Sep-10 07:11:52 UTC]

Add explicit casting to prevent expantion of 32th bit of
u32 into highest half of u64 in several places.

For example, in inject_abt64:
ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT = 0x24 << 26.
This operation's result is int with 1 in 32th bit.
While casting this value into u64 (esr is u64) 1
fills 32 highest bits.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: aa8eff9bfbd5 ("arm64: KVM: fault injection into a guest")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
---
v2: move casting from usage to definition
 arch/arm64/include/asm/esr.h | 88 ++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 56c148890daf..2f3d56857a97 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -10,63 +10,63 @@
 #include <asm/memory.h>
 #include <asm/sysreg.h>
 
-#define ESR_ELx_EC_UNKNOWN	(0x00)
-#define ESR_ELx_EC_WFx		(0x01)
+#define ESR_ELx_EC_UNKNOWN	UL(0x00)
+#define ESR_ELx_EC_WFx		UL(0x01)
 /* Unallocated EC: 0x02 */
-#define ESR_ELx_EC_CP15_32	(0x03)
-#define ESR_ELx_EC_CP15_64	(0x04)
-#define ESR_ELx_EC_CP14_MR	(0x05)
-#define ESR_ELx_EC_CP14_LS	(0x06)
-#define ESR_ELx_EC_FP_ASIMD	(0x07)
-#define ESR_ELx_EC_CP10_ID	(0x08)	/* EL2 only */
-#define ESR_ELx_EC_PAC		(0x09)	/* EL2 and above */
+#define ESR_ELx_EC_CP15_32	UL(0x03)
+#define ESR_ELx_EC_CP15_64	UL(0x04)
+#define ESR_ELx_EC_CP14_MR	UL(0x05)
+#define ESR_ELx_EC_CP14_LS	UL(0x06)
+#define ESR_ELx_EC_FP_ASIMD	UL(0x07)
+#define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
+#define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
 /* Unallocated EC: 0x0A - 0x0B */
-#define ESR_ELx_EC_CP14_64	(0x0C)
-#define ESR_ELx_EC_BTI		(0x0D)
-#define ESR_ELx_EC_ILL		(0x0E)
+#define ESR_ELx_EC_CP14_64	UL(0x0C)
+#define ESR_ELx_EC_BTI		UL(0x0D)
+#define ESR_ELx_EC_ILL		UL(0x0E)
 /* Unallocated EC: 0x0F - 0x10 */
-#define ESR_ELx_EC_SVC32	(0x11)
-#define ESR_ELx_EC_HVC32	(0x12)	/* EL2 only */
-#define ESR_ELx_EC_SMC32	(0x13)	/* EL2 and above */
+#define ESR_ELx_EC_SVC32	UL(0x11)
+#define ESR_ELx_EC_HVC32	UL(0x12)	/* EL2 only */
+#define ESR_ELx_EC_SMC32	UL(0x13)	/* EL2 and above */
 /* Unallocated EC: 0x14 */
-#define ESR_ELx_EC_SVC64	(0x15)
-#define ESR_ELx_EC_HVC64	(0x16)	/* EL2 and above */
-#define ESR_ELx_EC_SMC64	(0x17)	/* EL2 and above */
-#define ESR_ELx_EC_SYS64	(0x18)
-#define ESR_ELx_EC_SVE		(0x19)
-#define ESR_ELx_EC_ERET		(0x1a)	/* EL2 only */
+#define ESR_ELx_EC_SVC64	UL(0x15)
+#define ESR_ELx_EC_HVC64	UL(0x16)	/* EL2 and above */
+#define ESR_ELx_EC_SMC64	UL(0x17)	/* EL2 and above */
+#define ESR_ELx_EC_SYS64	UL(0x18)
+#define ESR_ELx_EC_SVE		UL(0x19)
+#define ESR_ELx_EC_ERET		UL(0x1a)	/* EL2 only */
 /* Unallocated EC: 0x1B */
-#define ESR_ELx_EC_FPAC		(0x1C)	/* EL1 and above */
-#define ESR_ELx_EC_SME		(0x1D)
+#define ESR_ELx_EC_FPAC		UL(0x1C)	/* EL1 and above */
+#define ESR_ELx_EC_SME		UL(0x1D)
 /* Unallocated EC: 0x1E */
-#define ESR_ELx_EC_IMP_DEF	(0x1f)	/* EL3 only */
-#define ESR_ELx_EC_IABT_LOW	(0x20)
-#define ESR_ELx_EC_IABT_CUR	(0x21)
-#define ESR_ELx_EC_PC_ALIGN	(0x22)
+#define ESR_ELx_EC_IMP_DEF	UL(0x1f)	/* EL3 only */
+#define ESR_ELx_EC_IABT_LOW	UL(0x20)
+#define ESR_ELx_EC_IABT_CUR	UL(0x21)
+#define ESR_ELx_EC_PC_ALIGN	UL(0x22)
 /* Unallocated EC: 0x23 */
-#define ESR_ELx_EC_DABT_LOW	(0x24)
-#define ESR_ELx_EC_DABT_CUR	(0x25)
-#define ESR_ELx_EC_SP_ALIGN	(0x26)
-#define ESR_ELx_EC_MOPS		(0x27)
-#define ESR_ELx_EC_FP_EXC32	(0x28)
+#define ESR_ELx_EC_DABT_LOW	UL(0x24)
+#define ESR_ELx_EC_DABT_CUR	UL(0x25)
+#define ESR_ELx_EC_SP_ALIGN	UL(0x26)
+#define ESR_ELx_EC_MOPS		UL(0x27)
+#define ESR_ELx_EC_FP_EXC32	UL(0x28)
 /* Unallocated EC: 0x29 - 0x2B */
-#define ESR_ELx_EC_FP_EXC64	(0x2C)
+#define ESR_ELx_EC_FP_EXC64	UL(0x2C)
 /* Unallocated EC: 0x2D - 0x2E */
-#define ESR_ELx_EC_SERROR	(0x2F)
-#define ESR_ELx_EC_BREAKPT_LOW	(0x30)
-#define ESR_ELx_EC_BREAKPT_CUR	(0x31)
-#define ESR_ELx_EC_SOFTSTP_LOW	(0x32)
-#define ESR_ELx_EC_SOFTSTP_CUR	(0x33)
-#define ESR_ELx_EC_WATCHPT_LOW	(0x34)
-#define ESR_ELx_EC_WATCHPT_CUR	(0x35)
+#define ESR_ELx_EC_SERROR	UL(0x2F)
+#define ESR_ELx_EC_BREAKPT_LOW	UL(0x30)
+#define ESR_ELx_EC_BREAKPT_CUR	UL(0x31)
+#define ESR_ELx_EC_SOFTSTP_LOW	UL(0x32)
+#define ESR_ELx_EC_SOFTSTP_CUR	UL(0x33)
+#define ESR_ELx_EC_WATCHPT_LOW	UL(0x34)
+#define ESR_ELx_EC_WATCHPT_CUR	UL(0x35)
 /* Unallocated EC: 0x36 - 0x37 */
-#define ESR_ELx_EC_BKPT32	(0x38)
+#define ESR_ELx_EC_BKPT32	UL(0x38)
 /* Unallocated EC: 0x39 */
-#define ESR_ELx_EC_VECTOR32	(0x3A)	/* EL2 only */
+#define ESR_ELx_EC_VECTOR32	UL(0x3A)	/* EL2 only */
 /* Unallocated EC: 0x3B */
-#define ESR_ELx_EC_BRK64	(0x3C)
+#define ESR_ELx_EC_BRK64	UL(0x3C)
 /* Unallocated EC: 0x3D - 0x3F */
-#define ESR_ELx_EC_MAX		(0x3F)
+#define ESR_ELx_EC_MAX		UL(0x3F)
 
 #define ESR_ELx_EC_SHIFT	(26)
 #define ESR_ELx_EC_WIDTH	(6)
-- 
2.30.2

