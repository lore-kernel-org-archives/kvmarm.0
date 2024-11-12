Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4272822B396
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407867; cv=none; b=p5xYtSwvNpho2rr6Fw8atBkfDMuruYATJ2NoUZ9vtSRWwOkHKRafRBremoZ2R3pytIGIFkT1hLjKGBqVOpXao0oQs5TW4juiKSJzfkKuUAoP2xtbxbNJNOe4V4mXQH2iRqDxb33EZEmKch6HPPXZl1mD17+3TpFHuWszIUolS50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407867; c=relaxed/simple;
	bh=bW78dTWX9Qdb7v4q4NxHdr2HgNtnEWktMrCmjJq8Vas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GIyLRQJO/O9R9OGR882e+CbEmfJ/AyLxCzl4Yp7UubsnJqvi43b4zN9dNxXAeNumkbkk59qPJvxzfHM8ees3grX0Pwqu/ogRz4w95nsy/BGq2MxK1HCfkAKGZuq9vfZ432tA7UMKGuH1urGq2iCNQlXgJHW/fFpy7k3MqlkV9js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fn/esx2J; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fn/esx2J"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4316a44d1bbso45484205e9.3
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407863; x=1732012663; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTySTtAsqRGnf147MrhkPg4Yh5sLBUeHvDRhHluNO/0=;
        b=fn/esx2JL6hDYVPfEK0DEwK9ADPTu0iB9UtLM25OtbRDKwRH45B9N5nW3Lc8vv+xl0
         U6a0TiRa0u4Y8OEBCCZLZwDp/yyMyLOZJQDx5ppZqhfkpzK+GIbyfrSKl5nRNAXqa0Qn
         KQ3xvQHtH66s4tvmMVf128awngeRLOvTH7TtVP7IzD+X3OOPh/oBBvCUDg84oiucKAJH
         4vR1MuPhAEe1+CWg4XMWXF60n83tWIyKMnttoqFGgVKhbB8JANlNt7OS7LZjliD347pu
         k9GRu5M9b49YoT5nAx688dPhXLh3W0Ys5NAYZC6l1QcV5m/POybiA/8P++0jJ0ueWzRN
         keBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407863; x=1732012663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FTySTtAsqRGnf147MrhkPg4Yh5sLBUeHvDRhHluNO/0=;
        b=JrryfY7f14170po8RanmclsqUf6dhCnqsTz/8i9lfOQiOZi8dNWrU63NfVGQe74XiS
         dW6MLHNPDebtBKOn5jRCOgb+MuTuYFV++szo0kcA3MLDDTsaxgLslZT3YxY6O8XrgXgr
         v2qY7U42IxF05DDnJaAVQfq4IObGXTNsFcd03SdLd0RKbO4VSRjc+7gIRZd9i7MZqM6z
         TfMB4bfGRwAKHIfjal9bitEg47TMoURN+DN7bEBNOCLrcreN36Hd5ccbkupHlsaCj0YT
         mfy2GKljjMJ+BWYnkbtlgLTNBRrw+hQTVD/1YBatku/GHkNKES2vJYQLtoJjkiWw7Dav
         XyUA==
X-Forwarded-Encrypted: i=1; AJvYcCXWe6IszN4Mp/ADGD4IFn3oxYwRw2fLKOl6tQ18emvpA2VkBc+ibfufHLZyg89aSrxq6cp3QYE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUoDx6bYEruXeA0ibYZpdQkajgRQGkSeLOih7CipvFaH61TUSl
	gR0fdAWAtoRv/2l7732HbKov/9yEvi2BEws3sYYoOAsYOshGlNgL8ZvsE1/NJXE=
X-Google-Smtp-Source: AGHT+IG3AoajTzlMTh78KdXie6xiKiy9y1tlxJvV6HKuAEEgWLas977mJIXVOTovDOUvWczXHedD1g==
X-Received: by 2002:a05:600c:354c:b0:42c:acb0:ddbd with SMTP id 5b1f17b1804b1-432b74fd80fmr132067245e9.7.1731407863433;
        Tue, 12 Nov 2024 02:37:43 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:37:42 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	coresight@lists.linaro.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 02/12] tools: arm64: Update sysreg.h header files
Date: Tue, 12 Nov 2024 10:37:01 +0000
Message-Id: <20241112103717.589952-3-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112103717.589952-1-james.clark@linaro.org>
References: <20241112103717.589952-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

Created with the following:

  cp include/linux/kasan-tags.h tools/include/linux/
  cp arch/arm64/include/asm/sysreg.h tools/arch/arm64/include/asm/

Update the tools copy of sysreg.h so that the next commit to add a new
register doesn't have unrelated changes in it. Because the new version
of sysreg.h includes kasan-tags.h, that file also now needs to be copied
into tools.

Acked-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 tools/arch/arm64/include/asm/sysreg.h | 398 +++++++++++++++++++++++++-
 tools/include/linux/kasan-tags.h      |  15 +
 2 files changed, 405 insertions(+), 8 deletions(-)
 create mode 100644 tools/include/linux/kasan-tags.h

diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index cd8420e8c3ad..345e81e0d2b3 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -11,6 +11,7 @@
 
 #include <linux/bits.h>
 #include <linux/stringify.h>
+#include <linux/kasan-tags.h>
 
 #include <asm/gpr-num.h>
 
@@ -108,6 +109,9 @@
 #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
 #define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
 
