Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794209819;
	b=CCfpUSWVWHdruNvI6pkWhFvzLsZbWJbeS7ewU2FlY+JV99kWU+luPcmnljJ/U86Wd/KW
	 t7QYI3scR05YRWU+ScbaVcJGtdf6BjZvCK0RgwDLe2lpFC4CKor4UkmcfiLAyMNa0TXnu
	 WlfY+rHxsgOvDg0mEiuoY6eBpl8XKcZ/9bmgmVkHFuGucBVyhUVehdyqWTcyvILSgxFtV
	 /68fd4ESM/Qhfc/04ySmfp8Zag9RBXBqoCUOz+BhtXN+jl70R/W+JFfmjVm97Bic925Sg
	 zmhAbBSBmTOcdMMT+o+Bgchd4CH2lMZd2qqZtEZI4zJR12SgvB+YigQ6dLfmW68QuOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209819;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=G4nBFLLn9aTpi8EYPD+/txX6SYamUtAxL+qhanQmPFg=;
	b=TfO/+bLF06Unv3BaOizK7J8X4oRIrbCljhYSIL3p17KbAr6lyJuyeSuZbm9yHlSb0/hx
	 t2yRda7I1UNc3wbAGVp+voKXEXPWtIy5luOs1Rxi4uvWnFXvS4XP+RuXb/jgvfiHUoPf1
	 qAaF9joMbFJ/sE4SNpwMHeSNEk+/tVxag6/7i/m4TUCrotSMA0Z7DAEOFYdBzeiBBunp8
	 a365W/EtIQoDtQSIXJWN76xCiVzuwr0qQc0OPfHQeJhe4N3l4CWewARZskQE7wYklz4sG
	 3DnWblVKn7ew02eD4/UFW132I3tG1Aara24X2YvkOvUqdUtXjitDCNMhBaYFczMb0+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="rJx/DI7/";
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1657606A325;
	Mon,  9 Nov 2026 07:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1657606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=rJx/DI7/
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=G4nBFLLn9aTpi8EYPD+/txX6SYamUtAxL+qhanQmPFg=;
	b=rJx/DI7/7jyPGgtfe8sKV6MCg5NTjxXm9S7Sr7f2MZieYDFz9wMxTwMLI11Gznr74bJx2I6FI
	dmK3xxAryxFhyKChIvhogErkMu1H8UATMKhnc3GdozgYlojG0mE9YadyoY43LRXAyarkjlGNUAI
	ech2wm5r/nRUcYAv+YekKt8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jNM6d38qSzLlSJ;
	Mon,  9 Nov 2026 15:36:41 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 5AE314055B;
	Mon,  9 Nov 2026 15:36:55 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 15:36:54 +0800
Message-ID: <f50df691-b935-41c7-b2bd-91a5288bab75@huawei.com>
Date: Mon, 9 Nov 2026 15:36:54 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/15] KVM: arm64: Handle HDBSS faults
To: <sashiko-reviews@lists.linux.dev>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, liuyonglong
	<liuyonglong@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-10-zhengtian10@huawei.com>
 <20260929105348.E3CB21F000FF@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260929105348.E3CB21F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/29/2026 6:53 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] arm64: KVM checks DABT-specific HDBSSF bit on Instruction Aborts
> - [High] KVM: guest-reachable WARN_ON_ONCE assertions in HDBSS fault handler
> --
> 
> commit 93c9cd523cd96ee876cb40ad4d3ecad32cc8aeff
> Author: Eillon <yezhenyu2@huawei.com>
> 
> KVM: arm64: Handle HDBSS faults
> 
> This commit introduces handling for hardware stopped promoting writable-clean
> descriptors, which raises a stage-2 Permission fault with ESR_EL2.ISS2.HDBSSF.
> It dispatches these from kvm_handle_guest_abort() via a new helper to clear
> the fault and report -EFAULT.
> 
>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>> index be0d12555c848..893a8c4248bcc 100644
>> --- a/arch/arm64/kvm/dirty_bit.c
>> +++ b/arch/arm64/kvm/dirty_bit.c
> [ ... ]
>> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 prod;
>> +	u64 fsc;
>> +
>> +	if (WARN_ON_ONCE(!system_supports_hdbss()))
>> +		return -EFAULT;
>> +
>> +	if (WARN_ON_ONCE(!vcpu_hdbss_enabled(vcpu)))
>> +		return -EFAULT;
> 
> [Severity: High]
> Are these WARN_ON_ONCE assertions safe to expose on a guest-reachable path?
> 
> If a guest manages to inadvertently route execution here (for instance, via
> an Instruction Abort matching the HDBSSF bit in its ISS2 field), these
> assertions can be triggered directly by the guest.
> 
> If the host has panic_on_warn enabled, this could lead to a host kernel
> panic and a complete denial of service. Should these be standard error
> returns without the warnings instead?
> 

