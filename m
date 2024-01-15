Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C981717597
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SmSEXLHJ"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-429d2ebdf05so454031cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 06:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705329263; x=1705934063; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QD47NFWCVA8oZgXSk2gsIya/0VoXKmXe9WgTGRIO0fI=;
        b=SmSEXLHJFafwl0ObOasP7YBwuXeEJdgKDL5TEMdwPcQ6HuYQ04iKeDRN3nQvOoTNZQ
         WTrMNDNPHIjc1Fyx2Q02GMjODvwqaz6OhhbyluDmIenN9ZLQhHPfY76i+XxOmc8Uc15A
         5DPYZiA3VWvBcCKP4zhg8XaCLvB3O7AZJE8KvZk7JHUjGQ5WLJq24Wk7p+d40Q201Hiy
         qSE54bsW9djSyLqMawDOMNC2/XM4Yz6pUGdGLoy078r/w5d/2zXyhAicSxOawsdO1Mia
         OZ8JmJS5nySJuwDqA92SHIGZ4+2rv4SCo8HnnLezdMZslNPh3NqSjkgq9VaRJnW4mFnp
         o2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705329263; x=1705934063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QD47NFWCVA8oZgXSk2gsIya/0VoXKmXe9WgTGRIO0fI=;
        b=pCH4mb9HAwIcEthnMO8xrcNJNXwlSqVPK21WFCatUSKPblolQaxtImFgkD3MmcMxwl
         kJq6Z3ZbINVp9/dIEnDap/LcSctaO3QwJVH+WOeBNUJvD2K/I75BnQ4ZJjkOGbnPKqLC
         xe5urbd5SaNPmwbkS4ECla7XVTM8wQF8EyvQ262R/P2VujvHb6LdqtoHZ43egeGn2XCN
         6L1QDCs0N63dMP2Gf7GELykzgWnBsQALfY9pbzVmvC/vv+awEykr5Sfnkucmwg207mco
         YPORCgS7FLM87b+GXWC4DI331WWKZN2lkBScgLRp+4C0p8TomqwfeH2onnf7feaQScmM
         vOrQ==
X-Gm-Message-State: AOJu0YxqqaYwTHETWT4UJLZycUkk3j3pr5rxse61uxPYvFIp6n3AtHYK
	NFI+pjSP/hixEuXypXjkNRAyQeEBz4yns8psmIoCcQrVCkHt
X-Google-Smtp-Source: AGHT+IGZoZo61ZIWhTN5lBtgk/IxE15vus9GYE5X5JRUJtqKv/himbiiNolrkb8/0eJ4bc6iPQOc2bhzWPRTAIIpMd8=
X-Received: by 2002:a05:622a:14c8:b0:429:c835:cd9f with SMTP id
 u8-20020a05622a14c800b00429c835cd9fmr859828qtx.12.1705329263498; Mon, 15 Jan
 2024 06:34:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201125328.2186498-1-jean-philippe@linaro.org> <20230201125328.2186498-28-jean-philippe@linaro.org>
In-Reply-To: <20230201125328.2186498-28-jean-philippe@linaro.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 15 Jan 2024 14:34:12 +0000
Message-ID: <CAFgf54pysSxKHcJVP6=dWPxmS3qi=eEMNQMF7SPiaiaeA-Kc_g@mail.gmail.com>
Subject: Re: [RFC PATCH 27/45] KVM: arm64: smmu-v3: Setup domains and page
 table configuration
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org, joro@8bytes.org, 
	robin.murphy@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, dbrazdil@google.com, 
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, 
	Daniel Mentz <danielmentz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Wed, Feb 1, 2023 at 12:59=E2=80=AFPM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> Setup the stream table entries when the host issues the attach_dev() and
> detach_dev() hypercalls. The driver holds one io-pgtable configuration
> for all domains.
>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  include/kvm/arm_smmu_v3.h                   |   2 +
>  arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 178 +++++++++++++++++++-
>  2 files changed, 177 insertions(+), 3 deletions(-)
>
> diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
> index fc67a3bf5709..ed139b0e9612 100644
> --- a/include/kvm/arm_smmu_v3.h
> +++ b/include/kvm/arm_smmu_v3.h
> @@ -3,6 +3,7 @@
>  #define __KVM_ARM_SMMU_V3_H
>
>  #include <asm/kvm_asm.h>
> +#include <linux/io-pgtable-arm.h>
>  #include <kvm/iommu.h>
>
>  #if IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM)
> @@ -28,6 +29,7 @@ struct hyp_arm_smmu_v3_device {
>         size_t                  strtab_num_entries;
>         size_t                  strtab_num_l1_entries;
>         u8                      strtab_split;
> +       struct arm_lpae_io_pgtable pgtable;
>  };
>
>  extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm=
/hyp/nvhe/iommu/arm-smmu-v3.c
> index 81040339ccfe..56e313203a16 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> @@ -152,7 +152,6 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_devic=
e *smmu,
>         return smmu_sync_cmd(smmu);
>  }
>
> -__maybe_unused
>  static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
>  {
>         struct arm_smmu_cmdq_ent cmd =3D {
> @@ -194,7 +193,6 @@ static int smmu_alloc_l2_strtab(struct hyp_arm_smmu_v=
3_device *smmu, u32 idx)
>         return 0;
>  }
>
> -__maybe_unused
>  static u64 *smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 si=
d)
>  {
>         u32 idx;
> @@ -382,6 +380,68 @@ static int smmu_reset_device(struct hyp_arm_smmu_v3_=
device *smmu)
>         return smmu_write_cr0(smmu, 0);
>  }
>
> +static struct hyp_arm_smmu_v3_device *to_smmu(struct kvm_hyp_iommu *iomm=
u)
> +{
> +       return container_of(iommu, struct hyp_arm_smmu_v3_device, iommu);
> +}
> +
> +static void smmu_tlb_flush_all(void *cookie)
> +{
> +       struct kvm_iommu_tlb_cookie *data =3D cookie;
> +       struct hyp_arm_smmu_v3_device *smmu =3D to_smmu(data->iommu);
> +       struct arm_smmu_cmdq_ent cmd =3D {
> +               .opcode =3D CMDQ_OP_TLBI_S12_VMALL,
> +               .tlbi.vmid =3D data->domain_id,
> +       };
> +
> +       WARN_ON(smmu_send_cmd(smmu, &cmd));
> +}
> +
> +static void smmu_tlb_inv_range(struct kvm_iommu_tlb_cookie *data,
> +                              unsigned long iova, size_t size, size_t gr=
anule,
> +                              bool leaf)
> +{
> +       struct hyp_arm_smmu_v3_device *smmu =3D to_smmu(data->iommu);
> +       unsigned long end =3D iova + size;
> +       struct arm_smmu_cmdq_ent cmd =3D {
> +               .opcode =3D CMDQ_OP_TLBI_S2_IPA,
> +               .tlbi.vmid =3D data->domain_id,
> +               .tlbi.leaf =3D leaf,
> +       };
> +
> +       /*
> +        * There are no mappings at high addresses since we don't use TTB=
1, so
> +        * no overflow possible.
> +        */
> +       BUG_ON(end < iova);
> +
> +       while (iova < end) {
> +               cmd.tlbi.addr =3D iova;
> +               WARN_ON(smmu_send_cmd(smmu, &cmd));

This would issue a sync command between each range, which is not needed,
maybe we can build the command first and then issue the sync, similar
to what the upstream driver does, what do you think?

Thanks,
Mostafa
