Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0993CF1FD
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776006; cv=none; b=Qt3YA0XI30Ereup23Xrz030N/BULMzx1fRkwGuSbY7J98b0ad3A8QhE4cSVrWTh2oMOXkZ/6BqtJt2SaDl1x1U+ss59dRoaePB/kC8PmwiXoVkjMZ6boaDoWu/LljGRdg891xotvj7omrOK7C2kpw9252m8TkOMqrdO5zYiL4pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776006; c=relaxed/simple;
	bh=kwSRFB6k7ItQnpLwWCQSXDIvf7Rf9MlEIuIPfK0wwm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQSqZ7y6Jgq6eGugNO5GzhPZhCwbOS/bxkOYevLKfJNSkHZgd6WBMMEh3PK4Cg2HeQ07k2jFI9NgvoLCoS0TiBUEX7Zlm1RDOSogV5G7pYdQQNSjf3jyx/L1BTUYJao51hm9p7Q5NqOhe2qtY/zL3NcCTapcf1G4S13EynZS4Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RI3D2xCj; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RI3D2xCj"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a600a1caf8so5210313a12.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 03:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788776003; x=1789380803; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mCouEmK1v28vcP6B5gyWqSemurFnzRz5qnbZvA4aPCU=;
        b=RI3D2xCjNzHtwdZZ7XdWZA1LPj/Yk2CzRPzYHN76D1H6ScyGDllsVI+/Ke0rSYYIKU
         GszhaCQLdPV9Lg8p7e5ygrTJN8vikjgGVwRn1mJl7lS8xsg9gwcPpy50v4eeTesQDF+L
         0fItwLG9/Vj73hQmPZSGw7qMb0JFflhs1e3bFprNVyZNR/WsMYvOb1w1kM6xeDLYPPzx
         2E3/AN1ivoDv2gdupMKSJ5emnPjNE3dqU/CxO5ePn80x/Lyi9qUlYg9pnjK8HVzL3csL
         heWPEu4gHojcSx99/uftAxRfgxx8RwveBFpj8nXR44rKtG0qF+nQ9unO+PTzYvmZXo1g
         ubAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788776003; x=1789380803;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mCouEmK1v28vcP6B5gyWqSemurFnzRz5qnbZvA4aPCU=;
        b=T1whkY2lwKx7pRXWsjxhHL3DuMDCurYgW6VNlBA+lxDkKGMpQ675QHsgKmawp9QuBX
         7VW9iIDb5j8zxjsV7TNVtybhmgn9B8KrF+hs5E2fdHJPx4Hf8Wvha1yNmV7ERWBDMhik
         PziPqPZ2o77WGnk1SVlhSW+0jsAHQLzVW4SjAtyhghVOgHjkIzf3ubkYGLyHdiUOw3Xn
         vkYhTxs4AM0wglwqFvQ5brmnbSAwg0udP27SgIqFuyh98m/7ggUK1+cBw2vqtnG2y0xt
         LUaL6yLH/2hOW2RS2C4jRyYvg5FsC1NQRZ21+OtXAWSd5xO/P0vHesqJ+HTEPlwV1BV2
         B6Ow==
X-Gm-Message-State: AFuF++lzSJLLlHRTa/nH2z8MsQG3yPKaIKV83lgs7q5q6CxmHrP7A6R9
	4aFi9BddF1C4HLDVmeKvHEEgdEy+l4g7JezatA1nXlaqDIiVsT7QApoD74WJEERxiA==
X-Gm-Gg: AYBFou02VfjV0LmJsqYmphqJzzSAZPRquOkTZR0ZiKA5uLMC2isyi41HMoTJrTHk++P
	kSTTN8SWZRZ/yZy0XrhKHl1kgjelfYnej5B0KqHv9SXEF6A3YBh4NGHgErBD24RUKqeP2adWdwh
	fM8YduNebWQurCQlEtmPIlKbTqOvEy45w0+mt3FO5AKpR4WBSKdEQnxh/lZPI1bLRe1l23HrzC+
	JrCazPrM0Zw6Zth1C7GYdhMoIfofKzt/+BvMJ9ZbsB1d7AgaANUoxvk5GQ36WEPquF66kY9Qkrf
	BMrd1vJOfRwzVKypu9/QtDX7XijMV0tIC7++Rla1v384//hiF2Fs0NjgUu7G7X55BSYEtxjtTS3
	NyPGhZyzGQ6rY7nKVVnR6EPG4Bqqg4YAel1syE4Ja0aNd75MyCocz2lu84kUgb8w2+8uIIbLx7W
	rq2SzdXuMOj6CXAgbyLPsVA3CKYSG6OQ2g0IuDX02un1f9P0rccLSBT9cV7KcWoSiVlV8/mnasx
	vDBCbcR862ykg+wxxT6ExOapJ5qb9W8