+/* Register-based PAN access, for save/restore purposes */
+#define SYS_PSTATE_PAN			sys_reg(3, 0, 4, 2, 3)
+
 #define __SYS_BARRIER_INSN(CRm, op2, Rt) \
 	__emit_inst(0xd5000000 | sys_insn(0, 3, 3, (CRm), (op2)) | ((Rt) & 0x1f))
 
@@ -123,6 +127,37 @@
 #define SYS_DC_CIGSW			sys_insn(1, 0, 7, 14, 4)
 #define SYS_DC_CIGDSW			sys_insn(1, 0, 7, 14, 6)
 
+#define SYS_IC_IALLUIS			sys_insn(1, 0, 7, 1, 0)
+#define SYS_IC_IALLU			sys_insn(1, 0, 7, 5, 0)
+#define SYS_IC_IVAU			sys_insn(1, 3, 7, 5, 1)
+
+#define SYS_DC_IVAC			sys_insn(1, 0, 7, 6, 1)
+#define SYS_DC_IGVAC			sys_insn(1, 0, 7, 6, 3)
+#define SYS_DC_IGDVAC			sys_insn(1, 0, 7, 6, 5)
+
+#define SYS_DC_CVAC			sys_insn(1, 3, 7, 10, 1)
+#define SYS_DC_CGVAC			sys_insn(1, 3, 7, 10, 3)
+#define SYS_DC_CGDVAC			sys_insn(1, 3, 7, 10, 5)
+
+#define SYS_DC_CVAU			sys_insn(1, 3, 7, 11, 1)
+
+#define SYS_DC_CVAP			sys_insn(1, 3, 7, 12, 1)
+#define SYS_DC_CGVAP			sys_insn(1, 3, 7, 12, 3)
+#define SYS_DC_CGDVAP			sys_insn(1, 3, 7, 12, 5)
+
+#define SYS_DC_CVADP			sys_insn(1, 3, 7, 13, 1)
+#define SYS_DC_CGVADP			sys_insn(1, 3, 7, 13, 3)
+#define SYS_DC_CGDVADP			sys_insn(1, 3, 7, 13, 5)
+
+#define SYS_DC_CIVAC			sys_insn(1, 3, 7, 14, 1)
+#define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
+#define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
+
+/* Data cache zero operations */
+#define SYS_DC_ZVA			sys_insn(1, 3, 7, 4, 1)
+#define SYS_DC_GVA			sys_insn(1, 3, 7, 4, 3)
+#define SYS_DC_GZVA			sys_insn(1, 3, 7, 4, 4)
+
 /*
  * Automatically generated definitions for system registers, the
  * manual encodings below are in the process of being converted to
@@ -162,6 +197,84 @@
 #define SYS_DBGDTRTX_EL0		sys_reg(2, 3, 0, 5, 0)
 #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)
 
+#define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 0))
+#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)
+#define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 1))
+#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)
+#define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 2))
+#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)
+#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)
+
+#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)
+#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)
+#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)
+
+#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
+#define SYS_TRCACATR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (2 | (m >> 3)))
+#define SYS_TRCACVR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (0 | (m >> 3)))
+#define SYS_TRCAUTHSTATUS		sys_reg(2, 1, 7, 14, 6)
+#define SYS_TRCAUXCTLR			sys_reg(2, 1, 0, 6, 0)
+#define SYS_TRCBBCTLR			sys_reg(2, 1, 0, 15, 0)
+#define SYS_TRCCCCTLR			sys_reg(2, 1, 0, 14, 0)
+#define SYS_TRCCIDCCTLR0		sys_reg(2, 1, 3, 0, 2)
+#define SYS_TRCCIDCCTLR1		sys_reg(2, 1, 3, 1, 2)
+#define SYS_TRCCIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 0)
+#define SYS_TRCCLAIMCLR			sys_reg(2, 1, 7, 9, 6)
+#define SYS_TRCCLAIMSET			sys_reg(2, 1, 7, 8, 6)
+#define SYS_TRCCNTCTLR(m)		sys_reg(2, 1, 0, (4 | (m & 3)), 5)
+#define SYS_TRCCNTRLDVR(m)		sys_reg(2, 1, 0, (0 | (m & 3)), 5)
+#define SYS_TRCCNTVR(m)			sys_reg(2, 1, 0, (8 | (m & 3)), 5)
+#define SYS_TRCCONFIGR			sys_reg(2, 1, 0, 4, 0)
+#define SYS_TRCDEVARCH			sys_reg(2, 1, 7, 15, 6)
+#define SYS_TRCDEVID			sys_reg(2, 1, 7, 2, 7)
+#define SYS_TRCEVENTCTL0R		sys_reg(2, 1, 0, 8, 0)
+#define SYS_TRCEVENTCTL1R		sys_reg(2, 1, 0, 9, 0)
+#define SYS_TRCEXTINSELR(m)		sys_reg(2, 1, 0, (8 | (m & 3)), 4)
+#define SYS_TRCIDR0			sys_reg(2, 1, 0, 8, 7)
+#define SYS_TRCIDR10			sys_reg(2, 1, 0, 2, 6)
+#define SYS_TRCIDR11			sys_reg(2, 1, 0, 3, 6)
+#define SYS_TRCIDR12			sys_reg(2, 1, 0, 4, 6)
+#define SYS_TRCIDR13			sys_reg(2, 1, 0, 5, 6)
+#define SYS_TRCIDR1			sys_reg(2, 1, 0, 9, 7)
+#define SYS_TRCIDR2			sys_reg(2, 1, 0, 10, 7)
+#define SYS_TRCIDR3			sys_reg(2, 1, 0, 11, 7)
+#define SYS_TRCIDR4			sys_reg(2, 1, 0, 12, 7)
+#define SYS_TRCIDR5			sys_reg(2, 1, 0, 13, 7)
+#define SYS_TRCIDR6			sys_reg(2, 1, 0, 14, 7)
+#define SYS_TRCIDR7			sys_reg(2, 1, 0, 15, 7)
+#define SYS_TRCIDR8			sys_reg(2, 1, 0, 0, 6)
+#define SYS_TRCIDR9			sys_reg(2, 1, 0, 1, 6)
+#define SYS_TRCIMSPEC(m)		sys_reg(2, 1, 0, (m & 7), 7)
+#define SYS_TRCITEEDCR			sys_reg(2, 1, 0, 2, 1)
+#define SYS_TRCOSLSR			sys_reg(2, 1, 1, 1, 4)
+#define SYS_TRCPRGCTLR			sys_reg(2, 1, 0, 1, 0)
+#define SYS_TRCQCTLR			sys_reg(2, 1, 0, 1, 1)
+#define SYS_TRCRSCTLR(m)		sys_reg(2, 1, 1, (m & 15), (0 | (m >> 4)))
+#define SYS_TRCRSR			sys_reg(2, 1, 0, 10, 0)
+#define SYS_TRCSEQEVR(m)		sys_reg(2, 1, 0, (m & 3), 4)
+#define SYS_TRCSEQRSTEVR		sys_reg(2, 1, 0, 6, 4)
+#define SYS_TRCSEQSTR			sys_reg(2, 1, 0, 7, 4)
+#define SYS_TRCSSCCR(m)			sys_reg(2, 1, 1, (m & 7), 2)
+#define SYS_TRCSSCSR(m)			sys_reg(2, 1, 1, (8 | (m & 7)), 2)
+#define SYS_TRCSSPCICR(m)		sys_reg(2, 1, 1, (m & 7), 3)
+#define SYS_TRCSTALLCTLR		sys_reg(2, 1, 0, 11, 0)
+#define SYS_TRCSTATR			sys_reg(2, 1, 0, 3, 0)
+#define SYS_TRCSYNCPR			sys_reg(2, 1, 0, 13, 0)
+#define SYS_TRCTRACEIDR			sys_reg(2, 1, 0, 0, 1)
+#define SYS_TRCTSCTLR			sys_reg(2, 1, 0, 12, 0)
+#define SYS_TRCVICTLR			sys_reg(2, 1, 0, 0, 2)
+#define SYS_TRCVIIECTLR			sys_reg(2, 1, 0, 1, 2)
+#define SYS_TRCVIPCSSCTLR		sys_reg(2, 1, 0, 3, 2)
+#define SYS_TRCVISSCTLR			sys_reg(2, 1, 0, 2, 2)
+#define SYS_TRCVMIDCCTLR0		sys_reg(2, 1, 3, 2, 2)
+#define SYS_TRCVMIDCCTLR1		sys_reg(2, 1, 3, 3, 2)
+#define SYS_TRCVMIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 1)
+
+/* ETM */
+#define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
+
+#define SYS_BRBCR_EL2			sys_reg(2, 4, 9, 0, 0)
+
 #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
 #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
 #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
