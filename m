From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Mon, 29 Jun 2015 18:30:50 +0100
Message-ID: <559180CA.3050905@arm.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com> <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com> <558A6A84.5020603@arm.com> <20150624085128.GA22785@cbox> <558A7936.7020109@arm.com> <20150625123034.GE28244@cbox> <558BF6C9.3000009@arm.com> <558C05A9.8080201@arm.com> <CAFEAcA_ULz=ugQW=NmthzqYRtvcfwteQTh0DonHRN6U5NykEtQ@mail.gmail.com> <20150626095318.GG28244@cbox> <F37C68A5-E48F-462C-AD18-0F3C096348C7@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <F37C68A5-E48F-462C-AD18-0F3C096348C7@caviumnetworks.com>
Sender: kvm-owner@vger.kernel.org
To: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/06/15 18:13, Chalamarla, Tirumalesh wrote:
> 
>> On Jun 26, 2015, at 2:53 AM, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>>
>> On Thu, Jun 25, 2015 at 02:49:08PM +0100, Peter Maydell wrote:
>>> On 25 June 2015 at 14:44, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>> It should always be possible to emulate a "known" CPU on a generic host,
>>>> and it should be able to migrate. The case we can't migrate is when we
>>>> let the guest be generic (which I guess should really be unknown, and
>>>> not generic).
>>>>
>>>> So if the user specify "-cpu cortex-a57" on the command line, the guest
>>>> should be able to migrate from an A72 to an A53. if the user specified
>>>> "-cpu host", the resulting guest won't be able to migrate.
>>>>
>>>> Does it make sense?
>>>
>>> Yes. We've always said "-cpu host" won't be cross-host migratable
>>> from a QEMU point of view.
>>>
>> ok, this makes sense.  It's basically up to userspace to mandate that
>> trying to migrate something that used unknown cpu (via -cpu host or
>> whatever) cannot be migrated.
>>
> 
> Will this also prevents migrating between same implementations, if no how is this identified.

This shouldn't. It is pretty easy to look at the incoming guest's MIDR,
and verify that it matches the default MIDR on the receiving system. Any
difference, and the migration should abort.

> This seems to be making emulation a requirment for ARM64 KVM. 

I don't believe so. Care to elaborate?

	M.
-- 
Jazz is not dead. It just smells funny...
