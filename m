Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F68179F8
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 12:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l75cKJjJ"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4a13374a1e8so2754536e0c.1
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 05:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698843115; x=1699447915; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3o84LhG/JDs4XT09LqOqAL557WR+kTbV5Toac0tgZE=;
        b=l75cKJjJcUIyDdbVFxSkD2nk1S6wPl4lMYmRPElZMohvOOemELKlPb8v9w46fkeCHU
         0PTz1vjZSVl77tRgkIhYmJQsqWyViZkmQCtSgvpkIGkhxV7J3529BqrwGEQsDkEFa7E3
         eH+sZi7ojM4Vg9afUWGAC05cjIfkvFcB7qYjqWWjhRu8Htqk+wpHh0+73NWOFA+Io0PJ
         fldA571+fIWFnH6YgqwsTQExEdk2+q9Gl/avcRZV/8QExCNaUDJ0p1lNATIyIaIVXtxk
         hOjXTv53WvtkPZWYxpCRx5Y5oaPGbFSbgCkpCwOv9NS2nqr4K1pRZTvEyhD3qAa2ZvEB
         +OZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698843115; x=1699447915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d3o84LhG/JDs4XT09LqOqAL557WR+kTbV5Toac0tgZE=;
        b=Dl6wMX2AVEfyDFijO18wcpy4yYOmkp2IpQc/NKCkYl6xXvZ1yj3vYeJ2q7xwN81xvW
         WLnABlmiOBCS9fa3iuK6JH1hNKPg3OX+oOgYg/4KcvubU3caQ4WpvOBjyhyh326sY1Ld
         VbnlAySmZm573BBhItdvTkj8gPzPwSReFlJYpFqdQQ9Hx7M9tqwDAZyA03WOiAhKmuZ7
         08V9XAfCWclP5lcClWyl8m8wMYOE74VWUDa0oip/CAKdLGQtQos5TcNWp2ero+cRZr4A
         bM+CsbE6QPI0gMjNABRfd+up6UoMW08Y8WXc50mjJYDkBzt1yL6Zr8I0DXT0Sg+eo3Yz
         0W6g==
X-Gm-Message-State: AOJu0YyKbd4sjtEdoBeuhArM7CMZ0IuOx/o6w1XuRwz+KNceVqoXJc/B
	U97dp2w5ibvXoyTLGJkVTRQTLvPbs6A4ewygHxYV+Q==
X-Google-Smtp-Source: AGHT+IF0GS509bXC109Q/KsllvKKbuNv6izlI+nfo857C1iROxiLKrI4wNuuGIZxmkDtH9Saf2Z2BbskHZJDaldFC6s=
X-Received: by 2002:a1f:9b13:0:b0:4a1:7278:3bf5 with SMTP id
 d19-20020a1f9b13000000b004a172783bf5mr13903007vke.4.1698843115068; Wed, 01
 Nov 2023 05:51:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-6-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-6-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 1 Nov 2023 12:51:19 +0000
Message-ID: <CA+EHjTxq9zBY02bqsThV5+afLY1mGXyfs+X1yiKL0kM8SSz_Ug@mail.gmail.com>
Subject: Re: [PATCH v13 05/35] KVM: PPC: Drop dead code related to KVM_ARCH_WANT_MMU_NOTIFIER
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 7:22=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Assert that both KVM_ARCH_WANT_MMU_NOTIFIER and CONFIG_MMU_NOTIFIER are
> defined when KVM is enabled, and return '1' unconditionally for the
> CONFIG_KVM_BOOK3S_HV_POSSIBLE=3Dn path.  All flavors of PPC support for K=
VM
> select MMU_NOTIFIER, and KVM_ARCH_WANT_MMU_NOTIFIER is unconditionally
> defined by arch/powerpc/include/asm/kvm_host.h.
>
> Effectively dropping use of KVM_ARCH_WANT_MMU_NOTIFIER will simplify a
> future cleanup to turn KVM_ARCH_WANT_MMU_NOTIFIER into a Kconfig, i.e.
> will allow combining all of the
>
>   #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>
> checks into a single
>
>   #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
>
> without having to worry about PPC's "bare" usage of
> KVM_ARCH_WANT_MMU_NOTIFIER.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/powerpc/kvm/powerpc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 7197c8256668..b0a512ede764 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -632,12 +632,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>                 break;
>  #endif
>         case KVM_CAP_SYNC_MMU:
> +#if !defined(CONFIG_MMU_NOTIFIER) || !defined(KVM_ARCH_WANT_MMU_NOTIFIER=
)
> +               BUILD_BUG();
> +#endif
>  #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>                 r =3D hv_enabled;
> -#elif defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> -               r =3D 1;
>  #else
> -               r =3D 0;
> +               r =3D 1;
>  #endif
>                 break;
>  #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> --
> 2.42.0.820.g83a721a137-goog
>
