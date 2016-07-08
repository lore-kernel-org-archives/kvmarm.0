From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH v8 06/17] KVM: arm/arm64: VGIC: add refcounting for IRQs
Date: Fri, 8 Jul 2016 14:14:43 +0100
Message-ID: <dc178029-c6d2-32e3-b5a3-aef8cdf9eb33@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-7-andre.przywara@arm.com> <577E6E99.9040003@arm.com>
 <da96b431-11ed-cd7d-fa77-0e261a8ad44c@arm.com> <577F8591.1090502@arm.com>
 <2d0ab9c8-1262-7a7e-fbb2-8f3c42abed66@arm.com> <577FA60A.9080502@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <577FA60A.9080502@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/16 14:09, Marc Zyngier wrote:
> On 08/07/16 13:54, Andr=E9 Przywara wrote:
>> On 08/07/16 11:50, Marc Zyngier wrote:
>>> On 08/07/16 11:28, Andre Przywara wrote:
>>>> Hi,
>>>>
>>>> On 07/07/16 16:00, Marc Zyngier wrote:
>>>>> On 05/07/16 12:22, Andre Przywara wrote:

=2E...

>>>>>> @@ -236,6 +254,7 @@ retry:
>>>>>>  		goto retry;
>>>>>>  	}
>>>>>> =20
>>>>>> +	kref_get(&irq->refcount);
>>>>>
>>>>> Could you use vgic_get_irq() instead? I know it is slightly overk=
ill,
>>>>> but I can already tell that we'll need to add some tracing in bot=
h the
>>>>> put and get helpers in order to do some debugging. Having straigh=
t
>>>>> kref_get/put is going to make this tracing difficult, so let's no=
t go there.
>>>>
>>>> I'd rather not.
>>>> 1) Putting the IRQ on the ap_list is the "other user" of the
>>>> refcounting, I don't want to mix that unnecessarily with the
>>>> vgic_get_irq() (as in: get the struct by the number) use case. Tha=
t may
>>>> actually help tracing, since we can have separate tracepoints to
>>>> distinguish them.
>>>
>>> And yet you end-up doing a vgic_put_irq() in the fold operation. Wh=
ich
>>> is wrong, by the way, as the interrupt is still in in ap_list. This
>>> should be moved to the prune operation.
>>>
>>>> 2) This would violate the locking order, since we hold the irq_loc=
k here
>>>> and possibly take the lpi_list_lock in vgic_get_irq().
>>>> I don't think we can or should drop the irq_lock and re-take it ju=
st for
>>>> this.
>>>
>>> That's a much more convincing argument. And when you take the above=
 into
>>> account, you realize that your locking is not correct. You shouldn'=
t be
>>> dropping the refcount in fold, but in prune, meaning that you're ho=
lding
>>> the ap_lock and the irq_lock, same as when you inserted the interru=
pt in
>>> the list.
>>>
>>> This is outlining an essential principle: if your locking/refcounti=
ng is
>>> not symmetric, it is likely that you're doing something wrong, and =
that
>>> should bother you really badly.
>>
>> Can you point me to the exact location where it's not symmetric?
>> I just looked at it again and can't find the issue.
>> I "put" it in v[23]_fold because we did a vgic_get_irq a few lines
>> before to translate the LR's intid into our struct vgic_irq pointer.
>=20
> Right. I misread that one, apologies.
>=20
>> The vgic_get_irq() call isn't in this patch, because we used it alre=
ady
>> before and this patch is just adding the respective puts.
>> The only asymmetry I could find is the expected one when it comes to=
 and
>> goes from the ap_list.
>=20
> So I assume this is the pendent of the kref_get call?

Yes.

>=20
> @@ -386,6 +412,7 @@ retry:
>  			list_del(&irq->ap_list);
>  			irq->vcpu =3D NULL;
>  			spin_unlock(&irq->irq_lock);
> +			vgic_put_irq(vcpu->kvm, irq);
>  			continue;
>=20
> If that's the case, please add a comment, because this is really hard=
 to
> find out which vgic_put_irq() balances with a kref_get() and not a
> vgic_get_irq().

Yes, that's what I thought as well just _after_ having hit the Send
button ...

I think much of the confusion stems from the fact that we used
vgic_get_irq() before, only that it wasn't a "get" in the refcounting
get-put sense.

Cheers,
Andre.

