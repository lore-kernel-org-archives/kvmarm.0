From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: A KVM kernel for FVP for ARM7
Date: Fri, 8 Jun 2018 15:26:37 +0200
Message-ID: <20180608132637.GB5097@C02W217FHV2R.local>
References: <CAPB=Z-qULLZUVOabsNDPRYxybC3M=O8ZrYpRo8Dfc0oT4nKcGQ@mail.gmail.com>
 <20180607073426.GA20446@C02W217FHV2R.local>
 <CAPB=Z-pF=BuHV73ybKaURavRd=-J2dHL3JWEzcH+=pih+-V0Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D7D94070F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jun 2018 09:15:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TDoOhh0QEz6D for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jun 2018 09:15:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C361401CD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jun 2018 09:15:21 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-pF=BuHV73ybKaURavRd=-J2dHL3JWEzcH+=pih+-V0Ng@mail.gmail.com>
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

[please don't top-post]

On Thu, Jun 07, 2018 at 11:44:14PM +0300, Raz wrote:
> The bellow is the command line I use. I am using now 4.14.48 compiled as
> arm7/ARCH-VEXPRESS . there is no clock tick. The boot hangs in:
> ....
>     while (get_jiffies_64() < waitjiffies)
>             udelay(10);
> 
> /opt/DS-5_v5.28.1/sw/models/bin/FVP_VE_Cortex-A9x1  -a
> /opt/arm7/FVP/FVP_VE_V7/FVP_VE_V7.axf --data
> /opt/tlinux-4.14.48/arch/arm/boot/Image@0x80008000 -f
> /opt/truly/arm7/fvpbase.conf  --data
> /opt/t/linux-4.14.48/arch/arm/boot/dts/vexpress-v2p-ca9.dtb
> 
> Any idea ?

You're probably not getting timer interrupts, which could be because of
a number of things.  Your bootloader in the .axf image could be the
wrong wrong or configured incorrectly, the DT could be the wong one for
the model, or your configuration parameters could otherwise be
incorrect.

This is a basic "bring up Linux on the fast model" question, and doesn't
really belong on the KVM/ARM list.

Also note, that if you do want to play with KVM on an Arm system, then
Cortex-A9 does not have the virtualization extensions.

Hope this helps,
-Christoffer

> 
> 
> On Thu, Jun 7, 2018 at 10:34 AM, Christoffer Dall <christoffer.dall@arm.com>
> wrote:
> 
> > On Wed, Jun 06, 2018 at 09:22:52AM +0300, Raz wrote:
> > > Hello
> > > KVM arm was introduced in 3.9. I wish to debug it through fast models.
> > > My problem is that FVP uses 3.4 kernel, and 3.9  from "git://
> > > git.kernel.org/pub/scm/virt/kvm/kvm.git " does not boot it.
> > >
> > > Do you have a ready kernel for FVP ?
> >
> > Mainline kernels should boot just fine on Arm fast models.  I strongly
> > recommend you use a much newer kernel version for anything KVM-related.
> >
> > -Christoffer
> >
