Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFCB29B795
	for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789331564; cv=none; b=CDR5Opv3uz+vx/L10i6VOMDOE0x9ZOqpYJM8zGBqCgu5rk1sChG8E/zmjLm3FJkDjQTdTBmKzGajr+VhsuZpiAs2j7xcfmuia0mSbJD3CHWeN+NekxKyb4Ax1IVkGSg31W5eMvKECH/oGYPviC5HpSkEnIlB9x7/GCfBuXmRbBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789331564; c=relaxed/simple;
	bh=+3wvn+LcJLxs9CD5gPyXtjBBE2q6N0M4ucxIJ7iBUQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFbmsrAu6oozXBypLBTjBE8TSJqw6RIrqBohNRr0Mnb3+/R3ZSjWOonmplc6jaFsotf7oDPRbkZQnIO1PO3lbsG5V1HPQu12FaU9EdrZSiCZzGNa4ReR7+Mf/2uD0WVQ8dq58zNm3r2iXok07qS1SUHZYtkMpZWY92UEdkuGwRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VpPXr+xi; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VpPXr+xi"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49e78adf099so2667345e9.2
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 13:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789331561; x=1789936361; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9bQY7Y2h5Bi3Z75l523u4BoMdJvdggKly0nCHimUJnY=;
        b=VpPXr+xiWa/p0u4IPVkaH4wBkzy+c77iF3+R+ntj9WyOkaYKIdi4vKCr2QP9d8xix2
         fP/2f9+fX0wSluMoNyH8LsOIAs3W7QMH7NWg6Q7hFGulCjoI4sbqYvvhDFhYiFK9Nj1P
         fx0cWqIaYrvXDRGRg0wx54mkv0gdLwxwvu89qRk0w90ppXfj7ZI9LLyU8qAMDlK0WO08
         5J6UEPS3VX83RAlaMKn7HvYU0w0xZkYDMAfJa17C1xA9PRV1axE6NYRxKWOEf2VGytUn
         ujP5wB9hBr94VAssmYhy4qr3p4BPoYy9bUGZasshbS5PVnTW4q5K5ARCiZPIgmFXtpeU
         /v+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789331561; x=1789936361;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9bQY7Y2h5Bi3Z75l523u4BoMdJvdggKly0nCHimUJnY=;
        b=D+lsO9HPRAE6v1sSG89OLJp1SMy+PiQGwtnne83eNYfMQ0fYusf40+/2KDoVP/LzYB
         J5P149aOTCF5o8PZnKrWtZUTPNiaYtWeC5Rzon2UwF+WDB2Pm61+eklaEZvtWuPwvE3E
         rWB3qegyuzXuQwqBz4W7GXoAbgRfBeU/LWnRL0Z2UeNGch1BTCq4l9ud1JzP2BTg2brV
         Ev84Fq6XkOy5mJFo+lj9G6ZrR1RqAw9SyVFLM+FEk2O0ZCOroefd1M/ID/7NJsFqqvP1
         /VfHlCmSdFJfmOmBBn1ir3qhFvnVJ9cRe7x+2+TL3sdOXikjL98q5tw1Ac1enjSFx4qD
         v/hQ==
X-Gm-Message-State: AFuF++kqK0FcFgtdueyD6GH8a7w1jIng9LlGFjbxKvNOiP8fsc2/2NJn
	dP7Ljalj/CGpLWBKUOI7cAEC/wHL7CpJYG7lTpDK5KTRqFOdd613zOEbb0ds9kiSUg==
