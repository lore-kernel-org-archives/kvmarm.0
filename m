Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6A2266B41
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 14:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860426; cv=none; b=upkITPUMN8uSdoDlnOPUCUB88VuHgA9Iddqqa1H4JLm5mU2h2OLbHh2sFozvp9RGBfa2fmT4AhRj7AqYW2vlwOCNbLQpbX91gF6JnzsNiRaV3RZke0Xu0YMBBiBVCS4BipYlttefujZXA0FPRKkHIgUaQpCJoLzgWumpackLO6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860426; c=relaxed/simple;
	bh=Sd9sNznzUEi5EJ+sne6IkjefYfHIjOxnBuf3fVCoFaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZgO+GsOE9CUtjus7qQOsU3VQ10TE8SDFl7H+leH8kkHEJPnSMXIWWxwPUvLtV6NMZ2JHxhDWUTasoQNLmt9cS1QcO6OSwHwLeEtFu0RfTPpBPuD7DUnRHQM2JaH12FfSzpUd5PcJjDGa5o1rxeDugcyrEI7nvkGXD9Pa5QEFkt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qAGjFsLd; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qAGjFsLd"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2369dd58602so59974125ad.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 07:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750860424; x=1751465224; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8f5KlzP2CK1JfKkyCSpzd2kQ9IT6Pxr3cya4YkMOEY8=;
        b=qAGjFsLducsFdrrOLOQtY7tpRxLjxrCdExXQ5ZfD8ctjja88YAixGLWaJ6mzEadaet
         hXDPFlc6Gtt5tSUpW//LCk8nT6ntsBw+2mTkEQTuRMrGYPwOeXAPTzQkEFAVK8BcfJkX
         b2s+vrPFTTfzvUDBM5xaZ9FQSiRp+b367jAw6CCQr1wrWFoWW83rDhDpvlXUYZJ3TwWT
         rUbRpTKYS+TxQhBfH/QLHY0tfB2xsKVIqIuIAQOCTFxw4hv3y4yWZsSpBrRvPUOhjwtl
         cXEhmrlTx0vcnZTWBjgIw3faxPmZVLeaLc0v9YnrGImJuo/cFFMs6Y+xez2+ZUIScfDZ
         8flA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750860424; x=1751465224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8f5KlzP2CK1JfKkyCSpzd2kQ9IT6Pxr3cya4YkMOEY8=;
        b=P1y0Yenx9jJSDhCwS/gyUCEeE164l83TfEuVI1nVRM+5cxI4nCQyWTcT8c+W100fvv
         ZazOK6IZZS+82xTJXPXBSS7kbDlqIkmKWq03y6m/iZTYi4VwnFrHUI1AtuPHa+wtBYj5
         ipJiH2y+FawDBiy7ZTqDYrOrK/8sK7R1DR7AFvwJdB3WOVGmyL2UyqBUxkf6xgZMNyAN
         /qbnM5JAfyZAZgRnYPm2442Kl5ny81Yfs4IXpLPUax8Eh+aZ5pIbe3jov/Ey+UqQKtde
         Lo/VP4MBflPd0/Xt8VCZEdmTcXWL8c1vDxdiI4aUcMl1MmMKFZrv8Af4afz5R25MIFJp
         OQMg==
X-Forwarded-Encrypted: i=1; AJvYcCXTMOzB0zxZgonkwzlhUVhWIITepz1Wg2yRF0KTUk3WKMfH+yMoFJCt3CYYNHWi64vv7MGYFFM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyx6qITweYfsIUcnuZurHWG0Ku3nHAtlqfirWbPKjcrRyQmWUUo
	RH04DW5e3DYOehIsF89KQnoA3sEC7f+owRiBw0MG+AdMY3HXctHTYKbPGxtVr5lzYFkdWv/1K4F
	wo1aS7g==
X-Google-Smtp-Source: AGHT+IEApMeiGDIZ/SFpUW2e3JmrB7W0fF4MD+T+mdNXkLycwiEroA69CQKBQvTSE7/cFMGNJoFgS1F9IcQ=
X-Received: from pjbof11.prod.google.com ([2002:a17:90b:39cb:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19eb:b0:235:f3df:bc1f
 with SMTP id d9443c01a7336-2382406877amr54160135ad.36.1750860424524; Wed, 25
 Jun 2025 07:07:04 -0700 (PDT)
Date: Wed, 25 Jun 2025 07:07:02 -0700
In-Reply-To: <CA+EHjTygKUN8xYM10sVHFDpV5GDZJLGK2JaFPbLhB1pHU7jAkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
 <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
 <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com> <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
 <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com> <CA+EHjTyginj74a+A58aAODZ72q9bye5Gm=pTxMmLHrqrRxaSww@mail.gmail.com>
 <aFrlcYYM5k5kstUO@google.com> <CA+EHjTygKUN8xYM10sVHFDpV5GDZJLGK2JaFPbLhB1pHU7jAkw@mail.gmail.com>
Message-ID: <aFwChljXL5QJYLM_@google.com>
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
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

On Wed, Jun 25, 2025, Fuad Tabba wrote:
> Got it. So, to summarize again:
> 
>     In struct kvm_arch: add `bool supports_gmem` instead of renaming
> `bool has_private_mem`
> 
>     The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED becomes
> GUEST_MEMFD_FLAG_MMAP
> 
>     The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED becomes
> KVM_MEMSLOT_GMEM_ONLY
> 
>     kvm_gmem_memslot_supports_shared() becomes kvm_memslot_is_gmem_only()
> 
>     kvm_arch_supports_gmem_shared_mem() becomes kvm_arch_supports_gmem_mmap()
> 
>     kvm_gmem_fault_shared(struct vm_fault *vmf) becomes
> kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> 
>     The capability KVM_CAP_GMEM_SHARED_MEM becomes KVM_CAP_GMEM_MMAP
> 
>     The Kconfig CONFIG_KVM_GMEM_SHARED_MEM becomes CONFIG_KVM_GMEM_SUPPORTS_MMAP
> 
> What will stay the same as V12:
> 
>     CONFIG_KVM_PRIVATE_MEM becomes CONFIG_KVM_GMEM
> 
>     CONFIG_KVM_GENERIC_PRIVATE_MEM becomes CONFIG_KVM_GENERIC_GMEM_POPULATE
> 
>     kvm_slot_can_be_private() becomes kvm_slot_has_gmem()

LGTM!
