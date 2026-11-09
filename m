Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794222376;
	b=E3DWJ+hEgNmkFpFT3dZ3Y7RODeTTInmJck8yk3X/F2prSFNgJKPCzUMl0msSD7RE5WCO
	 9Xv1YbUo9Gg9jZkZMvMCbb2aJbyaUYSow3wp19QkrVp2R4soU6ctEs7yXPos3BkNyTYXx
	 T/hpXL8Dss70aT8r75KEucsYDQ3jZ3xfrVxisteu3eWXeJDsVdNdtAib2f+Rfa7unovQj
	 go2pOUl3lcAp2yHNJG6pCVu75dNRPGKx2T2shqYzKRHgX+TEubD7UCqBqWnDmWP3LV5EJ
	 sl4DFN1rXZq0xWSh35qPMl9IikvhyLk9cxvnNwWTS13UPTQEyjv1w/hffy/Z1vttqrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794222376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=d8vRIIYl392fLQltvVGdYCiU5psYi3L4CF/tseUFWuI=;
	b=c6WszuqKQW4ig7lWypO/81jiUAi6AuZqa/XfrDSwn1K4Hfn3d73zOqlB0TbDmxZJ/ukm
	 JyYeqw9gsXBvXEorba63JEMU3it8yrdFgnfn3E5Yqpg8jzVDTu02Gi6my+TqgOhCXQ+VD
	 z4jNSufQsJVLeJ1o/mXViJFffwZw0JItyKXrIsZzImuah3rzrGp4qfNGDsX01AOIzXiKs
	 kVfRWUr4OwY/bWgJJtjZdfkodREkRiRITljKbNELUALizZQ7nc3kr7uZM/6kcW9rs4H4c
	 Nzrgx4nOhnhQsPfjd+EWIaoED9jhG8NSZ7NOaaFtebNteEcoPGO8Drmc7axUnsw47gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LFhukCQU;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B7B606A333
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 11:06:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76B7B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LFhukCQU
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4b6266b5bc4so22865e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 03:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794222375; x=1794827175; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d8vRIIYl392fLQltvVGdYCiU5psYi3L4CF/tseUFWuI=;
        b=LFhukCQUomrlCiEY7J8HM+MWMGjlTYs6uGCCNa8fCYmmkaxb3AcxUk1a9pR6KuY8bD
         UZg2zNavVdnqn0J6EzY0Ld1WLKBAJa9CANpz/VsKA5wBEKM3UZa/rLUQ8OHXQMiW7W6n
         KcQ9q+6sum7QEC4uf+TRKQHGVgr09bqsetl8p04kZSf+DKphXbcM4Qd9CTB2fbO0lGWq
         n80P5zAts4k6aSPPtG35MW8Mof8m/Ue84MYLg/ei3dzUPweXUI8VTBBV7Ec2KSHmT2f+
         5BjH52HdFSFmneAoCNEdxp6dKxlDMOJ9sSrkXsyg2/tkJUN5sZb1SyIACjcKjm0qub+m
         op5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794222375; x=1794827175;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d8vRIIYl392fLQltvVGdYCiU5psYi3L4CF/tseUFWuI=;
        b=ybuQFkSyGImMdLauzYy+7BXgLFhNWzaZTZ11tW7F07tVJeVJuYhdtqsSQC4uAkM9UG
         j30Sc7NdISXpXG4Wq8hndKUoxhMaID1lBG+/M03+X3nkz1MyXaPt2Dte0gtuxZWkeFiX
         jpB+sSwLiNl74m9Hq/4db4gEHehQ6b+/K/sguvRoiuvqZIG4PxjV8XviGeD8htOjTCKd
         UOHvqag0V8zwJhi+IXNyWH57c1Au2IH1fZ/pLM+aKWcySDaFBgzzVJh883PvqXSYlprl
         h9d5Mr0+Mu6+WyGAoPJxEXRa0F1rHK6Xd2Xkle7MuIsrjPyU22SJVmrQrvHnke1vI5Vz
         9wXQ==
