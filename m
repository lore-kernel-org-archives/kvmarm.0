Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB8837186D
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 09:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773740471; cv=pass; b=a4boc7bPVtTJjA4lcd8UlzZ4QYxrsYW3smDcjn9CAyiBlmNTCgKFHNBgxxDBvUECFCHH0bCymcrjrcR75TlCwL1E8uioZxelW9qIhsY+dKVC1sj/wliq/Rml1dgWKCtPv1/XqnJBLXF1i8FLvePGW1tLBo8BVLxMqMgo+dtwlIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773740471; c=relaxed/simple;
	bh=PFc+rTykPMkrv9A8jrXiuBq/3V+EkryA3AmXGTl+Ij4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qIZpEhxGIYTGUsfkrY2BP+TgqoOr2divU40DSPc3ivCOtq0Rvp4k+L4viC3XLMePXbyFrXv9QyVE9S1FQkznRqVetLaziHJnHD7DJ7zrRuksrloBS9E5F7Y3tmAzEbzoVcPTWtznI/Wgvs0skReu3P2j8lt9ldCaZneYfVfBGls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sab1/Llh; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sab1/Llh"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509069a7a7fso453111cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 02:41:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773740469; cv=none;
        d=google.com; s=arc-20240605;
        b=HcEARyItZVH1MsDjSBfoS6/C+BTE43vfxa9GpxsZcTrnc+70XelNp7+h39wPm7Qet7
         ysb85HZNRvSe8WUsmSUy9s+TirovSOWK6UmK7PVhPL251jKnsoVlmPXevWxOMxE2kjt1
         /93G6V1ewv2yumn6EAaqXc3CKl1eh1SV8RxEOKr9MWE6OBYycdxQDeQlVIoFfhuQiGWt
         LIFlARpgtYdqOThCdQ2cl6dwqZXTaHt5HQIcXHINnsXGqnEV/6CNHv0zph1YYw5lW24/
         jkY104SGAF3WiR3JyQNDEARe34gXsRLUo9taG2kF4Lxl9lX22asmCfSpCnp6E75yuH4Z
         ltzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bS9PfKBXOW6fmCX329/wY4OzoCDVjo1e2iZiSr+iZ4Y=;
        fh=LS/kqkAGp7gJmw6SJIshm3EyZy8ObcWzn7KQlQx/Zko=;
        b=kn5iSsPqvLmkPK56opCXyo0Dh07k/f5R/O5vLXmu3Fg9r9edTE011Phbln8fwDSe+8
         rOB9hZKReA6P9S5u71VaLI3kO5KUqTx4F+RQZ/sy9wbt2pe6fVYRl566v7ZD/7LZb4p1
         7jwyD94aKkq1fkra5sg/x3FDzQTJdTXKDs7QrbJeEt9ptlAyzVg8Y8eMfpAQtPE1exVv
         4t553kb8FoUR9icxRWdGTWPqB8Kv8IYuJ5eEOgUqiGSdFtd3ebYPWmTxfczRK3/YJx0U
         FKzkOkHMH9AqE9RJpof9sdACm/VbMSa8EgsUE1f5zDPxIrt0JeLXnh9mfPnY89Q7RvBq
         /gDQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773740469; x=1774345269; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bS9PfKBXOW6fmCX329/wY4OzoCDVjo1e2iZiSr+iZ4Y=;
        b=Sab1/LlhD3rvXZ/L2yO5qbVC7ZC30eboERshDTHJBhYCM1WpFsUkC2e+Sfc7qwy6cE
         O7Eg1I0tVFfj6cz95yyDnbtUujUaAjJ1uSSWnlWgqu9FcBPupHcGlG1U7kb2g9Vo3AMC
         MxHIJ+ZlZ+EWyXaLFgOioMfmiHo0sBRP/pVU8bbM3x5hbWqZPIOzkpGP4fG26X/DaN6H
         ubGQML7PgcyqQkMk7frU4i1QgB/JlQid/MCr/kGPY13O4GAmPrI/a2VsSJEp2MnKpB8W
         kao8YcDEPbjmrILF1eDOzR4bBD9Ba1n9XbkhBXk8Ox0qBvFCCYpPZxv70bIVavC7fp3u
         1/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773740469; x=1774345269;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bS9PfKBXOW6fmCX329/wY4OzoCDVjo1e2iZiSr+iZ4Y=;
        b=h9IrV863MFkHIL15SnP2Zb+xI/xoQK1OFvVogIOYjmgG/CVnhZhlVMQUV7Nwn0BsJ0
         tp2rxJbnP6HBq7nuVlSkWEEgXdK3TgRAux7U+ALEbVKsxMVNjzIgub6kWElTlzKipyHb
         lBEkfD6zl40AZQl0D9w3061KxyDzlDok/AwroG7Pw6gZ60flJ94EbPR5B4+q/Cy5CEHU
         XmmD0hoMEa/K/P0a4tGUW+dA6SaedSHfjEUSA35IFlXLA+9TJaiOP3KdNcXmaLt8Dh0/
         LbIfOK1im5gZxSlKwJyDVh5rXKdLSYleKqNLgdQBip7mk5vpS63sUQnD60mCoyhwDneT
         8rBA==
