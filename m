Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB512221DA6
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 10:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734603176; cv=none; b=H2wEc3cZgN1+vsUejjmJtralh9D4XVVrtG9BmOwgbpcxx3t9/Vs48H5eOMKiePLMTpi7f5sj1/L+FBm7zsgAFMDSVCP8deVaSGC7kw2wrj7Pq5AqXfG6b06suWsU30jvahYUXr6qIrPhyL+m4MxqEMpo/lINkF7NPpX413g+JJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734603176; c=relaxed/simple;
	bh=nJdOpf18jK3tm2fp3L1ChtS07mw3yWYn88TIpx4GYD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gr/GZzst5O6yWHrJVi0jCkJD/rwAZCPlG3QgxIdXkKJ0QQRF64LTqMLIEYlHSNCjoWGvindwlsblQFv+FI16RHJYVwii0OC5g6nP21HWhO/4NJqUAABa4/319RiLFuhqQajFyIp1UoBfKDenluDmHq8q6dDXLTAlCrTO4JlRC9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ltGVi+2; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ltGVi+2"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa696d3901bso104359066b.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 02:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734603172; x=1735207972; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nCbAYMLLvTAcxGqf7AGIu8LtVN+q/aDW+3h34FBSoIk=;
        b=3ltGVi+2Rf3n2NhGXueYRTqzbUjJ5iKQ1X2pNWs1uA5uY65+iB7wu0gfQRyxhhj4ji
         HIsWiT74Xu+TUNZakNIStB1Rn/XtzVr7Y5U3JlqZDY7yc8oyQGwrM7Sg8rhtngRmZRd2
         mjc6LP/DucErXtxnHB6qAoAOz3IXuTp+np2sju2Et4FQo3LCZIVbOZN4Xt3A9zFgXkRa
         +DvBcFCZXoZu2sm8M7fgNsG0JgYc+sHaPDl/Uu6ORxO0fWP5nfBFNqqV9PPK3Hvjg/F4
         VBsRzBm0yTxoCuNcFnlulwyEi1/TYv5r+i8jqK1XuSNjIezAe4LyVdN4QdZnT8kEEnV6
         EGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734603172; x=1735207972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nCbAYMLLvTAcxGqf7AGIu8LtVN+q/aDW+3h34FBSoIk=;
        b=qJ3PN+VZqW5eYON48OS2+xTwG2KEVwHYzDSHM7KFHrnjM3tJ9lkg+MAFaCqpxElF+2
         cX9wAOsU3bmSCtu6R0whmhE0G4uJsOcza/qfDAM8qWbD4UXMT2PrufQHjAebYXonJUMt
         fxcHLPKjYNtkIJJ8LXR4XPkhlYCBCO5NmIhZPm0nXRaHs5Cm3PGKjAItFQRqta0iGIvs
         WPG+36+mINSkS3aixg2rwRLDbJ6BPL+YKma2PEIXdzAnioDQCVFmFRduINOybs+89hED
         Vda6knaS9RMbOnlx9ENbTaVDy9GgPKbr/Hq5T5Z3FM2wVXyV6qcTy+2MBzHdliXKx9FD
         dLew==
X-Forwarded-Encrypted: i=1; AJvYcCXyDPvVVCbItqZrcrRWxoJmAHmF11CkbpmOdJH8VVYeg/bnb8Dp8F3ezIEuyyPsOygdFrRu7BI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy70mQQBsy+FN7FsSB9O4OsF9n3wSWhF5a/HB0nrPLaMtrbIf4/
	jUuZ8BXFZPajYDr5MjyO+wXoWInX9gq1c1krMrPK31YZYOKmalZJShmpyHvuPw==
X-Gm-Gg: ASbGncsE3m4B9Jw1h4TbOvbgtU9ee1JYpWZpZxoN0qyRrLiDYROafem0DJ48+8hIWZl
	+qHG5grfRGxYtza2S2LfRnEABjSzFKkNQDPvu9RVXzwnX778oWuVTlcjmg6UnAtmUfJPp6s4/8r
	v5O+V+hJ2AkmD9Dzk6SPbMlWFvk+zCBizmbn1ZkjbILqElgKKsmtRdwxEhJcxuCMIf1xJ8DFSvo
	VSHXDYl+XbKYddVH6d8dcZAhCAbaNDrREeKWYSh4WGuVs1/dRYvO+1Pg4PltrFImtKU+6cLlKfV
	yn/+jQ/uFJYII/Q=
