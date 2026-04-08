Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C47927FD6D
	for <kvmarm@lists.linux.dev>; Wed,  8 Apr 2026 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775657123; cv=none; b=LnH/Xk++PT2/aUDCE5qR5e2Fnen33vx2db2Si/FzdI/KS0LgcqP8jMGOIsCQkhcn+z2C9MIKuQAkY/vGd9SBGex+Uqo9g575HjPLUkQ6GSNMDUzHQUx2Es/rPUg1GVYGkgNhH96DlWlaBSqpe3m75DLABwi+64HZrjTW0Ubl4Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775657123; c=relaxed/simple;
	bh=ktdCQBUWxDJu3zmf6AZhTGm01YVYR/bo2D/VBezQORo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0r3oiYNXzhDwUYGYN23n3Mp2W2ecOcCB9WrbYq+gn/gT39YyduIaEcewp5FzxXOnObe+TT9JNRd67DBly0EAmSkEvijSdqm/ko4MucrbjIt+4kxK66xZ09LQow926o5vV+WDZDZpsj1w51PaajOMgz/b4kh1hX9mm7GGkSopLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IymoiN6g; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IymoiN6g"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4887ec3d8e7so122515e9.0
        for <kvmarm@lists.linux.dev>; Wed, 08 Apr 2026 07:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775657120; x=1776261920; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0++SFeN/8IKl7yQXtQlORsxUSVj0PcOer7nQ4yJ37E=;
        b=IymoiN6ggKd8jSxt33bKjYqaJNb0r9VJtE4d3LUdzIWR9fjW2ByG3e+ZSmKMWSfz+4
         p6nshcETUd65l7kbRUdbtEsS6GIHr72SnQoDWP1/F8RBnz2JyvtYSpMWAEPhxPaeW/fr
         DdP9xziOUJTpcHKibQSbLFDOToyg82KgTbckJ2umHvJUrGSyZMc5glkb5KZQDqFmkWTY
         S0Mi4wZAuz/0kt4Prz8zJbkhg4fTMYZhW2DQE+d+b4EQywxcN2OcnubGlmuqDRr4Vl2I
         kmV3ezZ1C5O+6q5LRBmq5Kfw1sx8O+tuWlyUVI6T2cq/M1IEt+eMto3D2wcAevfvcjby
         9cGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775657120; x=1776261920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0++SFeN/8IKl7yQXtQlORsxUSVj0PcOer7nQ4yJ37E=;
        b=geIGc4lsENXXr8GyNjlEpy465R2E1PlM9IJWrutPQVWyOW0nF5i/JnxPP8U1vnoKlp
         Ohh8JtorzHaX9C3HFSqZVkCyC1JtTijRhqlHRwq2i18BY4Nsknd21aEXHe1zbRNgAM5D
         pwX+5iefE0kZJ1VHkpcMxd8AAQN6NEOUs+B06kjfHHlg+TgTU59I2Jt8bw34M8pANXYD
         H/KJPHOQuC+ok7Qf7oBdNz//crF9YybbLZW+8VW7it3+KXTujvaz0vLjyivo990ZFGgR
         YXfVFGpOiQyNznOTCATx//tfL6fXitNqlm2LqzPoTHTGNJMF3P35CqXhglRRMBN4EGfI
         vPsA==
X-Forwarded-Encrypted: i=1; AJvYcCUrvxs4snHdp+mUHyzlSHPPi59/xVvWj//EviF+e5TGt20KW0fbU9VxDXDVrWJsi0Y+W/sBKcs=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywez38NFZdKDlIRlCw8tLFmzBFacK9ELzcqIdr7RP+lj4MiRrsc
	qxHsdYP0+96qwSvWn9n1f2QthUB1c1V52rlmUUmOEByZnhoiRKYsmRHkR524Q5kUGg==
