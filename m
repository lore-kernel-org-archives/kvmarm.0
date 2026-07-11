Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38032315793
	for <kvmarm@lists.linux.dev>; Sat, 11 Jul 2026 06:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783750773; cv=none; b=BU1gGB4K38v7tPQOGAU06nFQ2Dv/8CbbMBPdd8DptlIlZq+uHFCfL02KwmjK82Ocx/HJRmfeiP0i/k1puYjK+LbRONaRfGxLf4qD6ydee7q/dcwEsFVVxczifCEl2/a42fu2rymHz3NpKllVfkMR9oeIrPwTb0vag66GTBqWXcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783750773; c=relaxed/simple;
	bh=bVka9Y/pxBnfhMrcVcpVcQlHeE4oraJ+VZOP20yHSxk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NTe85MnMn+Un5+7FrkFtAf72D6GsB/9LRC361jinQB7nw6idj416GjZ6CNtDbHleaKMXVvczcf94sc8kr9wQpJHgYEWkNpmAcuyB1e8q6glA41tNZG90n7rITQDFna+7HDLR/i4cwhOmhTtYzpOdfrVJzEiMNgmjtl3dLju/1fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=TIktfliC reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="TIktfliC"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66B6IoIf015927
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 11 Jul 2026 15:18:50 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=jhPYci9Dt8OvtEtcy4b+McdMFRjiobjic+3G8cI6QZI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1783750731; v=1;
        b=TIktfliCWLwpd/+swlM0LiA65CD4UnKwP+vi5ebo48IQszOhpbBoisXZWlKlE/dX
         uAHImhHe1u8Zjp9F1SsNkKIkUb/AXZ9u8Z7NdTlKN2jqD5SOEswuQpbbITyDpknr
         bQMy8wc6V8eb3bRh5OuNVsh/Fytdus3Lti0kugfIaALxVXZL20RQVbBjguL04sMs
         aXEazALRVK84+npwac+koioVcBKj9dDnwEKFkIHUTtN1H8w/Ua72wDLMM7mvGBzF
         WYg5KFzUg1+rIbfhz4gWL1L0e/OW6ioPVpTinpDdvu87eF5MyhfkfpurgzIcIBhd
         q2uPRk28yyDaK3zl+/06dA==
Message-ID: <0e5e64ea-2f3c-4ce6-88ac-08b66f13027c@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 11 Jul 2026 15:18:50 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/7] KVM: arm64: Disallow vPMU when pPMUs do not cover
 all CPUs
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-1-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <akvgIWqBjAp_VA_A@kernel.org>
 <e03f17b2-a765-4912-adf6-3da26e7eeecd@rsg.ci.i.u-tokyo.ac.jp>
 <ak1DVUs0bgkpZh0N@kernel.org>
 <7bf6c440-5f14-4326-9800-9821adc4e2e4@rsg.ci.i.u-tokyo.ac.jp>
