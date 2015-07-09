From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 0/7] KVM: arm/arm64: gsi routing support
Date: Thu, 9 Jul 2015 16:25:50 +0100
Message-ID: <559E927E.8040403@arm.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <023601d0ba54$c4d6e020$4e84a060$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5347658440
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 11:14:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NXXBtSCP68kH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 11:14:19 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB6858421
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 11:14:18 -0400 (EDT)
In-Reply-To: <023601d0ba54$c4d6e020$4e84a060$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: "eric.auger@st.com" <eric.auger@st.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 09/07/15 15:37, Pavel Fedin wrote:
>  Hello!
> 
>> v1 -> v2:
>> - user API changed:
>>   x devid id passed in kvm_irq_routing_msi
>>   x kept the new routing entry type: KVM_IRQ_ROUTING_EXTENDED_MSI
> 
>  Andre, you never replied to my last comment to the previous series.

Oh dear, my draft folder again :-( Sorry for that!

> Are you going to do the same
> change in your MSI API? Otherwise:
> 1. KVM_IRQ_LINE - we have completely own convention. Well, this was already done before us, we
> cannot fix it.
> 2. KVM_SIGNAL_MSI - we use VALID_DEVID flag plus devid

Yes, because there is already a flag value and no other way to specify
this, in contrast to ...

> 3. KVM_SET_GSI_ROUTING - we use KVM_IRQ_ROUTING_EXTENDED_MSI plus devid

Here we already have a type field with some users, so lets piggy-back on
this.

Both ioctl extensions are coupled with a per-VM capability to let
userland know that it needs to provide a device ID.

>  Don't (2) and (3) together still look bad? Since we agreed on not using flags, i would suggest to
> have KVM_SIGNAL_EXTENDED_MSI counterpart, which also doesn't use flags.

Using flags on its own (without an explicit capability) is what I
opposed against, not flags in general. After all, that's what they are
meant for, right? In case of KVM_SET_GSI_ROUTING it just seems awkward
to me to use a flag when a different type would do as well.

But after all, I don't have a strong opinion on that matter, so if
others prefer using a flag I am also fine with that.

Poka,
Andre.

>  I know, we were already talking about it, so, if this gets ignored for the second time, i assume
> the Architects decided that fancy APIs are cool, and i promise to stop this.
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