@@ -202,15 +315,38 @@
 #define SYS_ERXCTLR_EL1			sys_reg(3, 0, 5, 4, 1)
 #define SYS_ERXSTATUS_EL1		sys_reg(3, 0, 5, 4, 2)
 #define SYS_ERXADDR_EL1			sys_reg(3, 0, 5, 4, 3)
+#define SYS_ERXPFGF_EL1			sys_reg(3, 0, 5, 4, 4)
+#define SYS_ERXPFGCTL_EL1		sys_reg(3, 0, 5, 4, 5)
+#define SYS_ERXPFGCDN_EL1		sys_reg(3, 0, 5, 4, 6)
 #define SYS_ERXMISC0_EL1		sys_reg(3, 0, 5, 5, 0)
 #define SYS_ERXMISC1_EL1		sys_reg(3, 0, 5, 5, 1)
+#define SYS_ERXMISC2_EL1		sys_reg(3, 0, 5, 5, 2)
+#define SYS_ERXMISC3_EL1		sys_reg(3, 0, 5, 5, 3)
 #define SYS_TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
 #define SYS_TFSRE0_EL1			sys_reg(3, 0, 5, 6, 1)
 
 #define SYS_PAR_EL1			sys_reg(3, 0, 7, 4, 0)
 
 #define SYS_PAR_EL1_F			BIT(0)
+/* When PAR_EL1.F == 1 */
 #define SYS_PAR_EL1_FST			GENMASK(6, 1)
+#define SYS_PAR_EL1_PTW			BIT(8)
+#define SYS_PAR_EL1_S			BIT(9)
+#define SYS_PAR_EL1_AssuredOnly		BIT(12)
+#define SYS_PAR_EL1_TopLevel		BIT(13)
+#define SYS_PAR_EL1_Overlay		BIT(14)
+#define SYS_PAR_EL1_DirtyBit		BIT(15)
+#define SYS_PAR_EL1_F1_IMPDEF		GENMASK_ULL(63, 48)
+#define SYS_PAR_EL1_F1_RES0		(BIT(7) | BIT(10) | GENMASK_ULL(47, 16))
+#define SYS_PAR_EL1_RES1		BIT(11)
+/* When PAR_EL1.F == 0 */
+#define SYS_PAR_EL1_SH			GENMASK_ULL(8, 7)
+#define SYS_PAR_EL1_NS			BIT(9)
+#define SYS_PAR_EL1_F0_IMPDEF		BIT(10)
+#define SYS_PAR_EL1_NSE			BIT(11)
+#define SYS_PAR_EL1_PA			GENMASK_ULL(51, 12)
+#define SYS_PAR_EL1_ATTR		GENMASK_ULL(63, 56)
+#define SYS_PAR_EL1_F0_RES0		(GENMASK_ULL(6, 1) | GENMASK_ULL(55, 52))
 
 /*** Statistical Profiling Extension ***/
 #define PMSEVFR_EL1_RES0_IMP	\
