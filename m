From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 0/3] KVM: arm/arm64: Clean up some obsolete code
Date: Wed, 4 Nov 2015 15:29:26 +0100
Message-ID: <20151104142926.GA20230@cbox>
References: <cover.1445934536.git.p.fedin@samsung.com>
 <20151102211538.GA5819@cbox>
 <005201d11608$a73edf80$f5bc9e80$@samsung.com>
 <002501d1161c$4c92f5d0$e5b8e170$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <002501d1161c$4c92f5d0$e5b8e170$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 03, 2015 at 12:44:54PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> >  By this time i'll make a very minimal version of patch 0001, for you to test it. If we have
> > problems with current 0001, which we
> > cannot solve quickly, we could stick to that version then, which will provide the necessary
> > changes to plug in LPIs, yet with
> > minimal changes (it will only remove vgic_irq_lr_map).
> >  I guess i should have done it before. Or, i could even respin v5, with current 0001 split up.
> > This should make it easier to bisect
> > the problem.
> 
>  So, i have just sent v5, conditions are the same as before. It is OK to stop at any point, and actually you should be able to
> easily throw away 0003 and apply just 1, 2, 4. The minimum needed thing for LPIs introduction is 0001.
>  You can also stick to v4 if the problem does not get triggered by its first patch, if you prefer reduced commit log.
> 
Actually, I seem to have been just incredibly unlucky with my test
cycles, because I eventually reproduced the bug without your patches.

I'm going to take this version of the series because that's what I
reviewed and tested.

Sorry for the noise.

-Christoffer