X-Received: by 2002:a05:6402:4150:b0:6a7:ee56:8150 with SMTP id 4fb4d7f45d1cf-6a7ee568298mr6387365a12.30.1788776002246;
        Mon, 07 Sep 2026 03:13:22 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6c1bee2sm4136565a12.29.2026.09.07.03.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 03:13:21 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:13:18 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 11/20] KVM: arm64: Add a range to pKVM ownership selftest
Message-ID: <ap6OPlYVvqbmAoGn@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-12-vdonnefort@google.com>
 <20260803104848.EF8BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260803104848.EF8BC1F000E9@smtp.kernel.org>

On Mon, Aug 03, 2026 at 10:48:48AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The pKVM ownership selftest crashes the hypervisor during boot when testing block-granular ranges.
> --
> 
> --- Patch [11]: [PATCH 11/20] KVM: arm64: Add a range to pKVM ownership selftest ---
> commit e6586b2867cba4559d50173770f2de71da4f2380
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add a range to pKVM ownership selftest
> 
> Extends pkvm_ownership_selftest() with a nr_pages argument to test state
> transitions with both page-granular and block-granular ranges.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index a53600c853d4f..d5ee079a5d70d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> [ ... ]
> > @@ -1894,10 +1901,10 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
> >  
> >  	selftest_state.host = PKVM_PAGE_OWNED;
> >  	selftest_state.guest[0] = PKVM_POISON;
> >  	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);
> 
> [Severity: High]
> Will this crash the hypervisor during boot when testing block-granular ranges?
> 
> When the selftest executes with a block-level range via PMD_ORDER, this
> assertion expects __pkvm_host_force_reclaim_page_guest() to return 0. However,
> __pkvm_host_force_reclaim_page_guest() hardcodes PAGE_SIZE internally:
> 
> arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_host_force_reclaim_page_guest() {
>     ...
>     ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &pa);
>     ...
> }
> 
> Because the mapping installed for this run is block-granular,
> get_valid_guest_pte() will return -E2BIG. This causes assert_transition_res()
> to fail, which triggers a WARN_ON at EL2. Since WARN_ON expands to a fatal
> BRK instruction at EL2, this results in a hypervisor panic during boot.

There's an order issue. Both

  Handle huge mappings in __pkvm_vcpu_in_poison_fault()
  Handle huge mappings in __pkvm_host_force_reclaim_page_guest()

Should come before this patch.

-- 
Vincent

> 
> [ ... ]
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index a9645480d1648..4d41a16cd5962 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> [ ... ]
> > @@ -274,17 +283,9 @@ void __init pkvm_ownership_selftest(void)
> >  	/* Memory for the VM page-table */
> >  	pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
> >  	if (!pgtable)
> > -		goto out;
> > -
> > -	/* Page whose ownership will be tested */
> > -	page = __get_free_page(GFP_KERNEL);
> > -	if (!page)
> > -		goto out;
> > +		return;
> >  
> > -	ret = kvm_call_hyp_nvhe(__pkvm_ownership_selftest, virt_to_pfn((void *)page),
> > -				virt_to_pfn((void *)pgtable), 1 << pgtable_order);
> > -out:
> > -	if (ret)
> > -		kvm_err("Failed to run %s (%ld)\n", __func__, ret);
> > +	__pkvm_ownership_selftest(0, pgtable, pgtable_order);
> > +	__pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
> >  
> >  	free_pages(pgtable, pgtable_order);
> > -	free_page(page);
> >  }
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260803100904.3563942-1-vdonnefort@google.com?part=11
