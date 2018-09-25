From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 11/18] kvm: arm64: Dynamic configuration of VTTBR mask
Date: Tue, 25 Sep 2018 13:56:44 +0200
Message-ID: <6ef42458-f1f2-9b2d-9cb9-4f0d1d0586b8@redhat.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-12-suzuki.poulose@arm.com>
 <15830d79-cfc3-964a-c232-a508758ba1b9@redhat.com>
 <77c89ec4-9e27-92b8-1d7c-91fb98496808@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <77c89ec4-9e27-92b8-1d7c-91fb98496808@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 9/20/18 5:22 PM, Suzuki K Poulose wrote:
> 
> 
> On 20/09/18 15:07, Auger Eric wrote:
>> Hi Suzuki,
>> On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
>>> On arm64 VTTBR_EL2:BADDR holds the base address for the stage2
>>> translation table. The Arm ARM mandates that the bits BADDR[x-1:0]
>>> should be 0, where 'x' is defined for a given IPA Size and the
>>> number of levels for a translation granule size. It is defined
>>> using some magical constants. This patch is a reverse engineered
>>> implementation to calculate the 'x' at runtime for a given ipa and
>>> number of page table levels. See patch for more details.
>>>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Christoffer Dall <cdall@kernel.org>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>>> ---
>>> Changes since V3:
>>>   - Update reference to latest ARM ARM and improve commentary
>>> ---
>>>   arch/arm64/include/asm/kvm_arm.h | 63 +++++++++++++++++++++++++++++---
>>>   arch/arm64/include/asm/kvm_mmu.h | 25 ++++++++++++-
>>>   2 files changed, 81 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_arm.h
>>> b/arch/arm64/include/asm/kvm_arm.h
>>> index 14317b3a1820..3fb1d440be6e 100644
>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>> @@ -123,7 +123,6 @@
>>>   #define VTCR_EL2_SL0_MASK  (3 << VTCR_EL2_SL0_SHIFT)
>>>   #define VTCR_EL2_SL0_LVL1  (1 << VTCR_EL2_SL0_SHIFT)
>>>   #define VTCR_EL2_T0SZ_MASK 0x3f
>>> -#define VTCR_EL2_T0SZ_40B   24
>>>   #define VTCR_EL2_VS_SHIFT  19
>>>   #define VTCR_EL2_VS_8BIT   (0 << VTCR_EL2_VS_SHIFT)
>>>   #define VTCR_EL2_VS_16BIT  (1 << VTCR_EL2_VS_SHIFT)
>>> @@ -140,11 +139,8 @@
>>>    * Note that when using 4K pages, we concatenate two first level
>>> page tables
>>>    * together. With 16K pages, we concatenate 16 first level page
>>> tables.
>>>    *
>>> - * The magic numbers used for VTTBR_X in this patch can be found in
>>> Tables
>>> - * D4-23 and D4-25 in ARM DDI 0487A.b.
>>>    */
>>>
>>> -#define VTCR_EL2_T0SZ_IPA   VTCR_EL2_T0SZ_40B
>>>   #define VTCR_EL2_COMMON_BITS       (VTCR_EL2_SH0_INNER |
>>> VTCR_EL2_ORGN0_WBWA | \
>>>                               VTCR_EL2_IRGN0_WBWA | VTCR_EL2_RES1)
>>>
>>> @@ -175,9 +171,64 @@
>>>   #endif
>>>
>>>   #define VTCR_EL2_FLAGS                     (VTCR_EL2_COMMON_BITS |
>>> VTCR_EL2_TGRAN_FLAGS)
>>> -#define VTTBR_X                             (VTTBR_X_TGRAN_MAGIC -
>>> VTCR_EL2_T0SZ_IPA)
>>> +/*
>>> + * ARM VMSAv8-64 defines an algorithm for finding the translation table
>>> + * descriptors in section D4.2.8 in ARM DDI 0487C.a.
>>> + *
>>> + * The algorithm defines the expectations on the BaseAddress (for
>>> the page
>>> + * table) bits resolved at each level based on the page size, entry
>>> level
>>> + * and T0SZ. The variable "x" in the algorithm also affects the
>>> VTTBR:BADDR
>>> + * for stage2 page table.
>>> + *
>>> + * The value of "x" is calculated as :
>>> + *  x = Magic_N - T0SZ
>>
>> What is not crystal clear to me is the "if SL0b,c = n" case where x get
>> a value not based on Magic_N. Please could you explain why it is not
>> relevant?
> 
> We only care about the "x" for the "entry" level of the table look up
> to make sure that the VTTBR is physical address meets the required
> alignment. In both cases, if SL0 b,c == n, x is (PAGE_SHIFT) iff the
> level you are looking at is not the "entry level". So this should always
> be page aligned, like any intermediate level table.

Oh OK I get it now.
> 
> The Magic value is needed only needed for the "entry" level due to the
> fact that we may have lesser bits to resolve (i.e, depending on your
> PAMax or in other words T0SZ) than the intermediate levels (where we
> always resolve {PAGE_SHIFT - 3} bits. This is further complicated by the
> fact that Stage2 could use different number of levels for a given T0SZ
> than the stage1.
> I acknowledge that the algorithm is a bit too cryptic and I spent quite
> sometime decode it to the formula we use below ;-).
> 
> I could update the comment to :
> 
> /*
>  * ARM VMSAv8-64 defines an algorithm for finding the translation table
>  * descriptors in section D4.2.8 in ARM DDI 0487C.a.
>  *
>  * The algorithm defines the expectations on the translation table
>  * addresses for each level, based on PAGE_SIZE, entry level
>  * and the translation table size (T0SZ). The variable "x" in the
>  * algorithm determines the alignment of a table base address at a given
>  * level and thus determines the alignment of VTTBR:BADDR for stage2
>  * page table entry level.
>  * Since the number of bits resolved at the entry level could vary
>  * depending on the T0SZ, the value of "x" is defined based on a
>  * Magic constant for a given PAGE_SIZE and Entry Level. The
>  * intermediate levels must be always aligned to the PAGE_SIZE (i.e,
>  * x = PAGE_SHIFT).
>  *
>  * The value of "x" for entry level is calculated as :
>  *     x = Magic_N - T0SZ
>  *
Looks OK.

Thank you for the explanation.

Eric
> 
> ...
> 
> Suzuki
> IMPORTANT NOTICE: The contents of this email and any attachments are
> confidential and may also be privileged. If you are not the intended
> recipient, please notify the sender immediately and do not disclose the
> contents to any other person, use it for any purpose, or store or copy
> the information in any medium. Thank you.
