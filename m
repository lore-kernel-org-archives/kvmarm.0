Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489327;
	b=gKjrVTcRBAOAd4S/LNR1mOLvYfUJQzSTzrj7w2npgNutsCSz0r4EqqWVdRO8MzmaVs6D
	 VPEO/xjaamVq85EbEJVPuXham8n9RALkrC3K5yxbnLNvmfU9VvzbBs0c48ibM2n8cs7Hp
	 cwezNKxInMeXNY3jwheK15xba5ZGpLnaxZtjwqt5ORUN0cLyfx020/VW0SAwiUdcPSZwT
	 IqKhVq1PPSPoPFe9lomTTjgHNbO1oxvbrWc2Ncb9UECkor4Rq6Df2Uxz6s7Jpbmfk0UwE
	 sg9pAxlys+9Wbubjk2s3Xf2Eo4AIbA/85reHqGdmhZC24Y3zIR9NZUMkMH0VS0Sypqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489327;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=e7CPF5orTIvftcTO8Leab/fUE5tFTHho+53fmzbA+Yw=;
	b=ScycxMzTy168wRVpjOvNdYEcXcgaC3CmMueRyMmRPnvRnecWvlHJ8c4vUD51Fg/jZ63M
	 QR99IDxpwb1X5ElPu3F1Eipg12iBDjbns1fgD0qDF9E0ZkXJAxoAsc4mzt99Wl18NiUhG
	 H2xXKs3cMRx/c19D4G4ny7E6QlWzlYA13RjlMaTm7Mhd+wTECaZ1m0Yj1C5Vx0xIe2/Pg
	 wQ/mpekF/ZXMr9Ld5EiLLqp+zHkzyF3+YZ+gUua+RLqyOsHAttyKdAYY/m9EpvMk5xIne
	 2GzTl+VPMYp0v6NZC2o7whZjl6/K8Eloz5FsLWOpUvsCb5QnRJ7fn+AgVNis7mdQ2pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lfr9DOuy;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825AC606A327
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 13:15:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 825AC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lfr9DOuy
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4910b863b84so561346f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 05:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794489326; x=1795094126; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e7CPF5orTIvftcTO8Leab/fUE5tFTHho+53fmzbA+Yw=;
        b=lfr9DOuyZWmv5Ssus+lxnBlJ5IRb34UhjM0HGOXuqnDqXM10ISr796MkpvqwN7yP0X
         ZPbsV1LZIE5ax0IszTR3mcHYxOFgh90JiPmG0RHZIq58jg2Y/JBEwQAH9xtMfJCmF99T
         9lz7/FpftdpIQzdCKSaO7n2bKDfssIevck10lvds8oGK7CsLu3UvqKLbXZDv9QEH46xK
         qWasSzIsFuWdBCyMTL1OkMuJnfpq+jNA1eKVEroTPzD83iIdsyezqsm5UQU4AyQIeEgF
         4HU9KcX+OR6Zg8tZIUs9GNcFww+DuRVAMPw5MN1RNJcd/RJBxaVurwZyeQnIFqZzsefP
         yT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489326; x=1795094126;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e7CPF5orTIvftcTO8Leab/fUE5tFTHho+53fmzbA+Yw=;
        b=e2uubwEe+5WqS2TXJX22UQzq4W3+9LEpF8N/prXgL/lRtuAeBqoRZT2Mk3nCDHUGtI
         MCrXqyGTcxBfo8E3deqfEyHqaQ5M4Rg5cOWGUD2fHSdGzgdpMFVMp0hoRt7FTpPJRSzp
         TrefoPr0LBuo/PRYYXdHu4Nq577F7yjNaEFyAPkeb8z9NLnG7fvf+RMA+WY4KKg1Z3gm
         8bFikAOLU8ScgU/dI2+NT1dyLi5AkagIC9cAd01ty+5Xx+DTRIFHo3miVvszIkIBw6Pe
         XnBxgKo6CnzrdbrI8Kquyi/i375x9GRwcwnedHS7GnKzMJvNyAQE10fyA7f4+QycBohO
         fMdw==
