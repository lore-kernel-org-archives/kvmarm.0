Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4D82EF657
	for <kvmarm@lists.linux.dev>; Tue, 12 Aug 2025 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755000661; cv=none; b=bTUCjPC5hbmzQZvMh+bbc227GQGewPR/E58uLwIfN7nOREv1ttH0sV7q/q6jWe57bOsXAs4XGgQfAR9udculJKL/j1bUk0iqUeERjrLbOnGj4NR1frrZV0EoedepsnPp/Y0RwYZOvPfEX1eE5pAGfjkpbxAvjtEzCjSAEH2282k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755000661; c=relaxed/simple;
	bh=8RBunKxUBb1Vj6PE5YuHmQTGXjBTAJn/u9sUy0q/u4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+zOcDqu7zLAdZN6WITfGL8nZe7UMwSiNyYHqsw66LXoWNgjThn24YR9Cj3BTkp3Tmu0NuCrcNUp291EzOBaV+e4JgjDVP25bJDqbkmzuseBp4CiI05Yu2kVIuRC6iRF2V7o6Egnv5R52nQdI6Xs7ZCbwXOu1HyUJdyybD3p5dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZzyuyHgZ; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZzyuyHgZ"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e278d8345aso524628485a.0
        for <kvmarm@lists.linux.dev>; Tue, 12 Aug 2025 05:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1755000658; x=1755605458; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zwzt5hp60I9xGcEL67DVrhF5ur9a/Ie7/jOy3595NAw=;
        b=ZzyuyHgZy/QzEAKxqtzvvjs2zpXR8A477DNL0BTVwUcTbltYxr2rryAr5k7+p5D7en
         t1LVjbTVwXzPZkkXzQkrb6mwVFjBpiQxmXz1N5mpoTCjM7B/AKs/ALDFZ82b9OFcBYfP
         sBPOX4K97PqRC6Wil+92Fdk+iNUHEp1vW2CePceKipfh7F9AEk3SMYRx3xbIfJs52QFu
         CmvBBBkAinq5Jtl/nO3eO3CEx/F3MYAn7h9DwE9YAT93k8oeOlNWwUxtYlVDnv4tqeX3
         OJjIAgWT5nPqC7VJEE34KoDqZS7/GuvcYLwawQPTks5B3WzEd/3vLjfm2MVaAAOj/c82
         hxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755000658; x=1755605458;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwzt5hp60I9xGcEL67DVrhF5ur9a/Ie7/jOy3595NAw=;
        b=k6d0JYGUIjW41Q4SbAzZS++dlWHmZNWd0MozmTxK0Y4c/lgErPNqpfCTu4dbkC4uZM
         2wH/AMQeO9aWZN7xM7QP7DRgey6KhCs3Xdlvukuk1Jkr7wYUTMEknVDPAHRfMoypx2AC
         xcF40r/3irMmmQNaf2Trcg1IBSMaxq1GZq9aRCeSvgGfJHka9auf2XPxyKY7I7hFBAZ5
         BZyZjYeDu0OOvPAux4G2oUHBjDb4rFW48/0f5IeC2Ajj3Y9DHR09CdcZTjpx6XHL9aA/
         5rkfV7lFgTft0anu7ZsHZC8+OXbrC7AfKxNxVGD5zEfNZKWAUQSEFmGDZu2SKQolQUx2
         y0eA==
X-Forwarded-Encrypted: i=1; AJvYcCWBxww8bmIwDS8Wt4d0L69OC1ev7uWzXl0plFdIvrKHSdSHm7si5DJ9ZblsdGCSr3G85ZWjAKI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDZsvpCNnxBiQLBDZ3R3tE0Kfg7sMwxU2n/uHrvsTFGV/Vhgk1
	bk54hCfy+MriEQFUI3ff13BIgiHlKWD0Btamu7ZR28mKuxyirdEyQVzOxXRXP4Q/MnI=
