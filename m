Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585CCC43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 18:14:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C58494CAD5;
	Wed, 20 Jul 2022 14:14:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sj-yL1v-i3Cu; Wed, 20 Jul 2022 14:14:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D2FF4CB70;
	Wed, 20 Jul 2022 14:14:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6844CB70
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:14:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0WisMxc1I4FL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 14:14:17 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 978754CAD5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:14:17 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C2503B8217E;
 Wed, 20 Jul 2022 18:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC421C3411E;
 Wed, 20 Jul 2022 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658340854;
 bh=Zy3j8P3splX48YJkjCqikBQJuhtL387mwjUOqWwhZyg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=f1bSc0Yj3ibRsagQc+g6SlYtxYklYtOgYuELU4/xH6eumhIXFB0mvrGzjq7Cq2/rx
 1L+jEMH8/N2dpUzOYhcT6ku+7sO7tjKA+JPJXSBFXDeSA2yZFC6QwIbS7zo3GYVAli
 X+jZ3ubhnXd/DVyN5CD4O+BCW+nIOcvoL7qy9OAZFm79QI9eNd6pX1vbdxD2cA/OSD
 rNMfyoqxx9j+72gIYM95fnrXCTYoTdrlP8UFHxmN70WwsgreKeJW6Ae32G+hX+rraQ
 hqOBKq+TCkoU+034Kv4E36/ZCl+EgW2RUjseeClMBew0i29/Id0e7HycMOhUA6upY6
 Q3tXZDv1WY/oA==
Date: Wed, 20 Jul 2022 19:14:07 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 06/24] KVM: arm64: Unify identifiers used to
 distinguish host and hypervisor
Message-ID: <20220720181406.GA16603@willie-the-truck>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-7-will@kernel.org>
 <YtgbCEOMze8N4TPW@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtgbCEOMze8N4TPW@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Hi Oliver,

Thanks for having a look.

On Wed, Jul 20, 2022 at 03:11:04PM +0000, Oliver Upton wrote:
> On Thu, Jun 30, 2022 at 02:57:29PM +0100, Will Deacon wrote:
> > The 'pkvm_component_id' enum type provides constants to refer to the
> > host and the hypervisor, yet this information is duplicated by the
> > 'pkvm_hyp_id' constant.
> > 
> > Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
> > type definition to 'mem_protect.h' so that it can be used outside of
> > the memory protection code.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 6 +++++-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 --------
> >  arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
> >  3 files changed, 6 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 80e99836eac7..f5705a1e972f 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -51,7 +51,11 @@ struct host_kvm {
> >  };
> >  extern struct host_kvm host_kvm;
> >  
> > -extern const u8 pkvm_hyp_id;
> > +/* This corresponds to page-table locking order */
> > +enum pkvm_component_id {
> > +	PKVM_ID_HOST,
> > +	PKVM_ID_HYP,
> > +};
> 
> Since we have the concept of PTE ownership in pgtable.c, WDYT about
> moving the owner ID enumeration there? KVM_MAX_OWNER_ID should be
> incorporated in the enum too.

Interesting idea... I think we need the definition in a header file so that
it can be used by mem_protect.c, so I'm not entirely sure where you'd like
to see it moved.

The main worry I have is that if we ever need to distinguish e.g. one guest
instance from another, which is likely needed for sharing of memory
between more than just two components, then the pgtable code really cares
about the number of instances ("which guest is it?") whilst the mem_protect
cares about the component type ("is it a guest?").

Finally, the pgtable code is also used outside of pKVM so, although the
concept of ownership doesn't yet apply elsewhere, keeping the concept
available without dictacting the different types of owners makes sense to
me.

Does that make sense?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
