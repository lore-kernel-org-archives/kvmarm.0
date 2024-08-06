Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028B31EA0A0
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722956653; cv=none; b=nAOIqKJs7YUiKSeZYdF/grqMy4DZNYtQFB07437FwJJcNe5D6lf+hvhTcw/wk+z/FUMAYz8jhD92mU7wpxlmiKNlCTTWjZQLA3oFwjw7NrXx/VN8zMzHEep8d69io9p7umqxOVqnF6qG7l6laovZEhiGNnirN+Z/cbhBwjTpLyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722956653; c=relaxed/simple;
	bh=Ojp+5mgXIeLmoaOntdYobjdPsSlf5Jv2i52l1FMoU8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mwzIRCr2PjKat8jS6kl4QaCTkSXqWWOYHL9RVbtSUITOSYZYcRf/akP93iphMEmqCIKYdSeLxgDfKfnh5/OUFmExqS66Y2u/fnTR3XNJ49B4ceTL5x44pdbM8f1udakful0RhijLB/axzjo+iZkcxbWJ8Davom16t21DqezkyH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=QtCe5kh2; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="QtCe5kh2"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8152f0c63c1so27261739f.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1722956651; x=1723561451; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nqpVJEa3gF+vLMgvdD8twTbWevyBd39Y3ES27W51MM=;
        b=QtCe5kh2oAFgYHFizC8ytOIItJmIE7nkani7O+lZs85DzAffl+IKvbL2mnTKLo4KJk
         xS26WJPqOBmG5h/m+HVwgQMaBGBGY7kcvSBJduVD57RKMf2g7J9fJsmm9klDMzvstAn3
         Z6Oho53KR4ZGiawIYr0ETRfsqZoE8fUWoScr3fWZ69szobgINEO6667SS2z6Ji4bxc/B
         H90UKwgFp4j4m9nhnkZEQmEvPAfaWb6G9ynEEZCueIOmwwL31wMNfrYlaWnTz6iuPIzi
         2iJehlP++zWeJ4v0eRij3dH2Dujc63LgI6t4y2ze9MRHQY0OvEX6eqiQcIQkfcBV9Jhs
         D99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722956651; x=1723561451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nqpVJEa3gF+vLMgvdD8twTbWevyBd39Y3ES27W51MM=;
        b=JltiBzjTDp3RHlO55nXhw0DCNAzG7hupuaEbwx+WVMX2ndntmoWBdMxsc7F6LcV9jG
         SCtMMRzu8hGFzOVzLFPJ+F3L/pWEoK6MU0Yswta3ffrL3dm7SLPZnswZ7PxwSAGaE7tb
         P0fbuntWawe8phcSuEHpJ/R4wAgrRrGiYiMAw8oDsA4o7pIEkPR77cOmw5BjLVb9qPc0
         tWq2Fu9BiWK4xi/6Qj1hb70td0VbIhICCiX4dXlmUeOYTP1ft/JOvRQ4+revETl8APw1
         jNbRexACY2FVuDZryJkv9tSAmpk2DkhY0aYp8tmTn50buPzbPGpzeG4Gr0nlF9/PqwjD
         Xluw==
X-Forwarded-Encrypted: i=1; AJvYcCWRkGT2a4ZW1EQTGbw6QDIw7EGJBrniwu7c9EQ4gIeVal6XtnaiWVMP59VIfp+E8YDyaNuu0jD6Z5+3DqwwEVfhNxOSI6as
X-Gm-Message-State: AOJu0Yxaq35dXQ0QVpzlKMe+NeGqX98tK8SmQ1BL33G/9ELceqJtmhzZ
	39iuLh+mCYlXgx3rBoHJK8KkelrmsoQLfz3U8YNbabp83H/0BoHTelqwhVlaVY0eEomzry+fJnp
	k1owMaQva79vBfePdUPDLwZP02f1Mi21PcWFfvw==
X-Google-Smtp-Source: AGHT+IE5dkU8O3hsRzTzR3mqE211YMexCU92LD+ZH2mO65SVdE7w+UZ8Equ/sKTPvXFYaRtJg+9DX/UprpD7ulXsS18=
X-Received: by 2002:a92:d64d:0:b0:397:d9a9:8769 with SMTP id
 e9e14a558f8ab-39b1fc37fe5mr152610645ab.24.1722956650868; Tue, 06 Aug 2024
 08:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-57-seanjc@google.com>
In-Reply-To: <20240726235234.228822-57-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 6 Aug 2024 20:33:59 +0530
Message-ID: <CAAhSdy1DvkU_C2jmtA1SBNfjp1gxu_6RhFKbf-hkhSNQeTXwwA@mail.gmail.com>
Subject: Re: [PATCH v12 56/84] KVM: RISC-V: Mark "struct page" pfns dirty iff
 a stage-2 PTE is installed
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
> Don't mark pages dirty if KVM bails from the page fault handler without
> installing a stage-2 mapping, i.e. if the page is guaranteed to not be
> written by the guest.
>
> In addition to being a (very) minor fix, this paves the way for convertin=
g
> RISC-V to use kvm_release_faultin_page().
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  arch/riscv/kvm/mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index b63650f9b966..06aa5a0d056d 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -669,7 +669,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 goto out_unlock;
>
>         if (writable) {
> -               kvm_set_pfn_dirty(hfn);
>                 mark_page_dirty(kvm, gfn);
>                 ret =3D gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHI=
FT,
>                                       vma_pagesize, false, true);
> @@ -682,6 +681,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 kvm_err("Failed to map in G-stage\n");
>
>  out_unlock:
> +       if ((!ret || ret =3D=3D -EEXIST) && writable)
> +               kvm_set_pfn_dirty(hfn);
> +
>         spin_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(hfn);
>         kvm_release_pfn_clean(hfn);
> --
> 2.46.0.rc1.232.g9752f9e123-goog
>
