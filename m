Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795382950;
	b=EEHbfg33P0gu4QgPw70e/r15ITAFlYSUHzhFcfxMnfd8KJ/pXCJeNu/b04YdSoqqsXNI
	 RIVtjExYk6EvZpQlzVaQpR/TYVJBcijRt8s+a/d/VdPNG9hbfyee1UCy5gSpnxVTR4DE3
	 J4f768NFPOqzCEcQAR2Ky1smxqpsIEz4J2g7LPpqe6sk+mZnkSofkeIIZ01UMvglkiV1d
	 YxUGoJR19LcO96MhVGeoOIMpMB9zZfhLfH2eNGvTEQKE+9QLT35vloa7hKEh6NhdkGDXB
	 ev73I84TsOf2d7OSyfa2i+9sklJ/EHKRZ7/kcIive6imjiTaZAF4W8VISPZ/YEd31EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795382950;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BTV0zF8Ij6zUMNBE+Oz8/N1ZVrqV9XG9B7wmhsB51vI=;
	b=oXwAI/fJ0xrfgw4b/kdqV5jcn7bE0kOTIjwnW4gCz+Lt7nzUVHHl7pznFFxiQBFQeidJ
	 BJrLcGN54Vd/PGqY9F5mTgOOT5Kw8XeC2CbX1UwPnGH0PoIfjcOcs2t2gHdOe6cXW8kZ0
	 fNIpMf0092V1I8Ta2/rUiFPTwxcxwdroDtQrSbO3T3Xdb9yY/tPiwHurP1nAuVSKdrgkq
	 CEfH7R2GoCFsURTcqIUr4gQ3fsBH5Mt7Ns/GN/Z5n4Bi+ryd9pfiWTqoBZpStH95E64SG
	 tbmD6fc3VE0LrKcwbu72j9r0wD1UZNkkNcQqaUvhfpKC3W4zEW98io7B5+Lfl0hjPsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WG54opzt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0F1606A31E
	for <kvmarm@lists.linux.dev>; Sun, 22 Nov 2026 21:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WG54opzt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F301F000D0
	for <kvmarm@lists.linux.dev>; Sun, 22 Nov 2026 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795382949;
	bh=BTV0zF8Ij6zUMNBE+Oz8/N1ZVrqV9XG9B7wmhsB51vI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WG54opztWi+ll7+PUc6eBXqw494LZjxIVJ0DKsOEfPBVjJTxRSg1R7ywaqbRHIXza
	 VazTaVz5alcKWtxPjpyt9HYyPuJTofmTz+8e/maD+l2IpS8DqfZjP0zUXVTezJDte0
	 SjZsXl9DSYkB8/hove8ERjgLKOc+ZHNEs6IDjDzHL7NxRuWchw69iLDkGo0NLU2xdo
	 8Hzau6EhHX6AhVk1259DZeOfEqoymIG0dhHjJsBRCeEcaYjJk3ioWBZwitbEi/yBjj
	 IA20Phq6/J8wU/WfLd6OgMcWvRFunqG5FUMxAlFCKFdiywCWLU+exJ7jprSB+jKsuv
	 X2O/DctYxrKAA==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ae2fb3fe2fso23496511fa.2
        for <kvmarm@lists.linux.dev>; Sun, 22 Nov 2026 13:29:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEhopZ4Re30b5Ea6edJms+siEjQ1I5nS8naQW1V4ltRiAizXlwaZJ7OLNr4Damvo7MUDeTaFjk=@lists.linux.dev
X-Gm-Message-State: APuU4Z+Mu+jMmc0LaGdeVwrkoi7jALH7zvzrmfich98VvD4oApUvKdlW
	XJPnLNisCTBluJyCsVlBypLu44drHnb+jaAtSoc3GuOqwTupbyGSmTJcToNyOmPOP7u7IpAm3yQ
	xwX/TlIKmQBTrXbNXAujhs5HlZPjIcnY=
X-Received: by 2002:a05:6512:4207:b0:5bf:ce41:b440 with SMTP id
 2adb3069b0e04-5c1bc7d6de5mr2517796e87.31.1795382947589; Sun, 22 Nov 2026
 13:29:07 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261015142552.4128028-1-ryan.roberts@arm.com> <20261015142552.4128028-9-ryan.roberts@arm.com>