X-Google-Smtp-Source: AGHT+IGMl2hg/hWZAxfwmB/IK3u3QFEHEjrtfo3Stww8uFN30SkW9zfcsvkOQ6GyYADyRplBw2Y2nw==
X-Received: by 2002:a17:907:dab:b0:aa6:538e:a311 with SMTP id a640c23a62f3a-aabf474df33mr596243266b.18.1734603171614;
        Thu, 19 Dec 2024 02:12:51 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f06ebf3sm47724366b.196.2024.12.19.02.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 02:12:51 -0800 (PST)
Date: Thu, 19 Dec 2024 10:12:48 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 17/18] KVM: arm64: Introduce the EL1 pKVM MMU
Message-ID: <Z2PxoLcB3EMfk3_-@google.com>
References: <20241218194059.3670226-1-qperret@google.com>
 <20241218194059.3670226-18-qperret@google.com>
 <CA+EHjTymHPQGwLLpsWzYf1zHpnQKu4mV54Bz3U9HWf3Jb8TcqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTymHPQGwLLpsWzYf1zHpnQKu4mV54Bz3U9HWf3Jb8TcqA@mail.gmail.com>

On Thursday 19 Dec 2024 at 09:49:31 (+0000), Fuad Tabba wrote:
> Hi Quentin
> 
> On Wed, 18 Dec 2024 at 19:41, Quentin Perret <qperret@google.com> wrote:
> >
> > Introduce a set of helper functions allowing to manipulate the pKVM
> > guest stage-2 page-tables from EL1 using pKVM's HVC interface.
> >
> > Each helper has an exact one-to-one correspondance with the traditional
> > kvm_pgtable_stage2_*() functions from pgtable.c, with a strictly
> > matching prototype. This will ease plumbing later on in mmu.c.
> >
> > These callbacks track the gfn->pfn mappings in a simple rb_tree indexed
> > by IPA in lieu of a page-table. This rb-tree is kept in sync with pKVM's
> > state and is protected by the mmu_lock like a traditional stage-2
> > page-table.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> 
> Minor nits (feel free to ignore). Apart from that, and despite that
> for_each_mapping_in_range_safe macro:
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks!

