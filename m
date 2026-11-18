Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024720;
	b=mzgMa/7GIBvlfgEdRfg/ZbijjDcxlkQEvaRxVbyxKb1IkmqHDF2GnltDxN6y02EhZ/GD
	 AKFYsvVIAdfK/O2qz1KNCmkU946OGOceAaCU4I7ESMWZwl8w7I5Kw3uLatkCaIEI91wBN
	 7ntYTu1TlZajgfDzwm3AdvpsBDB02gM+G3hY+BOM73S8R5dINKDg0UP4kjXO6B8n7GL93
	 7sDiKFi1cFseRkFwryW6bYx1rStc6Gw2ACT2q40aAJ9sxD3NlY3Ngm/1/SkRLDqthFZe7
	 4AQsPw0WmVVl8gGO7j5sddnAJ8oFcdAMf/6LrbgvvIsWkPznCrrDA2YUdyO8DV8Nlug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024720;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mn4Ggx29d50a4IUkBOUR4ytr+bcX51/dhy/wZQOyd28=;
	b=2sbGckf/h4MNwBICM28bj5iQQiOs6G+yv5kejntmUh+Xp2MzpGGqDylhOxmqIY/SdreU
	 umXCXXHQBXIdb1EDwF6mEXip//nbNNp532wOBa4iZ4d5PtFtwilzqQLp20rBwxjTfPoDw
	 XqevQTre28yRmchG655K9O3sQPNJDX2a5YDilJqLhD1m4V95UWbQFGaqFaQNVJR2Tid6N
	 bKzv5qF7q4FVBX9EgYDBEFu/MnsGGrjVpyPd1hCCaoxwGqZVrmJUH4fRFDyASTWtnoUDX
	 RNdqHPGWtob6WKMgLgWh/XO6tweknTHolCI27zmrmjo9txd62/hQK5v53DPzBJnXUQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Uw05dw+L;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAB4606A32A
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CAB4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Uw05dw+L
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EADEA1596;
	Wed, 18 Nov 2026 09:58:36 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94E323F632;
	Wed, 18 Nov 2026 09:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024719; bh=k6zuUWy43e72ltP4EH+msPflCCVb8GSqJKNp9NcCmcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uw05dw+LN6eq9XZZGsws1lR3GWlyq9Vhw/kXnUwTz7gmS0ppptdgM5zdiOSdH8Ffr
	 nsSz0ISoAxK6CDucO8Mcp55TBWDhCe7SrDDFGimW4XfhOoId3/dsSCxK6Vveuh9nuf
	 tFxQnW019mMV/LnCL/6WBgtg38DCXliK1Nyhp6RE=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 08/23] arm64: Start GICv5 SPI line allocation at zero
Date: Wed, 18 Nov 2026 17:57:40 +0000
Message-Id: <20261118175755.1946977-9-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GICv5 SPIs start at zero, while earlier GICs use an offset of 32.
Select the zero offset before allocating any interrupt lines.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index df5689a7..58644036 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -234,6 +234,9 @@ static int gic__set_spi(enum irqchip_type type)
 		break;
 	}
 
+	if (gic_spi_base == GICV5_SPI_IRQ_BASE)
+		return irq__init_irq_offset(gic_spi_base);
+
 	return 0;
 }
 
-- 
2.34.1