@@ -274,6 +410,8 @@
 #define SYS_ICC_IGRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
 #define SYS_ICC_IGRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
+#define SYS_ACCDATA_EL1			sys_reg(3, 0, 13, 0, 5)
+
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
 #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
@@ -286,7 +424,6 @@
 #define SYS_PMCNTENCLR_EL0		sys_reg(3, 3, 9, 12, 2)
 #define SYS_PMOVSCLR_EL0		sys_reg(3, 3, 9, 12, 3)
 #define SYS_PMSWINC_EL0			sys_reg(3, 3, 9, 12, 4)
-#define SYS_PMSELR_EL0			sys_reg(3, 3, 9, 12, 5)
 #define SYS_PMCEID0_EL0			sys_reg(3, 3, 9, 12, 6)
 #define SYS_PMCEID1_EL0			sys_reg(3, 3, 9, 12, 7)
 #define SYS_PMCCNTR_EL0			sys_reg(3, 3, 9, 13, 0)
@@ -369,6 +506,7 @@
 
 #define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
 #define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
+#define SYS_SCTLR2_EL2			sys_reg(3, 4, 1, 0, 3)
 #define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
 #define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
 #define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
@@ -382,12 +520,15 @@
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
-#define SYS_HDFGRTR_EL2			sys_reg(3, 4, 3, 1, 4)
-#define SYS_HDFGWTR_EL2			sys_reg(3, 4, 3, 1, 5)
+#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
 #define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
+#define SYS_SPSR_irq			sys_reg(3, 4, 4, 3, 0)
+#define SYS_SPSR_abt			sys_reg(3, 4, 4, 3, 1)
+#define SYS_SPSR_und			sys_reg(3, 4, 4, 3, 2)
+#define SYS_SPSR_fiq			sys_reg(3, 4, 4, 3, 3)
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
 #define SYS_AFSR0_EL2			sys_reg(3, 4, 5, 1, 0)
 #define SYS_AFSR1_EL2			sys_reg(3, 4, 5, 1, 1)
@@ -449,24 +590,49 @@
 
 #define SYS_CONTEXTIDR_EL2		sys_reg(3, 4, 13, 0, 1)
 #define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
+#define SYS_SCXTNUM_EL2			sys_reg(3, 4, 13, 0, 7)
+
+#define __AMEV_op2(m)			(m & 0x7)
+#define __AMEV_CRm(n, m)		(n | ((m & 0x8) >> 3))
+#define __SYS__AMEVCNTVOFF0n_EL2(m)	sys_reg(3, 4, 13, __AMEV_CRm(0x8, m), __AMEV_op2(m))
+#define SYS_AMEVCNTVOFF0n_EL2(m)	__SYS__AMEVCNTVOFF0n_EL2(m)
+#define __SYS__AMEVCNTVOFF1n_EL2(m)	sys_reg(3, 4, 13, __AMEV_CRm(0xA, m), __AMEV_op2(m))
+#define SYS_AMEVCNTVOFF1n_EL2(m)	__SYS__AMEVCNTVOFF1n_EL2(m)
 
 #define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
 #define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
+#define SYS_CNTHP_TVAL_EL2		sys_reg(3, 4, 14, 2, 0)
+#define SYS_CNTHP_CTL_EL2		sys_reg(3, 4, 14, 2, 1)
+#define SYS_CNTHP_CVAL_EL2		sys_reg(3, 4, 14, 2, 2)
+#define SYS_CNTHV_TVAL_EL2		sys_reg(3, 4, 14, 3, 0)
+#define SYS_CNTHV_CTL_EL2		sys_reg(3, 4, 14, 3, 1)
+#define SYS_CNTHV_CVAL_EL2		sys_reg(3, 4, 14, 3, 2)
 
 /* VHE encodings for architectural EL0/1 system registers */
+#define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
 #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
+#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
+#define SYS_SCTLR2_EL12			sys_reg(3, 5, 1, 0, 3)
+#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
+#define SYS_TRFCR_EL12			sys_reg(3, 5, 1, 2, 1)
+#define SYS_SMCR_EL12			sys_reg(3, 5, 1, 2, 6)
 #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
 #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
 #define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
+#define SYS_TCR2_EL12			sys_reg(3, 5, 2, 0, 3)
 #define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
 #define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
 #define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
 #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
 #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
 #define SYS_TFSR_EL12			sys_reg(3, 5, 5, 6, 0)
+#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
+#define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)
 #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
 #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
 #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
+#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
+#define SYS_SCXTNUM_EL12		sys_reg(3, 5, 13, 0, 7)
 #define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
 #define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
 #define SYS_CNTP_CTL_EL02		sys_reg(3, 5, 14, 2, 1)
@@ -477,6 +643,183 @@
 
 #define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
 
