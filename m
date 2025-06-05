Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA892750EA
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749144450; cv=none; b=Hqa53pKZZdJz7GsyRGXthJwbuNq/PVIWeGZ/kAqTqS4gW6s6sJ03h3JE+siMPbWZxnCEWcuHrHOpFi+NxNqpyUNaT7hdXe9fb5zCZvO2SEtnSLVlV5MrffIwyT0GctOgZgIUzaBtFoFki2+JnLxWvpTlgm1CoYwlYUlQyF29IKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749144450; c=relaxed/simple;
	bh=ypTCgnGwg5IbrjzUHrWEmJaTyMcNWrNCp7q14fmj92w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QJp11uIG5xGgEWbSj8x3HIcWz+d1B17wQiXOjYzEfzEESaxv5e5lrAxmZJmBMX/6bcc7/uj7nbd2lBnkOA7h2jCJtdNP8h4A6XLeC5fC7awjNnPi4y1pWVWIgXk1nIM9yAcukYol7MsofvCjZ5EoyI/PBbsyOG7bhJirzjV/7K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYPJWHkd; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYPJWHkd"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-70e77831d68so13655567b3.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 10:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749144447; x=1749749247; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqnn2BaHL5jjvXNbCDh0HtrOgixx6puwO+NS1bohbRc=;
        b=jYPJWHkdwG0x2zZRsFhlSm3S8GXHhkotvtVYYa+Qz3Ci3jwCdhLujaIdw6xDBxT01Q
         57eqCMcgKP9zMEeApB7L2TG17d8I788LCMn3TkKBWjko5/0BagnTGohgIWE6ZPc2nIEu
         jjFaNGNlNONbme5nlrM9nDQ+8LTiSkVRxpZjMFUgUAaei/uGgNwhh5PDlGKAH7nz1fZ9
         eZQjhonyRqBhayEZ6/KK3g4kwvOz5IpbAuZr50WczVmWyVDCNhNjq9DAmezdWBo/dp6Z
         ZauVzSRAcmG5BfiBQkK7NwkRUkn1EAiLK/2VDbZ4XPdWWkaLEzwzub+KUbQtg51Qen8t
         499w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749144447; x=1749749247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqnn2BaHL5jjvXNbCDh0HtrOgixx6puwO+NS1bohbRc=;
        b=I8ocGM1POqr0C8yYVY3hHzjERrphtZKlcVOWArSt8i18NWi2bE82Ko1/9aWl5f6wmF
         gahxVdlSIO3DJrQRxXfUuzqoFD06M12XCukfKfz6hNVLnlLueAXG07oXwGu+WJVECxPI
         4CxQLx5Y1pnmoFdZJR7pUH7/q2d970wHTgmm9yzNxdHbU5K+xH/m2Sas+PQ2iTrAoxLA
         /pu7jocmFyJQmtYl/ruwU/Ca9uuoToL9n+5drr5dOoWYtKF6XbYmYDqwb/+zn5zRLnjI
         jnr8K9h780vtWFLG5f2z1dhlADXGe/dUSdsHT60wcyiRwisNjkiTkhmK+SNWedd/4eml
         7RSw==
X-Forwarded-Encrypted: i=1; AJvYcCU1ifTQIIg7xApRC8yTqDRVGJI8QWLThCBdqjHvrTfhfVIwCDyDdZKY+TthzumU8098CKI/Brg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ1jEMRGhNsp8qW+K8vvd7n7znFF36sinz7+rj1azTAkSb3xhY
	iZBiULaBo+rIAcGPvqToPhZntGeG6LN1dyC6Ic8dW+Dj5upIIPkMnF1YXf1JYFdKhaGkdv+y5LQ
	KzSmv6vl9pUqAtHLpB88zCXBXVp+aF1W0s2+e5h1t
X-Gm-Gg: ASbGncssjDFk8fwq9elbtnPACyDiEnZ4rQf5wvipgIibQNxMsJDY7JdWHopzT163X4r
	WpQZT+23xE+h9VK0GSJrxNyN40zOqAXxcGiNinKCb+KHtuNbDYE3WsRUz1+xzCKteA5tfFL0OB7
	LNbKfTfqgZwNO98iLL49tSrekP2E2bt1PY4bwq82tquOZPJ3uXIU6pT7Gep3XZ8PB3a1NST4VLN
	w==
X-Google-Smtp-Source: AGHT+IHn5/wKNbQI7vSalTh67RacBOPcQxELVMGr9+xQc8VXWu2LJeEyltIok2m0x5MIgx3zLGdGw/XrfKms7dj72v4=
X-Received: by 2002:a05:690c:998b:b0:70c:d256:e7fc with SMTP id
 00721157ae682-710f76860c0mr3864297b3.21.1749144446771; Thu, 05 Jun 2025
 10:27:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-16-tabba@google.com>
In-Reply-To: <20250605153800.557144-16-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 5 Jun 2025 10:26:51 -0700
X-Gm-Features: AX0GCFsB1VCQwR2A3HvXMZ_dWbE-qcPDzOfRtnENxU5ylhm95m2ctpABU2Dvxt4
Message-ID: <CADrL8HUaHAD2Gp7k2uRAper2aMmem39dM9e=ydKMAqvJ=eDxKw@mail.gmail.com>
Subject: Re: [PATCH v11 15/18] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote:
>
> Enable the host mapping of guest_memfd-backed memory on arm64.
>
> This applies to all current arm64 VM types that support guest_memfd.
> Future VM types can restrict this behavior via the
> kvm_arch_gmem_supports_shared_mem() hook if needed.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  arch/arm64/kvm/Kconfig            | 1 +
>  arch/arm64/kvm/mmu.c              | 7 +++++++
>  3 files changed, 13 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 08ba91e6fb03..8add94929711 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1593,4 +1593,9 @@ static inline bool kvm_arch_has_irq_bypass(void)
>         return true;
>  }
>
> +#ifdef CONFIG_KVM_GMEM
> +#define kvm_arch_supports_gmem(kvm) true
> +#define kvm_arch_supports_gmem_shared_mem(kvm) IS_ENABLED(CONFIG_KVM_GME=
M_SHARED_MEM)
> +#endif

Thanks!

> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 096e45acadb2..8c1e1964b46a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -38,6 +38,7 @@ menuconfig KVM
>         select HAVE_KVM_VCPU_RUN_PID_CHANGE
>         select SCHED_INFO
>         select GUEST_PERF_EVENTS if PERF_EVENTS
> +       select KVM_GMEM_SHARED_MEM
>         help
>           Support hosting virtualized guest machines.
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f14925fe6144..19aca1442bbf 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2281,6 +2281,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm=
,
>         if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu=
) >> PAGE_SHIFT))
>                 return -EFAULT;
>
> +       /*
> +        * Only support guest_memfd backed memslots with shared memory, s=
ince
> +        * there aren't any CoCo VMs that support only private memory on =
arm64.
> +        */
> +       if (kvm_slot_has_gmem(new) && !kvm_gmem_memslot_supports_shared(n=
ew))
> +               return -EINVAL;
> +
>         hva =3D new->userspace_addr;
>         reg_end =3D hva + (new->npages << PAGE_SHIFT);
>
> --
> 2.49.0.1266.g31b7d2e469-goog
>
