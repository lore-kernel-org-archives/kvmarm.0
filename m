Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8D234167B
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598074; cv=none; b=VO5h0+1R85ohPv5qJVqfCEt6R4N5N+53bhofHs6HQfojBsbJNICMv5J7zO8vIzp8FN9q0MPV82Uog7VDEVWS/QaVUqof8BeZuaJFsDpgp7V6GEmofyl1JkzRwYBIlfy4XnpudOUtdaXhmESOXY/lxzCjeg5g2s9uxprYPhZi60Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598074; c=relaxed/simple;
	bh=eLNCihb73AkP7eUzkZCYHE7Hj0pppLXFYhZ9Vl1IUQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUAk5+EzVHTG2EFFAK7TRV4AUrSDJZXWGkfJcvgVTu0VZhzMawYg74yLX6XPrpAcLWK2Qa3r1JQPi7S9x6bXwCHm460+qsd30pQ2V+BN9eBWTMUdnuPrLnwm31X74u9pDlqmmw1wv+JaBWmCpqYvXZUGrTxmkatF5rmQ6aBPfO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=JCDdv0I2; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="JCDdv0I2"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b6004da52bso6718501cf.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 06:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1757598070; x=1758202870; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b9qmtOM7dk27TAU4OyKZ0knJ4KFcYKzonTZZzmEGOvc=;
        b=JCDdv0I29Iygfi7PL5imBoxf3fWb8PUtoMirN1KWCE0vzOPVpZUPPX/B9eoJO+uDhz
         MAtBnrw2N8InidBB075/2wc9k8rwVpGtig6d538Nig8dlkaGVD8AUDpDKcF+oIz2CwVt
         SJPX3t4vUWzQSI22n4JwSAwzsRWYAcfekUrnMYoRpAYHIvELJ+CExY1qzgLu0vi4VIW0
         i77q62oGyMSRHyFVXs6vVUkGDs2ht04xcjh1GWTroGyFM7OyhRYkTnueMd2AmasjaPt7
         uVDctyI+1uhw6r6w2CZiOwVnpSSxQaC/onEOr/dDd2N9EE6AoOAPEmqyuOSDYA3eslu0
         efWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757598070; x=1758202870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9qmtOM7dk27TAU4OyKZ0knJ4KFcYKzonTZZzmEGOvc=;
        b=X9+Ey5mSlfk9kI6Zs8ACSE4rl7b1T1ExiJ1oskzQZ8peSOT0b7F3M2tdm6HrAG9EOo
         wDgjyxzzjVHJFbfnb4vQ0auVdX5F5R6knqcGEdKimb36EfT+4Rspi41bYnaSXyZqTOS4
         +bvhXPxevsXqWLL2Sq61R3l2tG/jX34qRAbXb5RkTYRn6LGESPbow9nnPj7CpUSTa+Mu
         Gu/rFkzPcmRvpDFPV0td6gKHsAxj3BZh54C7Qi8YXBZv7Ux95q+/rr/zGxS+n47PG6UY
         QEVdPAJmn7hJ8KDi6wHBWa9JP1wAQ/MpibZ0mXq4Vv2aVtNQVr064HulVUvPBI6VyelX
         npRw==
X-Forwarded-Encrypted: i=1; AJvYcCUyrAReMkxTAAcDFylnNqSFpA56E3dqVZuytsPCOl+aHShWZ47zXz53/xwg5SsWlM9B9DHOBqw=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywv1xYRgw6EOcjeYoJj5/B7VSBV4BgTLyoBiparcwU1oJ4Fsv0J
	42kK5k5FNJrAgY0YyevC06l3EcrQ5wHcF7XPCOQ8ZHHhQqIyDHb7R7NiREX3me8WFaI=
X-Gm-Gg: ASbGncsqPWRUFD4Wdpo3knArQwnAeRRyPMO2hL+5FCreG6wrzi+c36QIOrMIJ/mtQzo
	iAlLaccdzAZYlVA6YJI0BkwC49vFDydM19xdQHmuQny+4gi//jTevwEqpOQ0tC55uTVHJHRj8iW
	T9fY70lHX6trDThYK8rPpAhBo7QngCBmRJ0T9yLfA3z01KhKOfp3JEqVGOVaf6zSss4NG5goqTy
	Lc2lbxS0P0mM+O13txj7ACVge4cSRFPY4OSAhJXXnBL80amlYAhZMZG8sz05vA4J9qHdbnaq4sH
	NwwxVbLhvaC+6rKeF42uJdQ0fSX70tu+7IP5ecD0pmzwb2plYjSpAwYZGEDJbJiZ6KJJgVU25qo
	kmz2pzXXKVe7uu8XEU7c0/CAmou1pHVp6fuOyI5ehbNOq04/9hgAtBdfT+ksm2x+f/YBJaH9Xmx
	68f7M=
X-Google-Smtp-Source: AGHT+IG5BULuh1Ix3dTKx0dMR7o7+0XiARxVmRkjj0WGgmMyJMRjiHF7nh7Zr7cWchr7UEHaWH/u8g==
X-Received: by 2002:a05:622a:1214:b0:4b5:d932:15c6 with SMTP id d75a77b69052e-4b5f847fd1emr220313931cf.34.1757598070182;
        Thu, 11 Sep 2025 06:41:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm102730285a.37.2025.09.11.06.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 06:41:08 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uwhXv-00000003zwM-3lhP;
	Thu, 11 Sep 2025 10:41:07 -0300
Date: Thu, 11 Sep 2025 10:41:07 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arto Merilainen <amerilainen@nvidia.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, aik@amd.com, lukas@wunner.de,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH v1 34/38] coco: guest: arm64: Validate mmio range
 found in the interface report
Message-ID: <20250911134107.GG882933@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-35-aneesh.kumar@kernel.org>
 <d57d12ce-78c6-4381-80eb-03e9e94f9903@nvidia.com>
 <c3291a06-1154-4c89-a77b-73e2a3ef61ee@nvidia.com>
 <yq5ay0ql364h.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ay0ql364h.fsf@kernel.org>

On Thu, Sep 11, 2025 at 11:03:50AM +0530, Aneesh Kumar K.V wrote:

> But we need to validate the interface report before accepting the device,
> and the device driver is only loaded after the device has been accepted.

+1

This must work from the generic OS code.

So I'd say add a new TSM op:
 int validate_pci_bar_range(struct pci_dev *pdev,
                            unsigned int bar_index, u64 tdisp_pa,
			    u64 size,phys_addr_t *bar_offset_out);

TSM has broadly two options to compute bar_offset_out:

1) Require the TDISP MMIO Offset is aligned to the BAR size and use
   something like:

    *bar_offset_out = (tdisp_pa) % pci_resource_len(pdev, bar_index);
    ipa = pci_resource_start(pdev, bar_index) + *bar_offset_out;
    if (size + *bar_offset_out > pci_resource_len(pdev, bar_index))
        return -EINVAL;
    tsm_call_to_validate(pdev, ipa, pa, size)

2) Require the TSM to convert the offest'd PA to the IPA:

    tsm_call_to_convert(pdev, pa, size, &ipa);

    if (ipa < pci_resource_start(pdev, bar_index) ||
        ipa >= pci_resource_end(pdev, bar_index) ||
        (ipa + size) > pci_resource_end(pdev, bar_index))
	return -EINVAL;

    *bar_offset_out = ipa -  pci_resource_start(pdev, bar_index);

Then the generic code builds a map of what parts of the BAR are secure
and what are not.

If it can't do either the TSM is unusable by Linux.

Jason
