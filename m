Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE98F1E98F2
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991674; cv=none; b=PzAmgR4t+y9++a7Gx6uSVR14ByvL5kmcOqzLY9JzqmPf8aM1418NGex3GE5MC28cyF7h5ZVdOB0Y0zD5VG3JgVMVeUH8E1ONlgWytjuzrabIeI5UiXG/y3ysLQTmM3o8MaXHEN2fwcb74Ijc1XRhEETm4Thk0G2/R+oT1mpQkHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991674; c=relaxed/simple;
	bh=z9629gb1tOIskh/aiHMKTA2rpMX9SSwAz3UTWcKmXKE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OWQYVJFCxQw5+e82py77oYrBsLmaQMXZkHgH192vXVggwbA3oHk+0ewU5g7325pNk6OQBTKIt+4UG7uWEDHKMPOOPiuiAAjtTQ5ZpFooc+tPH15wCq1O+vRH2n+QyTwWNjCaVbjidzYcaTQmxamLOd4etsP0awaXf520un3U5vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SOBCin/c; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SOBCin/c"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pge9pC0vSB5KypfN1MoQzc/bwCss0Z4P3hh9JP1x4uQ=;
	b=SOBCin/c2dRMFZgU53vCb/Xzb1DjdXYTAayP6EJCQg4V476CAnp5JCh/or5E0Yn+phF90P
	BFALCBW999o0MJPwcDXcOW5RRultqPlTTmZx2Xo1wf0gjr7RWAEKIn8xshab1HbTek4Zl6
	5Dhcm3Vqw1IyyDZmU2u1gmEtfMk21kQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 2/9] arm64: Move arm64-only features into main directory
Date: Fri, 14 Mar 2025 15:25:09 -0700
Message-Id: <20250314222516.1302429-3-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
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

