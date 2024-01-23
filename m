Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D720823AE
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 19:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706039125; cv=none; b=nafFRwj/YkvVTfMZnTY8Q5A/eNZge7HzVRS6nLq1hcRn7NjmNj+F6o5zZ+7RWSVKL75joEv13m5z8u1ARaTxwSoDqN90xo79sePlMyYgbBw00cjn5iJ8XJRpMn6gaBnlN1IRKpbp6Lxac4527hd1UjqG6ORVdzBUab5ingxpZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706039125; c=relaxed/simple;
	bh=eNJqhlR1mz1XoQIjA0PMEXMtohRUtBsqnl5wrTcpQE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1jp5rLsS2qvhjiCdn0rmZkch4dBkdEeHPQ27hVITT/lW26WPRXZuMMunO5A8qwUBgPWljusuHewf8t56TDzDEySi32rA4UTAvBwPDHyPpXtjeI0AGnyKO+fq9Fo/9ycqMDKeRC6cGWyhdFb/r+njq+qVb6W4pBU+cy6yaYdPb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F7vIajqc; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F7vIajqc"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3392d417a9fso1886843f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 11:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706039122; x=1706643922; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i7dwQrVQjuGrZ7V6sgd9fGyyi43Z5qftzJ/GAk7ai4s=;
        b=F7vIajqc7lhWGaBMq+UOyAW+U+uW+GjFzcHaC/bWBAsWdVr/27wVOOlqKUIsK3TRWq
         41Dlv8Gh/bLQz2jRi7cKKMWDqLd2lQhFU78Eogput0DtY3MYJPnfDduaNOsUmn23chXP
         CI515f1mDz1eZ/5winor9qTl2YmvImtsfDq0XB7p2kqnzDXk0AmLH5kwR6wD0pz3QXke
         KCw3MOxQMU0kknZEyjr01QjdSOYnBbwGXHRve+Fe77O2HUEtsp+sSYxTh995nWxf8ezd
         ENpi2CA6aSB4OOivJS/xel7RVfCOsA20SbGnVkRlh4VU3PsSAFlYlSFgTGVneWp7mQZR
         DvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706039122; x=1706643922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7dwQrVQjuGrZ7V6sgd9fGyyi43Z5qftzJ/GAk7ai4s=;
        b=Z4BdydWoTTYvW3rD1RFtp+1DFOlQX2hYmiIwx0hTsTUOAjBHrm4Ej1l7C1Wq8nizBT
         dFj+i5PrtAwqBIUphiY2XqsyZKzobDLYwuM3P+4ZbLMYIOwesDticumN+teT4PtUCh/M
         J39zv7R0QeE6JKtWJJiuB0gFiEe/1GLGpf2knILulDTO7PhugoPkm/iVbkqFWzsRi8nf
         55diLtu2Z5SecIwE54/XHhCwKy4Lr/dYalHb9h5BvzABZypVURAP+cqOEtjDab21sHQf
         t0ZJL4wub5BnhlBJP45GkB87td1fvGDZ4O9vTwCfTG2Yn6ocYQ5wIfpAq7v/2AVRfVkx
         2Lyw==
X-Gm-Message-State: AOJu0YxQf/HiYDvdNTib4SLB/iCRYmelgw4QZmV762XDLBFQ/iOl6QE5
	TtW8MF25funzGBgJ02QPP0ApkEaTUCPGXaGlsKsuhDhgJhCGgYZ5tNOTq6SVuEI=
X-Google-Smtp-Source: AGHT+IHSC3czTD9DuPppBHvZE6fNTJXWMdah36NgM0rGQW3ZtaCxIuIBOl7kJLUASIBgn4YRMx4xaw==
X-Received: by 2002:adf:f2c5:0:b0:337:c4ea:3023 with SMTP id d5-20020adff2c5000000b00337c4ea3023mr3144642wrp.38.1706039121651;
        Tue, 23 Jan 2024 11:45:21 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id b1-20020a5d4b81000000b0033920dfd287sm11958305wrt.19.2024.01.23.11.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 11:45:21 -0800 (PST)
Date: Tue, 23 Jan 2024 19:45:30 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 24/45] KVM: arm64: smmu-v3: Setup stream table
Message-ID: <20240123194530.GA40099@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-25-jean-philippe@linaro.org>
 <CAFgf54qcTAru0Nvy1wH_tJMadOSW7Y3zEip5RTm+mtSa54Bymg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgf54qcTAru0Nvy1wH_tJMadOSW7Y3zEip5RTm+mtSa54Bymg@mail.gmail.com>

Hi Mostafa,

On Tue, Jan 16, 2024 at 08:59:41AM +0000, Mostafa Saleh wrote:
> > +__maybe_unused
> > +static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
> > +{
> > +       struct arm_smmu_cmdq_ent cmd = {
> > +               .opcode = CMDQ_OP_CFGI_STE,
> > +               .cfgi.sid = sid,
> > +               .cfgi.leaf = true,
> > +       };
> > +
> > +       return smmu_send_cmd(smmu, &cmd);
> > +}
> > +
> I see the page tables are properly configured for ARM_SMMU_FEAT_COHERENCY but no
> handling for the STE or CMDQ, I believe here we should have something as:
> if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
>         kvm_flush_dcache_to_poc(step, STRTAB_STE_DWORDS << 3);
> 
> Similarly in "smmu_add_cmd" for the command queue. Or use NC mapping
> (which doesn't exist
> upstream as far as I can see)

Right, the host driver seems to do this. If I'm following correctly we end
up with dma_direct_alloc() calling pgprot_dmacoherent() and get
MT_NORMAL_NC, when the SMMU is declared non-coherent in DT/IORT.

So we'd get mismatched attributes if hyp is then mapping these structures
cacheable, but I don't remember how that works exactly. Might be fine
since host donates the pages to hyp and we'd have a cache flush in
between. I'll have to read up on that.

Regardless, mapping NC seems cleaner, more readable. I'll see if I can add
that attribute to kvm_pgtable_hyp_map().

Thanks,
Jean
