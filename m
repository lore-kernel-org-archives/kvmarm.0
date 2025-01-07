Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED36A1E9B0A
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249663; cv=none; b=AAOkz/gYT2MWp1dAk2Bh0Iu/mJg5qbIzUIOQjFnd6/P3G1OZlzOS+pO893rZ+CMaMI8EFaxa36LskDBUj9/5k94ZuSEpLg6JLkC415VCyr4IuIU2Y+hdZfME0BBDexsI8upZI99Vnr3+lu2L9aB/NGPgNIvPWMQR5Kjhcqs8hKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249663; c=relaxed/simple;
	bh=Tx4gZmqzWGxrZQuBl6Y8lsHTs6MHxSd+iZijyrQcFJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qWdMKlTF76TV4htqyma1LdcyJcTJsYYzch52rP5/9rCwTjep0f7zFMvcxE+3Gq/NjvG3Y22AQX18ePAZc4VWqBrBI7J9N/g4LvGp2W8VuzjKqqZBG5yWvj1bdiXnO+R858AINbE6zTNlditrGzjDCYTZkRnNOHIyO9YIVxFbYpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ggp9gmTD; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ggp9gmTD"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43675b1155bso147110555e9.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249658; x=1736854458; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFl0rTqzMZOu13PyWwuDfrMn8Up9x5/KT5bdiFMR/Bc=;
        b=Ggp9gmTD145rd7c/pRq7vQ7kDT/5TieZV/k9QNHgg+m/AUeiE1GgEvJ1I7pBLig4ok
         C2/8jFlO2R29aYB7/eGLvwrUfBkDMSX1sH89DOT3ql4Fj/ENJqZSn2Mek1pt/LwHUFgB
         l+6zIwv1KVoVCa0eEi8R6Du14edF+fHNy82sxzQSCVRogLQYBGnaCb7rxemL9Bd+UAai
         4p12syn2mFMRyb52q1EIrixloX9+XUcpBslSy+2qXd1kUTwS4AC/S3JBQkPrnrJX7cG8
         iAfdV65RMRFwOGDUJXNzbCsiFxQqyHsT8BOUN0f3BC84kTZ+Kh47hnqFHpaOJWRP+Blz
         t5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249658; x=1736854458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFl0rTqzMZOu13PyWwuDfrMn8Up9x5/KT5bdiFMR/Bc=;
        b=Cf36BgbII56JEYwPRLR1TT4sid1QD0yLWHXVPlyLh8eMHH7oqAcowP/l5TO0Ln3KC/
         CG+XhJ1ysOS5lVGNHup0EVto218jr6ArtxX2Q7e+ccyCk5jMwhTG5dPJIl9MQ5BvbTRZ
         +/dpefricZ5Qs+WSo70nRnrYFJE6HfM+r9sirJ1P/6W1rncB+IjwzfyQIO8tcMIGcMRq
         X1V2tAGyHs9oyZQLbE0+7JJBQ2+dqZKYrB/MVbnl5NoDy6dwVQNre5eN2Bsd1lxXC+hS
         o2/ChHQX7AOU/a2KHCvCdCWX4DVK8E6AgN5TcV1ZMlgOtigWbXLQgd/h3yyLlNYfr2pY
         DJWw==
X-Forwarded-Encrypted: i=1; AJvYcCVBjoRb9GHt0SR60SF8GEgYw91EnpUZsmesO0LplG4FlpUDskFjfMg9Oom9nVAU2bbCqS6MnNc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3z7DnLIPxGDN2VRY9UrmFPvuQYdA85YNALb2Mp19RpuDTAKSZ
	YwLTOsH6fhBsoRa/pb9LpBvUm0UPXMGystptcCCK8Wb+KeLYj7aOFYFHuyby770=
X-Gm-Gg: ASbGncuxpT7QrbUS2juUkYGSJxL46QB6jltL2xD2cuqBea86IETRafFv08N1smFwbwq
	TVDN7J9MiwZPmbwWDntEwSimF0TSFHq2tfq3Y5iJlrTzAkz1q9rEWC86TDPv0EWE2SWCKW13NxH
	5ac9ig/itm7+jujgB6Vpa60Nb7e0U+ZwFh5DgXcqYRs5bxct8EXc7j5GdgWJLZTkm2Iv9ek20r1
	QCH+PMyI1hD8mUK06H3W3FKCgi3m+CFj5A4lVBmZ0LU8vNuOvQOeXpm
X-Google-Smtp-Source: AGHT+IFAu6dRs3Zmaqru9uX4iNurUOwxinvqVpqIj4nCknFhIiufx+Adf13BSKMD96GQa9CMcfatag==
X-Received: by 2002:a05:6000:1863:b0:386:4312:53ec with SMTP id ffacd0b85a97d-38a221ea72bmr48392528f8f.17.1736249658294;
        Tue, 07 Jan 2025 03:34:18 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:34:17 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 01/10] KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
Date: Tue,  7 Jan 2025 11:32:38 +0000
Message-Id: <20250107113252.260631-2-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250107113252.260631-1-james.clark@linaro.org>
References: <20250107113252.260631-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Nothing is using this macro, get rid of it.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20241219224116.3941496-2-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/debug.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index ce8886122ed3..587e9eb4372e 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -16,11 +16,6 @@
 
 #include "trace.h"
 
-/* These are the bits of MDSCR_EL1 we may manipulate */
-#define MDSCR_EL1_DEBUG_MASK	(DBG_MDSCR_SS | \
-				DBG_MDSCR_KDE | \
-				DBG_MDSCR_MDE)
-
 static DEFINE_PER_CPU(u64, mdcr_el2);
 
 /*
-- 
2.34.1

