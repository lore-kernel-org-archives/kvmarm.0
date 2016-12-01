From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
Date: Thu, 1 Dec 2016 10:57:38 +0000
Message-ID: <be0586f4-57b7-b732-f97e-34798f57e066@arm.com>
References: <1480584341-32340-1-git-send-email-marc.zyngier@arm.com>
 <1480584341-32340-2-git-send-email-marc.zyngier@arm.com>
 <5FC3163CFD30C246ABAA99954A238FA817475F7E@lhreml504-mbs>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8C2C405DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 05:56:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O+FgCcGH2Qtv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 05:56:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CF214047D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 05:56:50 -0500 (EST)
In-Reply-To: <5FC3163CFD30C246ABAA99954A238FA817475F7E@lhreml504-mbs>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/16 10:28, Shameerali Kolothum Thodi wrote:
> Hi Marc,
> =

>> -----Original Message-----
>> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
>> bounces@lists.cs.columbia.edu] On Behalf Of Marc Zyngier
>> Sent: Thursday, December 01, 2016 9:26 AM
>> To: Paolo Bonzini; Radim Kr=E8m=E1=F8
>> Cc: Catalin Marinas; kvmarm@lists.cs.columbia.edu; linux-arm-
>> kernel@lists.infradead.org; kvm@vger.kernel.org
>> Subject: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
>>
>> When we inject a level triggerered interrupt (and unless it is backed
>> by the physical distributor - timer style), we request a maintenance
>> interrupt. Part of the processing for that interrupt is to feed to the
>> rest of KVM (and to the eventfd subsystem) the information that the
>> interrupt has been EOIed.
>>
>> But that notification only makes sense for SPIs, and not PPIs (such as
>> the PMU interrupt). Skip over the notification if the interrupt is not
>> an SPI.
> =

> Just to clarify my understanding, the maintenance interrupt is generated =

> for cases where there is no mapping of virt to phys interrupts
> (ie, ICH_LR HW bit is not set). And I was under the impression that
> kvm_notify_acked_irq will eventually deactivate the interrupt on distribu=
tor
> for such cases. Its not clear to me how the deactivation is done
> otherwise.
> =

> Could you please help me to understand this better.

kvm_notify_acked_irq() doesn't do *anything* at the distributor level,
ever (it has no idea of anything GIC-specific anyway). It's sole job is
to signal the rest of the stack that an interrupt has been EOIed in the
guest.

For these interrupts, which are purely virtual, there is absolutely
nothing to do at the physical distributor level anyway. Furthermore,
kvm_notify_acked_irq doesn't know about per-cpu interrupt, which is why
we cannot notify them.

Thanks,

	M.
-- =

Jazz is not dead. It just smells funny...
