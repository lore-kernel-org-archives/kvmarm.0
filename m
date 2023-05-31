Received: from out-47.mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C416E805
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 19:28:30 +0000 (UTC)
Date: Wed, 31 May 2023 19:28:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685561308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fExwE02o2n9ir13h12C6sJUjb5CZIzSGV94ltztSeYU=;
	b=j6oi+jpW4qEEAfeTqR1gVmlOIouoNE2cZuCQ9g4gmWt/4cyclojreEVXHu8btfeiGiVcDJ
	x4P5UZRMb0dW2T4B2o8jFedTmwMjh8UL0366wjygZebZR43zxO9qUMsie4B5b5unRoLQTv
	JJJh2wVtTtDIseRjA+dHi+WATyCzmmE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Anup Patel <anup@brainfault.org>, Ben Gardon <bgardon@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michael Larabel <michael@michaellarabel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Paul Mackerras <paulus@ozlabs.org>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	linux-mm@google.com
Subject: Re: [PATCH mm-unstable v2 04/10] kvm/arm64: make stage2 page tables
 RCU safe
Message-ID: <ZHef0VsZvZ1Vnz0u@linux.dev>
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-5-yuzhao@google.com>
 <ZHJHJPBF6euzOFdw@linux.dev>
 <CAOUHufa74CufHziHSquO5bZwbFXz2MNssBzW+AH7=Xo5RCnQ0A@mail.gmail.com>
 <ZHZQdQAApIrw6fBu@linux.dev>
 <CAOUHufZOkBmZJgCU2xW2B8S3P3TWERHezy0xKWY9_TeyV9K7Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOUHufZOkBmZJgCU2xW2B8S3P3TWERHezy0xKWY9_TeyV9K7Rg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 30, 2023 at 02:06:55PM -0600, Yu Zhao wrote:
> On Tue, May 30, 2023 at 1:37 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hi Yu,
> >
> > On Sat, May 27, 2023 at 02:13:07PM -0600, Yu Zhao wrote:
> > > On Sat, May 27, 2023 at 12:08 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > index 3d61bd3e591d..bfbebdcb4ef0 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -1019,7 +1019,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > >                                                kvm_granule_size(ctx->level));
> > > >
> > > >         if (childp)
> > > > -               mm_ops->put_page(childp);
> > > > +               mm_ops->free_removed_table(childp, ctx->level);
> > >
> > > Thanks, Oliver.
> > >
> > > A couple of things I haven't had the chance to verify -- I'm hoping
> > > you could help clarify:
> > > 1. For unmapping, with free_removed_table(), wouldn't we have to look
> > > into the table we know it's empty unnecessarily?
> >
> > As it is currently implemented, yes. But, there's potential to fast-path
> > the implementation by checking page_count() before starting the walk.
> 
> Do you mind posting another patch? I'd be happy to ack it, as well as
> the one you suggested above.

I'd rather not take such a patch independent of the test_clear_young
series if you're OK with that. Do you mind implementing something
similar to the above patch w/ the proposed optimization if you need it?

-- 
Thanks,
Oliver
