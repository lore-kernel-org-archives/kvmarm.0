Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C1C2F234C
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968357; cv=none; b=qu4M2ykLacPwgUxkaTiDEPeMt36J3YIJ5SPiw5mXBU0ux4Y/tfemtyAaCTSL7Mh5uB/1ld+JVzmMSEbFfrSyisH0S/g5P2wnyHhP9UCEUBzIRlwe974uMJtn4btOmpRJmKjpWEEtxCF1D0AXJZ7z1gfkqbVQIHcRf9ybCyKJEK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968357; c=relaxed/simple;
	bh=bO4sw7/hINJdmJB2o7i6RovRyFWviPuCwq5wxaiI8Bs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lpDQCPiXzQxIk5wiMWKi9/gxymSLOM46eoVRKCnakGRS6R5Xzm3flvZxpqT51Tie75ko78IIvg9XUR4Ewa9A4OGt/km/VnA72SxMCBSpgNfmSdMCyFmNdyIvaUt5Y/aYnHsiceV2kKVie93ftUbfXsCOnQUSfJoKHQ2YSOr9X+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BREiA4z2; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BREiA4z2"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-2e954a1d239so1213353fac.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968354; x=1751573154; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zPJCCS28P/ht0GkmQnG+3GK0DAvT59T6hS3LwMCctEw=;
        b=BREiA4z2C23AhI9MbHiEw0GUhgd/vpZf+7CUTrelfyxHhfQBmDB8352up187aiBx1G
         vjdT58hxL71WQg1UeBf5YHC218f1OQk5UgVI3AZTqMTQiv8Vx67N/yWQbo2Tpx838ZB7
         Chb7Zbn6muvzsDE4pDO1ukPVDSEmYzlICGpT2M5ld5stA7tJOqupE1Z5Og5izAZssidC
         2uNiOqbBZH6I7hftK64qScW3424CU0XUtrzuVx/yCEuESYuX06aCzFFoXSujw5iR7l7C
         zayV8AO+EuvnTfaCfSgSDD4kb0CCIxiMURsmb/oCNYnNLWC5geTsEBRVKuDmQnDUJuIi
         nFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968354; x=1751573154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPJCCS28P/ht0GkmQnG+3GK0DAvT59T6hS3LwMCctEw=;
        b=asvKSkAWkbonrZE/qJNyS0IEnHUrzZ4Ox1ya+/42hSVCTl/5qvLVZ8G15Pq228pCr0
         41kGCCWCkVbvy8MedHo8zCNSqqP9BbeksUGXZAQMWE9kJ7BAzUpXGn1zUIqvx1LLhk7y
         Cirr9E/TEIdDRtRxflg4BkstYqgE3WKXQ42imxZaxFtnhFM8ujY+QzCWeRTYUEwIaLgI
         2xuGci653z9nrwWNiKYaRkpGfZ27UanxxR+VAZLRKNnHjF8KPxhlZnFmuHG9S4+YTw7b
         sIbmPbWpvu2tBG56PQq5HfJ+u04KOdN8oHBfy8RydDk3dR91QG9An6+RbrE1EvHc3cVw
         awQw==
X-Forwarded-Encrypted: i=1; AJvYcCVA4mcoyDJ9gJf9O/8Yef9cjypfMGfi6mko4zsvwqvu1w/zxaN8hsVnowW7nJXOsZCDMSzkq10=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3yPEYboV66A9RPwoS22oyd6Y539GJr9XHufTwM71TdrIH9IUN
	WZLn+ALSxHzWwNeImsSmjtRxjoJ1Y3S/ebAtTpta+4+Ht83PapFaD2+1LA3JS5ArlqeD7LK6Y8f
	7eMyFDL69HQsx55h7KjWJBV0Vgg==
X-Google-Smtp-Source: AGHT+IEAValjLvIQUTTrl0WGiv7qDA/VK+W0m1ZQUDRoDH/VSaq0CR37ZF/2z6Fxf5GRvTFbBupf/JJhqDdR5wa1WQ==
X-Received: from oabxc6.prod.google.com ([2002:a05:6870:ce06:b0:2e8:ed52:15c9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:7050:10b0:2ef:eddd:690d with SMTP id 586e51a60fabf-2efeddd6bf1mr119143fac.24.1750968354720;
 Thu, 26 Jun 2025 13:05:54 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:39 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-4-coltonlewis@google.com>
Subject: [PATCH v3 03/22] KVM: arm64: Define PMI{CNTR,FILTR}_EL0 as undef_access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Because KVM isn't fully prepared to support these yet even though the
host PMUv3 driver does, define them as undef_access for now.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..99fdbe174202 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3092,6 +3092,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
+	{ SYS_DESC(SYS_PMICNTR_EL0), undef_access },
+	{ SYS_DESC(SYS_PMICFILTR_EL0), undef_access },
+
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
 	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
-- 
2.50.0.727.gbf7dc18ff4-goog

