Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AAD3BBFCE
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478007; cv=none; b=tXJEzbTUePpUky0Zog9pLP3d4zyG0uG+bcr5xBf8hcq2Q4ylUm1hPVmYitoM+p07CiQeuywlKbEnH9085D5bh7ZlVCZV4C4CUDyRpjpc5DY8QRwg3P1v/2C8c1OhO4wx1sw1D8WSrjGWrtMmkPuHiLzBTKpy5rylvLeN0hZ86Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478007; c=relaxed/simple;
	bh=sxgCcXsVUgd/NZQaj7eoMIiwtZuGOSGHsbhHSkNY9/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WbzjHrJq7LFrFSL91J765iA1KQVjwigXj7Behfaj7H3JXI7+cCkxmU5t4pKbQ15vUBitpaUXiD4t6BNCVbBOo171In6HMu0N2DZLB/PDYPuYYETf8DH2ECafZn5qtxgHT9RIfDe7Zh2jj87DsWwL+avvC9yaM40NIBjEW4FJA2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AgKqjuJp; arc=none smtp.client-ip=91.218.175.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AgKqjuJp"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sxgCcXsVUgd/NZQaj7eoMIiwtZuGOSGHsbhHSkNY9/Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789478003; v=1; x=1790082803;
 b=AgKqjuJp+ugdldX+QGlrYnmEuztbSQarp+vTf7ORWT8RTUkg70IRukuHe7f7e76dMTeWkkJW
 iWY0L6boHzjKWjVrCsGFSzGEX6z3oFqMo52Nsm70qgP8MiOmb9OW4+4pivUE0pubONgoDszyzMu
 SOd1uGDCsoLZy78GA6q+Hzcg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 107d255d2d3c9967;
	Tue, 15 Sep 2026 13:13:23 +0000
X-Mizu-Trace-ID: 107d255d2d3c9967
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so628e87.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 06:13:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxSIN76+cwdWkCAElaiQd4kukNYz0rsNB7+TkkOQc1RxN0c5HGTG5mMWOeX7ebCx5Iit+EbHMU=@lists.linux.dev
X-Gm-Message-State: AFuF++kZuLI4vHZXxwrMvJ5Jv+KiGO+AcA7YB/9u10oIa8uOk81F2LOt
	CLgO3l7yRIbPwVs70CCtwUraj4BxsmbdNm145zOjioOUWYni/a5WAi7mb4qU82WbK8Vr7LNh/zo
	4URvGhL+2IPBnk4sji+3kRic81If5eMlgSJZQt+KK
X-Received: by 2002:a05:6512:3b0f:b0:5b2:a967:c0c9 with SMTP id
 2adb3069b0e04-5b8b31fbc42mr139494e87.7.1789478001771; Tue, 15 Sep 2026
 06:13:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com> <20260807164322.2970811-7-sebastianene@google.com>
In-Reply-To: <20260807164322.2970811-7-sebastianene@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 14:12:45 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw84p44gZ=qGJq1M7FAg47uJkDMZxxebHx79fzcsETA7w@mail.gmail.com>
X-Gm-Features: AcwNN1U5YrLQgZHFUd0Pkt0i-x1LoJbyUs7P4djhMll5Y6K5gu4LvMmdOU3oihM
Message-ID: <CA+EHjTw84p44gZ=qGJq1M7FAg47uJkDMZxxebHx79fzcsETA7w@mail.gmail.com>
Subject: Re: [PATCH v2 05/13] irqchip/gic-v3-its: Add support for the ITS
 emulation setup
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org, 
	kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, seiden@linux.ibm.com, 
	smostafa@google.com, tglx@kernel.org, vdonnefort@google.com, 
	vladimir.murzin@arm.com, yuzenghui@huawei.com, zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Seb,

