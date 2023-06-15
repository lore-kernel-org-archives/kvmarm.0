Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F38495
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 13:32:40 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f7e4953107so90055e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 06:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686835958; x=1689427958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Fe8n19wwAbmfd0VoTnH2Ng+wpFvAxCOrxXVaNksRc8=;
        b=M58HbVYDKes0Ymmt25UG1OsX8ciJJVVMZ/Sl9VqReqm18w/exin513E9I/JyzouDKv
         umgPYLupQusdpaAHh4VOsxTbb7c1XCp+nQd7tQ8xHmaGOm6U/QMM0IYkbztMyxJsekCD
         hmOrTEFTxaaL1MVlVFz4/PBRj7P70UPoC4wmp30NuqStV5MLlE6hEz5SDlcU75XJJJ78
         oD4k2Ny47mBUB7/5vywa1ZTJ3Kzhek4NC1zmo7Q/DBQaYXQRBi/McePILS7cvc64GkYw
         m7JNqmurJBNDGuscaW1wu0Z1Zrbn/qb1AxsgYtudJNbtOvywaXRvJLIbY8TXamb0oUJy
         JpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686835958; x=1689427958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Fe8n19wwAbmfd0VoTnH2Ng+wpFvAxCOrxXVaNksRc8=;
        b=Rw5ZX3QEfgqRi4VuVHgL1T64gcM5e5QKsDVAWfznBp2VK7SJG3KGYLhlTk594b1ytp
         puCadvTYysm6GBvNiuEEe4p6bWP3o0i9yxIYxVo4TIvUngXEaaA05EAISco7rmgLDpvq
         v72nMcWR3JGsLAKOwrH5AyouEFmAu7SZh2h2eNo74AT7Hcd8jzq7mQlsOnZpVownAe/U
         d9v7cMVTcP9/VzIY/sNoz2HvTLrswakt32MdllbJp+4bN7gL6F3FNpDWqPPB/Q7IKqsu
         ypQt6NRhhKEXSFv4qoFKm0w3gFhF/SyfQAhj0BqVHQTjaDcMpxYryiMdGl59UACM6Hs/
         ourA==
X-Gm-Message-State: AC+VfDy6pCc5XHxu/abD0ivVnjGi2ocI1udzwR8JBkVgLfClZYFL8p+W
	h98FseAy2Jsw3Kwf5qZVXagIfA==
X-Google-Smtp-Source: ACHHUZ79fiwPqrRlbx+3qk28Z9rFtrqp/3CO/qQv4XWJ0xVG2mkDoWB/nNftzRbS0JBfV79r2m/YKg==
X-Received: by 2002:a7b:cd18:0:b0:3f7:7bd4:3b9d with SMTP id f24-20020a7bcd18000000b003f77bd43b9dmr174650wmj.6.1686835958154;
        Thu, 15 Jun 2023 06:32:38 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id t1-20020adfe101000000b0030e5a63e2dbsm21261717wrz.80.2023.06.15.06.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 06:32:37 -0700 (PDT)
Date: Thu, 15 Jun 2023 13:32:32 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
Message-ID: <ZIsS8C/8yyIS6GYP@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-20-jean-philippe@linaro.org>
 <ZGeWudESZP5BGjaA@google.com>
 <CAEBBgu3QbgHb2Bf1hTaYL2SDDsYKKqixJ7+u+VCd_sYj6VfWbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEBBgu3QbgHb2Bf1hTaYL2SDDsYKKqixJ7+u+VCd_sYj6VfWbw@mail.gmail.com>

Hi Jean,

