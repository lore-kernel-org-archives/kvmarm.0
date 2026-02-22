Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B8B3563E0
	for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 20:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771792140; cv=pass; b=po7Rfti0nw/iMSeq6IS2JZbppvQaZIW2FpOwKp2HPc5Hbq6HIbQ3//lzmaW299c6pPfOeWuSczxxmGQlU/OWV823v0/hDwjUKGGbl5K3n1Pg68niSruDJ4Qn1gWRK8Sr/e4BOVSIzfykAeIkRE8bhPvx14hmCru1DRwEq+epq1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771792140; c=relaxed/simple;
	bh=yjt+fj5rpYQBXgVHixsScjBAGfbqYqJIprbU4BqHtNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FwmY7jU644iwJsYLeOrI+5AVQqwuWxIWbJnGrQf1sCPhPLuarHv6BN+7RGy5HsAk1RobepkEHFnmX6sky3uM2TyD8UwnNgBLv1T9VqElejiQRr5llZvQz8yIPzK/vtmv0GpEQ/o9NIth0iSd/ZHCBtj6vijWrGAPWeph9N50l7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eVPWMwzq; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eVPWMwzq"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5033b64256dso715781cf.0
        for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 12:28:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771792137; cv=none;
        d=google.com; s=arc-20240605;
        b=ldqXF07woaeAuD2RkR/0dDRe8YtIB4JU7u0GuoPscja51zKXIezBVrMBQuPHMCtDtd
         rgAoHTFnxz+uV7CKU2doDsoa+WhlZW3eVZqjnM2K4IErcwAKcTO5Oi0DDnD2wFnJS8/J
         yoJx5F9VzXLWiRe7t0uNmwG45Rz9ogLmLQaBXXd2SqHNxDvaLu0bl4twhAkWmtx9gL4r
         F/DQym5xs4/tzaGBtFPd6u6vEuF0KP67xnkO/ugTln0Cbl0xEyu/gaLWg/dzPIiAJLPa
         HBak3zqRaJkQV1qkINIATXMABN1+gkTdwErFQUwTSU7pvmJLfR9v4l6KFmQzRrlj8lUf
         CmaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=F2/zSsN0ZphntQc+eR+dJyrmvjXaa4Ou1pt58IXRg+A=;
        fh=l+sdVha7YxfGfdzT9OeZJPp+WkrcNTj9WAopZOBOGVo=;
        b=CWxJ9ZBxt7xzsDXWRLRlXxIkrlWyuYWGUebVJweVNII8qFG2bIlkfdpzcnoNltY7Sk
         n+RB5BNActq6asRDNK1Bki4Zr9HhpgSTjaauZh6LIW2hRPbjEfSwZpNMca/bwLYe1aFI
         qzYwI+ms+FMSYEU/cxIe763pBPRdwsTmBbsYewPzP9lCT0HqCXxJBjl6z7CBcnLMsaBt
         ZymXOJUrGPlq2e5n8kwyfqOG5Tyo9L3ORjy3RClHFmt1VWalG8/PObentfSlpV15lY6z
         RlL6edmvWTGKqqEyFnxUNhZFTnEdBHbSF4kPLCEdXXs4cmxpBFJt6ALa9IcZbOGvofwU
         RSCw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771792137; x=1772396937; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F2/zSsN0ZphntQc+eR+dJyrmvjXaa4Ou1pt58IXRg+A=;
        b=eVPWMwzqNwItbFuRnbIr+aNOk5fyUgQRLVh6WwDTzsOC6B60l5MJf0GYER8tf56pra
         WGULKoUfU1XaPK76UfIFdhP4VhEM0B1LtNNNzar6D9bnlOeQF0MVZHyFDfBAnpGofGcp
         nnZ6EBGkh/kl3TRk667wrDrcXXsPWwJehhuJNrhGfboFf/QknKUhLPu/G878UvziKxwK
         ZPepY/vUD6N0Thd1qfQP9rPX9BBHrLCLNfThnmHv0nzs/d/SGO00CmMqX33XmokmVq8F
         GUIc32tgK1qa/P05qj+nh1qcx4VH6iAm1D4rTLbrDhmKqKHghl5X+6tPxcfth0FKZa0g
         D+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771792137; x=1772396937;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F2/zSsN0ZphntQc+eR+dJyrmvjXaa4Ou1pt58IXRg+A=;
        b=VjTMNO0R8hAtUAeoswGp3GfKn/CK8/GL6WpidtGKiTAPKLtqFM6X+FfSMLONSiCC0L
         zkGrB0vBqsUj5vxcxaY16/jnMnNbLhm96S1f/w9CIIzYMacTYWyysDGeg5qTMyPtzXx2
         +KkMN0c+PnbwczPTey8IQfEgp9Yuh0H88U+c5m+evIheHri73IjSYtO9RRLAmL/nL5k2
         Wjl6u6VHzAxn1jcK9V+LRgnU9iDndsJDFS0G9Qy5uWeXR1C3NTAJQwD053b65r+LnpwK
         QJsNGz3sidy5m95R09S1E2F0qRCmgEkiYcsuZKsA3kigkri9zvWYMeWNAYqzEyquhHKs
         5fzQ==
