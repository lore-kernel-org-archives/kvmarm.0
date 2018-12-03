From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v9 3/8] KVM: arm/arm64: Introduce helpers to manipulate
 page table entries
Date: Mon, 3 Dec 2018 14:03:11 +0000
Message-ID: <a57e690e-0b93-faf4-9d90-9ba0cc388936@arm.com>
References: <20181031175745.18650-1-punit.agrawal@arm.com>
 <20181031175745.18650-4-punit.agrawal@arm.com>
 <396402d5-fddf-ab72-01c4-80dd1a0d4d44@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <396402d5-fddf-ab72-01c4-80dd1a0d4d44@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anshuman Khandual <anshuman.khandual@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, punitagrawal@gmail.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Anshuman,

On 03/12/2018 13:50, Anshuman Khandual wrote:
> 
> 
> On 10/31/2018 11:27 PM, Punit Agrawal wrote:
>> Introduce helpers to abstract architectural handling of the conversion
>> of pfn to page table entries and marking a PMD page table entry as a
>> block entry.
> 
> Why is this necessary ? we would still need to access PMD, PUD as is
> without any conversion. IOW KVM knows the breakdown of the page table
> at various levels. Is this something required from generic KVM code ?

The KVM MMU code is shared for arm32 and arm64. Hence we need arch specific
helpers to hide how we deal with the levels. e.g, PUD never exists for
arm32.

>    
>>
>> The helpers are introduced in preparation for supporting PUD hugepages
>> at stage 2 - which are supported on arm64 but do not exist on arm.
> 
> Some of these patches (including the earlier two) are good on it's
> own. Do we have still mention in commit message about the incoming PUD
> enablement as the reason for these cleanup patches ?
> 

Cheers
Suzuki
