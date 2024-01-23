Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438C68003E
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706039447; cv=none; b=VngivZJsqF9Z+SwOPzuF11yMAqmX9oijLAzdmpbJqCz5tvw7NbuGBTl0NHQS5dJt7bMxP5jZIFE0rc7jHOefmC9pQdGg2GMZ9KygE0JKP5BvJMCfamjEY+xpSPf7QmQm6StSFXExUgjlUzkAaadvyDinpewKKHlr1mRHd2o6XNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706039447; c=relaxed/simple;
	bh=8dtODH7c4Z7+dVuF8YPbrq74mw76xQEbD5vF9cYfMUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdTDqn+0hn/kVFaQz/6H8a50IVcxB8niARGhubrOdGMynqNW2H9Ay67wskMv2KKb9dlxSf1CSV75WsrNG/W37gijX1LNAz5xf1MDk3kWWPneS4IsHKKtSvcuBn47z948taZ/QcKBIRoVdlKZ5CwNevtPKvbA6iqTsj8t9o18eog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zGCq6NGQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zGCq6NGQ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-337cc8e72f5so4321161f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 11:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706039444; x=1706644244; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=symCKlu70t5c2pz5MpkVzEsXKmD/I2ycs0+d/rCZY9k=;
        b=zGCq6NGQ5eYAw2g1gZV+iizw2L90t67OPZ4jKWPJQ6wOKaWevUkexjp3yQpqGIy/bN
         3+QTLyTgLsr0K/DsESefl5cT8ZnEL83GazlqdqW2U9zMUPMW8YFEXHpFhQ4oOvimtd6x
         TVmTglGXnw6Y2/BUVRG1g5FMRqTXpm9xjFWtOddQ8uRGNPlxFxTAsR+aS6vE3XXNFetM
         PMuwXa7vY8H654+DyrLt4SkqhjmssxgLusoOzELsG2sqyGLXTMmiIQC/nIjf3iiwyCMR
         b9TV5EG+3IDw6YVeqo8iLBW82frNrEfQlZalZNINQaaQzc3BUXJbL4wMOkoQwy+okjnW
         7neQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706039444; x=1706644244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=symCKlu70t5c2pz5MpkVzEsXKmD/I2ycs0+d/rCZY9k=;
        b=FtwcrcOHZBXJuGs1taPdf6ujAzqN29u8O/IcvX/OfYQia7LR9B1hZSaNlYmAgYWdFd
         Hdt8kJ8sHIa8EJCmcjgXxlaWDYtnkDETxA/xXC6fT92jBFSXB1c1onTnUh9wtYdqZd+u
         TcLKokwtyNyzm+lRzfFZ2PpN49TTHkY3rCjJ59MLbnA3KKB5tcNAdP4b0+TH0ZDIO47o
         +YmS0y3PjOR3KxBKvCm78qotaxOQUska+yu8msu9EpqfTzAzSOF/UwsdsChOaYwAmBh5
         4KrYeijYrJ6xLUYiiZwDhcblcVZdysX2qFHuYu0zgrBz/PV3+nOqjYoyqIcihSvNsrH7
         0TSw==
X-Gm-Message-State: AOJu0Yw68UvVwiQ8FSzVI9AuvNeV3egcqe6u2nELF0a1I+hHl9iWZkdR
	ZcMar4qDiBsRH8Mco/8JEJJDXCKJBJhkBtv6ag3io1ZTOQcWxqtEsJhT9RjwjoU=
X-Google-Smtp-Source: AGHT+IGvK2nRgJqfqxTiFf7eYxXF/FLO4QS4slRNBAch0gl6IUsYo+a3YBQ4+CQ61hhuq9QUr9aw8Q==
X-Received: by 2002:a5d:628c:0:b0:339:3f40:ffcd with SMTP id k12-20020a5d628c000000b003393f40ffcdmr1573778wru.129.1706039444344;
        Tue, 23 Jan 2024 11:50:44 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id x8-20020a5d54c8000000b00337d3465997sm14205211wrv.38.2024.01.23.11.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 11:50:44 -0800 (PST)
Date: Tue, 23 Jan 2024 19:50:53 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, Daniel Mentz <danielmentz@google.com>
Subject: Re: [RFC PATCH 27/45] KVM: arm64: smmu-v3: Setup domains and page
 table configuration
Message-ID: <20240123195053.GC40099@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-28-jean-philippe@linaro.org>
 <CAFgf54pysSxKHcJVP6=dWPxmS3qi=eEMNQMF7SPiaiaeA-Kc_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgf54pysSxKHcJVP6=dWPxmS3qi=eEMNQMF7SPiaiaeA-Kc_g@mail.gmail.com>

On Mon, Jan 15, 2024 at 02:34:12PM +0000, Mostafa Saleh wrote:
> > +static void smmu_tlb_inv_range(struct kvm_iommu_tlb_cookie *data,
> > +                              unsigned long iova, size_t size, size_t granule,
> > +                              bool leaf)
> > +{
> > +       struct hyp_arm_smmu_v3_device *smmu = to_smmu(data->iommu);
> > +       unsigned long end = iova + size;
> > +       struct arm_smmu_cmdq_ent cmd = {
> > +               .opcode = CMDQ_OP_TLBI_S2_IPA,
> > +               .tlbi.vmid = data->domain_id,
> > +               .tlbi.leaf = leaf,
> > +       };
> > +
> > +       /*
> > +        * There are no mappings at high addresses since we don't use TTB1, so
> > +        * no overflow possible.
> > +        */
> > +       BUG_ON(end < iova);
> > +
> > +       while (iova < end) {
> > +               cmd.tlbi.addr = iova;
> > +               WARN_ON(smmu_send_cmd(smmu, &cmd));
> 
> This would issue a sync command between each range, which is not needed,
> maybe we can build the command first and then issue the sync, similar
> to what the upstream driver does, what do you think?

Yes, moving the sync out of the loop would be better. To keep things
simple I'd just replace this with smmu_add_cmd() and add a smmu_sync_cmd()
at the end, but maybe some implementations won't consume the TLBI itself
fast enough, and we need to build a command list in software. Do you think
smmu_add_cmd() is sufficient here?

Thanks,
Jean

