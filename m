Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F3D1B8E7
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 15:29:14 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3f6da07ff00so21958805e9.3
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 08:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685719752; x=1688311752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VH7GGl6xtqqxUhhpkRoUtyXARLnTkYCIQf2MqXxYtgE=;
        b=wvx6yr7ls8G59v9HdpprjDeqwPbh3PT/MkRNNqUqIOTPuW5y9BtJTQ4/2ZgOBv+jiC
         Md3M06BB1gqI599ZSaq1pEK8bMr/Nu19V6/r4q831YCbQqSFGUQpeWLLoaJ8lgBWQQ4W
         TVdcIFBvQI1UCRNU0/eT03sKE+2wwFuqnHQRLfndo2O0wCouAqZtRi0/lSefx8kOn59F
         4ui6mT22g7Rrcz3pUTz9Db0c6aSZM5fagGkykemPGjVbLzGrFeklh5hCoF2zZPaUXo08
         3IK9vlF+Z/Dvq8VdkhtHAS5CoT18YTCAdPN7ah3Oz/yCd4pTONTXCJh85pOiGF+xORrP
         8X3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685719752; x=1688311752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VH7GGl6xtqqxUhhpkRoUtyXARLnTkYCIQf2MqXxYtgE=;
        b=KWjm/MGuQQ40sp8Ra5iPFcJJrwQV19KZgAoeWfHOdxc9rTnQcP8KJhqUDwcb6UHujh
         YxECD3oNv0uXp4ocfQjZeZQ5S+QCMMzu8Nw3on7f8LkEf9CKNJPzdl47AJjLsCRp/KHr
         jYN8eTXZ9ZXI91IU3clf9glPlXpe/t7COGO89tJXmWHkX02f7Co/AY3WOPnyx1VmDDYQ
         FEliZQIRPcAgySmVB2dCmXzg6/JZjdoGoRBUjoGh12DhMQAiZSnBox8aC0GOtfpn8jIv
         ZYPRzRRw7AaKqplje5hGMZoJlZHnoOsxX9YpynVx8AUxH7JPRFm/P2aCkFdTbuj+zLdc
         PH2w==
X-Gm-Message-State: AC+VfDw18pIlOqWRsiznMajfQbMmGpz6WPtwpwHdgkBZ1gA00cdVAzdG
	v6HS2j0fmD74hIO9TXvsIDl4XQ==
X-Google-Smtp-Source: ACHHUZ7BkquLM9YR+ptHVM+gI9HbdVeAE7APzrS45L0kOK0Bup77n/kEEpU6McDR9HpDYdxhBAp3oA==
X-Received: by 2002:a5d:6210:0:b0:30a:f17e:e02e with SMTP id y16-20020a5d6210000000b0030af17ee02emr235413wru.12.1685719752603;
        Fri, 02 Jun 2023 08:29:12 -0700 (PDT)
