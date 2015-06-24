From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Wed, 24 Jun 2015 10:51:28 +0200
Message-ID: <20150624085128.GA22785@cbox>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
 <558A6A84.5020603@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB3E56C69
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 04:40:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LVwP7IeIWWDK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 04:40:34 -0400 (EDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB99B56C68
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 04:40:33 -0400 (EDT)
Received: by laka10 with SMTP id a10so21830592lak.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 01:51:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <558A6A84.5020603@arm.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 24, 2015 at 09:29:56AM +0100, Marc Zyngier wrote:
> On 22/06/15 09:44, Peter Maydell wrote:
> > On 17 June 2015 at 10:00, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
> >> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> >>
> >> This patch adds a generic ARM v8 KVM target cpu type for use
> >> by the new CPUs which eventualy ends up using the common sys_reg
> >> table. For backward compatibility the existing targets have been
> >> preserved. Any new target CPU that can be covered by generic v8
> >> sys_reg tables should make use of the new generic target.
> > 
> > How do you intend this to work for cross-host migration?
> 
> It is not meant to work for cross migration at all.
> 
> > Is the idea that the kernel guarantees that "generic" looks
> > 100% the same to the guest regardless of host hardware? I'm
> > not sure that can be made to work, given impdef differences
> > in ID register values, bp/wp registers, and so on.
> > 
> > Given that, it seems to me that we still need to provide
> > KVM_ARM_TARGET_$THISCPU defines so userspace can request
> > a specific guest CPU flavour; so what does this patch
> > provide that isn't already provided by just having userspace
> > query for the "preferred" CPU type as it does already?
> 
> The way I see this working is that a "generic" CPU cannot be migrated
> (because we don't know anything about it). If it can be identified as a
> known (non generic) implementation, then we can migrate it.
> 
Concretely, how should this work?  Be enforced by userspace or should we
deny certain SET_ONE_REG operations from working on this target?

Also, can we imagine any scenario where the generic CPU cannot me
modeled for a VM on a specific piece of hardware (current or future)?

-Christoffer
