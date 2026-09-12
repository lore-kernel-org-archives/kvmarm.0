Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC9E384CD4
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 19:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241813; cv=none; b=Y6b/sxXF/tNO/oN1ndV7tFeipeAVTr+iZ9GhiQxMM15rEuMhGuO4lPF+6hN1JBJKFZYKfZfp9N1jEBFzsUOz2nkvhMGnkhu8Ti7cTZrfRk5f6Zh3VpAfvo0cQe8IoPG4iiELzl2JyQ9i+iEDO1Fix7H0wQXzPfIg9C3A62BvbQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241813; c=relaxed/simple;
	bh=BQEwAcV6yBvqR/Rm9ao7rHvQeRgAxg5IJk34c7tnROs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMeXw5Df7l7i+bIOjhJJIxjQ8i+gBnyT/ttKF2MYapZeCUIWI8PoaSR3SPELr8iRIERgQdy+794sr3hocc3qvYK1f3zZMiUnsCzE+OJTFYpAnvsfVPIZapxys7uASdw1VNTMGx634XtE21B8kCeQ7iniTuau9KSVjcL/uKb4clU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mS3NSRnY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mS3NSRnY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB2D01682;
	Sat, 12 Sep 2026 12:36:45 -0700 (PDT)
Received: from [10.57.6.4] (unknown [10.57.6.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E68DA3F59E;
	Sat, 12 Sep 2026 12:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789241809; bh=BQEwAcV6yBvqR/Rm9ao7rHvQeRgAxg5IJk34c7tnROs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mS3NSRnYasGW4ACH73iZryOLWuopBvUfLoWiwm26U1+pKLJCyj6JdYx7Zzxl7uoGS
	 UGGBA5Wpoem8zi76QHWOIf8dLmTRxQ5EkBGXjza7btgkma1Dml49xMevnygDze1ZWR
	 Jzq1bqjaDwnd0vI2zoquBS31p3yzsfGNjEI95z3g=
Message-ID: <c53c18dd-1f4c-4afd-a7e6-bebf4a2af872@arm.com>
Date: Sat, 12 Sep 2026 20:36:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 1/5] arm64: Do not abort on register-dump failures
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon
 <will@kernel.org>, Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-2-fuad.tabba@linux.dev>
 <3bb3d57a-1862-4645-a5e2-789d70e9fc73@arm.com>
 <CA+EHjTwCs8B4du2=rAdoTOpOfh64p5cbW902e5g0u6NZT=r=gA@mail.gmail.com>
 <CA+EHjTx5N1x5GzyHK62WqMnxtG3+=qejMZ36Oc1QkwJEUZgRAw@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTx5N1x5GzyHK62WqMnxtG3+=qejMZ36Oc1QkwJEUZgRAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/09/2026 15:02, Fuad Tabba wrote:
> On Sat, 12 Sept 2026 at 14:54, Fuad Tabba <fuad.tabba@linux.dev> wrote:
>>
>> Hi Suzuki,
>>
>> On Sat, 12 Sept 2026 at 08:33, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>
>>> On 31/08/2026 20:24, Fuad Tabba wrote:
>>>> kvm_cpu__show_registers() and kvm_cpu__show_code() read the vCPU's core
>>>> registers with KVM_GET_ONE_REG, and die() if the ioctl fails. Both are
>>>> diagnostics. They run from the KVM_EXIT_DEBUG case in kvm_cpu__start(),
>>>> from the "lkvm debug -d" dump path in handle_sigusr1(), and from the
>>>> panic dump in kvm_cpu_thread().
>>>>
>>>> Once a protected vCPU has run, its registers belong to the guest and
>>>> KVM_GET_ONE_REG returns -EPERM. Dying on that turns a diagnostic into a
>>>> VMM abort.
>>>
>>> Marc once suggested that these could always succeed with junk values for
>>> protected/Realm VMs. Do you think that is an option for pKVM ?
>>
>> It's possible, the host copy is still there, but I'd rather not. Once
>> the vCPU has run that copy is a mix rather than junk: the boot state
>> the VMM wrote, plus what the exit handlers copy out (the PSTATE mode,
>> x0 for an MMIO write, x0 to x2 for a forwarded PSCI call). A dump
>> would show a live PSTATE beside the PC from boot, and the VMM has no
>> way to distinguish them. With the error it prints that the state is
>> unavailable, which is what this patch does.
>>
>> It's also what the tree does for protected state elsewhere: s390
>> returns -EINVAL from KVM_GET/SET_ONE_REG on a protected VM, and x86
>> does the same from the register ioctls for the SEV-ES VM type, SNP and
>> TDX. Legacy SEV-ES is the one place that succeeds silently, kept for
>> backwards compatibility, and the commit that added the errors
>> (517987e3fb19) describes that as a problem. Sean's rationale for TDX:
>> KVM can't provide sane data, so it's userspace's job not to ask for it
>> [1].
>>

Thanks, I am aware of this. I will leave the decision to Marc.
For the record, for CCA we use GET_ONE_REG/SET_ONE_REG to configure
the SVE vector length, PMU Counter and the Debug HW BPRs and watch
points.
>>>
>>> If we go with this approach :
>>>
>>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Thanks, I'll add the tag. :)
> 
> Unless I misunderstood what "this" refers to exactly, please shout if
> that's the case, or continue the discussion :)

You got it right. I meant if we are happy to go with approach in the
patch.