On Fri, Jun 02, 2023 at 04:29:07PM +0100, Jean-Philippe Brucker wrote:
> Hi Mostafa,
> 
> On Fri, 19 May 2023 at 16:33, Mostafa Saleh <smostafa@google.com> wrote:
> >
> > Hi Jean,
> >
> > On Wed, Feb 01, 2023 at 12:53:03PM +0000, Jean-Philippe Brucker wrote:
> > > +/*
> > > + * Serialize access to domains and IOMMU driver internal structures (command
> > > + * queue, device tables)
> > > + */
> > > +static hyp_spinlock_t iommu_lock;
> > > +
> > I was looking more into this lock and I think we can make it per IOMMU instead
> > of having one big lock to avoid congestion, as I see it is only used to
> > protect per-IOMMU resources.
> 
> Yes it's a major bottleneck, thanks for looking into this. I think we'll
> eventually want to improve scalability within an IOMMU and even a domain:
> a multi-queue network device will share a single domain between multiple
> CPUs, each issuing lots of map/unmap calls. Or just two devices drivers
> working on different CPUs and sharing one IOMMU. In those cases the
> per-IOMMU lock won't be good enough and we'll be back to this problem, but
> a per-IOMMU lock should already improve scalability for some systems.
> 
> Currently the global lock protects:
> 
> (1) The domain array (per IOMMU)
> (2) The io-pgtables (per domain)
> (3) The command queue (per SMMU)
> (4) Power state (per SMMU)
> 
> I ran some experiments with refcounting the domains to avoid the lock for
> (1) and (2), which improves map() scalability. See
> https://jpbrucker.net/git/linux/commit/?h=pkvm/smmu-wip&id=5ad3bc6fd589b6f11fe31ccee5b8777ba8739167
> (and another experiment to optimize the DMA refcount on branch pkvm/smmu-wip)

Thanks for the detailed explanation! I will give it a try.

