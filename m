From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm: Implement software vGICv2 emulation
Date: Mon, 29 Jun 2015 16:29:38 +0100
Message-ID: <55916462.5080901@arm.com>
References: <cover.1435567226.git.p.fedin@samsung.com> <20150629125213.GK11332@cbox> <559151FE.8020701@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <559151FE.8020701@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/06/15 15:11, Andre Przywara wrote:
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

Let's face it: arm64 has no legacy to support. So if you're on a pure
GICv3 system, you run a GICv3 guest (oddly enough, pure GICv3 systems
are also pure AArch64 systems - see a pattern?). We've made sure the
software was available in a timely manner.

> Also if this will make the hack needed to enable KVM on RPi2 smaller,
> I'd rather embrace this one than letting any random hacks appear on that
> RPi kernel tree (patches which I have seen already on some other repo).
> If I get this correctly, there are some efforts currently to get closer
> to mainline with the RPi tree.

Whatever the RPi people do in their tree is their problem. I don't care.
I'm interested in supporting *compliant hardware*, and not doing a quick
hack on the side.

Even if RPi-2 was fully supported in mainline, this code would actively
prevent us from supporting proper timer deactivation, for example.

> Pavel, is this "broken" GIC you are talking about going to appear in a
> publicly available SoC? If yes, you could either state this right now or
> send it later once you can talk publicly.
> 
> Marc, Christoffer:
> So is this GICv2 CPU interface emulation totally out of question for us
> or is it worth at least commenting on the patches?

As long as this code is there to support a platform that doesn't exist
in a mainline tree, I'm not interested. We have much bigger fish to fry,
and supporting what is effectively a broken platform is not exactly high
on the agenda.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
