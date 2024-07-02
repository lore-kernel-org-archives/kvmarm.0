Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661F91BD01E
	for <kvmarm@lists.linux.dev>; Tue,  2 Jul 2024 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719938122; cv=none; b=lm0CDXgW3GMp1COqLW0qx50y4ga1GKsxqPDVwQ/lwCXz1gQbn2TMUl2mr6JermyMPos9Ux6dAfRIREMtrP/l6+NM0X6OMywdfTnSQ7pj59t5gXcKmJuD81HpiijgzGqL4eTFtyRUqhf1TidsnI3gm4B1xle21BdSu5+Bs7hrgsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719938122; c=relaxed/simple;
	bh=lygSVGqEW/V5wPZ/noOw52DNAd5cGOkDdbbjhHZVY1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxPikSPEu8ZUXGctbH6JuAPiFK9GL2y+w+ZqFabBEZwLAK/wOztNoXfeeI+u0Tm33wZiVMITGFfHG4YSr/SZWUMcwqpsbtcZm5kuYoLOup1KZ46yZx1WrbCieC6rmN8EQofaSgFp0tY5N3X9YX73wijSTQqjWAVFu/rn8Spzyeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OW5v+0fK; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OW5v+0fK"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-57ccd1111b0so1229201a12.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Jul 2024 09:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719938118; x=1720542918; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26ibk6G5TBJ3+G8dW2FBwDssd+gYK6j25tet2PWM190=;
        b=OW5v+0fKVjuNZfUwH75Eb8g3UV0a1wJbClcFTD0xlqePoZioVK2Uxg+3Kr9U9T6cTK
         1PLTZ5XmW7qMoPwuIkBLppZ5Whf2UPDUAo1WbKG3hklIeAMS6tG2LNbXouyBQ/GDUfK3
         jhfOn/cEPz5wOVDCPuS5DGgX3mr36Ma1AM4EJOIPyLdEGauiyXlJ7hmbXIsDKvVbtpY1
         Q/46BZXpwI+//ILNbAHzMUbCCjvrSp25NoVZzNql7YfN/LDQTq+Piy2ZKiELKgjcR/zP
         Ke7XFo8gOtKVrHRkHCco/4DlQtHXCMy6H4AONrv6/R0iDN489/UqEg/3mkiQKLL6iaf/
         veIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719938118; x=1720542918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26ibk6G5TBJ3+G8dW2FBwDssd+gYK6j25tet2PWM190=;
        b=k+bVG+zZ9cPUvlTzLenGvVCNMoElpEAbDvKKGdfEXk0P/CAkUppbs5JWblUxMowKr7
         gnAM5lZRJ470r4n6b9B7ddP6E4uaTxIjFa0UWrShWZHR8Q/JXzQpkbhoZM9+VChIr/FW
         U+/36uCOjjTuT0uXJKTLtMRebl3tFtbXtq1Olk8TwgFdHbNoaSIvotwci/fpJBKRnayd
         9tNT1sxcE6ugMRj90HHytiGhGV/xYNzffqO9HEiQemR0UX64rokwgJe4qo7C2KLtYPVH
         MdnP3FYgad1+U43vrMv3nV7qG28p1154hMkaO2ZCmlX8g2HA2+7CwnVO+ZQKKu4QNOKP
         tOCA==
X-Forwarded-Encrypted: i=1; AJvYcCVmur3r9gDAAJMzt20VgrvpGOEYpkVn3CJDTnXbXDzWpZyBoD0hRU6fdvDowYVjeJkCt52SAknLU/vOyWk8CI0K9BVPjLj6
X-Gm-Message-State: AOJu0YzaK615NtxU+nQlvR4CvrUvtjGvofDbR29GAMNdFiyoYTZOLqlv
	v/XLXooBPBic/sGLlCytfEjN4BwkaGzUrp5FjAw5pfBRVxxq+ZM00i9wZ8D3jc8=
X-Google-Smtp-Source: AGHT+IHBhfNB7jsgIlUoHE4OPYBRUkv0au3wXdb9DmRC6/b+bjRYvNJ2M/3/OHm9YVxoyt5+KFsgIg==
X-Received: by 2002:a05:6402:5203:b0:57d:1696:fd14 with SMTP id 4fb4d7f45d1cf-5879ede2704mr8832949a12.8.1719938117526;
        Tue, 02 Jul 2024 09:35:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58614f3d3f1sm5874972a12.94.2024.07.02.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 09:35:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B60F55F8D1;
	Tue,  2 Jul 2024 17:35:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	christoffer.dall@arm.com,
	maz@kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev (open list:ARM)
Subject: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU introspection test if missing
Date: Tue,  2 Jul 2024 17:35:14 +0100
Message-Id: <20240702163515.1964784-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240702163515.1964784-1-alex.bennee@linaro.org>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The test for number of events is not a substitute for properly
checking the feature register. Fix the define and skip if PMUv3 is not
available on the system. This includes emulator such as QEMU which
don't implement PMU counters as a matter of policy.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
---
 arm/pmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 9ff7a301..66163a40 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
 #define ID_AA64DFR0_PERFMON_MASK  0xf
 
 #define ID_DFR0_PMU_NOTIMPL	0b0000
-#define ID_DFR0_PMU_V3		0b0001
+#define ID_DFR0_PMU_V3		0b0011
 #define ID_DFR0_PMU_V3_8_1	0b0100
 #define ID_DFR0_PMU_V3_8_4	0b0101
 #define ID_DFR0_PMU_V3_8_5	0b0110
@@ -286,6 +286,11 @@ static void test_event_introspection(void)
 		return;
 	}
 
+	if (pmu.version < ID_DFR0_PMU_V3) {
+		report_skip("PMUv3 extensions not supported, skip ...");
+		return;
+	}
+
 	/* PMUv3 requires an implementation includes some common events */
 	required_events = is_event_supported(SW_INCR, true) &&
 			  is_event_supported(CPU_CYCLES, true) &&
-- 
2.39.2