In-Reply-To: <20261015142552.4128028-9-ryan.roberts@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sun, 22 Nov 2026 22:28:54 +0100
X-Gmail-Original-Message-ID: <CAD++jLnY3dagTQDzBa5e=g3fJ1rDOvyRHPKVtpadV4c0nXYV4Q@mail.gmail.com>
X-Gm-Features: Aa3M54r6B7e9BLC1UO5yqTkRPrBtuKJXzOWhi_mL44xox65BnkoSkli_lYPdSwU
Message-ID: <CAD++jLnY3dagTQDzBa5e=g3fJ1rDOvyRHPKVtpadV4c0nXYV4Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 08/15] misc/arm-cla: Manage domain contexts
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jean-Philippe Brucker <jpb@kernel.org>, Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ryan,

thanks for your patch!

On Thu, Oct 15, 2026 at 4:27=E2=80=AFPM Ryan Roberts <ryan.roberts@arm.com>=
 wrote:

> A CLA domain cannot be used by multiple address spaces concurrently

Which address space? The physical one? The virtual address
space of the CPU for a certain CLA? The virtual address space
of the CLA on a certain CPU, as found from it's TTBR0/1?
I suspect the last one, but it needs clarifying.

And so the domain is definied in hardware but there is
a footgun waiting to be fired by not defining the virtual
address space exactly the same on all CLA:s in the domain?

Please elaborate.

> because its devices share a memory translation context and may
> communicate without isolation.

Again I stumble here. "without isolation". So this kind of resoning
implies I know of some isolation that I cannot have. But I don't
know that, I have no idea what kind of isolation I would want here.

This needs to be explained differently.

> Represent each user of a domain with a
> context keyed by the mm_struct and device file description, and track
> contexts in a per-domain hash table.

This I understand.

> Add a domain scheduler that queues contexts for assignment

Are these contexts the software abstraction of hardware
constraints (such as the virtual memory space)
around a certain domain, and since they are scheduled,
these constraints are then applied over a certain time window?

> and gives
> each one a fixed time slice. Before switching, revoke the outgoing
> context's mappings from all VMAs for the device file. Then save its
> accelerator state and remove its MTC, before installing the incoming
> context's MTC and restoring the incoming accelerator state.

I think I start to understand a little...

> Run hardware operations through CPU-bound kthread workers, since each
> CLA can only be accessed from its local CPU. Coordinate the per-device
> workers with a domain worker so that every CLA in the domain is switched
> as a single assignment unit.
>
> Treat a failure on any device as a failure of the whole domain. Stop
> further assignments and wake all waiters when a domain becomes unusable.
>
> Co-developed-by: Jean-Philippe Brucker <jpb@kernel.org>
> Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

OK this is some kind of scheduler let's look, but right before we
start you should probably define the principles of this scheduler?
FIFO? round-robin? Something else?

>  extern struct xarray cla_domains;

Nice use of xarray


> +static inline void cla_ctx_get(struct cla_ctx *ctx)
> +{
> +       kref_get(&ctx->refcnt);
> +}
> +
> +static inline void cla_ctx_put(struct cla_ctx *ctx)
> +{
> +       kref_put(&ctx->refcnt, cla_ctx_free);
> +}

Rename these something like _addref/_dropref or just inline
the kref calls. These names upsets the kernel conventions
for _get()/_put() of resources, see below.

> +/**
> + * cla_ctx_create - Create a context or increase its user count

Something that creates or increase a context should be named
cla_ctx_get() to avoid ambiguousness.

> +/**
> + * cla_ctx_destroy - Drop a context user

No it drops the reference and drops the context (destroy it) if the
usecount =3D=3D 0.

Name it cla_ctx_put() to follow kernel patterns.

> +       /* Release initial reference from cla_ctx_create(). */
> +       cla_ctx_put(ctx);

So this needs a different name.

> +++ b/drivers/misc/arm-cla/cla-sched.c

I wanna spend some time here since this is RFC and we are looking
more at design than code details.

> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Arm CLA driver - domain scheduling

In this header explain the principles for the scheduling, as well as in the
commit message.

> +#include <linux/cpuhplock.h>
> +#include <linux/rhashtable.h>
> +
> +#include "arm-cla.h"
> +
> +static struct cla_ctx invalid_ctx;
> +
> +static const struct rhashtable_params ctxs_rht_params =3D {
> +       .head_offset =3D offsetof(struct cla_ctx, node),
> +       .key_offset =3D offsetof(struct cla_ctx, key),
> +       .key_len =3D sizeof(((struct cla_ctx *)0)->key),
> +       .automatic_shrinking =3D true,
> +};

Neat!

> +static int __cla_domain_switch_ctx(struct cla_domain *domain,
> +                                  struct cla_ctx *prev_ctx,
> +                                  struct cla_ctx *next_ctx)

Is this one of those "__ means __inner_function()"?

Name it for exactly what it does instead.