+/* AT instructions */
+#define AT_Op0 1
+#define AT_CRn 7
+
+#define OP_AT_S1E1R	sys_insn(AT_Op0, 0, AT_CRn, 8, 0)
+#define OP_AT_S1E1W	sys_insn(AT_Op0, 0, AT_CRn, 8, 1)
+#define OP_AT_S1E0R	sys_insn(AT_Op0, 0, AT_CRn, 8, 2)
+#define OP_AT_S1E0W	sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
+#define OP_AT_S1E1RP	sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
+#define OP_AT_S1E1WP	sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
+#define OP_AT_S1E1A	sys_insn(AT_Op0, 0, AT_CRn, 9, 2)
+#define OP_AT_S1E2R	sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
+#define OP_AT_S1E2W	sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
+#define OP_AT_S12E1R	sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
+#define OP_AT_S12E1W	sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
+#define OP_AT_S12E0R	sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
+#define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
+#define OP_AT_S1E2A	sys_insn(AT_Op0, 4, AT_CRn, 9, 2)
+
+/* TLBI instructions */
+#define TLBI_Op0	1
+
+#define TLBI_Op1_EL1	0	/* Accessible from EL1 or higher */
+#define TLBI_Op1_EL2	4	/* Accessible from EL2 or higher */
+
+#define TLBI_CRn_XS	8	/* Extra Slow (the common one) */
+#define TLBI_CRn_nXS	9	/* not Extra Slow (which nobody uses)*/
+
+#define TLBI_CRm_IPAIS	0	/* S2 Inner-Shareable */
+#define TLBI_CRm_nROS	1	/* non-Range, Outer-Sharable */
+#define TLBI_CRm_RIS	2	/* Range, Inner-Sharable */
+#define TLBI_CRm_nRIS	3	/* non-Range, Inner-Sharable */
+#define TLBI_CRm_IPAONS	4	/* S2 Outer and Non-Shareable */
+#define TLBI_CRm_ROS	5	/* Range, Outer-Sharable */
+#define TLBI_CRm_RNS	6	/* Range, Non-Sharable */
+#define TLBI_CRm_nRNS	7	/* non-Range, Non-Sharable */
+
+#define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
+#define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)
+#define OP_TLBI_ASIDE1OS		sys_insn(1, 0, 8, 1, 2)
+#define OP_TLBI_VAAE1OS			sys_insn(1, 0, 8, 1, 3)
+#define OP_TLBI_VALE1OS			sys_insn(1, 0, 8, 1, 5)
+#define OP_TLBI_VAALE1OS		sys_insn(1, 0, 8, 1, 7)
+#define OP_TLBI_RVAE1IS			sys_insn(1, 0, 8, 2, 1)
+#define OP_TLBI_RVAAE1IS		sys_insn(1, 0, 8, 2, 3)
+#define OP_TLBI_RVALE1IS		sys_insn(1, 0, 8, 2, 5)
+#define OP_TLBI_RVAALE1IS		sys_insn(1, 0, 8, 2, 7)
+#define OP_TLBI_VMALLE1IS		sys_insn(1, 0, 8, 3, 0)
+#define OP_TLBI_VAE1IS			sys_insn(1, 0, 8, 3, 1)
+#define OP_TLBI_ASIDE1IS		sys_insn(1, 0, 8, 3, 2)
+#define OP_TLBI_VAAE1IS			sys_insn(1, 0, 8, 3, 3)
+#define OP_TLBI_VALE1IS			sys_insn(1, 0, 8, 3, 5)
+#define OP_TLBI_VAALE1IS		sys_insn(1, 0, 8, 3, 7)
+#define OP_TLBI_RVAE1OS			sys_insn(1, 0, 8, 5, 1)
+#define OP_TLBI_RVAAE1OS		sys_insn(1, 0, 8, 5, 3)
+#define OP_TLBI_RVALE1OS		sys_insn(1, 0, 8, 5, 5)
+#define OP_TLBI_RVAALE1OS		sys_insn(1, 0, 8, 5, 7)
+#define OP_TLBI_RVAE1			sys_insn(1, 0, 8, 6, 1)
+#define OP_TLBI_RVAAE1			sys_insn(1, 0, 8, 6, 3)
+#define OP_TLBI_RVALE1			sys_insn(1, 0, 8, 6, 5)
+#define OP_TLBI_RVAALE1			sys_insn(1, 0, 8, 6, 7)
+#define OP_TLBI_VMALLE1			sys_insn(1, 0, 8, 7, 0)
+#define OP_TLBI_VAE1			sys_insn(1, 0, 8, 7, 1)
+#define OP_TLBI_ASIDE1			sys_insn(1, 0, 8, 7, 2)
+#define OP_TLBI_VAAE1			sys_insn(1, 0, 8, 7, 3)
+#define OP_TLBI_VALE1			sys_insn(1, 0, 8, 7, 5)
+#define OP_TLBI_VAALE1			sys_insn(1, 0, 8, 7, 7)
+#define OP_TLBI_VMALLE1OSNXS		sys_insn(1, 0, 9, 1, 0)
+#define OP_TLBI_VAE1OSNXS		sys_insn(1, 0, 9, 1, 1)
+#define OP_TLBI_ASIDE1OSNXS		sys_insn(1, 0, 9, 1, 2)
+#define OP_TLBI_VAAE1OSNXS		sys_insn(1, 0, 9, 1, 3)
+#define OP_TLBI_VALE1OSNXS		sys_insn(1, 0, 9, 1, 5)
+#define OP_TLBI_VAALE1OSNXS		sys_insn(1, 0, 9, 1, 7)
+#define OP_TLBI_RVAE1ISNXS		sys_insn(1, 0, 9, 2, 1)
+#define OP_TLBI_RVAAE1ISNXS		sys_insn(1, 0, 9, 2, 3)
+#define OP_TLBI_RVALE1ISNXS		sys_insn(1, 0, 9, 2, 5)
+#define OP_TLBI_RVAALE1ISNXS		sys_insn(1, 0, 9, 2, 7)
+#define OP_TLBI_VMALLE1ISNXS		sys_insn(1, 0, 9, 3, 0)
+#define OP_TLBI_VAE1ISNXS		sys_insn(1, 0, 9, 3, 1)
+#define OP_TLBI_ASIDE1ISNXS		sys_insn(1, 0, 9, 3, 2)
+#define OP_TLBI_VAAE1ISNXS		sys_insn(1, 0, 9, 3, 3)
+#define OP_TLBI_VALE1ISNXS		sys_insn(1, 0, 9, 3, 5)
+#define OP_TLBI_VAALE1ISNXS		sys_insn(1, 0, 9, 3, 7)
+#define OP_TLBI_RVAE1OSNXS		sys_insn(1, 0, 9, 5, 1)
+#define OP_TLBI_RVAAE1OSNXS		sys_insn(1, 0, 9, 5, 3)
+#define OP_TLBI_RVALE1OSNXS		sys_insn(1, 0, 9, 5, 5)
+#define OP_TLBI_RVAALE1OSNXS		sys_insn(1, 0, 9, 5, 7)
+#define OP_TLBI_RVAE1NXS		sys_insn(1, 0, 9, 6, 1)
+#define OP_TLBI_RVAAE1NXS		sys_insn(1, 0, 9, 6, 3)
+#define OP_TLBI_RVALE1NXS		sys_insn(1, 0, 9, 6, 5)
+#define OP_TLBI_RVAALE1NXS		sys_insn(1, 0, 9, 6, 7)
+#define OP_TLBI_VMALLE1NXS		sys_insn(1, 0, 9, 7, 0)
+#define OP_TLBI_VAE1NXS			sys_insn(1, 0, 9, 7, 1)
+#define OP_TLBI_ASIDE1NXS		sys_insn(1, 0, 9, 7, 2)
+#define OP_TLBI_VAAE1NXS		sys_insn(1, 0, 9, 7, 3)
+#define OP_TLBI_VALE1NXS		sys_insn(1, 0, 9, 7, 5)
+#define OP_TLBI_VAALE1NXS		sys_insn(1, 0, 9, 7, 7)
+#define OP_TLBI_IPAS2E1IS		sys_insn(1, 4, 8, 0, 1)
+#define OP_TLBI_RIPAS2E1IS		sys_insn(1, 4, 8, 0, 2)
+#define OP_TLBI_IPAS2LE1IS		sys_insn(1, 4, 8, 0, 5)
+#define OP_TLBI_RIPAS2LE1IS		sys_insn(1, 4, 8, 0, 6)
+#define OP_TLBI_ALLE2OS			sys_insn(1, 4, 8, 1, 0)
+#define OP_TLBI_VAE2OS			sys_insn(1, 4, 8, 1, 1)
+#define OP_TLBI_ALLE1OS			sys_insn(1, 4, 8, 1, 4)
+#define OP_TLBI_VALE2OS			sys_insn(1, 4, 8, 1, 5)
+#define OP_TLBI_VMALLS12E1OS		sys_insn(1, 4, 8, 1, 6)
+#define OP_TLBI_RVAE2IS			sys_insn(1, 4, 8, 2, 1)
+#define OP_TLBI_RVALE2IS		sys_insn(1, 4, 8, 2, 5)
+#define OP_TLBI_ALLE2IS			sys_insn(1, 4, 8, 3, 0)
+#define OP_TLBI_VAE2IS			sys_insn(1, 4, 8, 3, 1)
+#define OP_TLBI_ALLE1IS			sys_insn(1, 4, 8, 3, 4)
+#define OP_TLBI_VALE2IS			sys_insn(1, 4, 8, 3, 5)
+#define OP_TLBI_VMALLS12E1IS		sys_insn(1, 4, 8, 3, 6)
+#define OP_TLBI_IPAS2E1OS		sys_insn(1, 4, 8, 4, 0)
+#define OP_TLBI_IPAS2E1			sys_insn(1, 4, 8, 4, 1)
+#define OP_TLBI_RIPAS2E1		sys_insn(1, 4, 8, 4, 2)
+#define OP_TLBI_RIPAS2E1OS		sys_insn(1, 4, 8, 4, 3)
+#define OP_TLBI_IPAS2LE1OS		sys_insn(1, 4, 8, 4, 4)
+#define OP_TLBI_IPAS2LE1		sys_insn(1, 4, 8, 4, 5)
+#define OP_TLBI_RIPAS2LE1		sys_insn(1, 4, 8, 4, 6)
+#define OP_TLBI_RIPAS2LE1OS		sys_insn(1, 4, 8, 4, 7)
+#define OP_TLBI_RVAE2OS			sys_insn(1, 4, 8, 5, 1)
+#define OP_TLBI_RVALE2OS		sys_insn(1, 4, 8, 5, 5)
+#define OP_TLBI_RVAE2			sys_insn(1, 4, 8, 6, 1)
+#define OP_TLBI_RVALE2			sys_insn(1, 4, 8, 6, 5)
+#define OP_TLBI_ALLE2			sys_insn(1, 4, 8, 7, 0)
+#define OP_TLBI_VAE2			sys_insn(1, 4, 8, 7, 1)
+#define OP_TLBI_ALLE1			sys_insn(1, 4, 8, 7, 4)
+#define OP_TLBI_VALE2			sys_insn(1, 4, 8, 7, 5)
+#define OP_TLBI_VMALLS12E1		sys_insn(1, 4, 8, 7, 6)
+#define OP_TLBI_IPAS2E1ISNXS		sys_insn(1, 4, 9, 0, 1)
+#define OP_TLBI_RIPAS2E1ISNXS		sys_insn(1, 4, 9, 0, 2)
+#define OP_TLBI_IPAS2LE1ISNXS		sys_insn(1, 4, 9, 0, 5)
+#define OP_TLBI_RIPAS2LE1ISNXS		sys_insn(1, 4, 9, 0, 6)
+#define OP_TLBI_ALLE2OSNXS		sys_insn(1, 4, 9, 1, 0)
+#define OP_TLBI_VAE2OSNXS		sys_insn(1, 4, 9, 1, 1)
+#define OP_TLBI_ALLE1OSNXS		sys_insn(1, 4, 9, 1, 4)
+#define OP_TLBI_VALE2OSNXS		sys_insn(1, 4, 9, 1, 5)
+#define OP_TLBI_VMALLS12E1OSNXS		sys_insn(1, 4, 9, 1, 6)
+#define OP_TLBI_RVAE2ISNXS		sys_insn(1, 4, 9, 2, 1)
+#define OP_TLBI_RVALE2ISNXS		sys_insn(1, 4, 9, 2, 5)
+#define OP_TLBI_ALLE2ISNXS		sys_insn(1, 4, 9, 3, 0)
+#define OP_TLBI_VAE2ISNXS		sys_insn(1, 4, 9, 3, 1)
+#define OP_TLBI_ALLE1ISNXS		sys_insn(1, 4, 9, 3, 4)
+#define OP_TLBI_VALE2ISNXS		sys_insn(1, 4, 9, 3, 5)
+#define OP_TLBI_VMALLS12E1ISNXS		sys_insn(1, 4, 9, 3, 6)
+#define OP_TLBI_IPAS2E1OSNXS		sys_insn(1, 4, 9, 4, 0)
+#define OP_TLBI_IPAS2E1NXS		sys_insn(1, 4, 9, 4, 1)
+#define OP_TLBI_RIPAS2E1NXS		sys_insn(1, 4, 9, 4, 2)
+#define OP_TLBI_RIPAS2E1OSNXS		sys_insn(1, 4, 9, 4, 3)
+#define OP_TLBI_IPAS2LE1OSNXS		sys_insn(1, 4, 9, 4, 4)
+#define OP_TLBI_IPAS2LE1NXS		sys_insn(1, 4, 9, 4, 5)
+#define OP_TLBI_RIPAS2LE1NXS		sys_insn(1, 4, 9, 4, 6)
+#define OP_TLBI_RIPAS2LE1OSNXS		sys_insn(1, 4, 9, 4, 7)
+#define OP_TLBI_RVAE2OSNXS		sys_insn(1, 4, 9, 5, 1)
+#define OP_TLBI_RVALE2OSNXS		sys_insn(1, 4, 9, 5, 5)
+#define OP_TLBI_RVAE2NXS		sys_insn(1, 4, 9, 6, 1)
+#define OP_TLBI_RVALE2NXS		sys_insn(1, 4, 9, 6, 5)
+#define OP_TLBI_ALLE2NXS		sys_insn(1, 4, 9, 7, 0)
+#define OP_TLBI_VAE2NXS			sys_insn(1, 4, 9, 7, 1)
+#define OP_TLBI_ALLE1NXS		sys_insn(1, 4, 9, 7, 4)
+#define OP_TLBI_VALE2NXS		sys_insn(1, 4, 9, 7, 5)
+#define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
+
+/* Misc instructions */
+#define OP_GCSPUSHX			sys_insn(1, 0, 7, 7, 4)
+#define OP_GCSPOPCX			sys_insn(1, 0, 7, 7, 5)
+#define OP_GCSPOPX			sys_insn(1, 0, 7, 7, 6)
+#define OP_GCSPUSHM			sys_insn(1, 3, 7, 7, 0)
+
+#define OP_BRB_IALL			sys_insn(1, 1, 7, 2, 4)
+#define OP_BRB_INJ			sys_insn(1, 1, 7, 2, 5)
+#define OP_CFP_RCTX			sys_insn(1, 3, 7, 3, 4)
+#define OP_DVP_RCTX			sys_insn(1, 3, 7, 3, 5)
+#define OP_COSP_RCTX			sys_insn(1, 3, 7, 3, 6)
+#define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_ENTP2	(BIT(60))
 #define SCTLR_ELx_DSSBS	(BIT(44))
