Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A812FC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 17:27:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 480C460EE9
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 17:27:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 480C460EE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAF374B1F8;
	Mon, 18 Oct 2021 13:27:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L+SK4VmqFdlV; Mon, 18 Oct 2021 13:27:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 450D84B24B;
	Mon, 18 Oct 2021 13:27:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B38E4B1F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 13:27:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FlkbUylpscHm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 13:27:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 243694B1DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 13:27:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC7D92F;
 Mon, 18 Oct 2021 10:27:00 -0700 (PDT)
Received: from [10.1.196.28] (eglon.cambridge.arm.com [10.1.196.28])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 203F53F694;
 Mon, 18 Oct 2021 10:27:00 -0700 (PDT)
Subject: Re: [RFC PATCH 4/7] arm64: cpufeature: Enable PBHA bits for stage1
To: Marc Zyngier <maz@kernel.org>
References: <20211015161416.2196-1-james.morse@arm.com>
 <20211015161416.2196-5-james.morse@arm.com> <87bl3pulhd.wl-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <40dfabe4-47aa-49be-a37d-f17a47028c1e@arm.com>
Date: Mon, 18 Oct 2021 18:26:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87bl3pulhd.wl-maz@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On 16/10/2021 14:50, Marc Zyngier wrote:
> On Fri, 15 Oct 2021 17:14:13 +0100,
> James Morse <james.morse@arm.com> wrote:
>>
>> If the CPUs support HPDS2, and there is a DT description of PBHA values
>> that only affect performance, enable those bits for both TTBR0 and TTBR1.
>>
>> Enabling PBHA requires the hierarchical-permissions to be disabled.
>> Commit 87143f404f33 ("arm64: mm: use XN table mapping attributes for
>> the linear region") used these, but only as an optimisation.
>>
>> Only the necessary PBHA bits are enabled to reduce the risk of an
>> unsafe bit/value being used by accident.

>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 8694f9dec5e5..548c6f96a878 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c

>> @@ -1676,6 +1679,71 @@ static bool has_hw_dbm(const struct arm64_cpu_capabilities *cap,

>> +static bool plat_can_use_pbha_stage1(const struct arm64_cpu_capabilities *cap,
>> +				     int scope)
>> +{
>> +	u8 val;
>> +	struct device_node *cpus;
>> +	const u8 *perf_only_vals;
>> +	int num_perf_only_vals, i;
>> +
>> +	if (!has_cpuid_feature(cap, scope))
>> +		return false;
>> +
>> +	/*
>> +	 * Calls with scope == SCOPE_LOCAL_CPU need only testing whether this
>> +	 * cpu has the feature. A later 'system' scope call will check for a
>> +	 * firmware description.
>> +	 */
>> +	if (scope == SCOPE_LOCAL_CPU)
>> +		return true;
>> +
>> +	cpus = of_find_node_by_path("/cpus");
>> +	if (!cpus)
>> +		goto done;
>> +
>> +	perf_only_vals = of_get_property(cpus, "arm,pbha-performance-only",
>> +					 &num_perf_only_vals);
>> +	if (!perf_only_vals)
>> +		goto done;
>> +
>> +	/* any listed value is usable at stage 1 */
>> +	for (i = 0 ; i < num_perf_only_vals; i++) {
>> +		val = perf_only_vals[i];
>> +		if (val > 0xf)
>> +			continue;
>> +
>> +		pbha_stage1_enable_bits |= val;
>> +		set_bit(val, &arm64_pbha_perf_only_values);
>> +	}

> Somehow, this would need to be exposed to userspace so that a VMM
> could tell a guest what it can use.

I'm assuming any user is very soc-specific... but it would help the VMM to know.

I guess KVM could return the bitmap as KVM_CAP_PBHA. There is no way to tell the VMM what
the bits do, as that is imp-def...


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
