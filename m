Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6BB14285
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F308E143D;
	Fri, 20 Oct 2023 08:23:12 -0700 (PDT)
Received: from [10.1.30.154] (XHFQ2J9959.cambridge.arm.com [10.1.30.154])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A99B13F762;
	Fri, 20 Oct 2023 08:22:30 -0700 (PDT)
Message-ID: <2a1c314b-1fa4-47ac-a977-fba1ce06d614@arm.com>
Date: Fri, 20 Oct 2023 16:22:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm
 s2
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
 <867cnhmun2.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <867cnhmun2.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2023 11:54, Marc Zyngier wrote:
> Hi Ryan,
> 
> On Mon, 09 Oct 2023 19:49:56 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> Hi All,
>>
>> This adds support for FEAT_LPA2 to KVM for both hypervisor stage 1 (for the
>> nvhe/protected modes) and the vm stage 2 translation tables (for all modes).
>> FEAT_LPA2 enables 52 bit PAs and VAs for 4KB and 16KB granules (note this is
>> already supported for 64KB granules via the FEAT_LPA and FEAT_LVA extensions).
>> The series does not include support for FEAT_LPA2 in the kernel stage 1. This
>> support is provided separately by Ard Biesheuvel's series at [4]. The two series
>> are mostly independent.
>>
>> This is a small update from v3, rebased onto v6.6-rc5 and incorporating some
>> minor changes based on review comments from Oliver.
>>
>> NOTE: I've included my patch to update the range-based tlbi functions to work
>> with LPA2 in this version, because KVM has started using range-based tlbi
>> invalidation as of v6.6-rc1. I've done this in such a way that KVM-originated
>> calls will use the LPA2 format if LPA2 is in use by KVM, but the
>> kernel-originated calls are hardcoded to never use the LPA2 format. If merging
>> with Ard's series, you will need to update the 2 calls to __flush_tlb_range_op()
>> from __flush_tlb_range() appropriately.
>>
>>
>> Testing
>> =======
>>
>> Testing has been done exclusively on the FVP and covers my boot matrix tests
>> and kvm selftests.
>>
>> The host/guest config boot matrix gives the same (expected) results as for the
>> v3 submission; of 180 conifgs, 12 fail, and these are all due to attempting to
>> load the host kernel into high memory which isn't expected to work until the
>> kernel has FEAT_LPA2 support for its stage 1. (refer to v1 posting for details
>> on the exact configs).
>>
>> KVM selftests have been enhanced to support P52V48 4K and 16K guest modes, and
>> all tests have been run against a P48V48_4K host and a P52V52_4K host (a run
>> takes about 10 hours on FVP, sigh, but I can test a few more host configs if
>> useful).
> 
> Have you tried with the (brand new) "arm64_sw.hvhe=1" command-line
> option, which enables VHE for the EL2 hypervisor only? I expect things
> to work, but it would be good to make sure...

No, I haven't tried. I did notice it when I rebased but convinced myself that it
doesn't affect the page table stuff. I'm happy to give it a spin once I've
rebased to v6.7-rc1 though.

> 
>> All tests pass except "memslot_perf_test", which fails due to a timeout
>> while syncing. This test fails in the same way for plain v6.6-rc1, so I'm
>> confident this is not a regression caused by this series. (the issue is that
>> alarm(2) is issued and the signal is received before alarm(0) is issued. I
>> expect this is an FVP-time related problem, although I'm not sure how to fix
>> robustly for the FVP without potentially hanging real systems for long periods
>> of time).
> 
> [...]
> 
> This is starting to look good, and I only had pretty minor comments on
> this series so far. It is too late for 6.7, but if you can respin it
> for -rc1, I'll happily review it again and queue it for 6.8 if things
> keep looking OK.

Thanks for the review! This all sounds great to me. I'll probably wait for
v6.7-rc1 and do the rebase, fix up all your comments and do the benchmarking
then repost.

Thanks,
Ryan


> 
> Thanks,
> 
> 	M.
> 

