Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AD8C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 00:42:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 120554BA87;
	Wed,  9 Nov 2022 19:42:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X40i-Fs45to5; Wed,  9 Nov 2022 19:42:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9D424BA33;
	Wed,  9 Nov 2022 19:42:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC484BA33
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 19:42:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9DpqedtBZjb6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 19:42:43 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BFF34BA20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 19:42:43 -0500 (EST)
Date: Thu, 10 Nov 2022 00:42:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668040957;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eRsf0Yc4TqMwAER5aigpmti9/PEPuMa0WpzYqXNDuZQ=;
 b=UuU4JWtH6hrysbqKc1ioxoB5HBtTUJyV8uJwQFyFfhNihzi9THDz32XiDMeZv+yHDKPUG6
 I0cv2eH5ozct40aebDkeJeN7KPcNmqNEz735Joj7pb37DJ/jdukf63ug93Av4unMBLwuwp
 AkkC9TIiQNoU+AHi4kx4af5ehX0lP1o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 01/14] KVM: arm64: Combine visitor arguments into a
 context structure
Message-ID: <Y2xI+bw8i2iboHxL@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-2-oliver.upton@linux.dev>
 <190fd3d3-bf86-23cf-0424-336577655e8f@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <190fd3d3-bf86-23cf-0424-336577655e8f@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
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

Hi Gavin,

On Thu, Nov 10, 2022 at 08:23:36AM +0800, Gavin Shan wrote:
> On 11/8/22 5:56 AM, Oliver Upton wrote:
> > Passing new arguments by value to the visitor callbacks is extremely
> > inflexible for stuffing new parameters used by only some of the
> > visitors. Use a context structure instead and pass the pointer through
> > to the visitor callback.
> > 
> > While at it, redefine the 'flags' parameter to the visitor to contain
> > the bit indicating the phase of the walk. Pass the entire set of flags
> > through the context structure such that the walker can communicate
> > additional state to the visitor callback.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h  |  15 +-
> >   arch/arm64/kvm/hyp/nvhe/mem_protect.c |  10 +-
> >   arch/arm64/kvm/hyp/nvhe/setup.c       |  16 +-
> >   arch/arm64/kvm/hyp/pgtable.c          | 269 +++++++++++++-------------
> >   4 files changed, 154 insertions(+), 156 deletions(-)
> > 
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> One nit below.
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 3252eb50ecfe..607f9bb8aab4 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -199,10 +199,17 @@ enum kvm_pgtable_walk_flags {
> >   	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
> >   };
> > -typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
> > -					kvm_pte_t *ptep,
> > -					enum kvm_pgtable_walk_flags flag,
> > -					void * const arg);
> > +struct kvm_pgtable_visit_ctx {
> > +	kvm_pte_t				*ptep;
> > +	void					*arg;
> > +	u64					addr;
> > +	u64					end;
> > +	u32					level;
> > +	enum kvm_pgtable_walk_flags		flags;
> > +};
> > +
> > +typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
> > +					enum kvm_pgtable_walk_flags visit);
> 
> Does it make sense to reorder these fields in the context struct based on
> their properties.

The ordering was a deliberate optimization for space. Your suggestion
has 8 bytes of implicit padding:

>     struct kvm_pgtable_visit_ctx {
>            enum kvm_pgtable_walk_flags     flags;

here

>            u64                             addr;
>            u64                             end;
>            u32                             level;

and here.

>            kvm_pte_t                       *ptep;
>            void                            *arg;
>     };

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
