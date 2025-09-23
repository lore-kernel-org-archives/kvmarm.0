Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E51F82877FE
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649763; cv=none; b=M/1+TS+UplWbeSnOL/AipbxjFXXncMkDGmVdPgPdqC3POZ68BQy+ogGPMhmeyRRmLmFgZIR6ldnthaSYdWu6eQjrBOy9kFr0dC+bgyDswPY/oxu33f0ozi2nqAmyjOGcOHtv64tvJcXkscCyOd6txQX2a5avRv4oHxMjBP0dHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649763; c=relaxed/simple;
	bh=128ZpLwaXADL1vNovgRJUTn6L7GJXWYdUh56fZ+sRYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBvKk+S2Nj2/MBBJ9uu8Gwc+Yg4OQWw5Vze4vbO1m3GKJhTiV8yvPdpfTvjf01TRy+gonKWjb/1cwOXcs3rZyAzIdwgLVTbtq/1tyS6XWDCu+AK9Bc5OdTPvUCbZ3kd+ceD6ASEKrbWMkWA0O/0qckd7wvLW6LYOGGp+6KULpZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBD86FEC;
	Tue, 23 Sep 2025 10:49:11 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1734B3F5A1;
	Tue, 23 Sep 2025 10:49:15 -0700 (PDT)
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>
Subject: [RFC PATCH 01/16] kasan: mark kasan_(hw_)tags_enabled() __always_inline
Date: Tue, 23 Sep 2025 18:48:48 +0100
Message-ID: <20250923174903.76283-2-ada.coupriediaz@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174903.76283-1-ada.coupriediaz@arm.com>
References: <20250923174903.76283-1-ada.coupriediaz@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`kasan_hw_tags_enabled()` and `kasan_tags_enabled()` are marked inline,
except `kasan_enabled()` with `CONFIG_KASAN_HW_TAGS`,
which is marked `__always_inline`.

Those functions are called in the arm64 alternative callback
`kasan_hw_tags_enable()`, which requires them to be inlined to avoid
being instrumented and safe for patching.

For consistency between the four declarations and to make the arm64
alternative callback safe, mark them `__always_inline`.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 include/linux/kasan-enabled.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 6f612d69ea0c..d3d5a2327e11 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -13,19 +13,19 @@ static __always_inline bool kasan_enabled(void)
 	return static_branch_likely(&kasan_flag_enabled);
 }
 
-static inline bool kasan_hw_tags_enabled(void)
+static __always_inline bool kasan_hw_tags_enabled(void)
 {
 	return kasan_enabled();
 }
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
-static inline bool kasan_enabled(void)
+static __always_inline bool kasan_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KASAN);
 }
 
-static inline bool kasan_hw_tags_enabled(void)
+static __always_inline bool kasan_hw_tags_enabled(void)
 {
 	return false;
 }
-- 
2.43.0

