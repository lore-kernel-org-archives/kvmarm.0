From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Tue, 23 Jun 2015 14:39:59 +0200
Message-ID: <20150623123959.GF4035@cbox>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 497ED564EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 08:29:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 00hA31hpZZ32 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jun 2015 08:29:08 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45AC2564E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 08:29:07 -0400 (EDT)
Received: by lbbvz5 with SMTP id vz5so5796030lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2015 05:40:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, timur@codeaurora.org, vgandhi@codeaurora.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 22, 2015 at 09:44:48AM +0100, Peter Maydell wrote:
> On 17 June 2015 at 10:00, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
> > From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> >
> > This patch adds a generic ARM v8 KVM target cpu type for use
> > by the new CPUs which eventualy ends up using the common sys_reg
> > table. For backward compatibility the existing targets have been
> > preserved. Any new target CPU that can be covered by generic v8
> > sys_reg tables should make use of the new generic target.
> 
> How do you intend this to work for cross-host migration?
> Is the idea that the kernel guarantees that "generic" looks
> 100% the same to the guest regardless of host hardware? I'm
> not sure that can be made to work, given impdef differences
> in ID register values, bp/wp registers, and so on.
> 
> Given that, it seems to me that we still need to provide
> KVM_ARM_TARGET_$THISCPU defines so userspace can request
> a specific guest CPU flavour; so what does this patch
> provide that isn't already provided by just having userspace
> query for the "preferred" CPU type as it does already?
> 
I'm guessing the intention is to avoid having to add code in the kernel
to support KVM on a new CPU where nothing else needs to be done to
support KVM on that system.

Wrt. migration, I was also wondering about this.  Would the differences
in the CPU architecture be detected when feeding back the invariant
sysregs from userspace on VM restore?

-Christoffer
