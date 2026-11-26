Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723474;
	b=bqzgUu+IExKOAMAVZeigICwAaFnFtCI5vxa06tuIXvQDSgUm+dGTs8WqHtIz9ADnh3vp
	 oxty6vO/mhfWv4Fxv14w+jr+DX0umPZscGuB4HQaftVdrPwHw3nPr93aEJrgQxu6H2Urq
	 sPZcw6L3WXdRBLzVW1YzR4xDDWu4IWVLZYNbsgqTVabwO/oYBtq/v6SYBWcC6z1irKst7
	 ZvmAw5x6cnFMi9cRQ+am3CbsXUugae5YBZP8vMpJp3KAFjejmEBU7mIliw0kmA35kTNgh
	 nrLavl/mvV8nHIyBX1gWGQ7nqJ4noVaOQl+aV8cHvoJn3NxLBtTztn0Ygb2eSSA5fEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=SZViwLMRIRsc10i5iYEamCnIC3DyjaOcp2ziBxdsyFo=;
	b=R6dacM+l1DLAE0Lvhvx7rRQy7N+Z3gOpuZplRuKkCxObrPg+q+7nlPb6CAYbt8rBXuT6
	 peEw+4LnAry/Hhwgrlp0E1k5jSbKLc89f9KGNTIKNa7WfHLEajGxHcJll2uLzFoIpMi0j
	 EPl/xYJEtlkOKvJe7CVZM3iB90AKa45Wn+QYQ8VdF2GARlyVUofjREA1bqln9MwrUv+2X
	 cTec7yjZ8BBq9v5G/HWTHxaJaamEk+3Ou2PDAgJHstGgu7FpUDI3OrB9CPooUCcvY2dK1
	 u0Id9AR0ScTyt78Jjqb4mrUOwHGLM6DBi185dIjnvlUODm5Ky/B5SW+GkBqMNCE4C+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fqgCzMGl;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72215606A31C
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 20:04:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72215606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fqgCzMGl
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bba5e17728so20820525e9.2
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 12:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795723473; x=1796328273; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SZViwLMRIRsc10i5iYEamCnIC3DyjaOcp2ziBxdsyFo=;
        b=fqgCzMGlykFiUHcR+n4ERuHBsa4VjG3gs/urBxTW1H9tQvw09YmxPqbXDf31QvrBEo
         HZ+Wu6AIF98YWUJCuYHOdXgWn/1MD1rmx6+1rwdWIsY2CBm4G/mJzmFrHnE4p4Zhu4ju
         Kqq1qQrne7KmuteWm42Meou73d4cOqu/AL4L75ASGp5v77/2jyJqV2crkvm0akRu3Qlo
         0v3k0Ktdu/CNRfYvNSpwSTLUP/NA79xiXstPNRSPy0F0JD3N9n1urNpygMftr3bP3hr8
         dnNqbtwcAwCIE2x34uNCPuDDZaR+vdt8eP9myCfzKJyvCdZNZexmP17xwHYLx8OoaQ/Z
         TaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723473; x=1796328273;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SZViwLMRIRsc10i5iYEamCnIC3DyjaOcp2ziBxdsyFo=;
        b=a+DP2qHkwI/RCOvA3dSv9GKtdENqjedt5FTM/Ch3m5ZcydHDk3xt9F47LZeeZ+CpPe
         4V3MY0LLuepeyRxNmVp0gyDFXMOEt2BvacGZXZCR5nKe6rCPKWerAgwqp4cKaj10H1MK
         T6A7vrntD0XL3Bkiwryz3DXBxA2L5g/610Pa65BMJknTBDSN7UrH8w+G/zuY34lS5TTf
         okYrC9P+ns9fRdcRp20LuFV+jc8YZmV52jxVA56vsP2LH20DZzvUVypIj3QwEXLeH7XQ
         zDQ/KQME5t358p0stgl3be/wRdU6y1EUfjc/70ya5t4j6d+rvuf/cxjn22/Swvgzpu1U
         eIGA==
X-Forwarded-Encrypted: i=1; AL+hErETHVOgL931y5DXwDnD0MyQero7Qn4hGJ1AHQuNnt/a8L05Rhv4LjKFLbiDAp5NSA3qOp1htnU=@lists.linux.dev
X-Gm-Message-State: APuU4Z9VMjoa3MC74D7+jqxIuMsQ0szXO/XV/EM7zyzRzn7QbVaqBTfs
	4uDwTjD8uDIhJGecVcYkT4302D9dCh6zoz5YPUzuoKaNBMkcM17Yq9OyIBDjxBELgw==