> +static int cla_domain_switch_ctx(struct cla_domain *domain,
> +                                struct cla_ctx *prev_ctx,
> +                                struct cla_ctx *next_ctx,
> +                                struct cla_ctx **assigned_ctx)

Looks OK.

> +/*
> + * Run on the cla's local CPU, either in its worker or a CPU hotplug cal=
lback.
> + * Work submitters hold cpus_read_lock() until completion, excluding hot=
plug
> + * callbacks and keeping the worker bound. Hotplug callbacks hold domain=
->lock
> + * to protect the assigned context. Other devices may switch concurrentl=
y.
> + * On failure, mark the device broken; the caller handles domain failure=
.
> + */
> +int cla_dev_switch_ctx(struct cla_dev *dev, struct cla_ctx *prev_ctx,
> +                      struct cla_ctx *next_ctx)

Good explanation and name, easy to understand.

> +void cla_dev_switch_ctx_work(struct kthread_work *work)

Here too

> +static inline struct cla_ctx *cla_domain_get_next_ctx(struct cla_domain =
*domain)
> +{
> +       return list_first_entry_or_null(&domain->queued_ctxs, struct cla_=
ctx,
> +                                       queue_node);
> +}

This looks like a FIFO thing?

> +static inline struct cla_ctx *cla_domain_get_prev_ctx(struct cla_domain =
*domain,
> +                                                     struct cla_ctx *nex=
t_ctx)
> +{
> +       if (domain->assigned_ctx && (next_ctx || cla_ctx_is_dying(domain-=
>assigned_ctx)))
> +               return domain->assigned_ctx;
> +       return NULL;
> +}
> +
> +static void cla_vma_zap_domain(struct vm_area_struct *vma, struct cla_do=
main *domain)

"zap" is a very ambiguous word. This function needs to have
a name that express exactly what it does.

It looks like it should rather be infixed _initialize_?

cla_domain_initialize_vma()?
cla_domain_reinitialize_vma()?

> +{
> +       unsigned long vma_start =3D vma->vm_pgoff;
> +       unsigned long vma_end =3D vma_start + vma_pages(vma);
> +       unsigned long domain_start =3D domain->pg_offset;
> +       unsigned long domain_end =3D domain_start + domain->nr_devs;
> +       unsigned long start =3D max(vma_start, domain_start);
> +       unsigned long end =3D min(vma_end, domain_end);
> +       unsigned long addr;
> +       unsigned long size;
> +
> +       if (start >=3D end)
> +               return;
> +
> +       addr =3D vma->vm_start + ((start - vma_start) << PAGE_SHIFT);
> +       size =3D (end - start) << PAGE_SHIFT;
> +       zap_special_vma_range(vma, addr, size);

That goes for that function too by the way. Two wrongs does not
make one right.

It might be that everyone in memory management disagree with
me and think this is crystal clear, then I can have other opinions.

> +static void cla_domain_zap(struct cla_domain *domain, struct cla_ctx *ct=
x)

And this one.

cla_domain_init()?
cla_domain_reinit()?

> +static void cla_domain_reassign(struct kthread_work *work)

What about a comment above this function explaining
what is being reassigned to what?

> +       /*
> +        * Exclude cpuhp until assigned_ctx reflects the hardware again. =
cpuhp
> +        * callbacks use it to save/restore the local device and must not=
 see
> +        * invalid_ctx. Take before domain->lock, also used by cpuhp call=
backs.
> +        */
> +       cpus_read_lock();
> +       mutex_lock(&domain->lock);
> +       if (domain->broken)
> +               goto out_unlock;
> +
> +       /* Figure out prev_ctx and next_ctx. NULL indicates don't [un]ass=
ign. */
> +       next_ctx =3D cla_domain_get_next_ctx(domain);
> +       prev_ctx =3D cla_domain_get_prev_ctx(domain, next_ctx);
> +
> +       if (!prev_ctx && !next_ctx)
> +               goto out_unlock;
> +
> +       /* prev_ctx already holds its assignment reference. */
> +       if (next_ctx)
> +               cla_ctx_get(next_ctx);
> +
> +       /*
> +        * We need to grab mmap_lock, but can't do so while holding the d=
omain
> +        * lock (since cla_vma_fault() grabs the domain lock while holdin=
g
> +        * mmap_lock). The queue may change and contexts may be killed by
> +        * cla_ctx_destroy() while the lock is dropped.
> +        *
> +        * No user is allowed to access CLA while we are reassigning. Dis=
able
> +        * assigned_ctx before zapping so cla_vma_fault() won't re-map th=
e
> +        * domain during reassignment. The sentinel also defers broken-do=
main
> +        * cleanup until we know which context hardware may still access.
> +        */
> +       WRITE_ONCE(domain->assigned_ctx, &invalid_ctx);
> +       mutex_unlock(&domain->lock);
> +
> +       /* Prevent prev_ctx from accessing any device in the domain. */
> +       cla_domain_zap(domain, prev_ctx);
> +
> +       /* cpus_read_lock() ensures workers remain cpu-bound and alive. *=
/
> +       ret =3D cla_domain_switch_ctx(domain, prev_ctx, next_ctx, &assign=
ed_ctx);
> +
> +       mutex_lock(&domain->lock);
> +       WRITE_ONCE(domain->assigned_ctx, assigned_ctx);
> +
> +       /* Also handle failure reported by another thread during the swit=
ch. */
> +       if (ret || domain->broken) {
> +               cla_domain_set_broken(domain);
> +               goto out_unlock;
> +       }
> +
> +       /*
> +        * Remove next_ctx from the queue and wake up all waiters so that=
 the
> +        * fault handler can map the domain into the newly assigned proce=
ss.
> +        * assigned_ctx must have been updated prior to waking the waiter=
s.
> +        *
> +        * If next_ctx was killed while we were assigning it, schedule an=
other
> +        * reassignment to deassign it.
> +        */
> +       if (next_ctx) {
> +               if (cla_ctx_is_dying(next_ctx)) {
> +                       cla_domain_schedule_reassignment(domain);
> +                       goto out_unlock;
> +               }
> +               list_del_init(&next_ctx->queue_node);
> +               wake_up_all(&next_ctx->waitq);
> +       }
> +
> +       /* If there are more queued ctxs, schedule the next reassignment.=
 */
> +       if (!list_empty(&domain->queued_ctxs))
> +               cla_domain_schedule_reassignment(domain);
> +
> +out_unlock:
> +       mutex_unlock(&domain->lock);
> +       cpus_read_unlock();
> +
> +       /* Deliberately put references outside of the locks. */
> +       if (next_ctx && next_ctx !=3D assigned_ctx)
> +               cla_ctx_put(next_ctx);
> +       if (prev_ctx && prev_ctx !=3D assigned_ctx)
> +               cla_ctx_put(prev_ctx);
> +}

