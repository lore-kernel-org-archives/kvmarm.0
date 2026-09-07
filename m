Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB5943CE4B
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 08:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788769449; cv=pass; b=F7M+4Oa6fgty4XpNgxh8/KjqJavjr1GQHiVLHRPROp2Uhg5cfZ9cDSFhj2Gf4xkc3CWx0AKTMRckMGqN2kK5YLypyS9/X5hPNlBh8LkF51QNKZZSCq+Ge5gnXRou2bFLu9hOOilzjDb89bWxTbEE3bA6uDy9y5NkfKR96wG5NpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788769449; c=relaxed/simple;
	bh=eW2heI0TSrLo005hXEi9RN2qzKnbcSMx1USmy+ENf4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h3OCmpycb4RuLklCVWj1GMbcCk4QBiX9ZJpDc56B1zShFzRo3ZSpv8QnHMBmFa4Infkaag4UvZXXW4RIqywe/7pqFPzYbqn4lD1E/5Kn8TBO71A8Nh9LTbXp1qeeDCWpw8Cflq5RRztQVfWj1IOUmANc4+imnNyZUo7gUmpybs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault.org header.i=@brainfault.org header.b=kjsbKQVO; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault.org header.i=@brainfault.org header.b="kjsbKQVO"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4843e9c5960so3259106f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 01:24:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788769445; cv=none;
        d=google.com; s=arc-20260327;
        b=QxeYyq/AOKaC38dFyJBkZmBjFdpYq6bWeDX33C3Y/U9qMCfpM5brWlr05R9ABP9HMk
         PK+tLBfqaSpaVvsAaOXkTpnBATrxtAcm2QUd1pLK6sQ+AZv8022KsEfiucWOQsFaR6Er
         Afb5kWc8M6zwGjBsgMSjK5L7MHsEz9ycTejtOPO9n664TjwVxBxZT5VEukYGtlKM3hqO
         p2tF5kt46xfa0J9cGu88vYVUT8Jo6K27hj1gIRQvTPLZ3OzuoTkr29saDvf4n7fstl4D
         IWr/Cp2/PVhAKo20G6mKok0qG6RM2oYFFazPCyL81bugy4bMLWDEXt5Fdp97RglmHD5B
         6rVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h6qiSySchwLDdn88HORNI+edfDP5k4+RIZ3ev8MYNCc=;
        fh=FuZxML3DVmmmn3sfbkFvc0fxnoZBBOd+3JcnGcNOKqc=;
        b=kawI5yZeNri7XVUfY5YHl/tjIbwtzY1IALuYDyvUbiVvPKTVbQRVliqHp+aukgPZ67
         82lWRvdHmjArLEmyrOa1LnPLlVWjMAwUV0laUCfQnu+y2ocPHWBAZkXTttgUCIUnddM2
         NFX5F4e3A51I/lS1MxAKYxb1+p6eP2QXFf/QgYN/uwql8Wd0UcJORU+DPIl0QYo8C8ic
         jy+XdAw7b/OLridPQHj63nB7eFP9ZwCPOpvg83J9mnAX9/gktfdv9v3QT/YwXJTloa2K
         Lx+GevMXVyYP7fis3T4cokuRm5Vf6OnxITl3UOLRNOolmXT7Jlp1P/dYfBCHzC5Ji8Gu
         URgQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault.org; s=google; t=1788769445; x=1789374245; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h6qiSySchwLDdn88HORNI+edfDP5k4+RIZ3ev8MYNCc=;
        b=kjsbKQVOpAewjBgfDxqZPL5996xdu85QCa+JBtU+6nmZP6kZjicKmOpzxW2oGcQaqP
         xVyXfBE3TERHCFWPDnCoF6Mnaz86eaLMYq7Kvz9xRkjK0HgKgyxC7gj9l3jFCd5m9G5Q
         o0W8eImcJHoOOJM+989oW8Gp3mh28+WmN6VcxHL8f7FmPafqE5WqbTvOtevMVHpvPS1L
         qYNINu+eBpFtRLoeMUKWkDpVibctpY5qqN+3O4Ibo+y26HpOVGUdCWOUt7lHl7zhJ5d8
         MEsPGhejnl2vnTr1yPtYPz243PGOJGThLnsC0BTbsHYr18kShOqJy6H66snDYDgek/RO
         dZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788769445; x=1789374245;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h6qiSySchwLDdn88HORNI+edfDP5k4+RIZ3ev8MYNCc=;
        b=ogSdYGTpn4FHZtoPovG4aNV1KdBFXGCB7vqxrDAVyYCK97hfAnkc88ceP9XvJNep4Y
         F8dTv/JMdgzEMaPkc9eY8l59volFbJRKIl1qGH4T4HjDqczDZa9cpwBLMBaBxn4qcyTD
         SNUHhtsBvAleLyrmN4oPNVBlGjc8yDKCz7ZUVlvLlzCHp7gkY1RmuR0JdbHcE52MohKw
         P12Z8dVx7G92Z3hYMRoFlmPAMVtS4yKHGaTRSTs4K5Hmz/joBPsMwVWIfYOhRmNgFxGf
         fssFwYDpX0ylYwj20+hCf7E6siK0keVS90XNZicRTvAdIPO2eSMl7s+H/g0dIlsgWWi4
         Rm4Q==