On Fri, 7 Aug 2026 at 17:43, Sebastian Ene <sebastianene@google.com> wrote:
>
> Introduce two new helper functions to allow locking the ITS and setting
> up a copy of the host ITS state that will be given to the pKVM
> emulation. The caller of these functions is responsible to implement a
> callback which will be used to setup the emulation layer. The calling
> flow is expected to do the following:
>
> pkvm_its_emulate_setup(its_phys, host)
>         // allocate memory for the priv state of the ITS emulation
>         // call the its emulation setup(its_phys, host, priv_state);
>
> pkvm_drop_host_privileges()
>         its_emulate_acquire_locks(&flags);
>                 on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
>         its_emulate_release_locks(ret, &flags, pkvm_its_emulate_setup);
>
> Augment the its_baser structure with a new fiels that will hold a
> pointer to the base table copy. The gic ITS driver will use the pointer
> to the base table copy when emulation is enabled, as this allows us to
> hide away the original first level of an indirect table to prevent the
> following:
>
> // assumming an indirect Device Table layout
> 1. malicious host patches an entry in the 1st level table with an
>    address that it wants to write to.
> 2. malicious host issues MAPD to install a DTE in the table pointed by
>    the address from (1).
>
> As the driver only manipulates a copy of the table, the emulation is
> responsible for looking at the updates from the copy table, sanitizing
> them and updating the original table before talking to the hardware.
>
> In a simillar fashion, when emulation is in place we no longer let the
> gic ITS driver use the original command queue but we present the driver
> a copy of it and we hide away the original command queue from the driver
> as this will be used entirely by the emulation layer.
>
> Co-authored-by: Bart=C5=82omiej Grzesik <bgrzesik@google.com>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

A few typos, "fiels" and "simillar" here, "innaccessible" and
"assumming" further down.

Missing SoB.


> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 157 +++++++++++++++++++++++++++--
>  include/linux/irqchip/arm-gic-v3.h |  39 +++++++
>  2 files changed, 185 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v=
3-its.c
> index 6f5811aae59c..e74ae9220af5 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -78,17 +78,6 @@ struct its_collection {
>         u16                     col_id;
>  };
>
> -/*
> - * The ITS_BASER structure - contains memory information, cached
> - * value of BASER register configuration and ITS page size.
> - */
> -struct its_baser {
> -       void            *base;
> -       u64             val;
> -       u32             order;
> -       u32             psz;
> -};
> -
>  struct its_device;
>
>  /*
> @@ -5226,6 +5215,152 @@ static int __init its_compute_its_list_map(struct=
 its_node *its)
>         return its_number;
>  }
>
> +static void its_free_snapshot(struct its_host_state *snapshot)
> +{
> +       int i;
> +
> +       if (snapshot->cmd_host_copy)
> +               its_free_pages(snapshot->cmd_host_copy, get_order(ITS_CMD=
_QUEUE_SZ));
> +
> +       for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
> +               if (!snapshot->tables[i].base_snapshot)
> +                       continue;
> +
> +               its_free_pages(snapshot->tables[i].base_snapshot, snapsho=
t->tables[i].order);
> +       }
> +
> +       its_free_pages(snapshot, 0);
> +}
> +
> +static struct its_host_state *its_snapshot_host_state(struct its_node *i=
ts)
> +{
> +       void *page;
> +       struct its_host_state *snapshot;
> +       int i;
> +
> +       page =3D its_alloc_pages_node(its->numa_node, GFP_ATOMIC | __GFP_=
ZERO, 0);
> +       if (!page)
> +               return NULL;
> +
> +       snapshot =3D (void *)page_address(page);
> +       page =3D its_alloc_pages_node(its->numa_node, GFP_ATOMIC | __GFP_=
ZERO,
> +                                   get_order(ITS_CMD_QUEUE_SZ));

Once its_emulate_release_locks() has a caller, all of these run under
its_lock and every its->lock with interrupts off. Could the buffers be
allocated before the locks are taken, leaving only the copies under
them? (Sashiko is trying to say the same thing I think)

...
> +static int its_emulate_switch_queues_locked(struct its_node *its, its_em=
ulate_setup cb)
> +{
...
> +               baser_phys =3D virt_to_phys(host.tables[i].base_snapshot)=
;
> +               if (IS_ENABLED(CONFIG_ARM64_64K_PAGES) && (baser_phys >> =
48))
> +                       baser_phys =3D GITS_BASER_PHYS_52_to_48(baser_phy=
s);

its_setup_baser() has a third condition here: it fails unless psz is
SZ_64K, since 52-bit PA needs a 64K page size. This converts at any
page size, and psz is in host.tables[i].psz. Could that check come
too?

Also "host_snaphsot" in this function.

> +
> +               its->tables[i].val &=3D ~GENMASK(47, 12);
> +               its->tables[i].val |=3D baser_phys;
> +               its->tables[i].base =3D host.tables[i].base_snapshot;
> +       }
> +
> +       return 0;
> +}
> +
> +void its_emulate_acquire_locks(unsigned long *flags)
> +{
> +       struct its_node *its;
> +
> +       if (WARN_ON(!flags))
> +               return;
> +
> +       raw_spin_lock_irqsave(&its_lock, *flags);
> +
> +       list_for_each_entry(its, &its_nodes, entry)
> +               raw_spin_lock(&its->lock);

pkvm_drop_host_privileges() runs on_each_cpu() inside this section, so
the IPI goes out with interrupts off and lockdep_assert_irqs_enabled()
in smp_call_function_many_cond() fires on a PROVE_LOCKING build.

Moving the locks isn't free, though: priv is only set by the setup
hypercall after the IPI, and the handler drops every ITS access until
then. Would running the setup before the stage-2 install work, or
forwarding on a NULL priv?

> +}
> +
> +int its_emulate_release_locks(int ret_pkvm_finalize, unsigned long *flag=
s, its_emulate_setup cb)
> +{
> +       struct its_node *its;
> +       int ret =3D 0;
> +
> +       if (WARN_ON(!flags || !cb))
> +               ret =3D -EINVAL;

The acquire returns with no locks held, and the release then unlocks
them anyway and reads *flags. The only caller passes &its_flags, so
could both go?

> +
> +       list_for_each_entry(its, &its_nodes, entry) {
> +               if (!ret_pkvm_finalize && !ret)
> +                       ret =3D its_emulate_switch_queues_locked(its, cb)=
;
> +
> +               raw_spin_unlock(&its->lock);
> +       }
> +
> +       raw_spin_unlock_irqrestore(&its_lock, *flags);
> +
> +       return ret;
> +}
> +
>  static int __init its_probe_one(struct its_node *its)
>  {
>         u64 baser, tmp;
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/a=
rm-gic-v3.h
> index ea5fd2374ebe..b75f82cef4bf 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -657,6 +657,45 @@ static inline bool gic_enable_sre(void)
>         return !!(val & ICC_SRE_EL1_SRE);
>  }
>
> +/*
> + * The ITS_BASER structure - contains memory information, cached
> + * value of BASER register configuration and ITS page size.
> + */
> +struct its_baser {
> +       void            *base;
> +
> +       /*
> +        * The table used when emulation is in place and indirect layout =
is
> +        * configured.
> +        */
> +       void            *base_snapshot;
> +       u64             val;
> +       u32             order;
> +       u32             psz;
> +};
> +
> +struct its_host_state {
> +       struct its_baser        tables[GITS_BASER_NR_REGS];
> +
> +       /* The command queue used after the emulation is in place */
> +       void                    *cmd_host_copy;
> +
> +       /* The command queue configured by the ITS driver at boot */
> +       void                    *cmd_original;
> +       void                    *cmd_write;
> +       size_t                  cmdq_len;
> +};

struct its_baser was private to irq-gic-v3-its.c. Would it be better
for these to have their own header?

Cheers,
/fuad


> +/*
> + * Callback used to initialize the emulation. It is expected to allocate=
 memory for the private
> + * state of the emulation and receive as arguments copy of the host ITS =
driver state along
> + * with the address of the ITS.
> + */
> +typedef int (*its_emulate_setup)(phys_addr_t its_phys_base, struct its_h=
ost_state *host);
> +
> +void its_emulate_acquire_locks(unsigned long *flags);
> +int its_emulate_release_locks(int ret_pkvm_finalize, unsigned long *flag=
s, its_emulate_setup cb);
> +
>  #endif
>
>  #endif
> --
> 2.55.0.654.g21b8a5bc05-goog
>
