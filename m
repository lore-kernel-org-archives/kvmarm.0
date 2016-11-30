From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 07/11] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Wed, 30 Nov 2016 09:24:11 +0100
Message-ID: <20161130082411.GA6647@cbox>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-8-git-send-email-vijay.kilari@gmail.com>
 <20161128195028.GH18170@cbox>
 <CALicx6uW5RmjsPPBKB5wLW4TzNmcdc9ZADqp=M2ZJe9Cd+keZg@mail.gmail.com>
 <20161129210901.GC15346@cbox>
 <CAFEAcA_1i7-ti_H_RZrTbCW2DmFPvYudKn_WFs=_XRoyKKsnbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C562405C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 03:23:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9iXiX6UEXLpJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2016 03:23:24 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08D0A404D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 03:23:23 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id c13so140571810lfg.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 00:24:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA_1i7-ti_H_RZrTbCW2DmFPvYudKn_WFs=_XRoyKKsnbQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 30, 2016 at 07:10:51AM +0000, Peter Maydell wrote:
> On 29 November 2016 at 21:09, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > Actually, I'm not sure what the semantics of the line level ioctl should
> > be for edge-triggered interrupts?  My inclination is that it shouldn't
> > have any effect at this point, but that would mean that at this point we
> > should only set the pending variable and try to queue the interrupt if
> > the config is level.  But that also means that when we set the config
> > later, we need to try to queue the interrupt, which we don't do
> > currently, because we rely on the guest not fiddling with the config of
> > an enabled interrupt.
> >
> > Could it be considered an error if user space tries to set the level for
> > an edge-triggered interrupt and therefore something we can just ignore
> > and assume that the corresponing interrupt will be configured as a
> > level-triggered one later?
> 
> Userspace will always read the line-level values out and write
> them back for migration, and I'd rather not make it have to
> do cross-checks against whether the interrupt is edge or level
> triggered to see whether it should write the level values into
> the kernel. Telling the kernel the level for an edge-triggered
> interrupt should be a no-op because it doesn't have any effect
> on pending status.
> 
> > In any case we probably need to clarify the ABI in terms of this
> > particular KVM_DEV_AR_VGIC_GRP_LEVEL_INFO group and how it relates to
> > the config of edge vs. level of interrupts and ordering on restore...
> 
> IIRC the QEMU code restores the config first. (There's a similar
> ordering thing for GICv2 where we have to restore GICD_ICFGRn before
> GICD_ISPENDRn.)
> 

So it sounds to me that we should add a note in the Documentation like
this:

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 9348b3c..7bac20a 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -193,6 +193,11 @@ Groups:
 
 	Bit[n] indicates the status for interrupt vINTID + n.
 
+	Getting or setting the level info for an edge-triggered interrupt is
+	not guaranteed to work.  To restore the complete state of the VGIC, the
+	configuration (edge/level) of interrupts must be restored before
+	restoring the level.
+
     SGIs and any interrupt with a higher ID than the number of interrupts
     supported, will be RAZ/WI.  LPIs are always edge-triggered and are
     therefore not supported by this interface.

Vijay, this means that the first block in your if-statement should only
set pending and queue the interrupt if the interrupt is a level
triggered one.

(Peter, I thought you once argued that it was important for user space
to be able to save/restore the state without any ordering requirements,
but I may have misunderstood.  It is still the option to add something
like the above to the docs but also do our best to allow any ordering of
level/config, but it becomes slightly more invasive.)

Thanks,
-Christoffer