X-Forwarded-Encrypted: i=1; AKwUvBwqhQZzzdJWmtnGZf2hFbp/G2LKhFJ0s13eMQFsLME0VHy9jF9+A5TCKpBj0uU1Qzj1Cyjdwks=@lists.linux.dev
X-Gm-Message-State: AFuF++mEft7s0ALTMoZEvgBzm2Q1IdLimF7ODqhL34GomT5fNsmROFcl
	ikLvJG1Jgx6rffexvTr1nULsA6tK62JATHqNGr4Ian9Z0WZbDjQTJ1BPW2L8l9ozb0Kh2FYsSOO
	nNFC3yJirRXFjODhKVB42l3C08283wjfzGdLnF9D1MA==
X-Gm-Gg: AYBFou199jChIkgekGos/zqOUDvSnhXa0f103AfEq9bheSAZKIkhb9KioKyXBZgsNwC
	UXQr9b8K8SLv/osYSmPg6rOgAM7s/BZ6gvTLpGKOVb3Zm7jD9bX7SNSbUJxxNuIMRt89S+1ghpg
	ABRWUOpiGsCvuwTGDrGNphFlKMCRUvREEEQgT1YKcCUalETjoosR5g8pQn8cHYtY9r/3S5DFt4Z
	6c1cD0NRn0jGZQkZttE6MlHtSdSu3vYFGaV0YqOxB8P4FpoezR9givuy/OsHiGNfmnRQASiHdGL
	vuJmqxHxoT8dBgK0gS17SS8Z3tPZu2fzbd+JIxyN4AcCNzdqNpQYa9Sy/IEvP0hTnUtLekNkaFr
	RyoTddAQmer5wotvtB0zImzv61ZnTTRhpUdunz8eoGJMyoyb9AYHrh3pzjNIc16g=
X-Received: by 2002:a05:6000:2f82:b0:485:8c16:5ef7 with SMTP id
 ffacd0b85a97d-4858c166148mr18091871f8f.49.1788769445126; Mon, 07 Sep 2026
 01:24:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-11-seanjc@google.com>
