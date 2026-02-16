Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915C52D0C9C
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 12:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771244546; cv=none; b=kpIjnISlqauMqGktW9RdYMv4vlY02qjyqOtSnO0mHTj5X0rsC0LosZCb3cSMopxkqAMqBfz5qZfvFzBsHg2ewgpFPWBouK7djfO/UsISExi6LsVOF9JwMHI70RNOD5IIIcWXJQhfQRCd6N0NMHUUv0ljqIdOShAJF6LMcTdO/CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771244546; c=relaxed/simple;
	bh=bWnFaOVa0+yFR9y8lCxW59b1YsHn0T/VZtPn9tfqxxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pJeWq71n1dR8g16TfnTdXPrzENOaetA2HUM4iK80qwMbXcRqn3P/m7c0wqfoKdla7ns9PCb8KDbXKbM/r/dsCjGVlOi54JywV/Y0cknlRkPbk8+AjZ/Sdwk5kN+2rqOdxd+PilSDwT1hBOY6bxh+ArsrviEHEx7UdE0Q65dp8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5844C150C;
	Mon, 16 Feb 2026 04:22:15 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4786B3F73F;
	Mon, 16 Feb 2026 04:22:16 -0800 (PST)
Message-ID: <b844c632-c8fc-48f1-b347-07f166019b22@arm.com>
Date: Mon, 16 Feb 2026 12:22:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Zeng Heng <zengheng4@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 linux-doc@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <9945d28e-f1f2-e11a-1481-8d80167d6f89@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <9945d28e-f1f2-e11a-1481-8d80167d6f89@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Zeng,

On 2/14/26 09:40, Zeng Heng wrote:
> Hi Ben,
> 
> On 2026/2/4 5:43, Ben Horgan wrote:
[...]
>>
>> Based on:
>> [1] git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/cache
>> (To include telemetry code which changes the resctrl arch interface)
>>
>> The series can be retrieved from:
>> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v4
>> (Final commit is a fix already in 6.19-rc8)
>>
[...]
>>
> 
> I've tested the MPAM functionality on my local Kunpeng platform. Here's
> a summary of the results:

Thank you very much for your testing and detailed report.

> 
> Features enabled and verified:
>   * L2 and L3 CPBM
>   * L3 CSU
>   * L2 and L3 CDP
> All enabled features passed functional testing as expected.
> 
> + Tested-by: Zeng Heng <zengheng4@huawei.com>
> 
> Features not enabled:
>   1. MATA MBMAX partition and MBWU monitor.

What's MATA here? Just memory allocation or something more specific?

>      Reason: These do not meet the driver's current topology>     
expectations for MB support, hence they were not initialized.
>      This behavior is expected.

Is this because you have more than 1 L3 cache?

> 
>   2. L2 CSU and MBWU monitors.
>      Reason: The current MPAM driver does not support L2-related
>      functionality yet.

Thanks for letting us know you have these. But, yes, unfortunately
monitoring is only supported on the L3 at the moment.

> 
> + Tested-by: Zeng Heng <zengheng4@huawei.com>
> 
> 
> Detailed test logs are as follows:

I'm confused by these logs as it looks like you aren't getting any
monitors but you verified the L3 CSU. Also, it looks like cpor (cbpm) is
disabled (at least partially) but you verified L2 and L3 CPBM. Is this
across different machines?

> 
> Boot logs:
> [root@localhost ~]# dmesg | grep -i mpam
> [    0.000000] ACPI: MPAM 0x000000007FF35018 003024 (v01 HISI   HIP12
> 00000000 HISI 20151124)
> [    9.509852] mpam_msc mpam_msc.64: Merging features for
> vmsc:0xffff0800973cf5a0 |= ris:0xffff08009757ee90
> [    9.509859] mpam_msc mpam_msc.254: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff080097628520
> [    9.509860] mpam:__props_mismatch:
> mpam_has_feature(mpam_feat_cpor_part, parent) = 1
> [    9.509864] mpam:__props_mismatch:
> mpam_has_feature(mpam_feat_cpor_part, child) = 0
> [    9.509866] mpam:__props_mismatch: parent->cpbm_wd = 8
> [    9.509869] mpam:__props_mismatch: child->cpbm_wd = 0
> [    9.509871] mpam:__props_mismatch: alias = 0
> [    9.509873] mpam:__props_mismatch: cleared cpor_part

