Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1877F492
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718134959; cv=none; b=X32KoVXr5ajzSxByj1jb/VU/PPnGGEuFJZHh73u6lvJFNU5DMNv6X5SPKmCW+JG4/15whjX361El9+SjzKjVH0zuFJV0nVUqJfkyrOnVnjJzspdGvUeE23fEuPiJlGKIP5seX7R6nHnMLyRG+hLYscTiB/J+aEiKMH91ZyL7yCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718134959; c=relaxed/simple;
	bh=TQdxOxCaPkC06wqWfqJyJfJut/pJEyI8HajgGOMWNPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pP37ZBAn33I+4ypWpNTAxjLDXAKELplDKrtDHzmaMvr+HhJMoAIuZbAkqhrtG9n/6Ptgvvw14s9kmIn71aVGyd698GyVglU5slZttOMPorAaoXjRlu4izLF21Ak1AJOudbfGbf5l9kXTTaKKsjOTOwg935u9ZUmQ3ZKoamFiokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hk9pWx85; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hk9pWx85"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c761c61892so5723134a12.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 12:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718134958; x=1718739758; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wQHC8OIi/Hsd3JLuWOR0lq7d0FaWprofQPExl9Z9si0=;
        b=hk9pWx85vaapUNZqcojuJ73E3se6WTkqaENOCvZrn/wvhtZ028VhvvA2HjVscPvoN4
         kduKPXWhxiLAiDFhgP916UTuyDyV+AO1LZ/J57MLph83dH0PbT6dCOH5VXocoLTOSeXq
         QSIXW9MOWp+xK5F+Pw0zC2jo8DGx7cBcH3D6/Qm5gXc0NmZD0rb4OJwBQnBPCDAJt0O4
         2LlRGSCZ1EgCvwBhbKhYpfTb6Nd30Gk60PMppD8jI6Ser/R7eB7PhgxV2fJaBUIlQpVM
         mOLHcrDq6SHUblAQzrxSmoesh0rdsA+LmlhB0zOzMVxM7OPHjIQoK0xkTfWhzGlNeMDJ
         07+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718134958; x=1718739758;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wQHC8OIi/Hsd3JLuWOR0lq7d0FaWprofQPExl9Z9si0=;
        b=to8mk30QrZRSNtdX26IPF1bW+3Fq/FJBfyHgDrvcJSX4qRxpHW6Vj5SMhCXwZCfDR3
         GowWrhZi4yKfkvHTej9UA5a2THmPhHIDRCepJdYkQ/EC9BJ061cCm2HkXlehASgBZmAP
         6zcZ6dYrtbdJMdQ0Al84sQ88l0fpDbSh0Eownm9/PlO/SVstSngfIPXhoDFffENwsR7U
         ZOL7889nKO2YYbmOh0nArYiRArSg8NCfgT424OoqVkE5j6YtNXcGuFfuwuBYZRuhg7WT
         9SvXF2Y0+OKg+V7ZQhjLwjcQveauBYc73vxYwugPiQ+jK04wY5qD+j91C+mkRYiHt/pR
         IWWg==
X-Forwarded-Encrypted: i=1; AJvYcCWvkuN8YeOOxdgrirlIAo8vk0mjA8w1HLEOcDKNHTzt+vWMc/djNHTXp01SPe6e1fm/QdoQ9qm9rDIy2kMcD8NQrnXffgIE
X-Gm-Message-State: AOJu0YwQnOIllWADOsHRuQVQVTtMXY0OD0TmzGAwsNtGvp6OHidgaOU2
	8vZDHlwKtklB1AZFurLMyQliHoN1yXmVHJFuQmTja/ZelVVCqRL8Ud14kgl1TGuBPOFObBVjYqb
	YGQ==
X-Google-Smtp-Source: AGHT+IEPF8Tx1zPRD6hrqpXv6Mu4zzFUULaMqaPpbdSAl8Wrrff2x3ztnrpn6Pwr6Frteyuagy9bVl9rsn8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c401:b0:1f6:84b5:1e10 with SMTP id
 d9443c01a7336-1f6d02bfe8emr9509095ad.1.1718134957392; Tue, 11 Jun 2024
 12:42:37 -0700 (PDT)
