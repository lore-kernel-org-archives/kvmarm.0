Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC10422F14D
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120613; cv=none; b=LK3umhwEo5VZYyDE5L2DLgDo65cNG3t4/KDvz/z/meGNtm3xBeuGF8GGQJ5MPdPxhSLL2o1auR9P2Gw0AY96T2yaZeUWSRNQhKABATFfrrczs2u0HPkpV59KN3VCnlcI7pf8NSigJirMZaL02ty7KSKfUaxBwhpbs1bznM5Iy+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120613; c=relaxed/simple;
	bh=A8p4QmQp9wR2AXfusr2+sCtSzzwzACEYf3Bfr59fy6c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L6chTz9XLGEqZd8EmgXLJWkMqPtSvUqY8sOJo4ZWHBGdfPuq/29QAN11xGy3/eaM9micQ+8laqeu5qnXUUzWyaKk2sysk9Yd/cT/9cskuwkrtpRasUmLCtlUElhJh8WOrdR6HIAOAkLIuh5FY1ZL62egOLl0PgQ17X0OapgYrj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zv0VqBga; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zv0VqBga"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-451d54214adso6553005e9.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120608; x=1749725408; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJT+aMqYEQmL5PQmYJEFo4Ezn3ppsHm7b3c7sVHPycc=;
        b=zv0VqBgatk1hyF2f3XkqRxl0gtwqtFTebr3w3GK/EeY3VB0q35xj7Rn1Uglhi79CPb
         M6g4cTSG4laUaW5XkTftPavNr386Az0WJvmDBXdZcHgQc00PNNjh021X2k2IFrsnOF46
         OdclaVHrtz5JpmGKA8ibAznX4ZBnfAqiPDkfEb2RQ5QuqEtW2EsG3TrMkfSWq01HTR3A
         XdI9K9dJ74i+sAcTBmLpuj32vLF24PMTmifDms64xtkGGupgCenLlrPUQ15E+GOmkXsc
         Cmik+oqbeeYsD9MwDlyLNqnKoyxBG3Kxf1mIxgtTGvODNeGhH/X+pKb73JPir6bG88Zl
         cTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120608; x=1749725408;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJT+aMqYEQmL5PQmYJEFo4Ezn3ppsHm7b3c7sVHPycc=;
        b=lr0hGXoD4Eddq2BEIhycG8QxQXQ6z5EyVlUceyW5ZVC5KRmD5Buo8Qxu32BdkxwZWT
         skhmyJrdhH6zWDgylBgwX+lZwuwIN82OLNPpYKZuVxXA42+zUZYl1+6cjF99iWbPy62X
         fUSK5hdlDRGxQDxhahFYw6NJwV5AsNS5W/Rhxzi9UL0ZkllPJdRapBDbuV2iqX7anH30
         /omj8/uTRxdem6NDB4HhwrGx0xDRpp+CG4WBjMIySaWSbaaYlD3N0jIP/a2gJtIkTXrH
         5GeUVYFNEf4Yo/EqtcyPpsCwQy2+zAcXNHUyry4Y4QSx6Wes5mBTXZbJgzg2Xbqa6rqe
         P4xw==
X-Forwarded-Encrypted: i=1; AJvYcCVkhpqpPeQLm3aaAQ+bY5QTp/PZ1f8hkBnpSu+pkG5vRbg7L7Cngmp6fEID2G3T3wnw/lKVBH0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNFvOFtYdBv/KJURSnoooc/bFDIQhSC+JhsrW7Wf+id2vUSiEN
	WYYbT7uaiBL8JKVYZZ5/9xfvQOYTUgPIU/lFJXXKUE5CnEf99Ik4hJLAsgWhTk1YnyU=
X-Gm-Gg: ASbGncs8J9yCuTTmmDCj299/soQu4Z0y67h+bgapTF/0uVL7n97vkj26/sjZIVUSV4o
	o6MrH7FYdA6calYVGjkwKPyxXcxKoswJJuNgHcd5RP8uie03XxB4dIVhbk12et1kpzcDAXINVOT
	47K9+20AnG/ruqtvqmlxG/xkCdrGTd0w7Fvm4Sstf5Vwb/Ok1Fk7gRSJsDoa600E8XsItcT4njk
	T9kjGJ/Lg/ogmg9pa3YIK/1sPbeuKijCWNAFO2N/klKbWyLtFuL0c+CZgwTGctS2k8V5Gn2idOG
	AI1lgbqerY/CoHHUInm5+JQENwMqm0AhXmRhmGOIg5/QUW4bMl+8zYnXucx6BcEWRYTAjgg=
X-Google-Smtp-Source: AGHT+IEIHZpq8QHSEooXwNXyVEvqtUmnqaRzbft3GX1X+wZQal8zl6fwpJ0RAE4/3G1qpRtDL/8FwA==
X-Received: by 2002:a05:600c:310e:b0:44a:ac77:26d5 with SMTP id 5b1f17b1804b1-451f0a7c518mr63230645e9.14.1749120607969;
        Thu, 05 Jun 2025 03:50:07 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:07 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:02 +0100
Subject: [PATCH v3 04/10] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-4-71b0c9f98093@linaro.org>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

SPE data source filtering (optional from Armv8.8) requires that traps to
the filter register PMSDSFR be disabled. Document the requirements and
disable the traps if the feature is present.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 Documentation/arch/arm64/booting.rst | 11 +++++++++++
 arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index dee7b6de864f..abd75085a239 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
     - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
     - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
 
+  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
+
+  - If EL3 is present:
+
+    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
+
   For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
 
   - If the kernel is entered at EL1 and EL2 is present:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 1e7c7475e43f..02b4a7fc016e 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -279,6 +279,20 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
 .Lskip_pmuv3p9_\@:
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
+	/* If SPE is implemented, */
+	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
+	b.lt	.Lskip_spefds_\@
+	/* we can read PMSIDR and */
+	mrs_s	x1, SYS_PMSIDR_EL1
+	and	x1, x1,  #PMSIDR_EL1_FDS
+	/* if FEAT_SPE_FDS is implemented, */
+	cbz	x1, .Lskip_spefds_\@
+	/* disable traps to PMSDSFR. */
+	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
+
+.Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x0
 	msr_s   SYS_HFGRTR2_EL2, xzr

-- 
2.34.1

