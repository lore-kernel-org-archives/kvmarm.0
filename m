Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB9A20C004
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785576; cv=none; b=QTwqcJp3nRT2xhgZoOwH6fHZZj3LO5wbx9zj7p8vjz08LqqCabwftY6WnPghZeyHd1uo2nbS/OcbPsbjFY2S4NE33BaeVevMRZg7p+NmIfq7w4QjjlOzcusF9p+4dOT7O0WqFsG7AE5fu249QtX6Dha6KFOjW/OSmtXdvePbqhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785576; c=relaxed/simple;
	bh=Gm9mtGB73akp1FsZiauxeffEIgKi4vJg1t1cCuDSbUw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WHG0UAMFkW4sBeKhGOCXUHy5EyTBXHVsH6cghOdE146K9CgGZiijOCOIedJsF8tQXQuNEOenOMRTH2UNmQPSR8TLFskbj7Nqi7daOH6fPUJrzU9q+3w7BhL+TGRR0d4tyVY83GBRTOSlG3ctey7cSzNEH+bZqd+W91U2PLO5zQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nJl8mgmI; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nJl8mgmI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9vyQDUGcuKmvoqdSOB7BgeIFfCZWbPczoYiN/3IZ+w=;
	b=nJl8mgmInqvkb37/PTzGu0qEGagS13cPdgclFbFmwOtwIXuMK/Id1b7ouil6U610jgx5AC
	Jt3lDqdh3SFiHZ6+Qxur0/PfBlk+i79Lf1vBO0BFFJ+pNAy/aV7rGfmPzHRedRj9u3UY9l
	yUfhhHG3YQyXLELjcV1vBA3ql6zILAQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 2/9] arm64: Move arm64-only features into main directory
Date: Fri,  4 Apr 2025 09:52:25 -0700
Message-Id: <20250404165233.3205127-3-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start the backing out the 32/64-bit split by moving arm64-only features
up a level into the main arch directory.

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                    | 6 +++---
 arm/{aarch64 => }/arm-cpu.c | 0
 arm/{aarch64 => }/pmu.c     | 0
 arm/{aarch64 => }/pvtime.c  | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename arm/{aarch64 => }/arm-cpu.c (100%)
 rename arm/{aarch64 => }/pmu.c (100%)
 rename arm/{aarch64 => }/pvtime.c (100%)

diff --git a/Makefile b/Makefile
index 462659b..cf50cf7 100644
--- a/Makefile
+++ b/Makefile
@@ -178,11 +178,11 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/pci.o
 	OBJS		+= arm/timer.o
 	OBJS		+= hw/serial.o
-	OBJS		+= arm/aarch64/arm-cpu.o
+	OBJS		+= arm/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
-	OBJS		+= arm/aarch64/pvtime.o
-	OBJS		+= arm/aarch64/pmu.o
+	OBJS		+= arm/pvtime.o
+	OBJS		+= arm/pmu.o
 	ARCH_INCLUDE	:= arm/include
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/arm-cpu.c
similarity index 100%
rename from arm/aarch64/arm-cpu.c
rename to arm/arm-cpu.c
diff --git a/arm/aarch64/pmu.c b/arm/pmu.c
similarity index 100%
rename from arm/aarch64/pmu.c
rename to arm/pmu.c
diff --git a/arm/aarch64/pvtime.c b/arm/pvtime.c
similarity index 100%
rename from arm/aarch64/pvtime.c
rename to arm/pvtime.c
-- 
2.39.5

