Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31380320A
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 06:23:04 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ae3a5dfa42so2721395ad.0
        for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 23:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685082183; x=1687674183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cCHBf3UytwZfxePPwE+jd6ort0sOdXbbuo1VvBkL64=;
        b=In9JMr9pXJKdU4OFNrKA8VkqvzNERFgbkF1WTefIBpZGNH1cm6Wu4vy6gHMfTTbpH5
         Bxt1r4RdI0sl2apwFfU9YncceU9jlq55r9HxXRy93MWRcYsVcXQ/3fCBv5QBexNmd25X
         6G2yWYoM0MVRHQMx8eH0pxaCBL360ys2TBubCUiYCToafZ9wgibDjDx0qVGg1QlxwNOJ
         mLFF8yI2zd7UosSjjmAmMe1b3OntVisxuNwReKnyR4cjSdQqdBe57OFiu7V+h7YbDTD9
         gS4FVXbZxLBVK9nWMBpD7mMOq0v4voFCeypL5pXo+ai/vZiKklNlarHEiS6wZWvQStAQ
         076A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685082183; x=1687674183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7cCHBf3UytwZfxePPwE+jd6ort0sOdXbbuo1VvBkL64=;
        b=B5Me7flMxuL3oo3QSg1/OoaE9WILQiXsjaoTjIX+LSBci+2atEGt+lhtEYAefjL5Xs
         UOMQ4LTn3obGyDHci0hbcIjuOG4Po8P3BBKJ0fE51ApIuZJrFWu4kmntB/eJD6LgYimS
         EDRSnJc3ZEr0o/Tc8x5UBvi9KhkphohPbWabbqloLfMCM9NocLZljPBwFZTuUgUwhsU/
         qdoq6UL6Fk8R6RKFc4l2GhJ+lOQ9CEZnbwRbFASHnx4n34Y1Z+64MJhbI5UwayU6hx8L
         mFQa6vH1CWShyEWiQl4Q9HFbN1iWQUU8nV23ilVzm7IGzf8t429eCetmgcHh02QejwQg
         rgrw==
X-Gm-Message-State: AC+VfDxszudpGtRfayOjY20XLpiZQRYDWdKkkgj5M84W02x9SbP0CXzO
	nqAMha8P9H0GDnw1qi3mwbMdbRZ8JMjGbUFUer8=
X-Google-Smtp-Source: ACHHUZ5+adpq5bn8ccEuSJ16UorMQ11HQo3chgEmsUz3XwrAAvurJ6sIX+3y8mXx79RuaBedX3HqgDmU0iivyP2H1/M=
X-Received: by 2002:a17:903:2285:b0:1ab:142a:3dd7 with SMTP id
 b5-20020a170903228500b001ab142a3dd7mr1537487plh.68.1685082183465; Thu, 25 May
 2023 23:23:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1684999824.git.haibo1.xu@intel.com> <20230525-6e0855eb07086a96eaa82362@orel>
In-Reply-To: <20230525-6e0855eb07086a96eaa82362@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 26 May 2023 14:22:52 +0800
Message-ID: <CAJve8o=SdjMvsVn=3Vqw3QG5SuU8nqLVC_MRAgPX+GuFZj6jvA@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] RISCV: Add KVM_GET_REG_LIST API
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 26, 2023 at 1:20=E2=80=AFAM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, May 25, 2023 at 03:38:24PM +0800, Haibo Xu wrote:
> > KVM_GET_REG_LIST will dump all register IDs that are available to
> > KVM_GET/SET_ONE_REG and It's very useful to identify some platform
> > regression issue during VM migration.
> >
> > Patch 1-7 re-structured the get-reg-list test in aarch64 to make some
> > of the code as common test framework that can be shared by riscv.
> >
> > Patch 8 enabled the KVM_GET_REG_LIST API in riscv and patch 9-11 added
> > the corresponding kselftest for checking possible register regressions.
> >
> > The get-reg-list kvm selftest was ported from aarch64 and tested with
> > Linux 6.4-rc1 on a Qemu riscv virt machine.
> >
> > ---
> > Changed since v1:
> >   * rebase to Andrew's changes
> >   * fix coding style
> >
> > Andrew Jones (7):
> >   KVM: arm64: selftests: Replace str_with_index with strdup_printf
> >   KVM: arm64: selftests: Drop SVE cap check in print_reg
> >   KVM: arm64: selftests: Remove print_reg's dependency on vcpu_config
> >   KVM: arm64: selftests: Rename vcpu_config and add to kvm_util.h
> >   KVM: arm64: selftests: Delete core_reg_fixup
> >   KVM: arm64: selftests: Split get-reg-list test code
> >   KVM: arm64: selftests: Finish generalizing get-reg-list
>
> All the patches above should also have your s-o-b since your posting them=
.
>

Sure.

> Thanks,
> drew
