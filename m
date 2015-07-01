From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 10/10] KVM: arm/arm64: vgic: Allow non-shared device HW
 interrupts
Date: Wed, 1 Jul 2015 10:57:03 +0200
Message-ID: <20150701085703.GC11332@cbox>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-11-git-send-email-marc.zyngier@arm.com>
 <20150630201903.GX11332@cbox> <5593A453.4090903@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4041356BBA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2015 04:45:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BPs4WvzyEQL4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2015 04:45:50 -0400 (EDT)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
 [209.85.217.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3633F56BB6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2015 04:45:50 -0400 (EDT)
Received: by lbbpo10 with SMTP id po10so8646644lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Jul 2015 01:57:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5593A453.4090903@arm.com>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 01, 2015 at 09:26:59AM +0100, Marc Zyngier wrote:
> On 30/06/15 21:19, Christoffer Dall wrote:
> > On Mon, Jun 08, 2015 at 06:04:05PM +0100, Marc Zyngier wrote:
> >> So far, the only use of the HW interrupt facility is the timer,
> >> implying that the active state is context-switched for each vcpu,
> >> as the device is is shared across all vcpus.
> >>
> >> This does not work for a device that has been assigned to a VM,
> >> as the guest is entierely in control of that device (the HW is
> >> not shared). In that case, it makes sense to bypass the whole
> >> active state switchint, and only track the deactivation of the
> >> interrupt.
> >>
> > The discinction here between shared and non-shared feels a bit arbitrary
> > (it may not be, but just feel that way) and I can't easily convince
> > myself that this is the logical/correct/all-encompassing word to
> > describe the nature of the two devices.
> 
> Does the idea of global vs private resource feel more correct?
> 
I think shared covers that equally well.  This feels like one of those
things that just doesn't make intuitive sense on its own but when you
think about the cases we are familiar with, then it fits for now.  So
what you have here is probably as good as it gets and hopefully it does
cover all the cases we care about, i.e. shared and non-shared :)

-Christoffer
