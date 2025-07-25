Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC891E766F
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753455399; cv=none; b=DHDhpK6Y/iSz9yAqLvrgTvKT5buuJRnu/i1guTl39tdd8p+O6UkCUfV+7Dyym9uqNkUvlE8uok0AmtCseQODW7p6lzNpZOtfcLbofSlJB6yIhr5KM6ma2wHAA//JvImrvwQhezqfJVgWVvoulThCJySdS1jnMWvkgnrgmIKoxr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753455399; c=relaxed/simple;
	bh=K3fLhkRTCvPWFzXF+RTlvEpWsEqZfAX/VnDQbwLix5I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DmHIbPOmTHyu07JPbFotcIob+MzQZ16OHw3bKFcuDaR63aLbWakfrP1jjPKdZkX9Kx1sFy81SCDGftQ/gG7BydDHUA8ALQSOvciD7qmErIjMnytY3VhLpS5x0rCwKXTqlFZtV3kGMpjmiwubZ+hWTBULC8EHwfA/YXPrlnBIdH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MGy/3ADM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MGy/3ADM"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235eefe6a8fso17304695ad.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753455398; x=1754060198; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M11ZItqJowsXWKLvHpygzI/Vvsnt9QVCd1UdBgcxgdM=;
        b=MGy/3ADMt8IYsa+vX5Vj/U0G3trFjtKzuvocgYbMPBNKtR3mLO6ohVoTZynueuSQ95
         R1hp8ydKVJJaDMycYxzAsd5xb21N5nKRMhvEh7YHXh21XXYQ6uAB6zw1PBwH/ozfS8Az
         h38nnSdM94Xm4r2Hg+e0Gp8OUSlPm6sR7uZEjJ5kXTbhzmnMpymtpEneRUIaGmCsHnd6
         iqczkj89wfwK1hiJsRSyn8YCPbE4TatkmyQuuFI/YJZV/7X3pB5xlzv/XA1WVzuaxdok
         ZuIbpUudoem3WSeDevP5Cl6zimwIjzXksebh4y7OaNCrkWq/6GS4iobnLmPJSxWerMvK
         0ydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455398; x=1754060198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M11ZItqJowsXWKLvHpygzI/Vvsnt9QVCd1UdBgcxgdM=;
        b=mDAIkRw0NNH1fFrzXaYBOoKe/i5jf/nSahbaVi/DG9fmDl0EFEb7UWHvqJ9+k23EZX
         SSM/Z6HFBpBR3k1FZnOr6SubX5zg/Fq/0D3sFiBYZEFdnXBHFf2lk0WuWeYA9xSiNSvV
         r67j2jCEbkmtbx359mW1M+RfPykCXUomaulDyCbXAvxJe3uMuxHSoIlKe7G138RuFlnv
         Dy/vfwxRbPLLfdVOtDZ5ZPCIcIWj/R1LGJVSqq2yer+dYvGfDcWhO3eN2zZvMlRb0xQM
         yAOdiI34fufrUWBk9cLQCWrBPH9SIpT1R/cPPJ0XxAW0rJhsyffYWTH+wy5vzEhrwAow
         2LuA==
X-Forwarded-Encrypted: i=1; AJvYcCXdTowZ07vKmwCMgMIf6n8A3AXdbnBfRrsGuwfyDAVzh35QdI5tK3tPfdTOPG6xN3x7OaMOi6E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzxj4IEu9MyZ2NUyrS+dISGmboPTHYblrC0+/eNYzu+mvrNydyG
	9XgMrspGdtPFaAulTr+Ii6eUZQfuf+TWzzCNL02LOXRE5MLuzq+LEqJjhYTpWZOLIer4SwyZ+qO
	j0DVuag==
X-Google-Smtp-Source: AGHT+IHSdqHbxeeeIonkSh5BY2m83Kk+wImCtE785oBEw0uVpGh4sf1S5Bqzy2yOyFZqFe/ReQAn+EAhx5g=
X-Received: from pjvf3.prod.google.com ([2002:a17:90a:da83:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ca8d:b0:23f:b954:eee
 with SMTP id d9443c01a7336-23fb9541174mr15170785ad.35.1753455397682; Fri, 25
 Jul 2025 07:56:37 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:56:36 -0700
In-Reply-To: <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIObJH439LQWjnqq@google.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> 
> [snip]
> 
> Did the patch [1] for x86/mmu that actually allows faulting when
> kvm_memslot_is_gmem_only() get dropped by accident?

Ah shoot, it did get dropped.  I have a feeling Fuad read "drop the helper" as
"drop the patch" :-)

Faud, given the growing list of x86-specific goofs, any objection to me sending
v17?  I'd also like to tack on a selftest patch to verify that KVM can actually
fault-in non-private memory via a guest_memfd fd.
