Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E0231104
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 16:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C3EC4339E;
	Tue, 16 May 2023 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684253244;
	bh=WY9mojz+JxIIIHLIpP7M6rnup7jdrKDCKG5lg/lRrUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miKZNnEOuFMfFKgqtXtnLdXEddmtAYwAiv29ed3jdSODBJwbxl6Fs7ZQDvMgQxO+Y
	 etl4RPkmcS1afZZaQZIJOUc18hMC965eJWmtQ4uh6ttAYVTDo9iZRA8yqB8PkTHvws
	 tMg23uiRs3ElJMGkxPbWP+ulqME7o0DG1Asyl19PpY5itIhFgIrbl5WSQ20tY1r7jW
	 3AwfMxQGO2yJZ9AGYkXJawnRmQ0C6i8lD2CFscr4qr/KFuJovWFDfRVy45wTZiiaXV
	 AQhRHUPeewT9p/wWPmtpbto93lum9PE8rGEz/dgz5GCusjmQvUJN/ePhR+H9F2VFV5
	 tyamiqLBLrEXg==
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
Subject: [PATCH 07/15] arm64: cpuidle: fix #ifdef for acpi functions
Date: Tue, 16 May 2023 18:06:34 +0200
Message-Id: <20230516160642.523862-8-arnd@kernel.org>
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

The acpi_processor_ffh_lpi_* functions are defined whenever CONFIG_ACPI
is enabled, but only called and declared when CONFIG_ACPI_PROCESSOR_IDLE
is also enabled. Without that, a W=1 build triggers missing-prototope
warnings, so the #ifdef needs to be adapted:

arch/arm64/kernel/cpuidle.c:60:5: error: no previous prototype for 'acpi_processor_ffh_lpi_probe' [-Werror=missing-prototypes]
arch/arm64/kernel/cpuidle.c:65:15: error: no previous prototype for 'acpi_processor_ffh_lpi_enter' [-Werror=missing-prototypes]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kernel/cpuidle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
index 42e19fff40ee..d1f68599c29f 100644
--- a/arch/arm64/kernel/cpuidle.c
+++ b/arch/arm64/kernel/cpuidle.c
@@ -13,7 +13,7 @@
 #include <linux/of_device.h>
 #include <linux/psci.h>
 
-#ifdef CONFIG_ACPI
+#ifdef CONFIG_ACPI_PROCESSOR_IDLE
 
 #include <acpi/processor.h>
 
-- 
2.39.2

