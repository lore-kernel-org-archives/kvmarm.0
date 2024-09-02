Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429ED184531
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 11:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725275600; cv=none; b=aW7b1V3gxVOcxC6tW/QMH8TBjAp0snCVag6dQWEkIPQuqZpdNId1IAYZSxGd+gGL0Je6ifXcqgzWXqPA2CFrqtZuvkWScK7GmKHbwv5m0KW6jDPcYBmtNSd2XzS78qyz4CICeYGmXp9pN2Boi2Mk6YsZnO8txNP/yr8wXGUh084=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725275600; c=relaxed/simple;
	bh=qB/qPSlPdkFfzd1CTJrbma28TcJMnQRtjZeVRJqkvSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqabfBBLGCEcRC7SjthnvhtTJvNGdyjeG2XWB0AW4JwMpefB+fZ+ECYuA450/KP0FKlDtSTnU1rfqglUwUlu3qhBDjLWo70+mx57JNmHW30/zKgf0oDIMG98cZFh7UZc0Q3p0VvltAogLGHX0pzPVC+A94SLT0aSRdxQCqz/m18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mpxk38Nu; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mpxk38Nu"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-374c8cef906so795768f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Sep 2024 04:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725275597; x=1725880397; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=trOQbSRctpSwONXeBlAgxscj+bT35QMgk51a13CNx/U=;
        b=Mpxk38NuNdH/3l4wKG8Obn/TdPSHsk9xoRMklsMC+oNVO9/1n1Ykgu9hoIRFS8f3iV
         osLzva43miQO5X1ua1kFwMmMOC0sKAnxzmvtL1Hy6pk6jdy+iyYys/fWPEx2wgasSGJ7
         t05Cfe8Q9c8ja3a0tS7rbD4ZptuFby2pd4hR1F0Xzrpu5eS30uuZkGFjw3RD2kA5RiKC
         4lWgr+tu0Emddu7ss2harLIDux7eR41cfwwqqv6B3GCHWuxN7867CySxctO+Nt4qrbHM
         Y0if2eV2mBEoMORM3cA4dTl+j/AtexzpKqimlor3JTxdMhfLYrCUrso0Jlol0Y8IKw5B
         i4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725275597; x=1725880397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trOQbSRctpSwONXeBlAgxscj+bT35QMgk51a13CNx/U=;
        b=RqAMjDiJo+hIWPIrMSHolouL2al4VD3IWb/tnKtKamba9oLndKAMk6H0RoeGBZhHKd
         wevDU2b3lK6NVi1F+7H5gB0Md28QODiMuRNyuXXBCvOGIB25o5LYbJATaYQocKOqTvpa
         eFERvgiQX68XwkmmZjyTDEDKmfc08JNbM2mtvKNx5dc6fEtIP1elabt8ZDQKmUHDrKMN
         cAOheC3HQJw6QqZh2NohRVEvZ/fU/UlbKzAH18IaE5flTMWQ6P3TB+lroBFmnkPeqyA0
         SGcjIC2ofcNjUKkONQtcXdYArqRTIbGDavJ52YHRpVrrRtXo/KZggW9xD0zltuBeKBwm
         U1Dw==
X-Forwarded-Encrypted: i=1; AJvYcCXu73Oo1ZyNFy17ZU1KeDtgMZ8oPxShwy3ATr4fq2vaTxug+HuSb51v7Yl1rWw54Tj2yfi0XHA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJDtZH9MUyS2tr52gAfG/9iehPLckxpSbBiGJAB2VXNU5l0ogY
	NwoNVkm41BPQolqGML4qSjqghKpn5fI613Fu0Sh7IhYh7cHSaGrOWUbNbJ4hww==
X-Google-Smtp-Source: AGHT+IH7woCYVNiEDZabuscEJviasxR5ir6EOYwiqiG+6QJsMqDLh27XmLT7jAvAWCyzW79uw/yBHQ==
X-Received: by 2002:a5d:522d:0:b0:374:c4e2:ee00 with SMTP id ffacd0b85a97d-374c4e2f17dmr2647937f8f.53.1725275597192;
        Mon, 02 Sep 2024 04:13:17 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6e27c70sm134013705e9.35.2024.09.02.04.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 04:13:16 -0700 (PDT)
Date: Mon, 2 Sep 2024 12:13:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, akpm@linux-foundation.org,
	alexghiti@rivosinc.com, ankita@nvidia.com, ardb@kernel.org,
	catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
	james.morse@arm.com, mark.rutland@arm.com, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v9 4/5] KVM: arm64: Register ptdump with debugfs on guest
 creation
Message-ID: <ZtWdyKtw8EGYlJz5@google.com>
References: <20240827084549.45731-1-sebastianene@google.com>
 <20240827084549.45731-5-sebastianene@google.com>
 <ZtGd9UEudn8Z0IlG@google.com>
 <865xriw161.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xriw161.wl-maz@kernel.org>

[...]

> > > +static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> > > +{
> > > +	struct kvm *kvm = m->i_private;
> > > +	struct kvm_ptdump_guest_state *st;
> > > +	int ret;
> > > +
> > > +	if (!kvm_get_kvm_safe(kvm))
> > > +		return -ENOENT;
> > > +
> > > +	st = kvm_ptdump_parser_create(kvm);
> > > +	if (IS_ERR(st)) {
> > > +		ret = PTR_ERR(st);
> > > +		goto free_with_kvm_ref;
> > > +	}
> > > +
> > > +	ret = single_open(file, kvm_ptdump_guest_show, st);
> > > +	if (!ret)
> > > +		return 0;
> > > +
> > > +	kfree(st);
> > > +free_with_kvm_ref:
> > 
> > nit: I believe kfree understands IS_ERR() so you could have a simple "err:"
> > label covering all the error path.
> 
> I couldn't find such handling in kfree(). Could you point be to it?

My aplogies, I was confused by the DEFINE_FREE(kfree ...) for __free(). kfree()
only checks for null ptr.

Although, I wonder if the naming "free_with_kvm_ref" isn't an artifact from
previous code? Nothing is freeed here. So perhaps err_with_kvm_ref? which could
be shorten as this is the only label?

[...]
