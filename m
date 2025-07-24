Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135C323BCF7
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 22:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753396420; cv=none; b=u3NzDFc3xknqf5bpDd0nbiLc0IrbbiKEGtWjADyMMIna+LO5RHbU2AScklDG4vhYPljmcTw/Q3kZrKy5SfDo/zdVLqLf4dnnJiqidbHmxZyJ0QJ0JVCOLHQKtS11sJ2MoEoqpG+BffjxvE192937rdwHR9WY2kgLuVE+uVa7bmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753396420; c=relaxed/simple;
	bh=fR04mv39CqWH9hOwlExnLKnmwlLVKhJNGIGbrPJHvtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qf/oD73ZgSXaaQoh3CB2H3E07+UewY6jcLvJLulnqYFwlhtZuc/xHxaBa1fqqyQrJZ/VTh8WeoyWRT8r53vLlKCT/T/bhWYWo2ouBvmaBu6Qgd5eWXtxLAAu4Sa+GhN0J2Mc8k4XWxGRHjVNVXHUqX26EIzMaIklOhRG4ESZeRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UBwydviU; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UBwydviU"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b34fa832869so1986994a12.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 15:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396418; x=1754001218; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=inLy5vcBNILr3/MOBz76JuwhCqWg6KJsocdJKuHsHow=;
        b=UBwydviUkpfzywTgnJujUzj6VtfBgJaVK3vJNPzhGDUw6Iw0H+Nr8IGhOt76xsBy7d
         rM8kVYeEEL6c36/A0gTReP71Iz4367wIWsS/YjvnIlorlf5CX/YvTPljmyvgB53RsqJh
         zwkImzARBSi7ZMz/jpJKmMDYAp/gQcoAtsREFBrAU58qX4l1fBgxEqRa4Scp+BndVvxO
         6wqxCwZC+LDkx37a/EqTcJrjecoLu4Xb1n/yknmmVdQy+d9YEzEbQl7lSMDJjBGhB46+
         /CfT43J4MS9SB2bw/tk2IXGGTaI4AqWfr4kRFjEA3sDZc2XcUX69MccwoSbK2qLasa1i
         ADug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396418; x=1754001218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inLy5vcBNILr3/MOBz76JuwhCqWg6KJsocdJKuHsHow=;
        b=dINLdv/BR6U+K69v3toh4ovCxbdpCjI+PboNDVhpx7Kz/5Z6bN3jn8RQCyCkXHlGI2
         OcRpWuB9Cvq2q2/dIb0zgOUuPS7EGpW81uyQStbYSdWYMBGOVuhZecRrv6cK487ktI/E
         MuwIQjVIDAxA14cTmA86BYHeY+mhJ3aEYojGKSoqnIZ06pRmTzthxX1BLNWzJX9SRHHi
         V8RanAPv6N2DUb9gh+cincSHnobB8P/s66CB5EdhYpl8Fmw3eXD0MwGLb98HcarD9Cna
         BdIpUHlToX4Cd903iyOjlZyRgHp9erQOrhk3D+9Q45lAHOa6qRYl/ZADjEkTs12xQ5UD
         1wxA==
X-Forwarded-Encrypted: i=1; AJvYcCWl2j+64/C+P+RLQ4D42AHelM+8SLnubMTuOjZtpdbs/3DIcjxk0s+CiieWmmmQi/K0OYszB9I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yywpz4fNqkribWsKZLWb1Yc4D9B3kF0e8PORRjHz1rnNf9j6zNf
	2A7kfEqAqtaiUMVHoqDcNcoLpSKqJHwCBR55oj+QJv0fKbNWV2F/WmSUzWL8ebiLGU2tCYm40Qe
	fjQkCdg==
X-Google-Smtp-Source: AGHT+IE9v+AMqISEN6fUyAdtK8mFeHQvOl0cmpRw928j7ZGnBCeUKwILml7veHgu+g+g3U0uNgaRQdu3bsM=
X-Received: from pjbsy11.prod.google.com ([2002:a17:90b:2d0b:b0:31a:aa02:8c50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0b:b0:30a:3e8e:ea30
 with SMTP id 98e67ed59e1d1-31e662e841emr4851203a91.11.1753396418146; Thu, 24
 Jul 2025 15:33:38 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:33:36 -0700
In-Reply-To: <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-11-tabba@google.com>
 <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Message-ID: <aIK0wHgP91XhNEMC@google.com>
Subject: Re: [PATCH v16 10/22] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
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
> On 7/23/2025 6:47 PM, Fuad Tabba wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a1c49bc681c4..e5cd54ba1eaa 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
> > +#ifdef CONFIG_KVM_GUEST_MEMFD
> > +/*
> > + * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
> > + * (the private vs. shared tracking needs to be moved into guest_memfd).
> > + */
> > +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> > +{
> > +	return !kvm_arch_has_private_mem(kvm);
> > +}
> > +
> 
> I think it's better to move the kvm_arch_supports_gmem_mmap() stuff to patch
> 20. Because we don't know how kvm_arch_supports_gmem_mmap() is going to be
> used unitll that patch.

No strong preference on my end.
