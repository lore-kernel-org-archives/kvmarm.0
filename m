Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F52035202A
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184605; cv=none; b=XBlH0x4SFBhSuu5n5/fDJP8hdywBkihvKqXS/itVSRgLzyI13hmfQZywPmO+NElmtd3zkC+853AcLCClVGEEj+mJjCAlbsoFDKBrOUXZielrt2+CvxSqAqVMjf71d2d+emtEXrORAjhbfNG/CvrlZ6eto4dHtxr0rNVpBQQx6b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184605; c=relaxed/simple;
	bh=Xb+U6YJSUeoOboOu794hniiPkJcsrI7/3PRgA18qQs4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gPxXqOTBIRqfhCzST7F3XMPAUErl+4wIVrZwanBbowhHr5sGmPSs7qQIZXl7sENWLCsI7jyhNIdYKxe55KNw81tYYxUoYXVXvYfSXnse1zBVgNzF6KC+zXvNP8OHkaF193FpiIZpM+HTr9YOhyv64k+hs5wiP1noM8by8H64LZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OIKahD5V; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OIKahD5V"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so1856436a91.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 10:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790184598; x=1790789398; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lEgwGyblZ3NAaQJFmRUZMB/ng9M+MOX69eMi4kIb+DU=;
        b=OIKahD5VK84VMo1ENX8W6VJa23ygUqeyYwzcjOMh1EVhIc7ujupeB1GrBZvtKbS32V
         o8UBExURTfz7gJylQoP8UhzBfGYR/oIgJJv4ZuNgwHPs6ADNj9sJjivshYDyI4cxBcdy
         coVM7LrwkDnHPNjePpDLhkKJi1E4FBEGtp2Oe36E31TUj2oiIH+sjuKsg2bn1svlbAHQ
         jFl4mfaEhY3mqvoJm1r91mj3+PROyF7q7XhrPs7asYtu6xNyvUOXRVVr8PVtxByEaLmn
         i6RUJSIYIbXYtgMfB+gMWPlUQHh7fl1DKLcb8nHeYF3PGXQBhAq8hFEYMj1TA8VXNiQd
         8e1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184598; x=1790789398;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lEgwGyblZ3NAaQJFmRUZMB/ng9M+MOX69eMi4kIb+DU=;
        b=LecY0SufmRFQXUOQgTSLJmMpJtdBKv+dGw6GP8Dz6VVS3I6RHFFlWnIry0lJlblq/5
         H2iVh/Am/p8FaN6MjPv5KjIDTZJ7OkshxVdv+YJkAeZlIM5Z1FISADKhT3JaZpGw2P7S
         bx0LsWI/Cxub8COeksJNfelid6gDQFmASoCh6o0PntSV9VVYkIStnjol2ezv+9mH6gEW
         s0o51ySPaTUOgg8NSSDYpOGIYZoLA5CY5eBCPBc0LPqvBw8Tn9AfOIARN/2dn8hkNSfS
         +E843QcXmsUChOk3ezdB6y7V9Bg7jqGKQyvSkbTmhPcPotq00+/8jNCcbUCfp+xmMAql
         3M4w==
X-Forwarded-Encrypted: i=1; AKwUvBy7qYV/UYTW0Dy/fPZl3LCafKbXzggUNk8Qj9TnRZY9QpK7pjmhsNAkmPsamcpeAcotD0zzs9Y=@lists.linux.dev
X-Gm-Message-State: AFuF++nBC+c1DrVmZ2LazQMcjQpWTelUbUDZoFcji1yrUp6MBWcqK63K
	axLDUrfJtvWmYoTD/xD2bEly+RhfCA0DwHKib+lcrmjk2aZ+rUeQxc3rE2Ydq7vGHIwuiwuEfeA
	bjAEkrQ==
X-Received: from pjbmr22.prod.google.com ([2002:a17:90b:2396:b0:3a0:3f81:b5c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcb:b0:39e:b15:7950
 with SMTP id 98e67ed59e1d1-3a07e4f7befmr2966146a91.23.1790184597504; Wed, 23
 Sep 2026 10:29:57 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:29:56 -0700
In-Reply-To: <20260923-kvm-arm-prefault-v4-1-d4b0b4dfa8c3@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260923-kvm-arm-prefault-v4-0-d4b0b4dfa8c3@kernel.org> <20260923-kvm-arm-prefault-v4-1-d4b0b4dfa8c3@kernel.org>
Message-ID: <arQMlH-LWyRGJWt2@google.com>
Subject: Re: [PATCH v4 01/14] KVM: Allow architectures to disallow pre-fault
From: Sean Christopherson <seanjc@google.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Randy Dunlap <rdunlap@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
	Jack Thomson <jackabt.amazon@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 23, 2026, Lorenzo Stoakes (ARM) wrote:
> All existing architectures which implement KVM pre-fault (x86, s390) have
> mechanisms for disallowing pre-faulting.
> 
> Currently these are open coded as part of kvm_arch_vcpu_pre_fault_memory().
> 
> Formalise this by moving them into a new kvm_arch_pre_fault_allowed() hook,
> which every architecture selecting CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY must
> implement, returning an error code if the operation is disallowed or 0
> otherwise.
> 
> The hook is called early in the generic code, allowing architectures to
> disallow the operation prior to vCPU load.
> 
> This is important, as kvm_vcpu_pre_fault_memory() is the only place where
> generic code can call vcpu_load() on a vCPU that has not yet been
> initialised.
> 
> This lays the foundation for a future change which implements pre-faulting
> for arm64 which needs to disallow the mechanism for uninitialised vCPUs.
> 
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>
