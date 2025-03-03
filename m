Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B239F1EF370
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 09:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740992938; cv=none; b=aYLe4VElYarByaVbDcR4fHLv0BhtV7+v8/51cyoGU1vgXP/wzrvb2owlOgT7vLK5nkQYMhdYLYtw5KybU+V1Ur1dON6dwmQw5HD77aJ2fKoKDEWv//tE3/+Us9iP4jeigj/hXDARCH2WdOICT4rw4wKhT8k3u/+mhYR1O4119Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740992938; c=relaxed/simple;
	bh=5qkLkijq1aHVBAJe+pKnmmcboRU43L52rr+dVfewpTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WIcJgsDboe8UUn2XknllOzP9JnO9sFPEcS0hCvbegMU8Le3C5+drPt7Tn5gujQJQ3Et4YjrHJuRd/tHcOk2Fwz/hPzhAJF+55Yg2uLLFr+KOzxc21/c25Xr2VdwP0tyCQKRkqL4iTu28j57OcpitKEoKrDbFzsv9ubQB/5IU05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iUZpmqDB; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iUZpmqDB"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38dcac27bcbso3535296f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 01:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740992935; x=1741597735; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=73r+pPBFPmA5vexT3Ec5rGd49/E5Soa5Y1/Qzc7kIO4=;
        b=iUZpmqDB0WHVSlNczOIp8ukDSyLkVv+P+nqfWd4QIYFpxafQAksdvO/2HohMCHOMIU
         JdAO8ikTJlgu1N2DTLIukO1VeRB6LpnGu4nPzlR2bJr6YsgtvdshjJHifI4tfZptRdal
         MQYzCeR73zmTASRJ2iT8WIXkCzp4Uzuj67tekyTZyrsvidGJp9KUaUASBLt9gmBhTEUF
         zeDmkJR/JzraChgog8O8RfvETNa+4693js9aoUgtGZojANW368zwtLhVJkzuuVOK2WFh
         6+A1LwIdZx4knmqGJztTScUnDPieOYfYs4RFkLsCzbF8oVtPxgav+ZEiOoz/GQ3oLC4C
         5nxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740992935; x=1741597735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73r+pPBFPmA5vexT3Ec5rGd49/E5Soa5Y1/Qzc7kIO4=;
        b=Ry8xJRCvux56tYRj0P4keaYdisfAB5OHUBCwknoVu3KJFVokJTtnhhAHgc+VTH6jOZ
         5Mmhz5G6kcDEaDixhGBTzHhPyij2SKxD1Amk5qe0+mpRpgF30ihs8Ev4wgrzdp+wKdPw
         PyfX6DbR15upPTaaHdQvwuzGTkhhnaNhjHqQ4IU5HTfOa0EX44WEMYZggFj5565DF1M8
         plPW3XuHncaprclSZ+U61oQsWlxDhutbn/1E+yB7WNb67v/72l2kV0mByegx3p8BUo02
         2Ar2rYxocGC/gowT+Vje/6R7r02hWevmIqgCOKEw8wSKrVASukOXJMQQTJrQ+SKLdTHv
         5/AQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4FrdPUZhu3C45WX4mPacLz9nVfFacsDlx5ZmUOkXjj2mQKyOn4vH0g8he4yH/+9kcU1ykHIw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaVuXsMy3dslwH2lsCQW0Xxo5NgMrInHrJSao1k4CooEjImp5F
	CPgxowJsJPCyuc77M5MuBiy34UJXHEiwUZaKnWFVHDalOUAkYmXVfUWVEc3PgA==
X-Gm-Gg: ASbGncsAcK7U5WbFi7BRW8ZXRJXv/NZZm9TeEFb0XK15sgY/do0ByjhDkaaSeG/50p6
	Vm5m3pGEoaZa1jVykazNWaICdCd5u2PHSAswgBb1rag8viZVGOadRxf8iCMJq+bZCDblatR2pWG
	Sx4/JQIyEwrta+egBtM9KdSai5XlqexdRBxJHU7NDlaqosd00g7kyfTZucXgO+joTKEBJUgEoU3
	pW4BElI/a250FawbdaTd8xBJKIjgvsg12VIi+4312owlrVwxtN6I1b2YniA+9/4b+AutEzX7o/S
	iKQE6YzWyoN83HS1mwLC4fsY/IqxDQ6TRjzvI/RN2smNWq8Rz7XAgKsrclDkkYeXPzuJNJxu6K5
	89aKK8Q3K229V
X-Google-Smtp-Source: AGHT+IFulJGyYMQXTykjX7NCa+Iy43Ll73kEXzRosIE/q2QvgywumoNWk3nbePvrLXe4q9Ef14rB/g==
X-Received: by 2002:a5d:64cf:0:b0:38d:b12f:60d1 with SMTP id ffacd0b85a97d-390ec16ad09mr11136503f8f.26.1740992934969;
        Mon, 03 Mar 2025 01:08:54 -0800 (PST)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b7a73sm14106715f8f.50.2025.03.03.01.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 01:08:54 -0800 (PST)
Date: Mon, 3 Mar 2025 09:08:50 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 1/9] KVM: arm64: Handle huge mappings for np-guest CMOs
Message-ID: <Z8VxotNAW9CLogum@google.com>
References: <20250228102530.1229089-1-vdonnefort@google.com>
 <20250228102530.1229089-2-vdonnefort@google.com>
 <Z8IGcA6h6hZx7ujh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8IGcA6h6hZx7ujh@google.com>

On Fri, Feb 28, 2025 at 06:54:40PM +0000, Quentin Perret wrote:
> On Friday 28 Feb 2025 at 10:25:17 (+0000), Vincent Donnefort wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 19c3c631708c..a796e257c41f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -219,14 +219,24 @@ static void guest_s2_put_page(void *addr)
> >  
> >  static void clean_dcache_guest_page(void *va, size_t size)
> >  {
> > -	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
> > -	hyp_fixmap_unmap();
> > +	while (size) {
> 
> Nit: not a problem at the moment, but this makes me mildly worried if
> size ever became non-page-aligned, could we make the code robust to
> that?

The fixmap doesn't handle !ALIGNED adresses. (I have a patch in the tracing
series to cover that though). So wonder if that really makes sense to handle
unaligned size while it wouldn't work with unaligned va anyway?

Perhaps just a WARN_ON() then?

> 
> > +		__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
> > +					  PAGE_SIZE);
> > +		hyp_fixmap_unmap();
> > +		va += PAGE_SIZE;
> > +		size -= PAGE_SIZE;
> > +	}
> >  }
> >  
> >  static void invalidate_icache_guest_page(void *va, size_t size)
> >  {
> > -	__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
> > -	hyp_fixmap_unmap();
> > +	while (size) {
> > +		__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
> > +					       PAGE_SIZE);
> > +		hyp_fixmap_unmap();
> > +		va += PAGE_SIZE;
> > +		size -= PAGE_SIZE;
> > +	}
> >  }
> >  
> >  int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
> > -- 
> > 2.48.1.711.g2feabab25a-goog
> > 