> For (2), the io-pgtable-arm code already supports concurrent accesses
> (2c3d273eabe8 ("iommu/io-pgtable-arm: Support lockless operation")). But
> this one needs careful consideration because in the host, the io-pgtable
> code trusts the device drivers. For example it expects that only buggy
> drivers call map()/unmap() to the same IOVA concurrently. We need to make
> sure a compromised host drivers can't exploit these assumptions to do
> anything nasty.
> 
> There are options to improve (3) as well. The host SMMU driver supports
> lockless command-queue (587e6c10a7ce ("iommu/arm-smmu-v3: Reduce
> contention during command-queue insertion")) but it may be too complex to
> put in the hypervisor (or rather, I haven't tried to understand it yet).
> We could also wait for systems with ECMDQ, which enables per-CPU queues.
I was thinking about the same thing, in the futrue we should aim to have a
similar lockless approach for the cmdq as the host in EL2. I am not sure
how feasable it is, I will have a closer look. But having a per-IOMMU
shouldbe be a step in the right direction.

> > Some special handling needed as hyp_spinlock_t is not exposed to EL1.
> > Maybe something like this:
> >
> > diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
> > index b257a3b4bfc5..96d30a37f9e6 100644
> > --- a/arch/arm64/kvm/hyp/hyp-constants.c
> > +++ b/arch/arm64/kvm/hyp/hyp-constants.c
> > @@ -3,11 +3,13 @@
> >  #include <linux/kbuild.h>
> >  #include <nvhe/memory.h>
> >  #include <nvhe/pkvm.h>
> > +#include <nvhe/spinlock.h>
> >
> >  int main(void)
> >  {
> >         DEFINE(STRUCT_HYP_PAGE_SIZE,    sizeof(struct hyp_page));
> >         DEFINE(PKVM_HYP_VM_SIZE,        sizeof(struct pkvm_hyp_vm));
> >         DEFINE(PKVM_HYP_VCPU_SIZE,      sizeof(struct pkvm_hyp_vcpu));
> > +       DEFINE(HYP_SPINLOCK_SIZE,       sizeof(hyp_spinlock_t));
> >         return 0;
> >  }
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
> > index a90b97d8bae3..cf9195e24a08 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> > +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> > @@ -6,6 +6,7 @@ arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
> >  arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
> >
> >  obj-$(CONFIG_ARM_SMMU_V3_PKVM) += arm_smmu_v3_kvm.o
> > +ccflags-$(CONFIG_ARM_SMMU_V3_PKVM) += -Iarch/arm64/kvm/
> >  arm_smmu_v3_kvm-objs-y += arm-smmu-v3-kvm.o
> >  arm_smmu_v3_kvm-objs-y += arm-smmu-v3-common.o
> >  arm_smmu_v3_kvm-objs := $(arm_smmu_v3_kvm-objs-y)
> > diff --git a/include/kvm/iommu.h b/include/kvm/iommu.h
> > index ab888da731bc..82827b99b1ed 100644
> > --- a/include/kvm/iommu.h
> > +++ b/include/kvm/iommu.h
> > @@ -5,6 +5,12 @@
> >  #include <asm/kvm_host.h>
> >  #include <kvm/power_domain.h>
> >  #include <linux/io-pgtable.h>
> > +#ifdef __KVM_NVHE_HYPERVISOR__
> > +#include <nvhe/spinlock.h>
> > +#else
> > +#include "hyp_constants.h"
> > +#endif
> >
> >  /*
> >   * Parameters from the trusted host:
> > @@ -23,6 +29,11 @@ struct kvm_hyp_iommu {
> >
> >         struct io_pgtable_params        *pgtable;
> >         bool                            power_is_off;
> > +#ifdef __KVM_NVHE_HYPERVISOR__
> > +       hyp_spinlock_t                  iommu_lock;
> > +#else
> > +       u8 unused[HYP_SPINLOCK_SIZE];
> > +#endif
> >  };
> >
> >  struct kvm_hyp_iommu_memcache {
> > diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > index 1f4d5fcc1386..afaf173e65ed 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > @@ -14,12 +14,6 @@
> >
> >  struct kvm_hyp_iommu_memcache __ro_after_init *kvm_hyp_iommu_memcaches;
> >
> > -/*
> > - * Serialize access to domains and IOMMU driver internal structures (command
> > - * queue, device tables)
> > - */
> > -static hyp_spinlock_t iommu_lock;
> > -
> >  #define domain_to_iopt(_iommu, _domain, _domain_id)            \
> >         (struct io_pgtable) {                                   \
> >                 .ops = &(_iommu)->pgtable->ops,                 \
> > @@ -93,10 +87,10 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
> >  {
> >         int ret = -EINVAL;
> >         struct io_pgtable iopt;
> > -       struct kvm_hyp_iommu *iommu;
> > +       struct kvm_hyp_iommu *iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
> >         struct kvm_hyp_iommu_domain *domain;
> >
> > -       hyp_spin_lock(&iommu_lock);
> > +       hyp_spin_lock(&iommu->iommu_lock);
> >         domain = handle_to_domain(iommu_id, domain_id, &iommu);
> >         if (!domain)
> >                 goto out_unlock;
> > @@ -112,7 +106,7 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
> >         domain->refs = 1;
> >         domain->pgd = iopt.pgd;
> >  out_unlock:
> > -       hyp_spin_unlock(&iommu_lock);
> > +       hyp_spin_unlock(&iommu->iommu_lock);
> >         return ret;
> >  }
> >
> > @@ -120,10 +114,10 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
> >  {
> >         int ret = -EINVAL;
> >         struct io_pgtable iopt;
> > -       struct kvm_hyp_iommu *iommu;
> > +       struct kvm_hyp_iommu *iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
> >         struct kvm_hyp_iommu_domain *domain;
> >
> > -       hyp_spin_lock(&iommu_lock);
> > +       hyp_spin_lock(&iommu->iommu_lock);
> >         domain = handle_to_domain(iommu_id, domain_id, &iommu);
> >         if (!domain)
> >                 goto out_unlock;
> > @@ -137,7 +131,7 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
> >         memset(domain, 0, sizeof(*domain));
> >
> >  out_unlock:
> > -       hyp_spin_unlock(&iommu_lock);
> > +       hyp_spin_unlock(&iommu->iommu_lock);
> >         return ret;
> >  }
> > --
> >
> > (I didn't include full patch as it is too long, but mainly the
> > rest is s/&iommu_lock/&iommu->iommu_lock)
> >
> > Please let me know what do you think?
> 
> It makes sense, I can append it to my tree or squash it (with your S-o-B)
> if you want to send the full patch
Sure, that is the full patch based on latest
https://jpbrucker.net/git/linux/log/?h=pkvm/smmu

Thanks,
Mostafa

--

From 5b43b97ca2486d52aa2ad475e4a34357dea57bca Mon Sep 17 00:00:00 2001
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 13 Jun 2023 14:59:37 +0000
Subject: [PATCH] KVM: arm: iommu: Use per-iommu lock instead of one global
 lock

Currently, there is one big lock for all of the IOMMU operations
which is used to protect per-IOMMU resources or domains (which are
currently per-IOMMU also).

This can be improved for setups with many IOMMUs by having a per
IOMMU lock.

As now we always get the iommu before calling handle_to_domain, we
can remove the out_iommu arg and iommu_id and pass iommu instead.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/hyp-constants.c     |  1 +
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c  | 75 +++++++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/Makefile |  1 +
 include/kvm/iommu.h                    | 10 ++++
 4 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index b257a3b4bfc5..d84cc8ec1e46 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -9,5 +9,6 @@ int main(void)
 	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
 	DEFINE(PKVM_HYP_VM_SIZE,	sizeof(struct pkvm_hyp_vm));
 	DEFINE(PKVM_HYP_VCPU_SIZE,	sizeof(struct pkvm_hyp_vcpu));
+	DEFINE(HYP_SPINLOCK_SIZE,       sizeof(hyp_spinlock_t));
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index c70d3b6934eb..1dcba39d1d41 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -14,12 +14,6 @@

 struct kvm_hyp_iommu_memcache __ro_after_init *kvm_hyp_iommu_memcaches;

-/*
- * Serialize access to domains and IOMMU driver internal structures (command
- * queue, device tables)
- */
-static hyp_spinlock_t iommu_lock;
-
 #define domain_to_iopt(_iommu, _domain, _domain_id)		\
 	(struct io_pgtable) {					\
 		.ops = &(_iommu)->pgtable->ops,			\
@@ -59,14 +53,11 @@ void kvm_iommu_reclaim_page(void *p)
 }

 static struct kvm_hyp_iommu_domain *
-handle_to_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
-		 struct kvm_hyp_iommu **out_iommu)
+handle_to_domain(struct kvm_hyp_iommu *iommu, pkvm_handle_t domain_id)
 {
 	int idx;
-	struct kvm_hyp_iommu *iommu;
 	struct kvm_hyp_iommu_domain *domains;

-	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
 	if (!iommu)
 		return NULL;

@@ -83,7 +74,6 @@ handle_to_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 		iommu->domains[idx] = domains;
 	}

-	*out_iommu = iommu;
 	return &domains[domain_id & KVM_IOMMU_DOMAIN_ID_LEAF_MASK];
 }

@@ -95,8 +85,9 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	struct kvm_hyp_iommu *iommu;
 	struct kvm_hyp_iommu_domain *domain;

-	hyp_spin_lock(&iommu_lock);
-	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	hyp_spin_lock(&iommu->iommu_lock);
+	domain = handle_to_domain(iommu, domain_id);
 	if (!domain)
 		goto out_unlock;

@@ -111,7 +102,7 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	domain->refs = 1;
 	domain->pgd = iopt.pgd;
 out_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return ret;
 }

@@ -122,8 +113,9 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
 	struct kvm_hyp_iommu *iommu;
 	struct kvm_hyp_iommu_domain *domain;

-	hyp_spin_lock(&iommu_lock);
-	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	hyp_spin_lock(&iommu->iommu_lock);
+	domain = handle_to_domain(iommu, domain_id);
 	if (!domain)
 		goto out_unlock;

@@ -136,7 +128,7 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
 	memset(domain, 0, sizeof(*domain));

 out_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return ret;
 }

