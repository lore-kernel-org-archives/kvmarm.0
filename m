From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Remove VLA usage
Date: Mon, 9 Jul 2018 11:47:44 +0100
Message-ID: <f213e03a-66a6-0c07-7bb8-2061b9c24731@arm.com>
References: <20180629184618.GA37364@beast>
 <19f9ddb1-6009-850c-1949-3a8cdacdd2fc@redhat.com>
 <CAGXu5jJcqMX7HjvgqcR37jnuN48PtyHd+VVmfcQH6YfXXSpO_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJcqMX7HjvgqcR37jnuN48PtyHd+VVmfcQH6YfXXSpO_g@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Auger Eric <eric.auger@redhat.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>, Andre Przywara <andre.przywara@arm.com>, LKML <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi kees,

On 02/07/18 18:15, Kees Cook wrote:
> On Mon, Jul 2, 2018 at 12:36 AM, Auger Eric <eric.auger@redhat.com> wrote:
>> Hi Kees,
>>
>> On 06/29/2018 08:46 PM, Kees Cook wrote:
>>> In the quest to remove all stack VLA usage from the kernel[1], this
>>> switches to using a maximum size and adds sanity checks. Additionally
>>> cleans up some of the int-vs-u32 usage and adds additional bounds checking.
>>> As it currently stands, this will always be 8 bytes until the ABI changes.
>>>
>>> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>>
>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Eric Auger <eric.auger@redhat.com>
>>> Cc: Andre Przywara <andre.przywara@arm.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: kvmarm@lists.cs.columbia.edu
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 19 +++++++++++++++----
>>>  1 file changed, 15 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 4ed79c939fb4..3143fc047fcf 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -168,8 +168,14 @@ struct vgic_its_abi {
>>>       int (*commit)(struct vgic_its *its);
>>>  };
>>>
>>> +#define ABI_0_ESZ    8
>>> +#define ESZ_MAX              ABI_0_ESZ
>>> +
>>>  static const struct vgic_its_abi its_table_abi_versions[] = {
>>> -     [0] = {.cte_esz = 8, .dte_esz = 8, .ite_esz = 8,
>>> +     [0] = {
>>> +      .cte_esz = ABI_0_ESZ,
>>> +      .dte_esz = ABI_0_ESZ,
>>> +      .ite_esz = ABI_0_ESZ,
>>>        .save_tables = vgic_its_save_tables_v0,
>>>        .restore_tables = vgic_its_restore_tables_v0,
>>>        .commit = vgic_its_commit_v0,
>>> @@ -180,10 +186,12 @@ static const struct vgic_its_abi its_table_abi_versions[] = {
>>>
>>>  inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
>>>  {
>>> +     if (WARN_ON(its->abi_rev >= NR_ITS_ABIS))
>>> +             return NULL;
>>>       return &its_table_abi_versions[its->abi_rev];
>>>  }
>>>
>>> -int vgic_its_set_abi(struct vgic_its *its, int rev)
>>> +static int vgic_its_set_abi(struct vgic_its *its, u32 rev)
>>>  {
>> if vgic_its_get_abi is likely to return NULL, don't we need to check abi
>> != NULL in all call sites.
> 
> My thinking was that since it should never happen, a WARN_ON would be
> sufficient. But I can drop all these changes if you want. I just
> wanted to see the VLA removed. :)

Are you going to respin this patch limiting it to just the VLA changes?
I'm actively queuing stuff for the next merge window, and it'd be good
to get that one in.

Alternatively, I can drop the WARN_ONs myself. Just let me know.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
