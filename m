Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D220513545
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165318; cv=none; b=Jso6M/7dxpcyueM7/b8ehzZAYyMV+OxUVjE282Kb2r940EGOl5+8DnsHcmLIfSjWYcZMFXKVPsAB9RM0gKeRYwb4JLbZRwOjrryKKpVew0B9B8YTHEHfREoot5+crRh3c+iR7MnQsqJCR3PKoQhwc8S65xvao0kYMIEh1aKpugs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165318; c=relaxed/simple;
	bh=ibkxihDJCPcp347nEw/Hey3Va6+UGN5VsqrdxY6gVUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bxvB10cuHTTXiDbu8MEryyvjLNNYaMfru1YMW0smhoCIlyKvfvaXNJY/UOwzHnRXaJ+glENLKJZHg/qlwmh5T0kks774UxsKqGiNiMGYA/GHPpdcaZ6m14UsjaEj2+IeeSqwN/ckBTsE4LG6js3D8hMTBUWp6QzpuvBwNzri36U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nlQ1ENpG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nlQ1ENpG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38D6E143D;
	Fri, 16 Oct 2026 08:41:53 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50BB63F673;
	Fri, 16 Oct 2026 08:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165316; bh=ibkxihDJCPcp347nEw/Hey3Va6+UGN5VsqrdxY6gVUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlQ1ENpGVl7amvD0dRChGgcbal8RMP7LzAPH4Gu6kZrfFWe/iWNMstpan0ImHZy75
	 zfMK4N7z0S9g+wRzWDTNEKhIJ5VwB6cWWRI3b/TCyid5HELn8/26MuhIPhKUUdejqn
	 7a5CaTeOb9e2AiwHLzGUZPVqg1bL8Igso9gYDH24=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 16/21] arm64: Expose the GICv5 irqchip option
Date: Fri, 16 Oct 2026 16:39:34 +0100
Message-Id: <20261016153939.913764-17-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow --irqchip=gicv5 and prefer GICv5 for automatic irqchip selection
when the kernel supports it. The IRS and guest DT support are now in
place.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                         | 4 +++-
 arm64/include/kvm/kvm-config-arch.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index fe6c2059..02e55cd5 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -50,6 +50,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 		*type = IRQCHIP_GICV3;
 	} else if (!strcmp(arg, "gicv3-its")) {
 		*type = IRQCHIP_GICV3_ITS;
+	} else if (!strcmp(arg, "gicv5")) {
+		*type = IRQCHIP_GICV5;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
@@ -293,7 +295,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 
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