> > ---
> >  arch/arm64/include/asm/kvm_host.h    |   1 +
> >  arch/arm64/include/asm/kvm_pgtable.h |  23 +--
> >  arch/arm64/include/asm/kvm_pkvm.h    |  26 ++++
> >  arch/arm64/kvm/pkvm.c                | 201 +++++++++++++++++++++++++++
> >  4 files changed, 242 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 1246f1d01dbf..f23f4ea9ec8b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -85,6 +85,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
> >  struct kvm_hyp_memcache {
> >         phys_addr_t head;
> >         unsigned long nr_pages;
> > +       struct pkvm_mapping *mapping; /* only used from EL1 */
> >  };
> >
> >  static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 04418b5e3004..6b9d274052c7 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -412,15 +412,20 @@ static inline bool kvm_pgtable_walk_lock_held(void)
> >   *                     be used instead of block mappings.
> >   */
> >  struct kvm_pgtable {
> > -       u32                                     ia_bits;
> > -       s8                                      start_level;
> > -       kvm_pteref_t                            pgd;
> > -       struct kvm_pgtable_mm_ops               *mm_ops;
> > -
> > -       /* Stage-2 only */
> > -       struct kvm_s2_mmu                       *mmu;
> > -       enum kvm_pgtable_stage2_flags           flags;
> > -       kvm_pgtable_force_pte_cb_t              force_pte_cb;
> > +       union {
> > +               struct rb_root                                  pkvm_mappings;
> > +               struct {
> > +                       u32                                     ia_bits;
> > +                       s8                                      start_level;
> > +                       kvm_pteref_t                            pgd;
> > +                       struct kvm_pgtable_mm_ops               *mm_ops;
> > +
> > +                       /* Stage-2 only */
> > +                       enum kvm_pgtable_stage2_flags           flags;
> > +                       kvm_pgtable_force_pte_cb_t              force_pte_cb;
> > +               };
> > +       };
> > +       struct kvm_s2_mmu                                       *mmu;
> >  };
> >
> >  /**
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index cd56acd9a842..65f988b6fe0d 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -137,4 +137,30 @@ static inline size_t pkvm_host_sve_state_size(void)
> >                         SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl)));
> >  }
> >
> > +struct pkvm_mapping {
> > +       struct rb_node node;
> > +       u64 gfn;
> > +       u64 pfn;
> > +};
> > +
> > +int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> > +                            struct kvm_pgtable_mm_ops *mm_ops);
> > +void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> > +int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
> > +                           enum kvm_pgtable_prot prot, void *mc,
> > +                           enum kvm_pgtable_walk_flags flags);
> > +int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
> > +int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
> > +int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> > +bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold);
> > +int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
> > +                                   enum kvm_pgtable_walk_flags flags);
> > +void pkvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
> > +                                enum kvm_pgtable_walk_flags flags);
> > +int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +                             struct kvm_mmu_memory_cache *mc);
> > +void pkvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level);
> > +kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
> > +                                              enum kvm_pgtable_prot prot, void *mc,
> > +                                              bool force_pte);
> >  #endif /* __ARM64_KVM_PKVM_H__ */
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 85117ea8f351..930b677eb9b0 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/init.h>
> >  #include <linux/kmemleak.h>
> >  #include <linux/kvm_host.h>
> > +#include <asm/kvm_mmu.h>
> >  #include <linux/memblock.h>
> >  #include <linux/mutex.h>
> >  #include <linux/sort.h>
> > @@ -268,3 +269,203 @@ static int __init finalize_pkvm(void)
> >         return ret;
> >  }
> >  device_initcall_sync(finalize_pkvm);
> > +
> > +static int cmp_mappings(struct rb_node *node, const struct rb_node *parent)
> > +{
> > +       struct pkvm_mapping *a = rb_entry(node, struct pkvm_mapping, node);
> > +       struct pkvm_mapping *b = rb_entry(parent, struct pkvm_mapping, node);
> > +
> > +       if (a->gfn < b->gfn)
> > +               return -1;
> > +       if (a->gfn > b->gfn)
> > +               return 1;
> > +       return 0;
> > +}
> > +
> > +static struct rb_node *find_first_mapping_node(struct rb_root *root, u64 gfn)
> > +{
> > +       struct rb_node *node = root->rb_node, *prev = NULL;
> > +       struct pkvm_mapping *mapping;
> > +
> > +       while (node) {
> > +               mapping = rb_entry(node, struct pkvm_mapping, node);
> > +               if (mapping->gfn == gfn)
> > +                       return node;
> > +               prev = node;
> > +               node = (gfn < mapping->gfn) ? node->rb_left : node->rb_right;
> > +       }
> > +
> > +       return prev;
> > +}
> > +
> > +/*
> > + * __tmp is updated to rb_next(__tmp) *before* entering the body of the loop to allow freeing
> > + * of __map inline.
> > + */
> > +#define for_each_mapping_in_range_safe(__pgt, __start, __end, __map)                           \
> > +       for (struct rb_node *__tmp = find_first_mapping_node(&(__pgt)->pkvm_mappings,           \
> > +                                                            ((__start) >> PAGE_SHIFT));        \
> > +            __tmp && ({                                                                        \
> > +                               __map = rb_entry(__tmp, struct pkvm_mapping, node);             \
> > +                               __tmp = rb_next(__tmp);                                         \
> > +                               true;                                                           \
> > +                      });                                                                      \
> > +           )                                                                                   \
> > +               if (__map->gfn < ((__start) >> PAGE_SHIFT))                                     \
> > +                       continue;                                                               \
> > +               else if (__map->gfn >= ((__end) >> PAGE_SHIFT))                                 \
> > +                       break;                                                                  \
> > +               else
> > +
> > +int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> > +                            struct kvm_pgtable_mm_ops *mm_ops)
> > +{
> > +       pgt->pkvm_mappings      = RB_ROOT;
> > +       pgt->mmu                = mmu;
> > +
> > +       return 0;
> > +}
> > +
> > +void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> > +{
> > +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +       pkvm_handle_t handle = kvm->arch.pkvm.handle;
> > +       struct pkvm_mapping *mapping;
> > +       struct rb_node *node;
> > +
> > +       if (!handle)
> > +               return;
> > +
> > +       node = rb_first(&pgt->pkvm_mappings);
> > +       while (node) {
> > +               mapping = rb_entry(node, struct pkvm_mapping, node);
> > +               kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
> > +               node = rb_next(node);
> > +               rb_erase(&mapping->node, &pgt->pkvm_mappings);
> > +               kfree(mapping);
> > +       }
> > +}
> > +
> > +int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +                          u64 phys, enum kvm_pgtable_prot prot,
> > +                          void *mc, enum kvm_pgtable_walk_flags flags)
> > +{
> > +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +       struct pkvm_mapping *mapping = NULL;
> > +       struct kvm_hyp_memcache *cache = mc;
> > +       u64 gfn = addr >> PAGE_SHIFT;
> > +       u64 pfn = phys >> PAGE_SHIFT;
> 
> Is it worth using the gpa_to_gfn and __phys_to_pfn helpers? Might
> obscure rather than help, but something to think about.

Apparently user_mem_abort() already uses an open coded variant of
gpa_to_gfn(), so I guess it makes sense to be consistent here? I
personally like the open coded variant better because it makes it clear
what this does, but no strong opinion really.

> > +       int ret;
> > +
> > +       if (size != PAGE_SIZE)
> > +               return -EINVAL;
> > +
> > +       lockdep_assert_held_write(&kvm->mmu_lock);
> > +       ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, prot);
> > +       if (ret) {
> > +               /* Is the gfn already mapped due to a racing vCPU? */
> > +               if (ret == -EPERM)
> > +                       return -EAGAIN;
> > +       }
> > +
> > +       swap(mapping, cache->mapping);
> > +       mapping->gfn = gfn;
> > +       mapping->pfn = pfn;
> > +       WARN_ON(rb_find_add(&mapping->node, &pgt->pkvm_mappings, cmp_mappings));
> 
> In addition to the warning, is it better to return an error as well?

