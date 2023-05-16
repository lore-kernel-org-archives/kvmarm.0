Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3F631104
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 16:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A42C433A4;
	Tue, 16 May 2023 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684253277;
	bh=BD0ipDsRhl90CAL+14HC8Lct0XsReJC1pDRKPHzBMaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9U9QQ13YMvuuS3MR4tKUlFVWqrHShPb4YxuV4c9DePCQTYQuOI9FXxxmPVS7D8+J
	 AsU/0T96sFcz8/dxoRYlEtc/Hw/hn4/bX0XBR8dNp0G+DXSdKqORbThsY4OyulDyaG
	 dWM4BDDe/k+lyVgyOFJUYtYySqOvk9NphJ8PdC5dgyV0qkHPIXBCV9shrATK+OPB8W
	 UMmN9syxC8AbMWkt2gEI7nIO0lvMdlD5fnrq00MbFabkq9nbKtO6V2DLsqKvN/yId/
	 +/AkrzNCnISp28rRVsnvzJxB2c90G88oG/Xinuca3ToNwts5JQyHeKKDkxiPpMI+bi
	 95EtkbG24LWqg==
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
Subject: [PATCH 15/15] arm64: add alt_cb_patch_nops prototype
Date: Tue, 16 May 2023 18:06:42 +0200
Message-Id: <20230516160642.523862-16-arnd@kernel.org>
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

alt_cb_patch_nops() is called through an inline asm macro, so
it does not need a prototype for the caller, but adding it
avoids this W=1 build warning:

arch/arm64/kernel/alternative.c:295:14: error: no previous prototype for 'alt_cb_patch_nops' [-Werror=missing-prototypes]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/alternative.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index a38b92e11811..55da3fedcfe2 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -31,5 +31,8 @@ void apply_alternatives_module(void *start, size_t length);
 static inline void apply_alternatives_module(void *start, size_t length) { }
 #endif
 
+void alt_cb_patch_nops(struct alt_instr *alt, __le32 *origptr,
+		       __le32 *updptr, int nr_inst);
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_ALTERNATIVE_H */
-- 
2.39.2

