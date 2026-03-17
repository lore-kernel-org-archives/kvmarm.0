Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44833A4F29
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 10:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773742854; cv=pass; b=fc90DEx1DS2Fhybp6jDI2jujTTbxYlyKwZcsUyqjXl1tst2A2V428s3vn0lDbNDCuJiF0GxZAbZDhTcb2Wgojcm9KFnLHORXy+1d1H2quJ2GJ7gUTpruj+ZC/6flmrIk6SxIK8PO3F0S4ytS/8DAkDDbHqHEDvbiPDD5sAyu8Q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773742854; c=relaxed/simple;
	bh=kjgUmSSqXdyFVjMPW4NPWY42E2uhu/ZjmUwRawGx3XU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OmV5HDZ1F3d08+nQDd6Fkw3DXq9dPT1c2eDaYwegu79fSHpZpZmvKWm7kEtyti0m0qy9SvJgJEHtaHX2uMezDJ7IGseALv5+N5vlmVSwO2eiBpnHM7l6fsrTrDyTT5HfVZP5ck+lWmHoleG3TDRM0uT5WA5hkHWRSdg++nTzgBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SQe3m1zj; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SQe3m1zj"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509069a7a7fso464921cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 03:20:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773742852; cv=none;
        d=google.com; s=arc-20240605;
        b=bMD688cnNC/Vr9qgTglDoGVIyXgnsuWKA9H5dk8kK/tk3M4tYMIam53tiQtFXJTV0D
         Wg7zFU2CKoNBEyRvD3u1xoHZ7Ivwh+ZodQaYAhwk9mLhkf0hB25VjErYDUncdO7y0ioD
         h+TEfAhevt5YWqloMK8PlYlUjpdgQUredysBUJtSM1OI2rFTrNKoK2ugKXZFUXY5xytg
         Cgk7KeAg8TASRxJ2pCNNZA1sweEmV12+Ku5knSKQuQy4r7hJ4YgEpN+evdIWIlhZxTWZ
         5/rLNEMjalko53zTqifGr2d/g7LYp5BiawYtzbdwp05QIg+2hjCxZVj5IHfHgomlNyOe
         8QEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f+G3k2rqZ2vXMSBMpnYGO0MAWxRn6Tt+kQK5k1SVAz4=;
        fh=ocX+70nkZbHRM5Q84Vre7Ykwy1gRlFLLieVqQTETzeU=;
        b=lKLC82VVRzhzsyrahMsLp8GYJAu8oFS/Y6HpCmf9Upz0Nn6Bi1HAEcFO1mpzzG5ntH
         ykxcslyJaLBQ1rmDoTEzqx7O/gZPcGNoYP0gmKzz68qiTIhRZb7mcXKaaTbqS/WX6oya
         5GnRt2vGWuKe9JeHJxzuy8l3hrbu6j5FVfjL0Nat4319A8kfH5LfEoplfB39KPF3MTVQ
         Ao+kvQVAxbnRY3D1BFzfSUlR3VyGnpnVtBmhf/bNJJ4uBTXX9ptzkFnajMOoCtIxiGz5
         6FmCtxAacyGKFdFBCvZYW0EsTv0f1rgXvXm3ZoqKaIWQ4PBq83mbhdldxiClq1hTGnWl
         wRBQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773742852; x=1774347652; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f+G3k2rqZ2vXMSBMpnYGO0MAWxRn6Tt+kQK5k1SVAz4=;
        b=SQe3m1zjEgenACmybs0hWQ0XAjGjc2Zs7bOJ/kAAsvNg02x4bAkEI2eOYNkVMpWeGR
         s4tCor2j5lAxkoFnn+pKI4P84uaw3r0B4qutJEmvjmKF5XLZk7I3T8ARj3hPNxhrmHKE
         0TIGn6WyakcXlsk6LFoaQcjAGnnjww6mIW3OZ880/XdnWmkjjPdXyS6ezwS4I02PQCvZ
         vOTXf6S3vuQCA2cmuAzkcR2NnHXEpUEzsaES9+VZSZNyPmQP48eW74NSDOVOX58cLq7r
         q19JbrOhA2C+mZ//1I1Jn3Bebj3j862SBGiZ0UOKjH8NlN7ALCIq5J8ZrRuolZjtsFBR
         L+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773742852; x=1774347652;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+G3k2rqZ2vXMSBMpnYGO0MAWxRn6Tt+kQK5k1SVAz4=;
        b=UfrDp7juVaqYZu62ECW2IDV1lJ0Is9KkBnajVJbCmqpPjW9RN8k2g0bA/jqzo3fJhU
         liXAoR43xmF15+/w17hn2ecOAmFbDkQEt8zwIOIgizRNKOYnb9nqE5txmKizwL3YOVXu
         HS3wEUO3NsuV10emC2GG/iIDy53LmF04Jjk5YwfJB55brCEUUlYmKCFOROZzGnKASJrw
         KBEedOfleA2+D/KPLbMXorg7QaEaSSJy6J6IEkbMICDmmXmIGM9qSQ4HCHXcU+mRnyBO
         FdEn3JtvJ91r/rpvENI0JKOvWCvhj3kQp4I6N0H8TOWn5ZJO5d0HNXkdPZj3WSpMMeqc
         nKZA==
