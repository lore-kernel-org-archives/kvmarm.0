Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798985;
	b=d5q3NIzbwZTbEWZVLVPINzZylEa0clJUSfLRVGApGnqAhr1nUpFOopOKkJ8vPWbKJ4G4
	 XOiXTCoSdUCWOZXmDEK8KtmY3nlouyQ1Jy+FtuyclajoEXj3Lz4HYIAepZJeQ6CV5qvsv
	 eojr/Pv9/fI4+fgNrnPD8plADZnMSg1srub20uSy61hMaa11ciHpi363tmfbHcn1dL89Z
	 J7l9JbMj2k/uCtPj8XyiAOaGBCU2xcyH9ZMfv79HLDPdkKCd7gJb5OBq89lrlqEGNGLR+
	 OsOo62Rd+T1rm9xv5/QSMWUodoqkGl3Bzk0crbSBy4DXgUTibiJGVrV3Q1svRGVE4dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798985;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kXcNf23EjeX82tKtPOKqKsn322nY30E+/ZXjQHE1EAo=;
	b=UHXJKds3nQhr/67cqGqlKlQcOcrM1NiSfLg8K7fX3nuDbaMiLQYhR5kzn5CKKeysjE8g
	 sHpHAYFncBvpR8uPF+Mp5YXYj4BGl7Pw71umptPN2jYacvdhc2E9vfbIxfDPBWxaAuykW
	 TaNP2D6T0VllqA7Wu0kWno1tR1UrY6DnXMnIJaFtMFIUdf1aUzxcq/aCo86e1raFrcdRd
	 A+xdnV9VNEeDnhXHpYZiP7yufFObptrtNm48K7VXmoG240qKVPjx7+wDuIvH9p6ZdvRFc
	 IS7+BTeQvWhA+wkzVsYvENg2xw408+sLazAZWNKz49Yi03u2C9j6/owgg2sskopF/wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=boN4GZFu;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1521B606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1521B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=boN4GZFu
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D5DC1DB5;
	Fri, 27 Nov 2026 09:03:01 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CF283F632;
	Fri, 27 Nov 2026 09:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798984; bh=NjA+aNj+OPFvHEV2Ek7m+cEitX7CdVkRKvWWOhubcw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boN4GZFuD0FsplCrF9tL5kb9cvkyi5cq6lYSHZJp2KmYKDbU7RxB0GhElf0WeitkA
	 w4pz8X56ykQi1Zir3cZR9LNQZx48VVAPrzHTTW/XP7BZjiw4eVZAahXLC54k4nmYeV
	 4iGVlEZNmMLUfHt/jw1Mi06xRn4IFeMoTVKguY+4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 18/23] arm64: Expose the GICv5 irqchip option
Date: Fri, 27 Nov 2026 17:01:40 +0000
Message-Id: <20261127170145.4138182-19-sascha.bischoff@arm.com>
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

Allow --irqchip=gicv5 and prefer GICv5 for automatic irqchip selection
when the kernel supports it. The IRS and guest DT support are now in
place.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                         | 4 +++-
 arm64/include/kvm/kvm-config-arch.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 955eeb5f..c1408502 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -78,6 +78,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 		*type = IRQCHIP_GICV3;
 	} else if (!strcmp(arg, "gicv3-its")) {
 		*type = IRQCHIP_GICV3_ITS;
+	} else if (!strcmp(arg, "gicv5")) {
+		*type = IRQCHIP_GICV5;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
@@ -405,7 +407,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_AUTO:
-		for (try = IRQCHIP_GICV3_ITS; try >= IRQCHIP_GICV2; try--) {
+		for (try = IRQCHIP_GICV5; try >= IRQCHIP_GICV2; try--) {
 			err = gic__create(kvm, try);
 			if (!err)
 				break;
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index adda6403..a1a9336a 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -54,7 +54,7 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
 	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
-		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
+		     "[gicv2|gicv2m|gicv3|gicv3-its|gicv5]",			\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-- 
2.34.1

