Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A803F1669
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529138; cv=pass; b=E8tAlifuQPPNcxGwJst+y9RuHYGMR/ga+vC/uGHVdnR0dv1yh22eS1jlX34WAe/RbCdHEGYEYVFinmmpI07nIHDqtPITrLih6Re/fOUnLY/dL2s4lXzWQSYHvj2Run71e9j5252VEbOBN8zEFww+jKLY9zqPtnXAX6DFG0LV8pI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529138; c=relaxed/simple;
	bh=mHsQIC4wwrEe+dGhK+rlnftwIzTOD+l6ul55AVfG8+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PKBWSHjBVCI0k0praKv0PXM+VNWWokBhT6PJdiPe5NNXEpXkugTyiXJEKQ4riHgb9C3k+6TdQf+GkYSgQR/EQVVaq2+riuFRAQ/DdgF+ATmgEZJHpvBg0Y/qEj+j/OAA+a/KZCCauJTs2Z8Ux7Jyn5JmJZ/G5zU+OAhQIN+jlI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSeMFBm5; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSeMFBm5"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177d1ff061so75771cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:12:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781529135; cv=none;
        d=google.com; s=arc-20240605;
        b=lbSgA48kABM7i2Ewy7xyBI4YzfSF8xonj5xhe6dtoMw5KkQAAgD+63HKFI4fjACC6U
         phq7c8atxVppC+p23bGyTQd1tbAF9w0VAfDwpSuScVJoJv8PCktolswXJz3Yv0xrxRxY
         nsByfhNPmQNsL30AlRzrI8ViP7SwbiK2dKcjyrL+cBtQm8qXpAI+9y1PjKqsDx6PFNfi
         ULSWSPxbBxR2NDROPYdTkHa1i9gcIXbH3s3r5h+WmEjIKJ/kYO3Gge0v86nKRiCu3DYK
         vQOLiYaGqCsNZMEWmJJpz2nlxi1SFzeXrrnDNCFnYcBl4l7UQyihV5nOsRkk6RnhtZeC
         GyfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=V9ApFTtIbFndOO5kudQ+mdr96c2vq9dMtY6RicL5Hhg=;
        fh=pQiba2ybNHCajeRXAeJySmKV6z5WtiSQ+dH8qGTYv4I=;
        b=W3Ca1X9kwfPz2cEpMO1hMn696G3m+7fJrh+Gy37Hm6PI9C/HZHNzZKKrCwI8gJz6bW
         4k1/7Fzw67evAdeQQRqIN+CbsXkJpwGQDWcRPhVlhHaAX6vXU+J2VMNBXS1OGWH+tt3/
         QAc8hn05r+qmOmL2CtMixS3aqIfKB6WpMZNfVmQGD5kHu4TH90k2K2k0Yo1KZYIgN/k7
         MNPoGK6zpjI09X0xnktkV2D53cbdslaTL1SmDXEWAtjT/Hul8VW3F1Jf5cuMX2s9jddc
         5nqDPp3JcddDsnJxoQZ5uWnONmd3oBA6APqU6Fx9eUg1O4uUO8Usgix0D71/pxhX44nq
         PkWw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781529135; x=1782133935; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V9ApFTtIbFndOO5kudQ+mdr96c2vq9dMtY6RicL5Hhg=;
        b=VSeMFBm5y8pQ5a0nVTZHNgp82YT1VP5B4WTJTTlXjdqsZSVrphaMK9dBpVq0c0rgup
         lCWltn+yF8qQ5uJLAcWjfAcuBpDu+vJkMsfqKSGJ8aBNiIzmTuAlt3+XjhJkvc6EOE7u
         850ziy4ms0OblYrLnKv4qIOPjwaDU+6P5oRBw0yyuCvsRyS4RFkSVjX9Lcf3RD1oWKWT
         y5CeLspBi/+RFtPOwHEr7QklkGF/AV3aS7YfPq7sfbzKFTX23DXj3RQfGbXTXYN9z3Dr
         I3j0UkUBg7t1WpwYHCRmWzZz+Emn1KmyHuOiXHDcJzvtZZuFSt69PSgcb5fqiBmXLdXK
         860g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529135; x=1782133935;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9ApFTtIbFndOO5kudQ+mdr96c2vq9dMtY6RicL5Hhg=;
        b=Qr4xVCRO6L8hwCr0QYbKdHb6VftRZvFuUudBFPEs0cE4xhZWq++s31IUcr7kII0Vce
         +X9HFhYeIK6BaMwyA/jAYnlt720Zr5lcLP+Dw8WMksmEhw0qMT/EaQy7OSrka7wQpjr7
         Cs3zJ/Th2fWPK+eWnPuUGlfqODJDhkFKDf8f0XZYd/OnjID+RZYtJys73nPkn5FZHO5c
         50C48rUbmBJq6pNNaah6IJ9FijNp6h1o5VGde8M6eVHfqmgOvjN/ssfmc0tYQtFD3nKQ
         5i3WsM8Fi80bZxiHtw3H9XAiymGcU2o4BmzYbDEmT5hf1r5cv/Ij8y4C+8WiSTpMgzOo
         iF7w==
