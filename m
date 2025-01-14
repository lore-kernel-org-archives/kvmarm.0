Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666FA15B0EC
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867024; cv=none; b=R2p4cSaG5Et6Gj0TiXcHizHHmIGIwFmf+BAGwENpMG69h30UmH+zXqw0ze5FzPcNLO8Um69cKohnIr8saOac788KriW0wLKuPY+3+T7ypbJ2PZGxClOMerVRJVCtQ1YefQUrk3tBxcQTk9mFavJeNlVSVgO/SPqMRoADfmpUpLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867024; c=relaxed/simple;
	bh=L0m2hO5GDz/6RXvIPW29Bm3Papzh/ACjoqWJuz/Pkqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMPREFn9naGaOtzHdVj4svHlaw9ll61/Iqp/eeoY23n6guz5w+GcJHhYsPR0wZIXzqR9k+RsyfMHq2RidTGxQP6Y2lg2pCipt/Lerjfje58wK4yclurFn+L6fLCUq6Ll1IegKXmmL+BzOSpwLn+YCvuW+veQekS0pI33Wco8VyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FuZ1hJun; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FuZ1hJun"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso56485e9.0
        for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 07:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736867021; x=1737471821; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r3uX9sXBfAGLVLkprPT9LjGtR+jH3MZBlHxc/29olV4=;
        b=FuZ1hJunhhD4iyca5EtBj9G5MXvCypW6M6OTQXMvDIBlUpcrjU2FRPR+hnsstKuGdF
         uAr/ZFEO+OcH0gQFWStiAZgbDCyFX16oWMuJZxZKj5wncht2pkvxkbI7/EU+diO/xKlo
         b/n8ciSK7Gkn83Qa6nnh2izR9RxhsnnhJ7GXssYPB7VzTD751193MJNxJgzawnYKydox
         TCd1aewDn16OoNGts4O1KXki2msszg0AzxnXHYmpDb0Mz6GC7IYwiSgdCwOVUJzsHJ6d
         4RRQljvKQ4fPVNWy7z0u20rVx7UhoPwqUG4a/FBNAMtDAz04+sXOcxUh/eJ38M0cZoUk
         pvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736867021; x=1737471821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r3uX9sXBfAGLVLkprPT9LjGtR+jH3MZBlHxc/29olV4=;
        b=ZEoVpEf1epCPu01sPh+gvNypcddOpLH6iUQnU4PrFVktmTuGTc3j4jRDRxue8OIvyh
         U7rU0J0KLVfyX5CLWGSF4k8S4aIII59tIqM9pWP3ksWr4yoRJJoe9Ry9na2SIOTE14XT
         mzaauqLsPU7jrwhFT2mxHqSq/vFYYrKLvAqX0mWuXUpRwd6ZIdPr4p1YwH+wa/seMOTZ
         7eeogfPWtRXgzYs6+KWVbFZFffYLhWxxMD1fW68q8cJVOMQY0pBJbxs7sVT8Kio4bObQ
         KqfyqZam0//c57EkLlIxyM6qDKq9ASZPJcD76w0U0ZY7OWH9b6Hg9yUmJf7MN+6KYiSj
         OoSg==
X-Forwarded-Encrypted: i=1; AJvYcCWoSg2Mc1SYkVLyrYNq+B91JCm0d6h5eUI4pxBJZFTadP/ERA5cV7N40QUODIAuE3fvQ3D0BRA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH3Y3B1fYC9W2Ti5OiVow40TLJ30/F8/Zcijp4JcY2uT6YcsuU
	rRzibD30bgCm9+ks7gRVo3SDE60dNKdQfvfsZH53bC+AoQZmX0fwh+NdsAwsgt8bvWwW0VZFDS3
	VsA==
X-Gm-Gg: ASbGncsUwxzBtDT8d8636vc+GU4V84mL5j/JvG0/OmHFY/sKn1EpcjhAQoXXBNbRXWt
	/Ks6VlHMZXgoMOlsvvlb3G6YGeRgjr6NWgpXN9vzaIVcDLUmPUykz1qrH6I65AoY+113cSLDOPe
	zxMPWg+6N8A0k+Ed9LkBKCyBNGTy156n9N7mr60t30CLg4p/GPIzvi/JNvxK8hfivQLhGXLQliJ
	YuYmyvTZTUMsHykMYFNwIGYMNBA5iQnsGoVJHgDgKK3ToLx2s8Hwpr4H/AziAfIeseyqrLsd8PB
	m/RxvzoB0cQsRzJ9GmNxGPlq
X-Google-Smtp-Source: AGHT+IGYqkoeO9rhW5ofYX5hkCQ3axs1adHzVPrXSPhBirum2F1DdwApMWgQvcwBhmV8s97iNigOAw==
X-Received: by 2002:a05:600c:22d4:b0:434:9fac:3408 with SMTP id 5b1f17b1804b1-4376cbbdea5mr1143785e9.2.1736867020368;
        Tue, 14 Jan 2025 07:03:40 -0800 (PST)
Received: from google.com (47.246.140.34.bc.googleusercontent.com. [34.140.246.47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e37d2f5sm15218121f8f.17.2025.01.14.07.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 07:03:39 -0800 (PST)
Date: Tue, 14 Jan 2025 15:03:37 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Fix the upper limit of the walker range
Message-ID: <Z4Z8yRPGwvqHpzRs@google.com>
References: <20250114145050.563658-2-sebastianene@google.com>
 <86frllwilm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frllwilm.wl-maz@kernel.org>

On Tue, Jan 14, 2025 at 02:55:17PM +0000, Marc Zyngier wrote:
> On Tue, 14 Jan 2025 14:50:51 +0000,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > Prevent the walker from running into weeds when walking an
> > entire address range.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 40bd55966..2ffb5571e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -260,7 +260,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
> >  {
> >  	u32 idx;
> >  	int ret = 0;
> > -	u64 limit = BIT(pgt->ia_bits);
> > +	u64 limit = BIT(pgt->ia_bits) - 1;
> >  
> >  	if (data->addr > limit || data->end > limit)
> >  		return -ERANGE;
> 
> Huh, nice catch. I guess this deserves a
> 
> Fixes: b1e57de62cfb4 ("KVM: arm64: Add stand-alone page-table walker infrastructure")
> Cc: stable@vger.kernel.org
> 
> right?
> 
> 	M.

Hi Marc,

Thanks for the prompt review. Adding the missing bits now and re-spinnig
v2.

> 
> -- 
> Without deviation from the norm, progress is not possible.

Cheers
Sebastian
