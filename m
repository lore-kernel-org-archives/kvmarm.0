From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: add gic-400 compatible
Date: Thu, 2 Apr 2015 18:31:04 +0100
Message-ID: <20150402173103.GA30669@leverpostej>
References: <20140908222144.4967.80301.stgit@joelaarch64.amd.com>
 <551CF409.1090707@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 192274AE9B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 13:23:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0nJ9y9Tb4eaT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 13:23:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 998EA4AE1B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 13:23:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <551CF409.1090707@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Thu, Apr 02, 2015 at 08:47:21AM +0100, AKASHI Takahiro wrote:
> Ping.
> This patch was acked but has never been merged?

There's a more complete patch in the kvmarm tree, queued for 4.1 [1]. It
adds both "arm,gic-400" and "arm,cortex-a7-gic".

Mark.

[1] https://git.kernel.org/cgit/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=0f37247574b3ef5b130116bbf7c0f9eb8a4c78c2

> 
> -Takahiro AKASHI
> 
> On 09/09/2014 07:21 AM, Joel Schopp wrote:
> > Add a one liner to identify the gic-400.  It's gicv2 with optional MSI extensions.
> >
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > Signed-off-by: Joel Schopp <joel.schopp@amd.com>
> > ---
> >   virt/kvm/arm/vgic.c |    1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 73eba79..e81444e 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1550,6 +1550,7 @@ static struct notifier_block vgic_cpu_nb = {
> >
> >   static const struct of_device_id vgic_ids[] = {
> >   	{ .compatible = "arm,cortex-a15-gic", .data = vgic_v2_probe, },
> > +	{ .compatible = "arm,gic-400", .data = vgic_v2_probe, },
> >   	{ .compatible = "arm,gic-v3", .data = vgic_v3_probe, },
> >   	{},
> >   };
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
