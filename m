Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B446329E76
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768209960; cv=pass; b=Ut1Y9AtPvf/ggCyrX+/MpXlsEzF9rSF3sVgPZvP9RuVxb2MTE0/pgpf8EdT1LIjojJoCQDudyHjjSVy5kR4Ha7WW4wt3T5DfsrXQuAtjfrmbqElsAfGf7QcHCCcemfcylRj8GfXyf6kkLVg0V2Pt6Mz0oPut7RnjKNZoDQzJYiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768209960; c=relaxed/simple;
	bh=xTBr6d1VvkFZvKVxPcj5hHhnlGBrs01PHV9QP6vSYOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bshxlzLMf99kyzeCQvECVR2jE/99CDI8e1RCoZdRFeh90aP+4RMZRUmNW/FXL0vvKzKFog4K556cSOLDxF6M87WApEPLFyQ4lDtSOvUT8lC2CwkRp4VfH/o7Qc6M4ns5CSmdMgGuP9joLJdHpjgKMC4fjD/mQSHx6xYqFd5yh3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R5Fzmeti; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R5Fzmeti"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ffbaaafac4so835351cf.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 01:25:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768209957; cv=none;
        d=google.com; s=arc-20240605;
        b=K4HTa+85x1tin+LbsRkL2pGztjnOGt4m/KvK453ESergKFW4IeApH4wvc9p3kBmVHo
         FGIAcDV0jIlA69+H35GXMnpCU4+XEMEIFSbBtVx9I/V+VJTc+4F/cgvEgcb9CGrYXPUh
         FWIl/E0nhk30x4PYZG2sDDd24UtJlHfpJ6FqnXndQ/gdHuUBnWOghTvFeQ6IQCFkk6sV
         8JCYVqAo65Bp50ht7cXgh8+OzliCx9mQkL2Eq7Gk6yLTzIv9uLDWPtIxTyxZ8zS1BJtk
         V+PWbSowH9PSoivvwP9vYXlVxDS0pMdwVQzKDy5M0Ia3cDSqamIEc36cVw0E7n5v1u+R
         7tyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4CcV5AeMjzqz4dX84OHMKhqFU2THmMSUqKIzME/hWtA=;
        fh=OsVEnhpHfDtKQejlv1Bgs/tZPAfr3IJ2Ck5WUUi92Sc=;
        b=EPYFpmXPX/LCFYh6kroSBcEIWYOUul0LYQ1fnu6rkidKbVoqA2IAP7Slf8HYxC2VpA
         hLrnwCXa8JVmpIAA9iDG29fSgH37rHv+aW7PEFE+jRLiikRbJyOn7ooWETPFf+ZPIfoN
         1tsS+n+x2I/9tRTHCueC7ppYB+4A4zN4MZndfkTZyKj7qg0CIeJSi1px8YSH6pERsMNe
         TaDO8oz+Ey1oMqq0Ql2yXke+z5S9GPsKpqXszppyBA89EBuyDxdrsuRPptrUY51uxwQP
         LhdQmIcINjKDocVlrAi2BAc1ZrvNNp/f1YjrjaSBLGcuqDoYw2Jp9QpdljMpViSWzaKZ
         kKbA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768209957; x=1768814757; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4CcV5AeMjzqz4dX84OHMKhqFU2THmMSUqKIzME/hWtA=;
        b=R5FzmetiQwjuohcaBnf7PUovDdkkZ9cJt5klFKA54bDunqXx+57my6GDxDEmALgzhA
         +ClBlia1RNWzYh7DilNwuFWBpq0xNd8Y7mQwzb2siGLtRw3e9v/K30fsMaiW5RTGS7lP
         PXd9rBnFsVf+9DGVUBzCkQMOBKDHyAp6nQ8N1a1dSlVwi/FeFfRzLV19tV4oW2Ns1bmf
         q30u6px9J2IP/z6IHUwvIWyvBsdf60gXCqfHdhbBzePNvSOkR2eXXczp+kWk06sS/DVg
         mOS7EUqzFMfE7TyZyTolooAhGaLBr72+1oPXJ5ZcYblSTp59NDGzi8kOb9gr3qZ8vgl4
         Q9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768209957; x=1768814757;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CcV5AeMjzqz4dX84OHMKhqFU2THmMSUqKIzME/hWtA=;
        b=UerFJ8MwdoFwtiY6j4tJinpzGGZgHyfhRozoEMtlQYTjW8g+lTJ6eNtrXHPOe7cX2Q
         1Q3arQtuvZU7dvmVUw8kLjg4tCOLhY+aXKuWx+SzcmmSuQEIjCPxIMdgHqcg8PY2tOJc
         625PtGvxkLxYiyR88FaromCPzhWFClLSdJKFdnZ28v0c474DGTskD8o9JcH3DKFLTHvo
         //TLNC4raTNqo/10uQy2BapkiJtBNZIUy70G2Id9B/8SgQ1ifhJnTKrNPs7IRyzT7hPM
         BIp7EHsheqfNOAGuLAie5hLk49QFpBfkyH2ddWXxDo6JCosUawo6ybsRaWz1YJqu7fI2
         Qspg==