X-Gm-Gg: AeBDiet1PXBjA7EPKKXBOCiIdzfA3JRoBcXOrCZpzk268yBvf3JDNgMINxKDeosnadq
	0eHVzFPqDZtqwsYa6TdOdcUQp70C4Jp1PqpEixOz5T+sjfKjZQALZv0mFEIFbDcIhFa7iVxiaeg
	sNeIg7uBVfdpFGdAWiKYRmCZy66OyUhgQXLlZDV1NDV2h+bv5gNnMSO+eEPbCoUjxvkEZtG4ANT
	i6MZw+eF6Yov8qwYix8k2HL26QI+YSpGc7hxJuVYMOUV0NBn7nAtrSPX0heJebgY4/Dc5VmBQPU
	3nQBCEzsB0Eaw/oQUTi6ARFNCV8KUOW4JjTt75Kg/Kc7TfSQuMMUjc57MCE+dMett0IDRmDkZrk
	dZA4NoQaklTWfd+spuSHPQNGTMQ9bAPX17U7nWEYR9YsqSvM8QG+06dPTNb+QJBpEwh9ZwFKqR2
	B00ZNr41a4Iy/YVLwKYEvK3v1RYmuTqr2+jYzGnsXYb21QruKiqkHD2VrUTqsEG4t0FYY=
X-Received: by 2002:a05:600d:4:b0:477:c5b3:7a9b with SMTP id 5b1f17b1804b1-488cbf9addcmr186195e9.10.1775657119067;
        Wed, 08 Apr 2026 07:05:19 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2a71f7sm60713387f8f.1.2026.04.08.07.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:05:18 -0700 (PDT)
Date: Wed, 8 Apr 2026 14:05:14 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tglx@kernel.org,
	vdonnefort@google.com, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH 08/14] KVM: arm64: Trap & emulate the ITS MAPD command
Message-ID: <adZgmgNGt7saHQVd@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-9-sebastianene@google.com>
 <CA+EHjTzfoRPvfe-SNW_e=-p+3Yy2UPu90y0bsvSJ9OOgnc7C6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzfoRPvfe-SNW_e=-p+3Yy2UPu90y0bsvSJ9OOgnc7C6g@mail.gmail.com>

On Tue, Mar 17, 2026 at 10:20:14AM +0000, Fuad Tabba wrote:

Hi Fuad,

> Hi Sebastian,
> 
> On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
> >
> > Parse the MAPD command and extract the ITT address to
> > sanitize it. When the command has the valid bit set,
> > share the memory that holds the ITT table
> > with the hypervisor to prevent it from being used
> > by someone else and track the pages in an array.
> > When the valid bit is cleared, check if the pages
> > are tracked and then remove the sharing with the
> > hypervisor.
> > Check if we need to do any shadow table updates
> > in case the device table is configured with an
> > indirect layout.
> 
> Same as the previous commit message, could you please clarify the
> "why" rather than only the "how"?

Sure, I will enhance the commit message. There are at least two differnt
ways in which you can abuse this from a compromised host kernel to
attack the hypervisor memory:

One way:

1. Send a MAPD command to the ITS with an ITT address that belongs to the
hypervisor. This creates a device table entry that holds the ITT
address.
2. Use the MAPTI command to create an entry into the ITT table which
writes the entry to the previously pointed hypervisor memory.

Second way:

(assuming the device table is configured with an indirect layout)

1. Create a first level valid entry that holds a pointer to the hypervisor memory 
2. Send a MAPD command so that you create a DTE in the memory pointed at
(1)

