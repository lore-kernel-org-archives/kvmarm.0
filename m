Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079117;
	b=Aopuy97Q/jPTSssmzc4yQ74TPX6VJXWka7ZCcb027MSvOKIAwclbLamv3Vpl0eCqLl3R
	 q0USgtnOI3qZ0VY2vtE7/c8fNmhTdRFvBuErh9ZPZracdPCL3BsyT7LYHoOrhhNkNp+ag
	 4pOwQunnlFJ5ljie3146VCT4FLwmbJ2zaCLh9R1kMfBTICSET1t91AZQ2oDDUh6nW++t6
	 6QqwQs6PIjz4I0lyqFZ4KPrrYbe2DacQSqzZ5S7P+SXRY4lGyIOxvhLqUcfJwLudofByP
	 f/x5XqTcE2+LE+7AoSJ3aqBYZsHmvlBBkUsezDuV+AGVm1d2ZXCjH3KUNiUQHoIvAiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079117;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=tVnybqfQP+0SY9toa390RewPeBuG9wb3MHioOA0atLc=;
	b=YoHh5QKLQZAWM362EkNrWLCsWwArr5QpaZOE3mZP2svxaheUpgAEjnnGBPprV1oT3s9C
	 r/FR1rf/iMk+9hE7mqAN5hKeMWmhexBf8OeENAbEUd+KcM4sG+ItFi/Ah/MEcOinJOOJz
	 hddmT6EvFElrOjvJ8ntmAtWqTuz1TklnJ/m0r5Llq8CrXmTn77eMJtijmSQQW7LhkGVZ8
	 ntPLNVp0BN43HhbpbZVIJoGRXuD49KRGdRRFguySFmZCZJe+dmSQT2aQMF4r/LySlYTBL
	 DAPL0QXuh7LwYymPQ8iVjnI5sjjPYaXE15IbPKFZkMyumxNjl7/+9LnyOogXyhEi5jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=nm2gJzw3;
	arc=none smtp.remote-ip=139.138.36.223
Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431860A261F
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5431860A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=nm2gJzw3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795079116; x=1826615116;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=t70F907DzW+0QdbW9r0saLortrOhZdjwwGxQU9dlVtE=;
  b=nm2gJzw35H9crWUtDwKhlfX1NKqWvCSSV+XUhGneuEKAsrwkEI05g6tY
   ZTt81po4/9Egt3gj/2R6Y7vu+t8OtDnMAku87s54FkXdhzbUSiUR+GG1z
   dwiozf9ydSi++RH2E2D6Fzw6ictFBK0AyU/+ujB//XSvD28K6eSG4qzEl
   teXIZMV9IuAOPSzvvRXY+wuvUJx1T3LAT9XUfAFlIjdFuJTjNQeKHlJHh
   vs+Q0IKhGHgBVVN6RmmsF+vfSpA0FJly571IrJOHxUzuD7gFJdZVTVh6X
   PswYENoap9eCM+DiLfZH4WEPzr6jcOq/lgcAP0It+t/aeTN7VIX+CGNJo
   w==;
X-CSE-ConnectionGUID: jkTcmFMzT6mdZBtr6D2duA==
X-CSE-MsgGUID: eQMtRS+PR5uQ3/60ZkEjbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="249932061"
X-IronPort-AV: E=Sophos;i="6.27,220,1786978800"; 
   d="scan'208";a="249932061"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 18:05:08 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id AEF7E8214F7
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:08 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 5E70D14003D0
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:08 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTP id CA7DC1001166;
	Thu, 19 Nov 2026 09:05:00 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Thu, 19 Nov 2026 18:04:33 +0900
Subject: [PATCH v3 1/5] arm64: cputype: Add FUJITSU MONAKA definition
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-monaka-fix-for-upstream-v3-1-057df4d2ca3c@fujitsu.com>
References: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
In-Reply-To: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Kohei Enju <enju.kohei@fujitsu.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795079092; l=1299;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=t70F907DzW+0QdbW9r0saLortrOhZdjwwGxQU9dlVtE=;
 b=7tbIjW9MamZkZ0/AH09YZ8pHA3eHaC05RCH6WpmeFUm9rq3ptSPPxKF0yX/X8HmuAvKbVsSO6
 uKjvZ/8D5SLClGuVr97t8nS3IoqBbqoQdvOp5E4BXAhm7xq2C+L4WNz
X-Developer-Key: i=misono.tomohiro@fujitsu.com; a=ed25519;
 pk=VLRxj5y4GJrHLmj3e2NBg30fX2U//ydi7c2G2qiNo10=

Add cpu part definition for FUJITSU-MONAKA.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 6002d1d5f55f..fff0f460f43f 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -139,6 +139,7 @@
 #define NVIDIA_CPU_PART_RIGEL		0x011
 
 #define FUJITSU_CPU_PART_A64FX		0x001
+#define FUJITSU_CPU_PART_MONAKA		0x003
 
 #define HISI_CPU_PART_TSV110		0xD01
 #define HISI_CPU_PART_HIP09			0xD02
@@ -237,6 +238,7 @@
 #define MIDR_NVIDIA_OLYMPUS MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_OLYMPUS)
 #define MIDR_NVIDIA_RIGEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_RIGEL)
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
+#define MIDR_FUJITSU_MONAKA MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_MONAKA)
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 #define MIDR_HISI_HIP09 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP09)
 #define MIDR_HISI_HIP12 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP12)

-- 
2.43.0

