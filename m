Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1032725FA09
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 09:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741857399; cv=none; b=mF91R3OJfkRSN+/Y3yeLzT/I9h1hEOXRVWmlTORcmq21buvOct7ESsXEKMAoDIgYHcC29HrQ4UZzktoZYAa0ddfypRdmG6KgGy9Qzu6oyjYwlTI1njB7sWVmDiGgU57UxCO+PNGU/qr38cxmy9V+zia5GspFYo6TwJJ4oN248sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741857399; c=relaxed/simple;
	bh=vnGU6xsEnDEuWbgq4Zq5jcvdO7OIoOn4KRQG+0RDXz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muizIOEhkEtnwwpx/c1xsdwfaymath+Xu9MuJhckaKk/yO49LYH3pCTMMOF+Hu1X3GUNchYQyVmEQz3A11vgV3xU/rR6ZdlBmbbdsPKYeWTfOhqS41iVwwmX3sZ5l/2cuMMqhQXQ+Db+YV9z6zS9D2RSrLbve7u5gkRZYJOmKjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ehmn3cfd; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ehmn3cfd"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3914aba1ce4so547763f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 02:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741857395; x=1742462195; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxWaN40Gu0y4wmPgUEJqr+nQuSXPrmjIwZFj0rXa2nA=;
        b=ehmn3cfduCPOv1hXDebi4N8Yk4JyIVxq2eDmJsu3i7XPQr9TrwobVIBaXcstOgEjI5
         3aNLnlelAnUPSjsL2dRMnES24gUa8QI3aUuk3Es8hrLPOMmA8UauaETfU4wKPqdFuC6n
         Gx4blr4JsmKgiUFZSK+a/bs09REQTPkDTNs7pFP+qSpu/kO2/0O8mrbDrCuUHCuFZpRx
         bht3Kbt8yxJy/50MmjTRzwgNp4WFIfD5fl3dALs3qVm14YsNmNHIu6H/zq44VO/TdaT5
         yc5i6jwxKYdMHBngZ74HX6iP+PehLNH4D7/UFLMRVQ5tNbxk0ZkFn7Y9rjM8dW9oTMnW
         qhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741857395; x=1742462195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxWaN40Gu0y4wmPgUEJqr+nQuSXPrmjIwZFj0rXa2nA=;
        b=LRMpDKHoISMD420XUnBY2zKuTs/BPA6QVL30RNZb/ybNzVsmgYBKUvEPd3Y0bd0qO6
         5cWo0wbSxfUmYwVVLbSpIbLOLHO10zEtJfm7us7VxWNQOf3vKCWaNhML6XuVC+st1k9n
         uukljygVzJ0Uhr+sbyWH+MY6FsUJxqpqgkv0uewnYGShhz6e6cuiSByxXcTKJvOQ9Gg9
         dHhxAN7mRfGX9FIu/pRsurxiVK1fPxkMhJuCQvijfE/ZBLBUWCCq/LQ/nkGCamiLWsXQ
         lEFIR3ETGAr9TZBEeImg2lEI9fywDTthGFNDBoDoC33iVQr8n2ga2cYBn+p4ApPHBUkX
         i3Yg==
X-Forwarded-Encrypted: i=1; AJvYcCUAfQ2SJczEBPsVQ6z4qzTvCpgI/kx04Xm5odUnsguKvO9AOQDj2C0d63Po4yJVG6hNhsZoIKw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxls+RdYiMdhxo8Ti4VRYBSRf3rOnd7R7P6a+ByLC3d9ncaQCB2
	Vby3Xw+Vo2S4iyPhBe+LqMLkBT3QDp5SyvFzqgGIY2mq1RYPMMTWBYKArKF4DA==
X-Gm-Gg: ASbGncvWOkHL4drZI1OYQCQyvhk8ZbeAt4f2oif8NN+5gat/Ss7g7LlZ//96bCLhoa7
	sMRgtiKwLgUqXkFjebOKU+WwASxWvqLozFFLWO9t1feDjUvQfNgDQ8LPFc4LJSGDkAKD4qna/aQ
	PGfE+FCl/utrqF2m4/PpsbElH4S0bu2Cko2RJ5VhmVvDZpUtR1rqrcKJNMzOVwIXuT99Cw1QpDp
	4e5+c7foG38X1aompuzD0NgdBv0hkPMufTnrcugTc9I+yVBrCtuxVCCERcmcaHBKebTjp+uurO7
	GYYLbqdxDiCxoVSBJt2frMBwlwMzIaVR+j3yOibBxNzzV/w3P1/psnf767BdFBaRkCvlavwjWge
	8i2c7ccQKqJ1N
X-Google-Smtp-Source: AGHT+IHyTZmg9ER74S1drTjoF85PA6dZOdC3TWCeZ2nKybqjldE81KW9q1fSH09TLkfQNscM9Dnofg==
X-Received: by 2002:a5d:5f45:0:b0:38d:ca55:76c3 with SMTP id ffacd0b85a97d-39132d2ac3amr18093999f8f.11.1741857394994;
        Thu, 13 Mar 2025 02:16:34 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7eb8c2sm1397573f8f.85.2025.03.13.02.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 02:16:34 -0700 (PDT)
Date: Thu, 13 Mar 2025 09:16:30 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v3 1/3] KVM: arm64: Add flags to kvm_hyp_memcache
Message-ID: <Z9KiboTJy9A6qvbK@google.com>
References: <20250307113411.469018-1-vdonnefort@google.com>
 <20250307113411.469018-2-vdonnefort@google.com>
 <87r0327iek.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0327iek.wl-maz@kernel.org>

[...]

> > @@ -1102,7 +1102,7 @@ void free_hyp_memcache(struct kvm_hyp_memcache *mc)
> >  		return;
> >  
> >  	kfree(mc->mapping);
> > -	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, NULL);
> > +	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, (void *)mc);
> 
> Why the cast? It looks superfluous to me.

Ha yes it is now I pass mc and not mc->flags.

> 
> >  }
> >  
> >  int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
> > @@ -1117,7 +1117,7 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
> >  	}
> >  
> >  	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
> > -				    kvm_host_pa, NULL);
> > +				    kvm_host_pa, (void *)mc);
> 
> Same here.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
