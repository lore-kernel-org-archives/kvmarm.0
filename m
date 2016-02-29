From: Mihai Claudiu Caraman <mike.caraman@nxp.com>
Subject: RE: [PATCH v2 00/17] KVM/ARM: Guest Entry/Exit optimizations
Date: Mon, 29 Feb 2016 10:43:29 +0000
Message-ID: <AM2PR04MB0739F13F5F6CBBCB45F2071784BA0@AM2PR04MB0739.eurprd04.prod.outlook.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <AM2PR04MB073947192D0A7015739689EF84BA0@AM2PR04MB0739.eurprd04.prod.outlook.com>
 <56D400A4.3020904@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56D400A4.3020904@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

> -----Original Message-----
> From: Marc Zyngier [mailto:marc.zyngier@arm.com] 
> Sent: Monday, February 29, 2016 10:26 AM
> To: Mihai Claudiu Caraman <mike.caraman@nxp.com>; Christoffer Dall <christoffer.dall@linaro.org>
> Cc: kvm@vger.kernel.org; linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu
> Subject: Re: [PATCH v2 00/17] KVM/ARM: Guest Entry/Exit optimizations
> 
> On 29/02/16 00:57, Mihai Claudiu Caraman wrote:
> > Reported-by: Mihai Caraman <mihai.caraman@freescale.com>
> 
> Reported-by? Where? Did I miss an email (wouldn't surprise me)?

Private meeting between ARM and Freescale/NXP, it was me.

> 
> > Tested-by: Mihai Caraman <mihai.caraman@freescale.com>
> > 
> > 40% improvements here and there will make the difference. 
> 
> I'm sceptical that you will see a significant improvement

1% improvement with this patch is good enough.

> on any *realistic* workload

You will hear about this sooner than you think ;-)

> , but thanks for testing!

Thanks for the patch, we plan to contribute as well.

> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...

-Mike