@@ -147,8 +139,9 @@ int kvm_iommu_attach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	struct kvm_hyp_iommu *iommu;
 	struct kvm_hyp_iommu_domain *domain;

-	hyp_spin_lock(&iommu_lock);
-	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	hyp_spin_lock(&iommu->iommu_lock);
+	domain = handle_to_domain(iommu, domain_id);
 	if (!domain || !domain->refs || domain->refs == UINT_MAX)
 		goto out_unlock;

@@ -158,7 +151,7 @@ int kvm_iommu_attach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,

 	domain->refs++;
 out_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return ret;
 }

@@ -169,8 +162,9 @@ int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	struct kvm_hyp_iommu *iommu;
 	struct kvm_hyp_iommu_domain *domain;

-	hyp_spin_lock(&iommu_lock);
-	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	hyp_spin_lock(&iommu->iommu_lock);
+	domain = handle_to_domain(iommu, domain_id);
 	if (!domain || domain->refs <= 1)
 		goto out_unlock;

@@ -180,7 +174,7 @@ int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,

 	domain->refs--;
 out_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return ret;
 }

@@ -209,9 +203,10 @@ int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	    iova + size < iova || paddr + size < paddr)
 		return -EOVERFLOW;

-	hyp_spin_lock(&iommu_lock);
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	hyp_spin_lock(&iommu->iommu_lock);

-	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	domain = handle_to_domain(iommu, domain_id);
 	if (!domain)
 		goto err_unlock;

@@ -236,7 +231,7 @@ int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 		paddr += mapped;
 	}

-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return 0;

 err_unmap:
