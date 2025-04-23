Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8628DEEB
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 18:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433892; cv=none; b=driHLCuxDD30gItAzLrXq9QpgZ6+cupT6arB92QeqL1J1r8l12GAZ73F8jobB8yPsTsPi9gisyB6pdebYZigK+hRhlK79wQh+Wn3NVl5WXv8PsJB7Lz2JI/NnGfNLWD6FxlVILp2bFlR7kYv2RUICChrAw/tLw3Hgrfjaetx5fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433892; c=relaxed/simple;
	bh=C8Vy0QjWrcwscWvUeewG3k/22VJUo67jEM+Dw8FZWfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGY/+C/3NIzR/zvgVY4VldLzEQFKFJ4T1TgBXah6oy4F82iKVq35U7Ln2Zx1mkkmLB797pNGYaXhmGO5gb0Dx6aG8GITzn/pm5EWNoFrIEQsyiQOzfyXSTyKu77E31EMfFrkVTesDRBkIGBy7bpub5Pkk6Nt5yGHLMUlYUJ1t5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4fQI/pa; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4fQI/pa"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-225477548e1so2377735ad.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 11:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745433890; x=1746038690; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dyuD9/sJAUbk/RnjGg0DeufQJHAxdMe3Ujkj8v1B1G8=;
        b=B4fQI/paUclffUIhRorAmZUpgHtH5X3e9I9+i5/WwJDAoHqWYdfEuup37Ov2ExeE8t
         DUM9LyZjHxBoUxsy12UhoOiTpydfFJSkQJ9cfnOFFlRVAIYXbELWJy8uRSok5lFsqAvE
         PQYmvjniN7nINRbJhI1VvzLouECKdyiy219fjweXwH0PADr9mES2caWmnHIF2dfk69BC
         9AktBj9nKsH7i/gITDJnf5Cvl+RL40cZTSmJadvUE3MAjNccvR9wvkzO1BtZRHRVT6TL
         sEaFHDgU193b18yXvlQ9m0phjhlNXJOunxrjnmmsk/B4Qzeop4P/knv23hQjSzHbqH9f
         nfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745433890; x=1746038690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dyuD9/sJAUbk/RnjGg0DeufQJHAxdMe3Ujkj8v1B1G8=;
        b=KupIfHOTf/K9RAAQyhdZNc9jOWvR+20k8/hgZvtjZ5flNLPNtx+mezV1SHgAcVJYEL
         60R4TSbsXY3BuxFx+WY2hqoVnGZ2cqhCMvDI2w381M8ogZ36cHtRc63BIBIOXjmG3GMe
         a2fV0NsQD6ln2VfXD29j3xgEaFC1xJZnDOW+ZPcN6SxbugGcmev2pPSYf+mRI/ROl/vX
         O36zTicHR6cm2J96Ff8t6R+v569uxMKO0JSDq3v99KbQgQOOJO10f9HvKJeMWcvsD8aN
         Wmrfmb2HpyU4RYnGTKDu6eAjSddgsLP7A3ReXKpH/akGRZx+Fv9dOTD0+Q8CwgzbcKVw
         EKfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHSk2SU/LZL5YTRZnaVJId5bRTNl3TCWX/Iz0VNJBJcHYy+crmxsCmKdGFChZJL5paWiv1oeQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/9X7HNKSk/Yw8tH0mFiA67499eqV6VKwB3tNN4ojHn0In/Pr0
	oenRkhjLblcpX82eVEpqbHO4tGPTlqBmhQ7ZWI2icY4UWDLLJln4
X-Gm-Gg: ASbGncu1YjeYAIcottmnTg4JFCnkjsp7/dcyfUSQSXLSJCDnbELHNF1Aodd0Q4jjSww
	RJNI9GMR/Kj8OJ7krAVvfBxDuAe3f8gQv44VQzZRF76YRyKmmFFCwmbKW577CeucN7F+agmbPX9
	fJuvWaUy0k1diZGLku8FIxC+fEApEDnDp2KVy8Pc4cnmxtZVsV/ek89K2UQkKx//7ZlcGUes4Tc
	0oD00nN9rggqzg91gi3XgnPpnjllSBAJu6QqaaCPhGzCQVkNZ6mNjwXjriNlpIPzxB6cOH/KMhG
	cdpY5MxYffJSjYF78VuHqyjLTjO4iURraIcYPS/0GNaELvVIxYE=
X-Google-Smtp-Source: AGHT+IHehkEM0GpRg5zfuUpHGpY51Oz35KQoy2mf8GVVVNyjw21DRg3BRF5CuxGd2alCupb+hBqELw==
X-Received: by 2002:a17:903:247:b0:220:da88:2009 with SMTP id d9443c01a7336-22c53619eb5mr285278835ad.45.1745433889820;
        Wed, 23 Apr 2025 11:44:49 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b0db13a3e63sm9433123a12.29.2025.04.23.11.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 11:44:49 -0700 (PDT)
Date: Wed, 23 Apr 2025 14:44:47 -0400
From: Yury Norov <yury.norov@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Luo Jie <quic_luoj@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 0/6] Add FIELD_MODIFY() helper
Message-ID: <aAk1H0Msi3lMKNR9@yury>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <86sem7jb5t.wl-maz@kernel.org>
 <0c97c659-bd28-45e0-8537-d9be2637cb22@lunn.ch>
 <86mscek7h3.wl-maz@kernel.org>
 <aAJq9mGswYsnAOS8@yury>
 <aAkm79R8f5Vf6TLh@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAkm79R8f5Vf6TLh@shell.armlinux.org.uk>

On Wed, Apr 23, 2025 at 06:44:15PM +0100, Russell King (Oracle) wrote:
> On Fri, Apr 18, 2025 at 11:08:38AM -0400, Yury Norov wrote:
> > The _replace_bits() functions return fixed-width values, and intended
> > for: "manipulating bitfields both in host- and fixed-endian", as the
> > very first line in the commit message says.
> > 
> > Those using _replace_bits() for something else abuse the API, and
> > should switch to FIELD_MODIFY().
> 
> Sorry, but please explain this statement, because it means nothing to
> me.
> 
> FIELD_MODIFY() replaces bits in host endian. _replace_bits() also
> replaces bits, but has a wider range of which encompass FIELD_MODIFY().
> 
> I see nothing that precludes using using _replace_bits() with
> bitfields.
> 
> I see nothing that would differentiate the behaviour, other than maybe
> religous ideals about C functions vs macros or upper vs lower case.

Interesting, never heard about religious ideals in C.
 
> Please explain why you think there's a difference between the two
> because I really can't see any reason not to use one over the other
> apart from asthetics.

I explained that in subtread for 4/6 in this series. Shortly it's
about compiler's ability to catch various errors, like overflows,
and (not unlikely) generated code quality.