Content-Language: en-US
In-Reply-To: <7bf6c440-5f14-4326-9800-9821adc4e2e4@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/07/08 17:32, Akihiko Odaki wrote:
> On 2026/07/08 3:20, Oliver Upton wrote:
>> On Tue, Jul 07, 2026 at 08:08:03PM +0900, Akihiko Odaki wrote:
>>> On 2026/07/07 2:04, Oliver Upton wrote:
>>>> Hi,
>>>>
>>>> On Mon, Jul 06, 2026 at 07:03:24PM +0900, Akihiko Odaki wrote:
>>>>> Commit ec3eb9ed6081 ("KVM: arm64: PMU: Disallow vPMU on non-uniform
>>>>> PMUVer") made KVM reject vPMU unless the system-wide PMUVer is usable.
>>>>> That covers systems where PMUv3 is absent or non-uniform, as well as
>>>>> systems where IMPDEF PMUv3 sysreg traps are unavailable.
>>>>>
>>>>> However, KVM can still accept vPMU when all CPUs uniformly trap PMUv3
>>>>> sysregs, but the pPMUs registered with KVM only cover a subset of
>>>>> possible CPUs.
>>>>>
>>>>> Reject vPMU unless the registered pPMUs cover every possible CPU.
>>>>> This avoids carrying support for partial pPMU coverage into the
>>>>> fixed-counters-only UAPI introduced later in the series.
>>>>
>>>> Doesn't CPU hotplug screw this up? I could online a CPU that doesn't
>>>> have a PMU after creating the VM.>
>>>> I'd rather just change ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS to become a
>>>> system feature. That way any CPU which breaks the system-wide 
>>>> assumption
>>>> cannot be onlined.
>>>
>>> ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS only says that IMPDEF PMUv3 
>>> sysregs are
>>> trapped. It does not say that KVM has a driver-backed PMU usable for 
>>> PMUv3
>>> emulation. This patch checks that extra requirement.
>>>
>>> I re-checked CPU hotplug. Onlining a CPU without a PMU later does not 
>>> make
>>> an accepted VM unsafe, since the check is against cpu_possible_mask.
>>
>> Sorry, I missed that this was against the possible mask.
>>
>>> The problem is the reverse case on ACPI: this check can disable vPMU 
>>> when a
>>> possible CPU is offline. DT populates supported_cpus at boot, while ACPI
>>> initially populates it only from online CPUs and grows it as matching 
>>> CPUs
>>> come online.
>>>
>>> That makes this patch too conservative. In practice, I do not expect 
>>> systems
>>> to mix CPUs with and without a usable PMU. A better approach is 
>>> probably to
>>> treat such a host as out of spec and add TAINT_CPU_OUT_OF_SPEC. We 
>>> already
>>> do that for architectural PMUv3 by detecting mismatches in
>>> ID_AA64DFR0_EL1.PMUVer; we can do the same for
>>> ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS with non-standard PMUs.
>>
>> The presence of the workaround is, by definition, out of spec. I just
>> never bothered tainting the kernel because these machines are already
>> TAINT_CPU_OUT_OF_SPEC by way of the broken VGIC.
>>
>> Ok, so how about you keep the check that you're doing here and promote
>> IMPDEF_TRAPS to a system-wide feature? That would satisfy the two
>> preconditions we have for PMU emulation, which is system register traps
>> and a backing arm_pmu that understands PMUv3 events.
> 
> This check turned out to be faulty: it can disable PMU emulation on ACPI
> systems when a possible CPU is offline, because ACPI grows
> arm_pmu::supported_cpus as matching CPUs come online.
> 
> My current plan is:
> 
> - drop the possible-mask coverage check, to avoid breaking ACPI;
> - promote ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS to
>    ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE, so the system will have the
>    feature only if all online CPUs implement it;
> - explicitly taint hosts with ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
>    matching what KVM already does for non-architectural VGICs. The
>    comment will make it clear that this is out of spec because KVM cannot
>    make the usual architectural assumptions about PMUv3 sysreg traps and
>    uniform driver-backed PMU availability.

I sent a new revision implementing these changes, but due to a rebase
mistake it was also sent as v8.

However, it still does not cover every case of non-uniform driver-backed
PMU availability. With ACPI, if a CPU is brought online whose MIDR was
not represented by any CPU online during PMU probing, the PMU code
cannot associate it with an existing arm_pmu or register a new one.
This can happen even when PMUVer is uniform across CPUs.

I therefore plan to take a simpler approach: when KVM cannot find a
registered pPMU for the vCPU's current CPU, emit a one-time warning and
set TAINT_CPU_OUT_OF_SPEC, matching the treatment of mismatched CPU
features.

Regards,
Akihiko Odaki

> 
> That lets the code keep assuming uniform PMU availability without adding 
> an ACPI-hostile possible-CPU check, and makes that assumption explicit 
> for humans like me and tools such as Sashiko [1].
> 
> [1] https://sashiko.dev/#/patchset/20260706-hybrid-v8-0- 
> de459617b59d@rsg.ci.i.u-tokyo.ac.jp?part=6
> 
> Regards,
> Akihiko Odaki
> 