X-Gm-Gg: AYBFou2ltwGVwekkut28twQ/mTMjcDHJV05wQrQT7W6kXbrGinJbwIqtX13lCmfTo6F
	Fj8O9l5VnnurJkyYa6AH3My06oi+haAZixbLqMP8KcPITPouNkew21B4ocxpT85/2Yp3aoW8BUr
	THh9Mk2/UIiYxuQH0FdJ+rEFOrA0kg407H97olT11d6mV7xAd7sJl5SWXZz/buIa6KoMYiJzklE
	lsDcgN+dg3YoExFMtL4u31l0HI+6grnzI2OKjlq9vcDZh5zeKWDNeNpTPkHQqzgdqWUofWlvvJd
	KHm9A5xHy36vJ3EFy11Lr4cYXZIjbHFIVpY6IUpGoRkf+F9B1wsnizZUmGrgPAcxYYntNIkWvSV
	lVTc5HpVoYWSA6HAEztgZ+lYT+BLOkjNJrXuliO72/jlNbGEFQrh+1TNaUdSiYKWLqZetF/mJEg
	kNvfkClUJqw+YmrGCDkzvLxk7rkKPQFu4y/XRH1pNKg/Wwcx5fs4ov13BaLzGXWhJ/vC7AfPII1
	Quu+buCoM3ydmOfhs2bPvMCrl91hji+FHnQnCRlWnqtQ4WnUpaDXZ0=
X-Received: by 2002:a05:600c:1991:b0:49e:663c:c67e with SMTP id 5b1f17b1804b1-49e663cc7cdmr128057815e9.25.1789331560713;
        Sun, 13 Sep 2026 13:32:40 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e69f02e0bsm118285185e9.2.2026.09.13.13.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 13:32:39 -0700 (PDT)
Date: Sun, 13 Sep 2026 21:32:36 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1] KVM: arm64: Fix protected VMs fault on system with
 pages larger than 4K
Message-ID: <aqcIZCglQ2B7LPnH@google.com>
References: <20260913173516.3122436-1-vdonnefort@google.com>
 <20260913175105.A57AC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260913175105.A57AC1F000FF@smtp.kernel.org>

On Sun, Sep 13, 2026 at 05:51:05PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] gmem_abort() passes an unaligned fault_ipa to kvm_pgtable_stage2_map(), which triggers the new -EINVAL check on pKVM hosts.
> --
> 
> commit 724c2b0f8e554f59f7c409467796ff8e9acf590b
> Author: Vincent Donnefort <vdonnefort@google.com>
> Subject: KVM: arm64: Fix protected VMs fault on system with pages larger than 4K
> 
> This commit aligns the fault IPA down to the page size for protected VMs
> in pkvm_mem_abort(), similar to previous fixes for non-protected VMs.
> It also adds a strict page-alignment check to pkvm_pgtable_stage2_map()
> which returns -EINVAL if the address, size, or physical address are unaligned.
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 8e4c6e4bec123..1ca27d01a3ec6 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  	u64 end = addr + size;
> >  	int ret;
> >  
> > +	if (!PAGE_ALIGNED(addr | size | phys))
> > +		return -EINVAL;
> > +
> 
> [Severity: High]
> Does this new check break non-protected VMs using guest_memfd on a pKVM host?
> 
> When gmem_abort() handles page faults for guest_memfd slots, it passes
> s2fd->fault_ipa directly to kvm_pgtable_stage2_map() without aligning it
> down to the page size:
> 
> arch/arm64/kvm/mmu.c:gmem_abort() {
>     ...
> 	} else {
> 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa,
> 							 PAGE_SIZE,
> 							 __pfn_to_phys(pfn),
> 							 prot, memcache, flags);
> 	}
>     ...
> }

Ha right...

And actually I will do gfn_to_gpa(gfn)... that fits better the series I have
sent for the protected VM huge pages.

-- 
Vincent

> 
> Since HPFAR_EL2 only aligns to 4K, on a 16K or 64K page host, the fault_ipa
> passed from gmem_abort() will fail this new PAGE_ALIGNED check and return
> -EINVAL. This prevents memory mapping and causes the VM fault handling to
> abort.
> 
> Should gmem_abort() also be updated to apply ALIGN_DOWN to s2fd->fault_ipa,
> just like pkvm_mem_abort() was fixed in this patch?
> 
> >  	lockdep_assert_held_write(&kvm->mmu_lock);
> >  	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260913173516.3122436-1-vdonnefort@google.com?part=1
