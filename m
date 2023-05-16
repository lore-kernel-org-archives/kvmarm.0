Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F7931104
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 16:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B98AC4339E;
	Tue, 16 May 2023 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684253265;
	bh=UcWVdIx6eUNRqB58lvyqa00FuN14YMlQl7kvQIYp62I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwck9pxebUmJ5elwV8JbBowvzYFpqDcwvO+VjLC6ovtT5Zh8jbQn59jRACTo+f4Y/
	 7l0M8zxg2Np+BaiSbNSH14j2nYQP/XRbMAn93yj7xQ3SkvKIuntJt8KoZfrVTT9IU/
	 MrUn/2xa8+GbgCJmL4EeOBlFYppKePkdIq+DGQVbhNF9sV3i3DvsgPCXWTSQ3132uP
	 U9qPFdkImKIqjVSrHZY9q2gitN64HJoDSwj18p/c6zu6y7Xt91mTG1f26mBIVvC4MW
	 BwCIVuj2VVBxhDnJK+je2EjtBEQR6sCFizppprMVkDM36HeKFb3xDDRpH89RmhM2hJ
	 Ps4L3KXuhyDNw==
From: Arnd Bergmann <arnd@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 12/15] arm64: kaslr: add kaslr_early_init() declaration
Date: Tue, 16 May 2023 18:06:39 +0200
Message-Id: <20230516160642.523862-13-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230516160642.523862-1-arnd@kernel.org>
References: <20230516160642.523862-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

kaslr_early_init() is called from assembler code and does not
need a declaration to work, but adding one anyway shuts up
this W=1 warning:

arch/arm64/kernel/pi/kaslr_early.c:88:16: error: no previous prototype for 'kaslr_early_init' [-Werror=missing-prototypes]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/archrandom.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/archrandom.h b/arch/arm64/include/asm/archrandom.h
index 2f5f3da34782..b0abc64f86b0 100644
--- a/arch/arm64/include/asm/archrandom.h
+++ b/arch/arm64/include/asm/archrandom.h
@@ -129,4 +129,6 @@ static inline bool __init __early_cpu_has_rndr(void)
 	return (ftr >> ID_AA64ISAR0_EL1_RNDR_SHIFT) & 0xf;
 }
 
+u64 kaslr_early_init(void *fdt);
+
 #endif /* _ASM_ARCHRANDOM_H */
-- 
2.39.2