X-Gm-Message-State: AOJu0YzHJ7lGBgwcz/B+WYlGlSBdVbFbjcelOKph1NnX3hjpjgHAwHdn
	11xXnrfNs/fA3oKKDg1VGHGKv2ecHhd6Srso2gi5ldvHmK2tvOaD4vBTbGPpgTk4PFttfuPq/OK
	VwOKe5gpUaVBpKqI5At/IyAOvBwLLH/Cyb3czN+Dw
X-Gm-Gg: AZuq6aIlfDe8tx0bz9kr4ZHR3o3e7Bl1qoUdMGbSXeU6dObWqUiH5bvl3nfdXnTpdls
	cfRbLzUiho21gmIm29JAA0n/h3MI+nNYIqpCIfSzt+tRiSvslTjDANcxApaVhvY6PTRYa0FzUrr
	BNplneupUVQEKIq2plpJ+Iu6PMYY0KIGmQQFH6jG1gS9rXCPV0dMv93D2FENyvslw95UDpOH73d
	gRSW/269zKIidfBM0PDziKQzdXHqWgsLbtPzVrkDNPtdcPSbDaSSicGYdu09GSs2YEGebmVJvzr
	1JAJtSvs
X-Received: by 2002:ac8:7dc1:0:b0:4f0:2e33:81aa with SMTP id
 d75a77b69052e-5070e893faemr12700351cf.11.1771792136883; Sun, 22 Feb 2026
 12:28:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260222141000.3084258-1-maz@kernel.org> <CA+EHjTy4p-Mbfr86NR9n1LgHC0EWrkdVjYb8O3z7k=Lv1entQg@mail.gmail.com>
 <878qckehh9.wl-maz@kernel.org>
In-Reply-To: <878qckehh9.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Feb 2026 20:28:19 +0000
X-Gm-Features: AaiRm50cURl-e3Du3IJOwxV9NVX2guzIAipyh62nI0lRBrHVyFZMVoDigEP_TR8
Message-ID: <CA+EHjTxtFZU24rwh3zeiJjHgV2_g_HfJvMFJDC3WNKCLa58kaA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix protected mode handling of pages larger
 than 4kB
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 22 Feb 2026 at 18:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Sun, 22 Feb 2026 17:58:00 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sun, 22 Feb 2026 at 14:10, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > Since 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings"),
> > > pKVM tracks the memory that has been mapped into a guest in a
> > > side data structure. Crucially, it uses it to find out whether
> > > a page has already been mapped, and therefore refuses to map it
> > > twice. So far, so good.
> > >
> > > However, this very patch completely breaks non-4kB page support,
> > > with guests being unable to boot. The most obvious symptom is that
> > > we take the same fault repeatedly, and not making forward progress.
> > > A quick investigation shows that this is because of the above
> > > rejection code.
> > >
> > > As it turns out, there are multiple issues at play:
> > >
> > > - while the HPFAR_EL2 register gives you the faulting IPA minus
> > >   the bottom 12 bits, it will still give you the extra bits that
> > >   are part of the page offset for anything larger than 4kB,
> > >   even for a level-3 mapping
> >
> > Matches the ARM ARM.
> >
> > > - pkvm_kvm_pgtable_stage2_map() assumes that the address passed
> > >   as a parameter is aligned to the size of the intended mapping
> >
> > nit: pkvm_kvm_pgtable_stage2_map() -> kvm_pgtable_stage2_map()
>
> Actually, that's pkvm_pgtable_stage2_map(). kvm_pgtable_stage2_map()
> itself isn't affected.