X-Forwarded-Encrypted: i=1; AJvYcCXijarrdXX/Eo5iKX+6Ce5ZK3hyN1cs1/Pr4vTLk7TAauNTcRMgFB6RlRP4GiZtfsTq+b0rZ+A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRnpsD4MNI9t0rK7hn4v/PCt+FWG/iuEupSBKpeFaMHdFxD+Qu
	B6mW+TORLhKdkkTeFRvnMVbX6gjl04CICk2QyrwgOJu6gG1f5xkK9ESJDwC8SgTuZIz7qm8uMbG
	JNxpf2e7K+fN/fPei6bXh5rBcfru3ZDexpSWyCEVA
X-Gm-Gg: ATEYQzymhTQszYYUC/JhmEMl9CJs4ipjwMkG8eXClu5LVeuj9RtVv8SdAqXlUpGmT+C
	DaySTmr6bP41+RdF4UzTVhjcLvrFB5uADGojZt04Mbt0ANUZ2+niFR+CKYStMuy4/n7sYo/+FKe
	fbcSOHOPT+yToGMEJsoVFNnI5Wxig2jZwSyIpphdaRCfnNaIkXHlV/d3IVQnPt/yRy/f2ILqqin
	9feZN1PcZqzqm0CZiY/XOtlwasCixsdoX59gC6hZ6tmwTZWV4NrWrMPKIYWTy2Q7A/YJ4tbpbAN
	UOjfHgBgLixv6oZkRdg/lXSDz8m2C3uq+JTmrvq1rM4nUFg=
X-Received: by 2002:a05:622a:1ba7:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-5099ac6cce6mr10382591cf.3.1773742851259; Tue, 17 Mar 2026
 03:20:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <20260310124933.830025-9-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-9-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 10:20:14 +0000
X-Gm-Features: AaiRm50TPE0FIw-7TUW05xg8zVnIiwfm0n7O_Lk2IR6hWpuMOCIItnRIP8yL7co
Message-ID: <CA+EHjTzfoRPvfe-SNW_e=-p+3Yy2UPu90y0bsvSJ9OOgnc7C6g@mail.gmail.com>
Subject: Re: [PATCH 08/14] KVM: arm64: Trap & emulate the ITS MAPD command
To: Sebastian Ene <sebastianene@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, catalin.marinas@arm.com, dbrazdil@google.com, 
	joey.gouly@arm.com, kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, 
	oupton@kernel.org, perlarsen@google.com, qperret@google.com, 
	rananta@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi Sebastian,