X-Gm-Message-State: AOJu0YxLuSlzc4W9ps9RDT6zcr/IEQjrbj1T5xoQICffIRyE8oVoFDKb
	ADMDxmQvumpYH1kCDP1q6R4CaPi0PfsFU0miLfCDCPnq5p0MXdT720HnOYQak22NOvmb8PgQ1aP
	yUSpwkZcvBFn1fT/F07nHXusFFsYU7YvJid76xXYn
X-Gm-Gg: AY/fxX62NwiWxpEw1tDyi1UcbVO4BV4Acdwdjv2DmNzL1G45zzSLB8CXgB14XoOw3rH
	iVm/EHFRzNMXkuhgF+ybeDBi+htEcaVtNKSEFXY0gL7krdaY+Phz+eo+znx/GHVptkHTMthXlHb
	hEdYDL6bZ1wSys1nuIGSR01nIAHhXJa1KaLtcJE0jiryj5DxWY//Vus136bqU42AKeMSxuCB2P1
	8q2HUtXehfiNQ4jniwDDXYABUOg1vsl9Bwb1Gi81WL119d24AdAQUNw55y0Kte4eO9KqoMl
X-Received: by 2002:ac8:5952:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-50118159a32mr19754721cf.0.1768209957071; Mon, 12 Jan 2026
 01:25:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260105154939.11041-1-will@kernel.org> <20260105154939.11041-20-will@kernel.org>
 <CA+EHjTzNcTOR5sZpBTUXUP++yqOZEvmfs=S3wqBTG-YT=hxoKQ@mail.gmail.com> <aWET2EGnFKZCK2Ni@willie-the-truck>
In-Reply-To: <aWET2EGnFKZCK2Ni@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 09:25:20 +0000
X-Gm-Features: AZwV_Qj-dXnEHT_eaPYhFYtJOYm6uHvi1c01WepSDaWMdR4ksdvmrI3uB9QhiUA
Message-ID: <CA+EHjTwBFJWM4+TGCz9YwFcPQAC+nNxBNLQxnZPPo7VeQunoQw@mail.gmail.com>
Subject: Re: [PATCH 19/30] KVM: arm64: Annotate guest donations with handle
 and gfn in host stage-2
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 Jan 2026 at 14:42, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jan 06, 2026 at 04:01:28PM +0000, Fuad Tabba wrote:
> > On Mon, 5 Jan 2026 at 15:50, Will Deacon <will@kernel.org> wrote:
> > >
> > > Handling host kernel faults arising from accesses to donated guest
> > > memory will require an rmap-like mechanism to identify the guest mapping
> > > of the faulting page.
> > >
> > > Extend the page donation logic to encode the guest handle and gfn
> > > alongside the owner information in the host stage-2 pte.
> > >
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 18 +++++++++++++++++-
> > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index 7d1844e2888d..1a341337b272 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -1063,6 +1063,19 @@ static void hyp_poison_page(phys_addr_t phys)
> > >         hyp_fixmap_unmap();
> > >  }
> > >
> > > +#define KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK GENMASK(15, 0)
> > > +#define KVM_HOST_INVALID_PTE_GUEST_GFN_MASK    GENMASK(56, 16)
> > > +static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
> > > +{
> > > +       pkvm_handle_t handle = vm->kvm.arch.pkvm.handle;
> > > +
> > > +       WARN_ON(!FIELD_FIT(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, handle));
> >
> > Instead of (or in addition to) this check, should we also have a
> > compile time check to ensure that the handle fits? We have
> > KVM_MAX_PVMS and HANDLE_OFFSET, albeit HANDLE_OFFSET, so we can
> > calculate whether it fits.
>
> The problem there is that HANDLE_OFFSET is hidden inside of pkvm.c and I
> really didn't want to expose that in a header as we might as well just
> remove it at that point and allocate from 0.
>
> Maybe we could make pkvm_handle_t a u16 instead and I could assert that
> at compile type?

That works.

Cheers,
/fuad

> Will
