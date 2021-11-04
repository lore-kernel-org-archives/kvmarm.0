Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0869BC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 17:03:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B6DE61216
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 17:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B6DE61216
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8A654B16E;
	Fri,  5 Nov 2021 13:03:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GhrDgqBgy+Qx; Fri,  5 Nov 2021 13:02:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2BFC4B178;
	Fri,  5 Nov 2021 13:02:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F7E84B0DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 17:28:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oOn2EPE7rwq1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 17:28:11 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAEA849F5D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 17:28:11 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id z206so8613742iof.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 14:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kT59fOFXGdqG57cxSFiBCbx9dcYetqnRywW1gdZNmeY=;
 b=gT4nzQq0x89i6Vp5dNWtSZrRbMe0W3qbbXwW9NXWgaRs8fYbXvHzdlEGUK48g0ajas
 uHVv10bVNkjhWr3B3MYTi44+qGBwBfoBwhj+2jrlWAsr2slc13bc4BseaXy2AoLJs6t8
 xRBsjkLiRiH+rEZC9bjYDRvB0cKfRmGxlddQQ74lKlIH3DSIbhZURrg/4JSes8eUaatv
 4YcLz57IesgJy0I2f7nby9V0UuPZTikaQqcNEzddlw13/ibFXy00E0dEkzMok1oNoZqt
 ZDIYGh1maMM5k3AvqVuUpAr6S+JkIrJwFta52d8TDhA2FBg5X1Xits9o/XjdmWUTRl4X
 pAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kT59fOFXGdqG57cxSFiBCbx9dcYetqnRywW1gdZNmeY=;
 b=kVmVdvtoo3RfRhTHmfwCKPi6rbw94LcVV4yH+Ljo2Q6MxauTB1t6jqQbXN/kZYrM58
 XxiZgOM7acoGhqq9Iil4SOW/DNFOKNbASBMk3LpFnNfmu0aPHxEGdIlUpIneyNle8o5R
 Wog8NoaBB4JOJi5tFqNFCOqIbtt1iSN8loe2oiUpabD88au6EF6Zgl0qLjUI3gTkOUtQ
 DzOecd1UV7Aw1ngsMe86IuZex//A7fuqPvkj55hCiqycfKEiQ/HB7MlslucD/5795aaL
 39z6VQoh3XZAdPLVuvBuMAJEhtSSZ7nSJLiecPiqAZd4mvtXPL8NGA/fjqFH+h6+41Eu
 9v7w==
X-Gm-Message-State: AOAM532Jb6XfMBDpOXJNhgoAJZJohuL34VaQGsJ0A2HLSIuBXrw9jpYD
 xIKUIBDmRQizjiEorXtXVsPmoWfuqIdfq1Q8ifOpxw==
X-Google-Smtp-Source: ABdhPJyMIoxuukzQc6rukS1CsN0VzOsX5g2manzJn1KGK69DmvdVJ1f5vqR2wNyFb/XiaX/LmgNI1ppfR5uwGseVoTo=
X-Received: by 2002:a05:6602:1612:: with SMTP id
 x18mr282554iow.37.1636061290880; 
 Thu, 04 Nov 2021 14:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-2-seanjc@google.com>
In-Reply-To: <20211104002531.1176691-2-seanjc@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 4 Nov 2021 14:27:59 -0700
Message-ID: <CANgfPd-uuPFjAHk5kVNom2Qs=UU_GX6CQ0xDLg1h_iL8t8S2aQ@mail.gmail.com>
Subject: Re: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Fri, 05 Nov 2021 13:02:59 -0400
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Anup Patel <anup.patel@wdc.com>,
 linux-mips@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Nov 3, 2021 at 5:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> When modifying memslots, snapshot the "old" memslot and copy it to the
