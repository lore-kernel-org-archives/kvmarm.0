Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0931BD03A
	for <kvmarm@lists.linux.dev>; Tue,  2 Jul 2024 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719938122; cv=none; b=epaLECiOWPigj4xfwOhkxH5ejUWLGhNYb0qnjuOSRLVgK3/HQ9fYMkTHcCnZ7O213LboROhUVjmDDiQwmLQFv6xJkjPloxoZ5X2wi9dgyBoN7ApdnkX64FVKdOIdN9BkzXx7hLXj0Zq7NzCgy/JIE8ZQ00IwcYqw5G7JVJX6szg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719938122; c=relaxed/simple;
	bh=pY8x0+IL41Sv5h0liBJxf5jrHXv+KWn3gxNFTzEI2gA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4m/8I4ztEhH9JDPQwA0mnF4GmAWU5Dp7q6qasHOLhqDQp+3uzY+m2QClN97yFeN+SVisWQdrJYnhDhNhSSEKP585QB9IJsGeuIJKaNETudtvbbiM4cbzNP502ZcQtdp7T5NVr2rqOswdvLkEV0DBOhh2/Yh0UR0WJURk/DYpXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jg1WSECJ; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jg1WSECJ"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a724958f118so540707466b.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Jul 2024 09:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719938119; x=1720542919; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2PdP7fwhovm4zuFbTsGS+kYSr4P/6sfjgnZ9Yiz/Fk=;
        b=jg1WSECJVMFFkOcqIDND6Eh0dKmdHQcy6K72NTrmvskTse/SNqL7QegI9a1BEqIFPf
         qSpS4podQUuoS8rmQpY9S7G85ZO8/ex+ZQhhkZG/M3CsZFu6aTI2wGTaOnme3QZ2rC6i
         BdueV7RB9udusCrJMvJLTM2T/56r0Ff7QVHC7pnSiUNBRta5tN1qpR7I/gf/hLZL15Z+
         AOCaUGn3IcC4zOCdrV+ctygTEb2XaqxXjnpWvzUYS2VjaP5A9VyXL5+3mUPiIQq6r60K
         ZfVUwqlawoaUj0IuwUUtgCSo5lgUpQLFOD45pmeyb754rJ4jFon54Jvc+qu+SPpCb2wZ
         WWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719938119; x=1720542919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2PdP7fwhovm4zuFbTsGS+kYSr4P/6sfjgnZ9Yiz/Fk=;
        b=DOXkKcehmqpl15TCxQq230cxKi2Blyht0YxBArT6m9hP58oCg0cq7UDuyiEfofY11K
         ySTGKkYuRitAaUM+q6q25tf4WDVZTWo07QaSPVztpmmg4gUe6oyJ0R6rDKYGYrgPeZGi
         zah1ngil17Z/JsGAbxrypJm43RjiYMNTJsjF5CTYpTUCLWHWndnxSvnVtCq+Mf6Q9pJ6
         il4k48+ytSjpl94UpAdmdSwOakthJj76ozIxcsf2yOaesNmOCH9wssX8gqD3kSZF7xzA
         2rADHDNE70P3vDMheCE0TZS6TtosMhGnjABx5xhQ8Ud7UCKIVxVUKV+5BcTmMmc6/c/x
         1T+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWExMN/kmDEtjpRF0nSlprsEr4lgImQcATAid+uR4oUkYz8cLl7vgizBakKP6uMNrkBUIzh8b389SDPG8z3XUYsHd84R9Cc
X-Gm-Message-State: AOJu0YzMKhRX5HTaM0doAtrxtlU1ZQQmMFb/Uf5srUDVexaptDXiIys3
	wc+0g3EPs533l1nAacTTJtUMclTG2P1kEp4sHM/nQgKY4o+qKUV2dwhvkjHa5JU=
X-Google-Smtp-Source: AGHT+IFxmrxAj1VktUMByj7Xw6HSUJJNLn+Inx9C8W4+xXXqlzwq/OMRxn8bbZoKs8uozwXqJXHXKA==
X-Received: by 2002:a17:906:db01:b0:a6f:4bf2:daa2 with SMTP id a640c23a62f3a-a751443c744mr799316366b.15.1719938117250;
        Tue, 02 Jul 2024 09:35:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab08cfccsm435948166b.148.2024.07.02.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 09:35:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id CC8685F93D;
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
Subject: [kvm-unit-tests PATCH v1 2/2] arm/mmu: widen the page size check to account for LPA2
Date: Tue,  2 Jul 2024 17:35:15 +0100
Message-Id: <20240702163515.1964784-3-alex.bennee@linaro.org>
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

If FEAT_LPA2 is enabled there are different valid TGran values
possible to indicate the granule is supported for 52 bit addressing.
This will cause most tests to abort on QEMU's -cpu max with the error:

  lib/arm/mmu.c:216: assert failed: system_supports_granule(PAGE_SIZE): Unsupported translation granule 4096

Expand the test to tale this into account.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
---
 lib/arm64/asm/processor.h | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1c73ba32..4a213aec 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -110,31 +110,30 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
 #define ID_AA64MMFR0_TGRAN64_SHIFT	24
 #define ID_AA64MMFR0_TGRAN16_SHIFT	20
 
-#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_TGRAN4_OK	        0x0
+#define ID_AA64MMFR0_TGRAN4_52_OK       0x1
+#define ID_AA64MMFR0_TGRAN64_OK	0x0
+#define ID_AA64MMFR0_TGRAN16_OK	        0x1
+#define ID_AA64MMFR0_TGRAN16_52_OK      0x2
 
 static inline bool system_supports_granule(size_t granule)
 {
-	u32 shift;
 	u32 val;
-	u64 mmfr0;
+	u64 mmfr0 = get_id_aa64mmfr0_el1();
 
 	if (granule == SZ_4K) {
-		shift = ID_AA64MMFR0_TGRAN4_SHIFT;
-		val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
+		val = ((mmfr0 >> ID_AA64MMFR0_TGRAN4_SHIFT) & 0xf);
+		return (val == ID_AA64MMFR0_TGRAN4_OK) ||
+		       (val == ID_AA64MMFR0_TGRAN4_52_OK);
 	} else if (granule == SZ_16K) {
-		shift = ID_AA64MMFR0_TGRAN16_SHIFT;
-		val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
+		val = ((mmfr0 >> ID_AA64MMFR0_TGRAN16_SHIFT) & 0xf);
+		return val == ID_AA64MMFR0_TGRAN16_OK;
 	} else {
 		assert(granule == SZ_64K);
-		shift = ID_AA64MMFR0_TGRAN64_SHIFT;
-		val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
+		val = ((mmfr0 >> ID_AA64MMFR0_TGRAN64_SHIFT) & 0xf);
+		return (val == ID_AA64MMFR0_TGRAN64_OK) ||
+		       (val == ID_AA64MMFR0_TGRAN4_52_OK);
 	}
-
-	mmfr0 = get_id_aa64mmfr0_el1();
-
-	return ((mmfr0 >> shift) & 0xf) == val;
 }
 
 #endif /* !__ASSEMBLY__ */
-- 
2.39.2

