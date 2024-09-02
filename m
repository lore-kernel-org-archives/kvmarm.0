Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D704183CBB
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 13:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725284761; cv=none; b=ZjqzuNbpnBOYv26024lUcazBm8x+IwenEyn7UOgmDr7mcSIsuQNE/SHTkqjKDNAFyVmyfQhJT68eg4gdh6cwBKZ2QTfGUIHFwHi3MNjnV9bf7lO0TgsmJqUK4C1GVjnRV4TrxlyAR9tEbY6KOmFXTQMCFilQYcc1p7H6ytULOl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725284761; c=relaxed/simple;
	bh=uYnSy5nGblpu0Q0UqiGyeRUNI6MNALFdJHiDwlpJT0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZF+G4oB/DeFLddT7snDtcavmWcWAX5cRAuXxlTJvXx8Jpih3XUNX/AXWtu3+kfhcXnCrfiL+Y07CKAknf27mMopE4ycuUxyYk+oH+TZvP1dnz6qP4/2u+Ep1cLAWe88SQA1htKYsjBbYqt17mMFYFuSuTk1XdhukqlZU0qdlEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EON376Vc; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EON376Vc"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-429d1a9363aso76415e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Sep 2024 06:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725284758; x=1725889558; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h0imZkgHwv/FFSZ/weDFaOI5QGpkoprAXSenH7V5Z+0=;
        b=EON376VcDUmcG7fDWw3Nl7qj2hi93h+hSNed/0+cDfzGEt9D2nG6eRgjCMHzkcACEg
         e5aVMmfQEBKx1EzoJ00FM4qfjiHjAIvuZDA7SWXQuz15Dkd76ualF6FlmVxzhTU9sNag
         AhAFgYw2H2EjBn8c/eDNc+z7cC7RB+5ADiNVLA7bvisw0rI2kVRRF6of1a5II7lldpON
         Hz+0lv1aMyIHfXwd0ipnnOlMG/2sEK/gaU/X6oKjpEfkVTsJeTXvXyTzMWXKmMoMCWU1
         ZiwdZ6O6//7FxqFPr3OobhZhBuJXTZ23ofn4QonjseztVLte3pyRAHH1TWTbbjx0h0jc
         9UDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725284758; x=1725889558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h0imZkgHwv/FFSZ/weDFaOI5QGpkoprAXSenH7V5Z+0=;
        b=jPrZZIHIzgEU+Eb2GQs05vhLnIfDT/tWNLPLTweTSaKBklkgxBkFVTkv0SY8AAS93b
         J80C8LKaASghDhfIjIkLWEe8RwSyWaeofPRYTW/J0Q5sGOepF1mmnhNgwco6G0Jnd5qs
         fIya9liVDQun0qn47fX3WNaUFQAlsi9DuZocdJYBtHlmoRmca9ARvmmlgayJ9I4EbahV
         EJjQtYjrA55J23e0Tl3UIwybNXVpAGUlcZOHO77LnkV4a0viDHK+QdfuIbPfZFQSOf9Z
         OuAyZ1ETNms1DM8UxFD0YvDP9TP5IL6uWTNNYYtdk/jAPxI+6KTqnWevJY5nNpAepqWm
         rJFw==
X-Forwarded-Encrypted: i=1; AJvYcCV/4pM3Sn8/O2uVZCeAYIfi0q0xP7YYYgcJ6it6bnTsPpL0GGZSaGCatQ7QywU3wYfU7c1m6Y4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKtMCD23yTv2y8i3O4P/OmzUhTrDwSpADWLRdaUnlJQagad3Qk
	ubJC8Bp0hp0rAh/YWXdPxdOhKYsYEwu0xlVD96xLlqyKfeuy6uMOIpP2zG6ZyHfvYz2TxMRCs36
	wHD28
X-Google-Smtp-Source: AGHT+IHfmxWe7A8SIdoui0sTmiBSuRgFc0ExDXB96UvRo3zFmjQuhTAROm1VQW7ctx3emLZKd2x6sA==
X-Received: by 2002:a05:600c:b8e:b0:426:7018:2e2f with SMTP id 5b1f17b1804b1-42c78770e08mr2096735e9.5.1725284758212;
        Mon, 02 Sep 2024 06:45:58 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42c17fed40csm89809845e9.0.2024.09.02.06.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 06:45:57 -0700 (PDT)
Date: Mon, 2 Sep 2024 13:45:56 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, akpm@linux-foundation.org,
	alexghiti@rivosinc.com, ankita@nvidia.com, ardb@kernel.org,
	catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
	james.morse@arm.com, mark.rutland@arm.com, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v9 4/5] KVM: arm64: Register ptdump with debugfs on guest
 creation
Message-ID: <ZtXBlN6nBsEUhQ4P@google.com>
References: <20240827084549.45731-1-sebastianene@google.com>
 <20240827084549.45731-5-sebastianene@google.com>
 <ZtGd9UEudn8Z0IlG@google.com>
 <865xriw161.wl-maz@kernel.org>
 <ZtWdyKtw8EGYlJz5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtWdyKtw8EGYlJz5@google.com>

On Mon, Sep 02, 2024 at 12:13:12PM +0100, Vincent Donnefort wrote:
> [...]
> 
> > > > +static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> > > > +{
> > > > +	struct kvm *kvm = m->i_private;
> > > > +	struct kvm_ptdump_guest_state *st;
> > > > +	int ret;
> > > > +
> > > > +	if (!kvm_get_kvm_safe(kvm))
> > > > +		return -ENOENT;
> > > > +
> > > > +	st = kvm_ptdump_parser_create(kvm);
> > > > +	if (IS_ERR(st)) {
> > > > +		ret = PTR_ERR(st);
> > > > +		goto free_with_kvm_ref;
> > > > +	}
> > > > +
> > > > +	ret = single_open(file, kvm_ptdump_guest_show, st);
> > > > +	if (!ret)
> > > > +		return 0;
> > > > +
> > > > +	kfree(st);
> > > > +free_with_kvm_ref:
> > > 
> > > nit: I believe kfree understands IS_ERR() so you could have a simple "err:"
> > > label covering all the error path.
> > 
> > I couldn't find such handling in kfree(). Could you point be to it?
> 
> My aplogies, I was confused by the DEFINE_FREE(kfree ...) for __free(). kfree()
> only checks for null ptr.
> 
> Although, I wonder if the naming "free_with_kvm_ref" isn't an artifact from
> previous code? Nothing is freeed here. So perhaps err_with_kvm_ref? which could
> be shorten as this is the only label?
> 
> [...]

Yes, I guess that works better. Thanks for checking,

Seb
