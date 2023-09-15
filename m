Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17EC815
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 06:13:27 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-502f302b68dso679608e87.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 23:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694758405; x=1695363205; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VrYfSyvA1qDzz1C9me2YoJdAvmKAyt6HEOJS2kBsMOc=;
        b=Tk8kEg4gS/w17dPo7tUn2Ox52awkqcTPePbaCFupBLRvKleEqStWSzJLart8ZOT8h1
         DWzpFsHBvOYRJLx0oAYXLYDSDOtnIEzAGkcK3buQk61R3zCrGpNUYYVV8wQyKeozZ11y
         tMDr/v+aTyb5KLzUiheFQ8NouGJlNuWgkOEFD4zozQjH6TYp/DpEGtVHAMSpg+rOvP+2
         GjTtkvODH/JAtXZCS6TI40/RVdMT2SlhTRNLn4RdvCREWwDuC9ltDRa2SVofgr5MbGwj
         XkRQvbsBcAM0YLyCdPhoOSCVkE7DaPb4ZVDqFohsq2qc2u2z+zigHSdnQDsb7TNkX///
         IzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694758405; x=1695363205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VrYfSyvA1qDzz1C9me2YoJdAvmKAyt6HEOJS2kBsMOc=;
        b=KqnbvaB4w+0fPv4z1HNW6ObWfq8UD7UusCGg1Yh32gBtOFvtq5tELS4+rljaCRGqPG
         r9UCdE71Z9I4DPlkgTEGw1EKH5jj3eItgKNQ9Q+ebghVGoy/FkI5FsMW7W/dh6gbGBJg
         sVIX8ZwvMfFIYTiICIpx95OJ9MsldphYSmf9cz3XUBGxzp4qu4jcZ3ORnfLUE0cAIDF8
         Q9PWtMjOvkfIgBSZMO5D9zLv3OK3rjoJb0qUfkm8vUw1fz7/zRiUkdK+Yg/Jm2zVzNV/
         6Jc1rb3GhMIMRJ+gli1pH5yuGOvIwPynoU0xBHoP4zOaaR3hmlzytpPicVJ+lZjAzG7K
         4pDA==
X-Gm-Message-State: AOJu0Ywmcwr97QUC81LiIf1btFLBHkgvYsgx+/8p1tLybkCgoEHeszC5
	ZAuVspQmpW139ynhZ3DFop0gSPaw6OfR2DE4QiY=
X-Google-Smtp-Source: AGHT+IGkLJqQ/k8slvZGXQMAE/UeB/ooMmN+gETIu3I1Y9kMMNpJ7F3dojbdtU+Jb3bl7yAYuGDVmI9UONACJCtektg=
X-Received: by 2002:ac2:4c8b:0:b0:4fc:3755:37d9 with SMTP id
 d11-20020ac24c8b000000b004fc375537d9mr634044lfl.68.1694758405211; Thu, 14 Sep
 2023 23:13:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <6cdda82518977c67004ee01a767bc67962352c13.1694421911.git.haibo1.xu@intel.com>
 <20230914-18bfe93b679e290188e70307@orel>
In-Reply-To: <20230914-18bfe93b679e290188e70307@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 15 Sep 2023 14:13:13 +0800
Message-ID: <CAJve8okdUtcCihGh4wRb9rHTxuL7=7_1FY8Ez0+QMr=+x7fzoQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] KVM: riscv: selftests: Switch to use macro from csr.h
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Peter Xu <peterx@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 14, 2023 at 4:52=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Sep 14, 2023 at 09:36:59AM +0800, Haibo Xu wrote:
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---
> >  tools/testing/selftests/kvm/include/riscv/processor.h | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/to=
ols/testing/selftests/kvm/include/riscv/processor.h
> > index 5b62a3d2aa9b..67766baed4f7 100644
> > --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> > +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> > @@ -8,6 +8,7 @@
> >  #define SELFTEST_KVM_PROCESSOR_H
> >
> >  #include "kvm_util.h"
> > +#include <asm/csr.h>
> >  #include <linux/stringify.h>
>
> nit: Usually we try to keep the order of our includes separated into five
> categories, listed below, where each category is sorted alphabetically. O=
f
> course any dependencies the includes have on each other need to be
> considered too.
>
> <library-includes-without-a-subdir>
> <library-includes-with-subdir>
> <linux/...>
> <asm/...>
> "local-includes"
>

It's very helpful. Thanks for sharing it!
Will fix it in v4.

> >
> >  static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
> > @@ -95,13 +96,6 @@ static inline uint64_t __kvm_reg_id(uint64_t type, u=
int64_t idx,
> >  #define PGTBL_PAGE_SIZE                              PGTBL_L0_BLOCK_SI=
ZE
> >  #define PGTBL_PAGE_SIZE_SHIFT                        PGTBL_L0_BLOCK_SH=
IFT
> >
> > -#define SATP_PPN                             _AC(0x00000FFFFFFFFFFF, U=
L)
> > -#define SATP_MODE_39                         _AC(0x8000000000000000, U=
L)
> > -#define SATP_MODE_48                         _AC(0x9000000000000000, U=
L)
> > -#define SATP_ASID_BITS                               16
> > -#define SATP_ASID_SHIFT                              44
> > -#define SATP_ASID_MASK                               _AC(0xFFFF, UL)
> > -
> >  #define SBI_EXT_EXPERIMENTAL_START           0x08000000
> >  #define SBI_EXT_EXPERIMENTAL_END             0x08FFFFFF
> >
> > --
> > 2.34.1
> >
>
> Assuming the CONFIG_64BIT patch will come before this, then
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>
> Thanks,
> drew
