From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 9/9] KVM: arm/arm64: vgic: Update documentation of the
 GICv2 device
Date: Mon, 16 Jul 2018 12:07:04 +0100
Message-ID: <5c91b926-58d6-5830-87b9-2170bb700ef6@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
 <1531587940-2490-10-git-send-email-christoffer.dall@arm.com>
 <a5324e35-53b4-b5b4-84a2-1e0a89b244e7@arm.com>
 <20180716103442.GD30822@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1C24A128
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 06:54:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LViji3GfqAjI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 06:54:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 062BC4A114
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 06:54:09 -0400 (EDT)
In-Reply-To: <20180716103442.GD30822@e113682-lin.lund.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/07/18 11:34, Christoffer Dall wrote:
> On Mon, Jul 16, 2018 at 09:52:04AM +0100, Marc Zyngier wrote:
>> On 14/07/18 18:05, Christoffer Dall wrote:
>>> Update the documentation to reflect the ordering requirements of
>>> restoring GICv2 distributor registers and remove outdated limitations in
>>> the documentation while we're at it.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> ---
>>>  Documentation/virtual/kvm/devices/arm-vgic.txt | 12 ++++++------
>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
>>> index b3ce126..c9a6393 100644
>>> --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
>>> +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
>>> @@ -49,9 +49,12 @@ Groups:
>>>      index is specified with the vcpu_index field.  Note that most distributor
>>>      fields are not banked, but return the same value regardless of the
>>>      vcpu_index used to access the register.
>>> -  Limitations:
>>> -    - Priorities are not implemented, and registers are RAZ/WI
>>> -    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
>>> +
>>> +    GICD_IIDR.Revision is updated when the KVM implementation of an emulated
>>> +    GICv2 is changed.  Userspace should read GICD_IIDR from KVM and write back
>>> +    the read value to confirm its expected behavior is aligned with the KVM
>>> +    implementation.  To properly restore the interrupt group configuration,
>>> +    GICD_IIDR should be written before any other registers.
>>
>> I'd like to make it crystal clear that writing to IIDR doesn't allow to
>> select a behaviour, and is merely a confirmation that host and guest do
>> agree on either revision 0 (no write) or revision n (n being read and
>> written back).
>>
> 
> But that's not really true though, because userspace can read rev 0, and
> still have "no write", or read and write n for n >= 1 and have "write".
> 
> I guess I'm not completely sure which wording you'd like me to add?
I'm not sure either, because I find the behaviour of this register a bit
odd. We always default to rev 0, and allow the behaviour to be switched
to rev 2 if we write 2 to it. But we can't select rev 1.

So in a way, it is not a revision selection API (like we have with the
ITS), but a "I don't want rev 0" API. It works for what we have now, but
I'm not sure how future proof it is (I guess we can cross that bridge
when we get there).

Another thing is that the guest will always see rev 2, even when it runs
with the rev 0 behaviour, which is quite bizarre.

	M.
-- 
Jazz is not dead. It just smells funny...
