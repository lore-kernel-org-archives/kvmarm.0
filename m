Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DF213D8AE
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 06:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712818524; cv=none; b=TubDbtaogfIARYHY2IquejQBmx5BUop+y8pa2Et9n17Q7dUbPeXHgGkWdAOmE7RC5MYFyLiMYpgcnbFfhVVUxofN2CK+uhd1wytcVioqNCfWezuVYrSSTQ63J8/7tmzF5B9i7IX7To/1jZR34iWXHvM7FA6Fk5OT69Run/eb68U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712818524; c=relaxed/simple;
	bh=5r+ijZQ5MH7I7vPvW7C5wUqEXvulF+LJcjAwi2rEDXg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVKIoLasc9wBvP5CGWtIYi7/2orIXIlf+EPROQEl932pYqIrOgsFtmMa/TvXdalJXMU4+ptv4ANx6KbBBoo5zQTMw2QElvdfFb/aVdudQLpxTL9JF49jCF2ApQr4udQ4HPa0WUId5tLEjhZWUb7N3LgFky7iaXpxK1553Ij3lZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VFVl35Sj3z1yn1g;
	Thu, 11 Apr 2024 14:53:03 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 550DF14013B;
	Thu, 11 Apr 2024 14:55:20 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Thu, 11 Apr
 2024 14:55:18 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <mark.rutland@arm.com>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<anshuman.khandual@arm.com>, <miguel.luis@oracle.com>, <joey.gouly@arm.com>,
	<ryan.roberts@arm.com>, <jeremy.linton@arm.com>,
	<daniel.thompson@linaro.org>, <sumit.garg@linaro.org>, <liwei391@huawei.com>,
	<peterz@infradead.org>, <jpoimboe@kernel.org>, <ericchancf@google.com>,
	<kristina.martsenko@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<shijie@os.amperecomputing.com>, <bhe@redhat.com>,
	<akpm@linux-foundation.org>, <horms@kernel.org>,
	<rmk+kernel@armlinux.org.uk>, <Jonathan.Cameron@huawei.com>,
	<takakura@valinux.co.jp>, <dianders@chromium.org>, <swboyd@chromium.org>,
	<frederic@kernel.org>, <reijiw@google.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v2 5/9] arm64/cpufeature: Use alternatives to check enabled ARM64_HAS_NMI feature
Date: Thu, 11 Apr 2024 06:48:54 +0000
Message-ID: <20240411064858.3232574-6-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411064858.3232574-1-liaochang1@huawei.com>
References: <20240411064858.3232574-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd200013.china.huawei.com (7.221.188.133)

Due to the historical reasons, cpus_have_const_cap() is more complicated
than it needs to be. When CONFIG_ARM64_NMI=y the ARM64_HAS_NMI cpucap is
a strict boot cpu feature which is detected and patched early on the
boot cpu, which means no code depends on ARM64_HAS_NMI cpucap run in the
window between the ARM64_HAS_NMI cpucap is detected and alternative is
patched. So it would be nice to migrate caller over to
alternative_has_cap_likey().

Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index dc8b2d0d3763..4c35565ad656 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -803,7 +803,7 @@ static __always_inline bool system_uses_irq_prio_masking(void)
 static __always_inline bool system_uses_nmi(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_NMI) &&
-		cpus_have_const_cap(ARM64_USES_NMI);
+		alternative_has_cap_likely(ARM64_USES_NMI);
 }
 
 static inline bool system_supports_mte(void)
-- 
2.34.1

