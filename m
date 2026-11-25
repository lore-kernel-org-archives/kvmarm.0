Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619713;
	b=oCsLIMk7nEUaUqpxf+2E+AZo8isVswbyslVFB6pZiiC6b/scLUd8UTHTI47zJ6qQFf2U
	 uvJYIunDC5nypwlv/haLnCj7oiyvmGJQRUFF0SZH6V3CfY5LgaTi8xCOfEjZRHvODPfJy
	 /e0REtq0WX5jUFGFZwWk46VS+MsCNI8EpyRAYH8lHxQWiHGI6kpgN6OLKHtWkXP0ktkG8
	 Hwh7gHHuDv0/V7E8HPQ6HVgXZMTDnovRwb3NkpUILoBwi5yJ2yqBW8cxleCGWvoIObB63
	 euOdUCZjfbp2nTfmp68nTu+KxaJHjk4jcmBDzpGkxEqa8cUIR2MhPYRfEtB/PXGv04g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619713;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JB6rKjtgS7GCtJhRqVtnRh6KiXJmoZWWih+sfY3ClqA=;
	b=5rVL0N8BOK79nhYXscpOm4PviRQTiips3IH++FcQFXma953dZtFU+d1RoyfbumNpA5ua
	 uR6ASrmnexOsZ6k2FI0uBtn8W5DePixziZF2QkALbdRvm/44BjPVeoQ309gcRLLRnUFJ0
	 kMqLLlhwiemlR/UOaji2TfUC92BbqY7cHvDZ0K4goLfWBw4J0deuFpu2RkUe3SxCKB+A2
	 8A71i3BsaX+Pwum/kNHOluRgQ9mPO2eAOMEUNpmtLn+iec/mpA1OQqJ1Onu6JbQ6/aF4e
	 I/KVIpzOMyaBKyjf8gkTuLsC4B1plUCxMUyxqGG+DCVP0nl8eGzqvOJemf8QLbUVzZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="Z/Otg58K";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427EC606A333
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:15:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 427EC606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z/Otg58K
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C03D21762;
	Wed, 25 Nov 2026 07:15:09 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DF013FA7A;
	Wed, 25 Nov 2026 07:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619712; bh=CsFqqh1n8afZUR/MIhqwMK/qXUKYHWfg+J5jGa57e88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/Otg58Ksw3vFIVLXWwx5S9NUB2v5SnLjug4pvRtasTiAtbuzrMfV6efc77tqQBEU
	 WC2njSNXhCjwoSbnVkPW09NSGzAgWoZLNXCYhUO3Fu0fD0tOsX4vNB6MGldHE5TL7g
	 hbnqFvcyWFpM41rV9r9AGW6fZBiGuINX4aj1o55w=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 18/23] arm64: Expose the GICv5 irqchip option
Date: Wed, 25 Nov 2026 15:13:51 +0000
Message-Id: <20261125151356.2875108-19-sascha.bischoff@arm.com>
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
index d8a8ef7f..46130663 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -59,7 +59,7 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
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

