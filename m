From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 09/16] KVM: arm64: Allow ID registers to by
 dynamically read-as-zero
Date: Thu, 9 Aug 2018 11:19:14 +0100
Message-ID: <20180809101911.GM9097@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-10-git-send-email-Dave.Martin@arm.com>
 <20180806130324.GA5985@e113682-lin.lund.arm.com>
 <20180807110958.GC9097@e103592.cambridge.arm.com>
 <20180807193512.GH5985@e113682-lin.lund.arm.com>
 <20180808091111.GL9097@e103592.cambridge.arm.com>
 <CAFEAcA_9JDzj3NSrJcR6fkVm=Cuy71B_te+PUDJgDvV1gkDLSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0CA4A0E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Aug 2018 06:19:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vpbt2+QeO-Kk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Aug 2018 06:19:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79CE440184
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Aug 2018 06:19:19 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA_9JDzj3NSrJcR6fkVm=Cuy71B_te+PUDJgDvV1gkDLSQ@mail.gmail.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 08, 2018 at 03:03:31PM +0100, Peter Maydell wrote:
> On 8 August 2018 at 10:11, Dave Martin <Dave.Martin@arm.com> wrote:
> > At its heart, I'm trying to abstract out the special behaviour of
> > all unallocated ID registers, so that we can decide at runtime which
> > ones to hide fro the guest: within the ID register block, each
> > unallocated register becomes RAZ, not UNDEFINED as would be the case
> > for other system registers, so we need to capture both behaviours.
> 
> I think a better way to think of the ID register block is
> that all the registers in it *are* allocated. It's just that
> some of them are specified as RAZ/WI (because no bits in
> them have been given meaning yet). Then you retain the
> straightforward "unallocated == UNDEF". (In the Arm ARM
> the gaps in the ID register block are documented as
> "reserved, RAZ", not "unallocated".)

Sure, I'm not arguing against that.  Your viewpoint does mean that
"enabling"/"disabling" a system register needs to do different things
depending on whether it's an ID register or not: in the latter case,
disabling it makes it unallocated; in the former case it doesn't but
makes the register read as zero.

I think my attempt to conflate the two behaviours was not helpful.

The way the existing code was structured was not helpful for solving
this either, which is one reason I ended up with my approach, but I will
take another look and see if I can some up with something a bit more
sane.

Cheers
---Dave
