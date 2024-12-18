Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652591369AA
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 05:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734499553; cv=none; b=tpOaVMWGVwfkbII7j78x9YfwGsUML91P9qmvqjJXqfC6fIf3K6RLQl8huvCf9mX55tjll5DuK1Y4VocC6ryMQqcmbJCl8s6pug/WTpHWDkrxT3HZskc70wNVf7HRby+FVRdDJPSMBTPQvAzicIjq5lo6Z4ZYupGzMaAEidoPWKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734499553; c=relaxed/simple;
	bh=hdmn6jWP8hkI5Rxf8o9Dli5aPWwW4xK7sGhL7rLhTqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bmEJlfQxhv7Z7e4zANI7llAD1L0G2PzuxFL1IsYwfdv5fvV21/qRkBV/JDOpOrCJszKtoa9JfGXxeCS8HfGEVfioClIsmn7LdKjYiwdTPhgXP0CLFSxGL6E0fJsDqepfB7eGTcZwyY/jL9+UIPFJlBgRH1iMC4zQKSv0SIkXc8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8493FEC;
	Tue, 17 Dec 2024 21:26:18 -0800 (PST)
Received: from [10.163.50.13] (unknown [10.163.50.13])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E18403F7B4;
	Tue, 17 Dec 2024 21:25:45 -0800 (PST)
Message-ID: <96bae61a-c9a0-4b9a-af4f-b6fc6202bccd@arm.com>
Date: Wed, 18 Dec 2024 10:55:43 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 6/7] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
To: Rob Herring <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-7-anshuman.khandual@arm.com>
 <20241216234251.GA629562-robh@kernel.org>
 <c64709f7-e1c6-482e-8665-912be50b15bd@arm.com>
 <CAL_Jsq+EO_s49sSK3JQQEDDpcndf4hSpM_gfoe8tZ8=4y3f-tg@mail.gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <CAL_Jsq+EO_s49sSK3JQQEDDpcndf4hSpM_gfoe8tZ8=4y3f-tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[....]

On 12/17/24 23:23, Rob Herring wrote:
>> Something like the commit
>>
>> commit 31c00d2aeaa2da89361f5b64a64ca831433be5fc
>> Author: Mark Brown <broonie@kernel.org>
>> Date:   Thu Apr 1 19:09:40 2021 +0100
>>
>>     arm64: Disable fine grained traps on boot
>>
>>     The arm64 FEAT_FGT extension introduces a set of traps to EL2 for accesses
>>     to small sets of registers and instructions from EL1 and EL0.  Currently
>>     Linux makes no use of this feature, ensure that it is not active at boot by
>>     disabling the traps during EL2 setup.
>>
>>
>>>
>>> I just realized I forgot to add FGT2 setup for the PMUv3.9 features I
>>> already added in 6.12 and 6.13. So this really needs to land sooner
>>> rather than later to add that.
>> Not sure if I got this correctly. Are you suggesting to carve out __init_el2_fgt2()
>> from the series and post separately with PMUv3.9 requirements and fallback clearing
>> for all FEAT_FGT2 trap config registers as mentioned above ?
> Yes, as it needs to not be held up by any of the debug issues Mark
> raised. Also, it may need to be back ported to 6.12. And for that we'd
> want the PMU parts, but not the Debug. I still have to figure out what
> needs to be done on the KVM side.

Hi Rob,

I did go through all the five FEAT_FGT2 trap control registers and it
seems like the following are the controls available for FEAT_PMUv3p9
based registers. Although PMZR_EL0 does not get used in kernel right
now but still might be a good idea to include anyway. Please let me
know, if I might have missed something else related to FEAT_PMUv3p9.

HDFGRTR2_EL2_nPMUACR_EL1	(mrs PMUACR_EL1)
HDFGWTR2_EL2_nPMUACR_EL1	(msr PMUACR_EL1)
HDFGWTR2_EL2_nPMZR_EL0		(msr PMZR_EL0)

Following will be the change required for __init_el2_fgt2() along with
all the tools sysreg updates required for the mentioned registers here.

--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -233,6 +233,31 @@
 .Lskip_fgt_\@:
 .endm
 
+.macro __init_el2_fgt2
+       mrs     x1, id_aa64mmfr0_el1
+       ubfx    x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
+       cmp     x1, #ID_AA64MMFR0_EL1_FGT_FGT2
+       b.lt    .Lskip_fgt2_\@
+
+       mov     x0, xzr
+       mov     x2, xzr
+       mrs     x1, id_aa64dfr0_el1
+       ubfx    x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
+       cmp     x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
+       b.lt    .Lskip_pmuv3p9_\@
+
+       orr     x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
+       orr     x2, x2, #HDFGWTR2_EL2_nPMUACR_EL1
+       orr     x2, x2, #HDFGWTR2_EL2_nPMZR_EL0
+.Lskip_pmuv3p9_\@:
+       msr_s   SYS_HDFGRTR2_EL2, x0
+       msr_s   SYS_HDFGWTR2_EL2, x2
+       msr_s   SYS_HFGRTR2_EL2, xzr
+       msr_s   SYS_HFGWTR2_EL2, xzr
+       msr_s   SYS_HFGITR2_EL2, xzr
+.Lskip_fgt2_\@:
+.endm
+
 .macro __init_el2_gcs
        mrs_s   x1, SYS_ID_AA64PFR1_EL1
        ubfx    x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
@@ -283,6 +308,7 @@
        __init_el2_nvhe_idregs
        __init_el2_cptr
        __init_el2_fgt
+       __init_el2_fgt2
         __init_el2_gcs
 .endm
