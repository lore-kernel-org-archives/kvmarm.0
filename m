Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7084C2C235F
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 17:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764349977; cv=none; b=HszbcrxVyuTr8fQjmerU5C1xUAXdFTbyJ/rd+7uuxWXCbjdNlL4bZOGzOdYUix9sIuCK9ZWYnomENa4M5CYJblSx0G8CZkralAx7VN0gJ4+HIpO6V5RFKxuoPijXXrq2BSKr48mtg+g7R6DAYzStqVP9+t5VhfxoGAeFtRs3MHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764349977; c=relaxed/simple;
	bh=/sBYS2Dqy7t/Qv6aMLloF3PncUN9/Dov0w4IrPDsi+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CBQsiz4hRBxKRYxLXTSrbrKtVn6vSNeJ1TByQnT0p21zDw5YymlQxd1De8/uXksV54Sp/eMHLp6NT+T8UCDpsARxAhnWU7Hd2nZkeYgV5m3anxGv5XHIEzznRUIXNfQDaQQqvuxHQ0j6yIXgrLqGr3rGItWzm/N+hjG8mpkcgNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=B09mikJw; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="B09mikJw"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b2dcdde65bso286975785a.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 09:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764349974; x=1764954774; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGMOgE5nROcKR76+XJUgIhsjqUTTAWoW5W6MOeDvkTk=;
        b=B09mikJwgHFtd1tfDrnBPZZQoxCfG1v/G5bwhNR2MdnscKbPGVKu4wrhrDToZxeU1u
         LGT+Fd/bVzNok5hSkTNXpeQn6Tr/+jJ44XQ73ul377qDAnLKGqQBkRz5xAHH1Pgk91hg
         xSXS2oK3AWPcsuyeWq500OHfbjyn3ghh+mnO+tf3fBBZsb7ctm2YxydvSu0AgPbg2+M+
         8lkcvFOSk/pRMT/eh8mAxdWBvx3UX3imhtCDFoRfsjrTCwQLeZ2usuLnczLHXd/qxSj+
         u3AQhQZlLQp/Pd/nUZp5eqNFT1nDX027zcfy/K5O7MKc92dyKWdaK8bS2uA8wIwJRfGt
         LlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764349974; x=1764954774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VGMOgE5nROcKR76+XJUgIhsjqUTTAWoW5W6MOeDvkTk=;
        b=j0q0aySIkPW3BnnotxnjCaVqntuICdH9pIYEja2jeqfiIGVtkCLS5/fhuI5Mp0ttC9
         zByp5FwiO/4r8Te+rO5wcQ61soP8FfolcxV2FJFHrL8KVn27ve5JCA91WDcla+9Sm3cT
         XJbiY/NECaJ62VhN7ujO0wcOxrHd3JSkZl5fuXweaGLFwm4lG6++G3GIz7NZo8EpoUWd
         DosogJ5lVe8tzEOHQZMLwB1VVZfoKJDoHVo1ruRXPgK0XdPMVmOuMvEvJgHvcaJN23o9
         1Ww22rYwdmNJT0dQi04wwCHse/flCFy1XK12Sfe8VHjZo32IZf8rCOL7Udc0lxS3Wi6i
         xK9g==
X-Forwarded-Encrypted: i=1; AJvYcCVxNkBo0B8DD1QeUOqaSFMaskR59vfiFnUA+BTqSnm8GaRnqi5IjWF9aJqExQVKY87BgbZzMis=@lists.linux.dev
X-Gm-Message-State: AOJu0YxV/M3PNgSuUp9T11XtcvACjoWAqgQ1sVA5IlNJwhOBLm9MpK6z
	qVGO2VnoL1HQ3JlmZI9iyqS+U7mLowqySdodTX7ejOWgsHyPi1DG5fXgA0M1Al5EuRE=
X-Gm-Gg: ASbGnctIbkZ5zDlw5xmTQ/F8J6b1u+hVzRKbAfmWk6PBqbL1HebkFxWsjYEiSBKXj++
	PNuYTAb6zKdfbeXh3kJJmks8VsMMfR4oqt+ZksPDJMpMWea0hBz0FRFnfU/TCxboJU9tz30uoCq
	mSO9PGvdZg/5zqYCiGux6p7wiahcwgheJbxLtCrtuMbeQY9/t7EXLLVc+RdJfoRUUfIJYhBqZlo
	Oz+Zp6+GfwtJgDA9sS2FATrsXoWneb76Y2Bv+Dd0ASzvq9gG76/tRUWMVFy1uG5l27h5ieEW089
	Egq/v3UNGXZ+7eVUZGkFwW1tB2J8z0vdGoQ5028Kfag1PMoEJLEMDWftehr1UCip+HQLZpBbFWT
	VoojBloqtYGtJ3ABLTDkCYfxO09uplbJHFcdg2dlTK+gPgKflCYHCGSAM7/exn3DH9Aq3Qof2zF
	ozo3c3DKy0Ukz+3OlOW7kr8kP+cYHar2UokKnScqMwCkpmlmkQV3ZcOvGv
X-Google-Smtp-Source: AGHT+IEpLMRDIa8BpUCxOvzv6sBrlYlrmtR4jLIjgGtg7IeIGGp0t/UdGNKFxQmXbiZHtnUvklj64g==
X-Received: by 2002:a05:620a:3188:b0:864:48eb:34e with SMTP id af79cd13be357-8b4ebdaea45mr2049767785a.55.1764349974363;
        Fri, 28 Nov 2025 09:12:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a69d1sm339226285a.16.2025.11.28.09.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:12:53 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vP21c-00000003Q9u-4AUc;
	Fri, 28 Nov 2025 13:12:53 -0400
Date: Fri, 28 Nov 2025 13:12:52 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 27/27] iommu/arm-smmu-v3-kvm: Enable nesting
Message-ID: <20251128171252.GF812105@ziepe.ca>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-28-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117184815.1027271-28-smostafa@google.com>

On Mon, Nov 17, 2025 at 06:48:14PM +0000, Mostafa Saleh wrote:
> @@ -441,8 +490,32 @@ static void smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
>  		hyp_ste_ptr = smmu_get_ste_ptr(smmu, sid, hyp_ste_base);
>  	}
>  
> -	smmu_copy_from_host(smmu, hyp_ste_ptr->data, host_ste_ptr->data,
> +	smmu_copy_from_host(smmu, target.data, host_ste_ptr->data,
>  			    STRTAB_STE_DWORDS << 3);
> +	/*
> +	 * Typically, STE update is done as the following
> +	 * 1- Write last 7 dwords, while STE is invalid
> +	 * 2- CFGI
> +	 * 3- Write first dword, making STE valid
> +	 * 4- CFGI
> +	 * As the SMMU MUST at least load 64 bits atomically
> +	 * that gurantees that there is no race between writing
> +	 * the STE and the CFGI where the SMMU observes parts
> +	 * of the STE.
> +	 * In the shadow we update the STE to enable nested translation,
> +	 * which requires updating first 4 dwords.
> +	 * That is only done if the STE is valid and not in abort.
> +	 * Which means it happens at step 4)
> +	 * So we need to also write the last 7 dwords and send CFGI
> +	 * before writing the first dword.
> +	 * There is no need for last CFGI as it's done next.
> +	 */

This really should share the main driver logic to do STE writes in the
right order and try to avoid making it non-valid if not necessary.

This will not properly support all the real-world kernel flows around
PASID with such a simplistic implementation.

Json
