From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/3] KVM: arm: Implement software vGICv2 emulation
Date: Mon, 29 Jun 2015 16:15:16 +0200
Message-ID: <CAMJs5B-yDawq8kNTfQhewpoYWVULhCQdnOfvb__SBndaqVV1qA@mail.gmail.com>
References: <cover.1435567226.git.p.fedin@samsung.com>
	<20150629125213.GK11332@cbox>
	<559151FE.8020701@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <559151FE.8020701@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 29, 2015 at 4:11 PM, Andre Przywara <andre.przywara@arm.com> wrote:
> Hi,
>
> On 29/06/15 13:52, Christoffer Dall wrote:
>> Hi Pavel,
>>
>> [Please cc the kvm/arm list for such patches according to the
>> MAINTAINERS file in the future]
>>
>> On Mon, Jun 29, 2015 at 12:53:46PM +0300, Pavel Fedin wrote:
>>> Some hardware (like Raspberry Pi 2) is capable of running KVM, however lacks
>>> functional vGIC registers. This series introduces software vGIC emulation for
>>> such machines, allowing to fully use virtualization capabilities
>>
>> Is this rather esoteric use case really worth the extra code in the
>> kernel?
>
> I wonder if these patches would pave the way to support running GICv2
> guests on GICv3s without compat support? Admittedly not a really
> compelling use case either, but at least worth discussing, I think.
>
> Also if this will make the hack needed to enable KVM on RPi2 smaller,
> I'd rather embrace this one than letting any random hacks appear on that
> RPi kernel tree (patches which I have seen already on some other repo).
> If I get this correctly, there are some efforts currently to get closer
> to mainline with the RPi tree.
>
> Pavel, is this "broken" GIC you are talking about going to appear in a
> publicly available SoC? If yes, you could either state this right now or
> send it later once you can talk publicly.
>
> Marc, Christoffer:
> So is this GICv2 CPU interface emulation totally out of question for us
> or is it worth at least commenting on the patches?
>
Well, I certainly have a lot of seemingly higher-priority things to
look at currently.

I'd like some numbers for the performance benefit of putting this in
the kernel before I entertain the idea.

-Christoffer
