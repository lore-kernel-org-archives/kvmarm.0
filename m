Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D1119930
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 17:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14ACC433D2;
	Thu,  8 Jun 2023 17:57:09 +0000 (UTC)
Date: Thu, 8 Jun 2023 18:57:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>, jingzhangos@google.com,
	alexandru.elisei@arm.com, james.morse@arm.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	oupton@google.com, pbonzini@redhat.com, rananta@google.com,
	reijiw@google.com, suzuki.poulose@arm.com, tabba@google.com,
	will@kernel.org, sjitindarsingh@gmail.com
Subject: Re: [PATCH 3/3] KVM: arm64: Use per guest ID register for
 ID_AA64PFR1_EL1.MTE
Message-ID: <ZIIWc5v67cpMqEMU@arm.com>
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602221447.1809849-1-surajjs@amazon.com>
 <20230602221447.1809849-4-surajjs@amazon.com>
 <873539ospa.wl-maz@kernel.org>
 <87h6rl50dl.fsf@redhat.com>
 <87legwo83z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87legwo83z.wl-maz@kernel.org>

On Tue, Jun 06, 2023 at 05:42:24PM +0100, Marc Zyngier wrote:
> On Mon, 05 Jun 2023 17:39:50 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> > On Sat, Jun 03 2023, Marc Zyngier <maz@kernel.org> wrote:
> > > On Fri, 02 Jun 2023 23:14:47 +0100,
> > > Suraj Jitindar Singh <surajjs@amazon.com> wrote:
> > >> 
> > >> With per guest ID registers, MTE settings from userspace can be stored in
> > >> its corresponding ID register.
> > >> 
> > >> No functional change intended.
> > >> 
> > >> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> > >> ---
> > >>  arch/arm64/include/asm/kvm_host.h | 21 ++++++++++-----------
> > >>  arch/arm64/kvm/arm.c              | 11 ++++++++++-
> > >>  arch/arm64/kvm/sys_regs.c         |  5 +++++
> > >>  3 files changed, 25 insertions(+), 12 deletions(-)
> > >> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > >> index ca18c09ccf82..6fc4190559d1 100644
> > >> --- a/arch/arm64/kvm/arm.c
> > >> +++ b/arch/arm64/kvm/arm.c
> > >> @@ -80,8 +80,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >>  		if (!system_supports_mte() || kvm->created_vcpus) {
> > >>  			r = -EINVAL;
> > >>  		} else {
> > >> +			u64 val;
> > >> +
> > >> +			/* Protects the idregs against modification */
> > >> +			mutex_lock(&kvm->arch.config_lock);
> > >> +
> > >> +			val = IDREG(kvm, SYS_ID_AA64PFR1_EL1);
> > >> +			val |= FIELD_PREP(ID_AA64PFR1_EL1_MTE_MASK, 1);
> > >
> > > The architecture specifies 3 versions of MTE in the published ARM ARM,
> > > with a 4th coming up as part of the 2022 extensions.
> > 
> > Is that the one that adds some more MTE<foo> bits in AA64PFR1 and
> > AA64PFR2?
> 
> Yeah, that. You get ID_AA64PFR1_EL1.{MTE,MTE_frac,MTEX}, plus
> ID_AA64PFR2_EL1.{MTEFAR,MTESTOREONLY,MTEPERM}... It this sounds like a
> train wreck, then it probably is one!

I stared about an hour at that documentation and I think I got it (well,
for the next couple of hours). The disappearing of MTE_FEAT_ASYNC from
MTE2 is potentially problematic but the worst that can happen is that
async faults are simply not triggered (and TBH, those "faults" were not
that useful anyway). MTE4 without ASYM is defined in a weird way.
Basically there's no such thing as MTE4, just 2 and 3 (the latter
bringing in ASYM) with some extra features like store-only, stage 2
permission, canonical tag checking.

I don't think any of these new MTE extensions add any state that KVM
should care context-switch, so we should be fine. Does KVM limit the
maximum value of the ID field exposed to user? Some future MTE9 may add
new state, so better to be safe (I thought we handled these cases but
can't find it now).

It's also probably safe to disable MTE altogether if there's any
difference between all these fields on different CPUs (I don't think we
currently do, we just go for lower safe while ignoring MTE_frac, MTEX).

Regarding MTEX, I don't think Linux would ever make use of the canonical
tag checking. The enabling bit is unfortunately in TCR_EL1 which we
don't context-switch (and maybe cached in the TLB, I haven't checked the
latest spec).

-- 
Catalin
