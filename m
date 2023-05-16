Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4368D31104
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 16:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D877C433A0;
	Tue, 16 May 2023 16:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684253269;
	bh=Y/kX7yQ/rkwRjov2P3rhuT9nIb3QQo194N1K1FzHQ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kedr1NLZ1ZCY3DnJ3dxsFdY2+W0MGAEccULvE8FY4jEGNx4HDKeKuxc30G+7uwvGG
	 wnR08MvLRzsPA6WRL6GJ0wMktvpTzlCKA5U8saVsLDduqGtGn73O8BGC6cCL7cTtAK
	 y2nSsbvJ0q3eApquSZ48lZ1cFWbf+9f6yoU3LdVg5SGh/i69qU6ERcAkYREvNBs+UM
	 7FTNfy+nxps2IK2AiA9mOB7PmxIURaByQc/jRTu6mObtnO/GmCxIHXJSN5QwQm1UYw
	 0rMj30nsVdVXqSMEGdSfgXQ+LpxWk1ELY65Z/C5yKtHpe4zdTtoW/uFhpscPMo7Kwk
	 QU7MnvrwgYS6A==
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
Subject: [PATCH 13/15] arm64: signal: include asm/exception.h
Date: Tue, 16 May 2023 18:06:40 +0200
Message-Id: <20230516160642.523862-14-arnd@kernel.org>
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

The do_notify_resume() is in a header that is not included
for the definition, which causes a W=1 warning:

arch/arm64/kernel/signal.c:1280:6: error: no previous prototype for 'do_notify_resume' [-Werror=missing-prototypes]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 2cfc810d0a5b..3457906ba117 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/elf.h>
+#include <asm/exception.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/unistd.h>
-- 
2.39.2

