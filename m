Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F933E6
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 21:38:41 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id bg13-20020a17090b0d8d00b00233ee678ea6so1555374pjb.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 13:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qISKjtUmN2cEwBwW4xMI8exQ5WKRK627PpvklIdcOFI=;
        b=sfgAZ70dHjZIDt2LlS8uAAFtM3WGXWas6Swe1KZGm/7LwDUPrvMw5IjA6K+Yl5nXbx
         l/JB29YObSepeKdZS8KpaqLUbqar3WIXxLvjBNSO96gvv7lCvdc/UTNctCXfluTUiMYz
         Ze4SCZJXt0odf2R2vwiDjLSl0J/bAg1QM5eY7RDp4vkIDfBHXziFmXKfYb5dK3phQa2S
         mM/putTXr102FYkQcAnBu0KotBNtkF0xWASreyKGWqf+uTodfTKsBUiLeINHWNXWl6Nb
         BqvMUPpXzNV4b4HthNEdF7E94IrsUXUBoDepSs5mnkZgW50d/oK8LHUoYtZfL3CUK9pm
         M21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qISKjtUmN2cEwBwW4xMI8exQ5WKRK627PpvklIdcOFI=;
        b=gzfi0+fs3xFqTNIbLgUxB+ELtily/4XpZxL3hkMQIbXCi71K2N3iixXuSMVbh9vjiP
         +UevuWK99bhgCkjNOIWms+ahIMbpvO/cLNevvRzwVGM6XeFF8DbfbRjtSI9ZY4ZjfCyM
         gTnb4aJ4JMb62yyCfwHxK9JVNAlZldMAebWvHSoxK2TkOf+5bkwJOMBf2SS8vf9H9Dn+
         /aLWwZgXo8q25sS0nQQ71NEDdIp876y5HHgOSs1L/rtqx3Ybzeht4kpbm1qF2Mi+XU2V
         8CHNLtbQleqCF3yHPSC4W5LXJuaqmt/kIcqFiryQBLDs+F0LlM3t/tmTv6zpr9umtkWA
         RHqQ==
X-Gm-Message-State: AO0yUKUdocJ2bdIGgVGzU60axfbBTeTt9rdoIxowwE5hoGhNuJxnge+P
	SNDpqG0ICy4Icx9DIYUK6qcpZFXypfk=
X-Google-Smtp-Source: AK7set8GdCvk4jCPWiRNB0CEkjUTMbp8EH1MVnNVK571C5L6Vx7G9LuGyMCqRh3cyi5QWEywqdmID/9uzYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f508:0:b0:4fb:a28e:fa50 with SMTP id
 w8-20020a63f508000000b004fba28efa50mr1086612pgh.8.1676583520915; Thu, 16 Feb
 2023 13:38:40 -0800 (PST)
Date: Thu, 16 Feb 2023 13:38:39 -0800
In-Reply-To: <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
Message-ID: <Y+6iX6a22+GEuH1b@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, James Houghton <jthoughton@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	peterx@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 16, 2023, Anish Moorthy wrote:
> On Wed, Feb 15, 2023 at 12:59 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 109b18e2789c4..9352e7f8480fb 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -801,6 +801,9 @@ struct kvm {
> > > >     bool vm_bugged;
> > > >     bool vm_dead;
> > > >
> > > > +   rwlock_t mem_fault_nowait_lock;
> > > > +   bool mem_fault_nowait;
> > >
> > > A full-fat rwlock to protect a single bool? What benefits do you
> > > expect from a rwlock? Why is it preferable to an atomic access, or a
> > > simple bitop?
> >
> > There's no need to have any kind off dedicated atomicity.  The only readers are
> > in vCPU context, just disallow KVM_CAP_MEM_FAULT_NOWAIT after vCPUs are created.
> 
> I think we do need atomicity here.

Atomicity, yes.  Mutually exclusivity, no.  AFAICT, nothing will break if userspace
has multiple in-flight calls to toggled the flag.  And if we do want to guarantee
there's only one writer, then kvm->lock or kvm->slots_lock will suffice.

> When KVM_CAP_MEM_FAULT_NOWAIT is enabled async page faults are essentially
> disabled: so userspace will likely want to disable the cap at some point
> (such as the end of live migration post-copy).

Ah, this is a dynamic thing and not a set-and-forget thing.

> Since we want to support this without having to pause vCPUs, there's an
> atomicity requirement.

Ensuring that vCPUs "see" the new value and not corrupting memory are two very
different things.  Making the flag an atomic, wrapping with a rwlock, etc... do
nothing to ensure vCPUs observe the new value.  And for non-crazy usage of bools,
they're not even necessary to avoid memory corruption, e.g. the result of concurrent
writes to a bool is non-deterministic, but so is the order of two tasks contending
for a lock, so it's a moot point.

I think what you really want to achieve is that vCPUs observe the NOWAIT flag
before KVM returns to userspace.  There are a variety of ways to make that happen,
but since this all about accessing guest memory, the simplest is likely to
"protect" the flag with kvm->srcu, i.e. require SRCU be held by readers and then
do a synchronize_srcu() to ensure all vCPUs have picked up the new value.

Speaking of SRCU (which protect memslots), why not make this a memslot flag?  If
the goal is to be able to turn the behavior on/off dynamically, wouldn't it be
beneficial to turn off the NOWAIT behavior when a memslot is fully transfered?

A memslot flag would likely be simpler to implement as it would piggyback all of
the existing infrastructure to handle memslot updates.
