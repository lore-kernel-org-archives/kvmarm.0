From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] KVM: arm64: Implement accessors for vGIC CPU
 interface registers
Date: Mon, 31 Aug 2015 11:01:26 +0200
Message-ID: <20150831090126.GJ24113@cbox>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
 <20150830165015.GE24113@cbox>
 <CAFEAcA_+Q+byqn4=ByRZ_EtJ2LzF8dj1ac52R_MPbmJkDLSjhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA_+Q+byqn4=ByRZ_EtJ2LzF8dj1ac52R_MPbmJkDLSjhA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Aug 30, 2015 at 07:39:05PM +0100, Peter Maydell wrote:
> On 30 August 2015 at 17:50, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > I had imagined we would encode the GICv3 register accesses through the
> > device API and not through the system register API, since I'm not crazy
> > about polluting the general system register handling logic with GIC
> > registers solely for the purposes of migration.
> 
> There's an interesting design question lurking under this
> about the extent to which you expose the h/w design split
> between the CPU interface and the GIC proper as part of the
> KVM APIs. I'm inclined to agree that it's better to for our
> purposes treat both bits as just part of an irqchip device,
> but I haven't given it a great deal of thought.

Me neither, and I intended to start a discussion around this with my
e-mail.

But as I stated above, I think it will be easier to manage if the state
belongs to the device, in general, but I have fairly little insight into
how this is going to be implemented in QEMU at this point.  But for the
GICv2 implementation, it certainly made a lot of sense to only deal with
one device and file descriptor when getting/setting the state.

> 
> (Similarly in the QEMU emulated-GICv3 case you could also
> split the CPU i/f more formally, or not. The kernel's choice
> would have implications for which way QEMU ends up going,
> I think.)
> 

Thanks,
-Christoffer
