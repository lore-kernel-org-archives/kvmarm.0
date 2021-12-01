Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E612CC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 16:09:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 693C84B253;
	Wed,  1 Dec 2021 11:09:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DjVJrnqdDQHp; Wed,  1 Dec 2021 11:09:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9CE4B24F;
	Wed,  1 Dec 2021 11:09:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDE774B24F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 11:09:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V6hM7tadnQC1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 11:09:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C4E4B23F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 11:09:17 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA79F143B;
 Wed,  1 Dec 2021 08:09:16 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58FC13F766;
 Wed,  1 Dec 2021 08:09:15 -0800 (PST)
Date: Wed, 1 Dec 2021 16:09:09 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
Message-ID: <YaeeJUGRwZN00byk@monolith.localdoman>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <YaeabhZnYNLQcejs@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YaeabhZnYNLQcejs@monolith.localdoman>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Eric Auger <eauger@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On Wed, Dec 01, 2021 at 03:53:18PM +0000, Alexandru Elisei wrote:
> Hi Reiji,
> 
> On Mon, Nov 29, 2021 at 09:32:02PM -0800, Reiji Watanabe wrote:
> > Hi Eric,
> > 
> > On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> > >
> > > Hi Reiji,
> > >
> > > On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > > > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > > > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > > > expose the value for the guest as it is.  Since KVM doesn't support
> > > > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > > > exopse 0x0 (PMU is not implemented) instead.
> > > s/exopse/expose
> > > >
> > > > Change cpuid_feature_cap_perfmon_field() to update the field value
> > > > to 0x0 when it is 0xf.
> > > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > guest should not use it as a PMUv3?
> > 
> > > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > guest should not use it as a PMUv3?
> > 
> > For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> > Arm ARM says:
> >   "IMPLEMENTATION DEFINED form of performance monitors supported,
> >    PMUv3 not supported."
> > 
> > Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> > be exposed to guests (And this patch series doesn't allow userspace
> > to set the fields to 0xf for guests).
> 
> While it's true that a value of 0xf means that PMUv3 is not present (both
> KVM and the PMU driver handle it this way) this is an userspace visible
> change.
> 
> Are you sure there isn't software in the wild that relies on this value
> being 0xf to detect that some non-Arm architected hardware is present?
> 
> Since both 0 and 0xf are valid values that mean that PMUv3 is not present,
> I think it's best that both are kept.

Sorry, somehow I managed to get myself confused and didn't realize that
this is only used by KVM.

What I said above about the possibility of software existing that pokes IMP
DEF registers when PMUVer = 0xf is in fact a good argument for this patch,
because KVM injects an undefined exception when a guest tries to access
such registers.

Thanks,
Alex

> 
> Thanks,
> Alex
> 
> > 
> > Thanks,
> > Reiji
> > 
> > >
> > > Eric
> > > >
> > > > Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/cpufeature.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > > > index ef6be92b1921..fd7ad8193827 100644
> > > > --- a/arch/arm64/include/asm/cpufeature.h
> > > > +++ b/arch/arm64/include/asm/cpufeature.h
> > > > @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
> > > >
> > > >       /* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
> > > >       if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
> > > > -             val = 0;
> > > > +             return (features & ~mask);
> > > >
> > > >       if (val > cap) {
> > > >               features &= ~mask;
> > > >
> > >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