@@ -555,16 +898,14 @@
 /* Position the attr at the correct index */
 #define MAIR_ATTRIDX(attr, idx)		((attr) << ((idx) * 8))
 
-/* id_aa64pfr0 */
-#define ID_AA64PFR0_EL1_ELx_64BIT_ONLY		0x1
-#define ID_AA64PFR0_EL1_ELx_32BIT_64BIT		0x2
-
 /* id_aa64mmfr0 */
 #define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_EL1_TGRAN4_LPA2		ID_AA64MMFR0_EL1_TGRAN4_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MAX	0x7
 #define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MIN	0x0
 #define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MAX	0x7
 #define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MIN	0x1
+#define ID_AA64MMFR0_EL1_TGRAN16_LPA2		ID_AA64MMFR0_EL1_TGRAN16_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MAX	0xf
 
 #define ARM64_MIN_PARANGE_BITS		32
@@ -572,6 +913,7 @@
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_DEFAULT	0x0
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_NONE		0x1
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_MIN		0x2
+#define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2		0x3
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_MAX		0x7
 
 #ifdef CONFIG_ARM64_PA_BITS_52
@@ -582,11 +924,13 @@
 
 #if defined(CONFIG_ARM64_4K_PAGES)
 #define ID_AA64MMFR0_EL1_TGRAN_SHIFT		ID_AA64MMFR0_EL1_TGRAN4_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_LPA2		ID_AA64MMFR0_EL1_TGRAN4_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MIN
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MAX
 #define ID_AA64MMFR0_EL1_TGRAN_2_SHIFT		ID_AA64MMFR0_EL1_TGRAN4_2_SHIFT
 #elif defined(CONFIG_ARM64_16K_PAGES)
 #define ID_AA64MMFR0_EL1_TGRAN_SHIFT		ID_AA64MMFR0_EL1_TGRAN16_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_LPA2		ID_AA64MMFR0_EL1_TGRAN16_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MIN
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MAX
 #define ID_AA64MMFR0_EL1_TGRAN_2_SHIFT		ID_AA64MMFR0_EL1_TGRAN16_2_SHIFT