Date: Tue, 11 Jun 2024 12:42:35 -0700
In-Reply-To: <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
Message-ID: <ZmioedgEBptNoz91@google.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024, James Houghton wrote:
> On Mon, Jun 10, 2024 at 10:34=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrot=
e:
> >
> > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > This new notifier is for multi-gen LRU specifically
> >
> > Let me call it out before others do: we can't be this self-serving.
> >
> > > as it wants to be
> > > able to get and clear age information from secondary MMUs only if it =
can
> > > be done "fast".
> > >
> > > By having this notifier specifically created for MGLRU, what "fast"
> > > means comes down to what is "fast" enough to improve MGLRU's ability =
to
> > > reclaim most of the time.
> > >
> > > Signed-off-by: James Houghton <jthoughton@google.com>
> >
> > If we'd like this to pass other MM reviewers, especially the MMU
> > notifier maintainers, we'd need to design a generic API that can
> > benefit all the *existing* users: idle page tracking [1], DAMON [2]
> > and MGLRU.
> >
> > Also I personally prefer to extend the existing callbacks by adding
> > new parameters, and on top of that, I'd try to consolidate the
> > existing callbacks -- it'd be less of a hard sell if my changes result
> > in less code, not more.
> >
> > (v2 did all these, btw.)
>=20
> I think consolidating the callbacks is cleanest, like you had it in
> v2. I really wasn't sure about this change honestly, but it was my
> attempt to incorporate feedback like this[3] from v4. I'll consolidate
> the callbacks like you had in v2.

James, wait for others to chime in before committing yourself to a course o=
f
action, otherwise you're going to get ping-ponged to hell and back.

> Instead of the bitmap like you had, I imagine we'll have some kind of
> flags argument that has bits like MMU_NOTIFIER_YOUNG_CLEAR,
> MMU_NOTIFIER_YOUNG_FAST_ONLY, and other ones as they come up. Does
> that sound ok?

Why do we need a bundle of flags?  If we extend .clear_young() and .test_yo=
ung()
as Yu suggests, then we only need a single "bool fast_only".

As for adding a fast_only versus dedicated APIs, I don't have a strong pref=
erence.
Extending will require a small amount of additional churn, e.g. to pass in =
false,
but that doesn't seem problematic on its own.  On the plus side, there woul=
d be
less copy+paste in include/linux/mmu_notifier.h (though that could be solve=
d with
macros :-) ).

E.g.=20

