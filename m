Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA61DC197
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016457; cv=none; b=jqWEOdEPMf2iLPB8MAa6vBDEb+L6+sLz4bcP9DWsCQUxSFi7npNB6p4yAWiEt+jNZzENIk4ykoHZ2ombHE74wxyYNIWgiat7SoVM6bF8jDlkWvwhJPmaUEntI4nNts8BuQkH7iW6VLis9FqTfUmySBaMUkX5Yk/+iYYoqTDM1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016457; c=relaxed/simple;
	bh=SZa0a0KzR+LD1LUzSHL466MizkYLm52X6tOmDCEf1DM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hjyIUON5KLQ8Mikjt4/KnKrSpL16OqZ4xz0NsY56RxQoItIGxSMoGVoJlsMGBs3h+XSgKzQceKad2ehI/fCwAZVCSd3zc7fPW3RWyu3vxscyAc/sX7u1DiY3gg6LuFG8WdsU6GYbGxCiytku0ydBbocLQBeHqr7u2lmq7PfKyWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SjpnMqKX; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SjpnMqKX"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3cfc08132adso72000815ab.3
        for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 14:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738016454; x=1738621254; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eB/WXdYtPvN5Ab5ru245YZuFbSt2Wl8WSfh8CIWhE9E=;
        b=SjpnMqKXQCUz2nSot3P6qQ9qs38tex4QvPDrQpFYmzpanzh7BmABE2Ee/pmnQgf/H5
         WEFI6QN1aXYhoWPNDmJUuGG86tggk8pGXtQlEXlIhqRtotGhmHlDgmn908NLkPBehxN2
         mVLUZNDKgyqedoG/h110wRDX7l9h7vn+Z09BZppvoLkEWnoZAqOWZPnuLZeRPK4Ad06m
         rcKQbz+umzFv9/FXvfom0vuhCQmubom2y8yLl8CTcwxzXwgfC/+0K+l/u1HsmsZI5riY
         E2pNeWpqvDUu5ZBGoV8CD3uLl3UJM48fsFkldH5pTZEe0/ZjE6OGBL1797sYgPtJRa1N
         pwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738016454; x=1738621254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eB/WXdYtPvN5Ab5ru245YZuFbSt2Wl8WSfh8CIWhE9E=;
        b=swh/U6LAynLe1mihwHnPwp6c1y9SYFH9lAVy2pXujkCvBzaD5KsBMqlVYeJ69MZ9AV
         V1CON4ySBkrVEdD6YK5eBa9E04TfIngrHGgqf98DsDauUfPw5iXA2iZPhNfyBraiqlMh
         EgWVqiMetTcmDt4rUqRH5SecoRnfSMk7GY3K8RPNuRga+qUJ48waLhUhsiguDh5PxXrO
         6lU5GDRyaHToZp8ESQK6pEu5UxitXSHW4sKll4Y1SvdQ1vyutdMlFufMcDGA0F/WEMgJ
         JSQgX/8Onf78Nl69Aqxezo2Hz5QnlDi8Jdj3vLBijzHSwPAx0Lqi0XcyeQxON1tD/obS
         EK/g==
X-Forwarded-Encrypted: i=1; AJvYcCUUre6wmg7VXWADmC5K0oToBvvSRON7M1LuSy+k+g1CKysbQ8qo9DcWpGBmqEAq5GkDi6cq5/I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNPHwrR/SOZHPBy3Eq0+b4Qeq7P0u2KCu+cBfg4CBLr177I+Wf
	FujYdS49bXjvQfV667yr2wTzTwMK5sk2LUn8IKQC8AEi09o8rL+3Qy7dmm04ZVA/ULtuaCIxbu/
	a9XEFCWviXb9QGJ7KiOgKHQ==
X-Google-Smtp-Source: AGHT+IHlnPj0B51G4F3gaUMK8xZM3/o5eoR0afyVhEDX9mUYzTDBYrn3lVxOBnfUacMgZ4+x5YUCgf5OnSaiN01GgQ==
X-Received: from ilbdz9.prod.google.com ([2002:a05:6e02:4409:b0:3cd:deb8:6a64])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1fc9:b0:3cf:c88f:7555 with SMTP id e9e14a558f8ab-3cfc88f7680mr123300885ab.17.1738016454065;
 Mon, 27 Jan 2025 14:20:54 -0800 (PST)
Date: Mon, 27 Jan 2025 22:20:29 +0000
In-Reply-To: <20250127222031.3078945-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250127222031.3078945-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127222031.3078945-4-coltonlewis@google.com>
Subject: [RFC PATCH 3/4] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

These bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 include/linux/perf/arm_pmuv3.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d399e8c6f98e..115ee39f693a 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -230,16 +230,23 @@
 #define ARMV8_PMU_MDCR_HPME		BIT(7)
 #define ARMV8_PMU_MDCR_HPMD		BIT(17)
 
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
2.48.1.262.g85cc9f2d1e-goog

