Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BE91BDEA
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J/3yir1X"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-778a92c06d6so58034985a.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698935773; x=1699540573; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGQNRc9zE40ysVevY/WGU/Lu6W4371YJar5QqeiLOSY=;
        b=J/3yir1XoEgMGAWIn/bgPPaJrtKrBdu6VmfzjNX4kkAp4UxO9bTo9upjNEnus/Ur6Z
         SU/DwPywzIkFNf6OLX+rx/P1GKMXEjUZyNWPPH4Oxp0yd7ZdnML3h7MgkQ1MJsTfw0fx
         dH1D05dDx+wQPVhxsFjMZF/YRB5/GvdqgbRspaJ7yy63mfFjBmHnPc/V05j6pkFzBLCf
         PCXP7n4LvtoU93YWhXU66VxrP4FtdNMUU7pX6bIQz7KbS1p51OKvVGk3AujJERider+Z
         Lxenn8nHYIbzHny4aHALtws8lrscZ60Sqq5kGkUVmTINJEIi2D0c0wND/cnS3IOuy9nD
         Co0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698935773; x=1699540573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGQNRc9zE40ysVevY/WGU/Lu6W4371YJar5QqeiLOSY=;
        b=gYEqqCXsh2fgxyscHJ0anNrPQBSWt7J3l0/6qLdJYti2pcwgQt1CZ74VOj7PntnbNN
         JjjvkvJbNHTQNJ2XDcg1C2VK7SpwqzVxgbe7GM3ST+s+q0GGCtOvLaNlq79g272EIO3K
         jWCUjz9b4+yXax+Bs+tQBw2gnEuMz5/10Cv90FHM9+8bS/VE7bHXzd0b9gV7cITLOuwb
         /4HSgn7z1l6NYwVU5mKa+qo6K3JQMAaP7ZMDfCeRp9te1qqQ3WEoxjYcyyWd9OJ3zCvn
         nOAYB80WQGd3XWVU84MIRC30kELKsje+HVw8P+BicF+6U28bZSJPRBeOLsCJvZ3w+zjb
         4luw==
X-Gm-Message-State: AOJu0Yx9evj5bJgUpvGsfy46icQmqlGLNirFM3NAZo4ZCuSCK8sLXzrU
	a9IqEFE1y+OtNAqxpGdXJd40P2cbAVWAorjnTrxHDg==
X-Google-Smtp-Source: AGHT+IG3zQONLtNNLFCBisiqnyb2KBBdAZoBcVXn8ZKHSOcO4zLCu8vZ+2T5E0OEe4jyHp5mk0SJgyrOfTeARfH9hlY=
X-Received: by 2002:a05:6214:242e:b0:66d:a90f:c06 with SMTP id
 gy14-20020a056214242e00b0066da90f0c06mr22425828qvb.14.1698935773112; Thu, 02
 Nov 2023 07:36:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-22-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-22-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 2 Nov 2023 14:35:36 +0000
Message-ID: <CA+EHjTzk0=24wGbxQUApAY4B-K3xO3+SOfLn1tPJk-hVJY0+GQ@mail.gmail.com>
Subject: Re: [PATCH v13 21/35] KVM: Drop superfluous __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 macro
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

On Fri, Oct 27, 2023 at 7:23=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Drop __KVM_VCPU_MULTIPLE_ADDRESS_SPACE and instead check the value of
> KVM_ADDRESS_SPACE_NUM.
>
> No functional change intended.
>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/include/asm/kvm_host.h | 1 -
>  include/linux/kvm_host.h        | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 8d60e4745e8b..6702f795c862 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2124,7 +2124,6 @@ enum {
>  #define HF_SMM_MASK            (1 << 1)
>  #define HF_SMM_INSIDE_NMI_MASK (1 << 2)
>
> -# define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
>  # define KVM_ADDRESS_SPACE_NUM 2
>  # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_M=
ASK ? 1 : 0)
>  # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role=
).smm)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e3223cafd7db..c3cfe08b1300 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -692,7 +692,7 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm);
>  #define KVM_MEM_SLOTS_NUM SHRT_MAX
>  #define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_INTERNAL_MEM_SLOTS)
>
> -#ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
> +#if KVM_ADDRESS_SPACE_NUM =3D=3D 1
>  static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  {
>         return 0;
> --
> 2.42.0.820.g83a721a137-goog
>
