Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771EF1BC08F
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722956661; cv=none; b=qkFFl9PJygotssalqj12vXYtpSw4XWpDC+gcbUGUSqvZKxY2JZ4VW8DhW+cQka7TVLCYy1WQBcnOpFdDpJTL1u3wQGf4pwygGh/T5eoYr/c1QjHlQnhE8AbCX2F0TKqMoZyYh691ZXgiC8E++Xp2Y0BLmy0OtRzQeeDUTNzqdvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722956661; c=relaxed/simple;
	bh=weU0/ygthEVhph5l+8/dKvcNrdBMCRxTJh5fbqP3ZFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NHvdJSKX3BkWdTdE7Azokwc62pBAofLfWCgcrOnQ/sK98KnKlq2TuuNjjB+hD58ROCtjoDHJblf6SA3OW3gReoRRf0wX0LID786OHc/6qeqAwiaCF/k6755BnIq7rfM+jFrmam4agrH4Eh2zt5Dq3Ke7RWx5AMaYY9ZQNfVo9Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=uTzZeI1A; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="uTzZeI1A"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-81f96eaa02aso37589139f.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1722956660; x=1723561460; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLks5Q0iPBrgmJrvgcvS8LOwX/9jLhdRfGiAtwiNPmc=;
        b=uTzZeI1ApYVIrc5vbkIUdK2ueJIyMCP5+naYEWQu1nIFDMOYC/1K69B8+sQfEYcvly
         z3sUq8RGUES7GodH8YgMGfPCayYeEUwIi3bsxDTfKXdJlBjfYekzN0kZJZZdMrnaTGtu
         tGXUNjE1EOFacfNR4BmxSVBHaTK8SvluFH0bAJyHSp4QY6DmukYZGl8hBjmpjXvU4CJI
         YIvfEQJdBarOHbxnZJ4wqvJ4//pJyw/NJf7Yph/f2/xTfVz7Xye252/PoEUCH5sEbIyv
         pA5r3pn4mmqQNfRa8dM0VIyo40mi1ex5lozA5T6aZRvOtMV8nsURyzcnRgyf9XsP2RCZ
         qxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722956660; x=1723561460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLks5Q0iPBrgmJrvgcvS8LOwX/9jLhdRfGiAtwiNPmc=;
        b=GpXo8WfYqrRyz5nvRl5jOqJiqevcMHKQbgJmkBFxBw9i86JjE8dUiGCQgOjuAaDUu7
         gVdUSGhwrAw9CDw+PHDRetx09NM8JtUcatMst/K9q8kngMU7cSITp9/MU0m7g2gZnv2u
         sXR4ZsQuEv2eOYHSG34rMEOFdpPe3fN8mCEbaj/n5vPeFlTW0KsW5yhPKq75PTwc70BU
         zb+bfDTPwCFxksV+flOhJfO464NKSJCi8f1H5XIk5Voz4oN3KeK01Js9bahGVaFwO16J
         EBJgmfilkDk/lzLX8cl17BlzxDVP5IiAL06SgHSgO3lfdwlqLmHbIE6e1bBTZNM2A+K4
         fx4w==
X-Forwarded-Encrypted: i=1; AJvYcCXDIuSNhxrWFf7UPah3hG939a17EpWEsgkZqpv+1YHEm2bZNMXYTMSj+WvaM9EOWrTmu4wK0NHtd2rou60+3nv9MrRFZswP
X-Gm-Message-State: AOJu0YwKbtLehLijtIe3VDsZ9xVwa2oMVfnUvGvyBa4p/1X0SQSyxdGk
	81UhOjEEgc+Y0iiMHb5JeFFonncQdOJUbPhFbqEbaZBoejwmK1kLf1r1/avhRyVoGJJUXehOPkB
	bojOxUhBqzCnZXU7LMs4iNKzQdJ2s2SHEPjT+TQ==
X-Google-Smtp-Source: AGHT+IGyDNkeg1CkpECSQ0akll4U0MAQSWPOL8L25sxstJveeDCZd19K8yTTFoue56gvit0ch8aH+2CGmbmtibK8NQ8=
X-Received: by 2002:a92:c0d1:0:b0:374:9c67:1df6 with SMTP id
 e9e14a558f8ab-39b1fc23546mr155430195ab.22.1722956659564; Tue, 06 Aug 2024
 08:04:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-58-seanjc@google.com>
In-Reply-To: <20240726235234.228822-58-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 6 Aug 2024 20:34:08 +0530
Message-ID: <CAAhSdy2rvPCuN7ROU4k9pAuyCZUnyDf2DhHjfSa_pA5SG6Q5DA@mail.gmail.com>
Subject: Re: [PATCH v12 57/84] KVM: RISC-V: Mark "struct page" pfns accessed
 before dropping mmu_lock
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
> Mark pages accessed before dropping mmu_lock when faulting in guest memor=
y
> so that RISC-V can convert to kvm_release_faultin_page() without tripping
> its lockdep assertion on mmu_lock being held.  Marking pages accessed
> outside of mmu_lock is ok (not great, but safe), but marking pages _dirty=
_
> outside of mmu_lock can make filesystems unhappy.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  arch/riscv/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 06aa5a0d056d..806f68e70642 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -683,10 +683,10 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  out_unlock:
>         if ((!ret || ret =3D=3D -EEXIST) && writable)
>                 kvm_set_pfn_dirty(hfn);
> +       else
> +               kvm_release_pfn_clean(hfn);
>
>         spin_unlock(&kvm->mmu_lock);
> -       kvm_set_pfn_accessed(hfn);
> -       kvm_release_pfn_clean(hfn);
>         return ret;
>  }
>
> --
> 2.46.0.rc1.232.g9752f9e123-goog
>