@@ -610,6 +954,19 @@
 #define SYS_GCR_EL1_RRND	(BIT(16))
 #define SYS_GCR_EL1_EXCL_MASK	0xffffUL
 
+#ifdef CONFIG_KASAN_HW_TAGS
+/*
+ * KASAN always uses a whole byte for its tags. With CONFIG_KASAN_HW_TAGS it
+ * only uses tags in the range 0xF0-0xFF, which we map to MTE tags 0x0-0xF.
+ */
+#define __MTE_TAG_MIN		(KASAN_TAG_MIN & 0xf)
+#define __MTE_TAG_MAX		(KASAN_TAG_MAX & 0xf)
+#define __MTE_TAG_INCL		GENMASK(__MTE_TAG_MAX, __MTE_TAG_MIN)
+#define KERNEL_GCR_EL1_EXCL	(SYS_GCR_EL1_EXCL_MASK & ~__MTE_TAG_INCL)
+#else
+#define KERNEL_GCR_EL1_EXCL	SYS_GCR_EL1_EXCL_MASK
+#endif
+
 #define KERNEL_GCR_EL1		(SYS_GCR_EL1_RRND | KERNEL_GCR_EL1_EXCL)
 
 /* RGSR_EL1 Definitions */
@@ -716,6 +1073,22 @@
 
 #define PIRx_ELx_PERM(idx, perm)	((perm) << ((idx) * 4))
 