Invalid. The guest cannot route execution here. ESR_EL2 is synthesized
by hardware on exception entry, so the guest cannot forge the exit ESR
the host sees, and on hardware without HDBSS the ISS2 HDBSSF bit is RES0
and never set. The dispatch only reaches this handler when hardware
itself raised an HDBSS fault.

The guards check host invariants rather than guest input, a boot-time
cpufeature and the VTCR_EL2.HDBSS bit that only the host toggles. If
either fires it is a host bug, and that is what a WARN is for. With
panic_on_warn the admin has chosen to treat any warning as fatal, and
returning a plain error instead would only silence the bug.

>> +
>> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
>> +	fsc = FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
>> +
>> +	if (fsc == HDBSSPROD_EL2_FSC_OK)
>> +		/* Buffer full: the exit path drained it before handle_exit. */
>> +		return 1;
>> +
>> +	if (fsc != HDBSSPROD_EL2_FSC_ExternalAbort &&
>> +	    fsc != HDBSSPROD_EL2_FSC_GPF)
>> +		WARN_ONCE(1,
> 
> [Severity: High]
> Similarly, could this WARN_ONCE be triggered by a guest-driven event?
> 

No, for the same reason. The condition reads the FSC field of
HDBSSPROD_EL2, which hardware fills, so an unexpected value can only
come from the hardware or from a host integration bug, never from
anything the guest did.

>> +			  "Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
>> +			  fsc, prod, vcpu->vcpu_id);
>> +
>> +	/* Clear FSC so hardware dirty state updates can resume. */
>> +	write_sysreg_s(prod & ~HDBSSPROD_EL2_FSC_MASK, SYS_HDBSSPROD_EL2);
>> +	return -EFAULT;
>> +}
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 85a98d2c23a99..7bf82d65041c8 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> [ ... ]
>> @@ -2315,6 +2316,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>   
>>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>>   
>> +	if (esr_iss2_is_hdbssf(esr))
>> +		return kvm_handle_hdbss_fault(vcpu);
>> +
> 
> [Severity: High]
> Does this inadvertently check the HDBSSF bit for Instruction Aborts?
> 
> The esr_iss2_is_hdbssf() helper in arch/arm64/include/asm/esr.h extracts
> the ISS2 bit without verifying the Exception Class. Because the ISS layout
> is per-EC, an Instruction Abort's ISS2 field might coincidentally have this
> bit set for an entirely unrelated reason.
> 
> If that happens, a valid Instruction Abort would be misidentified as a
> HDBSS fault, routing execution into kvm_handle_hdbss_fault() and causing
> guest breakage. Should this check be gated by !is_iabt or a specific
> Exception Class check?
> 

Invalid.

The guest cannot route execution here. ESR_EL2 is synthesized by
hardware on exception entry, so the guest cannot forge the exit ESR the
host sees, and on hardware without HDBSS the ISS2 HDBSSF bit is RES0 and
never set. The dispatch only reaches this handler when hardware itself
raised an HDBSS fault.

The guards check host invariants rather than guest input: a boot-time
cpufeature and the VTCR_EL2.HDBSS bit that only the host toggles. If
either fires it is a host bug, and that is what a WARN is for. With
panic_on_warn the admin has chosen to treat any warning as fatal, and
returning a plain error instead would only silence the bug.

Thanks,
Tian


