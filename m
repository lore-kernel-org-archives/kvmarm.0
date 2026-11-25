Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619675;
	b=mx+oTXnsje6s8U1Zu1bAmnLGUkiq4QdFsWj7B6VI3RX0pjRzNNCkHH1zKkKwfSqWTo1f
	 h3RvnPuQ3mlzInDNQT1S7+tiM4XpYwHg5yKa9ovcWuVXQW61oOHxIrbi+Wl768Tk8FtvS
	 oxeGCH+AwQEu5Pb2LNDLdjaCsvo+zV5c6NaYUl0CWKmLFX7GdSwzaO0aAkicdZKtHXB/i
	 shjj456CBAas0+Qn8VZxPEIlxrgyUYqS2jkLpTwzV8vEhWTDsv4vufrfj1TA5vPdCMNPT
	 w8K/h12FAvDGFH23q1cEeS9M2UK0j9Af4dLn4tars3mYD1gxNiiVCrkzkuQVl4h2cPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619675;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mn4Ggx29d50a4IUkBOUR4ytr+bcX51/dhy/wZQOyd28=;
	b=OwB2q2zAGzHyzTHuUjspeaxykaSq6+r1r3bTxHZ1QyKaYsv4xcXEoGE2SgLos8eFAq5T
	 fN351J6P/aizVQcko7RQDXEVWJaGhkNJGmS83ijaa/9++2ijVAxEDJZZqfE6PokTLlSrw
	 10DiIut5vIRCBJde6P+lts9HfDeS07MrosUW4xTWK0RVKPbC9j3ix2b7mlseViUEXHUrG
	 lURkxJRzx2uzOLY7oH7/sv6MEZd/PlJhikd9z6XjlNCQoQ+rh5vmhchoQDnpHvlzKmhp6
	 9sGpwTehHPzWqUyk8EWbTa/navSwgTYVHS/MX5LKxrVGoSpngpuAnkSWBaz1fleRYCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=SJ69dlaR;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57941606A687
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57941606A687
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=SJ69dlaR
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FB692F;
	Wed, 25 Nov 2026 07:14:31 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C72383F86F;
	Wed, 25 Nov 2026 07:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619673; bh=k6zuUWy43e72ltP4EH+msPflCCVb8GSqJKNp9NcCmcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ69dlaR5yuNbfAp5FHsDABqeO9GZULxI6/EobBzvuoL7yiFxuqfsH3Fd9zVv0aNb
	 J4kNrB8cJdbS3yP3xYOW/TJ3e+2zZsiYbBvpp5ATvH/Y1S+vldaJyHU3HGXaAbSGqQ
	 E+tjZfycT5cX8WkTFpsPI1qdKjD9FBRpsE6fOBWE=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 08/23] arm64: Start GICv5 SPI line allocation at zero
Date: Wed, 25 Nov 2026 15:13:41 +0000
Message-Id: <20261125151356.2875108-9-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
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

