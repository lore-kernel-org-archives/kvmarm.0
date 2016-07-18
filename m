From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH v10 15/17] KVM: arm64: implement ITS command queue command
 handlers
Date: Mon, 18 Jul 2016 08:45:01 +0100
Message-ID: <39d146e9-f234-0ea0-9cbf-a8b27f55c32f@arm.com>
References: <20160715114338.10484-1-andre.przywara@arm.com>
 <20160715114338.10484-16-andre.przywara@arm.com>
 <20160716110815.35f8527e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160716110815.35f8527e@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 16/07/16 11:08, Marc Zyngier wrote:
> On Fri, 15 Jul 2016 12:43:36 +0100
>> +/*
>> + * Check whether a device ID can be stored into the guest device tables.
>> + * For a direct table this is pretty easy, but gets a bit nasty for
>> + * indirect tables. We check whether the resulting guest physical address
>> + * is actually valid (covered by a memslot and guest accessbible).
>> + * For this we have to read the respective first level entry.
>> + */
>> +static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its *its,
>> +				     int device_id)
>> +{
>> +	u64 r = its->baser_device_table;
>> +	int nr_entries = GITS_BASER_NR_PAGES(r) * SZ_64K;
>> +	int index;
>> +	u64 indirect_ptr;
>> +	gfn_t gfn;
>> +
>> +
>> +	if (!(r & GITS_BASER_INDIRECT))
>> +		return device_id < (nr_entries / GITS_BASER_ENTRY_SIZE(r));
>> +
>> +	/* calculate and check the index into the 1st level */
>> +	index = device_id / (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
>> +	if (index >= (nr_entries / sizeof(u64)))
>> +		return false;
>> +
>> +	/* Each 1st level entry is represented by a 64-bit value. */
>> +	if (!kvm_read_guest(kvm,
>> +			    BASER_ADDRESS(r) + index *
>> sizeof(indirect_ptr),
>> +			    &indirect_ptr, sizeof(indirect_ptr)))
>> +		return false;
> 
> Careful. The ITS tables are written in LE format, so you need a
> 
> 	indirect_ptr = le64_to_cpu(indirect_ptr);
> 
> to cater for the LE-on-BE case.

Oh right, endianness. Thanks for pointing that out!

>> +
>> +	/* check the valid bit of the first level entry */
>> +	if (!(indirect_ptr & BIT_ULL(63)))
>> +		return false;
>> +
>> +	/*
>> +	 * Mask the guest physical address and calculate the frame number.
>> +	 * Any address beyond our supported 48 bits of PA will be caught
>> +	 * by the actual check in the final step.
>> +	 */
>> +	gfn = (indirect_ptr & GENMASK_ULL(51, 16)) >> PAGE_SHIFT;
> 
> Another gotcha: Here, you're only checking for the CPU page that covers
> the beginning of the ITS page. If the CPU page size is smaller, you may
> end-up being out of bounds. You need something like:
> 
> 	l2_index = device_id % (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
> 	gfn = ((indirect_ptr & GENMASK_ULL(51, 16)) +
> 	       l2_index * GITS_BASER_ENTRY_SIZE(r)) >> PAGE_SHIFT;
> 
> so that you check the presence of the actual location you're virtually
> touching.
>

Right, that nasty case came to me as well after sending the patches.
I had something like "gfn += ...." plus a comment in mind, but that's
purely cosmetical.

So do you want me to send out another version with those fixes (and
possibly the usage of vgic_get_irq_kref() above)?

Are there more comments?

Cheers,
Andre.

