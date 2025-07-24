Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9F0241664
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753396514; cv=none; b=Za6zQ+feizI+3LDyjesEbzfLm4RQ9hMUBaLG9dTFek4mkxg/P8n3qF3Lnk3ZwnfEMO12W/4jkFBCfAsXpgqr4OR9/YfU29cIlpaskBcWIuOjHMn/XWmxenYQO/mAAZ4omOS5G1Qsw6tfbdhi2bV0DW5HGTw7r5Wv6OxPqe/0qgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753396514; c=relaxed/simple;
	bh=r5SzxM2o3YDT3MM6mgAjKy7bmQnwJvTgu0zUuOAYsqk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dIq+1+GEOswgpNkmu8u6XceAMXreotQ6dSYfUxeOaGL4LZtiUfDczEoVWf/L24LHONhE5dnnjSbUr73X2szV8LCOsHyN0MgTW7GENgutRLTAi8AN+xDgdb2PHwdIz+2Z4fw/CxhnkGObPOaSWq8WV6xLQXwgqAOhXXNy8gqNcD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4yrR07Jn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4yrR07Jn"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso2431817a91.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 15:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396512; x=1754001312; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PFqcIXETNfo8GzEn6hB6Ya7g4JGq3t1ggKMLi3jyaSw=;
        b=4yrR07JnlrwmJousj6cIya2wRVAkGbGKz9vm4Sd4q6Ijd0glNyuyTdlcXgGdWACK5E
         HW74MMIFWfLJo5FMq+a+I3j5Bbup6vX23dpUd5UbLd58pfrx5xzOiMD0IqLtILW8N30B
         6JPSsAGqq11LzBnGhijux4UIiDDZgcF5XvgRxgwtr6Etj9iabCae8Ecm+L9yDyeTGdNH
         0XySYbeO3nN2GKVZ17zX/w22pAYVeqk5vPojUmm+loGOguAouj8iPPwIMe7ETe3OPjC9
         mzqTlvtKxSoH7SP34uTuJogbAjZlxnAfSdlEGDUoj/fJMNim9nZbW+T33HwWg0u/CU6Y
         0/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396512; x=1754001312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PFqcIXETNfo8GzEn6hB6Ya7g4JGq3t1ggKMLi3jyaSw=;
        b=enQirlzWIV2ERfnnrUNQz2jZ0E6fLnWlMcEpu46i5vDBqJfKjVHE1oi95urL4qkS7+
         O64rIvfGPYuR8S81l3CTzs9RVX0oLVc6n8AR05Y+awBy7gvk7fCQVPRL04gsbmPt8QEj
         QujIT2EFaunPdWVnspXPg9dZ4a+Cwd5JA+IE4jBuB/QtASOhNV0eBYXvmEdhr9ACyUx3
         e+2PqBM5zzggiMZDa81i9EqyluFOHSzpmt61QSVKznNadsCpdIbkqXS1uvaKFxSw0SMw
         e/okZEXJzJt7AFCt3yaNPr+dSpC59BA5T5v3WqtlWUeS5eWddSx2hob/gTc35XUTSVvv
         4/8w==
X-Forwarded-Encrypted: i=1; AJvYcCVyky/xZL1tIzUune4seLfDUIZAyb6VeG8FN8gnzXpnKYVQ3QE61Mv24MeJVvOQkW0ucaKt8Lc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyibciaQUeyoA8Lhq1Pv8c/MaNogJAV6Mq0pkfJG62e2R9pS3g
	A9b2M7qDb0Fe3J2IPpUa0IU/Da1aDTwQ+IvKjIzy3D2aws9rsVivv3Iz1XmacuNAOAgml197xRQ
	iy4GgEQ==
X-Google-Smtp-Source: AGHT+IHuVeukYr6lWMjvsRkjvN6oFU8CQPzldpvdB/N9yisxOdKopu5kObxNBBArWTOrC8zyhULTFJAICEM=
X-Received: from pjbsu16.prod.google.com ([2002:a17:90b:5350:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3809:b0:308:7270:d6ea
 with SMTP id 98e67ed59e1d1-31e50855de1mr10081085a91.30.1753396511877; Thu, 24
 Jul 2025 15:35:11 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:35:10 -0700
In-Reply-To: <3f337306-e79f-4ac7-bb86-60b88b262e88@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-5-tabba@google.com>
 <3f337306-e79f-4ac7-bb86-60b88b262e88@intel.com>
Message-ID: <aIK1Hp4jZRY4zVTW@google.com>
Subject: Re: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx
 dependencies iff CONFIG_KVM_INTEL_TDX=y
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
> > from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
> > KVM.  There is no need to enable KVM's private memory support just because
> > the core kernel's INTEL_TDX_HOST is enabled.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> > ---
> >   arch/x86/kvm/Kconfig | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 402ba00fdf45..13ab7265b505 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
> >   config KVM_INTEL
> >   	tristate "KVM for Intel (and compatible) processors support"
> >   	depends on KVM && IA32_FEAT_CTL
> > -	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> > -	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
> >   	help
> >   	  Provides support for KVM on processors equipped with Intel's VT
> >   	  extensions, a.k.a. Virtual Machine Extensions (VMX).
> > @@ -135,6 +133,8 @@ config KVM_INTEL_TDX
> >   	bool "Intel Trust Domain Extensions (TDX) support"
> >   	default y
> >   	depends on INTEL_TDX_HOST
> > +	select KVM_GENERIC_PRIVATE_MEM
> > +	select KVM_GENERIC_MEMORY_ATTRIBUTES
> 
> I had a similar patch internally, while my version doesn't select
> KVM_GENERIC_MEMORY_ATTRIBUTES here since it's selected by
> KVM_GENERIC_PRIVATE_MEM.
> 
> Anyway, next patch clean it up as well.

Yeah, I saw this oddity when writing this patch, and decided it'd be easier to
just deal with it in the next patch.
