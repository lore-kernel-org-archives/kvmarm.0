Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0011FAC
	for <kvmarm@lists.linux.dev>; Mon,  3 Jul 2023 10:41:59 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3143493728dso1345904f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Jul 2023 03:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688380917; x=1690972917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cefly1GwtRhN7DQubvj71xCv2sWrmliQoTLwjdvrN3M=;
        b=cBGWPSPt4tEcCJ69DxyGXWhm20o6MynGAVzAQmcGnp/avie15eGjwOKb8YAoggbdn5
         GzUk6s6q1Y87NyRckVTI4CPPAw+yhParh6uFm1XFoM/jnWFqi3FyrodhIe9EsAODU+HQ
         YF9XsiPuhSA2Z/nexgJCcuW+2yhHYKGNGIJKxe+VeXQ4R4PthI5iBtXI9DIg3oIOCaoW
         Hp1C6sFTzL7LXJRHNsj/rwuLdyuIPnphoPwuK3G8Qzvq0teH+c9or6kpntqpUzbW2ucC
         zb+akqM49N8H5Cf5fykFQEKPRhqTZUikSjxj00LMI38Gj3mAaX05cDVtYI6dNwiEM57D
         ndow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688380917; x=1690972917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cefly1GwtRhN7DQubvj71xCv2sWrmliQoTLwjdvrN3M=;
        b=ZD5Y7HPr8xBAg0+U16Fy+iESrocL9STTYzyDahckKBF9CHMtrX1ExCBbZwyuPEME2Q
         jGhpzWtDDnia/NEbJ7nCm2rzkOSl1CdeFhlodF5eVqTNK8fQdJc/e8Pvp/fcChASKOWe
         ezVcqNVpcuaHcKoo25AP1+4coLA/0Zhyo2TfU4jL6xrlyNudP6JVJqy/UXnkZq+kAk+B
         hpp9iO9PCcxTtUc64rH/cDiotrz3yItoshENY3/KON54+uu1k9ljaoAEq8qbPKE1QkaC
         i3C1X0lv3dRH1VulaD7Ij0ERdVDl783vMPU0EdlU0LeIpeBJOIxesYr8RDgUNhvJ0Z4A
         /W9Q==
X-Gm-Message-State: ABy/qLb9oJKdu86f+e/SlnAURTFo3pLJoRY47F4W49mVuQ3F8Wns/3mE
	6ry8FYJ1g7Efhttk34/7H1SabA==
X-Google-Smtp-Source: APBJJlHjQY5wS4Wm5OydaNz9HLZuUE94gA3T/csBsXJLJ9RDfVNFA2Z1ykgnyXuPvZ8PBhKd7GQcwQ==
X-Received: by 2002:adf:f3c4:0:b0:313:ebf3:850e with SMTP id g4-20020adff3c4000000b00313ebf3850emr8270897wrp.37.1688380917352;
        Mon, 03 Jul 2023 03:41:57 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id b7-20020a5d45c7000000b003141a3c4353sm10606788wrs.30.2023.07.03.03.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 03:41:56 -0700 (PDT)
Date: Mon, 3 Jul 2023 11:41:56 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 27/45] KVM: arm64: smmu-v3: Setup domains and page
 table configuration
Message-ID: <20230703104156.GB2439191@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-28-jean-philippe@linaro.org>
 <ZJXuhQeDgK4sShRA@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJXuhQeDgK4sShRA@google.com>

Hi Mostafa,

On Fri, Jun 23, 2023 at 07:12:05PM +0000, Mostafa Saleh wrote:
> > +static int smmu_detach_dev(struct kvm_hyp_iommu *iommu, pkvm_handle_t domain_id,
> > +			   struct kvm_hyp_iommu_domain *domain, u32 sid)
> > +{
> > +	u64 ttb;
> > +	u64 *dst;
> > +	int i, ret;
> > +	struct hyp_arm_smmu_v3_device *smmu = to_smmu(iommu);
> > +
> > +	dst = smmu_get_ste_ptr(smmu, sid);
> > +	if (!dst)
> > +		return -ENODEV;
> > +
> > +	ttb = dst[3] & STRTAB_STE_3_S2TTB_MASK;
> This is unused, does detach needs to do anything with ttb?

No it doesn't look like I've ever used this, I removed it

Thanks,
Jean
