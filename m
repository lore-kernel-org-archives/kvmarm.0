Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A31625
	for <kvmarm@lists.linux.dev>; Mon,  3 Jul 2023 02:53:28 +0000 (UTC)
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2b5c231c23aso62053621fa.0
        for <kvmarm@lists.linux.dev>; Sun, 02 Jul 2023 19:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688352807; x=1690944807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhyBGVQ1gaH5Dq33+rfxBQOlHqFL4drvkmIj6aJ3EDI=;
        b=O1hWsfHy6op+iJK7RchZka3HezdQVlH4vq5oZ4Ax4HtYBJHdp7SiTUlOd/0MeGRlXW
         qD/ZIYJ7S7K1mp3qOnr6kToxa76JlnRwNUBFg8F1baXgmRqJNnWHdQllc+zNQ/KDquxA
         7ErHevq/QuYL5AcR4Ql1h5QzNaJ9QIQcafCqt4dGXfaEkOM3HL++icZX1GE7OHuqT4Je
         cvxgKsI/a5C0cZWpASXrd1T8JMo5yoIoj74Zs2ka04Rmp+6QnFbys2scKj3azEQXgQ2p
         1SDy5h+KL7Ty3XPYq179EooH/TEpDroawrvKxJ2iJS0i2N+UJhV225NmXPpDfy0Ly7ur
         MwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688352807; x=1690944807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fhyBGVQ1gaH5Dq33+rfxBQOlHqFL4drvkmIj6aJ3EDI=;
        b=kjVL6scHNGb5jt2FQbeHyibc1OIVnfpRgsoiQUgY8DWm/1bwZFSqX/C1ugNVyajPl7
         +5VevhfNvk8hqbR7UEXclorc5+pJgNbpdqcr4mNflMZclsUa9e1c7uOIkVXZWnWVNpQV
         1a+PgMcvnRUrUU0KzykyScXzmKanan7rcK8iNUTh/i4GQCM1daxHkFQpRXfD+3EbTg1Q
         FDzZZNWenHusl3bsntSnQW+4uR47yORdxjrcZuHxGbo1t/Pg4QhYRNbZOeOy4d9vb7uf
         vjDYSgYtdWdEfeTQO59mIOXuqw3dHfgdE2M7SjdSTeHLCBxAsM3gnhghxXXcF62xsJaU
         cbKQ==
X-Gm-Message-State: ABy/qLZsEkGV7SyK2O4Ei2nPDkHK/VYLmaeCPKYsnmNPEXEWLJXSgpkj
	C6Cd12hHFf+xE8cLHxHj+rOvh1y8hmt0tJ5y3t8=
X-Google-Smtp-Source: APBJJlFfL2px5Y6Cyr17rNDrNo5fJ8sdzYko47a6W75rx7foKvBUjbZJAB2cC/NyOavCuc3SoyWVNmryeUVMgdKDyso=
X-Received: by 2002:a2e:9205:0:b0:2b6:e128:e7a3 with SMTP id
 k5-20020a2e9205000000b002b6e128e7a3mr2116081ljg.33.1688352806560; Sun, 02 Jul
 2023 19:53:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1688010022.git.haibo1.xu@intel.com> <20230701-e1bff47a0ed38ec3ab6ca252@orel>
In-Reply-To: <20230701-e1bff47a0ed38ec3ab6ca252@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Mon, 3 Jul 2023 10:53:15 +0800
Message-ID: <CAJve8on_SRbPmQ4U16imMUjrqs_abLsW64xJotBxRSv65WJa-w@mail.gmail.com>
Subject: Re: [PATCH v5 00/13] RISCV: Add KVM_GET_REG_LIST API
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 1, 2023 at 10:53=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Sat, Jul 01, 2023 at 09:42:48PM +0800, Haibo Xu wrote:
> > KVM_GET_REG_LIST will dump all register IDs that are available to
> > KVM_GET/SET_ONE_REG and It's very useful to identify some platform
> > regression issue during VM migration.
> >
> > Patch 1-7 re-structured the get-reg-list test in aarch64 to make some
> > of the code as common test framework that can be shared by riscv.
> >
> > Patch 8 move reject_set check logic to a function so as to check for
> > different errno for different registers.
> > Patch 9 move finalize_vcpu back to run_test so that riscv can implement
> > its specific operation.
> > Patch 10 change to do the get/set operation only on present-blessed lis=
t.
> > Patch 11 add the skip_set facilities so that riscv can skip set operati=
on
> > on some registers.
> > Patch 12 enabled the KVM_GET_REG_LIST API in riscv.
> > patch 13 added the corresponding kselftest for checking possible
> > register regressions.
> >
> > The get-reg-list kvm selftest was ported from aarch64 and tested with
> > Linux v6.4 on a Qemu riscv64 virt machine.
>
> Hi Haibo,
>
> This series needs a rebase on top of these recent patches
>
>  commit ee053e03b08e ("KVM: selftests: get-reg-list: support ID register =
features")
>  commit 5f0419a0083b ("KVM: selftests: get-reg-list: add Permission Indir=
ection registers")
>
> The conflicts will be in my patches, which do the splitting of the test.
> I'll do the rebase and push it to a branch for you to pick up.
>

Thanks for the heads up. I will include your changes in v6.

> Thanks,
> drew
