Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6839EBF6
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 22:23:37 +0000 (UTC)
Received: by mail-qt1-f170.google.com with SMTP id h24so33183qta.9
        for <kvmarm@lists.linux.dev>; Wed, 09 Nov 2022 14:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uJg+kpvNkPD030tpMMGmVHe2gjQx4qRtyPNBYhTi0Do=;
        b=spArdvT5xfNKFKqJhO//PlvjWcnhvTF2+ViWLb1H96v+OMZm56WD/DL3FTv1+ByYEN
         lsgdE+x7WHSdiZJoLNMKj10oOzlPFVH7OOqJ3Jyl5kqmK/M/sL+IkOQM+KUYRBnDS+Am
         BC+jNOVK5u7F88DAPQFuRMrP8sNj8OpZ35wpepJFStMGQbp7Oicy1zBJOnz2SHSZDpbi
         iZIdImQTkj60o6FYxDzctqMSs5CpMqWSbgDo03a2UfLWnKiqGab805LagiU7qMPRCfXE
         Sq2ANew7d5NwsmA7OWYYkZd+UB7ov+92nWYlaeLE/MXNuAxohNyYD8KzCxJoTSOA58/c
         HdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uJg+kpvNkPD030tpMMGmVHe2gjQx4qRtyPNBYhTi0Do=;
        b=uBdH4QcEJ3h+qDYN6y0toKk6rWbeNaSQHRvvkSgBooS0SpvvXzhTMDh1yF/O0Cg68a
         +9LHMTKgqIlsB4j79NAjDH4U6tN0uDkHjfZ2InP/M3AnTtvDObXRoNQImodh3HVpFl50
         zsIqyDH+vCk9lXUfLi+gB48RQ5XWts+VTbAV+ZFnlr9hHF8dCsp8/G9HI85DuJ8+Grk9
         Meq7vm7ySI/9P/pjYkL/7Iki9w6k0oaWlaW1SpqvunmfJadQpApc2UTMZ4wEha56gDgM
         /fV8mqf2LYn1c56ZgRLRWT8UpQr87axiE7TRkUgLSyCSIQoYh25RgSXEZ1oOPb+NgAiy
         0yXA==
X-Gm-Message-State: ACrzQf1rnUn6SSctm92zb7Dcr23P1eoUBbLDtPbYrG2NsNd8LwhMI5Pq
	9aNlTY8O3De8kNceglIDucjeX6iXucNUZrH7OtV+ig==
X-Google-Smtp-Source: AMsMyM4tGmioPPwHHbmDR56b9nxo9rsvbynmSavlKkjED5lHQQmrp870AqPkMfEw30VQwHWm31A/vU+rVcf7R8CSS1Q=
X-Received: by 2002:ac8:7d4d:0:b0:3a5:5987:432b with SMTP id
 h13-20020ac87d4d000000b003a55987432bmr26351094qtb.566.1668032617470; Wed, 09
 Nov 2022 14:23:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-5-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-5-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:23:26 -0800
Message-ID: <CANgfPd_RXJXGQDWrzT-ZCYLOkK_J_LMP3mFkmGsnVAPsqr7KdQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/14] KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	David Matlack <dmatlack@google.com>, Quentin Perret <qperret@google.com>, Gavin Shan <gshan@redhat.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221109222326.s7zL-AQrHo-wacCmDmh78XZDn58cEJHEoObbXFlrqjA@z>

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> In order to tear down page tables from outside the context of
> kvm_pgtable (such as an RCU callback), stop passing a pointer through
> kvm_pgtable_walk_data.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index db25e81a9890..93989b750a26 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -50,7 +50,6 @@
>  #define KVM_MAX_OWNER_ID               1
>
>  struct kvm_pgtable_walk_data {
> -       struct kvm_pgtable              *pgt;
>         struct kvm_pgtable_walker       *walker;
>
>         u64                             addr;
> @@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>         return (data->addr >> shift) & mask;
>  }
>
> -static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
> +static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>  {
>         u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
>         u64 mask = BIT(pgt->ia_bits) - 1;
> @@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>         return (addr & mask) >> shift;
>  }
>
> -static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
> -{
> -       return __kvm_pgd_page_idx(data->pgt, data->addr);
> -}
> -
>  static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>  {
>         struct kvm_pgtable pgt = {
> @@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>                 .start_level    = start_level,
>         };
>
> -       return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> +       return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>  }
>
>  static bool kvm_pte_table(kvm_pte_t pte, u32 level)
> @@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>         return ret;
>  }
>
> -static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
> +static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
>  {
>         u32 idx;
>         int ret = 0;
> -       struct kvm_pgtable *pgt = data->pgt;
>         u64 limit = BIT(pgt->ia_bits);
>
>         if (data->addr > limit || data->end > limit)
> @@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>         if (!pgt->pgd)
>                 return -EINVAL;
>
> -       for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
> +       for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
>                 kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>
>                 ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
> @@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                      struct kvm_pgtable_walker *walker)
>  {
>         struct kvm_pgtable_walk_data walk_data = {
> -               .pgt    = pgt,
>                 .addr   = ALIGN_DOWN(addr, PAGE_SIZE),
>                 .end    = PAGE_ALIGN(walk_data.addr + size),
>                 .walker = walker,
>         };
>
> -       return _kvm_pgtable_walk(&walk_data);
> +       return _kvm_pgtable_walk(pgt, &walk_data);
>  }
>
>  struct leaf_walk_data {
> --
> 2.38.1.431.g37b22c650d-goog
>
