Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B4FC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:04:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72FF740BD3;
	Wed,  2 Mar 2022 09:04:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JHSFsORmxKLW; Wed,  2 Mar 2022 09:04:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CCF949F03;
	Wed,  2 Mar 2022 09:04:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27ED940AFA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 17:56:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30DZvWPO2Vtc for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2022 17:56:48 -0500 (EST)
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1B7440A84
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 17:56:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1646175408; x=1677711408;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=WCgp4Qb2HPWuL7vI5XcOO6Be8JMHMl98QxYb9LSR3a0=;
 b=xHxRidPwb0Q5EMLye8UD2fxUSadpiluqjou9wFMJPtcHcJ1fRGfXbLXa
 lX8riz+dPlSMDCnwnFJtY6o+rH3Bkm90Vk7dLvTJkgat+nBP2RkjYiCzS
 RxG/QvwpohoyBZ9hf85SEekO33/ZJ5i5A7cfAfEaJMFb8RmV6YV88+pC1 o=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
 by alexa-out.qualcomm.com with ESMTP; 01 Mar 2022 14:56:47 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 01 Mar 2022 14:56:46 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 1 Mar 2022 14:56:45 -0800
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Tue, 1 Mar 2022
 14:56:44 -0800
Date: Tue, 1 Mar 2022 17:56:41 -0500
From: Qian Cai <quic_qiancai@quicinc.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 03/40] arm64: cpufeature: Always specify and use a
 field width for capabilities
Message-ID: <Yh6kqaR9FQXg8Q4w@qian>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-4-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-4-broonie@kernel.org>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mailman-Approved-At: Wed, 02 Mar 2022 09:04:15 -0500
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah
 Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Feb 07, 2022 at 03:20:32PM +0000, Mark Brown wrote:
> Since all the fields in the main ID registers are 4 bits wide we have up
> until now not bothered specifying the width in the code. Since we now
> wish to use this mechanism to enumerate features from the floating point
> feature registers which do not follow this pattern add a width to the
> table.  This means updating all the existing table entries but makes it
> less likely that we run into issues in future due to implicitly assuming
> a 4 bit width.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Do we leave this one alone on purpose?

                .desc = "GIC system register CPU interface",
                .capability = ARM64_HAS_SYSREG_GIC_CPUIF,
                .type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
                .matches = has_useable_gicv3_cpuif,
                .sys_reg = SYS_ID_AA64PFR0_EL1,
                .field_pos = ID_AA64PFR0_GIC_SHIFT,
                .sign = FTR_UNSIGNED,
                .min_field_value = 1,

Since width == 0, it will generate an undefined behavior.

UBSAN: shift-out-of-bounds in ./arch/arm64/include/asm/cpufeature.h:535:49
 shift exponent 64 is too large for 64-bit type 'long long unsigned int'
 CPU: 0 PID: 0 Comm: swapper Not tainted 5.17.0-rc6-next-20220301 #1
 Call trace:
  dump_backtrace
  show_stack
  dump_stack_lvl
  dump_stack
  ubsan_epilogue
  __ubsan_handle_shift_out_of_bounds
  has_cpuid_feature
  cpuid_feature_extract_unsigned_field_width at arch/arm64/include/asm/cpufeature.h:535
  (inlined by) cpuid_feature_extract_field_width at arch/arm64/include/asm/cpufeature.h:582
  (inlined by) cpuid_feature_extract_field_width at arch/arm64/include/asm/cpufeature.h:578
  (inlined by) feature_matches at arch/arm64/kernel/cpufeature.c:1317
  (inlined by) has_cpuid_feature at arch/arm64/kernel/cpufeature.c:1335
  has_useable_gicv3_cpuif
  has_useable_gicv3_cpuif at arch/arm64/kernel/cpufeature.c:1389
  update_cpu_capabilities
  init_cpu_features
  cpuinfo_store_boot_cpu
  smp_prepare_boot_cpu
  start_kernel
  __primary_switched
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