X-Forwarded-Encrypted: i=1; AL+hErGTL9wCkyPefNDL99mkONX+y7IDwEl7OVmnwnPLt5+tBbAJr1v+q0E2pLb9G1cuZm71CGGRZag=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Mg7FLv10a5QDpRS84RgtEaWyE0TbntSheIhtW/LXaDIFZXFxa
	tEAZfN1YV/MMo65VSRYlK3rISUs0Kvk82OVzmU5voxJNctmCXWEszsXqtW7/RRusFA==
X-Gm-Gg: AYBFou032JzJDhqgw+jREeG14T7DooYHWBW7z78CBIWesG7pnENJpZQtW6+8Z3CWPOi
	IXSP0fdXykTzl/RWdUZ+RilLfCjUeUcyisp9ULPJLUzP5xKbnH7v7SGbJxtv2m3L1dLyKRHfG2c
	sOXg+lcB6xE3zZr9srBb0VERMRikPS/TohPhBOFxOTaX7UTufWefL0tw3Q1z7bHwQpLTv6603Lo
	y/jO4JkddiL5cWfV69y/FfPfbau51GMPoK3PTPKCQbpgHi8pGKJrKxGIeqYRGXoyvtWqIheKpUL
	YbapxZOJEzPBtydWrwvMiuiziG8ardYXa+7yiKoy61tLdwytPpKgR99j08tcRFc9ulXfOKyDb5S
	MVi+YpbR3c60M5PEpTbw83KNp6NsnXSHAKI62J/r1qG71TH9xDBAsyLw+l6z2B+Xt6eHzSj8MK8
	Sv63Y55ynpFXS8OZUmoSTENVdsw0N2qsmH9ARMnYafv1HDbTTktzogaYBVi9YeBrV+xQjtU5lFm
	mXc293myE0Q7lty4QAjqkKLxB9w9DjVSXuuOFXQitxZU0ZeeKUgdwILQokfK5oMPOB3JHBKtrI8
	aWLeiChNfaTUSUcDurB3ElMT67uaFXpg9jdEjW0G/TH2FNeHJQma6HL+Hb+rq2EEXtZRhw==
X-Received: by 2002:a05:600d:640f:10b0:4a2:1912:6687 with SMTP id 5b1f17b1804b1-4b8aec1d290mr1382195e9.2.1794222374432;
        Mon, 09 Nov 2026 03:06:14 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-496c89d8630sm4422045f8f.15.2026.11.09.03.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:06:13 -0800 (PST)
Date: Mon, 9 Nov 2026 11:06:09 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 13/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
Message-ID: <avGpIXoiLzncL29t@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-14-smostafa@google.com>
 <au4w8nvPQ3xv7igC@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au4w8nvPQ3xv7igC@nvidia.com>

On Fri, Nov 06, 2026 at 11:56:34AM -0800, Nicolin Chen wrote:
> On Thu, Oct 15, 2026 at 08:08:44PM +0000, Mostafa Saleh wrote:
> > +static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
> > +{
> > +	struct hyp_arm_smmu_v3_device *smmu;
> > +	bool ret;
> > +
> > +	for_each_smmu(smmu) {
> > +		if (addr < smmu->mmio_addr || addr >= smmu->mmio_addr + smmu->mmio_size)
> > +			continue;
> > +		hyp_spin_lock(&smmu->lock);
> > +		ret = smmu_dabt_device(smmu, regs, esr, addr - smmu->mmio_addr);
> 
> Going through the followup patches, I found this smmu_dabt_device
> gets really too big. Perhaps it can be bisect to read and write at
> least? Something like:
> 
> static bool smmu_mmio_handler(smmu, regs, esr, off)
> {
>         /* decode ESR: len, rd, xzr; width check */
>         if (is_write)
>                 return smmu_mmio_write_handler(smmu, off, len, val);
>         val = smmu_mmio_read_handler(smmu, off, len);
>         if (!is_xzr)
>                 regs->regs[rd] = val;
>         return true;
> }

Yes, I was wondering about the size of the dabt handler also.
I will try this, but that will propably won't cut the size in half.

Thanks,
Mostafa

> 
> Nicolin
