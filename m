Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1C8224228
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120609; cv=none; b=dRtjYg9E60dRmMeF1YwePh+4ROF5zy0VzaUJw+q8cBqu/jmFXF3ll/AZvVNi8JvuvoS7fArVgLuUVbi3WRvCl2XEW7JLCLYdrQGsncD21yojhEjtBpds7gb3YA7X1fVxMc6AxMAHs57fObIBJd1STvdLDcl5ZpyjGLVk+VsKrq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120609; c=relaxed/simple;
	bh=J8OmP1gsaCmehSiWudGGqnPNvN5TiSXtYIKG2wZEIRY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z7O/x9/L3mjxyK9+UrgyHFmWMrxZNE+Sz4/NA2iW7C9pe0mMwlL6NqDjZebffzG4yn9Z1/VONk79xMMfXbvGQQBt9RErWkdWsbyWCKk6DRuVx/v1XFojCBzXuZ5JOjjdfi5Zi4QwgsdD37WKUgQv9AK3GXfBEzdWj9Z2hY0zFzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t1/Iiifl; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t1/Iiifl"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a375888297so549511f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120605; x=1749725405; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WHbW2UQ+G7ko5zDPsKOZEBPKiZAxVSAKWEGcyVL84GY=;
        b=t1/IiiflAwUY7CZo5Jwg6sbuYagByKSeAQFEFfCklNhcDKIDyVuh2wHlEmmODfJTfI
         2Q9JjvFmzUkXmDJJWEwFLXSBHpqsTe52i6+XtJSEXqLSZttlljrVrHty6Tx+ZGVQaF8y
         YCeay5Rn15iiXOLR36rMtnrAtiRBhI73Fss5Ii/vZiJtArAfLtwAxCsluuQ4yn2T2Y/0
         GECCpRMvfF8GsyLAbxvfzaS7KYxpTFF4HUMgcbbyA9v0J8KN9SVvPQESxx9ODP2iufhz
         BMo/mbMmJznUS5H0ijTayh1Ijl6WdR1krCBt78vFAGSdGWKTkWvnVG1ADwWeREseFJH6
         mxkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120605; x=1749725405;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WHbW2UQ+G7ko5zDPsKOZEBPKiZAxVSAKWEGcyVL84GY=;
        b=Nda49N7rNxvBJuiKRavA8YfHd5YFczeobmHnN4X1QOFMiQAkmm+FcnGL1qGBH5S49p
         9BMY7GFb2Amm99vXg0Qr1I8rNBLqkzWMju5IgRoVGd78z68NMVHwjoN/wOWHSkm8+2t8
         cnSxjZpsEEhPMVMRRqmpRkteP2ShhFwhJqQErS8qjthN18im+xbSuoHCvNEZOmvp27D6
         lU6igH5ioViruB/GVge+ND6btHY//mTGHRua5cdQzksGew+HwB8mpWOTAY/OXFMeNV3C
         zJhvD4YtLmhX/hPe+gkJBc2iAfDLYQcJv9ZJche6XCHWv1w2pJLIm9iAj47qWN9AIUB8
         o7wg==
X-Forwarded-Encrypted: i=1; AJvYcCUgHPbqT5ntF6pNIGjTeHwtRyqduoBkzg6paxOgYKz9yW0eA4ISg4zLD2UfZFwIsfoRh2HjuQk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSrkF8PLpEVpVpjh6gakxgRV8SoLYMLSp6pKznaeBAybxli6hm
	qjDzm5c0ASAMkEmEk1zL+ISKSl0cr5MiCNUdU4ad3mGjBnp6kQ/pr566dctBtlwN3P0=
X-Gm-Gg: ASbGncsuK6AD/fUc/irFSYvnjggyZXQYiYDQ3QS2lzupBA3j7qr2mAgH+mCsHZdHUBW
	/MeDo9+LSR1f4rZflDtBk5jduLeNFoEiJApzWBfEDCvpQwIR5SAMyiHfXFhSZzEdp6UKWHC2BIz
	6P44HX9NTlQzcmtWw4Y7bew15x44a9hLAaUmvcHLFS1XhAnqMgEpp3jVNE4FipDgb5q8b9zRTTY
	HD7QwCq2AYEnz2IpU/5E24gdwWo2DhhM4HzhvEQ5IHwmiwW1JMyUNczxppGP3ef6Xo3XPwZLa48
	MNOeYr2MsJJAxMJNDFyKLan7OWjREmg14/WUEqynteYKziNZ8TQkRoFfwr4q
X-Google-Smtp-Source: AGHT+IFRWzZEtfMJIm7ANoPCr8nsDJf/OxJ3jlNOmnbV1HMLW3JnGbA0M2qGF1W+QvYQi0862CiYjA==
X-Received: by 2002:a05:6000:2485:b0:3a4:f70d:aff0 with SMTP id ffacd0b85a97d-3a526ddadedmr2646825f8f.14.1749120605010;
        Thu, 05 Jun 2025 03:50:05 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:04 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:00 +0100
Subject: [PATCH v3 02/10] perf: arm_spe: Support FEAT_SPEv1p4 filters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-2-71b0c9f98093@linaro.org>
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

FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
remove them from the previous version's RES0 bits using
PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.
E.g:

  E[30], bit [30]
  When FEAT_SPEv1p4 is _not_ implemented ...

FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
switch.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 drivers/perf/arm_spe_pmu.c      | 5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index f1bb0d10c39a..880090df3efc 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -358,6 +358,13 @@
 	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
 #define PMSEVFR_EL1_RES0_V1P2	\
 	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
+#define PMSEVFR_EL1_RES0_V1P4_EXCL \
+	(BIT_ULL(2) | BIT_ULL(4) | GENMASK_ULL(10, 8) | GENMASK_ULL(23, 19))
+#define PMSEVFR_EL1_RES0_V1P4_INCL \
+	(GENMASK_ULL(31, 26))
+#define PMSEVFR_EL1_RES0_V1P4	\
+	(PMSEVFR_EL1_RES0_V1P4_INCL | \
+	(PMSEVFR_EL1_RES0_V1P2 & ~PMSEVFR_EL1_RES0_V1P4_EXCL))
 
 /* Buffer error reporting */
 #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 3efed8839a4e..d9f6d229dce8 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -701,9 +701,12 @@ static u64 arm_spe_pmsevfr_res0(u16 pmsver)
 	case ID_AA64DFR0_EL1_PMSVer_V1P1:
 		return PMSEVFR_EL1_RES0_V1P1;
 	case ID_AA64DFR0_EL1_PMSVer_V1P2:
+	case ID_AA64DFR0_EL1_PMSVer_V1P3:
+		return PMSEVFR_EL1_RES0_V1P2;
+	case ID_AA64DFR0_EL1_PMSVer_V1P4:
 	/* Return the highest version we support in default */
 	default:
-		return PMSEVFR_EL1_RES0_V1P2;
+		return PMSEVFR_EL1_RES0_V1P4;
 	}
 }
 

-- 
2.34.1

