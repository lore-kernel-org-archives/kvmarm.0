Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44F13A542C
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 12:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777639489; cv=none; b=sSmKFItwwS+w8yacDZSXl6yEr4Ky0Bekpxu0J1nVM7B2tnUmYC1NPLBhT9V/L7NvTiJ7ubT+xIDhfZqmYA8Yt2twurI7eSn6urPCOUi5JfQqqsrfTZWeq7fe9GiHNc8hNoOTtFWncD475BdKJ7ByUSnJKL/MxgA3umMpfzvxKUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777639489; c=relaxed/simple;
	bh=6Yymezd7E/UB3QsnyrfM7fDI7+HVN1rOcGdLpyRqtwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKAFH/j1fFjFIPnrop0VEHAisUfsD9PfhB0L1ilhxOIU9DPTw3rlHAMImqoItvsFVEdLxmkEkFoENEp+DiBIyC/j1G5lArQ8/s+UIYOJ8WTmBltI9xapoq3NYcBxqEUnMEZsxRFfOPk7rhb+bscU+th0T3mGdIZ5rR+LiXlZIhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=E4g/zCKo; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="E4g/zCKo"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8f15e900586so90474185a.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 05:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777639487; x=1778244287; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x+W1ujC/i2sYkXDbzkORn7Jew8iq3dGZCwNInAwZJio=;
        b=E4g/zCKo30bnrmL3jJbn45RNuE5khStlNBTb09gKk3p6RKPMKJK50DpS05c/vTTXAg
         lrlAqxfI6SKqme+L8pI+RMPbwKS0POKodxkXaZyMyI2UOZpYVOAvohdBxMg659IA2IUL
         uc9xBvINIUkXxmqvyu5wmiAMXJ1jvZoaIXK8x6ubS6WQDfOFlwok4OQL/8BXISbl2i/0
         qDz+O3BnUThb8oAjb02XAw3mnc8vjoTWEmBVkaaqzeCiKr+kAuvEuV87ZU3OSTTbYWyi
         qacBSRmzVyWYYT0w03O7I725R5+PPmMIDsDv9o3byfmnp4iCcz4gDmC0aeL93e8r3aM5
         K8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777639487; x=1778244287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+W1ujC/i2sYkXDbzkORn7Jew8iq3dGZCwNInAwZJio=;
        b=asZ4IxsiTLFa2pGJmuJpQ+OLSsLjO+wiqLCNfNdShdcf4R6LSjB1D8CyqYA37xzqUj
         LfZw9VTiSy2xqIZUiUJe92Of1qw6k0urE6Osa3oGeM5U71p3ixTYy5cb0Vku4eseQr/g
         K+Vr7SpzQZFJzWrMyCfiz8fXCHeSwzFkOThn2XRTiZ2ffFWUcFbvEFUfrf+ORqS8yre+
         TvLCptfwEJRHJFeAhntvyyFPB8jy+tTQ+T7318zY65W8i9XxV0cl1nuHF+3YsNkXnNu5
         z31vT5+SfWtzzBkTCALUm3efFzCN0C50ZEjwuGQlEO52NWnZcrF4WaNykcwFgs2OtDrE
         ZLwg==
X-Forwarded-Encrypted: i=1; AFNElJ/CU80h2u27deTPaMAdVNnAt5TJmAKwaf5TdL56KY/CXhHCDIRP4rwr3wU13bP5sQ7S0DnynU4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCxvYx9LR2Oi+e+omljDtYd5OaiqplZ5G3pB7GM0BqjBuchNdI
	f4X8B4t7N6Geis7BW8EgYf0+R2rY+W/664nf0hsIPG0ANpHyU9qrjEQDKjlrkabx8AQ=
X-Gm-Gg: AeBDieuMgP9muHbjJ1b4tOyDPsUFWjhwopKOY4J2rXOw0cSxpfbGjocFFvTFyCudyK/
	zqROqMe+2BYfFGs17anQ1lz5moaT1q3zLueDxUYRPozThNp4/abOso5TBB2ziaVZn0vx0dVxtAv
	fDw2Umui2JvzhAiM2+WWr0uYjdO+pcE92Hxgrg1T+Uc1Mc7lZuCLAdzuetZivMHrMcwfPbgWHKV
	ModVR4YV+MaKxXFAUg58HI+KV+aQo7RM7eWjquN+wnrdqadoSn783Q1qNSNXL6zHmioNsffoCpe
	TZ29ItFUMhco5J01u6O0WbKY6Oolgnrk1uPD8Q2JmkvNwicuPAjpn/YUiJq51brbKytvQ3fkT4n
	jH4TxVjbCdqu9gaWbVWp10z7FINTtZJQVPlAds6WdoPuJG3xlpOfVtKrZT9AmJZq22SszW9CIyh
	jEsMfiFlZCN9BOwr0BoRwkQQ96KB7psyhJvFJB8ENQu35ZQYayvCKw5iFsDyNfDfVIIZDy1FFL/
	gK1lh26PeUPjKrIZE1ubjhuhe0=
X-Received: by 2002:a05:620a:6989:b0:8f0:a3f8:fb2d with SMTP id af79cd13be357-8fa869c827amr1076322085a.2.1777639486728;
        Fri, 01 May 2026 05:44:46 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd06f16sm155809085a.42.2026.05.01.05.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 05:44:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wInEb-000000059N4-2gid;
	Fri, 01 May 2026 09:44:45 -0300
Date: Fri, 1 May 2026 09:44:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 03/25] iommu/arm-smmu-v3: Split code with hyp
Message-ID: <20260501124445.GC6912@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-4-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-4-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:05AM +0000, Mostafa Saleh wrote:
> +int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
> +{
> +	memset(cmd, 0, 1 << CMDQ_ENT_SZ_SHIFT);
> +	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);

Hopefully I get to it today, but I am going to post a series that will
move this logic into the headers while deleting arm_smmu_cmdq_ent. It
should be directly usable for pkvm as well to achieve this same split
without having to shove a giant inline into a header file.

https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/

cover-letter: Remove SMMUv3 struct arm_smmu_cmdq_ent

Jason
