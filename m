From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Sat, 17 Sep 2016 16:28:00 +0100
Message-ID: <CAKv+Gu_+txUFT158VzJqeE3Jwdd1LL1n2kzOzYKuk03UFxW3NQ@mail.gmail.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com> <060ADA14-786E-400E-9B11-61C34B7081B5@suse.de>
 <20160916122937.GA14140@cbox> <6b92c411-8b27-a4c0-6969-38e32bbf18ab@redhat.com>
 <10C5B047-6A7F-4255-BE56-5358AF88DA5E@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <10C5B047-6A7F-4255-BE56-5358AF88DA5E@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, KVM devel mailing list <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 September 2016 at 13:44, Alexander Graf <agraf@suse.de> wrote:
>
>> On 16 Sep 2016, at 14:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>
>>
>> On 16/09/2016 14:29, Christoffer Dall wrote:
>>>> It may be useful for migrating a gicv2 VM to a gicv3 host without gicv2 emulation as well.
>>>
>>> I don't see why you'd do this; the VGIC hardware can perfectly well be
>>> used for nesting as well, and this works rather well.
>>
>> Can GICv3 emulate GICv2 in a guest?
>
> It depends on the gicv3 configuration. As an SOC vendor you can either enable gicv2 compatibility or disable it. ThunderX for example is gicv3 only. LS2085 can handle gicv2 in the guest with gicv3 on the host.
>

Note that 'disabled' here means 'not implemented it in silicon', so
there is no way you will ever be able to re-enable GICv2 compatibility
on a ThunderX. Another thing to keep in mind is that GICv2
compatibility is disabled on the non-secure side if the secure side
elects to configure its view of the GIC as v3 (i.e., in order to
support >8 cores)
