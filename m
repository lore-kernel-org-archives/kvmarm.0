Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A811B0439
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949309; cv=none; b=Kyz/IjlUleS6vygV4vRmpCDEX1pQeTI5kvaj4plK2UQ+wQ6w+6MYq1S36KSRfE6hEjev6OBAkWx8ZZ+its/bAtUZ0MJAs+uXU7f/tn7p1vgGiqze6fFZ+w8SNrwyjbUYRzqlK/PhVOdvqdKaTosYli04xrkCp+WuqoDjTePuN7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949309; c=relaxed/simple;
	bh=e5Hocw5GiE127jmgexsLYEDO3B9Flp3i16mxz7Kb7EU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/o9VrA1UT0WyNigJ+MLrNoJHlHOHb8uFvPgOHwbv3f2BMKUAs8IrtPzSrkg25kug+CimQgbicquNFGQtxF2Isysr3Xw3NIniwwbkcwZd20l/qh17OKNSaGcQIP3d4fmicNgYDhExv297fY7RTbMsWkplEEAbPfzuqXrEI1mzbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zMQGeevb; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zMQGeevb"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aef56cea5bso60921cf.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949306; x=1754554106; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jeno8f5+usJMV/ac339wMG/DF96hWxCd1z1Rm4i7gbQ=;
        b=zMQGeevbeDZt5ISay+l7MXSoyfYZmYkp0xt6CMZAv5sIw+WunWUzRm/3qqE6bHAQxb
         JQ6wRMadha+BphM4IGQmko+diWPgf8ahzt9lPWP2GQMZN2p3XJedtuIgK8Dde0y6tDMZ
         703iQqaEFAV8yI/hAI3g0NNw8h54YZEe8Lj3NQbE6kcwg24SQzEg7pB2bFX68HgG4Cm0
         2FXI3RiPnsItXfG+sN+dnlOqbcwKkckZBn2WYMrLeQiFUa2hJ46xc2JAC4t/BB7+UMgG
         VJn5c9kvJH0bD+jouV8hg+5Y+0KPtMK3LZDqCfCrEjyDOlUclR2VXAD+Ag//llx89k1z
         DLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949306; x=1754554106;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jeno8f5+usJMV/ac339wMG/DF96hWxCd1z1Rm4i7gbQ=;
        b=Go6EFAHOy3QnuZYLqgk7myE6jUMRN+A9DbVsIPQ+imKepBuFyyMC/SijWc1tqBd+lH
         C+HXy0uLfRqkQ50hF6ZxtOd8lv1NwDRkkSSVEXn28ix3iTC7pj2myFno+3EFxqHdU77t
         27OeO5jGEGOyaO5rXf7LJNAICULbwlQ2rzGPfrJooPSF/jCtEjP5DUDbjmSrWTmHEBOk
         6EJmO0Wy37zWj/+DBKM6f0E6RSWtyTyveTasHC42x3oX/IlMmk8Oh3R9KZjyhwagy5Uf
         v6tn2kt53znv/0x0V0egr/YbGmC3biGBah7fAat+MCEsnKz0rF49keWXOjMC3jEi+nnp
         F8SA==
X-Forwarded-Encrypted: i=1; AJvYcCUyeu+VEB1uG0gFIEY+JhIi6INaSUrH7HM4zLxQF4tw4+ZFEFuhpsLoyuNk9C9K/lbgpHViV9o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMA60t8uqwPqGm/3PLbChC2gOHmdrL3eO1m0TsAD/HkqlIk3zx
	g4spVH0RRHCShdXAVImdVIzglIs1K7hjVMMIAIbBvnbFeSmWsoTU3/eZFug5tz1iR77dvuJsQ7N
	PSWtLzgPCWo7Qn/tOV7ZB2rnobzKeKi+rVqk09hsa
X-Gm-Gg: ASbGnctA48HiitisQh4tt9IT11ChEM+LiVzaLPjkzQPDHHRT1NwwUb+bVIkq43rPfnc
	Ud4/M6J+mrHKpe+iUeFbVF/i260jymVCA1mDZKN9hTKkrgpG6RdvZdPk4W6L5MJNHHylzNbzTFR
	qPNZdfsEPYpnWoL99Uph2HnxZeEOeocZE3S7ie6jZwfY0Vb+QqkgsKuPBgwl2aePitdW8+BnFIc
	cDiEO0=
X-Google-Smtp-Source: AGHT+IFbmVQN1x5b+62iRQ3U8XZDUkGVQZbiaLNVWtLXncLKF5qCofgpdoCiMDPvbq7m8yKnT95C2PAE3uUVd0hLcc4=
X-Received: by 2002:a05:622a:13cd:b0:4a6:fc57:b85a with SMTP id
 d75a77b69052e-4aeeff89123mr2556921cf.14.1753949305731; Thu, 31 Jul 2025
 01:08:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-5-seanjc@google.com>
In-Reply-To: <20250729225455.670324-5-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:07:49 +0100
X-Gm-Features: Ac12FXy0R_yNTeBd7qrXPHZNFcLfR6ujjjzcWA_Yc7EECI6d3AjDyGMKsJvuKKg
Message-ID: <CA+EHjTxHk4hsPXDiUY2nOfGdT9GjPvu7YdNKApkUJK4RjBKB4Q@mail.gmail.com>
Subject: Re: [PATCH v17 04/24] KVM: x86: Select TDX's KVM_GENERIC_xxx
 dependencies iff CONFIG_KVM_INTEL_TDX=y
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
> from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
> KVM.  There is no need to enable KVM's private memory support just because
> the core kernel's INTEL_TDX_HOST is enabled.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 402ba00fdf45..13ab7265b505 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
>  config KVM_INTEL
>         tristate "KVM for Intel (and compatible) processors support"
>         depends on KVM && IA32_FEAT_CTL
> -       select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
>         help
>           Provides support for KVM on processors equipped with Intel's VT
>           extensions, a.k.a. Virtual Machine Extensions (VMX).
> @@ -135,6 +133,8 @@ config KVM_INTEL_TDX
>         bool "Intel Trust Domain Extensions (TDX) support"
>         default y
>         depends on INTEL_TDX_HOST
> +       select KVM_GENERIC_PRIVATE_MEM
> +       select KVM_GENERIC_MEMORY_ATTRIBUTES
>         help
>           Provides support for launching Intel Trust Domain Extensions (TDX)
>           confidential VMs on Intel processors.
> --
> 2.50.1.552.g942d659e1b-goog
>
