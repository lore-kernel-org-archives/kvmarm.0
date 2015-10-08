From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 8 Oct 2015 12:15:06 +0100
Message-ID: <5616503A.7060504@arm.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <20151008101408.GA20936@cbox> <56164BC4.80104@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56164BC4.80104@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/10/15 11:56, Marc Zyngier wrote:
> On 08/10/15 11:14, Christoffer Dall wrote:
>> Hi Pavel,
>>
>> On Fri, Oct 02, 2015 at 05:44:27PM +0300, Pavel Fedin wrote:
>>> Current KVM code has lots of old redundancies, which can be cleaned=
 up.
>>> This patchset is actually a better alternative to
>>> http://www.spinics.net/lists/arm-kernel/msg430726.html, which allow=
s to
>>> keep piggy-backed LRs. The idea is based on the fact that our code =
also
>>> maintains LR state in elrsr, and this information is enough to trac=
k LR
>>> usage.
>>>
>>> This patchset is made against linux-next of 02.10.2015. Thanks to A=
ndre
>>> for pointing out some 4.3 specifics.
>>>
>> I'm not opposed to these changes, they clean up the data structures
>> which is definitely a good thing.
>>
>> I am a bit worries about how/if this is going to conflict with the I=
TS
>> series and other patches in flight touchignt he vgic.
>>
>> Marc/Andre, any thoughts on this?
>=20
> I don't mind the simplification (Andre was already removing the
> piggybacking stuff as part of his ITS series). I'm a bit more cautiou=
s
> about the sync_elrsr stuff, but that's mostly because I've only read =
the
> patch in a superficial way.
>=20
> But yes, this is probably going to clash, unless we make this part of=
 an
> existing series (/me looks at Andr=E9... ;-)

Yes, I am looking at merging this. From the discussion with Pavel I
remember some things that I disagreed with, so I may propose a follow-u=
p
patch. I will give this a try tomorrow.

Cheers,
Andre.
