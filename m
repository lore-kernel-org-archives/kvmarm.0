Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619733;
	b=3LJR2R8PyxtsLCa0eJ3S+1U/Tm2qDM5gDpCSTauQJ0br9vPVkKkaiiXWdPCUOQmJE6Gq
	 TeTBeRB2EH4F++IqaNbQked4qk6UE0mN1772piP9BGNbRYozUnVTipiEDUpsjask5PQy3
	 lljiVjer84mjC0569tuEjuspyMf7a+s6dvXItfEn1VXqdIlD6sPABLzL4K7qbpmhtDtsg
	 el1cC4cVbKPvanprPex0Stzo5vvdHoKOqbEtBYtYgvZGAjFVY4HNNMtln27Y2eJARnWIg
	 XEyYT4y/wMgDnlSwwL9/+ChAOOPhowubuTrwEpcmpfqmpd+x/VMFuXcjuNbIGEr+FVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619733;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5kR+NcMSQ7ykJji3RevBgB6GAVzprMAWarlwVHhwyLQ=;
	b=sqxUbCY865jHTFrQqPxwuJD9DH0KodVpzD51zeJE/+0QJXd16CwcGyqmdoPFm3fjWspx
	 eRtD48vkTXy3BAxod5JqwCFkjJfwm+jY7Bl31zqCZDkdCMkblpXKRICqkcqCMsH59vkam
	 LySd7YDFwut3G7+zoi4kd/zNFORJ6BFHT2jNi8WThr5+7RD3qRYpBKBvXaXLXFeAW8vEN
	 X4fGdJMwvTJslUMniBfgK6mnTnMgL21RYCZYwvrZBQ/5lsCIDjSrdGZ+wDQv2XGniot1v
	 UylIMoIh1a1rfBwly3GEb3QXxlskQCM7Z8BQkp9Clqmdw9nRa3dkoyBADjLrA3CGhnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h4ylK1rW;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9ED1606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9ED1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h4ylK1rW
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2446D1596;
	Wed, 25 Nov 2026 07:15:29 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E35353F86F;
	Wed, 25 Nov 2026 07:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619732; bh=rq+ZmJ6FSww4chdItGgGNPA524Q167UVgT/xB7zd+pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4ylK1rW1v47S74BxjlvP3TzGt1p4724xx1Jjz1w9pLCVEB4s056aOyyLz9AGo475
	 +1I0mlyl60jXllYoWHMyCJ8634xn4cWzs6b7NBohh5Zg6eCWOXGyudPllgH8d1bkav
	 xlRKjQN994aDKPdbR0WQb3VJgtDx7mkMD23P/ARo=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 23/23] arm64: Expose the GICv5 ITS irqchip option
Date: Wed, 25 Nov 2026 15:13:56 +0000
Message-Id: <20261125151356.2875108-24-sascha.bischoff@arm.com>
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

Allow --irqchip=gicv5-its now that the ITS DT nodes and PCI MSI
requester mapping are in place. Start automatic irqchip selection at
GICv5 ITS so it is preferred ahead of base GICv5 and older models.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                         | 4 +++-
 arm64/include/kvm/kvm-config-arch.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 2b24f5b6..230448e8 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -81,6 +81,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 		*type = IRQCHIP_GICV3_ITS;
 	} else if (!strcmp(arg, "gicv5")) {
 		*type = IRQCHIP_GICV5;
+	} else if (!strcmp(arg, "gicv5-its")) {
+		*type = IRQCHIP_GICV5_ITS;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
@@ -415,7 +417,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_AUTO:
-		for (try = IRQCHIP_GICV5; try >= IRQCHIP_GICV2; try--) {
+		for (try = IRQCHIP_GICV5_ITS; try >= IRQCHIP_GICV2; try--) {
 			err = gic__create(kvm, try);
 			if (!err)
 				break;
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index 46130663..936b142d 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -59,7 +59,7 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
 	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
-		     "[gicv2|gicv2m|gicv3|gicv3-its|gicv5]",			\
+		     "[gicv2|gicv2m|gicv3|gicv3-its|gicv5|gicv5-its]",		\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-- 
2.34.1