Right, I meant to remove the kvm, not the pkvm. It is indeed
pkvm_pgtable_stage2_map().

> >
> > > - the faulting address is only aligned for a non-page mapping
> > >
> > > When the planets are suitably aligned (pun intended), the guest
> > > faults a page by accessing it past the bottom 4kB, and extra bits
> > > get set in the HPFAR_EL2 register. If this results in a page mapping
> > > (which is likely with large granule sizes), nothing aligns it further
> > > down, and pkvm_mapping_iter_first() finds an intersection that
> > > doesn't really exist. We assume this is a spurious fault and return
> > > -EAGAIN. And again.
> > >
> > > This doesn't hit outside of the protected code, as the page table
> > > code always aligns the IPA down to a page boundary, hiding the issue
> > > for everyone else.
> > >
> > > Fix it by always forcing the alignment on vma_pagesize, irrespective
> > > of the value of vma_pagesize.
> > >
> > > Fixes: 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings")
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  arch/arm64/kvm/mmu.c | 12 +++++-------
> > >  1 file changed, 5 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 8c5d259810b2f..aa587f2e28264 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1753,14 +1753,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >         }
> > >
> > >         /*
> > > -        * Both the canonical IPA and fault IPA must be hugepage-aligned to
> > > -        * ensure we find the right PFN and lay down the mapping in the right
> > > -        * place.
> > > +        * Both the canonical IPA and fault IPA must be aligned to the
> > > +        * mapping size to ensure we find the right PFN and lay down the
> > > +        * mapping in the right place.
> > >          */
> > > -       if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
> > > -               fault_ipa &= ~(vma_pagesize - 1);
> > > -               ipa &= ~(vma_pagesize - 1);
> > > -       }
> > > +       fault_ipa &= ~(vma_pagesize - 1);
> > > +       ipa &= ~(vma_pagesize - 1);
> >
> > nit: Since we're changing this code anyway, should we use the ALIGN
> > macros instead?
>
> That'd be ALIGN_DOWN() then, as ALIGN() really is ALIGN_UP(), and
> that'd be counter-productive.  Something like:
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index aa587f2e28264..3952415c4f83b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1757,8 +1757,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          * mapping size to ensure we find the right PFN and lay down the
>          * mapping in the right place.
>          */
> -       fault_ipa &= ~(vma_pagesize - 1);
> -       ipa &= ~(vma_pagesize - 1);
> +       fault_ipa = ALIGN_DOWN(fault_ipa, vma_pagesize);
> +       ipa = ALIGN_DOWN(ipa, vma_pagesize);

Yup, that's what I had in mind.

>         gfn = ipa >> PAGE_SHIFT;
>         mte_allowed = kvm_vma_mte_allowed(vma);
>
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> >
> > and using 4, 16, and 64KB pages:
> >
> > Tested-by: Fuad Tabba <tabba@google.com>
>
> Ah, great! I couldn't be bothered with 64kB, and only used 16kB in NV
> to debug quickly and then bare-metal to verify the fix.
>
> Thanks!

Thank you!
/fuad

>
>         M.
>
> --
> Jazz isn't dead. It just smells funny.