cpor (partially) disabled?

> [    9.509876] mpam:__props_mismatch: took the min num_csu_mon
> [    9.509878] mpam:__props_mismatch: took the min num_mbwu_mon
> [    9.509881] mpam_msc mpam_msc.252: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800976284a0
> [    9.509884] mpam_msc mpam_msc.250: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff080097628420
> [    9.509887] mpam_msc mpam_msc.248: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800976283a0
> [    9.509889] mpam_msc mpam_msc.246: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff080097628320
> [    9.509892] mpam_msc mpam_msc.244: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800976282a0
> [    9.509894] mpam_msc mpam_msc.242: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff080097628220
> [    9.509897] mpam_msc mpam_msc.240: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800976281a0
> [    9.509900] mpam_msc mpam_msc.238: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff080097628120
> [    9.509902] mpam_msc mpam_msc.236: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800976280a0
> [    9.509905] mpam_msc mpam_msc.234: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff080097628020
> [    9.509907] mpam_msc mpam_msc.232: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975affa0
> [    9.509910] mpam_msc mpam_msc.230: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aff20
> [    9.509913] mpam_msc mpam_msc.228: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afea0
> [    9.509915] mpam_msc mpam_msc.226: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afe20
> [    9.509918] mpam_msc mpam_msc.224: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afda0
> [    9.509920] mpam_msc mpam_msc.222: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afd20
> [    9.509923] mpam_msc mpam_msc.220: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afca0
> [    9.509925] mpam_msc mpam_msc.218: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afc20
> [    9.509928] mpam_msc mpam_msc.216: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afba0
> [    9.509931] mpam_msc mpam_msc.214: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afb20
> [    9.509933] mpam_msc mpam_msc.212: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afaa0
> [    9.509936] mpam_msc mpam_msc.210: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975afa20
> [    9.509938] mpam_msc mpam_msc.208: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af9a0
> [    9.509941] mpam_msc mpam_msc.206: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af920
> [    9.509943] mpam_msc mpam_msc.204: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af8a0
> [    9.509946] mpam_msc mpam_msc.202: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af820
> [    9.509949] mpam_msc mpam_msc.200: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af7a0
> [    9.509951] mpam_msc mpam_msc.198: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af720
> [    9.509954] mpam_msc mpam_msc.196: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af6a0
> [    9.509956] mpam_msc mpam_msc.194: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af620
> [    9.509959] mpam_msc mpam_msc.192: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af5a0
> [    9.509962] mpam_msc mpam_msc.190: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af520
> [    9.509964] mpam_msc mpam_msc.188: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af4a0
> [    9.509967] mpam_msc mpam_msc.186: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af420
> [    9.509969] mpam_msc mpam_msc.184: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af3a0
> [    9.509972] mpam_msc mpam_msc.182: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af320
> [    9.509974] mpam_msc mpam_msc.180: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af2a0
> [    9.509977] mpam_msc mpam_msc.178: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af220
> [    9.509980] mpam_msc mpam_msc.176: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af1a0
> [    9.509982] mpam_msc mpam_msc.174: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af120
> [    9.509985] mpam_msc mpam_msc.172: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af0a0
> [    9.509987] mpam_msc mpam_msc.170: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975af020
> [    9.509990] mpam_msc mpam_msc.168: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aefa0
> [    9.509993] mpam_msc mpam_msc.166: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aef20
> [    9.509995] mpam_msc mpam_msc.164: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aeea0
> [    9.509998] mpam_msc mpam_msc.162: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aee20
> [    9.510000] mpam_msc mpam_msc.160: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aeda0
> [    9.510003] mpam_msc mpam_msc.158: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aed20
> [    9.510005] mpam_msc mpam_msc.156: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aeca0
> [    9.510008] mpam_msc mpam_msc.154: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aec20
> [    9.510010] mpam_msc mpam_msc.152: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aeba0
> [    9.510013] mpam_msc mpam_msc.150: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aeb20
> [    9.510016] mpam_msc mpam_msc.148: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aeaa0
> [    9.510018] mpam_msc mpam_msc.146: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975aea20
> [    9.510021] mpam_msc mpam_msc.144: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae9a0
> [    9.510023] mpam_msc mpam_msc.142: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae920
> [    9.510026] mpam_msc mpam_msc.140: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae8a0
> [    9.510029] mpam_msc mpam_msc.138: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae820
> [    9.510031] mpam_msc mpam_msc.136: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae7a0
> [    9.510034] mpam_msc mpam_msc.134: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae720
> [    9.510036] mpam_msc mpam_msc.132: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae6a0
> [    9.510039] mpam_msc mpam_msc.130: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae620
> [    9.510041] mpam_msc mpam_msc.128: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae5a0
> [    9.510044] mpam_msc mpam_msc.126: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae520
> [    9.510047] mpam_msc mpam_msc.124: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae4a0
> [    9.510049] mpam_msc mpam_msc.122: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae420
> [    9.510052] mpam_msc mpam_msc.120: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae3a0
> [    9.510054] mpam_msc mpam_msc.118: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae2a0
> [    9.510057] mpam_msc mpam_msc.116: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae220
> [    9.510060] mpam_msc mpam_msc.114: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae1a0
> [    9.510062] mpam_msc mpam_msc.112: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae120
> [    9.510065] mpam_msc mpam_msc.110: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae0a0
> [    9.510067] mpam_msc mpam_msc.108: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800975ae020
> [    9.510070] mpam_msc mpam_msc.106: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff08009729c720
> [    9.510073] mpam_msc mpam_msc.104: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cffa0
> [    9.510075] mpam_msc mpam_msc.102: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cff20
> [    9.510078] mpam_msc mpam_msc.100: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfea0
> [    9.510080] mpam_msc mpam_msc.98: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfe20
> [    9.510083] mpam_msc mpam_msc.96: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfda0
> [    9.510086] mpam_msc mpam_msc.94: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfd20
> [    9.510088] mpam_msc mpam_msc.92: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfca0
> [    9.510091] mpam_msc mpam_msc.90: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfc20
> [    9.510094] mpam_msc mpam_msc.88: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfba0
> [    9.510096] mpam_msc mpam_msc.86: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfb20
> [    9.510099] mpam_msc mpam_msc.84: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfaa0
> [    9.510102] mpam_msc mpam_msc.82: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cfa20
> [    9.510104] mpam_msc mpam_msc.80: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf9a0
> [    9.510107] mpam_msc mpam_msc.78: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf920
> [    9.510109] mpam_msc mpam_msc.76: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf8a0
> [    9.510112] mpam_msc mpam_msc.74: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf820
> [    9.510115] mpam_msc mpam_msc.72: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf7a0
> [    9.510117] mpam_msc mpam_msc.70: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf720
> [    9.510120] mpam_msc mpam_msc.68: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf6a0
> [    9.510123] mpam_msc mpam_msc.66: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf620
> [    9.510125] mpam_msc mpam_msc.64: Merging features for
> class:0xffff08009736fe50 &= vmsc:0xffff0800973cf5a0
> [    9.510129] mpam_msc mpam_msc.62: Merging features for
> vmsc:0xffff0800973cf520 |= ris:0xffff08009757ea90
> [    9.510132] mpam_msc mpam_msc.60: Merging features for
> vmsc:0xffff0800973cf4a0 |= ris:0xffff08009757e690
> [    9.510133] mpam_msc mpam_msc.58: Merging features for
> vmsc:0xffff0800973cf420 |= ris:0xffff08009757e290
> [    9.510136] mpam_msc mpam_msc.56: Merging features for
> vmsc:0xffff0800973cf3a0 |= ris:0xffff08009757de90
> [    9.510139] mpam_msc mpam_msc.54: Merging features for
> vmsc:0xffff0800973cf320 |= ris:0xffff08009757da90
> [    9.510141] mpam_msc mpam_msc.52: Merging features for
> vmsc:0xffff0800973cf2a0 |= ris:0xffff08009757d690
> [    9.510144] mpam_msc mpam_msc.50: Merging features for
> vmsc:0xffff0800973cf220 |= ris:0xffff08009757d290
> [    9.510146] mpam_msc mpam_msc.48: Merging features for
> vmsc:0xffff0800973cf1a0 |= ris:0xffff08009757ce90
> [    9.510149] mpam_msc mpam_msc.46: Merging features for
> vmsc:0xffff0800973cf120 |= ris:0xffff08009757ca90
> [    9.510152] mpam_msc mpam_msc.44: Merging features for
> vmsc:0xffff0800973cf0a0 |= ris:0xffff08009757c690
> [    9.510154] mpam_msc mpam_msc.42: Merging features for
> vmsc:0xffff0800973cf020 |= ris:0xffff08009757c290
> [    9.510157] mpam_msc mpam_msc.40: Merging features for
> vmsc:0xffff0800973cefa0 |= ris:0xffff08009757be90
> [    9.510160] mpam_msc mpam_msc.38: Merging features for
> vmsc:0xffff0800973cef20 |= ris:0xffff08009757ba90
> [    9.510162] mpam_msc mpam_msc.36: Merging features for
> vmsc:0xffff0800973ceea0 |= ris:0xffff08009757b690
> [    9.510166] mpam_msc mpam_msc.34: Merging features for
> vmsc:0xffff0800973cee20 |= ris:0xffff08009757b290
> [    9.510167] mpam_msc mpam_msc.32: Merging features for
> vmsc:0xffff0800973ceda0 |= ris:0xffff08009757ae90
> [    9.510170] mpam_msc mpam_msc.30: Merging features for
> vmsc:0xffff0800973ced20 |= ris:0xffff08009757aa90
> [    9.510173] mpam_msc mpam_msc.28: Merging features for
> vmsc:0xffff0800973ceca0 |= ris:0xffff08009757a690
> [    9.510175] mpam_msc mpam_msc.26: Merging features for
> vmsc:0xffff0800973cec20 |= ris:0xffff08009757a290
> [    9.510178] mpam_msc mpam_msc.24: Merging features for
> vmsc:0xffff0800973ceba0 |= ris:0xffff080097579e90
> [    9.510181] mpam_msc mpam_msc.22: Merging features for
> vmsc:0xffff0800973ceb20 |= ris:0xffff080097579a90
> [    9.510183] mpam_msc mpam_msc.20: Merging features for
> vmsc:0xffff0800973ceaa0 |= ris:0xffff080097579690
> [    9.510186] mpam_msc mpam_msc.18: Merging features for
> vmsc:0xffff0800973cea20 |= ris:0xffff080097579290
> [    9.510189] mpam_msc mpam_msc.16: Merging features for
> vmsc:0xffff0800973ce9a0 |= ris:0xffff080097578e90
> [    9.510191] mpam_msc mpam_msc.62: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf520
> [    9.510195] mpam_msc mpam_msc.60: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf4a0
> [    9.510196] mpam_msc mpam_msc.58: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf420
> [    9.510199] mpam_msc mpam_msc.56: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf3a0
> [    9.510202] mpam_msc mpam_msc.54: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf320
> [    9.510204] mpam_msc mpam_msc.52: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf2a0
> [    9.510207] mpam_msc mpam_msc.50: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf220
> [    9.510209] mpam_msc mpam_msc.48: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf1a0
> [    9.510212] mpam_msc mpam_msc.46: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf120
> [    9.510214] mpam_msc mpam_msc.44: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf0a0
> [    9.510217] mpam_msc mpam_msc.42: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cf020
> [    9.510219] mpam_msc mpam_msc.40: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cefa0
> [    9.510222] mpam_msc mpam_msc.38: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cef20
> [    9.510224] mpam_msc mpam_msc.36: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ceea0
> [    9.510227] mpam_msc mpam_msc.34: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cee20
> [    9.510230] mpam_msc mpam_msc.32: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ceda0
> [    9.510232] mpam_msc mpam_msc.30: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ced20
> [    9.510235] mpam_msc mpam_msc.28: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ceca0
> [    9.510237] mpam_msc mpam_msc.26: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cec20
> [    9.510240] mpam_msc mpam_msc.24: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ceba0
> [    9.510242] mpam_msc mpam_msc.22: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ceb20
> [    9.510245] mpam_msc mpam_msc.20: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ceaa0
> [    9.510247] mpam_msc mpam_msc.18: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973cea20
> [    9.510250] mpam_msc mpam_msc.16: Merging features for
> class:0xffff08009736cc50 &= vmsc:0xffff0800973ce9a0
> [    9.510254] mpam_msc mpam_msc.14: Merging features for
> vmsc:0xffff0800973ce920 |= ris:0xffff080097578a90
> [    9.510255] mpam_msc mpam_msc.12: Merging features for
> vmsc:0xffff0800973ce8a0 |= ris:0xffff080097578690
> [    9.510258] mpam_msc mpam_msc.10: Merging features for
> vmsc:0xffff0800973ce820 |= ris:0xffff080097578290
> [    9.510260] mpam_msc mpam_msc.8: Merging features for
> vmsc:0xffff0800973ce7a0 |= ris:0xffff080097417e90
> [    9.510263] mpam_msc mpam_msc.6: Merging features for
> vmsc:0xffff0800973ce720 |= ris:0xffff080097417a90
> [    9.510266] mpam_msc mpam_msc.4: Merging features for
> vmsc:0xffff0800973ce6a0 |= ris:0xffff080097417690
> [    9.510268] mpam_msc mpam_msc.2: Merging features for
> vmsc:0xffff0800973ce620 |= ris:0xffff080097417290
> [    9.510271] mpam_msc mpam_msc.0: Merging features for
> vmsc:0xffff0800973ce5a0 |= ris:0xffff080097416e90
> [    9.510274] mpam_msc mpam_msc.14: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce920
> [    9.510276] mpam_msc mpam_msc.12: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce8a0
> [    9.510279] mpam_msc mpam_msc.10: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce820
> [    9.510281] mpam_msc mpam_msc.8: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce7a0
> [    9.510284] mpam_msc mpam_msc.6: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce720
> [    9.510287] mpam_msc mpam_msc.4: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce6a0
> [    9.510289] mpam_msc mpam_msc.2: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce620
> [    9.510292] mpam_msc mpam_msc.0: Merging features for
> class:0xffff08009735bb50 &= vmsc:0xffff0800973ce5a0
> [   10.978496] mpam:mpam_resctrl_pick_caches: class 2 cache misses CPOR