X-Gm-Gg: ASbGnctgDGbCpOUqwvyA2oJ+VNa0t7S4QYirPcxkTIpkLykSP3kGY9QsojSIXVMsMFg
	cFp8qiZgw9Lr0NO9nbTMiIT0jMLcj9V/gGgK80cpGtZa1BfQbxDn8kftbQk+XGnShl9s0VKmfbY
	YV3ZGIgv0NiyxgwE8VNyVMMX4zJVSDlWr6m6RiD4k1kRPolsQrOA8nW1RPnDGq+g2zZe/UqqSrL
	OFX4UXuB6fShhrVcHUYVrCYq0MjKgchHnnMglOEw4TlgltcNuYhP6OImLXgHXNg3tKavHSM2iLn
	/Nv+ZBGmOrAIvkcjoyzaXxKzTNs1vvpP/hFvXynmck/KdobVzybFYU/cdG3qkQNsGtu7HRsUFej
	kGAkC9Y0egs1uv97z2RbN/PvF4ftYHAQkRzOvbd62b/g2iK2gCAPhGdXeRFbOa0bpdVDJ
X-Google-Smtp-Source: AGHT+IHpaffqwwD2Z9E3cXc4Gk+qNtr0gNf1UVekaIiTZnryNrm4aWl3gQcM0mkfqjTsmCyn653LSw==
X-Received: by 2002:a05:620a:831b:b0:7e3:4740:3d3a with SMTP id af79cd13be357-7e8588d7a35mr401586685a.55.1755000658513;
        Tue, 12 Aug 2025 05:10:58 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f72f75asm1760951185a.59.2025.08.12.05.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 05:10:57 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ulnqC-00000002c1d-3Hty;
	Tue, 12 Aug 2025 09:10:56 -0300
Date: Tue, 12 Aug 2025 09:10:56 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <20250812121056.GB599331@ziepe.ca>
References: <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
 <aJDGm02ihZyrBalY@google.com>
 <20250805175753.GY26511@ziepe.ca>
 <aJNiW48DdXIAFz8r@google.com>
 <20250811185523.GG377696@ziepe.ca>
 <aJsXkidmcSl3jUJP@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aJsXkidmcSl3jUJP@google.com>

On Tue, Aug 12, 2025 at 10:29:38AM +0000, Mostafa Saleh wrote:
> On Mon, Aug 11, 2025 at 03:55:23PM -0300, Jason Gunthorpe wrote:
> > On Wed, Aug 06, 2025 at 02:10:35PM +0000, Mostafa Saleh wrote:
> > > I am not sure I understand, the SMMU driver will register its IOMMU
> > > ops to probe the devices
> > 
> > You couldn't do this. But why do you need the iommu subsystem to help
> > you do probing for the pKVM driver? Today SMMU starts all devices in
> > ABORT mode except for some it scans manually from the fw tables.
> > 
> > They switch to identity when the iommu subsystem attaches devices, you
> > can continue to do that by having the paravirt driver tell pkvm when
> > it attaches.
> > 
> > What is wrong with this approach?
> > 
> 
> My confusion is that in this proposal we have 2 drivers:
> - arm-smmu-v3-kvm: Register arm_smmu_ops? binds to the SMMUs

No, I don't mean two iommu subsystem drivers. You have only the
pkvm-iommu driver. Whatever you bind to the arm-smmu does not register
with the iommu subsystem.

> I am almost done with v4, which relies on a single driver, I don’t think
> it’s that complicated, it adds a few impl_ops + some few re-works.
> 
> I think that is much simpler than having 3 drivers.
> Also better for the current SMMUv3 driver maintainability to have the KVM driver
> as mode, where all the KVM logic is implemented in a new file which relies on few
> ops, similar to “tegra241-cmdqv.c”

I don't understand how you can do this, it is fundamentally not an
iommu subsystem driver if pkvm is in control of the HW.

And I still strongly do not want to see a para virt iommu driver hidden
inside the smmu driver. It should be its own thing.

The tegra ops were for customizing the iommu subsystem behavior of the
arm iommu driver, not to turn it into a wrapper for a different
paravirt driver!!

Jason