X-Gm-Message-State: APuU4Z8ZmkB2iNeYtpxCCbgGLQ9u8rQvp/IYY0MBu+O0pIfEyXnz1Z7G
	Rt7VR93ESZzKEv6S2NVHwH1BT2kU3GM3CNSfXDOkGvolM10aXJNyy5LQ2zEIwWkATA==
X-Gm-Gg: AYBFou1iFfF0y4OsKiHy6sgED/BPqd8K/zDs/QLD61RdKPzlFOVawF3rQgRc8BgvQLq
	N8bL2NaPakbbtWsYXjd4IvGJQv/NrJttLKILIS+seUj2yaoU6/XHdShFASCnSscEnEpApB7TvJa
	fOOvs0A3tEwmsmjdhKpHvLzpAEWw/j2gGCrop+WcOhsfYyB880V5LructpFYm2b8itOe0HKVG9H
	evWKwPHAbgj5rT5wZN8pZLPMC71LXDAI14fyQYrRNvpj1CbzqzAY78nNYErmFMCUo5azLw5cbKV
	3YZzm6R5gqFrFVXA9viSfmiFi4s95DYCzVCik4u9ZIUDmWK1IIkvSG3NQ71xCzqIzoCTdrwwdsU
	5Upyx3Xg8LYuMZ7e+0MS2FBUDOiFR2bHNaMdNH5lZsEmNz+1xcixpDRu9itlc5Yo3zUxsrBm6HO
	auJPJRJ/KyQztk76K4Vz8VaPS52RA23R4QGx89nDautmI8mVTBd/gF41EXoKWxHM1YNpJDDBE5T
	tagZpFhggSlrabvG6/c7epxKRiyu/uJUWrCeT9N798qxhXO1wEBvQZS5WVpu6ZyorstLgLhOBEa
	7Wa0P69/okzKj9RRDXpLugWJBK4wVVZT0Q7h0rOloEPFkgBqGERVle026DVVzIDGdQ==
X-Received: by 2002:a05:6000:4684:b0:491:9332:935a with SMTP id ffacd0b85a97d-49afdf7ee91mr3623954f8f.1.1794489325121;
        Thu, 12 Nov 2026 05:15:25 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835d2bf91sm17033305f8f.23.2026.11.12.05.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:15:24 -0800 (PST)
Date: Thu, 12 Nov 2026 13:15:20 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 18/23] KVM: arm64: Introduce
 kvm_pgtable_stage2_table_install()
Message-ID: <avW76NcAokHunPXw@google.com>
References: <20261102204628.401871-1-vdonnefort@google.com>
 <20261102204628.401871-19-vdonnefort@google.com>
 <sashiko-outbox-194174@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-194174@kernel.org>

