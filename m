From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/17] KVM/ARM: Guest Entry/Exit optimizations
Date: Mon, 29 Feb 2016 08:26:12 +0000
Message-ID: <56D400A4.3020904@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <AM2PR04MB073947192D0A7015739689EF84BA0@AM2PR04MB0739.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <AM2PR04MB073947192D0A7015739689EF84BA0@AM2PR04MB0739.eurprd04.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Mihai Claudiu Caraman <mike.caraman@nxp.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/02/16 00:57, Mihai Claudiu Caraman wrote:
> Reported-by: Mihai Caraman <mihai.caraman@freescale.com>

Reported-by? Where? Did I miss an email (wouldn't surprise me)?

> Tested-by: Mihai Caraman <mihai.caraman@freescale.com>
> 
> 40% improvements here and there will make the difference. 

I'm sceptical that you will see a significant improvement on any
*realistic* workload, but thanks for testing!

	M.
-- 
Jazz is not dead. It just smells funny...
