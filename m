Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0E4253C8
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 16:29:10 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b9ed206018so217545ad.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 09:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689611350; x=1690216150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdC3m+V++Z/viiPrZylihhrytj8yYzk3mKF8HaNWKR8=;
        b=JLAgLws9Ph8sZXiXZU9MF05DdRh4lVloJ4eCxbv6I29WMR5L0rCOLPelFSDEOZhJvt
         64+osbhlLyTLpW/D92uvfSJaEL4sFuEBmrpVS+xj6clTrIc2+bVJGwfbs5n6gHdnEr5B
         YqzqSMwfqaSo3XeFvoWjfbHeM4Cc/MTNc1ecF1B0hr875jx1ozJYDOrdZfwkabhTY752
         2VHpkMBORHmHuzxFkO6mdxouWf2WD6zFkfGAabLUwljGiTe44J/tuB2YOVMzpNsZ9p1i
         sch2dY3rkukgapyWRdaAtY7ju3lclvSIthC+kC+tP83bYfSBV/VxQM9FDLFKyUC+qfpE
         iEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689611350; x=1690216150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JdC3m+V++Z/viiPrZylihhrytj8yYzk3mKF8HaNWKR8=;
        b=ZOi8nm5IjErEceRZvt3T1gOYsKikq4PdBM3GhziLeIHPvxXX942+yvKz0/ZmiIgp5V
         j0kFPQrz5tj/2WYJsKrrF6PjHbq72kMmegajS0jb0xzDZtYj38hRg+/uFh2I/35H1Ge4
         Sn3oVkcVawqNqu7SBabcKw/ktYcxVW0x/QMWdxi6ZP3D6eMe+gWT9/pD6QIUXt8WViC8
         Yk/2C9bgbpZT3TTw+AiV7mfOcX9g/xCiwMnN9KOBTcIdeQ155oUZxRimIPlagPFxIziE
         +emUwWFqaxXtkjd2WskiQpdZD4B3VpsUnD10yzHqHQTQimuOQSWkUQy+x1gv0XHRU5pa
         txLg==
X-Gm-Message-State: ABy/qLbMQtu5I+zlz3ARIM1HiWX5lPsUT/7x+Q2+p3vvdMqiwD0+Jr6t
	Lmp92ymHZde6G7D8Pv+PiOgFCJrjyZ++DJUCwWb8lw==
X-Google-Smtp-Source: APBJJlEyymDBpyl7ABeHnCX+wEYEjlMXNDWxLVm6reu3PBE3OUW35nPR5bmepa4Nhj9vtn4nG7ITVPmZXkRqcZH8h0M=
X-Received: by 2002:a17:903:41c4:b0:1b8:5857:ea9a with SMTP id
 u4-20020a17090341c400b001b85857ea9amr1012512ple.23.1689611350208; Mon, 17 Jul
 2023 09:29:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com> <20230715005405.3689586-3-rananta@google.com>
 <ef2dddcd-f4dd-da9b-c03f-ccd852bb8543@linaro.org>
In-Reply-To: <ef2dddcd-f4dd-da9b-c03f-ccd852bb8543@linaro.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 17 Jul 2023 09:28:58 -0700
Message-ID: <CAJHc60xbPoTeX4oKeg45U6QjBw3CS=ZU0PEVCE1zaoAX4Ex7Vw@mail.gmail.com>
Subject: Re: [PATCH v6 02/11] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zenghui Yu <zenghui.yu@linux.dev>, Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Philippe,

On Mon, Jul 17, 2023 at 1:13=E2=80=AFAM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> Hi Raghavendra, David,
>
> On 15/7/23 02:53, Raghavendra Rao Ananta wrote:
> > From: David Matlack <dmatlack@google.com>
> >
> > Use kvm_arch_flush_remote_tlbs() instead of
> > CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL. The two mechanisms solve the same
> > problem, allowing architecture-specific code to provide a non-IPI
> > implementation of remote TLB flushing.
> >
> > Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> > all architectures on kvm_arch_flush_remote_tlbs() instead of maintainin=
g
> > two mechanisms.
> >
> > Opt to standardize on kvm_arch_flush_remote_tlbs() since it avoids
> > duplicating the generic TLB stats across architectures that implement
> > their own remote TLB flush.
> >
> > This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> > path, but that is a small cost in comparison to flushing remote TLBs.
> >
> > In addition, instead of just incrementing remote_tlb_flush_requests
> > stat, the generic interface would also increment the
> > remote_tlb_flush stat.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
> > Acked-by: Oliver Upton <oliver.upton@linux.dev>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h | 3 +++
> >   arch/arm64/kvm/Kconfig            | 1 -
> >   arch/arm64/kvm/mmu.c              | 6 +++---
> >   virt/kvm/Kconfig                  | 3 ---
> >   virt/kvm/kvm_main.c               | 2 --
> >   5 files changed, 6 insertions(+), 9 deletions(-)
>
> You are doing 2 changes in the same patch:
>
> - Have ARM use kvm_arch_flush_remote_tlbs() instead of
>    HAVE_KVM_ARCH_TLB_FLUSH_ALL,
> - Drop the now unused HAVE_KVM_ARCH_TLB_FLUSH_ALL.
>
> Commits should be atomic, to allow partial
> revert or cherry-pick.
>
> Preferably splitting this patch in 2:
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>
Thanks for the suggestion. I guess that makes sense. I'll split the
patch in two for v7.

- Raghavendra
> Regards,
>
> Phil.
>
