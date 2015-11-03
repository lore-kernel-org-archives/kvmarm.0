From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 0/3] KVM: arm/arm64: Clean up some obsolete code
Date: Tue, 03 Nov 2015 10:24:18 +0300
Message-ID: <005201d11608$a73edf80$f5bc9e80$@samsung.com>
References: <cover.1445934536.git.p.fedin@samsung.com>
 <20151102211538.GA5819@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CAA54970A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 02:21:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LUSFRWQD6kIb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 02:21:12 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2909449708
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 02:21:11 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX800EQL9WJ3V80@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 03 Nov 2015 07:24:19 +0000 (GMT)
In-reply-to: <20151102211538.GA5819@cbox>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I ran this through my test scripts and I'm now quite sure that there's
> some breakage in here.
> 
> One of my tests is running two VMs in parallel, each booting up, running
> hackbench, and then doing reboot (from within the guest), and just
> repeating like that.
> 
> I've run your patches in the above config 100 times, and every time,
> the rebooting VMs got stuck before 50 reboots.
> 
> Without these patches, I could run the above config 100 times, and every
> time, the rebooting VMs passed 200 reboots.

 Huh, the description looks like some problem with vgic_retire_disabled_irqs(). By the way, during reboot, who does call it? The
only call i see is in vgic_handle_enable_reg(), which obviously just processes emulated register accesses...
 And the only thing i know is that in case of GICv2 the userland resets vGIC manually by resetting each register to its default
value (therefore all ENABLER are set to 0). At least qemu does this, and i'm not sure about kvmtool. And in case of vGICv3 nobody
can do this because there's no API to set registers yet. So, could we be rebooting with interrupts enabled or something like that?
 So: what kind of container are you running and what vGIC version? Does this problem reproduce with both vGICv2 and vGICv3?

 By this time i'll make a very minimal version of patch 0001, for you to test it. If we have problems with current 0001, which we
cannot solve quickly, we could stick to that version then, which will provide the necessary changes to plug in LPIs, yet with
minimal changes (it will only remove vgic_irq_lr_map).
 I guess i should have done it before. Or, i could even respin v5, with current 0001 split up. This should make it easier to bisect
the problem.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