Received: from myrica (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id m4-20020a5d6a04000000b0030aea925fbesm1973116wru.50.2023.06.02.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 08:29:12 -0700 (PDT)
Date: Fri, 2 Jun 2023 16:29:07 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
Message-ID: <CAEBBgu3QbgHb2Bf1hTaYL2SDDsYKKqixJ7+u+VCd_sYj6VfWbw@mail.gmail.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-20-jean-philippe@linaro.org>
 <ZGeWudESZP5BGjaA@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGeWudESZP5BGjaA@google.com>
X-TUID: AONX6gFSOYg7

Hi Mostafa,

On Fri, 19 May 2023 at 16:33, Mostafa Saleh <smostafa@google.com> wrote:
>
> Hi Jean,
>
> On Wed, Feb 01, 2023 at 12:53:03PM +0000, Jean-Philippe Brucker wrote:
> > +/*
> > + * Serialize access to domains and IOMMU driver internal structures (command
> > + * queue, device tables)
> > + */
> > +static hyp_spinlock_t iommu_lock;
> > +
> I was looking more into this lock and I think we can make it per IOMMU instead
> of having one big lock to avoid congestion, as I see it is only used to
> protect per-IOMMU resources.

Yes it's a major bottleneck, thanks for looking into this. I think we'll
eventually want to improve scalability within an IOMMU and even a domain:
a multi-queue network device will share a single domain between multiple
CPUs, each issuing lots of map/unmap calls. Or just two devices drivers
working on different CPUs and sharing one IOMMU. In those cases the
per-IOMMU lock won't be good enough and we'll be back to this problem, but
a per-IOMMU lock should already improve scalability for some systems.

Currently the global lock protects:

(1) The domain array (per IOMMU)
(2) The io-pgtables (per domain)
(3) The command queue (per SMMU)
(4) Power state (per SMMU)

I ran some experiments with refcounting the domains to avoid the lock for
(1) and (2), which improves map() scalability. See
https://jpbrucker.net/git/linux/commit/?h=pkvm/smmu-wip&id=5ad3bc6fd589b6f11fe31ccee5b8777ba8739167
(and another experiment to optimize the DMA refcount on branch pkvm/smmu-wip)

For (2), the io-pgtable-arm code already supports concurrent accesses
(2c3d273eabe8 ("iommu/io-pgtable-arm: Support lockless operation")). But
this one needs careful consideration because in the host, the io-pgtable
code trusts the device drivers. For example it expects that only buggy
drivers call map()/unmap() to the same IOVA concurrently. We need to make
sure a compromised host drivers can't exploit these assumptions to do
anything nasty.

There are options to improve (3) as well. The host SMMU driver supports
lockless command-queue (587e6c10a7ce ("iommu/arm-smmu-v3: Reduce
contention during command-queue insertion")) but it may be too complex to
put in the hypervisor (or rather, I haven't tried to understand it yet).
We could also wait for systems with ECMDQ, which enables per-CPU queues.

> Some special handling needed as hyp_spinlock_t is not exposed to EL1.
> Maybe something like this:
>
> diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
> index b257a3b4bfc5..96d30a37f9e6 100644
> --- a/arch/arm64/kvm/hyp/hyp-constants.c
> +++ b/arch/arm64/kvm/hyp/hyp-constants.c
> @@ -3,11 +3,13 @@
>  #include <linux/kbuild.h>
>  #include <nvhe/memory.h>
>  #include <nvhe/pkvm.h>
> +#include <nvhe/spinlock.h>
>
>  int main(void)
>  {
>         DEFINE(STRUCT_HYP_PAGE_SIZE,    sizeof(struct hyp_page));
>         DEFINE(PKVM_HYP_VM_SIZE,        sizeof(struct pkvm_hyp_vm));
>         DEFINE(PKVM_HYP_VCPU_SIZE,      sizeof(struct pkvm_hyp_vcpu));
> +       DEFINE(HYP_SPINLOCK_SIZE,       sizeof(hyp_spinlock_t));
>         return 0;
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
> index a90b97d8bae3..cf9195e24a08 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> @@ -6,6 +6,7 @@ arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
>  arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
>
>  obj-$(CONFIG_ARM_SMMU_V3_PKVM) += arm_smmu_v3_kvm.o
> +ccflags-$(CONFIG_ARM_SMMU_V3_PKVM) += -Iarch/arm64/kvm/
>  arm_smmu_v3_kvm-objs-y += arm-smmu-v3-kvm.o
>  arm_smmu_v3_kvm-objs-y += arm-smmu-v3-common.o
>  arm_smmu_v3_kvm-objs := $(arm_smmu_v3_kvm-objs-y)
> diff --git a/include/kvm/iommu.h b/include/kvm/iommu.h
> index ab888da731bc..82827b99b1ed 100644
> --- a/include/kvm/iommu.h
> +++ b/include/kvm/iommu.h
> @@ -5,6 +5,12 @@
>  #include <asm/kvm_host.h>
>  #include <kvm/power_domain.h>
>  #include <linux/io-pgtable.h>
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#include <nvhe/spinlock.h>
> +#else
> +#include "hyp_constants.h"
> +#endif
>
>  /*
>   * Parameters from the trusted host:
> @@ -23,6 +29,11 @@ struct kvm_hyp_iommu {
>
>         struct io_pgtable_params        *pgtable;
>         bool                            power_is_off;
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +       hyp_spinlock_t                  iommu_lock;
> +#else
> +       u8 unused[HYP_SPINLOCK_SIZE];
> +#endif
>  };
>
>  struct kvm_hyp_iommu_memcache {
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> index 1f4d5fcc1386..afaf173e65ed 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> @@ -14,12 +14,6 @@
>
>  struct kvm_hyp_iommu_memcache __ro_after_init *kvm_hyp_iommu_memcaches;
>
> -/*
> - * Serialize access to domains and IOMMU driver internal structures (command
> - * queue, device tables)
> - */
> -static hyp_spinlock_t iommu_lock;
> -
>  #define domain_to_iopt(_iommu, _domain, _domain_id)            \
>         (struct io_pgtable) {                                   \
>                 .ops = &(_iommu)->pgtable->ops,                 \
> @@ -93,10 +87,10 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
>  {
>         int ret = -EINVAL;
>         struct io_pgtable iopt;
> -       struct kvm_hyp_iommu *iommu;
> +       struct kvm_hyp_iommu *iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
>         struct kvm_hyp_iommu_domain *domain;
>
> -       hyp_spin_lock(&iommu_lock);
> +       hyp_spin_lock(&iommu->iommu_lock);
>         domain = handle_to_domain(iommu_id, domain_id, &iommu);
>         if (!domain)
>                 goto out_unlock;
> @@ -112,7 +106,7 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
>         domain->refs = 1;
>         domain->pgd = iopt.pgd;
>  out_unlock:
> -       hyp_spin_unlock(&iommu_lock);
> +       hyp_spin_unlock(&iommu->iommu_lock);
>         return ret;
>  }
>
> @@ -120,10 +114,10 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
>  {
>         int ret = -EINVAL;
>         struct io_pgtable iopt;
> -       struct kvm_hyp_iommu *iommu;
> +       struct kvm_hyp_iommu *iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
>         struct kvm_hyp_iommu_domain *domain;
>
> -       hyp_spin_lock(&iommu_lock);
> +       hyp_spin_lock(&iommu->iommu_lock);
>         domain = handle_to_domain(iommu_id, domain_id, &iommu);
>         if (!domain)
>                 goto out_unlock;
> @@ -137,7 +131,7 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
>         memset(domain, 0, sizeof(*domain));
>
>  out_unlock:
> -       hyp_spin_unlock(&iommu_lock);
> +       hyp_spin_unlock(&iommu->iommu_lock);
>         return ret;
>  }
> --
>
> (I didn't include full patch as it is too long, but mainly the
> rest is s/&iommu_lock/&iommu->iommu_lock)
>
> Please let me know what do you think?

It makes sense, I can append it to my tree or squash it (with your S-o-B)
if you want to send the full patch

Thanks,
Jean