X-Forwarded-Encrypted: i=1; AFNElJ+bbdppyOicitpG3P2EjzBm/3Q6MU8+WZTm9ikJTN6DUPSuYAx6pa0YvV9H3c5ZpHD+d2VEz+Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0oqNnx5xr00NOV/PkCEWu44PmHTWN3aU9Y0paJBEhG8C8Ky9j
	T+eLMewU8PaZHGUWj11qxyKqCWJkwYYSXpRcL6nDLWjP0t80/5kxzR95GNktSTPuo2UZfbMPbKX
	UBpij/4eiX0nhMBR+faoJo76sA7xoyWpgawxyU+Fa
X-Gm-Gg: Acq92OEFrh5a+2E7bbKCADi8yDi7iiC09R3FCwuH/qZxegCOv1s+tXpTKRTo3iACNPW
	ed/UCpDPr9AAX9jwDnDe7wxzhebdThWkyZYZrWs8I1GI4mBk2z1skESB+YATMuMwrdj7djoiv5A
	JMwA1naBDRIoTEI2axTym//F25LItMGYWVETbMDlVOX5eH7OUIgW0QdpBzApfMEhLG2xLmTqHpt
	pi3ubv0dR1QGRVK7Rvy/IFELKis8X6kzqzrCxhZ3NB2pRcB0u5BrjIhDYy+CJ4NVmYrJpRJh/tA
	J/yXMhUBUTOLXRqBq3c=
X-Received: by 2002:a05:622a:5810:b0:516:3def:1cf4 with SMTP id
 d75a77b69052e-519872df3b4mr1903741cf.1.1781529134395; Mon, 15 Jun 2026
 06:12:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-3-tabba@google.com>
 <ai_1z13TyEXbHx4Q@google.com>
In-Reply-To: <ai_1z13TyEXbHx4Q@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 14:11:37 +0100
X-Gm-Features: AVVi8CfeXGRS4qbHoDv1tNV11kQoNJh7W4G-vCO44nFd_V-kW6IwV2WUcVJxP2E
Message-ID: <CA+EHjTw_goANXAuFiDdkcSW4d0xtTJjqO5Q=ySn9F_pHn+ZBJg@mail.gmail.com>
Subject: Re: [PATCH v1 02/11] KVM: arm64: Use guard(hyp_spinlock) in pKVM
 hypervisor code
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Per Larsen <perlarsen@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Mon, 15 Jun 2026 at 13:53, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, Jun 12, 2026 at 07:59:16AM +0100, tabba@google.com wrote:
> > Convert the manual hyp_spin_lock()/hyp_spin_unlock() pairs in
> > arch/arm64/kvm/hyp/nvhe/{pkvm,mm,page_alloc,ffa}.c to
> > guard(hyp_spinlock) and scoped_guard(hyp_spinlock), dropping several
> > unlock-only goto labels in favour of direct returns.
> >
> > hyp_fixblock_lock in mm.c is left as an explicit lock/unlock pair: it is
> > acquired in hyp_fixblock_map() and released in hyp_fixblock_unmap(), so
> > its critical section spans two functions and cannot be expressed as a
> > single lexical scope.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c        | 154 +++++++++++----------------
> >  arch/arm64/kvm/hyp/nvhe/mm.c         |  37 ++-----
> >  arch/arm64/kvm/hyp/nvhe/page_alloc.c |  13 +--
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c       |  86 +++++----------
> >  4 files changed, 105 insertions(+), 185 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1af722771178..46cd4fa924be 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -313,17 +313,16 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
> >                             struct kvm_cpu_context *ctxt)
> >  {
> >       DECLARE_REG(u32, id, ctxt, 1);
> > -     int ret = 0;
> >
> >       if (id != HOST_FFA_ID) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> > -     hyp_spin_lock(&host_buffers.lock);
> > +     guard(hyp_spinlock)(&host_buffers.lock);
> >       if (!host_buffers.tx) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> >       hyp_unpin_shared_mem(host_buffers.tx, host_buffers.tx + 1);
> > @@ -336,10 +335,7 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
> >
> >       ffa_unmap_hyp_buffers();
> >
> > -out_unlock:
> > -     hyp_spin_unlock(&host_buffers.lock);
> > -out:
> > -     ffa_to_smccc_res(res, ret);
> > +     ffa_to_smccc_res(res, 0);
> >  }
> >
> >  static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
> > @@ -418,18 +414,20 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
> >       DECLARE_REG(u32, fraglen, ctxt, 3);
> >       DECLARE_REG(u32, endpoint_id, ctxt, 4);
> >       struct ffa_mem_region_addr_range *buf;
> > -     int ret = FFA_RET_INVALID_PARAMETERS;
> > +     int ret;
> >       u32 nr_ranges;
>
> nit: inverted christmas tree

