Received: from out-36.mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1F6200AD
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 19:37:38 +0000 (UTC)
Date: Tue, 30 May 2023 19:37:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685475455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJBcu8ATCUO1aDY2yQ8vOVcCThAxEWqTiihzn189BcI=;
	b=oTgfsm6Y7m0cHeGsa3KJXNWXMuNSlm0sfaQCoEPDjFj6jxNxzseINRPUWevletZvuYk83p
	+kFUfwmLUYdIL6pvdibsqLd2oceBrIf/xJKHf7O+W7xiGADvFsQD0goq381G/kYiPU+lqt
	jv2kELueVaqLNY647oTCnG+i/dK3+OY=
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
Message-ID: <ZHZQdQAApIrw6fBu@linux.dev>
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-5-yuzhao@google.com>
 <ZHJHJPBF6euzOFdw@linux.dev>
 <CAOUHufa74CufHziHSquO5bZwbFXz2MNssBzW+AH7=Xo5RCnQ0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOUHufa74CufHziHSquO5bZwbFXz2MNssBzW+AH7=Xo5RCnQ0A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Yu,

On Sat, May 27, 2023 at 02:13:07PM -0600, Yu Zhao wrote:
> On Sat, May 27, 2023 at 12:08 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 3d61bd3e591d..bfbebdcb4ef0 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1019,7 +1019,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >                                                kvm_granule_size(ctx->level));
> >
> >         if (childp)
> > -               mm_ops->put_page(childp);
> > +               mm_ops->free_removed_table(childp, ctx->level);
> 
> Thanks, Oliver.
> 
> A couple of things I haven't had the chance to verify -- I'm hoping
> you could help clarify:
> 1. For unmapping, with free_removed_table(), wouldn't we have to look
> into the table we know it's empty unnecessarily?

As it is currently implemented, yes. But, there's potential to fast-path
the implementation by checking page_count() before starting the walk.

> 2. For remapping and unmapping, how does free_removed_table() put the
> final refcnt on the table passed in? (Previously we had
> put_page(childp) in stage2_map_walk_table_post(). So I'm assuming we'd
> have to do something equivalent with free_removed_table().)

Heh, that's a bug, and an embarrassing one at that!

Sent out a fix for that, since it would appear we leak memory on
table->block transitions. PTAL if you have a chance.

https://lore.kernel.org/all/20230530193213.1663411-1-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