In-Reply-To: <20260902164123.2546762-11-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 7 Sep 2026 13:53:53 +0530
X-Gm-Features: AcwNN1UOItNX8Zqa8yZNak7eVCaaP3xVxuE0lRNcn1acCna6Fm_hGPjVZ5FCvUw
Message-ID: <CAAhSdy1zxu0cGnvpZEq_mPYRj07m7a+TA_8f0-sa=Mu7xtXvjA@mail.gmail.com>
Subject: Re: [PATCH v2 10/20] KVM: selftests: Add a wrapper API to allocate
 multiple page table pages
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 10:11=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Add vm_alloc_page_table_pages() and use it throughout arch code to replac=
e
> open coded equivalents.
>
> No functional change intended.
>
> Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM.

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  tools/testing/selftests/kvm/include/kvm_util.h    | 9 +++++++--
>  tools/testing/selftests/kvm/lib/arm64/processor.c | 4 +---
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 4 +---
>  tools/testing/selftests/kvm/lib/s390/processor.c  | 8 ++------
>  4 files changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index d9d39a8894e2..c56f342b16fd 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -1013,10 +1013,15 @@ static inline gpa_t vm_phy_page_alloc(struct kvm_=
vm *vm, gpa_t min_gpa,
>         return vm_phy_pages_alloc(vm, 1, min_gpa, memslot);
>  }
>
> +static inline gpa_t vm_alloc_page_table_pages(struct kvm_vm *vm, size_t =
nr_pages)
> +{
> +       return vm_phy_pages_alloc(vm, nr_pages, KVM_GUEST_PAGE_TABLE_MIN_=
PADDR,
> +                                 vm->memslots[MEM_REGION_PT]);
> +}
> +
>  static inline gpa_t vm_alloc_page_table(struct kvm_vm *vm)
>  {
> -       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -                                vm->memslots[MEM_REGION_PT]);
> +       return vm_alloc_page_table_pages(vm, 1);
>  }
>
>  /*
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/te=
sting/selftests/kvm/lib/arm64/processor.c
> index 01325bf4d36f..2dcaa2c4a038 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -115,9 +115,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>         if (vm->mmu.pgd_created)
>                 return;
>
> -       vm->mmu.pgd =3D vm_phy_pages_alloc(vm, nr_pages,
> -                                        KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -                                        vm->memslots[MEM_REGION_PT]);
> +       vm->mmu.pgd =3D vm_alloc_page_table_pages(vm, nr_pages);
>         vm->mmu.pgd_created =3D true;
>  }
>
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/te=
sting/selftests/kvm/lib/riscv/processor.c
> index ded5429f3448..c175dcd14114 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -69,9 +69,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>         if (vm->mmu.pgd_created)
>                 return;
>
> -       vm->mmu.pgd =3D vm_phy_pages_alloc(vm, nr_pages,
> -                                        KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -                                        vm->memslots[MEM_REGION_PT]);
> +       vm->mmu.pgd =3D vm_alloc_page_table_pages(vm, nr_pages);
>         vm->mmu.pgd_created =3D true;
>  }
>
> diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/tes=
ting/selftests/kvm/lib/s390/processor.c
> index fb9dab92d4d1..33f49d743b5f 100644
> --- a/tools/testing/selftests/kvm/lib/s390/processor.c
> +++ b/tools/testing/selftests/kvm/lib/s390/processor.c
> @@ -20,9 +20,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>         if (vm->mmu.pgd_created)
>                 return;
>
> -       gpa =3D vm_phy_pages_alloc(vm, PAGES_PER_REGION,
> -                                  KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -                                  vm->memslots[MEM_REGION_PT]);
> +       gpa =3D vm_alloc_page_table_pages(vm, PAGES_PER_REGION);
>         memset(addr_gpa2hva(vm, gpa), 0xff, PAGES_PER_REGION * vm->page_s=
ize);
>
>         vm->mmu.pgd =3D gpa;
> @@ -38,9 +36,7 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
>  {
>         u64 taddr;
>
> -       taddr =3D vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
> -                                  KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -                                  vm->memslots[MEM_REGION_PT]);
> +       taddr =3D vm_alloc_page_table_pages(vm, ri < 4 ? PAGES_PER_REGION=
 : 1);
>         memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page=
_size);
>
>         return (taddr & REGION_ENTRY_ORIGIN)
> --
> 2.55.0.966.g6673acef38-goog
>
