From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: Booting a kernel to EL1 in Armv8.1
Date: Wed, 25 Jan 2017 09:22:52 +0100
Message-ID: <20170125082252.GS15850@cbox>
References: <CAPB=Z-pGjZ398fZuUeR2EsOnVf-0Qp3m4ckdeCBniKZmjs25Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3123440665
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 03:22:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BMI2H5vBt0QV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jan 2017 03:22:52 -0500 (EST)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
 [209.85.215.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F019B40064
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 03:22:51 -0500 (EST)
Received: by mail-lf0-f47.google.com with SMTP id n124so124292439lfd.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 00:23:00 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-pGjZ398fZuUeR2EsOnVf-0Qp3m4ckdeCBniKZmjs25Nw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Raz <raziebe@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 24, 2017 at 09:50:04PM +0000, Raz wrote:
> Hello
> 
> I am trying to boot EL1 kernel in a platform based on Armv8.1.
> I am using fvp as a hardware.
> What I am trying to achieve is to execute some kernel code in
> EL2 exception level..

When you boot a reasonably recent kernel on VHE, it will execute in EL2,
so all the code you're executing will be at EL2, so I think you've
already achieved what you're trying to do.

> 
> The current VHE patch is booting the kernel into EL2. So I took an older
> kernel
> and I tried to set  TTBR1_EL2 to access kernel memory as if it is TTBR1_EL1
> .

That won't work unless you set the E2H bit, see the ARMv8.1
documentation.

If you boot a kernel that doesn't have the necessary bits to enable VHE,
then you'll just run as on a non-VHE system with the main kernel running
at EL1 and a stub installed at EL2 which eventually gets replaced by the
KVM hyp lowvisor code in EL2.

> 
> It is theoretically possible ?

I'm not sure what you're asking?

> Setting TTBR1_EL2 to TTBR1_EL1
> and enabling mmu  thtough sctlr_el2 does not work.
> 

Again, not sure what you're trying to do.  If you're running in EL1
(because you're old kernel drops you to EL1) then trying to access EL2
registers obviously won't work.

If you run a VHE kernel, it will have already set the _EL2 registers to
the values you want (but it will use _EL1 register access intructions to
do so, and they are transparently rewritten by hardware to program the
corresponding _EL2 registers).

Hope this helps,
-Christoffer
