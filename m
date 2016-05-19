From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 32/56] KVM: arm/arm64: vgic-new: Add SGIPENDR register
 handlers
Date: Thu, 19 May 2016 14:25:22 +0100
Message-ID: <d2a62bb3-791a-b6d2-a41b-faa671f5e3f6@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-33-git-send-email-andre.przywara@arm.com>
 <20160518131449.GI3827@cbox> <573C6EA6.90803@arm.com>
 <20160518135022.GL3827@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD04412DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 09:21:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K4Ja-vgXmPKy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 09:21:30 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0CB4410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 09:21:29 -0400 (EDT)
In-Reply-To: <20160518135022.GL3827@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 18/05/16 14:50, Christoffer Dall wrote:
> On Wed, May 18, 2016 at 02:31:18PM +0100, Andre Przywara wrote:
>> Hi,
>>
>> On 18/05/16 14:14, Christoffer Dall wrote:
>>> On Mon, May 16, 2016 at 10:53:20AM +0100, Andre Przywara wrote:
>>>> As this register is v2 specific, its implementation lives entirely
>>>> in vgic-mmio-v2.c.
>>>> This register allows setting the source mask of an IPI.
>>>>
>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>> ---
>>>> Changelog RFC..v1:
>>>> - remove IRQ lock from read handler
>>>> - update pending bit on setting the first / clearing the last bit
>>>> - queue virtual IRQ if necessary
>>>>
>>>> Changelog v1 .. v2:
>>>> - adapt to new MMIO framework
>>>>
>>>> Changelog v3 .. v4:
>>>> - specify accessor width
>>>>
>>>>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 62 +++++++++++++++++++++++++++++++=
+++++++--
>>>>  1 file changed, 60 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic=
-mmio-v2.c
>>>> index c884e9b..3925d4c 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>>> @@ -146,6 +146,64 @@ static void vgic_mmio_write_target(struct kvm_vcp=
u *vcpu,
>>>>  	}
>>>>  }
>>>>  =

>>>> +static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
>>>> +					    gpa_t addr, unsigned int len)
>>>> +{
>>>> +	u32 intid =3D addr & 0x0f;
>>>
>>> is there a reason why we cannot use the magic macro here?
>>
>> I wasn't sure about this, because it's not covering all 1024 interrupts,
>> but just SGIs, so it's always fixed to 16 interrupts =E1 8 bits. The
>> default mask would be too big in this case.
>> I guess it would work anyway because this region is limited to 16 bytes
>> in our description, so we could use this here anyway to make it more
>> aligned with the other handlers, maybe adding a comment about the
>> difference?
>>
> meh, either way works for me actually, whatever you prefer.

So for the records: we can't use the macro here, since it relies on
masking and thus a certain alignment, which the SGIPENDR registers do
not have (being mapped to 0xF10 and 0xF20, respectively). So the
calculated intid would be much higher than the number of actually
allocated interrupts - with all the consequences ;-)

Cheers,
Andre.
