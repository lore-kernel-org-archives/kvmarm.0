From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 00/25] arm/arm64: KVM: Rework the hyp-stub API
Date: Fri, 17 Mar 2017 11:43:14 +0000
Message-ID: <20170317114314.GA21222@n2100.armlinux.org.uk>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
 <20170314160545.GP21222@n2100.armlinux.org.uk>
 <4bf5788f-7ed8-198e-8089-1c7a8385f96b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DFB440A66
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 07:41:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xSHDBKNHtLp7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 07:41:53 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D22C40948
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 07:41:52 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <4bf5788f-7ed8-198e-8089-1c7a8385f96b@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: cdall@linaro.org, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 14, 2017 at 04:09:44PM +0000, Marc Zyngier wrote:
> On 14/03/17 16:05, Russell King - ARM Linux wrote:
> > On Mon, Mar 06, 2017 at 02:24:33PM +0000, Marc Zyngier wrote:
> >> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
> >> could do with some TLC (it cannot perform a soft-restart at HYP, and
> >> has holes in the hyp-stub support in a number of places). In general,
> >> it would be desirable for the 32bit behaviour to align on 64bit, if
> >> only to ease maintenance.
> > 
> > What's the merge plan for this?
> 
> If you're happy with it (together with Christoffer, Will and Catalin), I
> plat to take it through the kvmarm tree.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
