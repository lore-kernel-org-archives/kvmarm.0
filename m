Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDFF176255
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 07:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725866179; cv=none; b=Vn+dJz5vK+ImnNf05BHkoWGhe6L2Q6OIP7kY9C8tnx79+JPzby/3G2kFlqxz6UThyhPJo9xEJcB2zHY4+2KZZ4H49M00xfJD372F7JLmZWKJiwsy29349hYWnin8Ucb4FFLjirKXpGKN8yzlZFDji/EiizEZdD52wGrc8yvMUtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725866179; c=relaxed/simple;
	bh=BjXsP4Mp690AnYXVBtGi2BkMgGrtsmKJ2olHdnk1un4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7whLbCxL7DiOsKoMmPGNFsjGUJuaEN2dmDpSAKzr4eKO4jGtop5tD1gnRER7ZUmACPEaSrTLC0wbNMp9gYOMGITWrqq64FC+E7o7SZHiu1xAV0CuVBMiBtppgffVudTNL696BQKZyVD3S0R11t8vToj8BZMblVx4uyI5pwQUM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2QIrjbXA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2QIrjbXA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42ba8928f1dso58035e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 00:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725866176; x=1726470976; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VftkMC5+mYm3QQ3dWBsLEgURQE/0zJC3ZLx2ECmB1zs=;
        b=2QIrjbXAPwo8JkH/ccp1ohGK//PKQnoWvvYXv6mDJP8vqaZsrGu3NdE7qIG1s1Dod4
         JOciXdVbLGOGf+9//SbrERiuD6awsky9XBAH/cLi8OAgiYeqUuXfquq0ZYejC8bTkTKU
         MXuZ3uQ7Wv+sjM3MZEhJ46LDGq61MZfDgugWEZ1nWo1tcWO7ASR7OsNeSWyzpkghzjIk
         IBk7rjya4NSpgpeXIy0rKyN62XzEQcYc2QRx1gQbwIOw4tAYV1hXW15u/GNfAQhfvJDa
         Utvp1nN3inO6Agmz7KvZWnN2vRFoCFswlpSFuZtm/2jjCyhkcbpRPJEaFucWvF+W1wpu
         vZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725866176; x=1726470976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VftkMC5+mYm3QQ3dWBsLEgURQE/0zJC3ZLx2ECmB1zs=;
        b=w5Em85hqSig6Cf9WtXTWKB1QYjVzUW02FfI/N75yu/UhsmDEJYwPhHNFicbsAuHB1R
         TTNKPuZz5NsGs8/espooPHyxD5xiUFa3KO2ZPoxlp+Fd5b6MBiks2StEjOhT04QP+gKL
         U/D9eWUUzKDRVXIddZIIzD38pyTFnsJA+eiVVJhfWHbpbmJo3ir4K4j9yyL/xvfSBfKp
         EiOtfMey1Mkjl8Y2jq32e2aaP+tj+BqGn4hHqnZqUDAYcMN2/99AyO3BNWjp6zaSViYI
         cVed4tLajAdSa4oO5eAiIXe+fnTAaRLQLRX4mqePQKz6k0Fxz5YmhXp7LmUbdApTh9S7
         zjCg==
X-Forwarded-Encrypted: i=1; AJvYcCWAfLdSn76ep710fwxmzy0XpAMTMUtizTfqF12SDoKD70JHo5nwN1Ye/b25TeY9VcwfYdUsBIU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+C1ngz9/4k1I6sp3itV2uQATDlLytAjw1fw8aZcOK9aNYLtMw
	Y+svlgR4KDaZ9R0SWIXDHpfexRPxYLKSenXHx2rVWu+Gul0WpIx0CHKp5jsC1g==
X-Google-Smtp-Source: AGHT+IGOIkTSaWnXjE2bwYgTX4o/x860SYJOr8Q/IVHIUjLL5fLSHy00YIBudEH8NGk3Gpb6Mxcv4g==
X-Received: by 2002:a05:600c:3d17:b0:426:68ce:c97a with SMTP id 5b1f17b1804b1-42cae4bc174mr1825485e9.7.1725866175872;
        Mon, 09 Sep 2024 00:16:15 -0700 (PDT)
Received: from google.com (93.20.140.34.bc.googleusercontent.com. [34.140.20.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caf33e9b2sm65999675e9.14.2024.09.09.00.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 00:16:15 -0700 (PDT)
Date: Mon, 9 Sep 2024 07:16:13 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Snehal Koukuntla <snehalreddy@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Add memory length checks before it is xfered
Message-ID: <Zt6gvd4NwMmjS8JB@google.com>
References: <20240906092732.113152-1-snehalreddy@google.com>
 <86ed5wvixw.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ed5wvixw.wl-maz@kernel.org>

On Fri, Sep 06, 2024 at 05:35:39PM +0100, Marc Zyngier wrote:

Hi,

> Hi Snehal,
> 
> On Fri, 06 Sep 2024 10:27:32 +0100,
> Snehal Koukuntla <snehalreddy@google.com> wrote:
> > 
> > From: Snehal <snehalreddy@google.com>
> > 
> > Check size during allocation to fix discrepancy in memory reclaim path.
> > Currently only happens during memory reclaim, inconsistent with mem_xfer
> 
> Can you please elaborate? It doesn't seem to fail at allocation time
> here, as everything is pre-allocated. Some context would greatly help,
> as my FFA-foo is as basic as it gets (I did read the spec once and ran
> away screaming).
> 

Right, I think what happens is that we use the fragmentation API to
transfer memory to Trustzone that normally won't fit on the reclaim path
where we use an auxiliary buffer to store the descriptors.

All the descriptors are identified by the same handle and the reclaim
will try to store them into the ffa_desc_buf before nuking the FF-A
annotation from the stage-2.

> >
> > Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
> 
> The From: and Signed-off-by: tags do not match. You may want to add a
> [user] section to your .gitconfig with your full name so that this
> issue is sorted once and for all.
> 
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index e715c157c2c4..e9223cc4f913 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
> 
> /facepalm: why do we have this __always_inline here? Nothing to do
> with your patch, but definitely worth understanding why it is
> required.
>

I don't think it is needed, we can drop it. Maybe as part of this patch
?

> >  		goto out_unlock;
> >  	}
> >  
> > +	if (len > ffa_desc_buf.len) {
> > +		ret = FFA_RET_NO_MEMORY;
> > +		goto out_unlock;
> > +	}
> > +
> 
> It took some digging to understand how the various queues are sized,
> and a comment explaining the relation between ffa_desc_buf and the
> other queues would be very welcome.
> 
> I also notice that we have other places (apparently dealing with
> fragments) that do not have such checks. Do they need anything else?
>

I think we don't need that check in other parts.

> >  	buf = hyp_buffers.tx;
> >  	memcpy(buf, host_buffers.tx, fraglen);
> >  
> 
> Finally, this probably deserves a Fixes: tag and a Cc: stable so that
> it can be backported.
> 
> Thanks,
> 
> 	M.
>

Seb

> -- 
> Without deviation from the norm, progress is not possible.
