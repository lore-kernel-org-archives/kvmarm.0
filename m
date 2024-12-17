Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435831F3D41
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734442443; cv=none; b=TcWtrjWbrP3Jrdsmlnsk+TvEv3t6GCODtuumfOS9ktnulRmCM11PaCMXsRxPjz0aSEvFzOXNGfr31r+gr1AHDZMKSC6ZqFPBqGcNtOhLAVIPRHNOosHgXfGWQrpDji8bXi5Wc8O+TGIbHSHkhnLy//QuThTigvutGWgycxE8a/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734442443; c=relaxed/simple;
	bh=5xutDIjCyMIitN2CQux5XcwFtIsmOsvNxx/cYCqH9pA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNrcVg1NoMzHwJY9XAk0fTqQJxYLCmTxX2QxaW3ABmw5hazkkq1R/6k9vGlpvaRW4SpFZAD+2gdmudUX9iiIqTaQAGFp2qKlneYcA93e8DAJvLHtNFiN/lKIh2mwFz6dS+RtyKwv2n3XAM1lBlq+imAdIZ2UwcyQ+xESibK05gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2lg/ifp4; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2lg/ifp4"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa66ead88b3so946000466b.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 05:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734442440; x=1735047240; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QNzKWwcjuKoS1G8q7vft+5gTVP09htSDXmMOavO194=;
        b=2lg/ifp4AT+66uQFanXBB5TIrXW3JFIcA+7rqBtGctxSpNF6ck61eom1dgd7YWSXWY
         DYfTYc/kgyRGOitx52JjvvQ8ixtZB3buC3dUKN5djR/XndiyGKNJN4vaIApmjsDwmZZH
         PIWyx10HQuMdHmJV2gjfYmQHFmJpSK8hdnVojoRAdqzixFZUqF5dCPqUwmGq5VHluIW5
         HgGVBkSQ3q0LdaAQeVlV9bfIzX+S0VTyfJQ6EF2nVA9ZSNgQOAg4stj2ddYCx3stHElr
         pkhY2OUPgEUKgw2HBNYsdBHDmF8ZHq2HRqYQNqIJZ3UChPH2KU5DnK8xTfnBofR3A5B0
         wzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734442440; x=1735047240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QNzKWwcjuKoS1G8q7vft+5gTVP09htSDXmMOavO194=;
        b=dWjXWnlthW1WyJRf/KMdqh38C8ix0RTzWBPV1Naagc2I2aHEt+jD2HSrGG9hBAygqp
         RECOzc1BRFjOmZ+nMjqS7qhfsZR+N3tGbJvSL64zy/rGL/CJgJonnFvsWedv2ni0Yvn8
         IHX0x0mM3VNaE5tXJ9ARCkuSaqnm/fRvUkGYn5/YoilrFhYoV1KT8KWxlT9FQ+tqXmy+
         TAiTh7F0JSB+/QwUINuT0iWIbXiwmB9LUJ9sQlcDH13UYaAKolfZgOGNp6ISMkuVmMlI
         9F4zLaWm8y5KWnTXTjFjsq3wzQHzAjFGg+CVZ6zk07EWJP2LSdNGRP92l+YsQ6BIMiEg
         AAgA==
X-Forwarded-Encrypted: i=1; AJvYcCUFI9wPzq3vlNnCaKpH/CCPR8wnPVF+X9pmCX5Yy9DeTRgaS6gHqV0NriLXtMaJ81VIBSRGPxs=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywg0gSlUqnhQKm/Oj7l746gUiGwdGl/HGdEkLW9HP0CSq19v40p
	Qh18mPc94l2u6Qgqp80sdGnd8lEhlEhtDzgruB1pG6cHJS2hrKXgTyq1yLGXFQ==
X-Gm-Gg: ASbGncuUQpS3t+Va94U230pU8UnEsHYvUd7ktzTlfH39LDxxbXxKTZAm1HlpaM79UVx
	I+T+NuIgamGC84/YA9DgYMmft5F0rBynzuENIh51P3WnFAGTxQp78SR6OIR5R+V9+XT/WD/S+5G
	JP66KiVeeUPxW+4UHypo0Iho2oE8j6+TNj6HEdrzfc2AIUlgkQH2QlXwUB/k7/39s+waV8dnJAF
	b7QIfs/hj1dKXYiwMNzjJ4un74VLjnt0r/IQf0sNWAfa5zuEsKEDo4Y4qePDye0tcE4jP7coSUY
	+ElRlEHY1r4akkQ=
X-Google-Smtp-Source: AGHT+IHaaBpKehN/3xKCSI4k6TebR04IYJYJaUaIapMz4+szmzBaeqriWGDQgSt0k6S3fPHQK0lNaA==
X-Received: by 2002:a17:907:7296:b0:aa6:6c08:dc71 with SMTP id a640c23a62f3a-aab77909ee1mr1749746666b.23.1734442440424;
        Tue, 17 Dec 2024 05:34:00 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab963c54c7sm442926066b.195.2024.12.17.05.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 05:34:00 -0800 (PST)
Date: Tue, 17 Dec 2024 13:33:57 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/18] KVM: arm64: Introduce
 __pkvm_host_unshare_guest()
Message-ID: <Z2F9xb4jrK1zRtNV@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <20241216175803.2716565-12-qperret@google.com>
 <86wmfyr1j4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmfyr1j4.wl-maz@kernel.org>

On Tuesday 17 Dec 2024 at 11:29:03 (+0000), Marc Zyngier wrote:
> > +static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa)
> > +{
> > +	enum pkvm_page_state state;
> > +	struct hyp_page *page;
> > +	kvm_pte_t pte;
> > +	u64 phys;
> > +	s8 level;
> > +	int ret;
> > +
> > +	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
> > +	if (ret)
> > +		return ret;
> > +	if (level != KVM_PGTABLE_LAST_LEVEL)
> 
> So there is still a very strong assumption that a guest is only
> provided page mappings, and no blocks?

Yep, very much so. It's one of the main limitations of the series as-is
(with the absence of support for mapping anything else than memory in
guests). Those limitations were mentioned in the cover letter of v1, but
I should have kept that mention in later versions, sorry!

The last patch of the series has a tweak to user_mem_abort() to force
mappings to PTE level which is trivial to do as we already need to do
similar things for dirty logging. And __pkvm_host_share_guest() doesn't
take a 'size' parameter in its current form, it assumes it is being
passed a single pfn. So all in all this works well, and simplifies the
series a lot.

Huge-page support should come as a natural extension to this series, but
I was hoping it could be done separately as that should have no
*functional* impact observable from userspace. I'm slightly more
concerned about the lack of support for mapping MMIO, but that too is
going to be some work, and I guess you should just turn pKVM off if
you want that for now...

Happy to address either or both of these limitations as part of this
series if we think they're strictly required to land this stuff
upstream, this is obviously up for debate. But that's going to be quite
a few patches on top :-)

Thanks,
Quentin
