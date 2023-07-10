Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778B43D76
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 15:02:00 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-47dcf42d3a0so4006550e0c.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 08:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689001319; x=1691593319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/sUNdtXxakq8jmp5wcqZtKus2+6D3V7y8Xb9orW/bc=;
        b=lR0HiSsQ75xixs2SGZAUx9sppXeb2VUtOOA1aLvD1Hb0V2qN+kBZC9UiNkUQ53tEu1
         9Q5CiNzlQZz8mFacRo11LBsVS1pTeTyHcDtR0FEIGnbtzOXQzTv8b0khJsEAa0DtMT+m
         QXMw0qiZ+RRp+XH8/b/zhruC9D2pJ29/6N6NCYarnnTRaU4xL7uZrWYrhoSRtEay2v+9
         CW5iqSb1KxLwErSMdYZCBTqHsSu4tZzjBa11fXJ3Ps6aUMwC/HLTMQDtlZegse4hJam7
         vYtL82aJNmt5uP7KQD13A1hocVwS1F73iAyEppsbQilE+60bBvi+ZMrWmbfoa5+ZEj4W
         FKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689001319; x=1691593319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/sUNdtXxakq8jmp5wcqZtKus2+6D3V7y8Xb9orW/bc=;
        b=EdOwj2mEyKx5r72lYn18eOAE3etWcxGb36gqHgq1h40hw0lxJGHlJ6j/3IzEoxW50h
         WqbyIXF4w40p1jc2E4ygsz2q84IMsof38GNbXKBkwJBRqp+aad4o0xEMDsl/IILvd8Wp
         3kFppdJCSKcA4Ji/Vna3MwH/rtYht9t2jPSBwDRtJ1rQkN/GXlWRfgTtYAqaxZwsRKcj
         yTkjfApq3j1whY0+ISjfsqoDXgkotygYGPHZZRniOTIhq8oMIfAi6LqYj1aW++uiUP6K
         vrDtxf5DU3t8KRv7fTMDlx/ohudyttyiXW8VU6+nCn6lXr46Yok/lLkWEfkD/zGEqcL9
         0d1A==
X-Gm-Message-State: ABy/qLbSklW2OT3cAl/J0HlO6JtA37gafehZ/KucPqDuPYtRO9ZKtZCF
	P0QqhHZ9iu9yRbdpaCUkdGaACgny4eKb91/0JaQo+Q==
X-Google-Smtp-Source: APBJJlF2giwme5p7futOTNlJ8L8M/CNv5v2eRtIYUGAvhRDJ73OwpteVzgCU/DW4qF+q9LfswGKQiPI9yXVkzTwPeH8=
X-Received: by 2002:a1f:c1ce:0:b0:46e:1a21:b52d with SMTP id
 r197-20020a1fc1ce000000b0046e1a21b52dmr4103998vkf.5.1689001319090; Mon, 10
 Jul 2023 08:01:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
In-Reply-To: <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 10 Jul 2023 08:00:00 -0700
Message-ID: <CAF7b7mr7BZayOxE2y8K87+AfYuGoDc7_kA2ouA3kBuhSgDiomg@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Kautuk Consul <kconsul@linux.vnet.ibm.com>
Cc: Sean Christopherson <seanjc@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > > +   preempt_disable();
> > > +   /*
> > > +    * Ensure the this vCPU isn't modifying another vCPU's run struct=
, which
> > > +    * would open the door for races between concurrent calls to this
> > > +    * function.
> > > +    */
> > > +   if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_running_vcpu)))
> > > +           goto out;
> >
> > Meh, this is overkill IMO.  The check in mark_page_dirty_in_slot() is a=
n
> > abomination that I wish didn't exist, not a pattern that should be copi=
ed.  If
> > we do keep this sanity check, it can simply be
> >
> >       if (WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu()))
> >               return;
> >
> > because as the comment for kvm_get_running_vcpu() explains, the returne=
d vCPU
> > pointer won't change even if this task gets migrated to a different pCP=
U.  If
> > this code were doing something with vcpu->cpu then preemption would nee=
d to be
> > disabled throughout, but that's not the case.
> >
> I think that this check is needed but without the WARN_ON_ONCE as per my
> other comment.
> Reason is that we really need to insulate the code against preemption
> kicking in before the call to preempt_disable() as the logic seems to
> need this check to avoid concurrency problems.
> (I don't think Anish simply copied this if-check from mark_page_dirty_in_=
slot)

Heh, you're giving me too much credit here. I did copy-paste this
check, not from from mark_page_dirty_in_slot() but from one of Sean's
old responses [1]

> That said, I agree that there's a risk that KVM could clobber vcpu->run_r=
un by
> hitting an -EFAULT without the vCPU loaded, but that's a solvable problem=
, e.g.
> the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if cal=
led
> without the target vCPU being loaded:
>
>     int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
>     {
>         preempt_disable();
>         if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_running_vcpu)))
>             goto out;
>
>         vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
>         ...
>     out:
>         preempt_enable();
>         return -EFAULT;
>     }

Ancient history aside, let's figure out what's really needed here.

> Why use WARN_ON_ONCE when there is a clear possiblity of preemption
> kicking in (with the possibility of vcpu_load/vcpu_put being called
> in the new task) before preempt_disable() is called in this function ?
> I think you should use WARN_ON_ONCE only where there is some impossible
> or unhandled situation happening, not when there is a possibility of that
> situation clearly happening as per the kernel code.

I did some mucking around to try and understand the kvm_running_vcpu
variable, and I don't think preemption/rescheduling actually trips the
WARN here? From my (limited) understanding, it seems that the
thread being preempted will cause a vcpu_put() via kvm_sched_out().
But when the thread is eventually scheduled back in onto whatever
core, it'll vcpu_load() via kvm_sched_in(), and the docstring for
kvm_get_running_vcpu() seems to imply the thing that vcpu_load()
stores into the per-cpu "kvm_running_vcpu" variable will be the same
thing which would have been observed before preemption.

All that's to say: I wouldn't expect the value of
"__this_cpu_read(kvm_running_vcpu)" to change in any given thread. If
that's true, then the things I would expect this WARN to catch are (a)
bugs where somehow the thread gets scheduled without calling
vcpu_load() or (b) bizarre situations (probably all bugs?) where some
vcpu thread has a hold of some _other_ kvm_vcpu* and is trying to do
something with it.


On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Meh, this is overkill IMO.  The check in mark_page_dirty_in_slot() is an
> abomination that I wish didn't exist, not a pattern that should be copied=
.  If
> we do keep this sanity check, it can simply be
>
>         if (WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu()))
>                 return;
>
> because as the comment for kvm_get_running_vcpu() explains, the returned =
vCPU
> pointer won't change even if this task gets migrated to a different pCPU.=
  If
> this code were doing something with vcpu->cpu then preemption would need =
to be
> disabled throughout, but that's not the case.

Oh, looks like Sean said the same thing. Guess I probably should have
read that reply more closely first :/


[1] https://lore.kernel.org/kvm/ZBnLaidtZEM20jMp@google.com/
