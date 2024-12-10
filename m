Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F10B22617A
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 19:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733859606; cv=none; b=HcsVlPHz4Wf3c4pP0IPb7C3NY+GriuJrZXBThfmZhS23fDuQgMPGY1VAWvv/nd4ofZMLMbInLB7G7YkuJeGvPbWx2MPrGEYkb0XZoJVgIYZxP5m1reM40v4bTQhGQSlVpQGyGazlolJ4gM47dGZEMFEyloRrdgmkwn+5Lh7iDEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733859606; c=relaxed/simple;
	bh=unXnRfu/yUThTbpM4v8udjLfXFivgtwIKR880XV65Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsPRI0orzj1lTr85WoHI1qvzAsM5Hms0N0ogpMS0m2ULakAQZbdRs/ejvImFJ6jLNz+nZE8v9LTL+xRBFQtaR/qxesD4cJHTzfilS7OBuoHVB70WUjDdAiBwqOBkzDyEXxgcToizmRZAjmtXCErKw4HRrSprPucm/uXJE6py1xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tsSdI4WG; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tsSdI4WG"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5cec9609303so7013750a12.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 11:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733859603; x=1734464403; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q91PmvibJrjArXljdo3eEl/cePC9h8EbSI/sERSQTH4=;
        b=tsSdI4WGlS+FHAnMq4usQd9i/owJL4kBMe7UaNsxQirjVrOeg/z8YIvI6zcLLN5ppc
         O0PELba1XfPZxYB0RXbS9Nbh4HMzBKYF+HloYJaz0MI9quu/qeAIEUbaTvbx71gcH4W/
         l6s7VnQ58dfmnkXd2jdLuZpV8y7xBftSk7Kbk16Dr5tnkATXs5YzZOdaXAgQeMbw8iRa
         tm4XKFtzWJjCN5vyruyqlaejeLTGyS30pqir86qJPvJO6iOnIUHhgjf+G4KRKBNxE1J9
         KPO5bAHExmGXRIXJxqeCnI+J+BxJe33mT50Kc830FKopvPXJHErXMENQSBbGJXwc61b7
         PIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733859603; x=1734464403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q91PmvibJrjArXljdo3eEl/cePC9h8EbSI/sERSQTH4=;
        b=X/YCGq0alxedqpPftNQFViQ1rBnClQ5YQvhu+NG2M1RVbSsZCu5NR+4e5F8N4uLpC7
         WCaIGtx+9b+EZaJMOAqkI4HxUVihicUSVkRGZO3Lp+OaUo13bpQuTmx7gZEhmhmr5BAC
         IohV+QnHTuye6lggv1WJ0hQOOw13tVk3NATUA/zP4mHL882ZUjyitcVDoj/WIde4arxC
         9nWvMvWoNzIXha3zOsDmMn1sNofswvJ1z1NgZTONNYImynIMeED49BkvSUhHZhI9fwie
         Xk46dpqJCzy52oMlGLE+Y2fZ7LZe2z9TbzkKPWcryg2IpqT8l1G9+M+70ifVEdzE9Zfc
         2mTg==
X-Forwarded-Encrypted: i=1; AJvYcCUqAGEvKYV5Y30w/3aRsxZn2/AXcUWFD+ihs6EfIgivtA/XvYQvv9swXOL+A3EhvTckS4jZCYo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyhwr15IBtxW3kjd3d8CttBKvZ8s/N2GI1+4TlsfOGmiA2K74gw
	eGH0OrWZZSU0srA6H9yVfqz6ypQelP0w8WCoI5hyuzQ/VwAqvHaB/nwBAWlVaw==
X-Gm-Gg: ASbGncutGvFIIfn7wsF5mK1tn0uyrifxbwTR4zhGMyERABR75LPbYy/2pSaLb4EWWyZ
	cEqkuxAC+GGRfZvOQyOEJj9DIstTAAShEkJq1q1jEL97tB6Lqpd5CBUvYXBQO5Kcff2pGgdBj3R
	5x7/5KBqIdoNmDvWiU/OFgFubmxD0ruaRyFSg9KZA/b67mbjn9pFUwYosW5tl9lpUb5E+p3+RGL
	p6b+JffJOqF5gDNTLIYocnty3d3APXghB1XbiLDJeUjvtUNgbPO73zqFW4QNrrb/dMBqU3sIoLs
	O3uJKorORnbA
X-Google-Smtp-Source: AGHT+IHWIDVdFqGs95DGfrfVEYVGD04C9okzNTbglc21NwXMz+6mFDbeHCJtOk1PZLW3D2Rl/6yrJw==
X-Received: by 2002:a05:6402:360b:b0:5d0:b925:a8a with SMTP id 4fb4d7f45d1cf-5d4330a2f6dmr35199a12.16.1733859602562;
        Tue, 10 Dec 2024 11:40:02 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3e7936581sm4997727a12.56.2024.12.10.11.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 11:40:02 -0800 (PST)
Date: Tue, 10 Dec 2024 19:39:59 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/18] KVM: arm64: Introduce
 __pkvm_host_test_clear_young_guest()
Message-ID: <Z1iZD54EdpvbpW7I@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-15-qperret@google.com>
 <CA+EHjTwV2mXOXMF7u+pVaSqvJ2c-iPGMxPBhrj7oZrm+oaAi3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwV2mXOXMF7u+pVaSqvJ2c-iPGMxPBhrj7oZrm+oaAi3A@mail.gmail.com>

On Tuesday 10 Dec 2024 at 15:11:53 (+0000), Fuad Tabba wrote:
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 8658b5932473..554ce31882e6 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -43,6 +43,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum k
> >  int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
> >  int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
> >  int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
> > +int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
> 
> While I'm piling on the function names/parameters, some functions have
> _guest as a postfix at the end (e.g., this one), others have it in the
> middle (__pkvm_host_relax_guest_perms). I guess
> __pkvm_host_relax_guest_perms is the odd one out. Could you rename it?

Right, 'relax_guest_perms' felt more natural to me, but consistency
should take precedence, so I'll rename :-)
