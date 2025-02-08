Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6A01448D5
	for <kvmarm@lists.linux.dev>; Sat,  8 Feb 2025 02:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738980086; cv=none; b=F0VaACsULiT7T/J/IGmn7fdGZT7xQyEng/As1ej0NtsuC2PLxp1rCfeT3r75Jdgu/hejyUVmCrErZRb/kgAo5xEtOX+1MFPimNH4teupZoaybBSh4SIIlyU/WmDJpoDZUJiFtWkfdHQyIGtEOZYGzy9VoqmrTFWya+e9SiJNxhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738980086; c=relaxed/simple;
	bh=+qAoXvS6xc+m3hsF9w5PjnIq4aq3I0ctOVpDSrBl1Js=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uAQvDAYgU4zujfJ+tSC8iGagcOrCRatkhMtZGAi0XHcFz3vRIfH/dkEjC9GZgw/SCYun79xXQOoPgoZAYA2btNLZoBJPdczECaidz+wnlmcNfOAomrbMBxHjpJrfHqFjwKQrHUUBw2w/A8gxrjyvTXlLPFiBgsU4W9JWqJ6pGG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=saFmnvKi; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="saFmnvKi"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-84f543c55dcso500601639f.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 18:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738980084; x=1739584884; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4O4akjcxYhNwCefv175mmgU5vTvI8B0CXOe+M7wmIh8=;
        b=saFmnvKioWhCagW2XTlRUn/xCELfuIBKXHXew1/uS8D0xhDjfdFR/x1lyQtX3wOgS+
         uU30IYUv9FnLuwJOegmxe8SJxHHai65v68MP9luwmLHNhXo4Wast6NKokj/MpdvIarzW
         Ysylo3ENxeUQ4r8sh9x3xgvlfsQFNSz2M6uYDEzqSp82nTwh8Spqmept65xUlHdLVGRn
         257qqNyhzrEVifdiJDDR1v9vLy5j03/moCHSAJ7il2CpmaKmGU4uxhiz/aVzowHwW/D/
         PHjvlF17QNdLDKdHmKKqTr3w+1shnYvdrA+/JWBI4wI1slBKMNuVPasnYx5eeU+hmvBP
         /ZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738980084; x=1739584884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4O4akjcxYhNwCefv175mmgU5vTvI8B0CXOe+M7wmIh8=;
        b=h1fWNC7JF4/4vbkm9fQbl+gjAz51dUmo0r4eajcQX58NDTfGdpqdHnKR5xxaX8cE/U
         G1YRzS+4xkFw+lR6fFzqt7E5fIgeBQTU/NpNR82ixXE//C5GSBSvYjvB8bbZhEScUrHB
         UAFEE5YEgPkys4F8FFL4k7dSS1XMBk/g3hY9ZquiGmYpDFaM8gcPDUTl3g8Bt0QT7TtR
         wVdnrejnP23zqHB3f+xKv1LESbNML+UFkqV0+0B63UvTaT0xKpvtvAEoCWOPEwBXbZ9y
         nZXUMub6BPoWeBr7PvhQZ3S6gsMeD5FFxwxz6IFO1tYYSBjXZWyc8Qb1vSi+DjXhaI1P
         SKGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEpD7IKtVpTHd4dpkH4398QfKUoYKI4Uyoj2ptZQM+deunGAmIjC0DBFuLzOc6Vlw9meb1P6o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yychlu3pSIarAMTFN7KAQN7gGAZUlWp6Bvt3KCZruE5tG7FkF6V
	C7cXgyYJ1Y/akdMwWtJZkbP52SfFo4Ra85vpes8Py1h422IEIooM6xF5yILaAz0s10Hmt035Fmi
	0f7kFn2YpwJVgeH7rgKKdWA==
X-Google-Smtp-Source: AGHT+IGWeZpc2qa1ckU4PjgV51Y7Hx9W1wQ1TYRDVmT/vQly3n2guK7Orb67xhImPnqLeWrkenED8+oum8nOVfQ3mw==
X-Received: from ilbee27.prod.google.com ([2002:a05:6e02:491b:b0:3ce:69d1:ce53])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:17ce:b0:3d0:1bc4:77a0 with SMTP id e9e14a558f8ab-3d13da22469mr48897165ab.0.1738980083677;
 Fri, 07 Feb 2025 18:01:23 -0800 (PST)
Date: Sat,  8 Feb 2025 02:01:08 +0000
In-Reply-To: <20250208020111.2068239-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250208020111.2068239-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250208020111.2068239-2-coltonlewis@google.com>
Subject: [RFC PATCH v2 1/4] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

These bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 include/linux/perf/arm_pmuv3.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a2..c2448477c37f 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -223,16 +223,23 @@
 				 ARMV8_PMU_PMCR_X | ARMV8_PMU_PMCR_DP | \
 				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
 
+/*
+ * Counter bitmask layouts for overflow, enable, and interrupts
+ */
+#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
+#define ARMV8_PMU_CNT_MASK_C		BIT(31)
+#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
+					 ARMV8_PMU_CNT_MASK_C | \
+					 ARMV8_PMU_CNT_MASK_F)
 /*
  * PMOVSR: counters overflow flag status reg
  */
-#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
-#define ARMV8_PMU_OVSR_C		BIT(31)
-#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_OVSR_P		ARMV8_PMU_CNT_MASK_P
+#define ARMV8_PMU_OVSR_C		ARMV8_PMU_CNT_MASK_C
+#define ARMV8_PMU_OVSR_F		ARMV8_PMU_CNT_MASK_F
 /* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
-					ARMV8_PMU_OVSR_F)
-
+#define ARMV8_PMU_OVERFLOWED_MASK	ARMV8_PMU_CNT_MASK_ALL
 /*
  * PMXEVTYPER: Event selection reg
  */
-- 
2.48.1.502.g6dc24dfdaf-goog

