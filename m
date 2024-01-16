Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633CF12B61
	for <kvmarm@lists.linux.dev>; Tue, 16 Jan 2024 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f2lOTeVG"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-429d2ebdf05so663071cf.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jan 2024 00:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705395593; x=1706000393; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/igkgCyA152m1fzCehtUHeYlu0mhCasrXV541Dw4cvc=;
        b=f2lOTeVGfd8anclzjN3wwHqZ1ohqed3/YEUZ/BE/JezKVinqA1vtrDLbsdx44NKvor
         qhm2JfmGs2cer+zwkJky6a8e7xpSC4nNLmKhfXS3QZn/wlaSTKDqQoeAVJpPorECujk9
         lyuXAyJqvGSXb7EqbavGDSkII1/HhhQ1gtx01PVBHypSicxAvldvJDY4uqcW/kiWi+Tp
         itWbr8vy8jfVgh6uGTBsxQXTEE3crOgohVDKly7jZVC2+la4v2P5znv0ITrBxSgqnOuX
         3HxfCcCyHRs/cP6FZwAVUJpO4//V7k73ZhOmCPdyN/T3d1eT8eezKl1qbEjEeywgqFit
         TNOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705395593; x=1706000393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/igkgCyA152m1fzCehtUHeYlu0mhCasrXV541Dw4cvc=;
        b=PUB/cDbbR6FinZ6FZ1IyqycuK/c8fnZNN/3/zyIql0J1eseVF1ugoT8KyTAJ4UZPOk
         9ywfDs25WXNMiekhz9sMCq2eoZBPyLko+KxMp4Qer4ifWrO7KMowToBCWZ1bglQNBv/m
         Lz715V3zExrSTt52YLMqOhkyrsENzcxDILavqj5DcDcZhTtl3VkqG3Hb1d5eR7z3K8Ha
         qf1NwHhueAJ5MULMZ0dQ6/8bWf6FFIEFg5v0V72bU/WbRaTMySd98biaBhRVojkLqrid
         OpMioel/Z3PaBDRSVefUIqF0lOKJCGzC8OIi67Dmujbnnz5Pcp5llIpCxwR68IcMh8/h
         FKZg==
X-Gm-Message-State: AOJu0YyXAWaoGZadvv3mdiH4QtY7lQDGiDf/JHSju1v8TRLSrXSiMQ8Q
	Nxqt7fRMCXo650Q1VgZFV0s6Yn46d3w3L3NWfYNimtVwiR2R
X-Google-Smtp-Source: AGHT+IFqW6pcSkRl+kNnNA6UxnwDzJDioCsXMI2eqdzhDZzh6KY/0DXg2WWhBI5TtTkUDNvwGw5V/d5icdBQrzQcI5M=
X-Received: by 2002:a05:622a:608e:b0:429:e35c:e3b7 with SMTP id
 hf14-20020a05622a608e00b00429e35ce3b7mr294775qtb.18.1705395593175; Tue, 16
 Jan 2024 00:59:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201125328.2186498-1-jean-philippe@linaro.org> <20230201125328.2186498-25-jean-philippe@linaro.org>
In-Reply-To: <20230201125328.2186498-25-jean-philippe@linaro.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 16 Jan 2024 08:59:41 +0000
Message-ID: <CAFgf54qcTAru0Nvy1wH_tJMadOSW7Y3zEip5RTm+mtSa54Bymg@mail.gmail.com>
Subject: Re: [RFC PATCH 24/45] KVM: arm64: smmu-v3: Setup stream table
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org, joro@8bytes.org, 
	robin.murphy@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, dbrazdil@google.com, 
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Wed, Feb 1, 2023 at 12:59=E2=80=AFPM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> Map the stream table allocated by the host into the hypervisor address
> space. When the host mappings are finalized, the table is unmapped from
> the host. Depending on the host configuration, the stream table may have
> one or two levels. Populate the level-2 stream table lazily.
>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  include/kvm/arm_smmu_v3.h                   |   4 +
>  arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 133 +++++++++++++++++++-
>  2 files changed, 136 insertions(+), 1 deletion(-)
>
> diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
> index da36737bc1e0..fc67a3bf5709 100644
> --- a/include/kvm/arm_smmu_v3.h
> +++ b/include/kvm/arm_smmu_v3.h
> @@ -24,6 +24,10 @@ struct hyp_arm_smmu_v3_device {
>         u32                     cmdq_prod;
>         u64                     *cmdq_base;
>         size_t                  cmdq_log2size;
> +       u64                     *strtab_base;
> +       size_t                  strtab_num_entries;
> +       size_t                  strtab_num_l1_entries;
> +       u8                      strtab_split;
>  };
>
>  extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm=
/hyp/nvhe/iommu/arm-smmu-v3.c
> index 36ee5724f36f..021bebebd40c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> @@ -141,7 +141,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_devic=
e *smmu)
>         return smmu_wait_event(smmu, smmu_cmdq_empty(smmu));
>  }
>
> -__maybe_unused
>  static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
>                          struct arm_smmu_cmdq_ent *cmd)
>  {
> @@ -153,6 +152,82 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_devi=
ce *smmu,
>         return smmu_sync_cmd(smmu);
>  }
>
> +__maybe_unused
> +static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
> +{
> +       struct arm_smmu_cmdq_ent cmd =3D {
> +               .opcode =3D CMDQ_OP_CFGI_STE,
> +               .cfgi.sid =3D sid,
> +               .cfgi.leaf =3D true,
> +       };
> +
> +       return smmu_send_cmd(smmu, &cmd);
> +}
> +
I see the page tables are properly configured for ARM_SMMU_FEAT_COHERENCY b=
ut no
handling for the STE or CMDQ, I believe here we should have something as:
if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
        kvm_flush_dcache_to_poc(step, STRTAB_STE_DWORDS << 3);

Similarly in "smmu_add_cmd" for the command queue. Or use NC mapping
(which doesn't exist
upstream as far as I can see)

Thanks,
Mostafa