X-Gm-Gg: AZFdTZfaAJUV6bmXZQp4Z07B0TLrPZCMw+JoeNPblPcYfBsy9t9D4yeLM/IsDj7XJkI
	lTDx9iAVm1E7ImuVQ4x8fiRqkeIEx00SnGQZZoq9O4Lji65bEVGfVpI75bPFrBWKsDZHkVMswhw
	02QwN7l4CW+cKkkMBuNtHTLYfInL0pxyOgGmpC8KBTy79YwNwuOLUPifGDg7gTS61bOLWkZujD9
	odP/9/u0B3+cYngtMRff5A/G7Aeajnn+7UTdocGsIH4mQ7tzE0qQNyLexZfoC/xRdgEm1P6YIQi
	P277mShcRDwdRZbKgt4G0YGGX8lrl1Mtze7EpG9oW9ZbYDw2Hem/ABmGJrb2VEa3Mh0oh59K85U
	RdGPK7WRx8xaD6tgY1zK+JyEJjGJummGA7DAn2O6kZ5eU2jq+f0/exJpRadnvYXlM9dG8LhV+Kl
	g7TzL4rAw2tXbM4ZOpDkYOmnxGREKDcKPbgEzGO6OyrhFGao/RBgRJ3eyXr5mO5OmgqIclJtfSR
	2FsWBsUid6xS323MXiKlFlWa5I/nTg372GDJVB3EePCpCLTHLgURTXs88nJzNgjezhGvDzNSwwf
	dRY5p2QwbaR3JeQfALpjWryIdugwAAjxQM4efk+71aSlJyXxPLDfojPQ1FqyqVvs9/HTwYDwbqR
	gWVVf4KBOTVMVFsQxpjc/EQA=
X-Received: by 2002:a05:600c:828e:b0:4a1:cd83:b23e with SMTP id 5b1f17b1804b1-4bb88786ddemr411339985e9.0.1795723472329;
        Thu, 26 Nov 2026 12:04:32 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b8429sm981502225e9.14.2026.11.26.12.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 12:04:31 -0800 (PST)
Date: Thu, 26 Nov 2026 20:04:28 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com, weilin.chang@arm.com
Subject: Re: [PATCH v4 21/23] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
Message-ID: <awiQzMZxQDEHrRf4@google.com>
References: <20261117174403.58762-1-vdonnefort@google.com>
 <20261117174403.58762-22-vdonnefort@google.com>
 <CA+EHjTzZkAf8+BGNH15TKCEYUyO=VFvGSeJg5hfaFoefNOTVpg@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzZkAf8+BGNH15TKCEYUyO=VFvGSeJg5hfaFoefNOTVpg@mail.gmail.com>

On Mon, Nov 23, 2026 at 08:49:00PM +0000, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Tue, 17 Nov 2026 17:44:00 +0000, Vincent Donnefort
> <vdonnefort@google.com> wrote:
> [...]
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index c55b6d442d0e..58ca7ffa68e3 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> [...]
> > +static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_t ipa, u64 size)
> > +{
> [...]
> > +        ret = folio_add_pins(page_folio(pfn_to_page(mapping->pfn)), nr_pages);
> > +        if (ret)
> > +                goto unlock_mmu;
> > +
> > +        ret = kvm_call_hyp_nvhe(__pkvm_host_split_guest, gpa_to_gfn(ipa), size / PAGE_SIZE);
> > +        if (ret) {
> > +                for (int i = 0; i < nr_pages; i++)
> > +                        unpin_user_page(pfn_to_page(mapping->pfn + 1 + i));
> > +                goto unlock_mmu;
> > +        }
> 
> Could you use unpin_user_folio() here, to mirror folio_add_pins()?

Ack.

> 
> [...]
> > @@ -765,6 +890,23 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
> >          return !ret || ret == -EAGAIN;
> >  }
> >
> > +static int pkvm_hyp_req_handle_split(struct kvm_vcpu *vcpu, u64 gfn, u64 nr_pages)
> > +{
> > +        phys_addr_t addr = ALIGN_DOWN(gfn << PAGE_SHIFT, PMD_SIZE);
> > +        phys_addr_t end = ALIGN((gfn + nr_pages) << PAGE_SHIFT, PMD_SIZE);
> > +
> > +        while (addr < end) {
> > +                int ret = __pkvm_pgtable_stage2_split(vcpu, addr, PMD_SIZE);
> 
> Could you drop nr_pages from the split request? Patch 22, the only place
> that raises it, passes 1, so this loop runs once.

Hum, it is just we have range everywhere now so it feels a bit weird of not
having one here. But then I agree this isn't a stable API.

-- 
Vincent


> 
> Cheers,
> /fuad
