From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Fri, 17 Jul 2015 11:33:34 +0200
Message-ID: <20150717093334.GA24504@cbox>
References: <559180CA.3050905@arm.com>
 <CAFEAcA-E+KdiL4suQ0DoEvB-zGpNZ7-dq46FegC_iXYRPvo9jA@mail.gmail.com>
 <559185D4.7060308@arm.com>
 <85D36B67-643B-407F-944F-D18D54FF9909@caviumnetworks.com>
 <D805D093-CCFE-4835-853A-B2654DAA10A1@caviumnetworks.com>
 <559642EE.1050605@arm.com>
 <CAFEAcA8nt7yr0K4QesJjWqEwBgziWOt2DViY70E=z2wjt=X7XA@mail.gmail.com>
 <559647A7.7010309@arm.com>
 <CAFEAcA-XyGRLSdQSye5OP6vRQKLZtMY4Erg7jfcpr-oo-HqJ7A@mail.gmail.com>
 <55965F81.5050609@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A0B58BCB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 05:21:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ekGHg3LkCZfo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 05:21:22 -0400 (EDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D1AB58BC6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 05:21:22 -0400 (EDT)
Received: by lagx9 with SMTP id x9so57914570lag.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 02:33:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55965F81.5050609@arm.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "Chalamarla,
 Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 03, 2015 at 11:10:09AM +0100, Marc Zyngier wrote:
> On 03/07/15 10:34, Peter Maydell wrote:
> > On 3 July 2015 at 09:28, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >> On 03/07/15 09:12, Peter Maydell wrote:
> >>> I would still like to see the proponents of this patch say
> >>> what their model is for userspace support of cross-host migration,
> >>> if we're abandoning the model the current API envisages.
> >>
> >> I thought we had discussed this above, and don't really see this as a
> >> departure from the current model:
> >>
> >> - "-cpu host" results in "GENERIC" being used: VM can only be migrated
> >> to the exact same HW (no cross-host migration). MIDR should probably
> >> become RO.
> >> - "-cpu host" results in "A57" (for example): VM can be migrated to a
> >> variety of A57 platforms, and allow for some fuzzing on the revision (or
> >> accept any revision).
> >> - "-cpu a57" forces an A57 model to be emulated, always. It is always
> >> possible to migrate such a VM on any host.
> >>
> >> I think only the first point is new, but the last two are what we have
> >> (or what we should have).
> > 
> > Right, but the implicit idea of this GENERIC patch seems to
> > be that new host CPU types don't get their own KVM_ARM_TARGET_*
> > constant, and are thus forever unable to do cross-host migration.
> > It's not clear to me why we'd want to have new CPUs be second
> > class citizens like that.
> 
> I certainly don't want to see *any* CPU be a second class citizen. But
> let's face it, we're adding more and more targets that don't implement
> anything new, and just satisfy themselves with the generic implementation.
> 
> I see it as an incentive to provide something useful (tables of all the
> registers with default values?) so that cross-host migration becomes a
> reality instead of the figment of our imagination (as it is now). If it
> wasn't already ABI, I'd have removed the existing targets until we have
> something meaningful to put there.

What we're doing now certainly seems silly, because we're adding kernel
patches without bringing anything to the table...

> 
> Now, I also have my own doubts about cross-host migration (timers
> anyone?). But I don't see the above as a change in policy. More as a way
> to outline the fact that we currently don't have the right level of
> information/infrastructure to support it at all.
> 
The one thing that I've lost track of here (sorry) is whether we're
enforcing the inability to do cross-host migration with the generic
target when this patch is merged or do we leave this up to the graces of
userspace?

Thanks,
-Christoffer
