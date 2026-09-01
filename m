Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9C835C6B5
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273146; cv=none; b=aG37VZ+YSKY52qVS+wNV48n/QD7l9bt0jVnDzA3b4Y/0DbgR10g06z+zKUUroXe6ZeFkKZLMPOLRWcGoy8THRVfe97FPhDQpOBcJ6waLQ1Rhv/0rhyPVhfyvEPH4PzHLpmAbZ45YxXOPZdH5kCgMuJu6F18882J/uIIyJWuLLiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273146; c=relaxed/simple;
	bh=Epea1SJtx0b5eyI7MQ/aNcrxf6TZYklQq7AcTHGfVa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pMuSLoFO9r3urEm5sAqQQyidT9uEkx1JXByaPXm0Udt4u3lY6aUzzs0YBR4Qx1WnXgbE0EZfgOeuuHjh4nwcDWHjCFo5UDtugSzrJJUMmUgSC3u8/cIVl7uRmGBnpukCH+n1V53mZd8n07KUPxqmiXo3vghxBh0Ea8631b0ReV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WxVM2Stv; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WxVM2Stv"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-52fa9c055b5so13991431cf.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 07:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788273144; x=1788877944; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BSVwyibyFfIHGL0TlXMcUmW3kV25Hg4l49RcXdnb+4E=;
        b=WxVM2Stvn6ZUEd4m/DPoefoshdc7YoKMy5nFjlThoaCyTqi0FEm2qwLEfJX8LzVdNA
         9wKSVbhS5emVz0PmVNJKYLOQEs+EbttzYEYMwuDnwQYokWTiItmexbhM/GSJeWF/JLJU
         MFcIyI3j5tC30a/73o3loVAW75Ofm77pZ9s8LVMx3npaQYP1BGoIfUnE5AcYxnYtaVoO
         6Zu8GUGBJqQ2Md1oXdg3q24AqvOViZhm8WkbSE8lNhmIzu8sZYOFGpcVdrnJ0NpNynV8
         GIvdBTIS6KqLpHNOFipd9DPiXSGRS7+TVSUJaZ/OtfgtBneLuSB1BEwikSGicSFLg2Vt
         /dVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788273144; x=1788877944;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BSVwyibyFfIHGL0TlXMcUmW3kV25Hg4l49RcXdnb+4E=;
        b=aAC2NhOjcNpLua/gWtUkv9IpmXVKNk5YCvasFqSATx/A3HNS09FYKhfusuZi1LuHdD
         RWmh7XVB0ibpiYkHX+ru1VtH51yQG59b5zXOXqwffsDTtbiGrgioJXsDvHLWoWoFZRTS
         brJb2p25F41RNLjGpf7HpDNaTHc8qKDXJlv4NyjRNPOU40CnL0cdDrA61s1swidfDPvR
         SQQCqZLHL01X1TUT1GPFxK8k4nHvkr7Kz48nWWF/vlRUK+IAe69vKsinkx3XiwO/p9XW
         Bb8s0hjkwCuzt5jTeqk0L3+9IESuH8XPw49gXP14BXS1PZP2pt7PSs8KB/DaXe91ZmC5
         HOlA==
X-Forwarded-Encrypted: i=1; AHgh+RoqJarle2Au6Fuh8J6o1sZUDN3mio4k2NxF7z0MWn4lDSmy4XxNkrNzXUnJMIZ4nmODmfO7rC8=@lists.linux.dev
X-Gm-Message-State: AFuF++l9DicciUe44fZ6h7fCgXZfyxv7y7njM0yCZas54DoUfKZq114f
	duWer/rvj5OUQnTorxH2l5nRHxLdUPwDWTyxMV3+pvzf7+A2we96nWwjwjSlPWb1Yyo=
X-Gm-Gg: AR+sD13KXlGbzPe5XoN1rW8/+E5faMD3qQkXXVrlfe1VQz1SG7IqnrUSiCS7ZVtNVK2
	DNnZWHfGAtqqcZV/BX63LqQuqf3Y4PKZ6Zi7FBJF0F3Xg/i6bR81fDMzNwowdp04ADTs87Co2Ms
	QXSZXTgSxuohAvAOG1wQPKyLaZ8p+28hNj6eqWdNc3s+uOeLe/8V4JoWxCItxktYyd+J128KM0k
	AMeMVd8cHvGWeFfosgUC8yJ8exmaZuC3lkRckf+IA8DlkX9K+Jt7KLsOPDZXGYSD/LaxJsrSZGN
	8a21X/lo+mZn5b/4+tudSVzPPDkKbY1BHqtI1BKOhbAppJj+lFnk8aplrGCep19JeXtfvnuJivW
	9/pTKwd+KLlaXk+DeeiJ0XaqtVmO+YvwwLBjTDmv4OdD4cSslUd9SiwT7gDcVoCEVJVq6aeuR1d
	mTQbwhgvpWIioPILwMcN8e2L5CCIUEPSWPFZM5wTINqI2XUgbTOqf1jhuDG6oV/Kq9HRxxnNN9L
	KUr5pM8jtueUY+6zckq0koL9mRdpfw3WprzE2PznydKdeNG2jWm1jVH
X-Received: by 2002:a05:622a:948:20b0:530:2ded:eb32 with SMTP id d75a77b69052e-5302dedececmr22533091cf.2.1788273142344;
        Tue, 01 Sep 2026 07:32:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe7fbe06sm96855001cf.17.2026.09.01.07.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:32:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1PXA-0000000BhaA-3wav;
	Tue, 01 Sep 2026 11:32:20 -0300
Date: Tue, 1 Sep 2026 11:32:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 01/16] iommu/arm-smmu-v3: Discover RME support and
 realm IRQ topology
Message-ID: <20260901143220.GB56830@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-2-aneesh.kumar@kernel.org>
 <apMjUSbxcnlAKjks@nvidia.com>
 <yq5aik4pnyul.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aik4pnyul.fsf@kernel.org>

On Tue, Sep 01, 2026 at 02:16:10PM +0530, Aneesh Kumar K.V wrote:
> +static struct irq_domain *arm_smmu_get_wired_irq_domain(struct arm_smmu_device *smmu)
> +{
> +	int irqs[] = {
> +		smmu->combined_irq,
> +		smmu->evtq.q.irq,
> +		smmu->gerr_irq,
> +		smmu->priq.q.irq,
> +	};
> +	struct irq_domain *domain = NULL;
> +	struct irq_data *irq_data;
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(irqs); i++) {
> +		if (irqs[i] <= 0)
> +			continue;
> +
> +		irq_data = irq_get_irq_data(irqs[i]);
> +		if (!irq_data || !irq_data->domain)
> +			return ERR_PTR(-EINVAL);
> +
> +		if (domain && domain != irq_data->domain)
> +			return ERR_PTR(-EINVAL);
> +
> +		domain = irq_data->domain;
> +	}
> +
> +	return domain ?: ERR_PTR(-ENXIO);

I'm not excited to see code like this in a driver. Please put a helper
function someplace else to translate whatever the RMM value is into a
normal linux irq number?

But this feels wrong to me, interrupts need to come through the FW
side, ACPI or DT. Having RMM pass the value outside that
infrastructure is going to be painful. None of this is trusted, why is
it working like this vs just adding more interrupt lines to the FW
description?

A naked integer is not enough to describe an interrupt in the system,
and guessing that it is connected to other interrupts in the psmmu
seems like an uncomfortable leap to me.

Jason