+/*
+ * Permission Overlay Extension (POE) permission encodings.
+ */
+#define POE_NONE	UL(0x0)
+#define POE_R		UL(0x1)
+#define POE_X		UL(0x2)
+#define POE_RX		UL(0x3)
+#define POE_W		UL(0x4)
+#define POE_RW		UL(0x5)
+#define POE_XW		UL(0x6)
+#define POE_RXW		UL(0x7)
+#define POE_MASK	UL(0xf)
+
+/* Initial value for Permission Overlay Extension for EL0 */
+#define POR_EL0_INIT	POE_RXW
+
 #define ARM64_FEATURE_FIELD_BITS	4
 
 /* Defined for compatibility only, do not add new users. */
@@ -789,15 +1162,21 @@
 /*
  * For registers without architectural names, or simply unsupported by
  * GAS.
+ *
+ * __check_r forces warnings to be generated by the compiler when
+ * evaluating r which wouldn't normally happen due to being passed to
+ * the assembler via __stringify(r).
  */
 #define read_sysreg_s(r) ({						\
 	u64 __val;							\
+	u32 __maybe_unused __check_r = (u32)(r);			\
 	asm volatile(__mrs_s("%0", r) : "=r" (__val));			\
 	__val;								\
 })
 
 #define write_sysreg_s(v, r) do {					\
 	u64 __val = (u64)(v);						\
+	u32 __maybe_unused __check_r = (u32)(r);			\
 	asm volatile(__msr_s(r, "%x0") : : "rZ" (__val));		\
 } while (0)
 
@@ -827,6 +1206,8 @@
 	par;								\
 })
 
+#define SYS_FIELD_VALUE(reg, field, val)	reg##_##field##_##val
+
 #define SYS_FIELD_GET(reg, field, val)		\
 		 FIELD_GET(reg##_##field##_MASK, val)
 
@@ -834,7 +1215,8 @@
 		 FIELD_PREP(reg##_##field##_MASK, val)
 
 #define SYS_FIELD_PREP_ENUM(reg, field, val)		\
-		 FIELD_PREP(reg##_##field##_MASK, reg##_##field##_##val)
+		 FIELD_PREP(reg##_##field##_MASK,	\
+			    SYS_FIELD_VALUE(reg, field, val))
 
 #endif
 
diff --git a/tools/include/linux/kasan-tags.h b/tools/include/linux/kasan-tags.h
new file mode 100644
index 000000000000..4f85f562512c
--- /dev/null
+++ b/tools/include/linux/kasan-tags.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KASAN_TAGS_H
+#define _LINUX_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
+#define KASAN_TAG_INVALID	0xFE /* inaccessible memory tag */
+#define KASAN_TAG_MAX		0xFD /* maximum value for random tags */
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN		0xF0 /* minimum value for random tags */
+#else
+#define KASAN_TAG_MIN		0x00 /* minimum value for random tags */
+#endif
+
+#endif /* LINUX_KASAN_TAGS_H */
-- 
2.34.1

