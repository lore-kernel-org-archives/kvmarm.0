Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F06232E696;
	Thu, 21 May 2026 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376536; cv=none; b=sfofNqL977+zqdS0gXwoGHNj6uQ2W/lT2pYCIfWVhCpuMZMAVmGoRyR7X7CTcOx77sMGBSOahZLCgSlJFe17ezYvM8/WpQlmG+2lgJPAaRWdeL2kBH+ElZEAwtHpty/jU6FIKzWbJ1HSWFD8x1ymRKb1M7gUIhceTqN36q7Cws0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376536; c=relaxed/simple;
	bh=3y9ZG7S7MPMGSv9tY2zvWNHcxtxTfvmCabG0wclRyUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8JEou7UhRxX9H8ffjGwCZSGoBvcioNQkqO+tBgiTcvFxWY+zYmCLnMw0N45sUUUJiCorjk5npqRrdWuhadZzCl1RvQwePXSfS1/ANGEk643cxwjEjc+Vsk/3/jYlrFh7nt9XUCzwzrz0iEZghQW0vgCJZEpp/ph73wEqeN3b54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q1p85n1d; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q1p85n1d"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C34523AEC;
	Thu, 21 May 2026 08:15:28 -0700 (PDT)
Received: from [10.1.32.22] (e122027.cambridge.arm.com [10.1.32.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA9FD3F7B4;
	Thu, 21 May 2026 08:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779376533; bh=3y9ZG7S7MPMGSv9tY2zvWNHcxtxTfvmCabG0wclRyUE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q1p85n1dcwPlMDtm8GdOza6yOXj63L2mykIMJpBURkQ3sysBkNbyYuFr9BsBKd1OU
	 VB0Uo0SpRNAZADbxgmAphDwkA2FHnTiT+vONs/AL+7JTIcmbyN92nTu0GHcKvJqFl1
	 NSWjOb+jH1lt2GmNYWfXACP1a0vtMHmh86KGQJ3U=
Message-ID: <82e39e69-a344-4330-a8dd-7073b005a6e5@arm.com>
Date: Thu, 21 May 2026 16:15:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/44] arm64: RME: Handle Granule Protection Faults
 (GPFs)
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-4-steven.price@arm.com> <86fr3lvtk3.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86fr3lvtk3.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/05/2026 13:25, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:11 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> If the host attempts to access granules that have been delegated for use
>> in a realm these accesses will be caught and will trigger a Granule
>> Protection Fault (GPF).
>>
>> A fault during a page walk signals a bug in the kernel and is handled by
>> oopsing the kernel. A non-page walk fault could be caused by user space
>> having access to a page which has been delegated to the kernel and will
>> trigger a SIGBUS to allow debugging why user space is trying to access a
>> delegated page.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v10:
>>  * Don't call arm64_notify_die() in do_gpf() but simply return 1.
>> Changes since v2:
>>  * Include missing "Granule Protection Fault at level -1"
>> ---
>>  arch/arm64/mm/fault.c | 28 ++++++++++++++++++++++------
>>  1 file changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 0f3c5c7ca054..6358ea4787ba 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -905,6 +905,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>>  	return 0;
>>  }
>>  
>> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	const struct fault_info *inf = esr_to_fault_info(esr);
>> +
>> +	die_kernel_fault(inf->name, far, esr, regs);
>> +	return 0;
>> +}
>> +
>> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
>> +		return 0;
>> +
>> +	return 1;
>> +}
>> +
>>  static const struct fault_info fault_info[] = {
>>  	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
>>  	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
>> @@ -941,12 +957,12 @@ static const struct fault_info fault_info[] = {
>>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 32"			},
>>  	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
>>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 34"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 35"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 36"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 37"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 38"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 39"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 40"			},
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level -1" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 0" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 1" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 2" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 3" },
>> +	{ do_gpf,		SIGBUS,  SI_KERNEL,	"Granule Protection Fault not on table walk" },
> 
> It wouldn't hurt to align the textual description with what we have
> for other fault syndromes:
> 
> 	"level X granule protection fault (translation table walk)"
> 
> for the PTW-trigger faults, and
> 
> 	"granule protection fault"
> 
> for the non PTW case.

Sure, no problem.

Thanks,
Steve

> 
> Thanks,
> 
> 	M.
> 

