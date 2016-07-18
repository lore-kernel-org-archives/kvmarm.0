From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v10 15/17] KVM: arm64: implement ITS command queue command
 handlers
Date: Mon, 18 Jul 2016 08:46:45 +0100
Message-ID: <578C8965.9090707@arm.com>
References: <20160715114338.10484-1-andre.przywara@arm.com>
 <20160715114338.10484-16-andre.przywara@arm.com>
 <20160716110815.35f8527e@arm.com>
 <545f7c23-0146-ebd7-b173-be3440c29351@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ED6A41145
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 03:40:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yIIfqW0akeiA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 03:40:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA55C40FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 03:40:43 -0400 (EDT)
In-Reply-To: <545f7c23-0146-ebd7-b173-be3440c29351@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 18/07/16 00:23, Andr=E9 Przywara wrote:
> Hi Marc,
> =

> [...]
> =

>>> +/*
>>> + * Check whether a device ID can be stored into the guest device table=
s.
>>> + * For a direct table this is pretty easy, but gets a bit nasty for
>>> + * indirect tables. We check whether the resulting guest physical addr=
ess
>>> + * is actually valid (covered by a memslot and guest accessbible).
>>> + * For this we have to read the respective first level entry.
>>> + */
>>> +static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its =
*its,
>>> +				     int device_id)
>>> +{
>>> +	u64 r =3D its->baser_device_table;
>>> +	int nr_entries =3D GITS_BASER_NR_PAGES(r) * SZ_64K;
>>> +	int index;
>>> +	u64 indirect_ptr;
>>> +	gfn_t gfn;
>>> +
>>> +
>>> +	if (!(r & GITS_BASER_INDIRECT))
>>> +		return device_id < (nr_entries / GITS_BASER_ENTRY_SIZE(r));
>>> +
>>> +	/* calculate and check the index into the 1st level */
>>> +	index =3D device_id / (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
>>> +	if (index >=3D (nr_entries / sizeof(u64)))
>>> +		return false;
>>> +
>>> +	/* Each 1st level entry is represented by a 64-bit value. */
>>> +	if (!kvm_read_guest(kvm,
>>> +			    BASER_ADDRESS(r) + index *
>>> sizeof(indirect_ptr),
>>> +			    &indirect_ptr, sizeof(indirect_ptr)))
>>> +		return false;
>>
>> Careful. The ITS tables are written in LE format, so you need a
>>
>> 	indirect_ptr =3D le64_to_cpu(indirect_ptr);
>>
>> to cater for the LE-on-BE case.
> =

> Oh right, endianness. Thanks for pointing that out!
> =

>>
>>> +
>>> +	/* check the valid bit of the first level entry */
>>> +	if (!(indirect_ptr & BIT_ULL(63)))
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * Mask the guest physical address and calculate the frame number.
>>> +	 * Any address beyond our supported 48 bits of PA will be caught
>>> +	 * by the actual check in the final step.
>>> +	 */
>>> +	gfn =3D (indirect_ptr & GENMASK_ULL(51, 16)) >> PAGE_SHIFT;
>>
>> Another gotcha: Here, you're only checking for the CPU page that covers
>> the beginning of the ITS page. If the CPU page size is smaller, you may
>> end-up being out of bounds. You need something like:
>>
>> 	l2_index =3D device_id % (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
>> 	gfn =3D ((indirect_ptr & GENMASK_ULL(51, 16)) +
>> 	       l2_index * GITS_BASER_ENTRY_SIZE(r)) >> PAGE_SHIFT;
>>
>> so that you check the presence of the actual location you're virtually
>> touching.
> =

> Right, that nasty case came to me as well after sending the patches.
> I had something like "gfn +=3D ...." plus a comment in mind, but that's
> purely cosmetical.
> =

> So do you want me to send out another version with those fixes (and
> possibly the usage of vgic_get_irq_kref() above)?
> =

> Are there more comments?

Plenty. But we're running out of time, so I've queued the series as is,
and I'm stacking fixes on top of them. I'll post something today.

Thanks,

	M.
-- =

Jazz is not dead. It just smells funny...
