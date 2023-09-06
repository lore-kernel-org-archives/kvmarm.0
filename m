Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE914A2C
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 06:57:07 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2bd0bc8b429so56083891fa.2
        for <kvmarm@lists.linux.dev>; Tue, 05 Sep 2023 23:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693983426; x=1694588226; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zlJV3YrVhcDgjJFnq8JrFHKjW/deWsGxcZLe+DpQPlY=;
        b=sMbw2jBhpU6X65nPrcRpRV0P7Cg6VTPkf0HfFKe11+V5ZD0ANLSspaL0GsrZQabXS7
         clspxKyJIcHl2Kte4bRM4MuRnLyce1GHAihDIL4m/m7dXUjr7gAFJb+vITOJe+QErdMW
         0uj68gRS/X/LxCrDQiQVvRxCj1KwMCGbdABWWPcFh7d+q5F+dUi5Eo6HJRi4wf4Bi2Ui
         Cbk2hRz5+6szPvTGBS5pg9u27xpCRH2zO+YWYKGdTOqyXvC/3lP8fBEFJM9r+5Co8eJF
         dwin0NWFh7SndqthL3NwaRm9es5OZtvPK50SqPRfVBedb8Hz8+LwPuK/jp/6dT6Na3T3
         7vjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693983426; x=1694588226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zlJV3YrVhcDgjJFnq8JrFHKjW/deWsGxcZLe+DpQPlY=;
        b=l1EuLJl/5o0JnepTSQ6Bnaa0cjEBEZDqhjiav4dXXL5nEmGzznApJ5Khxr/UCQ75gf
         Av3rNAcwbd6QgZL2TegIn7fC/a70byFcNDJiFO2wAGx8q6IchwYwNcKc55OeDAlgDB1O
         AXOvUDIa9pxgemPgNouIpaoKr27VOuTXzBliYw03nC1uxZVkq2q+29yZeCoPVS/HrcaX
         mAYoxgjw9MNY4AFjDeYyg0yGGhvmiX+pgz9mwxLzanxBabvIVpFvvXF40QOgAGyShBSM
         pGm/u1r50OBtd6yw0XsrgEHgbbwVJPMwUrlqyj6Jceywh2i0EwWhp+jj9L2N6Px8IxsZ
         5lfQ==
X-Gm-Message-State: AOJu0YwrrRBGxBzi/6NIwQ5tZehfv0r2TF2GRglDU70MbWx2Vlz6FEUc
	FY76YhGP1RuymasuO14TOKZaSJSmgeM4uVVl3S8=
X-Google-Smtp-Source: AGHT+IE2wohgSgl/gZUM1LzzLcCwq5kIveaGhSl1JWbsEVX+uMGhnRmRqbVkQ36vSc6Xb8HN2ND74xdMHJJ7AowqLIU=
X-Received: by 2002:a2e:b051:0:b0:2bc:e1a3:fbaa with SMTP id
 d17-20020a2eb051000000b002bce1a3fbaamr1470233ljl.22.1693983425421; Tue, 05
 Sep 2023 23:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <ee4e518cbed9ff4210b74a22c5af21c410fab85d.1693659382.git.haibo1.xu@intel.com>
 <20230904-d35320b23119ee97737e8a74@orel>
In-Reply-To: <20230904-d35320b23119ee97737e8a74@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 6 Sep 2023 14:56:54 +0800
Message-ID: <CAJve8om7Rmp-gbyT7DfHQVPrpkrgA95pbLVrTh=-S2HegkuXpQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] KVM: riscv: selftests: Switch to use macro from csr.h
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, wchen <waylingii@gmail.com>, 
	Greentime Hu <greentime.hu@sifive.com>, Sean Christopherson <seanjc@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jim Mattson <jmattson@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Peter Gonda <pgonda@google.com>, Like Xu <likexu@tencent.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 4, 2023 at 9:31=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Sat, Sep 02, 2023 at 08:59:26PM +0800, Haibo Xu wrote:
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---
> >  tools/testing/selftests/kvm/include/riscv/processor.h | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/to=
ols/testing/selftests/kvm/include/riscv/processor.h
> > index 5b62a3d2aa9b..6810c887fadc 100644
> > --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> > +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> > @@ -8,6 +8,7 @@
> >  #define SELFTEST_KVM_PROCESSOR_H
> >
> >  #include "kvm_util.h"
> > +#include <asm/csr.h>
> >  #include <linux/stringify.h>
> >
> >  static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
> > @@ -95,12 +96,8 @@ static inline uint64_t __kvm_reg_id(uint64_t type, u=
int64_t idx,
> >  #define PGTBL_PAGE_SIZE                              PGTBL_L0_BLOCK_SI=
ZE
> >  #define PGTBL_PAGE_SIZE_SHIFT                        PGTBL_L0_BLOCK_SH=
IFT
> >
> > -#define SATP_PPN                             _AC(0x00000FFFFFFFFFFF, U=
L)
> >  #define SATP_MODE_39                         _AC(0x8000000000000000, U=
L)
> >  #define SATP_MODE_48                         _AC(0x9000000000000000, U=
L)
>
> SATP_MODE_39/48 are also in csr.h
>

Good catch! These 2 should also be removed. Will fix it in the next version=
.

> > -#define SATP_ASID_BITS                               16
> > -#define SATP_ASID_SHIFT                              44
> > -#define SATP_ASID_MASK                               _AC(0xFFFF, UL)
> >
> >  #define SBI_EXT_EXPERIMENTAL_START           0x08000000
> >  #define SBI_EXT_EXPERIMENTAL_END             0x08FFFFFF
> > --
> > 2.34.1
> >
>
> Thanks,
> drew