X-Forwarded-Encrypted: i=1; AJvYcCXn+q2TX+eEcHwGmhnUJiYWaobGn3Iliax2wmUMlCkbpND5XY5W1yBKXKUOrcQrOJOQJHv4wTQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUHwem5M+Q5UIwxqleOff4XB7QeANlx0xlUT5Ddrinkzev/Juk
	RUA52RcK6DfSmpmLCN+vMxjn9vPIqIXpzPwjdz6P1xXKfxizZjQryaulGY9t7wGlR6LLpqVxGVX
	u6x8sWHkvsG/VShvpL9Bq1jHqOtHdpVNpqMxiWAtZ
X-Gm-Gg: ATEYQzxIbAA+mqwy0bERDiKem+3S2UxTPd5S2SjnwVgUg61w7FPlnmeN6UVVa8xdrSP
	grwe/xzoJzSo62AtSHL8w7amMnPmXgdTWyn0ebB01V96E+2DmdsP6ohGQYSMjZAM7beY5AeVLEz
	o5+VH+dxHBo2BT4vGV2Fi8e+Kk9ztJ0xvv86AVL+BPOAEOLwyHpqe7d2B5Kb/eI76/0cveDzD+a
	DX7bOllO+xUYnUnMoSUNalEOMcxxa6pLIvHTPQiybkRqsuq54SktwvF20ayHY5175pMQK9eNaIV
	8N3gnTfS6wDySZS7vcemX1ViyfD9kAwdgHVz
X-Received: by 2002:a05:622a:144f:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-5099ae2a155mr9844921cf.5.1773740468577; Tue, 17 Mar 2026
 02:41:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-7-sebastianene@google.com> <CA+EHjTy051kjdReuESmk3HpMsBEW=s3DxhJXa8vQJFHz--wG2Q@mail.gmail.com>
In-Reply-To: <CA+EHjTy051kjdReuESmk3HpMsBEW=s3DxhJXa8vQJFHz--wG2Q@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 09:40:31 +0000
X-Gm-Features: AaiRm53KBgHC5d-Zqr_jX-4sHKW6VtW6A9pR3Ss9SaBCLcjNk9OzLbJJ4fUt1VA
Message-ID: <CA+EHjTxLAvMQR_6eiPRA-8HuoOHmEpY99TFf6TheUf0hYf1uhQ@mail.gmail.com>
Subject: Re: [PATCH 06/14] KVM: arm64: Add infrastructure for ITS emulation setup
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

