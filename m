Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F330EC00144
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jul 2022 19:28:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5784D4C1AF;
	Fri, 29 Jul 2022 15:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UUL3j4FRDq26; Fri, 29 Jul 2022 15:28:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B941A4C18F;
	Fri, 29 Jul 2022 15:28:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAD2E4C18F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jul 2022 15:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GftFzQpfYDyx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jul 2022 15:28:17 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 703F24C029
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jul 2022 15:28:17 -0400 (EDT)
Date: Fri, 29 Jul 2022 19:28:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1659122895;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hGAAQQims/x+aVkjeXh2pO3zuX49eGIs7h2PdGd4m9k=;
 b=rQXuzbUlhy1H2pl2MLh/fFzXumhLDJ1JmxPLp9XsRjxgk5EM2up8wOI94Wy6GEXKWBDCOu
 uqX9RQF/oULzk6hI2zFHjlgwyY+Yl6wrh35P6gVDjBNPYihBnycuHu99Gdw2aX1LmHSHiE
 Q6O8rTbFdMTQpb4uya6GSPgXVbjxsEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 06/24] KVM: arm64: Unify identifiers used to
 distinguish host and hypervisor
Message-ID: <YuQ0ypCVgfMjJOew@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-7-will@kernel.org>
 <YtgbCEOMze8N4TPW@google.com>
 <20220720181406.GA16603@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220720181406.GA16603@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

Hi Will,

Sorry, I didn't see your reply til now.

On Wed, Jul 20, 2022 at 07:14:07PM +0100, Will Deacon wrote:
> Hi Oliver,
> 
> Thanks for having a look.
> 
> On Wed, Jul 20, 2022 at 03:11:04PM +0000, Oliver Upton wrote:
> > On Thu, Jun 30, 2022 at 02:57:29PM +0100, Will Deacon wrote:
> > > The 'pkvm_component_id' enum type provides constants to refer to the
> > > host and the hypervisor, yet this information is duplicated by the
> > > 'pkvm_hyp_id' constant.
> > > 
> > > Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
> > > type definition to 'mem_protect.h' so that it can be used outside of
> > > the memory protection code.
> > > 
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 6 +++++-
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 --------
> > >  arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
> > >  3 files changed, 6 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > index 80e99836eac7..f5705a1e972f 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > @@ -51,7 +51,11 @@ struct host_kvm {
> > >  };
> > >  extern struct host_kvm host_kvm;
> > >  
> > > -extern const u8 pkvm_hyp_id;
> > > +/* This corresponds to page-table locking order */
> > > +enum pkvm_component_id {
> > > +	PKVM_ID_HOST,
> > > +	PKVM_ID_HYP,
> > > +};
> > 
> > Since we have the concept of PTE ownership in pgtable.c, WDYT about
> > moving the owner ID enumeration there? KVM_MAX_OWNER_ID should be
> > incorporated in the enum too.
> 
> Interesting idea... I think we need the definition in a header file so that
> it can be used by mem_protect.c, so I'm not entirely sure where you'd like
> to see it moved.
> 
> The main worry I have is that if we ever need to distinguish e.g. one guest
> instance from another, which is likely needed for sharing of memory
> between more than just two components, then the pgtable code really cares
> about the number of instances ("which guest is it?") whilst the mem_protect
> cares about the component type ("is it a guest?").
> 
> Finally, the pgtable code is also used outside of pKVM so, although the
> concept of ownership doesn't yet apply elsewhere, keeping the concept
> available without dictacting the different types of owners makes sense to
> me.

Sorry, it was a silly suggestion to wedge the enum there. I don't think
it matters too much where it winds up, but something like:

  enum kvm_pgtable_owner_id {
  	OWNER_ID_PKVM_HOST,
	OWNER_ID_PKVM_HYP,
	NR_PGTABLE_OWNER_IDS,
  }

And put it somewhere that both pgtable.c and mem_protect.c can get at
it. That way bound checks (like in kvm_pgtable_stage2_set_owner())
organically work as new IDs are added.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
