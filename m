Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795757846;
	b=Oi/aEOYqhY6sBuzxhxEr4YmY5QjBt8KUFnZWjUe4c6gOv+seEB6qjUSzAQeNooE4sme1
	 tCf511tWDXsBt2DwHYGWyyXW4PvykyT2ROoR4OW7LUUjg9OoZUnSvX+pXqFFa0G+2jQgj
	 S6TzmRus7+TWG0j3YHuQ4v48PWf1msxvrmmtysdMmY6lb5BshN144XTBU8wvujgnXBZ0W
	 ai/yxxj6gbS1PBRGO5rd3RbR7wKWAPrWWZKsyqvIQ817WPmP9v07zsEMz1w3BAcxjcSly
	 N+O0BJqXd46070RDQR8zausSDviSEx3Udai2hqVsKR1oZYIIafAsfhSgLbfD1ld408A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757846;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=tVnybqfQP+0SY9toa390RewPeBuG9wb3MHioOA0atLc=;
	b=ejsIdvzXRsIltWkfaQCQ0NT4EtLj6bnmg6IzuLn6nOqAxVVlYk/NlZ/Sj5wijIuXz7Bq
	 aeD7C/ACGOWDuCpl1xFfh4CIBvED5uzBVDh13wVIGO2tpP1Py+XcfTWCAsvaIxm1NE9Zi
	 XaalQwhqLduZOX3mEkmOdbx1z940DnR66739ToN82gDFSG2AaQDzcj4mAoZyFsOIgqi9l
	 KuO7CXyM1u1P4CCbv/GirhWR4i6wH16iSK1uiBzR8r8Jd0mTgtep6vObH6545W9Hfxv/N
	 Bt3UUBwT3IYbbvZvUjv7b5xvxwhBPs3LWVui/QNWJ4F0+nE5AUIGrGs45XjjsRUbO6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b="AYslgR/e";
	arc=none smtp.remote-ip=68.232.139.130
Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584A8606A31C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 584A8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=AYslgR/e
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795757853; x=1827293853;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=t70F907DzW+0QdbW9r0saLortrOhZdjwwGxQU9dlVtE=;
  b=AYslgR/e1Kzho4dz4qMCz04rXdUxSnVfwouOuheBXEKnQeoBxcJ4K8pX
   x5zwuN03bUDpMNQ8GBRXlOeEJ+LA6JiQc5nuaRLvq8+VFcZ2N0FOvvLxX
   YPPFaMPjOsVXMqCzaF4JjCGI2Wyht5ej+bqMUe8ClVqnrEPmcYiM4NBqL
   /BJxZqGGt/DBFVpszL+HEehoSST/jPUOPmSuRezIaKBcl887HRUUH0HsL
   PTZO3hr7Yu3KXcVhxbucTkdHAXfqxvnf9YiyTT6/YFgHlxYtD1hW766w3
   eZFHfDy6zRbbVoKXVMxoBGyoIxS9Ms4hL72WA1DAmAkvSLI6NfpZyOcKr
   A==;
X-CSE-ConnectionGUID: 8uEttYPfQRyyCkjNPJW+jQ==
X-CSE-MsgGUID: B+cMrL4GQYqXSP8Qp1E6cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="261514721"
X-IronPort-AV: E=Sophos;i="6.27,236,1786978800"; 
   d="scan'208";a="261514721"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 14:37:26 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 46FAA1C01691
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:18 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id F0A8014003CC
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:17 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id 7952E4045EE;
	Fri, 27 Nov 2026 05:37:10 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Fri, 27 Nov 2026 14:36:30 +0900
Subject: [PATCH v4 1/5] arm64: cputype: Add FUJITSU MONAKA definition
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
Message-Id: <20261127-monaka-fix-for-upstream-v4-1-3395c415bbe4@fujitsu.com>
References: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
In-Reply-To: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795757822; l=1299;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=t70F907DzW+0QdbW9r0saLortrOhZdjwwGxQU9dlVtE=;
 b=uo0E+IarAjICrItkUNTDd7YTIlhjU6ClHbTKnjkdDTYC46jtdai+Js7t6184fHECST/PbUykE
 3NjjP4RzVEJBpj6YuT6vkUmsuxQSty4FTJX+cRWdyn9/LvpiSBkC6aW
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

