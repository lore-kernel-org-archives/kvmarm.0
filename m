From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 28/37] KVM: arm64: Move common VHE/non-VHE trap config in
 separate functions
Date: Sat, 25 Nov 2017 10:49:22 +0000
Message-ID: <20171125104922.GX31757@n2100.armlinux.org.uk>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-29-christoffer.dall@linaro.org>
 <20171125104347.cco323qjucrgmryz@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A02FB49D92
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 05:46:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bW9zjqq0QJOs for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Nov 2017 05:46:54 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F46449D6D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 05:46:54 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171125104347.cco323qjucrgmryz@yury-thinkpad>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Nov 25, 2017 at 01:43:47PM +0300, Yury Norov wrote:
> On Thu, Oct 12, 2017 at 12:41:32PM +0200, Christoffer Dall wrote:
> > As we are about to be more lazy with some of the trap configuration
> > register read/writes for VHE systems, move the logic that is currently
> > shared between VHE and non-VHE into a separate function which can be
> > called from either the world-switch path or from vcpu_load/vcpu_put.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/hyp/switch.c | 70 +++++++++++++++++++++++++--------------------
> >  1 file changed, 39 insertions(+), 31 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 6a12504..c587416 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -23,6 +23,43 @@
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/fpsimd.h>
> >  
> > +static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * We are about to set CPTR_EL2.TFP to trap all floating point
> > +	 * register accesses to EL2, however, the ARM ARM clearly states that
> 
> ARM ARM: typo?

No.  ARM _A_rchitecture _R_eference _M_anual.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