On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
>
> Parse the MAPD command and extract the ITT address to
> sanitize it. When the command has the valid bit set,
> share the memory that holds the ITT table
> with the hypervisor to prevent it from being used
> by someone else and track the pages in an array.
> When the valid bit is cleared, check if the pages
> are tracked and then remove the sharing with the
> hypervisor.
> Check if we need to do any shadow table updates
> in case the device table is configured with an
> indirect layout.

Same as the previous commit message, could you please clarify the
"why" rather than only the "how"?

For someone without deep context of the pKVM ITS isolation model, this
message does not explain the threat vector.

>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/its_emulate.c | 182 ++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v3-its.c      |  12 --
>  include/linux/irqchip/arm-gic-v3.h    |  12 ++
>  3 files changed, 194 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> index 865a5d6353ed..722fe80dc2e5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -12,8 +12,13 @@ struct its_priv_state {
>         void *cmd_host_cwriter;
>         struct its_shadow_tables *shadow;
>         hyp_spinlock_t its_lock;
> +       u16 empty_idx;
> +       u64 tracked_pfns[];
>  };
>
> +#define MAX_TRACKED_PFNS       ((PAGE_SIZE - offsetof(struct its_priv_state, \
> +                                 tracked_pfns)) / sizeof(u64))
> +
>  struct its_handler {
>         u64 offset;
>         u8 access_size;
> @@ -23,6 +28,178 @@ struct its_handler {
>
>  DEFINE_HYP_SPINLOCK(its_setup_lock);
>
> +static int track_pfn_add(struct its_priv_state *its, u64 pfn)
> +{
> +       int ret, i;
> +
> +       if (its->empty_idx + 1 >= MAX_TRACKED_PFNS)
> +               return -ENOSPC;

Why +1? This wastes the final slot in the array. It should just be: if
(its->empty_idx >= MAX_TRACKED_PFNS).

More importantly, doing an O(N) linear array scan to manage empty_idx
inside track_pfn_add and track_pfn_remove while holding the raw
its_priv->its_lock needlessly inflates host IRQ latency. Please
replace this array with a  BITMAP.

> +
> +       ret = __pkvm_host_share_hyp(pfn);
> +       if (ret)
> +               return ret;
> +
> +       its->tracked_pfns[its->empty_idx] = pfn;
> +       for (i = 0; i < MAX_TRACKED_PFNS; i++) {
> +               if (!its->tracked_pfns[i])
> +                       break;
> +       }
> +
> +       its->empty_idx = i;
> +       return 0;
> +}
> +
> +static int track_pfn_remove(struct its_priv_state *its, u64 pfn)
> +{
> +       int i, ret;
> +
> +       for (i = 0; i < MAX_TRACKED_PFNS; i++) {
> +               if (its->tracked_pfns[i] != pfn)
> +                       continue;
> +
> +               ret = __pkvm_host_unshare_hyp(pfn);
> +               if (ret)
> +                       return ret;
> +
> +               its->tracked_pfns[i] = 0;
> +               its->empty_idx = i;
> +       }
> +
> +       return 0;
> +}

If the PFN isn't found in the array, this silently returns 0 (success).

> +
> +static int get_num_itt_pages(struct its_priv_state *its, u8 num_bits)
> +{
> +       int nr_ites = 1 << (num_bits + 1);
> +       u64 size, gits_typer = readq_relaxed(its->base + GITS_TYPER);
> +
> +       size = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, gits_typer) + 1);
> +       size = max(size, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> +
> +       return PAGE_ALIGN(size) >> PAGE_SHIFT;
> +}
> +
> +static int track_pfn(struct its_priv_state *its, u64 start_pfn, int num_pages, bool remove)
> +{
> +       int i, ret;
> +
> +       for (i = 0; i < num_pages; i++) {
> +               if (remove)
> +                       ret = track_pfn_remove(its, start_pfn + i);
> +               else
> +                       ret = track_pfn_add(its, start_pfn + i);
> +
> +               if (ret)
> +                       goto err_track;
> +       }
> +
> +       return 0;
> +err_track:
> +       for (i = i - 1; i >= 0; i--) {
> +               if (remove)
> +                       track_pfn_add(its, start_pfn + i);
> +               else
> +                       track_pfn_remove(its, start_pfn + i);
> +       }
> +
> +       return ret;
> +}
> +
> +static struct its_baser *get_table(struct its_priv_state *its, u64 type)
> +{
> +       int i;
> +       struct its_shadow_tables *shadow = its->shadow;
> +
> +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> +               if (GITS_BASER_TYPE(shadow->tables[i].val) == type)
> +                       return &shadow->tables[i];
> +       }
> +
> +       return NULL;
> +}
> +
> +static int check_table_update(struct its_priv_state *its, u32 id, u64 type)
> +{
> +       u32 lvl1_idx;
> +       u64 esz, *host_table, *hyp_table, new_entry, update;
> +       struct its_baser *table = get_table(its, type);
> +       int ret;
> +       phys_addr_t new_lvl2_table, lvl2_table;
> +
> +       if (!table)
> +               return -EINVAL;
> +
> +       if (!(table->val & GITS_BASER_INDIRECT))
> +               return 0;
> +
> +       esz = GITS_BASER_ENTRY_SIZE(table->val);
> +       lvl1_idx = id / (table->psz / esz);
> +
> +       host_table = kern_hyp_va(table->shadow);
> +       hyp_table = kern_hyp_va(table->base);
> +
> +       new_entry = host_table[id];

This accesses the entry based on id, which isn't sanitized.

> +       update = new_entry ^ hyp_table[id];
> +       if (!update || !(update & GITS_BASER_VALID))
> +               return 0;

This assumes any meaningful update must toggle the Valid bit. If the
host issues a MAPD that changes the Level 2 table pointer but keeps
Valid=1, update & GITS_BASER_VALID is 0.

> +
> +       new_lvl2_table = hyp_phys_to_pfn(new_entry & PHYS_MASK_SHIFT);
> +       lvl2_table = hyp_phys_to_pfn(hyp_table[id] & PHYS_MASK_SHIFT);

Should this be PHYS_MASK?

> +       if (new_entry & GITS_BASER_VALID)
> +               ret = __pkvm_host_donate_hyp(new_lvl2_table, table->psz >> PAGE_SHIFT);
> +       else
> +               ret = __pkvm_hyp_donate_host(lvl2_table, table->psz >> PAGE_SHIFT);

Similar issue to the one I mentioned in a previous patch regarding ITS
page size vs host page size.


> +       if (ret)
> +               return ret;
> +
> +       hyp_table[id] = new_entry;
> +       return 0;
> +}
> +
> +static int process_its_mapd(struct its_priv_state *its, struct its_cmd_block *cmd)
> +{
> +       phys_addr_t itt_addr = cmd->raw_cmd[2] & GENMASK(51, 8);
> +       u8 size = cmd->raw_cmd[1] & GENMASK(4, 0);
> +       bool remove = !(cmd->raw_cmd[2] & BIT(63));
> +       u32 device_id = cmd->raw_cmd[0] >> 32;
> +       int num_pages, ret;
> +       u64 base_pfn;
> +
> +       if (PAGE_ALIGNED(itt_addr))
> +               return -EINVAL;

This is inverted, right?

Cheers,
/fuad

> +
> +       base_pfn = hyp_phys_to_pfn(itt_addr);
> +       num_pages = get_num_itt_pages(its, size);
> +
> +       ret = check_table_update(its, device_id, GITS_BASER_TYPE_DEVICE);
> +       if (ret)
> +               return ret;
> +
> +       return track_pfn(its, base_pfn, num_pages, remove);
> +}
> +
> +static int parse_its_cmdq(struct its_priv_state *its, int offset, ssize_t len)
> +{
> +       struct its_cmd_block *cmd = its->cmd_hyp_base + offset;
> +       u8 req_type;
> +       int ret = 0;
> +
> +       while (len > 0 && !ret) {
> +               req_type = cmd->raw_cmd[0] & GENMASK(7, 0);
> +
> +               switch (req_type) {
> +               case GITS_CMD_MAPD:
> +                       ret = process_its_mapd(its, cmd);
> +                       break;
> +               }
> +
> +               cmd++;
> +               len -= sizeof(struct its_cmd_block);
> +       }
> +
> +       return ret;
> +}
> +
>  static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
>  {
>         u64 cwriter_offset = value & GENMASK(19, 5);
> @@ -41,11 +218,15 @@ static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
>                 return;
>
>         memcpy(its->cmd_hyp_base + cmd_offset, its->cmd_host_cwriter, cmd_len);
> +       if (parse_its_cmdq(its, cmd_offset, cmd_len))
> +               return;
>
>         its->cmd_host_cwriter = its->cmd_host_base +
>                 (cmd_offset + cmd_len) % cmdq_sz;
>         if (its->cmd_host_cwriter == its->cmd_host_base) {
>                 memcpy(its->cmd_hyp_base, its->cmd_host_base, cwriter_offset);
> +               if (parse_its_cmdq(its, cmd_offset, cmd_len))
> +                       return;
>
>                 its->cmd_host_cwriter = its->cmd_host_base + cwriter_offset;
>         }
> @@ -357,6 +538,7 @@ int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
>         priv_state->cmd_hyp_base = kern_hyp_va(shadow->cmd_original);
>         priv_state->cmd_host_base = kern_hyp_va(shadow->cmd_shadow);
>         priv_state->cmd_host_cwriter = priv_state->cmd_host_base;
> +       priv_state->empty_idx = 0;
>
>         hyp_spin_unlock(&its_setup_lock);
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 278dbc56f962..be78f7dccb9f 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -121,8 +121,6 @@ static DEFINE_PER_CPU(struct its_node *, local_4_1_its);
>  #define is_v4_1(its)           (!!((its)->typer & GITS_TYPER_VMAPP))
>  #define device_ids(its)                (FIELD_GET(GITS_TYPER_DEVBITS, (its)->typer) + 1)
>
> -#define ITS_ITT_ALIGN          SZ_256
> -
>  /* The maximum number of VPEID bits supported by VLPI commands */
>  #define ITS_MAX_VPEID_BITS                                             \
>         ({                                                              \
> @@ -515,16 +513,6 @@ struct its_cmd_desc {
>         };
>  };
>
> -/*
> - * The ITS command block, which is what the ITS actually parses.
> - */
> -struct its_cmd_block {
> -       union {
> -               u64     raw_cmd[4];
> -               __le64  raw_cmd_le[4];
> -       };
> -};
> -
>  #define ITS_CMD_QUEUE_SZ               SZ_64K
>  #define ITS_CMD_QUEUE_NR_ENTRIES       (ITS_CMD_QUEUE_SZ / sizeof(struct its_cmd_block))
>
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 40457a4375d4..4f7d47f3d970 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -612,6 +612,8 @@
>   */
>  #define GIC_IRQ_TYPE_LPI               0xa110c8ed
>
> +#define ITS_ITT_ALIGN                  SZ_256
> +
>  struct rdists {
>         struct {
>                 raw_spinlock_t  rd_lock;
> @@ -634,6 +636,16 @@ struct rdists {
>         bool                    has_vpend_valid_dirty;
>  };
>
> +/*
> + * The ITS command block, which is what the ITS actually parses.
> + */
> +struct its_cmd_block {
> +       union {
> +               u64     raw_cmd[4];
> +               __le64  raw_cmd_le[4];
> +       };
> +};
> +
>  struct irq_domain;
>  struct fwnode_handle;
>  int __init its_lpi_memreserve_init(void);
> --
> 2.53.0.473.g4a7958ca14-goog
>
