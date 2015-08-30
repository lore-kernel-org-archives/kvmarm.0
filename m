From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 3/3] KVM: arm64: Implement accessors for vGIC CPU
 interface registers
Date: Sun, 30 Aug 2015 19:39:05 +0100
Message-ID: <CAFEAcA_+Q+byqn4=ByRZ_EtJ2LzF8dj1ac52R_MPbmJkDLSjhA@mail.gmail.com>
References: <cover.1440766141.git.p.fedin@samsung.com> <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
 <20150830165015.GE24113@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150830165015.GE24113@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30 August 2015 at 17:50, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> I had imagined we would encode the GICv3 register accesses through the
> device API and not through the system register API, since I'm not crazy
> about polluting the general system register handling logic with GIC
> registers solely for the purposes of migration.

There's an interesting design question lurking under this
about the extent to which you expose the h/w design split
between the CPU interface and the GIC proper as part of the
KVM APIs. I'm inclined to agree that it's better to for our
purposes treat both bits as just part of an irqchip device,
but I haven't given it a great deal of thought.

(Similarly in the QEMU emulated-GICv3 case you could also
split the CPU i/f more formally, or not. The kernel's choice
would have implications for which way QEMU ends up going,
I think.)

thanks
-- PMM
