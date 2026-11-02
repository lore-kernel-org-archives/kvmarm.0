Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655336;
	b=m7dR5+ClOQx2vLUrPjtk4Pk31KEt8siGHnCDvUJ1BoG14VSOxgmoKD2Y9dI4f+QHRvuX
	 th4mR0siq5JBJVeZCRoHmKZR+xEIgWeQANzzV6ePxwVmsMLKoyVYJNZ3oTzpPAJ3fvUPs
	 9eM35ZtFjyEioRlcj4hIO9qwsXS53pIqRR6QAO1cO+RX8vs5yvkVTwPCI3aSYDgGd/uqt
	 mukWQKQGx2i9stBHa0zvz3tMVTsNHt40NKXW1bgDmekYT91NP4dQw67GzbJo0VGbvTBEr
	 cYOZLz4Bc2rRX9lG08Z+c/l79DRxfmHP3gOBtUJmXxHyLFhXZWOmDiJh8IKw64wfzfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655336;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AvisrEqQElUoHyisCCLCSldLV5z6aMNgp29/YuuIZCA=;
	b=aUn40iSAy/inVw3b7lbGz9yiR8kWtQPdCT3aOsBthuR5tCFpZ2Ty4p85ln7kSYNg5hPA
	 YNbHdCRiyVKyhaws+2iZLyLFrDAoyPfY8hYFGkYAINPJrLvDKFxyrFrSsen/Lj9t/wJNQ
	 c7sU6ymGjGWZ1G8qOMOKBl2ITlultrMQ7GbU2oMvxbt/CxPI7pudEXLR/C/8+FSOgI3Hk
	 2rHA/pQHHxjIKCRrWoJArWLz7y0KvEpBlZgr23iojfqM1JFCQEAbmVNEwYljM0iDfgTq/
	 qgZUB6oZQ4WENYq3hSG5XzLjSbqImlKbIGBwl++x1VxT4gqeo23SUdOW3rP8i4cRKHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZnDHxJNQ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A586F6083610
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A586F6083610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZnDHxJNQ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01BB81595;
	Mon,  2 Nov 2026 13:35:32 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1A243F673;
	Mon,  2 Nov 2026 13:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655335; bh=MUCtExWUSWr34apmoDGdTASZbCVWFvhA7xJCDqrY4rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnDHxJNQxfd865ntegJhmjbiCx7HYzX3XMsJiRZDqyOAB4JruRBhQNM5SWvSkynl3
	 cyCVDO9bDsxVqSRX/WNDNXFGIr8oXV17P/SuTghzbhMkv52CdgngX4AvxaTl0T093z
	 K+NcdSjoR+nUvB+ILYJabszPpwxs8J8Z4i8g0sBM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 18/23] arm64: Expose the GICv5 irqchip option
Date: Mon,  2 Nov 2026 21:34:08 +0000
Message-Id: <20261102213413.4136118-19-sascha.bischoff@arm.com>
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
index 91447703..6abd7d44 100644
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
@@ -404,7 +406,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 
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

