From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
Date: Thu, 1 Dec 2016 12:57:53 +0000
Message-ID: <0c69099a-06b4-cf84-9578-138350c0d5ba@arm.com>
References: <1480584341-32340-1-git-send-email-marc.zyngier@arm.com>
 <1480584341-32340-2-git-send-email-marc.zyngier@arm.com>
 <5FC3163CFD30C246ABAA99954A238FA817475F7E@lhreml504-mbs>
 <be0586f4-57b7-b732-f97e-34798f57e066@arm.com>
 <5FC3163CFD30C246ABAA99954A238FA81747812F@lhreml504-mbs>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5FC3163CFD30C246ABAA99954A238FA81747812F@lhreml504-mbs>
Sender: kvm-owner@vger.kernel.org
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/16 12:15, Shameerali Kolothum Thodi wrote:

>> For these interrupts, which are purely virtual, there is absolutely
>> nothing to do at the physical distributor level anyway. Furthermore,
>> kvm_notify_acked_irq doesn't know about per-cpu interrupt, which is why
>> we cannot notify them.
> 
> Just to confirm, that means for any phys interrupt(PPI/SPI) to be injected
> to the Guest, the mapping bit has(HW bit set) to be used.

Yup.

	M.
-- 
Jazz is not dead. It just smells funny...