--
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 7b77ad6cf833..07872ae00fa6 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -384,7 +384,8 @@ int __mmu_notifier_clear_flush_young(struct mm_struct *=
mm,
=20
 int __mmu_notifier_clear_young(struct mm_struct *mm,
                               unsigned long start,
-                              unsigned long end)
+                              unsigned long end,
+                              bool fast_only)
 {
        struct mmu_notifier *subscription;
        int young =3D 0, id;
@@ -393,9 +394,12 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
        hlist_for_each_entry_rcu(subscription,
                                 &mm->notifier_subscriptions->list, hlist,
                                 srcu_read_lock_held(&srcu)) {
-               if (subscription->ops->clear_young)
-                       young |=3D subscription->ops->clear_young(subscript=
ion,
-                                                               mm, start, =
end);
+               if (!subscription->ops->clear_young ||
+                   fast_only && !subscription->ops->has_fast_aging)
+                       continue;
+
+               young |=3D subscription->ops->clear_young(subscription,
+                                                       mm, start, end);
        }
        srcu_read_unlock(&srcu, id);
=20
@@ -403,7 +407,8 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 }
=20
 int __mmu_notifier_test_young(struct mm_struct *mm,
-                             unsigned long address)
+                             unsigned long address,
+                             bool fast_only)
 {
        struct mmu_notifier *subscription;
        int young =3D 0, id;
@@ -412,12 +417,15 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
        hlist_for_each_entry_rcu(subscription,
                                 &mm->notifier_subscriptions->list, hlist,
                                 srcu_read_lock_held(&srcu)) {
-               if (subscription->ops->test_young) {
-                       young =3D subscription->ops->test_young(subscriptio=
n, mm,
-                                                             address);
-                       if (young)
-                               break;
-               }
+               if (!subscription->ops->test_young)
+                       continue;
+
+               if (fast_only && !subscription->ops->has_fast_aging)
+                       continue;
+
+               young =3D subscription->ops->test_young(subscription, mm, a=
ddress);
+               if (young)
+                       break;
        }
        srcu_read_unlock(&srcu, id);
--=20

It might also require multiplexing the return value to differentiate betwee=
n
"young" and "failed".  Ugh, but the code already does that, just in a bespo=
ke way.

Double ugh.  Peeking ahead at the "failure" code, NAK to adding
kvm_arch_young_notifier_likely_fast for all the same reasons I objected to
kvm_arch_has_test_clear_young() in v1.  Please stop trying to do anything l=
ike
that, I will NAK each every attempt to have core mm/ code call directly int=
o KVM.

Anyways, back to this code, before we spin another version, we need to agre=
e on
exactly what behavior we want out of secondary MMUs.  Because to me, the be=
havior
proposed in this version doesn't make any sense.

Signalling failure because KVM _might_ have relevant aging information in S=
PTEs
that require taking kvm->mmu_lock is a terrible tradeoff.  And for the test=
_young
case, it's flat out wrong, e.g. if a page is marked Accessed in the TDP MMU=
, then
KVM should return "young", not "failed".

If KVM is using the TDP MMU, i.e. has_fast_aging=3Dtrue, then there will be=
 rmaps
if and only if L1 ran a nested VM at some point.  But as proposed, KVM does=
n't
actually check if there are any shadow TDP entries to process.  That could =
be
fixed by looking at kvm->arch.indirect_shadow_pages, but even then it's not=
 clear
that bailing if kvm->arch.indirect_shadow_pages > 0 makes sense.

E.g. if L1 happens to be running an L2, but <10% of the VM's memory is expo=
sed to
L2, then "failure" is pretty much guaranteed to a false positive.  And even=
 for
the pages that are exposed to L2, "failure" will occur if and only if the p=
ages
are being accessed _only_ by L2.

There most definitely are use cases where the majority of a VM's memory is =
accessed
only by L2.  But if those use cases are performing poorly under MGLRU, then=
 IMO
we should figure out a way to enhance KVM to do a fast harvest of nested TD=
P
Accessed information, not make MGRLU+KVM suck for a VMs that run nested VMs=
.

Oh, and calling into mmu_notifiers to do the "slow" version if the fast ver=
sion
fails is suboptimal.

So rather than failing the fast aging, I think what we want is to know if a=
n
mmu_notifier found a young SPTE during a fast lookup.  E.g. something like =
this
in KVM, where using kvm_has_shadow_mmu_sptes() instead of kvm_memslots_have=
_rmaps()
is an optional optimization to avoid taking mmu_lock for write in paths whe=
re a
(very rare) false negative is acceptable.

  static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
  {
	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
  }

  static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range,
			 bool fast_only)
  {
	int young =3D 0;

	if (!fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
		write_lock(&kvm->mmu_lock);
		young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
		write_unlock(&kvm->mmu_lock);
	}

	if (tdp_mmu_enabled && kvm_tdp_mmu_age_gfn_range(kvm, range))
		young =3D 1 | MMU_NOTIFY_WAS_FAST;

	return (int)young;
  }

and then in lru_gen_look_around():

	if (spin_is_contended(pvmw->ptl))
		return false;

	/* exclude special VMAs containing anon pages from COW */
	if (vma->vm_flags & VM_SPECIAL)
		return false;

	young =3D ptep_clear_young_notify(vma, addr, pte);
	if (!young)
		return false;

	if (!(young & MMU_NOTIFY_WAS_FAST))
		return true;

	young =3D 1;

with the lookaround done using ptep_clear_young_notify_fast().

The MMU_NOTIFY_WAS_FAST flag is gross, but AFAICT it would Just Work withou=
t
needing to update all users of ptep_clear_young_notify() and friends.
