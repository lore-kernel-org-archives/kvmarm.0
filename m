From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Fri, 4 Dec 2015 09:37:12 +0100
Message-ID: <CAKv+Gu9TemWhgySjkb3-PAQNz=VZBW0E4Sn34H_K53r3zjGNfw@mail.gmail.com>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
	<CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
	<1449194337.30642.69.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449194337.30642.69.camel@decadent.org.uk>
Sender: kvm-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 December 2015 at 02:58, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, 2015-12-02 at 18:41 +0100, Ard Biesheuvel wrote:
>> Hi Pavel,
>>
>> Thanks for getting to the bottom of this.
>>
>> On 1 December 2015 at 14:03, Pavel Fedin <p.fedin@samsung.com> wrote:
>> > This function takes stage-II physical addresses (A.K.A. IPA), on input, not
>> > real physical addresses. This causes kvm_is_device_pfn() to return wrong
>> > values, depending on how much guest and host memory maps match. This
>> > results in completely broken KVM on some boards. The problem has been
>> > caught on Samsung proprietary hardware.
>> >
>> > Cc: stable@vger.kernel.org
>> > Fixes: e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's uncachedness")
>> >
>>
>> That commit is not in a release yet, so no need for cc stable
> [...]
>
> But it is cc'd to stable, so unless it is going to be nacked at review
> stage, any subsequent fixes should also be cc'd.
>

Ah yes, thanks for pointing that out.

But please, don't cc your proposed patches straight to
stable@vger.kernel.org. I usually leave it up to the maintainer that
merges the patch to add the Cc: line to the commit log.
