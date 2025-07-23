Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4756C2F4332
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753281833; cv=none; b=BnBFeBxGHv9nSd6Zg5peGYn8DknC6AkxQU0ev1bUIVnPOTBoNd153gPf5wduieg7cltTiz3qKJV66w+gZs5Nse9OKotoqoxLcEvXluZ6WwNV6SMPAu1equz5wuhjTx2lrSxgM+l3xyCzUgkDZngyZ7p2QpDMWsBgBRJiKykGxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753281833; c=relaxed/simple;
	bh=kYA2UzaJYH+3hGfThkOhnRfE3+sQ12vjUQCuIWpjA0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tDdkaE4qEBMCv79xcM08K/9vC/or+Z2OISwds7LRV2DQCAsYjp4LKoPG66fxXT/qCKSEVxHUHz2UKiH5u+Wk7qUsgM/kYvGinlHL/hV3x5QM7E8XjqPDoCa1XjuHFvU52vsbS70wpS3nKQT+xIw0xVHngVNVhm8/rRPcKd2dkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mrkdf/9r; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mrkdf/9r"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so6787567a91.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 07:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753281831; x=1753886631; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYA2UzaJYH+3hGfThkOhnRfE3+sQ12vjUQCuIWpjA0w=;
        b=mrkdf/9rp1jzd5h8vz93rSCc7c/1RxjkNadHT2Rkg8/YVdzJ8UqEQn9RW7NBkczyNz
         2X7He5AXtHx/GKhneTUp5uGjvUQK8fuJV2YWK42YwJj18ANGMcaS0Zxn6GszWD3oX0N1
         pqc6up+vkIS7KTbfZdgyDOHLJ4wlg9+eFdNS4jDEAX9OdHjcCzGaopsNWmKVKZ9nBjjk
         qXYe+05D5+RO02LbshU9MSY3+sHsE/dJN8d4fcJeeejYmgTcPEeZqOQ6NYTKnQMVe7/d
         IjO2H0EHW0Fy5GlMlNpTyw6Dx3U62RDehMrDFicCuiXRoCs23p422+jAaVBSUtUF6KXN
         zxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753281831; x=1753886631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYA2UzaJYH+3hGfThkOhnRfE3+sQ12vjUQCuIWpjA0w=;
        b=mFSCIXm6sPrCzE2IAxZWAzRjLNmLOQqmtM3Jy8/HqhbJWteRZ0hAyJlg3vDXzgQYC0
         woii8GuFKg+VRuJpTuVieN2NR8/qKd1Dd75VriVFTFCcCnsCf4H7earuxHG+1DFRojhr
         5HT1WpxHjNB3aV2wztUJgyNpExj7rmyiycfu4QeZ8mPLetBs8qpOaCYTNSwNPUFxp8vO
         p3cp5Up/lxH1iZiXiY+IZ6WrL7WlC8HF5WexoKJmrW7k+E1Is58WsGpiXKVqXfNVL992
         qGJDkAbKuGKgp8pt3P0+zAx3KU0xVZItWs74vqeK3e/41qKYNzYZ01ijr+e5eQNbWHcJ
         o8Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWVaXTANosxzxr2SQTlXYBn2b4Ef3PuB78p2hKzYdNHevNrhT9xY8Mfe2Fi3+7MymIQZET0or0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVw2EX9/rYMULPAkxGK13mjaAPUMewJ7eUBLrK5yLtemXrq0MM
	1nZNbTKW4EQ517xDx72zIH79kT1tZhjA8ydgmQSXNkmApSyF0i8gJpRD7nx+0a3kjzpdauR9vci
	uY2dskw==
X-Google-Smtp-Source: AGHT+IGkVA9V8/ZO7g4shvg2UQ6jCg/0h7Ce9RZescp986cCMnBbbliYZnYSjUAkEJw0pSkUoLPPHW3zZ24=
X-Received: from pjtu6.prod.google.com ([2002:a17:90a:c886:b0:311:d79d:e432])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5242:b0:311:df4b:4b82
 with SMTP id 98e67ed59e1d1-31e5078f52bmr4726762a91.4.1753281831499; Wed, 23
 Jul 2025 07:43:51 -0700 (PDT)
Date: Wed, 23 Jul 2025 07:43:50 -0700
In-Reply-To: <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com> <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
 <aH-hxiD2DwovFpqg@google.com> <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
Message-ID: <aID1JoOGRZ8HIkc9@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 23, 2025, Vishal Annapurve wrote:
> 2) Userspace brings a mappable guest_memfd to back guest private
> memory (passed as guest_memfd field in the
> KVM_USERSPACE_MEMORY_REGION2): KVM will always fault in all guest
> faults via guest_memfd so if userspace brings in VMAs that point to
> different physical memory then there would be a discrepancy between
> what guest and userspace/KVM (going through HVAs) sees for shared
> memory ranges. I am not sure if KVM needs to enforce anything here,

We agreed (I think in a guest_memfd call?) that KVM won't enforce anything,
because trying to do so for uaccesses, e.g. via __kvm_read_guest_page(), would
require grabbing mmap_lock in hot paths, i.e. would be a complete non-starter.

So yeah, it's the VMM's responsibility to not be stupid.
