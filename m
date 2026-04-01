Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3457431E848
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775012497; cv=none; b=CGltSNVBFSHfvwM6lGj2SII8f2KtgRuyQk1ZsKKv8aujkYC/PUgbD2j54A6J7saImiXNauCjbDhXCH5ZQM14OBA7yhNsvlOgrsP+jwK4BJJ93qDxenlNk5QhxsToL8S9erGkokouowWWu4y6FQoKhkAsg6WxDlBl8viVP3MIeiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775012497; c=relaxed/simple;
	bh=ckPkDolwtt/HMixMNBfum3Ujevylij8wrK9B13Bpq9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7x/eFkKTO6m6F7JZXymzVmxe2GLbJ3shsHCQuooUfF6SAtInUngBiHXgwvH0txejgPH251o1wLVWWiW0NayjWSB2eKBAEw6NT873uFBFJVNYVpi7/5y5Q3IUYYLXlBcG5h6CbJOKD8Uqt2Y4zsRd20M8BNeRSHkhN/ZlO1bJwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kNxkPD4m; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kNxkPD4m"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4887fd35e60so7084225e9.2
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 20:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775012490; x=1775617290; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAhQRpBpSmCBJe7SZDFc/utVWYKkz+s/X4+iBM+yncU=;
        b=kNxkPD4mPUVugA1nSwOjN8ny1TUFaJAN2bGTNhMHqA55KEE/8xeV6h1oBXQVukcmzF
         bfpYfkZDMHF5Pkm+UUdrIBIjnUSInThcJtH+4lcrUYJcc+L9IeGKAvYaOJA3rdo7bp/R
         IP7xbvpriB2Zvz5dg+NVnV3Qs7nGroM8UeWUCaKaLaHB0OCbhVam7qTjFpTMqPN+KV2S
         4FUGPCeAKBUHN9hNFC7PEOx7UAJRW0ixusac//sog+QncciKzmIdBsH+eJZZNQHvBE4Z
         ZEI1h1Fh6IF+cgwDvBQQU2sGeEHV6hACebrHR0cLj6maKt1xXGso+jYaFfUqAPG80ZfX
         ZYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775012490; x=1775617290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pAhQRpBpSmCBJe7SZDFc/utVWYKkz+s/X4+iBM+yncU=;
        b=bWeqVdI7wETl+60eJs1jobfGc7FqpZITtkndt6d/Uy6Q+lJdg5zMcOmTSW6HddOwc9
         tZQBEpRzBdLtGlhVFkRxFVEKkLSlSoi4T1PeocJ8vztxDS0iliH+U11SRYa0S7IEpjZs
         bAZ3DLzkmsbeftDukii4w20aOlg1jKIBA00Rc+RuRb0M/OjmwjlMNzAWmZ8WhxW9cXwx
         0mN6fxwmFjbpz7qXF63NlFFgMwWaqbfGABHVW23foCOSnKKYkEb99K2v/QF9YrX8H4X9
         4WGSUkhcV6DoRyk+2zFYl18gSyUXhtCW/yL5AKreO2dZKXlbOL2h/ydtvF0PjSgB5FWZ
         bgPA==
X-Forwarded-Encrypted: i=1; AJvYcCUNAK6+9Q54ejebN7xaIDdSak40qlIRfxetsBe1wdG2Iw0b8Z829v4nDSd78jz9Uvm1GrSzBH4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywrmg7AqPe9vcfuvMTpKPJwnCvgCb6ovETEsTSTaEJrUHuXlXiC
	ivhwDgC5XiPTbtKKV4Wm5SSGz+AP91pgBvuaaPY1OeVbKc6LYZahDShoFDHdkA/trA==
