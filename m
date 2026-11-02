Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655295;
	b=1IfOgvDYSW/pH39Hwue6b7Zi3IFwjRsfRaogyNli+sXzlHB28FDrTYhyzxs9gXpI4ryF
	 IORrbvnIS6SjJT2lbeXjKcmUaqY62B8TIiUICVuSc67t645RQZmhSpuZ/0NcFiRnvLssF
	 AJPJkfilv5saF7O4ubKLQzFLcH5KUae/beyhJkh/zy430m2qbwLUdiCIc8xe3r0sUYKj6
	 SRORxkQUBMpUvkWljtXYIxWSR0pJwq3AtcINVfRCLsZkv1kOIRPbPI3CUdPm8a516SNIA
	 DPuQM/uWA4/SHxJbfR9wtZtpo9AU7Sl0FE9r1fW/ZmVFd/9qDRG0T0yHCqvnZkk7Zog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655295;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=srKSyCS4Ru2zUf0gjuvs1S6oRHT6jks7X3qvi0ipRVI=;
	b=Ia5nNJo73eWj2v4Tqw+ZOYFV+O1JkKvXgupCw+m+drYo2zLI0DO8IgrIb7XBEDLJnpjM
	 0CCdYsEWYL4B7fSblgIvYX2QXhd/FKJiWzUNgxdTZQnEkTuneS9b5qyL5rcKdTvRnX6tN
	 rEPL24uNB235Xg2HkaZMf7Jz/POoZQQuasrJSpP52dEgALPdSme9t4xCKflwJz4CQoJUq
	 RunU2sIid10DLzPUAZ87AWYFxS8aJISJVtu6ERXmnz8XT95pwZ7kpzqKcWkwrfOl79ySW
	 Hyi33pqSZH9U1UNjP5gNlzUdCrkSWM0jP5h7bcknrWN0YG8y3pIlunWTCo3mmfbsO2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bjANUts8;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4BB606A32C
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C4BB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bjANUts8
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC31D1595;
	Mon,  2 Nov 2026 13:34:51 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93A373F673;
	Mon,  2 Nov 2026 13:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655294; bh=hWceZWLZ+2f/fzIv2zN2OspNTB8e4OnpKfuZZ4Svkcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjANUts8tLTjNLLKfVAUomSszK0mpS2NQn5d8kXMuW9R2NMzIAHVrUQkyx/UitcLD
	 dxdfBUd/23L7PFUWZI9ke6LFKQAH2f9yCw5IjH200I/1mHjaptTZui1fhDdHwh4ydC
	 o3jITvb5D7nq15VsmxE4115hCdBoW14hkFPkYeEI=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 08/23] arm64: Start GICv5 SPI line allocation at zero
Date: Mon,  2 Nov 2026 21:33:58 +0000
Message-Id: <20261102213413.4136118-9-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102213413.4136118-1-sascha.bischoff@arm.com>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
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

