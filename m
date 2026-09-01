Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D4A3D47A9
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273798; cv=none; b=L9jKqqFbYIHIWtVNIdNFcSvFzbi2BcMbT7oHSJ5PutO4a5jJprZ/fpmJ2M4SlY76p7nzy775ANfa761975xfBiQ7EUt6BVPOHvIceFLYkssZz0WdLCCbGW+V0OYgpXy1Z9dK9Ju+Wj1T3OFSVtzjYI64PuY3n9ezePMQp5DszGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273798; c=relaxed/simple;
	bh=qMqqtXFnIeU06gpJdvWqkHC1kvHEcyriAiG82aOitE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MmxXNudiQyoed81HitoEhfsH1h0W3SmZBhRn3A5D1v4oJrxGw+vvYqC9rehgJAvdnlYvpwJ5lXMg0feZl1Oe8X46NuUNabVqzDM+w7NhtoDcW3VZHKeVLhbqm5Uaxqg5IzelxEzLF/XigvxfxILoNol03sKlvjuROZeT3yVF634=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tV7hWVeE; arc=none smtp.client-ip=95.215.58.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tV7hWVeE"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qMqqtXFnIeU06gpJdvWqkHC1kvHEcyriAiG82aOitE4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788273794; v=1; x=1788878594;
 b=tV7hWVeEzPynyywJIo1qTHD5PUR3vcmKL6/tBqhsFxcjRmf82MQTECTcrKwAgbTXcX3Kv7D8
 48hX7z37plkkuDk/DJcxoEb6YRMsTpULDGIYZKLS2RpY/b4VdtSwPyel8ZJSfZqsWEjvnYl55Yi
 qxGDVG8Hq93yMzhghY89irN8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8522e90eba2312d0;
	Tue, 01 Sep 2026 14:43:14 +0000
X-Mizu-Trace-ID: 8522e90eba2312d0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so6692e87.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 07:43:13 -0700 (PDT)
X-Gm-Message-State: AFuF++mmo4ZJA+IrOL/CUaAZ7CbWJHoQ7GoanD+JHL67x1E9uky4X6Yl
	bzCjXPwMri9jW1hUFG8XH2B4Cdzy+DNT5BLDF4aVPmTzPFh7xiz7iRvBYQ9tEXz7Atjb1CT9Nvs
	PLhzbtFuhTFjXYlN0XQhcZGqG1BuoDZ9VHiQ1qHZt
X-Received: by 2002:ac2:5689:0:b0:5b4:4c8a:abef with SMTP id
 2adb3069b0e04-5b5ff29d7ccmr162861e87.10.1788273792891; Tue, 01 Sep 2026
 07:43:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
 <20260901140326.3812068-12-fuad.tabba@linux.dev> <20260901141548.3D6921F000E9@smtp.kernel.org>
In-Reply-To: <20260901141548.3D6921F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 15:42:36 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw8cDcSPb6sGWnPqrCFzk=DGycd_8kEwQBip9xn+j0GLg@mail.gmail.com>
X-Gm-Features: AcwNN1UFOAjSeSlrWShyG9qazQj-B2qNTNMDXRquUS9Wj0SNWvFKhaeyo-IMivY
Message-ID: <CA+EHjTw8cDcSPb6sGWnPqrCFzk=DGycd_8kEwQBip9xn+j0GLg@mail.gmail.com>
Subject: Re: [PATCH v4 11/11] KVM: arm64: Tag host-VA hypercall parameters __kern
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	linux-trace-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Sept 2026 at 15:15, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] The __kvm_adjust_pc hypercall translates and uses a host-pro=
vided vcpu pointer without validation, allowing a malicious host kernel to =
corrupt protected guest state.

Fix posted yesterday [1].

> - [High] __pkvm_host_donate_hyp wraps fallible allocator primitives in WA=
RN_ON(), allowing unprivileged host userspace to trigger a hypervisor panic=
.

Both pools are sized at boot to map all of memory at page granularity,
so donating host pages cannot exhaust them.

/fuad

[1] https://lore.kernel.org/all/20260831163421.272420-1-fuad.tabba@linux.de=
v/

> --
>
> commit f41e99c0d7eef41b448f7016f3b2a6ae6358d4c0
> Author: Fuad Tabba <fuad.tabba@linux.dev>
> Subject: KVM: arm64: Tag host-VA hypercall parameters __kern
>
> This commit introduces the __kern sparse address space to tag host virtua=
l
> addresses passed to EL2 hypercalls. It updates the hypercall declarations
> and unwrapping functions to ensure host VAs are explicitly translated
> before use, preventing unchecked dereferences at EL2.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 9085f46c2880f..91e74a1a334f0 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -548,9 +548,9 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_gues=
t,
> >  }
> >
> >  DEFINE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
> > -     struct kvm_vcpu *, vcpu)
> > +     struct kvm_vcpu __kern *, vcpu)
> >  {
> > -     __kvm_adjust_pc(kern_hyp_va(vcpu));
> > +     __kvm_adjust_pc(kern_hyp_va_host(vcpu));
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but does this hypercall fail to validate th=
e
> translated vcpu pointer?
>
> If a compromised host kernel issues the __kvm_adjust_pc hypercall and pas=
ses
> a forged virtual address, kern_hyp_va_host() could resolve it to the
> physical memory of a protected VM's pkvm_hyp_vcpu structure residing in t=
he
> EL2 linear map.
>
> Since this pointer is then used directly in __kvm_adjust_pc() to modify
> flags like PENDING_EXCEPTION or INCREMENT_PC, could this allow a maliciou=
s
> host to corrupt protected guest state and bypass pKVM isolation boundarie=
s?
>
> [ ... ]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index 6c8e33ebf8bb6..5cdb0318fa7ba 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> [ ... ]
> > @@ -657,9 +657,9 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_=
vcpus)
> >               size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
> >  }
> >
> > -static void *map_donated_memory_noclear(void *host_va, size_t size)
> > +static void *map_donated_memory_noclear(void __kern *host_va, size_t s=
ize)
> >  {
> > -     void *va =3D kern_hyp_va(host_va);
> > +     void *va =3D kern_hyp_va_host(host_va);
> >
> >       if (!PAGE_ALIGNED(va))
> >               return NULL;
> > @@ -671,7 +671,7 @@ static void *map_donated_memory_noclear(void *host_=
va, size_t size)
> >       return va;
> >  }
>
> [Severity: High]
> This isn't a bug introduced by this patch, but can this donation path lea=
d
> to a hypervisor panic triggered by unprivileged host userspace?
>
> Host userspace can issue KVM_CREATE_VM or KVM_CREATE_VCPU ioctls, which
> trigger hypercalls like __pkvm_init_vm and __pkvm_init_vcpu. These
> eventually call map_donated_memory_noclear() and __pkvm_host_donate_hyp()=
.
>
> Looking at arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_host_donate_hyp()=
:
>
>         __hyp_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
>         WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP))=
;
>         WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HYP));
>
> Both pkvm_create_mappings_locked() and host_stage2_set_owner_locked()
> allocate page tables from the hypervisor's memory pool and can fail with
> -ENOMEM if the pool is exhausted.
>
> Since WARN_ON() at EL2 expands to a fatal BRK instruction, could an
> unprivileged user exhaust EL2 memory and trigger these paths to crash the
> entire system, rather than safely returning an error and rolling back?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901140326.38=
12068-1-fuad.tabba@linux.dev?part=3D11