No L2 cpor?

> [   10.978497] mpam:mpam_resctrl_pick_caches: class 255 is not a cache
> [   10.980470] mpam:mpam_resctrl_pick_mba: class 2 is before L3
> [   10.980472] mpam:mpam_resctrl_pick_mba: class 3 has no bandwidth control
> [   10.997406] mpam:topology_matches_l3: class 255 component 0 has
> Mismatched CPU mask with L3 equivalent
> [   10.997411] mpam:mpam_resctrl_pick_mba: class 255 topology doesn't
> match L3
> [   10.997415] mpam:mpam_resctrl_pick_counters: class 2 is before L3
> [   11.024109] mpam:topology_matches_l3: class 3 component 276 has
> Mismatched CPU mask with L3 equivalent
> [   11.024114] mpam:class_has_usable_mbwu: monitors usable in free-
> running mode

mbwu enabled?

> [   11.063882] mpam:topology_matches_l3: class 255 component 0 has
> Mismatched CPU mask with L3 equivalent
> [   11.113183] mpam:mpam_resctrl_alloc_domain: Skipped monitor domain
> online - no monitors
> [   11.113189] MPAM enabled with 32 PARTIDs and 4 PMGs
> 
> 
> Kunit test logs:
> [   31.253697] KTAP version 1
> [   31.253698] 1..2
> [   31.258263]     KTAP version 1
> [   31.258265]     # Subtest: mpam_devices_test_suite
> [   31.258267]     # module: mpam
> [   31.258268]     1..3
> [   31.258775]     ok 1 test_mpam_reset_msc_bitmap
> [   31.259558]     ok 2 test_mpam_enable_merge_features
> [   31.260259]     ok 3 test__props_mismatch
> [   31.260261] # mpam_devices_test_suite: pass:3 fail:0 skip:0 total:3
> [   31.260263] # Totals: pass:3 fail:0 skip:0 total:3
> [   31.260265] ok 1 mpam_devices_test_suite
> [   31.260267]     KTAP version 1
> [   31.260268]     # Subtest: mpam_resctrl_test_suite
> [   31.260269]     # module: mpam
> [   31.260271]     1..7
> [   31.260965]     ok 1 test_get_mba_granularity
> [   31.260968]         KTAP version 1
> [   31.260969]         # Subtest: test_mbw_max_to_percent
> [   31.261372]         ok 1 pc=1, width=8, value=0x01
> [   31.261794]         ok 2 pc=1, width=12, value=0x027
> [   31.262081]         ok 3 pc=1, width=16, value=0x028e
> [   31.262183]         ok 4 pc=25, width=8, value=0x3f
> [   31.262287]         ok 5 pc=25, width=12, value=0x3ff
> [   31.262388]         ok 6 pc=25, width=16, value=0x3fff
> [   31.262489]         ok 7 pc=33, width=8, value=0x53
> [   31.262608]         ok 8 pc=33, width=12, value=0x546
> [   31.262860]         ok 9 pc=33, width=16, value=0x5479
> [   31.263113]         ok 10 pc=35, width=8, value=0x58
> [   31.263491]         ok 11 pc=35, width=12, value=0x598
> [   31.263872]         ok 12 pc=35, width=16, value=0x5998
> [   31.264249]         ok 13 pc=45, width=8, value=0x72
> [   31.264352]         ok 14 pc=45, width=12, value=0x732
> [   31.264455]         ok 15 pc=45, width=16, value=0x7332
> [   31.264559]         ok 16 pc=50, width=8, value=0x7f
> [   31.264661]         ok 17 pc=50, width=12, value=0x7ff
> [   31.264764]         ok 18 pc=50, width=16, value=0x7fff
> [   31.264872]         ok 19 pc=52, width=8, value=0x84
> [   31.264978]         ok 20 pc=52, width=12, value=0x850
> [   31.265082]         ok 21 pc=52, width=16, value=0x851d
> [   31.265190]         ok 22 pc=55, width=8, value=0x8b
> [   31.265297]         ok 23 pc=55, width=12, value=0x8cb
> [   31.265403]         ok 24 pc=55, width=16, value=0x8ccb
> [   31.265507]         ok 25 pc=58, width=8, value=0x93
> [   31.265609]         ok 26 pc=58, width=12, value=0x946
> [   31.265714]         ok 27 pc=58, width=16, value=0x9479
> [   31.265817]         ok 28 pc=75, width=8, value=0xbf
> [   31.265918]         ok 29 pc=75, width=12, value=0xbff
> [   31.266020]         ok 30 pc=75, width=16, value=0xbfff
> [   31.266120]         ok 31 pc=80, width=8, value=0xcb
> [   31.266220]         ok 32 pc=80, width=12, value=0xccb
> [   31.266322]         ok 33 pc=80, width=16, value=0xcccb
> [   31.266425]         ok 34 pc=88, width=8, value=0xe0
> [   31.266533]         ok 35 pc=88, width=12, value=0xe13
> [   31.266637]         ok 36 pc=88, width=16, value=0xe146
> [   31.266758]         ok 37 pc=95, width=8, value=0xf2
> [   31.267150]         ok 38 pc=95, width=12, value=0xf32
> [   31.267535]         ok 39 pc=95, width=16, value=0xf332
> [   31.267918]         ok 40 pc=100, width=8, value=0xff
> [   31.268160]         ok 41 pc=100, width=12, value=0xfff
> [   31.268264]         ok 42 pc=100, width=16, value=0xffff
> [   31.268266]     # test_mbw_max_to_percent: pass:42 fail:0 skip:0
> total:42
> [   31.268268]     ok 2 test_mbw_max_to_percent
> [   31.268270]         KTAP version 1
> [   31.268271]         # Subtest: test_percent_to_mbw_max
> [   31.268376]         ok 1 pc=1, width=8, value=0x01
> [   31.268483]         ok 2 pc=1, width=12, value=0x027
> [   31.268595]         ok 3 pc=1, width=16, value=0x028e
> [   31.268701]         ok 4 pc=25, width=8, value=0x3f
> [   31.268806]         ok 5 pc=25, width=12, value=0x3ff
> [   31.268915]         ok 6 pc=25, width=16, value=0x3fff
> [   31.269022]         ok 7 pc=33, width=8, value=0x53
> [   31.269129]         ok 8 pc=33, width=12, value=0x546
> [   31.269237]         ok 9 pc=33, width=16, value=0x5479
> [   31.269342]         ok 10 pc=35, width=8, value=0x58
> [   31.269446]         ok 11 pc=35, width=12, value=0x598
> [   31.269551]         ok 12 pc=35, width=16, value=0x5998
> [   31.269658]         ok 13 pc=45, width=8, value=0x72
> [   31.269764]         ok 14 pc=45, width=12, value=0x732
> [   31.269868]         ok 15 pc=45, width=16, value=0x7332
> [   31.269975]         ok 16 pc=50, width=8, value=0x7f
> [   31.270081]         ok 17 pc=50, width=12, value=0x7ff
> [   31.270185]         ok 18 pc=50, width=16, value=0x7fff
> [   31.270287]         ok 19 pc=52, width=8, value=0x84
> [   31.270388]         ok 20 pc=52, width=12, value=0x850
> [   31.270494]         ok 21 pc=52, width=16, value=0x851d
> [   31.270606]         ok 22 pc=55, width=8, value=0x8b
> [   31.271004]         ok 23 pc=55, width=12, value=0x8cb
> [   31.271387]         ok 24 pc=55, width=16, value=0x8ccb
> [   31.271770]         ok 25 pc=58, width=8, value=0x93
> [   31.272151]         ok 26 pc=58, width=12, value=0x946
> [   31.272260]         ok 27 pc=58, width=16, value=0x9479
> [   31.272366]         ok 28 pc=75, width=8, value=0xbf
> [   31.272472]         ok 29 pc=75, width=12, value=0xbff
> [   31.272580]         ok 30 pc=75, width=16, value=0xbfff
> [   31.272686]         ok 31 pc=80, width=8, value=0xcb
> [   31.272790]         ok 32 pc=80, width=12, value=0xccb
> [   31.272895]         ok 33 pc=80, width=16, value=0xcccb
> [   31.273000]         ok 34 pc=88, width=8, value=0xe0
> [   31.273106]         ok 35 pc=88, width=12, value=0xe13
> [   31.273209]         ok 36 pc=88, width=16, value=0xe146
> [   31.273318]         ok 37 pc=95, width=8, value=0xf2
> [   31.273424]         ok 38 pc=95, width=12, value=0xf32
> [   31.273528]         ok 39 pc=95, width=16, value=0xf332
> [   31.273635]         ok 40 pc=100, width=8, value=0xff
> [   31.273742]         ok 41 pc=100, width=12, value=0xfff
> [   31.273847]         ok 42 pc=100, width=16, value=0xffff
> [   31.273849]     # test_percent_to_mbw_max: pass:42 fail:0 skip:0
> total:42
> [   31.273850]     ok 3 test_percent_to_mbw_max
> [   31.273852]         KTAP version 1
> [   31.273853]         # Subtest: test_mbw_max_to_percent_limits
> [   31.273957]         ok 1 wd=1
> [   31.274064]         ok 2 wd=2
> [   31.274171]         ok 3 wd=3
> [   31.274276]         ok 4 wd=4
> [   31.274381]         ok 5 wd=5
> [   31.274485]         ok 6 wd=6
> [   31.274603]         ok 7 wd=7
> [   31.274710]         ok 8 wd=8
> [   31.274974]         ok 9 wd=9
> [   31.275362]         ok 10 wd=10
> [   31.275746]         ok 11 wd=11
> [   31.276122]         ok 12 wd=12
> [   31.276230]         ok 13 wd=13
> [   31.276335]         ok 14 wd=14
> [   31.276444]         ok 15 wd=15
> [   31.276551]         ok 16 wd=16
> [   31.276553]     # test_mbw_max_to_percent_limits: pass:16 fail:0
> skip:0 total:16
> [   31.276554]     ok 4 test_mbw_max_to_percent_limits
> [   31.276605]     # test_percent_to_max_rounding: Round-up rate: 43%
> (18/42)
> [   31.276668]     ok 5 test_percent_to_max_rounding
> [   31.276671]         KTAP version 1
> [   31.276672]         # Subtest: test_percent_max_roundtrip_stability
> [   31.276776]         ok 1 wd=1
> [   31.276883]         ok 2 wd=2
> [   31.276988]         ok 3 wd=3
> [   31.277096]         ok 4 wd=4
> [   31.277202]         ok 5 wd=5
> [   31.277309]         ok 6 wd=6
> [   31.277416]         ok 7 wd=7
> [   31.277524]         ok 8 wd=8
> [   31.277629]         ok 9 wd=9
> [   31.277737]         ok 10 wd=10
> [   31.277843]         ok 11 wd=11
> [   31.277948]         ok 12 wd=12
> [   31.278061]         ok 13 wd=13
> [   31.278167]         ok 14 wd=14
> [   31.278273]         ok 15 wd=15
> [   31.278380]         ok 16 wd=16
> [   31.278381]     # test_percent_max_roundtrip_stability: pass:16
> fail:0 skip:0 total:16
> [   31.278383]     ok 6 test_percent_max_roundtrip_stability
> [   31.278385]         KTAP version 1
> [   31.278386]         # Subtest: test_rmid_idx_encoding
> [   31.278490]         ok 1 max_partid=0, max_pmg=0
> [   31.278604]         ok 2 max_partid=1, max_pmg=4
> [   31.279008]         ok 3 max_partid=3, max_pmg=1
> [   31.279394]         ok 4 max_partid=5, max_pmg=9
> [   31.279777]         ok 5 max_partid=4, max_pmg=4
> [   31.280167]         ok 6 max_partid=100, max_pmg=11
> [   31.358979]         ok 7 max_partid=65535, max_pmg=255
> [   31.358985]     # test_rmid_idx_encoding: pass:7 fail:0 skip:0 total:7
> [   31.358987]     ok 7 test_rmid_idx_encoding
> [   31.358989] # mpam_resctrl_test_suite: pass:7 fail:0 skip:0 total:7
> [   31.358990] # Totals: pass:125 fail:0 skip:0 total:125
> [   31.358992] ok 2 mpam_resctrl_test_suite
> 
> 
> ------
> 
> Best regards,
> Zeng Heng

Thanks,

Ben