On Mon, 16 Mar 2026 at 10:46, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Sebastian,
>
> On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
> >
> > Share the host command queue with the hypervisor. Donate
> > the original command queue memory to the hypervisor to ensure
> > host exclusion and trap accesses on GITS_CWRITE register.
>
> GITS_CWRITE -> GITS_CWRITER
>
> > On a CWRITER write, the hypervisor copies commands from the
> > host's queue to the protected queue before updating the
> > hardware register.
> > This ensures the hypervisor mediates all commands sent to
> > the physical ITS.
>
> This commit message demonstrates why we should be careful about
> naming. This patch series is pretty complex, and having clear and
> consistent naming would help. What I mean is, here you're referring to
> protected vs host queue, earlier you were referring to shadow (which
> now I am not clear if it meant the host version or the hyp version).
> Maybe we could have a discussion about naming, but the most important
> part is consistency.
>
> >
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h             |   1 +
> >  arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  17 ++
> >  arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 203 ++++++++++++++++++
> >  3 files changed, 221 insertions(+)
> >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
> >
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index ef00c1bf7d00..dc5ef2f9ac49 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -28,6 +28,7 @@ struct pkvm_protected_reg {
> >         u64 start_pfn;
> >         size_t num_pages;
> >         pkvm_emulate_handler *cb;
> > +       void *priv;
> >  };
> >
> >  extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h b/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
> > new file mode 100644
> > index 000000000000..6be24c723658
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +
> > +#ifndef __NVHE_ITS_EMULATE_H
> > +#define __NVHE_ITS_EMULATE_H
> > +
> > +
> > +#include <asm/kvm_pkvm.h>
> > +
> > +
> > +struct its_shadow_tables;
> > +
> > +int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *priv_state,
> > +                               struct its_shadow_tables *shadow);
> > +
> > +void pkvm_handle_gic_emulation(struct pkvm_protected_reg *region, u64 offset, bool write,
> > +                              u64 *reg, u8 reg_size);
> > +#endif /* __NVHE_ITS_EMULATE_H */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > index 0eecbb011898..4a3ccc90a1a9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> > @@ -1,8 +1,75 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >
> >  #include <asm/kvm_pkvm.h>
> > +#include <linux/irqchip/arm-gic-v3.h>
> > +#include <nvhe/its_emulate.h>
> >  #include <nvhe/mem_protect.h>
> >
> > +struct its_priv_state {
> > +       void *base;
> > +       void *cmd_hyp_base;
> > +       void *cmd_host_base;
> > +       void *cmd_host_cwriter;
> > +       struct its_shadow_tables *shadow;
> > +       hyp_spinlock_t its_lock;
> > +};
> > +
> > +struct its_handler {
> > +       u64 offset;
> > +       u8 access_size;
> > +       void (*write)(struct its_priv_state *its, u64 offset, u64 value);
> > +       void (*read)(struct its_priv_state *its, u64 offset, u64 *read);
> > +};
> > +
> > +DEFINE_HYP_SPINLOCK(its_setup_lock);
> > +
> > +static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
> > +{
> > +       u64 cwriter_offset = value & GENMASK(19, 5);
> > +       int cmd_len, cmd_offset;
> > +       size_t cmdq_sz = its->shadow->cmdq_len;
>
> Prefer RCT declaration order.
>
> > +
> > +       if (cwriter_offset > cmdq_sz)
> > +               return;
>
> Off-by-one:
> +       if (cwriter_offset >= cmdq_sz)
>
> > +
> > +       cmd_offset = its->cmd_host_cwriter - its->cmd_host_base;
> > +       cmd_len = cwriter_offset - cmd_offset;
> > +       if (cmd_len < 0)
> > +               cmd_len = cmdq_sz - cmd_offset;
>
> This relies on unsigned underflow. cwriter_offset is u64. If
> cmd_offset > cwriter_offset, the result is a massive positive u64
> (e.g., 0xFFFFFFF...). This works but relies on implementation-defined
> behavior and is fragile. UBSAN might flag this, and if someone comes
> along and "cleans up" the variables by changing cmd_len and cmd_offset
> to size_t (unsigned 64-bit), which is the correct type for buffer
> lengths, cmd_len < 0 will never be true. It's better to explicitly
> handle the wrap-around using safe unsigned logic (which is the
> idiomatic way of doing it):
>
> +       size_t cwriter_offset = value & GENMASK(19, 5);
> +       size_t cmd_len, cmd_offset;
> ...
> +       if (cwriter_offset >= cmd_offset)
> +              cmd_len = cwriter_offset - cmd_offset;
> +       else
> +              cmd_len = cmdq_sz - cmd_offset;

Will Deacon pointed out that I'm wrong about this (offline): the Linux
kernel relies on compiler guarantees for 2's complement architectures:
the value is truncated to the lower 32 bits. That said, the code I
suggested above is clearer and more idiomatic.

Cheers,
/fuad


>
> Also, cwriter_offset should be validated to ensure it is 32-byte
> aligned, as the ITS commands are fixed-size packets.
>
> > +
> > +       if (cmd_offset + cmd_len > cmdq_sz)
> > +               return;
> > +
> > +       memcpy(its->cmd_hyp_base + cmd_offset, its->cmd_host_cwriter, cmd_len);
>
> I think we need a memory barrier (e.g., dsb(ishst)) after the memcpy
> to ensure the writes are visible to the hardware before ringing the
> GITS_CWRITER doorbell.
>
> > +
> > +       its->cmd_host_cwriter = its->cmd_host_base +
> > +               (cmd_offset + cmd_len) % cmdq_sz;
> > +       if (its->cmd_host_cwriter == its->cmd_host_base) {
> > +               memcpy(its->cmd_hyp_base, its->cmd_host_base, cwriter_offset);
> > +
> > +               its->cmd_host_cwriter = its->cmd_host_base + cwriter_offset;
> > +       }
> > +
> > +       writeq_relaxed(value, its->base + GITS_CWRITER);
>
> You should sanitize this to
>
>  +       writeq_relaxed(value & GENMASK(19, 5), its->base + GITS_CWRITER);
>
> because value contains the raw 64-bit value written by the host. While
> you extracted the offset correctly using GENMASK(19, 5), you are
> forwarding the raw value (including any garbage in the RES0 bits) to
> the physical hardware.
>
> > +}
> > +
> > +static void cwriter_read(struct its_priv_state *its, u64 offset, u64 *read)
> > +{
> > +       *read = readq_relaxed(its->base + GITS_CWRITER);
> > +}
> > +
> > +#define ITS_HANDLER(off, sz, write_cb, read_cb)        \
> > +{                                                      \
> > +       .offset = (off),                                \
> > +       .access_size = (sz),                            \
> > +       .write = (write_cb),                            \
> > +       .read = (read_cb),                              \
> > +}
> > +
> > +static struct its_handler its_handlers[] = {
> > +       ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
> > +       {},
> > +};
> >
> >  void pkvm_handle_forward_req(struct pkvm_protected_reg *region, u64 offset, bool write,
> >                              u64 *reg, u8 reg_size)
> > @@ -21,3 +88,139 @@ void pkvm_handle_forward_req(struct pkvm_protected_reg *region, u64 offset, bool
> >                         writeq_relaxed(*reg, addr);
> >         }
> >  }
> > +
> > +void pkvm_handle_gic_emulation(struct pkvm_protected_reg *region, u64 offset, bool write,
> > +                              u64 *reg, u8 reg_size)
> > +{
> > +       struct its_priv_state *its_priv = region->priv;
>
> Due to arm64's  memory model, you must use
> smp_load_acquire(&region->priv) here to guarantee the struct fields
> (base, shadow, etc.) are fully visible before dereferencing them.
>
> (and a similar issue later on below... I'll point it out)
>
> > +       void __iomem *addr;
> > +       struct its_handler *reg_handler;
>
> Prefer RCT declaration order.
>
>
> > +
> > +       if (!its_priv)
> > +               return;
>
> This breaks bisectability. In this patch, you redirect the MMIO trap
> to pkvm_handle_gic_emulation, but the setup HVC
> (pkvm_init_gic_its_emulation) isn't called until a later patch.
> Therefore, its_priv is always NULL here, causing all host ITS accesses
> to be silently dropped. The device appears dead.
>
>  You must fall back to the passthrough handler if emulation is not yet
> initialized:
> +       if (!its_priv) {
> +               pkvm_handle_forward_req(region, offset, write, reg, reg_size);
> +               return;
> +       }
>
> at least until you setup the hvc...
>
> > +
> > +       addr = its_priv->base + offset;
> > +       for (reg_handler = its_handlers; reg_handler->access_size; reg_handler++) {
> > +               if (reg_handler->offset > offset ||
> > +                   reg_handler->offset + reg_handler->access_size <= offset)
> > +                       continue;
> > +
> > +               if (reg_handler->access_size & (reg_size - 1))
> > +                       continue;
>
> Is this deliberate? If access_size is 8 and reg_size is 4, 8 & 3 == 0,
> so it continues and allows the 8-byte handler to process a 4-byte
> write. Use explicit length matching (reg_handler->access_size !=
> reg_size), but there's more later...
>
> > +
> > +               if (write && reg_handler->write) {
> > +                       hyp_spin_lock(&its_priv->its_lock);
> > +                       reg_handler->write(its_priv, offset, *reg);
>
> The GIC specification requires support for 32-bit accesses to all
> GITS_* registers. If the host executes a 32-bit write, *reg contains
> only the 32-bit value. However, you do not pass reg_size to
> cwriter_write. The handler assumes it is a full 64-bit value, which
> will corrupt the other half of the emulated register with zeros. You
> need to implement Read-Modify-Write logic for sub-register accesses.
>
> > +                       hyp_spin_unlock(&its_priv->its_lock);
> > +                       return;
> > +               }
> > +
> > +               if (!write && reg_handler->read) {
> > +                       hyp_spin_lock(&its_priv->its_lock);
> > +                       reg_handler->read(its_priv, offset, reg);
> > +                       hyp_spin_unlock(&its_priv->its_lock);
> > +                       return;
> > +               }
> > +
> > +               return;
> > +       }
> > +
> > +       pkvm_handle_forward_req(region, offset, write, reg, reg_size);
> > +}
> > +
> > +static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
> > +{
> > +       int i;
> > +       u64 dev_pfn = dev_addr >> PAGE_SHIFT;
>
> Please prefer RCT.
>
> > +
> > +       for (i = 0; i < PKVM_PROTECTED_REGS_NUM; i++) {
> > +               if (pkvm_protected_regs[i].start_pfn == dev_pfn)
> > +                       return &pkvm_protected_regs[i];
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> > +static int pkvm_setup_its_shadow_cmdq(struct its_shadow_tables *shadow)
> > +{
> > +       int ret, i, num_pages;
> > +       u64 shadow_start_pfn, original_start_pfn;
> > +       void *cmd_shadow_va = kern_hyp_va(shadow->cmd_shadow);
>
> Please prefer RCT. There are multiple variables declared on a single
> line (int ret, i, num_pages;). Please untangle.
>
> > +
> > +       shadow_start_pfn = hyp_virt_to_pfn(cmd_shadow_va);
> > +       original_start_pfn = hyp_virt_to_pfn(kern_hyp_va(shadow->cmd_original));
> > +       num_pages = shadow->cmdq_len >> PAGE_SHIFT;
> > +
> > +       for (i = 0; i < num_pages; i++) {
> > +               ret = __pkvm_host_share_hyp(shadow_start_pfn + i);
> > +               if (ret)
> > +                       goto unshare_shadow;
> > +       }
> > +
> > +       ret = hyp_pin_shared_mem(cmd_shadow_va, cmd_shadow_va + shadow->cmdq_len);
> > +       if (ret)
> > +               goto unshare_shadow;
> > +
> > +       ret = __pkvm_host_donate_hyp(original_start_pfn, num_pages);
> > +       if (ret)
> > +               goto unpin_shadow;
> > +
> > +       return ret;
> > +
> > +unpin_shadow:
> > +       hyp_unpin_shared_mem(cmd_shadow_va, cmd_shadow_va + shadow->cmdq_len);
> > +
> > +unshare_shadow:
> > +       for (i = i - 1; i >= 0; i--)
>
> Please use the standard while (i--) idiom for cleaner rollback loops.
>
> > +               __pkvm_host_unshare_hyp(shadow_start_pfn + i);
> > +
> > +       return ret;
> > +}
> > +
> > +int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
> > +                               struct its_shadow_tables *host_shadow)
> > +{
> > +       int ret;
> > +       struct its_priv_state *priv_state = kern_hyp_va(host_priv_state);
> > +       struct its_shadow_tables *shadow = kern_hyp_va(host_shadow);
> > +       struct pkvm_protected_reg *its_reg;
> > +
> > +       hyp_spin_lock(&its_setup_lock);
>
> You're not releasing this lock on any of the error paths. Please add
> err_unlock and goto err_unlock to release the spinlock.
>
> > +       its_reg = get_region(dev_addr);
> > +       if (!its_reg)
> > +               return -ENODEV;
> > +
> > +       if (its_reg->priv)
> > +               return -EOPNOTSUPP;
>
> I think you need to add a check:
>
> +       if (!PAGE_ALIGNED(priv_state) || !PAGE_ALIGNED(shadow))
> +              return -EINVAL;
>
> since __pkvm_host_donate_hyp() expects page-aligned addresses.
>
> > +       ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(priv_state), 1);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(shadow), 1);
> > +       if (ret)
> > +               goto err_with_state;
> > +
> > +       ret = pkvm_setup_its_shadow_cmdq(shadow);
> > +       if (ret)
> > +               goto err_with_shadow;
> > +
> > +       its_reg->priv = priv_state;
>
> Related to above, please use smp_store_release(&its_reg->priv,
> priv_state); to prevent the compiler and CPU from reordering the
> struct initialization below this pointer assignment, which would
> expose uninitialized memory to the lockless reader in the trap
> handler.
>
> Cheers,
> /fuad
>
>
>
>
> > +
> > +       hyp_spin_lock_init(&priv_state->its_lock);
> > +       priv_state->shadow = shadow;
> > +       priv_state->base = __hyp_va(dev_addr);
> > +
> > +       priv_state->cmd_hyp_base = kern_hyp_va(shadow->cmd_original);
> > +       priv_state->cmd_host_base = kern_hyp_va(shadow->cmd_shadow);
> > +       priv_state->cmd_host_cwriter = priv_state->cmd_host_base;
> > +
> > +       hyp_spin_unlock(&its_setup_lock);
> > +
> > +       return 0;
> > +err_with_shadow:
> > +       __pkvm_hyp_donate_host(hyp_virt_to_pfn(shadow), 1);
> > +err_with_state:
> > +       __pkvm_hyp_donate_host(hyp_virt_to_pfn(priv_state), 1);
> > +       return ret;
> > +}
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