Ack.

>
> >
> > -     if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
> > -             goto out;
> > +     if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE ||
> > +         fraglen % sizeof(*buf)) {
>
> nit: I don't know if we wouldn't want extra parenthesis here for readability.

Sure, will add parentheses around the second operand.

>
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> > +     }
> >
> > -     if (fraglen % sizeof(*buf))
> > -             goto out;
> > -
> > -     hyp_spin_lock(&host_buffers.lock);
> > -     if (!host_buffers.tx)
> > -             goto out_unlock;
> > +     guard(hyp_spinlock)(&host_buffers.lock);
> > +     if (!host_buffers.tx) {
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> > +     }
> >
> >       buf = hyp_buffers.tx;
> >       memcpy(buf, host_buffers.tx, fraglen);
> > @@ -444,19 +442,14 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
> >                */
> >               ffa_mem_reclaim(res, handle_lo, handle_hi, 0);
> >               WARN_ON(res->a0 != FFA_SUCCESS);
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, ret);
> > +             return;
> >       }
> >
> >       ffa_mem_frag_tx(res, handle_lo, handle_hi, fraglen, endpoint_id);
> >       if (res->a0 != FFA_SUCCESS && res->a0 != FFA_MEM_FRAG_RX)
> >               WARN_ON(ffa_host_unshare_ranges(buf, nr_ranges));
> >
> > -out_unlock:
> > -     hyp_spin_unlock(&host_buffers.lock);
> > -out:
> > -     if (ret)
> > -             ffa_to_smccc_res(res, ret);
> > -
> >       /*
> >        * If for any reason this did not succeed, we're in trouble as we have
> >        * now lost the content of the previous fragments and we can't rollback
> > @@ -465,7 +458,6 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
> >        * sharing/donating them again and may possibly lead to subsequent
> >        * failures, but this will not compromise confidentiality.
> >        */
> > -     return;
> >  }
> >
> >  static void __do_ffa_mem_xfer(const u64 func_id,
> > @@ -480,29 +472,29 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> >       struct ffa_composite_mem_region *reg;
> >       struct ffa_mem_region *buf;
> >       u32 offset, nr_ranges, checked_offset;
> > -     int ret = 0;
> > +     int ret;
> >
> >       if (addr_mbz || npages_mbz || fraglen > len ||
> >           fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> >       if (fraglen < sizeof(struct ffa_mem_region) +
> >                     sizeof(struct ffa_mem_region_attributes)) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> > -     hyp_spin_lock(&host_buffers.lock);
> > +     guard(hyp_spinlock)(&host_buffers.lock);
> >       if (!host_buffers.tx) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> >       if (len > ffa_desc_buf.len) {
> > -             ret = FFA_RET_NO_MEMORY;
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, FFA_RET_NO_MEMORY);
> > +             return;
> >       }
> >
> >       buf = hyp_buffers.tx;
> > @@ -512,53 +504,41 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> >                       ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> >       offset = ep_mem_access->composite_off;
> >       if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> >       if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> >       if (fraglen < checked_offset) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> >       reg = (void *)buf + offset;
> >       nr_ranges = ((void *)buf + fraglen) - (void *)reg->constituents;
> >       if (nr_ranges % sizeof(reg->constituents[0])) {
> > -             ret = FFA_RET_INVALID_PARAMETERS;
> > -             goto out_unlock;
> > +             ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +             return;
> >       }
> >
> >       nr_ranges /= sizeof(reg->constituents[0]);
> >       ret = ffa_host_share_ranges(reg->constituents, nr_ranges);
> > -     if (ret)
> > -             goto out_unlock;
> > +     if (ret) {
> > +             ffa_to_smccc_res(res, ret);
> > +             return;
> > +     }
> >
> >       ffa_mem_xfer(res, func_id, len, fraglen);
> >       if (fraglen != len) {
> > -             if (res->a0 != FFA_MEM_FRAG_RX)
> > -                     goto err_unshare;
> > -
> > -             if (res->a3 != fraglen)
> > -                     goto err_unshare;
> > +             if (res->a0 != FFA_MEM_FRAG_RX || res->a3 != fraglen)
> > +                     WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
> >       } else if (res->a0 != FFA_SUCCESS) {
> > -             goto err_unshare;
> > +             WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
>
> I am not sure this is really better for this function. At least we had a single
> callsite to this WARN_ON(ffa_host_unshare_ranges) ...
>
> Or alternatively if we really want guard() this can just set ret = XXX and then
>
>   if (ret)
>       WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
>
> So we can keep a single call site for the rollback.

Agreed, the single rollback callsite is better. I'll use a flag to
keep the original control flow readable:

>
> >       }
> > -
> > -out_unlock:
> > -     hyp_spin_unlock(&host_buffers.lock);
> > -out:
> > -     if (ret)
> > -             ffa_to_smccc_res(res, ret);
> > -     return;
> > -
> > -err_unshare:
> > -     WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
> > -     goto out_unlock;
> >  }
> >
>
> [...]
>
> >  int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
> > @@ -996,22 +975,19 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
> >       struct kvm *host_kvm;
> >       unsigned int idx;
> >       size_t vm_size;
> > -     int err;
> >
> > -     hyp_spin_lock(&vm_table_lock);
> > -     hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
> > -     if (!hyp_vm || !hyp_vm->kvm.arch.pkvm.is_dying) {
> > -             err = -EINVAL;
> > -             goto err_unlock;
> > +     scoped_guard(hyp_spinlock, &vm_table_lock) {
> > +             hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
> > +             if (!hyp_vm || !hyp_vm->kvm.arch.pkvm.is_dying)
> > +                     return -EINVAL;
> > +
> > +             host_kvm = hyp_vm->host_kvm;
> > +
> > +             /* Ensure the VMID is clean before it can be reallocated */
> > +             __kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
> > +             remove_vm_table_entry(handle);
> >       }
> >
> > -     host_kvm = hyp_vm->host_kvm;
> > -
> > -     /* Ensure the VMID is clean before it can be reallocated */
> > -     __kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
> > -     remove_vm_table_entry(handle);
> > -     hyp_spin_unlock(&vm_table_lock);
> > -
> >       /* Reclaim guest pages (including page-table pages) */
> >       mc = &host_kvm->arch.pkvm.teardown_mc;
> >       stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
> > @@ -1042,10 +1018,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
> >       teardown_donated_memory(mc, hyp_vm, vm_size);
> >       hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
> >       return 0;
> > -
> > -err_unlock:
> > -     hyp_spin_unlock(&vm_table_lock);
> > -     return err;
>
> For this one too I doubt this is really interesting: only one path using
> err_unlock and actually the entire label could be just removed to to simply do
> hyp_spin_unlock() return -EINVAL;
>
> This would avoid adding another tab with that scoped_guard(). But that's
> probably my aversion to scoped_guard() talking.

The scoped_guard makes the lock scope visually explicit here: the
lock must be dropped before the long teardown tail that follows, and
scoped_guard makes that boundary clear. It also prevents forgetting
the unlock on the early return. I think the extra tab is worth it for the
clarity it provides.

Thanks,
/fuad


>
> >  }
> >
> >  static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