This function contains a bunch of comments that are hard for me
to understand without context (ha!) but it's probably all right,
I bet they are helpful once you get the hang of it.

> +int cla_domain_sched_init(struct cla_domain *domain)

OK.

> +/**
> + * cla_domain_sched_exit - Tear down scheduling for a CLA domain
> + * @domain: CLA domain
> + *
> + * Drain final deassignment, destroy the domain worker, and destroy the =
context
> + * table. All context users must have exited before calling this.
> + */
> +void cla_domain_sched_exit(struct cla_domain *domain)

OK.

> +void cla_domain_set_broken(struct cla_domain *domain)

OK.

> +struct cla_ctx *cla_domain_lookup_ctx(struct cla_domain *domain,
> +                                     struct cla_ctx_key *key)
(...)
> +int cla_domain_insert_ctx(struct cla_domain *domain, struct cla_ctx *ctx=
)
(...)
> +void cla_domain_remove_ctx(struct cla_domain *domain, struct cla_ctx *ct=
x)

Clever use of rhashtable, good names.

> +/**
> + * cla_domain_schedule_reassignment - Schedule domain reassignment
> + * @domain: CLA domain
> + *
> + * The caller must hold the domain lock. If a live context is currently
> + * assigned, schedule with a delay (CLA_SLICE_MS), otherwise reassign
> + * immediately. Do nothing if the domain is broken or a switch is in pro=
gress;
> + * the running switch handles new requests before returning. If reassign=
ment is
> + * already scheduled, the delay is modified.
> + */
> +void cla_domain_schedule_reassignment(struct cla_domain *domain)

Schedule reassign of the domain to ... what?

This use of verbs is really confusing me, I understand for example
"assign timeslice to process" then I know a timeslice is assigned to
a process. There is something implicit here making this really
hard to understand.

> +void cla_domains_sched_exit(void)

OK.

But where is the cla_schedule() function in this scheduler
akin to Linux' schedule() call? It feels like this is implicit
in some call order semantic, and the function
cla_domain_get_next_ctx() implements an implicit
FIFO scheduling principle.

Alternatively the scheduling isn't actually driven here
but from somehwere else, like userspace. Then that
needs to be explained. Then this file doesn't actually
implement any scheduling, it's a scheduling context
library nothing more.

This kind of stuff needs to be explained so I can review the
patch properly.

Yours,
Linus Walleij
