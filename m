From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Wed, 7 Oct 2015 20:48:10 +0100
Message-ID: <20151007204810.66e2b1d6@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
	<029601d1011a$026e1000$074a3000$@samsung.com>
	<561546AF.90903@arm.com>
	<02c301d1012b$42cb8270$c8628750$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <02c301d1012b$42cb8270$c8628750$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Andre Przywara' <andre.przywara@arm.com>, christoffer.dall@linaro.org, eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 7 Oct 2015 21:09:07 +0300
Pavel Fedin <p.fedin@samsung.com> wrote:

>  Hello!
> 
> > LPIs do not have an active state, at the redistributor or otherwise.
> 
>  Then what do they become after they were ACK'ed and before EOI'ed?

Nothing. They are gone. What is left at the CPU interface is the active
priority.

>  I tried to google up this thing, and came up with this email:
> http://www.spinics.net/lists/kvm-arm/msg16032.html. It says that "SW must issue a write to EOI to
> clear the active priorities register, hence the CPU interface still requires an active state for
> LPIs". They give a link to some document which seems to be top-secret and never published, because
> my arch reference manual does not have section 4.8.3 named "Properties of LPI".

Your architecture document has a section 1.2.1 which contains the
sentence: "LPIs do not have an active state, and therefore do not
require explicit deactivation.". It also has 1.2.2 ("Interrupt states")
that repeatedly states the same thing. Finally, the email you quote is
about priority drop vs deactivation, not about the active state of an
LPI.

>  And another thread,
> http://lists.xen.org/archives/html/xen-devel/2014-09/msg01141.html,
> says that virtual LPIs actually do have active state in LR.

Or not. Read again. The only case where something vaguely relevant
happens is when you inject a virtual SPI backed by a HW LPI. In that
case, the LR does have an active state (of course, this is an SPI). Or
when you inject a virtual LPI backed by a HW SPI (in which case the
relevant active state is in the physical distributor, not in the LR).

I'd appreciate if you could try to read and understand the architecture
spec instead of randomly googling and quoting various bits of
irrelevant information.

If something is unclear in the architecture specification (yes, this
is complicated and sometimes confusing), please ask relevant questions.
At the moment, you're just asserting fallacies, and I'd rather spend
time doing something useful instead of setting the record straight
again and again.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
