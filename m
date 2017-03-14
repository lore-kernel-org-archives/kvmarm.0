From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 00/25] arm/arm64: KVM: Rework the hyp-stub API
Date: Tue, 14 Mar 2017 16:09:44 +0000
Message-ID: <4bf5788f-7ed8-198e-8089-1c7a8385f96b@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
 <20170314160545.GP21222@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53D3940430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 12:08:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QQjavCdjir9Q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Mar 2017 12:08:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41F1540296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 12:08:13 -0400 (EDT)
In-Reply-To: <20170314160545.GP21222@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: cdall@linaro.org, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 14/03/17 16:05, Russell King - ARM Linux wrote:
> On Mon, Mar 06, 2017 at 02:24:33PM +0000, Marc Zyngier wrote:
>> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
>> could do with some TLC (it cannot perform a soft-restart at HYP, and
>> has holes in the hyp-stub support in a number of places). In general,
>> it would be desirable for the 32bit behaviour to align on 64bit, if
>> only to ease maintenance.
> 
> What's the merge plan for this?

If you're happy with it (together with Christoffer, Will and Catalin), I
plat to take it through the kvmarm tree.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
