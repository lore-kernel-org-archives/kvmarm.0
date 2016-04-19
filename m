From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 26/45] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register handler
Date: Tue, 19 Apr 2016 14:12:32 +0100
Message-ID: <CAFEAcA8ceAo-67oiJSDQZKsnyuBv-aar-AhdL2mpdvDQ2=Bwtg@mail.gmail.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-27-git-send-email-andre.przywara@arm.com>
 <CAFEAcA9Hy2cSVguOWrxBo6By24BjiE2rgoCPGbfo+OuuPMtSQg@mail.gmail.com> <57162B3D.9000307@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57162B3D.9000307@arm.com>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 April 2016 at 13:57, Andr=C3=A9 Przywara <andre.przywara@arm.com>=
 wrote:
> Hi Peter,
>
> thanks for going through the pain of looking into this!

No problem -- I figured I might as well while I have my head full
of the GICv3 spec for the QEMU emulated version.

> On 19/04/16 13:34, Peter Maydell wrote:
>> We claim to be an ARM implementation, so we should report the full
>> set of ARM ID registers, not just GICD_PIDR2:
>
> Do we really have to? Please note that though we say our implementor =
is
> ARM (because we lack alternatives, I think), we don't claim to be a
> GIC-500, for instance, but a made-up KVM implementation.
> So there is no need to implement the other ID registers, except for t=
he
> architecturally defined PIDR2, which Linux actually checks to confirm
> that this is a GICv3 compliant GIC.
>
>>         0x44, 0x00, 0x00, 0x00, 0x92, 0xB4, 0x3B, 0x00, 0x0D, 0xF0, =
0x05, 0xB1
>
> Yes, I had those registers defined like this in an earlier version, b=
ut
> Marc's comment IIRC correctly was that we shouldn't claim to be a
> GIC-500, for instance, because then we would need to mimic GIC-500
> behavior quite closely, which we simply don't and also don't want to.

This isn't claiming to be a GIC-500 (which you would do via the
GICD_IIDR and GICR_IIDR by specifying the right Product field).
This is implementing the Coresight ID registers, which the spec
says have the same values for all ARM implementations (and as you
note, you are claiming in the IIDR registers to be an ARM
implementation). The spec also says "ARM strongly recommends that
other implementers also use this scheme", so even if we weren't
saying we were an ARM implementation I think it would be a good idea.

> Do you think by claiming coming from ARM we are obliged to implement =
all
> the other PIDR/CIDR registers the ARM way?

I think so, and it's not exactly difficult so why not?

Any guest that thinks these ID values mean "I'm a GIC-500" is
broken :-)

thanks
-- PMM
