Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E81E22087
	for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 10:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X9rAMMRS"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40b367a0a12so29855e9.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 02:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700737102; x=1701341902; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tbD+CZLI2OJnj2XtkqlWGnXInTbmUcqYNyaWG++MW1o=;
        b=X9rAMMRSsTcHi/FQDJIBvGMJUusfw2LRdtmNsteSHmyMaMXFYg0k26ouZ2qHz2H/S4
         klPsvSGLe7GRro+tItN/nMcDlQOw6ligvzdgmF5O1uYz/YFK0KqA/e/TRPlZg/bjp92c
         z9m+HJuHJ3OUJl/cnLWM0ZnbyI5I8R7USluc2Zso0/LODc+i8DWtKydckYahXHoDhfht
         EsfCy8KlaviKBxW3KWMuNOpaH6ypqsoPdnJE60KrQhopnO9dwZkYLncge+wRguoxSXJ/
         vxCNb/kqgoSOG6K7cLl/b8/OGBvC2sFvrYRKKOxi88kstdFyrZL7UHO64dwHV1Hb7Ldf
         2+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700737102; x=1701341902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tbD+CZLI2OJnj2XtkqlWGnXInTbmUcqYNyaWG++MW1o=;
        b=diRgGOAdaLDJu351h/CAZbFTTKmfO8oVVX3mjvp2viWvYcLsrtU6orQNbMNlOZszfs
         NwnD+gs88a9W9r6pSEox6OmdRsBK8qiXTWrz9alGjTlbhJnB5dPXpyszC2Dcg7hxkNHn
         JV7AM8yFw4EC0xsO0ueh42lFVfRmrwNHm2HmWQhqpiR4Gcg5daPhbbbqHFWB7XRWtFd6
         DPBiDBxYYc1eSAmJTutXCVaV5OVld1VqArawAm7jEQm89tOELj96+LEcJxXPMfMmGV1a
         LSXroZTWvjwN4rCxIkp31E4v5dRIpBJBuEgmTRXN9P0BEtPuDziE32HEhsiIYQaTwqcg
         FqRQ==
X-Gm-Message-State: AOJu0YzpzvghkJLj0SpVzy/DCBDILHVYnNJc2FtGjuYRuGfHxWFyzOtZ
	DmOq4GUv29H77PV24BpnxPyEmA==
X-Google-Smtp-Source: AGHT+IECpNi7V/qSvW7pVQ/CJFY4C0ksNj+vFUmeqFagu+qFkUWQoOPShJMnthXGa96ey5y1uPJSiw==
X-Received: by 2002:a05:600c:3b13:b0:40a:483f:f828 with SMTP id m19-20020a05600c3b1300b0040a483ff828mr251605wms.4.1700737102403;
        Thu, 23 Nov 2023 02:58:22 -0800 (PST)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id k11-20020adfe3cb000000b00332d3c78e11sm1305204wrm.85.2023.11.23.02.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 02:58:21 -0800 (PST)
Date: Thu, 23 Nov 2023 10:58:20 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: will@kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com, qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v3 10/10] arm64: ptdump: Add support for guest stage-2
 pagetables dumping
Message-ID: <ZV8wTMtuztSdzPaI@google.com>
References: <20231115171639.2852644-2-sebastianene@google.com>
 <20231115171639.2852644-12-sebastianene@google.com>
 <ZV6QXSV_SrYjjoE_@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV6QXSV_SrYjjoE_@linux.dev>

On Wed, Nov 22, 2023 at 11:35:57PM +0000, Oliver Upton wrote:
> On Wed, Nov 15, 2023 at 05:16:40PM +0000, Sebastian Ene wrote:
> > +struct ptdump_registered_guest {
> > +	struct list_head		reg_list;
> > +	struct ptdump_info		info;
> > +	struct kvm_pgtable_snapshot	snapshot;
> > +	rwlock_t			*lock;
> > +};
> 
> Why can't we just store a pointer directly to struct kvm in ::private?

I don't think it will work unless we expect a struct kvm_pgtable
in stage2_ptdump_walk file_priv field. I think it is a good ideea and will
simplify things a little bit dropping kvm_pgtable_snapshot from here.

The current code has some fileds that are reduntant (the priv pointers)
because I also made this to work with protected guests where we can't
access their pagetables directly.

> Also, shouldn't you take a reference on struct kvm when the file is
> opened to protect against VM teardown?
>

I am not sure about the need could you please elaborate a bit ? On VM
teardown we expect ptdump_unregister_guest_stage2 to be invoked.

> > +static LIST_HEAD(ptdump_guest_list);
> > +static DEFINE_MUTEX(ptdump_list_lock);
> 
> What is the list for?
> 

I am keeping a list of registered guests with ptdump and the lock should
protect the list against concurent VM teardowns.

> >  static phys_addr_t ptdump_host_pa(void *addr)
> >  {
> >  	return __pa(addr);
> > @@ -757,6 +768,63 @@ static void stage2_ptdump_walk(struct seq_file *s, struct ptdump_info *info)
> >  	kvm_pgtable_walk(pgtable, start_ipa, end_ipa, &walker);
> >  }
> >  
> > +static void guest_stage2_ptdump_walk(struct seq_file *s,
> > +				     struct ptdump_info *info)
> > +{
> > +	struct ptdump_info_file_priv *f_priv =
> > +		container_of(info, struct ptdump_info_file_priv, info);
> > +	struct ptdump_registered_guest *guest = info->priv;
> > +
> > +	f_priv->file_priv = &guest->snapshot;
> > +
> > +	read_lock(guest->lock);
> > +	stage2_ptdump_walk(s, info);
> > +	read_unlock(guest->lock);
> 
> Taking the mmu lock for read allows other table walkers to add new
> mappings and adjust the granularity of existing ones. Should this
> instead take the mmu lock for write?
>

Thanks for pointing our, this is exactly what I was trying to avoid,
so yes I should use the write mmu lock in this case.

> > +}
> > +
> > +int ptdump_register_guest_stage2(struct kvm *kvm)
> > +{
> > +	struct ptdump_registered_guest *guest;
> > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > +	struct kvm_pgtable *pgt = mmu->pgt;
> > +
> > +	guest = kzalloc(sizeof(struct ptdump_registered_guest), GFP_KERNEL);
> 
> You want GFP_KERNEL_ACCOUNT here.
> 

Right, thanks this is because it is an untrusted allocation triggered from
userspace.

> -- 
> Thanks,
> Oliver

Thank you,
Seb