> 
> For someone without deep context of the pKVM ITS isolation model, this
> message does not explain the threat vector.
> 
> >
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/its_emulate.c | 182 ++++++++++++++++++++++++++
> >  drivers/irqchip/irq-gic-v3-its.c      |  12 --
> >  include/linux/irqchip/arm-gic-v3.h    |  12 ++
> >  3 files changed, 194 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > index 865a5d6353ed..722fe80dc2e5 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > @@ -12,8 +12,13 @@ struct its_priv_state {
> >         void *cmd_host_cwriter;
> >         struct its_shadow_tables *shadow;
> >         hyp_spinlock_t its_lock;
> > +       u16 empty_idx;
> > +       u64 tracked_pfns[];
> >  };
> >
> > +#define MAX_TRACKED_PFNS       ((PAGE_SIZE - offsetof(struct its_priv_state, \
> > +                                 tracked_pfns)) / sizeof(u64))
> > +
> >  struct its_handler {
> >         u64 offset;
> >         u8 access_size;
> > @@ -23,6 +28,178 @@ struct its_handler {
> >
> >  DEFINE_HYP_SPINLOCK(its_setup_lock);
> >
> > +static int track_pfn_add(struct its_priv_state *its, u64 pfn)
> > +{
> > +       int ret, i;
> > +
> > +       if (its->empty_idx + 1 >= MAX_TRACKED_PFNS)
> > +               return -ENOSPC;
> 
> Why +1? This wastes the final slot in the array. It should just be: if
> (its->empty_idx >= MAX_TRACKED_PFNS).
> 
> More importantly, doing an O(N) linear array scan to manage empty_idx
> inside track_pfn_add and track_pfn_remove while holding the raw
> its_priv->its_lock needlessly inflates host IRQ latency. Please
> replace this array with a  BITMAP.
> 
> > +
> > +       ret = __pkvm_host_share_hyp(pfn);
> > +       if (ret)
> > +               return ret;
> > +
> > +       its->tracked_pfns[its->empty_idx] = pfn;
> > +       for (i = 0; i < MAX_TRACKED_PFNS; i++) {
> > +               if (!its->tracked_pfns[i])
> > +                       break;
> > +       }
> > +
> > +       its->empty_idx = i;
> > +       return 0;
> > +}
> > +
> > +static int track_pfn_remove(struct its_priv_state *its, u64 pfn)
> > +{
> > +       int i, ret;
> > +
> > +       for (i = 0; i < MAX_TRACKED_PFNS; i++) {
> > +               if (its->tracked_pfns[i] != pfn)
> > +                       continue;
> > +
> > +               ret = __pkvm_host_unshare_hyp(pfn);
> > +               if (ret)
> > +                       return ret;
> > +
> > +               its->tracked_pfns[i] = 0;
> > +               its->empty_idx = i;
> > +       }
> > +
> > +       return 0;
> > +}
> 
> If the PFN isn't found in the array, this silently returns 0 (success).
> 
> > +
> > +static int get_num_itt_pages(struct its_priv_state *its, u8 num_bits)
> > +{
> > +       int nr_ites = 1 << (num_bits + 1);
> > +       u64 size, gits_typer = readq_relaxed(its->base + GITS_TYPER);
> > +
> > +       size = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, gits_typer) + 1);
> > +       size = max(size, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> > +
> > +       return PAGE_ALIGN(size) >> PAGE_SHIFT;
> > +}
> > +
> > +static int track_pfn(struct its_priv_state *its, u64 start_pfn, int num_pages, bool remove)
> > +{
> > +       int i, ret;
> > +
> > +       for (i = 0; i < num_pages; i++) {
> > +               if (remove)
> > +                       ret = track_pfn_remove(its, start_pfn + i);
> > +               else
> > +                       ret = track_pfn_add(its, start_pfn + i);
> > +
> > +               if (ret)
> > +                       goto err_track;
> > +       }
> > +
> > +       return 0;
> > +err_track:
> > +       for (i = i - 1; i >= 0; i--) {
> > +               if (remove)
> > +                       track_pfn_add(its, start_pfn + i);
> > +               else
> > +                       track_pfn_remove(its, start_pfn + i);
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static struct its_baser *get_table(struct its_priv_state *its, u64 type)
> > +{
> > +       int i;
> > +       struct its_shadow_tables *shadow = its->shadow;
> > +
> > +       for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> > +               if (GITS_BASER_TYPE(shadow->tables[i].val) == type)
> > +                       return &shadow->tables[i];
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> > +static int check_table_update(struct its_priv_state *its, u32 id, u64 type)
> > +{
> > +       u32 lvl1_idx;
> > +       u64 esz, *host_table, *hyp_table, new_entry, update;
> > +       struct its_baser *table = get_table(its, type);
> > +       int ret;
> > +       phys_addr_t new_lvl2_table, lvl2_table;
> > +
> > +       if (!table)
> > +               return -EINVAL;
> > +
> > +       if (!(table->val & GITS_BASER_INDIRECT))
> > +               return 0;
> > +
> > +       esz = GITS_BASER_ENTRY_SIZE(table->val);
> > +       lvl1_idx = id / (table->psz / esz);
> > +
> > +       host_table = kern_hyp_va(table->shadow);
> > +       hyp_table = kern_hyp_va(table->base);
> > +
> > +       new_entry = host_table[id];
> 
> This accesses the entry based on id, which isn't sanitized.
> 

I should use lvl1_idx instead of id and sanitize this.

> > +       update = new_entry ^ hyp_table[id];
> > +       if (!update || !(update & GITS_BASER_VALID))
> > +               return 0;
> 
> This assumes any meaningful update must toggle the Valid bit. If the
> host issues a MAPD that changes the Level 2 table pointer but keeps
> Valid=1, update & GITS_BASER_VALID is 0.
> 

That is exactly what it does but it is expected because it usually
transitions from valid -> invalid and the address doesn't change without
this state transition.

> > +
> > +       new_lvl2_table = hyp_phys_to_pfn(new_entry & PHYS_MASK_SHIFT);
> > +       lvl2_table = hyp_phys_to_pfn(hyp_table[id] & PHYS_MASK_SHIFT);
> 
> Should this be PHYS_MASK?

Yes good catch !

> 
> > +       if (new_entry & GITS_BASER_VALID)
> > +               ret = __pkvm_host_donate_hyp(new_lvl2_table, table->psz >> PAGE_SHIFT);
> > +       else
> > +               ret = __pkvm_hyp_donate_host(lvl2_table, table->psz >> PAGE_SHIFT);
> 
> Similar issue to the one I mentioned in a previous patch regarding ITS
> page size vs host page size.
> 
> 
> > +       if (ret)
> > +               return ret;
> > +
> > +       hyp_table[id] = new_entry;
> > +       return 0;
> > +}
> > +
> > +static int process_its_mapd(struct its_priv_state *its, struct its_cmd_block *cmd)
> > +{
> > +       phys_addr_t itt_addr = cmd->raw_cmd[2] & GENMASK(51, 8);
> > +       u8 size = cmd->raw_cmd[1] & GENMASK(4, 0);
> > +       bool remove = !(cmd->raw_cmd[2] & BIT(63));
> > +       u32 device_id = cmd->raw_cmd[0] >> 32;
> > +       int num_pages, ret;
> > +       u64 base_pfn;
> > +
> > +       if (PAGE_ALIGNED(itt_addr))
> > +               return -EINVAL;
> 
> This is inverted, right?
>

Ouch (hide) yes, I will fix this.

> Cheers,
> /fuad

Cheers,
Sebastian

> 
> > +
> > +       base_pfn = hyp_phys_to_pfn(itt_addr);
> > +       num_pages = get_num_itt_pages(its, size);
> > +
> > +       ret = check_table_update(its, device_id, GITS_BASER_TYPE_DEVICE);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return track_pfn(its, base_pfn, num_pages, remove);
> > +}
> > +
> > +static int parse_its_cmdq(struct its_priv_state *its, int offset, ssize_t len)
> > +{
> > +       struct its_cmd_block *cmd = its->cmd_hyp_base + offset;
> > +       u8 req_type;
> > +       int ret = 0;
> > +
> > +       while (len > 0 && !ret) {
> > +               req_type = cmd->raw_cmd[0] & GENMASK(7, 0);
> > +
> > +               switch (req_type) {
> > +               case GITS_CMD_MAPD:
> > +                       ret = process_its_mapd(its, cmd);
> > +                       break;
> > +               }
> > +
> > +               cmd++;
> > +               len -= sizeof(struct its_cmd_block);
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> >  static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
> >  {
> >         u64 cwriter_offset = value & GENMASK(19, 5);
> > @@ -41,11 +218,15 @@ static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
> >                 return;
> >
> >         memcpy(its->cmd_hyp_base + cmd_offset, its->cmd_host_cwriter, cmd_len);
> > +       if (parse_its_cmdq(its, cmd_offset, cmd_len))
> > +               return;
> >
> >         its->cmd_host_cwriter = its->cmd_host_base +
> >                 (cmd_offset + cmd_len) % cmdq_sz;
> >         if (its->cmd_host_cwriter == its->cmd_host_base) {
> >                 memcpy(its->cmd_hyp_base, its->cmd_host_base, cwriter_offset);
> > +               if (parse_its_cmdq(its, cmd_offset, cmd_len))
> > +                       return;
> >
> >                 its->cmd_host_cwriter = its->cmd_host_base + cwriter_offset;
> >         }
> > @@ -357,6 +538,7 @@ int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
> >         priv_state->cmd_hyp_base = kern_hyp_va(shadow->cmd_original);
> >         priv_state->cmd_host_base = kern_hyp_va(shadow->cmd_shadow);
> >         priv_state->cmd_host_cwriter = priv_state->cmd_host_base;
> > +       priv_state->empty_idx = 0;
> >
> >         hyp_spin_unlock(&its_setup_lock);
> >
> > diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> > index 278dbc56f962..be78f7dccb9f 100644
> > --- a/drivers/irqchip/irq-gic-v3-its.c
> > +++ b/drivers/irqchip/irq-gic-v3-its.c
> > @@ -121,8 +121,6 @@ static DEFINE_PER_CPU(struct its_node *, local_4_1_its);
> >  #define is_v4_1(its)           (!!((its)->typer & GITS_TYPER_VMAPP))
> >  #define device_ids(its)                (FIELD_GET(GITS_TYPER_DEVBITS, (its)->typer) + 1)
> >
> > -#define ITS_ITT_ALIGN          SZ_256
> > -
> >  /* The maximum number of VPEID bits supported by VLPI commands */
> >  #define ITS_MAX_VPEID_BITS                                             \
> >         ({                                                              \
> > @@ -515,16 +513,6 @@ struct its_cmd_desc {
> >         };
> >  };
> >
> > -/*
> > - * The ITS command block, which is what the ITS actually parses.
> > - */
> > -struct its_cmd_block {
> > -       union {
> > -               u64     raw_cmd[4];
> > -               __le64  raw_cmd_le[4];
> > -       };
> > -};
> > -
> >  #define ITS_CMD_QUEUE_SZ               SZ_64K
> >  #define ITS_CMD_QUEUE_NR_ENTRIES       (ITS_CMD_QUEUE_SZ / sizeof(struct its_cmd_block))
> >
> > diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> > index 40457a4375d4..4f7d47f3d970 100644
> > --- a/include/linux/irqchip/arm-gic-v3.h
> > +++ b/include/linux/irqchip/arm-gic-v3.h
> > @@ -612,6 +612,8 @@
> >   */
> >  #define GIC_IRQ_TYPE_LPI               0xa110c8ed
> >
> > +#define ITS_ITT_ALIGN                  SZ_256
> > +
> >  struct rdists {
> >         struct {
> >                 raw_spinlock_t  rd_lock;
> > @@ -634,6 +636,16 @@ struct rdists {
> >         bool                    has_vpend_valid_dirty;
> >  };
> >
> > +/*
> > + * The ITS command block, which is what the ITS actually parses.
> > + */
> > +struct its_cmd_block {
> > +       union {
> > +               u64     raw_cmd[4];
> > +               __le64  raw_cmd_le[4];
> > +       };
> > +};
> > +
> >  struct irq_domain;
> >  struct fwnode_handle;
> >  int __init its_lpi_memreserve_init(void);
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