> "new" memslot's arch data after (re)acquiring slots_arch_lock.  x86 can
> change a memslot's arch data while memslot updates are in-progress so
> long as it holds slots_arch_lock, thus snapshotting a memslot without
> holding the lock can result in the consumption of stale data.
>
> Fixes: b10a038e84d1 ("KVM: mmu: Add slots_arch_lock for memslot arch fields")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 47 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 16 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3f6d450355f0..99e69375c4c9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1531,11 +1531,10 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>
>  static int kvm_set_memslot(struct kvm *kvm,
>                            const struct kvm_userspace_memory_region *mem,
> -                          struct kvm_memory_slot *old,
>                            struct kvm_memory_slot *new, int as_id,
>                            enum kvm_mr_change change)
>  {
> -       struct kvm_memory_slot *slot;
> +       struct kvm_memory_slot *slot, old;
>         struct kvm_memslots *slots;
>         int r;
>
> @@ -1566,7 +1565,7 @@ static int kvm_set_memslot(struct kvm *kvm,
>                  * Note, the INVALID flag needs to be in the appropriate entry
>                  * in the freshly allocated memslots, not in @old or @new.
>                  */
> -               slot = id_to_memslot(slots, old->id);
> +               slot = id_to_memslot(slots, new->id);

Since new is guaranteed to have the same id as old (at least prior to
this change) this is a no-op change, so no problem here.
This could be a separate commit which would have no functional change
but only worth extracting if you send a v2.

>                 slot->flags |= KVM_MEMSLOT_INVALID;
>
>                 /*
> @@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
>                 kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
>         }
>
> +       /*
> +        * Make a full copy of the old memslot, the pointer will become stale
> +        * when the memslots are re-sorted by update_memslots(), and the old
> +        * memslot needs to be referenced after calling update_memslots(), e.g.
> +        * to free its resources and for arch specific behavior.  This needs to
> +        * happen *after* (re)acquiring slots_arch_lock.
> +        */
> +       slot = id_to_memslot(slots, new->id);
> +       if (slot) {
> +               old = *slot;
> +       } else {
> +               WARN_ON_ONCE(change != KVM_MR_CREATE);
> +               memset(&old, 0, sizeof(old));
> +               old.id = new->id;
> +               old.as_id = as_id;
> +       }
> +
> +       /* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
> +       memcpy(&new->arch, &old.arch, sizeof(old.arch));
> +

Is new->arch not initialized before this function is called? Does this
need to be here, or could it be moved above into the first branch of
the if statement?
Oh I see you removed the memset below and replaced it with this. I
think this is fine, but it might be easier to reason about if we left
the memset and moved the memcopy into the if.
No point in doing a memcpy of zeros here.

>         r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
>         if (r)
>                 goto out_slots;
> @@ -1604,14 +1623,18 @@ static int kvm_set_memslot(struct kvm *kvm,
>         update_memslots(slots, new, change);
>         slots = install_new_memslots(kvm, as_id, slots);
>
> -       kvm_arch_commit_memory_region(kvm, mem, old, new, change);
> +       kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
> +
> +       /* Free the old memslot's metadata.  Note, this is the full copy!!! */
> +       if (change == KVM_MR_DELETE)
> +               kvm_free_memslot(kvm, &old);
>
>         kvfree(slots);
>         return 0;
>
>  out_slots:
>         if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> -               slot = id_to_memslot(slots, old->id);
> +               slot = id_to_memslot(slots, new->id);
>                 slot->flags &= ~KVM_MEMSLOT_INVALID;
>                 slots = install_new_memslots(kvm, as_id, slots);
>         } else {
> @@ -1626,7 +1649,6 @@ static int kvm_delete_memslot(struct kvm *kvm,
>                               struct kvm_memory_slot *old, int as_id)
>  {
>         struct kvm_memory_slot new;
> -       int r;
>
>         if (!old->npages)
>                 return -EINVAL;
> @@ -1639,12 +1661,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
>          */
>         new.as_id = as_id;
>
> -       r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
> -       if (r)
> -               return r;
> -
> -       kvm_free_memslot(kvm, old);
> -       return 0;
> +       return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
>  }
>
>  /*
> @@ -1718,7 +1735,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>         if (!old.npages) {
>                 change = KVM_MR_CREATE;
>                 new.dirty_bitmap = NULL;
> -               memset(&new.arch, 0, sizeof(new.arch));
>         } else { /* Modify an existing slot. */
>                 if ((new.userspace_addr != old.userspace_addr) ||
>                     (new.npages != old.npages) ||
> @@ -1732,9 +1748,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>                 else /* Nothing to change. */
>                         return 0;
>
> -               /* Copy dirty_bitmap and arch from the current memslot. */
> +               /* Copy dirty_bitmap from the current memslot. */
>                 new.dirty_bitmap = old.dirty_bitmap;
> -               memcpy(&new.arch, &old.arch, sizeof(new.arch));
>         }
>
>         if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
> @@ -1760,7 +1775,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>                         bitmap_set(new.dirty_bitmap, 0, new.npages);
>         }
>
> -       r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
> +       r = kvm_set_memslot(kvm, mem, &new, as_id, change);
>         if (r)
>                 goto out_bitmap;
>
> --
> 2.33.1.1089.g2158813163f-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