X-Gm-Gg: ATEYQzxqxbc3gI2i7JDNPWHfanCRfua3f3gOgrl+oiasefroUx72fSdVhdXVI3Tbik7
	GmPqlYmacVZByxRETyaFIMq5TAFVpGt5q2LvzZPTJd4EU1Unw3JmninMl9ywGGyAoXXhXToEUX/
	oZadVCpbbDBZgANXDyb+nLk00IC9TIl0nSJqgyK6t+ZgVlhABsPeJg0GMMhxzEGNPoLzsfFhqmi
	kw9VPDG1rPUJ1u58Jz9x4XvFK++areoq3nBcGA23aWBvW/cKMSBrrMf6MGRu0bBvbu3ULSJtPfh
	FOv9Mx2QZdDCOXJbFeupFd68f8jjG2tUV3MN1VVd1RTndNk9c5rPnmn68Jxh3PNmuBWPcAcr2OP
	Q672vQZ/iUpeTW7ACpzb6dUqZLG+TJEGPt2UIkJjnVaJRECY4AdrXmj7AW+v2CAsgwIGUgzHpo7
	y8l7C/oBMoa57a6iCgy8qkT4FvVp/E4Koa/igDP227fkD8T/MMPmfBUyRKDRopDDqEaeA4nSmdS
	g3Nzw==
X-Received: by 2002:a05:600c:c178:b0:486:f8e9:add5 with SMTP id 5b1f17b1804b1-48883591777mr27188255e9.19.1775012489318;
        Tue, 31 Mar 2026 20:01:29 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e80140esm76029395e9.4.2026.03.31.20.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 20:01:28 -0700 (PDT)
Date: Wed, 1 Apr 2026 04:01:25 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: pkvm: Rollback refcount on hyp share/unshare
 error
Message-ID: <acyKhZL2di_QQ9xm@google.com>
References: <20260324172757.2147153-1-vdonnefort@google.com>
 <acpCq1qZCMFqocs3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acpCq1qZCMFqocs3@google.com>

On Mon, Mar 30, 2026 at 09:41:01AM +0000, Quentin Perret wrote:
> Hey Vincent,
> 
> On Tuesday 24 Mar 2026 at 17:27:57 (+0000), Vincent Donnefort wrote:
> > If one of the HVC __pkvm_host_share_hyp or __pkvm_host_unshare_hyp fails,
> > rollback the refcount to ensure the hyp_shared_pfns tracking reflects
> > the actual sharing status.
> 
> If any of these hypercalls fail I think we're still in trouble as
> kvm_{un}share_hyp() work on multi-page ranges and we could leak pages in
> a borked state if we fail halfway through. And failing any of these
> hypercalls is also sign of a bigger problem somewhere else so I wasn't
> too worried.

Yes, my bad, I haven't made that clear in the commit message: a failed HVC
right now is very much unlikely. I meant more to future proof and this isn't
fixing an existing corner case. 

> 
> But if we're going to fix this properly, I'd suggest also improving the
> error handling in kvm_share_hyp(). 'Fixing' kvm_unshare_hyp() is a bit
> harder because we must tell the caller to leak the data structure that
> was shared I presume, so maybe we just keep the WARN and cross our
> fingers :)

ack

> 
> Cheers,
> Quentin
> 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 17d64a1e11e5..0fb41d2c8b44 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -493,11 +493,17 @@ static int share_pfn_hyp(u64 pfn)
> >  		goto unlock;
> >  	}
> >  
> > +	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
> > +	if (ret) {
> > +		kfree(this);
> > +		goto unlock;
> > +	}
> > +
> >  	this->pfn = pfn;
> >  	this->count = 1;
> >  	rb_link_node(&this->node, parent, node);
> >  	rb_insert_color(&this->node, &hyp_shared_pfns);
> > -	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
> > +
> >  unlock:
> >  	mutex_unlock(&hyp_shared_pfns_lock);
> >  
> > @@ -521,9 +527,15 @@ static int unshare_pfn_hyp(u64 pfn)
> >  	if (this->count)
> >  		goto unlock;
> >  
> > +	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
> > +	if (ret) {
> > +		this->count++;
> > +		goto unlock;
> > +	}
> > +
> >  	rb_erase(&this->node, &hyp_shared_pfns);
> >  	kfree(this);
> > -	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
> > +
> >  unlock:
> >  	mutex_unlock(&hyp_shared_pfns_lock);
> >  
> > 
> > base-commit: c369299895a591d96745d6492d4888259b004a9e
> > -- 
> > 2.53.0.1018.g2bb0e51243-goog
> > 
