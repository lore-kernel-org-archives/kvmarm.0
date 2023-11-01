Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916AE79F8
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 12:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tzrj4F8c"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-66cfc96f475so43158096d6.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 05:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698843062; x=1699447862; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DytdUoCbq8poGHKLHOEtAO0D5dohgKyWvCysCxFt+wY=;
        b=tzrj4F8cvZnt8//jt09VBNriK0RMQLpjfgjzyw+nLYQITucXQtJi6UXj36BKvs/iit
         41EpwBjUCGRHbCkoLsaGVZea0eAm1c5sCHCzmlhnXgBnYbXDZNR6/hvJq4NQgu1MTC1g
         qT6/ve2UGQAHVIrmirVFgCnI+2XFn9dsX8VbIuilaCStbDsJE2o77AIKF0qmBZpmln7o
         r6l/KCipUfSrnKs4Pk7irT9DKNI+eGPsofqV7YciCWEBFHAZgYaAeFzEuQLhMVX959fy
         dA3AC6JrAKqULwsZBoyE0uj+b5J+ty0mBSE671Vld7IVzok66HkqOjSPZ0fde+70mgcp
         OHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698843062; x=1699447862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DytdUoCbq8poGHKLHOEtAO0D5dohgKyWvCysCxFt+wY=;
        b=oxgL+28jBmni6AYyfkPetLaZSOcyP6VCoFiG9M364gSLEdlXW/f8W6dgL6L4OJsita
         Kvwhqn1+QYC8k/eAJ+KecEW1fSzwg5KJgHUTwkYx5l+LUxMywDfBcF4aaHs34mkwM4uA
         1CDnHR8lwlAZQJiDpSfhby0QBw4YOwiFHlgfvLWtb71hAAQdQ94DUCtwFoZ3XGXkf8ar
         VTgKokxBSE7/u9+nk+rHw+vlbNbB4tOdGQQqJne5d7QCKQw3reG2r9l8PGPXLr28yYn9
         qKDtaDxHtpPwuQDFmeg3bRPNTlLFLogY1NoFTeXnvKImE9XepwVWdsLojD+wRs1v7+6I
         FQ4w==
X-Gm-Message-State: AOJu0YxkKBnnXEDXinLnTywZxIZxRR3pk2a1axJaro6Mwoe2MjAexAi3
	f44nyn2rT5fZATLx4OUcslC9UMjRMee4inMn7ulA5w==
X-Google-Smtp-Source: AGHT+IF4xR6L8cVnqFnyZjdEh5XAFhWOV7M0s6Xt9NyBBttGvtAf21ACAZmexGcVd+eTPklAY7PiFjol+SoHUZLf4NM=
X-Received: by 2002:a05:6214:262e:b0:66f:bd35:e889 with SMTP id
 gv14-20020a056214262e00b0066fbd35e889mr16003984qvb.60.1698843062295; Wed, 01
 Nov 2023 05:51:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-5-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-5-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 1 Nov 2023 12:50:26 +0000
Message-ID: <CA+EHjTxW3P+_fejO6emoZ1=c9EkWJUH63-ffmSumh=6P6MbTqQ@mail.gmail.com>
Subject: Re: [PATCH v13 04/35] KVM: WARN if there are dangling MMU
 invalidations at VM destruction
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
> Add an assertion that there are no in-progress MMU invalidations when a
> VM is being destroyed, with the exception of the scenario where KVM
> unregisters its MMU notifier between an .invalidate_range_start() call an=
d
> the corresponding .invalidate_range_end().
>
> KVM can't detect unpaired calls from the mmu_notifier due to the above
> exception waiver, but the assertion can detect KVM bugs, e.g. such as the
> bug that *almost* escaped initial guest_memfd development.
>
> Link: https://lore.kernel.org/all/e397d30c-c6af-e68f-d18e-b4e3739c5389@li=
nux.intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  virt/kvm/kvm_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1a577a25de47..4dba682586ee 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1356,9 +1356,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
>          * No threads can be waiting in kvm_swap_active_memslots() as the
>          * last reference on KVM has been dropped, but freeing
>          * memslots would deadlock without this manual intervention.
> +        *
> +        * If the count isn't unbalanced, i.e. KVM did NOT unregister its=
 MMU
> +        * notifier between a start() and end(), then there shouldn't be =
any
> +        * in-progress invalidations.
>          */
>         WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
> -       kvm->mn_active_invalidate_count =3D 0;
> +       if (kvm->mn_active_invalidate_count)
> +               kvm->mn_active_invalidate_count =3D 0;
> +       else
> +               WARN_ON(kvm->mmu_invalidate_in_progress);
>  #else
>         kvm_flush_shadow_all(kvm);
>  #endif
> --
> 2.42.0.820.g83a721a137-goog
>
