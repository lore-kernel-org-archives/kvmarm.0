Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798945;
	b=Ta030jJD6J1OnrsWdOd17izPPTVz30XCSWRfxIWB8yJiJKwqz273zVwrkjtYtGoCTbtA
	 pSinyalX3DTzXjnCNAgP2dFGLnFiGkxWpJVG0AHJtZJKJ2Vz1w/SND5FEQ2dJ53micTuv
	 w+c46+3r7RPBQuXlxSktKiUtOq/DBjvOwjokrrLltrgcF6sqrwAS6p/GxbmbhFMF/jWUD
	 hTBgmjH+NEG5btM401vhQRleHodKxSiIimklcFA1Jw65pRZbFg/afOSQ7iCREjZcTJhJA
	 cAWcj+kR8WI8Xx3Ncykfbt3r0erEjyuPzrYmALpKXaQKpfBQGGE1Q6bqMNE1lmxVo6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798945;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mn4Ggx29d50a4IUkBOUR4ytr+bcX51/dhy/wZQOyd28=;
	b=Z3JmIzT0uZZEHP1SyRI082LwjQGEsoy6RgxF3gM7RbOXUBMygiT+YbqdeGqfK2ZHFVob
	 Bj0VTJGmymsBKubC/EVe7+vJSV2qLmxMHqEsbRrYYjkU0rnd0qJSWpq9sbdxNdrbu1U49
	 +oaWYW46SAxWVmUJBGFLGPKRUnEpZhcrNK39t8QSJnJekDNf7Nu8DZTRhzgWmahySx+i0
	 LXpR433VrQiok4z1GCDyfQqHrZkYK5qbEakiYGr6iHB7GvQBr/nLo0yxLPjTj7sb6jC8j
	 GleGvQ/XZ7ijSzbQvL6rzMqWjZ+7aE0sfkez/W6NKlMJFyTDpbkzWfK9HXW1jzq9XCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NXW0aazq;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EDC606A332
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03EDC606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NXW0aazq
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 679FB1D70;
	Fri, 27 Nov 2026 09:02:21 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBE343F632;
	Fri, 27 Nov 2026 09:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798944; bh=k6zuUWy43e72ltP4EH+msPflCCVb8GSqJKNp9NcCmcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXW0aazqy6I9TWZm4fCIpzi+vtgcxfMlaiFzXd+sRtfcfpafnpThmkZCGSbejD/OW
	 c/2a+/xyU6nxknx9BlvOLHisvWzKwX+R3eqwz8VbOfp0e2YDe0Hie+Aka4E6PTEJtf
	 OyP0rv1x0iTcpQ2Ko7lZwxeqoimRxDfz4z2oyQOw=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 08/23] arm64: Start GICv5 SPI line allocation at zero
Date: Fri, 27 Nov 2026 17:01:30 +0000
Message-Id: <20261127170145.4138182-9-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127170145.4138182-1-sascha.bischoff@arm.com>
References: <20261127170145.4138182-1-sascha.bischoff@arm.com>
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

