From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Tue, 23 Jun 2015 15:16:16 +0100
Message-ID: <CAFEAcA-1T8+KAym4Ow4RP3YNvKc1h3iFsX4Xj1kBb=ny_fOb6w@mail.gmail.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
 <20150623123959.GF4035@cbox> <55896718.9080600@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55896718.9080600@arm.com>
Sender: kvm-owner@vger.kernel.org
To: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 23 June 2015 at 15:03, Suzuki K. Poulose <Suzuki.Poulose@arm.com> wrote:
> On 23/06/15 13:39, Christoffer Dall wrote:
>> On Mon, Jun 22, 2015 at 09:44:48AM +0100, Peter Maydell wrote:
>> I'm guessing the intention is to avoid having to add code in the kernel
>> to support KVM on a new CPU where nothing else needs to be done to
>> support KVM on that system.
>
> Yes, thats the *only* motivation behind the patch

I'm not convinced we really want to change the userspace ABI design
principles just for convenience of internal kernel implementation.
At the moment the approach is:
 (1) if you want a specific guest CPU, you ask for it; the kernel
guarantees that if this succeeds, you can cross-migrate between
this and another kernel that also lets you init that guest CPU
[at the moment this implies no cross-host-type migration, of course]
 (2) if you don't care, you ask the kernel what its preferred
CPU type is, and use it

If we want to change away from this model (which has at least
the advantages of being coherent and sort-of similar to
how x86 does things), what's the model we're moving to?

> May be we can create a dummy set of values for
> the ID registers, which doesn't provide any 'special functionality'
> so that it is safe to be migrated across any host ?

I suspect this problem is larger and requires a more complex
solution than merely providing funky ID register values. If we
can do it successfully that would be really handy, though...

thanks
-- PMM