On Mon, Nov 02, 2026 at 09:02:11PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] KVM: arm64: missing block alignment check in stage2_table_install_walker()
> - [Low] KVM: arm64: kernel-doc mismatch for kvm_pgtable_stage2_table_install()
> --
> 
> commit 2ec53eff489eca020eb2705b64a21720b1def67f
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Introduce kvm_pgtable_stage2_table_install()
> 
> This commit introduces kvm_pgtable_stage2_table_install() to replace a
> stage-2 leaf entry with a pre-allocated table, enabling pKVM to handle block
> splitting in mem_protect.c without relying on kvm_mmu_memory_cache.
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 1c9c57cd6ae40..587874c3a5259 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -835,6 +835,18 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >  int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  			     struct kvm_mmu_memory_cache *mc);
> >  
> > +/**
> > + * kvm_pgtable_stage2_table_install() - Replace a stage-2 leaf entry with a table.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_create_unlinked().
> > + * @addr:	Address identifying the leaf entry to replace.
> > + * @size:	Size of the block to replace.
> > + * @tab:	Pointer to the pre-allocated table to install.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_table_install(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +				     kvm_pte_t *table);
> 
> [Severity: Low]
> In the kernel-doc comment for kvm_pgtable_stage2_table_install(), @tab does
> not match the parameter name table in the prototype (and definition in
> arch/arm64/kvm/hyp/pgtable.c), which triggers a scripts/kernel-doc warning.
> 
> Also, @pgt is described as initialised by
> kvm_pgtable_stage2_create_unlinked(). Should @pgt be documented as
> initialised by kvm_pgtable_stage2_init*(), with @table being the table that
> may be created by kvm_pgtable_stage2_create_unlinked()?

That one is easy!

> 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index abd32e94f6ff0..19634e5ec5557 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> 
> [ ... ]
> 
> > @@ -1620,6 +1634,55 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  	return ret;
> >  }
> >  
> > +struct stage2_table_install_data {
> > +	struct kvm_s2_mmu	*mmu;
> > +	kvm_pte_t		*table;
> > +};
> > +
> > +static int stage2_table_install_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +				       enum kvm_pgtable_walk_flags visit)
> > +{
> > +	struct stage2_table_install_data *data = ctx->arg;
> > +	struct kvm_s2_mmu *mmu = data->mmu;
> > +	kvm_pte_t *childp = data->table;
> > +
> > +	if (ctx->level == KVM_PGTABLE_LAST_LEVEL)
> > +		return -EINVAL;
> > +
> > +	if (ctx->addr != ctx->start ||
> > +	    ctx->end != ctx->addr + kvm_granule_size(ctx->level))
> > +		return -EINVAL;
> 
> [Severity: Medium]
> Does this check verify that ctx->addr is aligned to the block granule size
> kvm_granule_size(ctx->level)?
> 
> In kvm_pgtable_walk(), both walk_data.start and walk_data.addr are
> initialised to ALIGN_DOWN(addr, PAGE_SIZE):
> 
> 	struct kvm_pgtable_walk_data walk_data = {
> 		.start	= ALIGN_DOWN(addr, PAGE_SIZE),
> 		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
> 		.end	= PAGE_ALIGN(walk_data.addr + size),
> 		.walker	= walker,
> 	};
> 
> In __kvm_pgtable_visit(), data->addr is only aligned down to
> kvm_granule_size(level) and advanced after the leaf callback returns 0:
> 
> 	if (!table) {
> 		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
> 		data->addr += kvm_granule_size(level);
> 		goto out;
> 	}
> 
> Because stage2_table_install_walker() is only invoked for
> KVM_PGTABLE_WALK_LEAF and always returns a non-zero value, ctx->addr is
> always equal to ctx->start on the first visited leaf entry, making
> ctx->addr != ctx->start always false.

Right, this can be dropped.

> 
> If kvm_pgtable_stage2_table_install() is called with an addr that is
> page-aligned but not aligned to kvm_granule_size(ctx->level) and with size
> equal to kvm_granule_size(ctx->level), this check will pass, replacing the
> enclosing block PTE and passing an unaligned IPA to stage2_try_break_pte().
> Although the callers added later in the series (__pkvm_host_split_guest()
> and host_stage2_split_gfn_meta()) check PMD_SIZE alignment beforehand,
> should stage2_table_install_walker() check
> !IS_ALIGNED(ctx->addr, kvm_granule_size(ctx->level))?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261102204628.401871-1-vdonnefort@google.com?part=18

Perhaps a better API would be

  int kvm_pgtable_stage2_table_install(struct kvm_pgtable *pgt, kvm_pte_t *table, u64 addr, s8 level)

This would match kvm_pgtable_stage2_create_unlinked() which is also using
"level". Then, we can easily reject a non-aligned addr and drop the checks in
the walker.

-- 
Vincent