Right, returning an error would be fatal for the guest I think, there's
nothing the VMM can do. The WARN alone keeps it limping along a bit
longer. In both case we're in deep trouble because the state is truly
borked.

I'm tempted to leave things as is (because the error path is really
going to be dead code in practice) unless anybody feels strongly about
it.

Cheers,
Quentin

> 
> > +       return ret;
> > +}
> > +
> > +int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
> > +{
> > +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +       pkvm_handle_t handle = kvm->arch.pkvm.handle;
> > +       struct pkvm_mapping *mapping;
> > +       int ret = 0;
> > +
> > +       lockdep_assert_held_write(&kvm->mmu_lock);
> > +       for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> > +               ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
> > +               if (WARN_ON(ret))
> > +                       break;
> > +               rb_erase(&mapping->node, &pgt->pkvm_mappings);
> > +               kfree(mapping);
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> > +{
> > +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +       pkvm_handle_t handle = kvm->arch.pkvm.handle;
> > +       struct pkvm_mapping *mapping;
> > +       int ret = 0;
> > +
> > +       lockdep_assert_held(&kvm->mmu_lock);
> > +       for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> > +               ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn);
> > +               if (WARN_ON(ret))
> > +                       break;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> > +{
> > +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +       struct pkvm_mapping *mapping;
> > +
> > +       lockdep_assert_held(&kvm->mmu_lock);
> > +       for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> > +               __clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn), PAGE_SIZE);
> > +
> > +       return 0;
> > +}
> > +
> > +bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold)
> > +{
> > +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +       pkvm_handle_t handle = kvm->arch.pkvm.handle;
> > +       struct pkvm_mapping *mapping;
> > +       bool young = false;
> > +
> > +       lockdep_assert_held(&kvm->mmu_lock);
> > +       for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> > +               young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
> > +                                          mkold);
> > +
> > +       return young;
> > +}
> > +
> > +int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
> > +                                   enum kvm_pgtable_walk_flags flags)
> > +{
> > +       return kvm_call_hyp_nvhe(__pkvm_host_relax_perms_guest, addr >> PAGE_SHIFT, prot);
> > +}
> > +
> > +void pkvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
> > +                                enum kvm_pgtable_walk_flags flags)
> > +{
> > +       WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_mkyoung_guest, addr >> PAGE_SHIFT));
> > +}
> > +
> > +void pkvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level)
> > +{
> > +       WARN_ON_ONCE(1);
> > +}
> > +
> > +kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
> > +                                       enum kvm_pgtable_prot prot, void *mc, bool force_pte)
> > +{
> > +       WARN_ON_ONCE(1);
> > +       return NULL;
> > +}
> > +
> > +int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +                             struct kvm_mmu_memory_cache *mc)
> > +{
> > +       WARN_ON_ONCE(1);
> > +       return -EINVAL;
> > +}
> > --
> > 2.47.1.613.gc27f4b7a9f-goog
> >
