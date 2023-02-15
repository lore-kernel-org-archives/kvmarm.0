Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07FB7B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:47:43 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id o42so11067204qvo.13
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676483262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WP1JNa4W/AmrkCNSc3ANi+zdSMWTWC+4FVT8pyWRWzQ=;
        b=dknhbWOUpFszYt6gBrp4BoGaoVHJjeRNv1YFklJ5PG1D8K5n1CnRItYUd4M2EGWI2B
         lFYYuiUdhWflZ30VKY7UbE7/cpM63SQP9FvzGvrdT9qoDMwEV+DGAEOY9yCAHXsbDTpx
         tDMlvoppgQOCrWWSxGtJHt/wkn1LNBmS9iMvi3fqJAK17GTOSCYCaHuLK6TJWjtl6OZ3
         FB3waJt+Pttk6llI2s1xcONUVHcNB/1XN2RAg8IJR2dDiXPSELH6lCnm/228xpnIjnGw
         Nv4JLVN51NT3PftRlJG4OCV7vpHqYB6PuwN6TsGe9zACTFaFjxv/N8R5nmGCIAnUYxV/
         qVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676483262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WP1JNa4W/AmrkCNSc3ANi+zdSMWTWC+4FVT8pyWRWzQ=;
        b=rC9/PEFwPvakXgEXjHapQGR9PMRVOI8DLkPtleuggxpKkJrIKDV1Tt+JwdkRKOhr9L
         /6OoZgQUWrhJa8woC6VWrMNhZpbtssV8IuAwH/V0ggIaH7YC7XJQG57vsMAEvIheQR2H
         OHIIvRXo2C0jxSGJtYf9tlpQndq1K0pAh1FWcAKWz2Vgd61gAKBcI8xF28dT2ZyakUZ+
         pbbwkXkVkDO8o6zP2U1ZQeOEmUrHjiprJ7JezdFOSD7fkaFRc84l+Fi6kwzzVBE1j/71
         U2E1RsQD04HwSoMsPQGf7nDaN58ZnmMVb84L4PEwnRufMG+mOc29Bo1qfV9jFUtmnVTY
         9mgg==
X-Gm-Message-State: AO0yUKWU37sCF+wsKL6CuL2zSMOLa6gZfTdpHu/YX7w69uV/X2maFYci
	Ep4xJWhOwB90/sllqgQiQyAocV8Tvd9u32iOZtEUiA==
X-Google-Smtp-Source: AK7set8M3sXmHwvK69zDrbwFGZgKFkFCni1niDqX3B4zq45NHNGOIzD6V5SLqvS7S916jJ2NYLM1txdZflOHnRDLjOs=
X-Received: by 2002:a0c:e086:0:b0:56e:a207:142d with SMTP id
 l6-20020a0ce086000000b0056ea207142dmr222494qvk.6.1676483262557; Wed, 15 Feb
 2023 09:47:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-6-ricarkol@google.com>
 <8be5c7be-fd43-86e8-6b3d-6085dd4f3cc6@redhat.com>
In-Reply-To: <8be5c7be-fd43-86e8-6b3d-6085dd4f3cc6@redhat.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Wed, 15 Feb 2023 09:47:31 -0800
Message-ID: <CAOHnOrxMjJ6RZZ4mnLKrJSEee+6PagLPNf+b-OSpfxbj+2Pa=w@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
To: Gavin Shan <gshan@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, reijiw@google.com, 
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 8, 2023 at 10:02 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 2/7/23 3:58 AM, Ricardo Koller wrote:
> > Refactor kvm_arch_commit_memory_region() as a preparation for a future
> > commit to look cleaner and more understandable. Also, it looks more
> > like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> >
> > No functional change intended.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9bd3c2cfb476..d2c5e6992459 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >                                  const struct kvm_memory_slot *new,
> >                                  enum kvm_mr_change change)
> >   {
> > +     bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> > +
> >       /*
> >        * At this point memslot has been committed and there is an
> >        * allocated dirty_bitmap[], dirty pages will be tracked while the
> >        * memory slot is write protected.
> >        */
> > -     if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > +     if (log_dirty_pages) {
> > +
> > +             if (change == KVM_MR_DELETE)
> > +                     return;
> > +
>
> When @change is KVM_MR_DELETE, @new should be NULL. It means this check
> isn't needed?

If you don't mind, I prefer not risking making this commit change some
functionality.

>
> >               /*
> >                * If we're with initial-all-set, we don't need to write
> >                * protect any pages because they're all reported as dirty.
> >                * Huge pages and normal pages will be write protect gradually.
> >                */
> > -             if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> > -                     kvm_mmu_wp_memory_region(kvm, new->id);
> > -             }
> > +             if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > +                     return;
> > +
> > +             kvm_mmu_wp_memory_region(kvm, new->id);
> >       }
> >   }
> >
>
> Thanks,
> Gavin
>
>
>
