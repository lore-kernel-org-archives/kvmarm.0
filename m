Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F95E456DFA
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 14:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785855019; cv=none; b=bynkN+19y0T824ln6R8Tg9ReLVRHeCIhsd76gKDFu5hVcl/wvVm19gu6zwx5ON64JV3eb/QohQkXE+zXVJslkYs1VVf8CoV58ZZLhToJTc7YE3N812MsoCqfdyv4EkauZf2jVrxJIVK2mgURjybawxsNnU1r/GADAxskL7eiTMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785855019; c=relaxed/simple;
	bh=kQAS1jsNR9gHB+FBM7fPWKSqywBPXmRqtaUfOLkCkrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fC75TQrQ/iWjz8aXuC+nd1WjpDvKj9KBhq2tWaQDdZk1UlDOb1fqxkLdHuxrUI4GNzJSygBJj8dUILYjQ8dxYPGPmd2Odm+nZAT1LHzn9cGiZbgT+gkVktI2yWAdtgXbQU1J+sb4xHQHfeEgdlKh17vnGwA/jFNMOO+Z95N+EoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DjozL+US; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DjozL+US"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-495509b08ebso46875e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Aug 2026 07:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785855015; x=1786459815; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aoiYuPF6Lxrjv4D/1nx7DDBtlGVMorYZQ8pdqOx51TA=;
        b=DjozL+USiAFju7/ysT7BNMLYpupTZ/ILl7D0M+OVuUGwTTiOpw34O+J1PU6c9j64ZJ
         XzHI1FmJUVSoGRguN91X3OtLesX7PcSaOWniIQIY0LKNNOsxFadof4CchAb26p8A/mqt
         uE3szc2ssut8ZN1GRVdQQKJOE0venVrIEfW9i8VHsTJEUoiNECArKO5IV8Lv+Kx5JQ+U
         HZe/sUgHoddcehKiMXoymFXGlC+f9lSHkModSIyU7RKjhX6/V44tnQ1iFPTT8hmhszbz
         oICdzngeaLbFB617U1Zs6TVtFRYz5ViMI0WDiKcuMkzhf2Tvxe43gGgXVBjkxk/+El3r
         OjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785855015; x=1786459815;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aoiYuPF6Lxrjv4D/1nx7DDBtlGVMorYZQ8pdqOx51TA=;
        b=QEG0YYz0tvowS2zLa7NrkWrlz1nWamgInIaATKsr2Ih/oiQRmzDteXxotuEcHyx9WX
         9cXWHYtTM8mztFPMTbLGZ06FoMxOesmoErc8u81cJBZdev6VDbFSxm36oORKJGfqGp9g
         YlfKKuc6fyjU1Aw6SOmY5+/+qNf931r53TeWv4sFe357EeTd9g/Vrq0NCizJVpS0enuB
         FlaY8B6Nc1pPd24GXgrcGmQopi9VlV/pVrgtnEudThOH0ctXwL7O+cTfPfOmDoUtH/Is
         2p62/UUVTOWCYCPLE07IlDYqcZXKc9SitvkZYQK0ovlb+0bAA2NDKY8OY6lBxuQSf6SB
         2eUA==
X-Forwarded-Encrypted: i=1; AHgh+Rrn9h+bj/+rtrSmLn2pz0+rURLQc7JeeOq1yLO9S6leP4lUs2wK8vlx9WpdPoFauq0+htVG07Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxqmf3U7kazJ6fpJ3HdLbGR9/+Kim8Mh6ueqDT+g4Mdo1gsrh8V
	mCHmogiLJfhDtEg023zZRmzm4iQJGoVWPq6lypJ300dc0hevrCG9D61ovixp22HUPQ==
X-Gm-Gg: AR+sD111aW9hs0vMA16PG2kkFj/lgvBnG7S8kKZOu9qINiP1DhwjL69lr3BcQ6tyhMO
	I8v8++DRPek84AkRN8LoPU17jHt9hN57i3oXJHita8Zehu+kGlg6K4zDfPjO4aMfL/fravYFs0m
	vPR+gq5/iGXG3dyLbBcn2zIuCFMetR3OHxQJt2ND5mB3vBAjuzAiQrdvEbytZ9kKksI9K/qabWE
	I8I1IAenfs4Xo/ij0q8P8u0Nq68ZL+eC36XyXjuJ0UZ1uBStIuLSdOrn0jOoPNOXUMtXWOQngOX
	J6nv9Uvez/T8n5bCcxi8Vb8+3jLqjc+lyBo2oX+KlJxiuc7mL7NNIagkkootO8NbrZe5LpZOE3J
	l7DUBlZ4UB54VU2voL9TNsOUeaEU7/rIbQGUsAXaWAN6g49NA2uGIWnMXpAP0u7HpS8P+bXuWNK
	3sbaE7j8VSdIkupItC90PewlPp2zkVWxT/y5XWEnUO2w1DmyewCeOBbDDVB0DNMZ9TRkL+z2ww6
	hNzZUuIb9K9U5yxnUfmhK0PehDhe3oE
