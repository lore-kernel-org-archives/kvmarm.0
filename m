Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D93432BC1
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787588618; cv=none; b=P1cJ/gDg7BI8rvJCTOtT1uKF21BTgxcPNMKe1m8r1YOvCYWgl6DF96/AdrqMpBQjFA53A2JHmsbp7Mlz+x3G1vtcVvoV5j/Y1T4nkp4nAHFxICKqP07pbV/bMyzaDRqsTDZmjEgtGWOJ59ADWBZYB+3rlL9Moe8CFdiFfm1uCjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787588618; c=relaxed/simple;
	bh=CVqShdwopWXthWP5NpoVBSsEeKneG1zYbLGVXGy/2xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEs/U2bOuK8Qi2B4Hx04wqAc3zVCdoSw44VUtn4dcs8fOXVPd6/nEkTlYCyJrNCQc+B1hXy1DKV3HwonHe98NE0rNze1nfE2GkkUSwIPozHdbY3wsFGCSzSSkhIe4OBW0FKrYT6V1iwiGn+8i+aZDw80O7zY4RKCJNoQzg0s8tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j1TFoAqL; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j1TFoAqL"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47de0093c42so2911317f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 09:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787588615; x=1788193415; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IO0g4mIiXj10EzMo2R/KDJ9Eie2fuSqpmAU+xz/5e2k=;
        b=j1TFoAqLbpPAtpccer+hvOSuoCTuSzEvfg/E12bSlmVmeqK4Xd2NukoCLcnLhfTLUI
         M82MZVXR3wFdVh1SkIWeNn3coybl8BAFl9vPfTZQ4f9o/lGvoJye3DAytTmK1ZA4VUgD
         dfv6DSWmnYZahE3IWgmPGRCE0874KsPsQEBf/+7zKUthRwo/EJObsjippTEkRho6inkL
         rab9XhSr+RrUMSsMxuPmYr6ZAVxKsD7kILVkN5c2CuwAiaIuXSCN6A6KV6r1ZwiqKkIa
         kERfuM7Oux2ereD1BSi0AN94bWZLkgQn+GgGyO8yhJY20WsUnm1CY2o09ov2gTDuhiGB
         kAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787588615; x=1788193415;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IO0g4mIiXj10EzMo2R/KDJ9Eie2fuSqpmAU+xz/5e2k=;
        b=BypGKLmTIhq0UtzHu3y8EymEzvhY5OlxfhjI4vpGFXwOJtcC5+efqjHn0dhHqJNdhp
         wHUfFPxpmHe0ycyucWCgabecRqko1IkDsqRaQ3TJA02OsegGgc3k8w+KebKz9DN5KMXZ
         TKhrlP4+8OC0C78vm6i78d/W1Abqqez10iNyrR9Z7mR4juH6oGA3cm2heiQ5OcebnR8p
         eoki0x2UTBrxpXLeFr9lTMIOnXngaGqPlD9NtmmRwmcdj81AjeiZC7QgGauG1/2g5EA+
         MyO5n5rWJT0SDqixZoDs4gLO1pbOvjtgg0EtdeK8gqvHgXfc6OKCALULcklOMeB6cMWR
         FrPg==
X-Forwarded-Encrypted: i=1; AHgh+Rr82ADuCNKSYbSNGmJkZ2QAFBP3vs16HxDMq/V99i987oqShPUR3sREHoFywbMQKTOtn5/O+YA=@lists.linux.dev
X-Gm-Message-State: AFuF++mBVsTAVXhY+ilRj1eoBvBGvvV+GL8alZwrZFliwfL/rLNJGN0V
	MBul1rgpTcejS8Au93MlL61YmXzenV+eSyC8J4UOCCxgr/GHIthmIJ57cOl7OdsK5w==