@@ -245,7 +240,7 @@ int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 		iopt_unmap_pages(&iopt, iova_orig, pgsize, pgcount, NULL);
 	__pkvm_host_unshare_dma(paddr_orig, size);
 err_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return ret;
 }

@@ -269,8 +264,9 @@ size_t kvm_iommu_unmap_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	    iova + size < iova)
 		return 0;

-	hyp_spin_lock(&iommu_lock);
-	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	hyp_spin_lock(&iommu->iommu_lock);
+	domain = handle_to_domain(iommu, domain_id);
 	if (!domain)
 		goto out_unlock;

@@ -299,7 +295,7 @@ size_t kvm_iommu_unmap_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	}

 out_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return total_unmapped;
 }

@@ -311,14 +307,15 @@ phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t iommu_id,
 	struct kvm_hyp_iommu *iommu;
 	struct kvm_hyp_iommu_domain *domain;

-	hyp_spin_lock(&iommu_lock);
-	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	hyp_spin_lock(&iommu->iommu_lock);
+	domain = handle_to_domain(iommu, domain_id);
 	if (domain) {
 		iopt = domain_to_iopt(iommu, domain, domain_id);

 		phys = iopt_iova_to_phys(&iopt, iova);
 	}
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return phys;
 }

@@ -333,9 +330,9 @@ static int iommu_power_on(struct kvm_power_domain *pd)
 	 * We currently assume that the device retains its architectural state
 	 * across power off, hence no save/restore.
 	 */
-	hyp_spin_lock(&iommu_lock);
+	hyp_spin_lock(&iommu->iommu_lock);
 	iommu->power_is_off = false;
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return 0;
 }

@@ -346,9 +343,9 @@ static int iommu_power_off(struct kvm_power_domain *pd)

 	pkvm_debug("%s\n", __func__);

-	hyp_spin_lock(&iommu_lock);
+	hyp_spin_lock(&iommu->iommu_lock);
 	iommu->power_is_off = true;
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return 0;
 }

@@ -362,6 +359,8 @@ int kvm_iommu_init_device(struct kvm_hyp_iommu *iommu)
 	int ret;
 	void *domains;

+	hyp_spin_lock_init(&iommu->iommu_lock);
+
 	ret = pkvm_init_power_domain(&iommu->power_domain, &iommu_power_ops);
 	if (ret)
 		return ret;
@@ -376,8 +375,6 @@ int kvm_iommu_init(void)
 {
 	enum kvm_pgtable_prot prot;

-	hyp_spin_lock_init(&iommu_lock);
-
 	if (WARN_ON(!kvm_iommu_ops.get_iommu_by_id ||
 		    !kvm_iommu_ops.alloc_iopt ||
 		    !kvm_iommu_ops.free_iopt ||
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index a90b97d8bae3..cf9195e24a08 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -6,6 +6,7 @@ arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)

 obj-$(CONFIG_ARM_SMMU_V3_PKVM) += arm_smmu_v3_kvm.o
+ccflags-$(CONFIG_ARM_SMMU_V3_PKVM) += -Iarch/arm64/kvm/
 arm_smmu_v3_kvm-objs-y += arm-smmu-v3-kvm.o
 arm_smmu_v3_kvm-objs-y += arm-smmu-v3-common.o
 arm_smmu_v3_kvm-objs := $(arm_smmu_v3_kvm-objs-y)
diff --git a/include/kvm/iommu.h b/include/kvm/iommu.h
index ab888da731bc..b7cda7540156 100644
--- a/include/kvm/iommu.h
+++ b/include/kvm/iommu.h
@@ -5,6 +5,11 @@
 #include <asm/kvm_host.h>
 #include <kvm/power_domain.h>
 #include <linux/io-pgtable.h>
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/spinlock.h>
+#else
+#include "hyp_constants.h"
+#endif

 /*
  * Parameters from the trusted host:
@@ -23,6 +28,11 @@ struct kvm_hyp_iommu {

 	struct io_pgtable_params	*pgtable;
 	bool				power_is_off;
+#ifdef __KVM_NVHE_HYPERVISOR__
+	hyp_spinlock_t			iommu_lock;
+#else
+	u8 unused[HYP_SPINLOCK_SIZE];
+#endif
 };

 struct kvm_hyp_iommu_memcache {
--
2.41.0.162.gfafddb0af9-goog

