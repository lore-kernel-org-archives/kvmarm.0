Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5342594
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 11:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734607174; cv=none; b=UDHnEB3gdZ4x/9SFbkVZedbZk9zqwol/E45JnWrH80/SALwo21knUi4w+EyJvcTSHROnd+gE2SYdV0aR1ld0jBocovIyl114lUSI1mZMizY/SJhtd6zmcUen3O5Yz9EovVF7bp9ZhzZtFHz0aEcIdr51QiW7pBAOq8+6rR859Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734607174; c=relaxed/simple;
	bh=uCO8XIxLkLERtbLGEzOZDP1Nn56oL2YEsBEMIpvgr34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPi+yUAMnAEe8v8AXNvJxJo2AW4e/W83nUac6otzM0+Rhvyc8ipcLU/5hzRsGovOdiSXmrx1fUiamLHSqzo1yuOUCGEtLJbxo/8bx/hn38tQOdsZzoI7+o5xbTAv01pXLBaDNrN+oKkgDnZ6xx/8vQinq3I03367HDiSqyKbuwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QTEo+0xJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QTEo+0xJ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso48615e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 03:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734607171; x=1735211971; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DaFUYqfbJ0FVFTC0Qejf2fBra+Am279oXsL2ycAM8YU=;
        b=QTEo+0xJeIC+sTYNn0ZfLc8c2k8PhbvETP/6AXsXD/n57vUk9XpKb2Wpew95FyB8Qb
         AeZAn01dkDk+u4nyGrc+odT2uh9T1cNTe3sImrSJ+S/tUo/wHJmTfLcm8NFJSSh5rph+
         vcPdHYl6CFrn3ffVLYTRB/54k8zMax/gKX+tltWnZm36lV0TYcVcpUfuqSk6yIV+mIGQ
         sO7criDATb19xy1fhOGApTZnBlF/pT5Zh7muG7rg5KiJdmxftR0ptH6HJD+NGnn5o22a
         sKv5T0H34rw8OVB/rivC3wXJjzEbGeZxt57aB1fF02l1XKnaengZZRsYefU7MuzjNVa5
         xA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734607171; x=1735211971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaFUYqfbJ0FVFTC0Qejf2fBra+Am279oXsL2ycAM8YU=;
        b=KLjiFTLEYFTffK2P+izgYCFaGLFy2yN5D5SEUlvdPM79BmhgEVwtzIqMVW2ii9ihGQ
         GGdDJgfhFSqqVFatgWp6369eBrbhkuqg3BVmqfBkHIwRoItk8P3S1ME8I9zlRQy7lDdG
         b/BOrKVjaSgAVR3U+9lC4PpXrjm6V8OiZ2lqu1BbELzf0h6mQEHwNUmMsbKgFwJF4yBL
         aK3PSwU6Vf3Yoi7Wid4Tlp4ZbhltFz1ssefU9q59RZz+kQqG5iE1l85feDyRArv5o3uf
         Pc0z+kcy+yQspf8fKBNyOzlfDCrRtoyTIXSQdd2ox5K74Wch3BleD/+seeVsfMUXcu5N
         qGLg==
X-Forwarded-Encrypted: i=1; AJvYcCVmLvZKE4r0tiU6g/Ld/tPkXb3RGriZZd4SQbuxUE/QB3kAv9CeZd5mOqk52SCZLMOzwgHSZWo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXTFzUadW0aUk+FT93tROXQtVIFHXXJrpQKeHe+jJzmbPLfP7c
	t2eo29vbse1UjPwLgt+pRodb0Nev9xDL2hOKMRwUquPNJvt0uDR6iEaU8QTitFXG/vNroPjfaez
	JDw==
X-Gm-Gg: ASbGnctVLoB+IC0fdQ3LGQTUJTkyO3BN/lUGjGAHA9ETqUxeFoe7hZe4cd/JJ88kIqz
	lxzZMdEQPPZrMrPuDlWyUJj/7znl8W9AEL9KxQmp/FjdR+17HuYCh34YQrkubBjUK489Bcmu6hb
	kQgsta7Kx2P2pjfPmyy8mh0b6qPAhnZx70hK5eakSWdz7to77PtFv7nzzhRHFBEJIAIt8bGHYlr
	i3qCJDLo+QXr35dGSrx1CqWiuDXXB4hen+KIpU1Do0PxchR3lr9DUbAKOGhhzxwP0y7LW4PYcTV
	RZjCWhmIuqTAhcNYyDc=
X-Google-Smtp-Source: AGHT+IGXfoawYuXIuMfIIDaYD8hngDHiUTctYslUp+cxCbwWzZSbONX4t2aPmw9QcUFfEenJ6bez4w==
X-Received: by 2002:a05:600c:3590:b0:434:9fac:3408 with SMTP id 5b1f17b1804b1-4365e5dd70dmr1072565e9.2.1734607171199;
        Thu, 19 Dec 2024 03:19:31 -0800 (PST)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8a6cb1sm1345355f8f.89.2024.12.19.03.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 03:19:30 -0800 (PST)
Date: Thu, 19 Dec 2024 11:19:26 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Quentin Perret <qperret@google.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca,
	nicolinc@nvidia.com, vdonnefort@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 21/58] KVM: arm64: pkvm: Add
 __pkvm_host_add_remove_page()
Message-ID: <Z2QBPtRvnB3PGvMG@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-22-smostafa@google.com>
 <Z2P_H4eahmrvhkIl@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2P_H4eahmrvhkIl@google.com>

On Thu, Dec 19, 2024 at 11:10:23AM +0000, Quentin Perret wrote:
> On Thursday 12 Dec 2024 at 18:03:45 (+0000), Mostafa Saleh wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > +/*
> > + * Temporarily unmap a page from the host stage-2, if @remove is true, or put it
> > + * back. After restoring the ownership to host, the page will be lazy-mapped.
> > + */
> > +int __pkvm_host_add_remove_page(u64 pfn, bool remove)
> > +{
> > +	int ret;
> > +	u64 host_addr = hyp_pfn_to_phys(pfn);
> > +	u8 owner = remove ? PKVM_ID_HYP : PKVM_ID_HOST;
> > +
> > +	host_lock_component();
> > +	ret = host_stage2_set_owner_locked(host_addr, PAGE_SIZE, owner);
> 
> Any reason why this can't be expressed using __pkvm_host_donate_hyp()
> and __pkvm_hyp_donate_host()?

That makes more sense, I will fix it.
> 
> This doesn't check any state, so it feels like a dangerous primitive to
> have. Is the issue the overhead of mapping/unmapping into EL2 stage-1?