X-Received: by 2002:a05:600c:230c:b0:495:3ffd:5e39 with SMTP id 5b1f17b1804b1-4994dc85254mr145915e9.3.1785855014652;
        Tue, 04 Aug 2026 07:50:14 -0700 (PDT)
Received: from google.com (63.235.189.35.bc.googleusercontent.com. [35.189.235.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d74sm181843f8f.17.2026.08.04.07.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:50:14 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:50:10 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@kernel.org, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH 02/14] KVM: arm64: Track host-unmapped MMIO regions in a
 static array
Message-ID: <anH8IuRrbQV67Q4C@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-3-sebastianene@google.com>
 <acJrldyUBXgbvWw4@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acJrldyUBXgbvWw4@google.com>

On Tue, Mar 24, 2026 at 10:46:45AM +0000, Vincent Donnefort wrote:
> On Tue, Mar 10, 2026 at 12:49:21PM +0000, Sebastian Ene wrote:
> > Introduce a registry to track protected MMIO regions that are unmapped
> > from the host stage-2 page tables. These regions are stored in a
> > fixed-size array and their ownership is donated to the hypervisor during
> > initialization to ensure host-exclusion and persistent tracking.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h     | 10 ++++++++++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/setup.c       | 25 +++++++++++++++++++++++++
> >  3 files changed, 38 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index 757076ad4ec9..48ec7d519399 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -17,6 +17,16 @@
> >  
> >  #define HYP_MEMBLOCK_REGIONS 128
> >  
> > +#define PKVM_PROTECTED_REGS_NUM	8
> > +
> > +struct pkvm_protected_reg {
> > +	u64 start_pfn; 
> > +	size_t num_pages; 
> 
> nit: "u64 pfn, u64 nr_pages" to align with everywhere else.

Ack,

> 
> > +};
> > +
> > +extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
> > +extern unsigned int kvm_nvhe_sym(num_protected_reg);
> > +
> >  int pkvm_init_host_vm(struct kvm *kvm);
> >  int pkvm_create_hyp_vm(struct kvm *kvm);
> >  bool pkvm_hyp_vm_is_created(struct kvm *kvm);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 0808367c52e5..7c125836b533 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -23,6 +23,9 @@
> >  
> >  struct host_mmu host_mmu;
> >  
> > +struct pkvm_protected_reg pkvm_protected_regs[PKVM_PROTECTED_REGS_NUM];
> > +unsigned int num_protected_reg;
> > +
> >  static struct hyp_pool host_s2_pool;
> >  
> >  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 90bd014e952f..ad5b96085e1b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -284,6 +284,27 @@ static int fix_hyp_pgtable_refcnt(void)
> >  				&walker);
> >  }
> >  
> > +static int unmap_protected_regions(void)
> > +{
> > +	struct pkvm_protected_reg *reg;
> > +	int i, ret, j = 0;
> > +
> > +	for (i = 0; i < num_protected_reg; i++) {
> > +		reg = &pkvm_protected_regs[i];
> > +		for (j = 0; j < reg->num_pages; j++) {
> > +			ret = __pkvm_host_donate_hyp_mmio(reg->start_pfn + j);
> 
> If this is to make this static at boot, we don't even need __pkvm_host_donate_hyp_mmio()
> 
> We can just map the region early enough in the hypervisor pkvm_create_mappings()
> in recreate_hyp_mappings() and then let fix_host_ownership() do the host
> stage2 unmapping.


I looked at this and tried to implement it this way as you suggest because it is more
elegant but then I realized that `fix_host_ownership_walker` doesn't do
well with MMIO (it returns -EINVAL).

> 
> > +			if (ret)
> > +				goto err_setup;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +err_setup:
> > +	for (j = j - 1; j >= 0; j--)
> > +		__pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
> > +	return ret;
> > +}
> > +
> >  void __noreturn __pkvm_init_finalise(void)
> >  {
> >  	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
> > @@ -324,6 +345,10 @@ void __noreturn __pkvm_init_finalise(void)
> >  	if (ret)
> >  		goto out;
> >  
> > +	ret = unmap_protected_regions();
> > +	if (ret)
> > +		goto out;
> > +
> >  	ret = hyp_ffa_init(ffa_proxy_pages);
> >  	if (ret)
> >  		goto out;
> > -- 
> > 2.53.0.473.g4a7958ca14-goog
> > 

Thanks Sebastian
