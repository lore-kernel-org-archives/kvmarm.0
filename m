Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71421EA0BD
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722956674; cv=none; b=b0bHudL4v1GYeJ39jZEZ0U70VaFnaum4+LcPVNpLXpKJJd/tu8ztouVDb18tIF1gHovUiLKf7zN3GR+VgyQmx8zi4deGx1yjrvvRSiUBtLwyP4Le6YVJFQBYnXTz3bmSBJ2p24L+xN30prSJtd7As3bQVG7iFmxhugg/0fi14yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722956674; c=relaxed/simple;
	bh=LUNW9RUIstkrjibzIwDixQZwd8z0VowIYpuqj/xpKxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RdFCg4eihC8wRxA8ZBdCKBmFszFAkSFr8EEAI2YlDbnFzF8QUp8QCRC2LSZkmOK0v8h9eAOuj8dRglG4myk8gPdnIYJIFiMjmHmHpBazqaAHrxyxMHoWC41GHmLKm+1SDQZhlAS8My7J5qL7GIK6nX4BueXfjMXTMXSFTf1O4Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=YFhpMdNJ; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="YFhpMdNJ"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-37636c3872bso2972635ab.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 08:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1722956672; x=1723561472; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLbAu/3JQVhbekGE1m18EyrvzfniM5U0p+PtTw3SPlQ=;
        b=YFhpMdNJsX1I38w9hgilx9IeoNEcRPfUutZDylHGvcpaEUZUGN1XOwVW4voQhU2lbB
         JsdWnC75u4LrcdlZ8IvQfHtNAv6a2Sa+f7IBoe/iB+w7l2xp7e2Rr/iz1zf/75LWOm3i
         wtYu/AgnSBcq+vqTLphUvh1YuZHi0+dEf7IfLOnzYPBcB/aYG09E2eQGcZ2EUU1slOSq
         IuqoD+egy7/Ql/+XrtY7TLOhR+Mh5WwMrIbUbZlqRBmPU/e4nEnn90kPGA+deVaXbkVC
         vr3mrrIKrcjOQgZVDAlVcbXy8+L2t8aiUOzxq6c4beYoNvXuOuDZu6Ik+EfgDl2dJo5h
         3bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722956672; x=1723561472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uLbAu/3JQVhbekGE1m18EyrvzfniM5U0p+PtTw3SPlQ=;
        b=j9hzfG+dKa0hI3ZMUhSvT/DM0bfA6yoUaSl4eYcoJHnYuxIE8pQyxjlB8BXTD4ifpu
         FpofVQlUiGrmFoY6+I2sP1knLKg47TTS6676Z2VA2GIbo0DriXT0PEZDj5V5gAVW62vX
         ml5RtgGwt5hKBJgYGxPJzKHf33BrdXojmjuR99yLI5JcO125Ke8BgSRXFT8d0cc8a+05
         A552U6INsVUZtbJpPmeCO3LQeXq99QyfkNtBESzqA5Ivnk/cQXCsELt7nxJmgp3CI1/v
         qSEpbVC6YxwuQ9LiRCPSqrikc7w05wb+JXaolIyZ199iy+WYlZ4+T4X+TP4em0jJI3OM
         j6TA==
X-Forwarded-Encrypted: i=1; AJvYcCU/pYj5pumoe9o+UpJu1YvEwj3Sa/ar4yaO562Lgw56yRllw5xXkGx4HW0aLv/5QaqKMSxhGhd9kkJTC+WLJIeWEgaD4fYD
X-Gm-Message-State: AOJu0Yzp2NcT8lroEB0CbVRY49Dm+3yW1GAC+cxf9NjO9pEcAG7jumJB
	fN6iPyXxFx+Yv5lrOIzbxQYuuA/RG3hd/rlMl78Was+vmqhyCOJMDNLHMuyDPFeVk0TUkii3qGu
	Gt5YOu4VGgFAh8UpkHC3BhaNt9mHawRSVPNTuYQ==
X-Google-Smtp-Source: AGHT+IHdYOEWf6qlsoZVXjSZ7lVz4nHt9XoyHycNquwMn333FMaz4B6ys0O5Sw1BKpWpYjBg2+pZRslO+PRicrnJai8=
X-Received: by 2002:a92:d1cd:0:b0:39a:e86b:a76a with SMTP id
 e9e14a558f8ab-39b1fc2bbbdmr148654105ab.26.1722956671518; Tue, 06 Aug 2024
 08:04:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-59-seanjc@google.com>
In-Reply-To: <20240726235234.228822-59-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 6 Aug 2024 20:34:20 +0530
Message-ID: <CAAhSdy2whfRBm9HBkr=gSwxpFHGwGtB70fKNCqG1-MeHmB1K7w@mail.gmail.com>
Subject: Re: [PATCH v12 58/84] KVM: RISC-V: Use kvm_faultin_pfn() when mapping
 pfns into the guest
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2024 at 5:24=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Convert RISC-V to __kvm_faultin_pfn()+kvm_release_faultin_page(), which
> are new APIs to consolidate arch code and provide consistent behavior
> across all KVM architectures.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  arch/riscv/kvm/mmu.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 806f68e70642..f73d6a79a78c 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -601,6 +601,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>         bool logging =3D (memslot->dirty_bitmap &&
>                         !(memslot->flags & KVM_MEM_READONLY)) ? true : fa=
lse;
>         unsigned long vma_pagesize, mmu_seq;
> +       struct page *page;
>
>         /* We need minimum second+third level pages */
>         ret =3D kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
> @@ -631,7 +632,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>
>         /*
>          * Read mmu_invalidate_seq so that KVM can detect if the results =
of
> -        * vma_lookup() or gfn_to_pfn_prot() become stale priort to acqui=
ring
> +        * vma_lookup() or __kvm_faultin_pfn() become stale priort to acq=
uiring
>          * kvm->mmu_lock.
>          *
>          * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pa=
irs
> @@ -647,7 +648,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 return -EFAULT;
>         }
>
> -       hfn =3D gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
> +       hfn =3D kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
>         if (hfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>                 send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
>                                 vma_pageshift, current);
> @@ -681,11 +682,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 kvm_err("Failed to map in G-stage\n");
>
>  out_unlock:
> -       if ((!ret || ret =3D=3D -EEXIST) && writable)
> -               kvm_set_pfn_dirty(hfn);
> -       else
> -               kvm_release_pfn_clean(hfn);
> -
> +       kvm_release_faultin_page(kvm, page, ret && ret !=3D -EEXIST, writ=
able);
>         spin_unlock(&kvm->mmu_lock);
>         return ret;
>  }
> --
> 2.46.0.rc1.232.g9752f9e123-goog
>