X-Gm-Gg: AR+sD12t6KgXruerlKLikwd5MRTNhCk6FhQTxldr8VkCXxO8mgVNeqk34otelf4hTyM
	YZebek8Zir0WqaKcf1m28mhGtK+TBIF/8lvodembIhp4B8cZ06NWhszEuNwItmy/9+YSGX6RIJo
	/BnDsQRljTLFtA006U7rhOFSkkiP7HFOL6NCK8RGmkJEt+1FOHm8EV1m6np6Jzs18iDzGJjaAbZ
	uQv0W2Ho5vd1uhUVtkGDNVyAsvIruOo8vaMLHn2e1cxP8lIs+8DHZodqDK/okqYw/0tWaSYpBEN
	SgsISROFothAixJTOX9shnDijyR0DTCRoAVdQ91M0Kj6URTcR3uWKnicUYp0sibsrgdH+PVSZpw
	LXZ3WTKK3KQZOQOSAEzKXEyP1AcXdw+mPq3Ihu67te7VARRtJuxDdrMgzuaSgd2KpYFqxVgvqD0
	9auoA5tOkuv9OHfqJcUam9ornD/ox9O7JuCBzXGQABK3+uAaEfDzQOTiInCeeDBj9X+sRCn/MRN
	vuegYu5HkxQka/OqZGW5dGqrwRBMfnY
X-Received: by 2002:a05:6000:22c2:b0:47f:d011:f644 with SMTP id ffacd0b85a97d-482c0b54606mr34306523f8f.4.1787588614220;
        Mon, 24 Aug 2026 09:23:34 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482c9b69a49sm8579616f8f.7.2026.08.24.09.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 09:23:33 -0700 (PDT)
Date: Mon, 24 Aug 2026 17:23:30 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v4 09/17] KVM: arm64: Add selftests for the pKVM heap
 allocator
Message-ID: <aoxwAukYucNw1T2p@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-10-vdonnefort@google.com>
 <CA+EHjTy7SUFsE3N5ERV_FQw-3GyEo17mqe2=RbV1wz8bVT+JXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTy7SUFsE3N5ERV_FQw-3GyEo17mqe2=RbV1wz8bVT+JXw@mail.gmail.com>

[...]

> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 346365e76ef2..d99c9b1b0c82 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -633,6 +633,28 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
> >         cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
> >  }
> >
> > +#ifdef CONFIG_NVHE_EL2_DEBUG
> > +static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
> > +{
> > +       struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
> > +       int ret;
> > +
> > +       ret = hyp_allocator_selftest();
> > +       if (ret == -ENOMEM) {
> > +               req.type = PKVM_HYP_REQ_HYP_ALLOC_SELFTEST;
> > +               req.mem.nr_pages = hyp_alloc_selftest_topup_needed();
> > +       }
> > +
> > +       cpu_reg(host_ctxt, 1) = ret;
> > +       pkvm_hyp_req_to_smccc(host_ctxt, &req);
> > +}
> > +#else
> > +static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
> > +{
> > +       cpu_reg(host_ctxt, 1) = -EPERM;
> > +}
> > +#endif
> 
> My tag stands, but thought about this while going through Sashiko's reviews.
> 
> The other arm writes x2 through pkvm_hyp_req_to_smccc(), this one does
> not, and -EPERM is an error so pkvm_call_hyp_req() goes and decodes
> x2. Nothing initialises it on a call with no arguments.
> 
> It is inert because pkvm_selftests() sits behind the same #ifdef, but
> the handler is registered either way and nothing states the rule.
> errno_to_smccc(-EPERM, host_ctxt) here would write the zero, and it
> may be worth saying on pkvm_call_hyp_req() that any handler reached
> through it has to set x2.
> 
> Cheers,
> /fuad

Clearly not something that would happen but I can put the #ifdef inside
handle___pkvm_hyp_alloc_selftest() so it looks cleaner:

  static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
  {
          struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
          int ret = -EPERM;

  #ifdef CONFIG_NVHE_EL2_DEBUG
          ret = hyp_allocator_selftest();
          if (ret == -ENOMEM) {
                  req.type = PKVM_HYP_REQ_HYP_ALLOC_SELFTEST;
                  req.mem.nr_pages = hyp_alloc_selftest_topup_needed();
          }
  #endif
          cpu_reg(host_ctxt, 1) = ret;
          pkvm_hyp_req_to_smccc(host_ctxt, &req);
  }

Regarding pkvm_call_hyp_req(), how about a proper kerneldoc?

 /**
  * pkvm_call_hyp_req() - Issue an HVC that can return hypervisor requests
  * @f: Hypervisor function symbol to call.
  * @...: Arguments to pass to the hypercall.
  *
  * Re-issue an HVC and process any pending hypervisor request until completion
  * or error.
  *
  * Only use this helper for HVCs whose hypervisor handlers format their return
  * registers with pkvm_hyp_req_to_smccc().
  *
  * Return: Result of the hypercall or a negative error if the hyp request
  * handling failed.
  */

-- 
Vincent

