Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755E922173D;
	Thu, 30 Jul 2026 06:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391977; cv=none; b=CzaerjcuUJAOb3QUcl6uKZlPnXNWOfmvtD18k6MpQf1hz73FoNQ1DWYygQtjYWtaJmRq9cbmUyVsImIvGUHn8WJrjYS6cn+zgL+THVeCZRAt3nzhjf/e/n6ePLyRnn3oMakxHuYLWLa9+mkhh9FQy5tNsRk8/hvK3iUFyRtk2AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391977; c=relaxed/simple;
	bh=YFqutATzvWW3QhWPijZMXK8XnQAj6npn9DNtjLf0fiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t/yhGBbO9ZyqcEEF7NwnsECcQNmMM8ZYLDdABjqT0Mlz+p2iWQkm2IwCGDC1qXXYyZ+NNABi5hQhEdwUXfPciYWEAUcPMnYqaISPuKrA4tqN5GUXv1zC4GsIchq0op50IEWjvQ7P0RgpcNjnKfcj6CrTSZUYYtHbldSVOmJTt3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=g4mYVPBg; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="g4mYVPBg"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66U6CR9m046685
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 30 Jul 2026 15:12:28 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=IxvgiNswdCOoQeTRoc+gtTiY6gk3P0ppOIXfC98pabY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1785391948; v=1;
        b=g4mYVPBgZ6/VEOl3aEKX6lxTwG9h5eZqOnWULx+nJy98XE15l+LXU4IOurFaoeMC
         hVT4LAcR8dgerOlEA5/GivwizToqLUTXwAmt4J/ZXnqSmQrk8e5hgDmNnR8FuS/v
         EXm2MzUDNzFDwGENJ6X7tzSLzTPsJu09z8LuACuvbVoDMAYxRE9xiHxKrFs88Fgu
         WIufBP9iFfvCMF1Ws0SZTFhFZwiVj9UyLeL0QzOh/w9+nB7niilD4eGsYqBULmd0
         hPWws6zF0J73jjiM7tDPHpAtZgVSNyvYSwjOvy6m4xqOSdXYRAQEixc/wD7GlQYV
         f6IkyitJV2pK+C42vm/CLQ==
Message-ID: <4cf2911c-610e-4cf1-9c42-cc5792265a89@rsg.ci.i.u-tokyo.ac.jp>
Date: Thu, 30 Jul 2026 15:12:26 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/16] arm64: errata: Require Apple IMPDEF PMUv3 traps
 on all CPUs
To: Fuad Tabba <fuad.tabba@linux.dev>, sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        Oliver Upton <oupton@kernel.org>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-9-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720060101.764901F000E9@smtp.kernel.org>
 <CA+EHjTx20tDkJTZ0XhcA24YAeMh6v-vkX2UZvq4oCsk0CrdM5A@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <CA+EHjTx20tDkJTZ0XhcA24YAeMh6v-vkX2UZvq4oCsk0CrdM5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/07/30 1:23, Fuad Tabba wrote:
> On Mon, 20 Jul 2026 at 07:01, <sashiko-bot@kernel.org> wrote:
>>
>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>>
>> New issues:
>> - [Critical] Permitting late CPUs with IMPDEF PMUv3 to boot without enabling hypervisor traps allows untrapped guest access to host PMU registers.
> 
>   The code path is real, but I don't think it's reachable on current
> hardware: impdef_pmuv3_cpus lists both the P-cores and E-cores of
> M1/M2.

Indeed the code path is real, but Sashiko is wrong about its 
consequence. Accessing PMUv3 registers on CPUs with IMPDEF PMU but 
without hypervisor traps enabled is UNDEFINED, so host PMU registers 
won't be accessed. I'll change the patch message to clarify that in the 
next version.

Regards,
Akihiko Odaki

> 
>> Pre-existing issues:
>> - [High] Writes to control-plane system registers in CPU capability enable callbacks lack a mandatory `isb()` instruction.
> 
> No, exception return is a context synchronization event, which happens
> before the effect is consumed.

I agree. No change will be made for this false positive in the next version.

Regards,
Akihiko Odaki

> 
> 
> /fuad
> 
> 
>> --
>>
>> --- Patch [9]: [PATCH v9 09/16] arm64: errata: Require Apple IMPDEF PMUv3 traps on all CPUs ---
>> commit 3e98f085c1f1b418fb0ec6e336b981ba1df07b03
>> Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>>
>> arm64: errata: Require Apple IMPDEF PMUv3 traps on all CPUs
>>
>> This commit changes the ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS erratum to an
>> all-early-CPU capability. It ensures the capability is only advertised if all
>> early CPUs match, aiming to reject late CPUs that miss the capability while
>> permitting late CPUs to have it when the system does not.
>>
>>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>>> index 1995e1198648e..a5ae628204a12 100644
>>> --- a/arch/arm64/kernel/cpu_errata.c
>>> +++ b/arch/arm64/kernel/cpu_errata.c
>>
>> [ ... ]
>>
>>> @@ -1005,7 +1005,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>>        {
>>>                .desc = "Apple IMPDEF PMUv3 Traps",
>>>                .capability = ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
>>> -             .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>>> +             .type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
>>
>> [Severity: Critical]
>> By changing the capability type to ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
>> does this allow a late CPU with IMPDEF PMUv3 to boot without enabling the
>> hypervisor trap if the system lacks the capability system-wide?
>>
>> If an asymmetric system boots without the PMUv3 IMPDEF capability system-wide
>> and a late Apple CPU with the feature is onlined, verify_local_cpu_caps()
>> will permit the CPU. However, because system_has_cap is false, it skips
>> caps->cpu_enable() which leaves HACR_EL2 bit 56 clear.
>>
>> Since KVM relies on this hardware trap to intercept these instructions and
>> inject an UNDEF exception, could this missing trap allow a malicious guest
>> scheduled on the late CPU to execute IMPDEF PMU instructions natively and
>> manipulate host physical PMU state?
>>
>>>                .matches = has_impdef_pmuv3,
>>>                .cpu_enable = cpu_enable_impdef_pmuv3_traps,
>>
>> [Severity: High]
>> This is a pre-existing issue, but do the writes to control-plane system
>> registers in capability enable callbacks require an isb() synchronization
>> barrier?
>>
>> Currently, callbacks like cpu_enable_impdef_pmuv3_traps update SYS_HACR_EL2
>> using sysreg_clear_set_s, and then return immediately without a trailing
>> isb(). Other callbacks like cpu_enable_trap_ctr_access and
>> cpu_enable_cache_maint_trap update sctlr_el1 in a similar way.
>>
>> Under the ARM64 subsystem rules, every write to a control-plane system
>> register must be followed by an isb() as the very next instruction. Since
>> sysreg_clear_set_s does not issue this barrier, returning immediately places
>> the return branch instruction against an architecturally undefined pipeline
>> state. Should these callbacks issue an explicit isb() before returning?
>>
>>>        },
>>
>> --
>> Sashiko AI review · https://sashiko.dev/#/patchset/20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=9
>>

