Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4862E2DF0
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754938532; cv=none; b=bJ3pKhss0xUKiV/NBLLSinJX8UpMTvsHRf3Eonttbm/7nFfI2UQkt1YgRAZdBiPASKXvaca3z7D+AbVM9xIwIjbAdUj+Vg+4/oMviZLSbaRfSMkLdaV763qL/4kjcUlzDSWojb3uDaspSBzzHbEkRJFsW+2sf9pYuHYTGmJYK6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754938532; c=relaxed/simple;
	bh=uQ3fr3pfhXh7AS8ejvnx1d8aiWIIkDyvsDnvhr3mk9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jaAWznyIKzQ3PlTA2DVnD8HE8bOWrXEt10HTIU7h/GKI/Ff7gownVqcBE678PihKpIanvdXrlaNyemxvtQiyIWD19jCF457WEUr00q6/JgsQ4haYcHkkZ2kdlII83r5tqA3zbuMnUXWWBHLQoAP7fS4SiKTLYsJIhezMBVUg0sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Px6taPWf; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Px6taPWf"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b07d777d5bso54092501cf.2
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 11:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754938530; x=1755543330; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+1xezh5zigs0Eh1IHXpsvZxf5v0NNa8iAaWLGnBO56k=;
        b=Px6taPWfPiWBv0s92/igrjHD1EaFna9DB4IEAFMcI1/733WaeER1PuOr2AgzP9tosM
         ytrbg9xm7QJwEM5a0ymzAVBSvScpD9NRgnp7NXfWSHB06mW7O8lNkKSHvIRy8kdS9XJH
         EmJ7zFn0jY44SEm7m4+uboLc7SH2JTtVyFgUQGRzsmSYpwxm+KKn4Y/2RlipHBQBwdw7
         ZsM4dNAOTGn37fj0xqXFvNQQrX4ceZL97z3mQQEyXAAyAQIc/Bjwnfkv+U3TED33i/+2
         z6spfvOq9X3jYDxTT/JraiZwqbtaSnsz39KXexBa5ATw5zSNc7N0Sf8JPth9yjGp2dJo
         0OhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754938530; x=1755543330;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+1xezh5zigs0Eh1IHXpsvZxf5v0NNa8iAaWLGnBO56k=;
        b=BrhyCzHqRFBz7EHZ8g7h2ZsaHX/cwZ/UHZ7sDJvlMx+w/YzzD2KYU3uyt53VX7z1mo
         xZvs+ozUzb1TRJwhXEUjE9ML/Apb17pCdhiYEtSa5Ze+NBoBjq/jylXetsd2Bsv+agbZ
         Gt06nuBpcb/lqXhi1s81yJEQr5vI4g0VGDnRtxFI0BGJ3XdQNNfTdIwq0LACTs7iYEzo
         G5vHD6hrFCewSsehQf2bDjSb9wshn+8KT3bjw1aUESMZAO/8ETrlORjWcTDUXPu8LQRW
         iTVBAtoM+pMOYPsMyllFaorfw3bSSYds2h5IpIdpTR557+RgZ32yu768ruVoBjch/5x7
         PMCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCQ9k3op5xPHWnfqAW4bWWM1y+iXFXOovFy2QPNMq0hhznX3KXNu1sn85bO8Sp5fPE3POVb7Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXCPpfR8Xq1oNEnYP3rMtmD1O1rhRjhL4kyG3mdOJStqMaRqLf
	vbhhXHHp4JCnPhpfiLhFE1p6WK8U3550Np0Q9SyR4FgPuyGm45EOYJ+Gf4q8Tk1DHzM=
X-Gm-Gg: ASbGncuNF9aFrdyogL53xDWHs1Hc0Fh81raKAn6ENL5NQ3TT9j3kzP4vy67Rc7XpIJt
	qykSjbEixwAWiqR4A9Yk/ICs/70rSYFjXAvWURvMvt3cCHok0dkWPcZah1KUxUzWXXhX9C1K19V
	l+5xVjHidgvPn65fFj34xmYzJ9yuZErMH8byJtmb3ZRTlcjdfaz8JNvdmFXeGthKJrOSOpNgnmE
	lcGo+hkSUGjYkUu9gOM4VbUdbGke0BTOQuiVQPxB0s+YU9NdYkBBazXpE6GQbwusBDMRS1xvHbw
	icHWuLYFcFFVmE6d7Z9B3Co8p6ZLvcjVne2IKv8t9kWccpa2owbBxAXaa4JRv6/aAgN4Br8tH5K
	W5FNK9CINVKqZnDI4T1bebg/XOF6AqVXw9pTXlScx0hUvLhsC/DgiJzMdSP+SYT1rCi2W
X-Google-Smtp-Source: AGHT+IGgJZJcKTKM3XxOf4YsuboP55lfsrq1eYtf1kTos3YrkSFpLqpnWNoLYcx3tr3obv49p1pGYQ==
X-Received: by 2002:a05:622a:2507:b0:4b0:7b80:4761 with SMTP id d75a77b69052e-4b0ecc76dbdmr9999781cf.37.1754938524860;
        Mon, 11 Aug 2025 11:55:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b08cfbc7b9sm81757831cf.23.2025.08.11.11.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:55:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ulXg3-00000002V2t-2HW8;
	Mon, 11 Aug 2025 15:55:23 -0300
Date: Mon, 11 Aug 2025 15:55:23 -0300
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
Message-ID: <20250811185523.GG377696@ziepe.ca>
References: <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
 <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
 <aJDGm02ihZyrBalY@google.com>
 <20250805175753.GY26511@ziepe.ca>
 <aJNiW48DdXIAFz8r@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aJNiW48DdXIAFz8r@google.com>

On Wed, Aug 06, 2025 at 02:10:35PM +0000, Mostafa Saleh wrote:
> I am not sure I understand, the SMMU driver will register its IOMMU
> ops to probe the devices

You couldn't do this. But why do you need the iommu subsystem to help
you do probing for the pKVM driver? Today SMMU starts all devices in
ABORT mode except for some it scans manually from the fw tables.

They switch to identity when the iommu subsystem attaches devices, you
can continue to do that by having the paravirt driver tell pkvm when
it attaches.

What is wrong with this approach?

> > > Also I am not sure how that
> > > looks from the kernel perspective (do we have 2 struct devices per SMMU?)
> > 
> > I think you'd want to have pkvm bound to the physical struct device
> > and then spawn new faux, aux or something devices for the virtualized
> > IOMMUs that probes the new paravirt driver. This driver would be fully
> > self contained.
> 
> I think it’s hard to reason about this as 2 devices, from my pov it seems
> that the pKVM HVCs are a library that can be part of separate common file,
> then called from drivers. (with common ops)
> Instead of having extra complexity of 2 drivers (KVM and IOMMU PV).
> However, I can see the value of that as it totally abstracts the iommu ops
> outside the device specific code, I will give it more thought.
> But it feels that might be more suitable for a full fledged PV
> implementation (as in RFC v1 and v2).

Maybe, but I'm feeling sensitive here to not mess up the ARM SMMU
driver with this stuff that is honestly looking harder and harder to
understand what it is trying to do...

If you can keep the pkvm enablement to three drivers:
 - A pKVM SMMU driver sharing some header files
 - A the untrusted half of the above driver
 - A para virt IOMMU driver

And not further change the smmu driver beyond making some code
sharable it sure would be nice from a maintenance perspective.

> I had an offline discussion with Will and Robin and they believe it might
> be better if we get rid of the kernel KVM SMMUv3 driver at all, and just
> rely on ARM_SMMU_V3 + extra hooks, so there is a single driver managing
> the SMMUs in the system.

> This way we don’t need to split current SMMUv3 or have different IOMMU ops,
> and reduces some of the duplication, also that avoids the need for a fake device.
> 
> Then we have an extra file for KVM with some of the hooks (similar to the
> hooks in arm_smmu_impl_ops we have for tegra)
> 
> And that might be more suitable for nesting also, to avoid the bind/unbind flow.
> 
> I will investigate that and if feasible I will send v4 (hopefully
> shortly) based on this idea, otherwise I will see if we can separate
> KVM code and SMMU bootstrap code.

Maybe, not sure what exactly you imagine here.. You still have your
para virt driver, yes?

This especially is what bothers me, I don't think you should have a
para virt driver for pkvm hidden inside the smmu driver at all.

And if we have a smmu driver that optionally doesn't register with the
iommu subsystem at all - that seems unwise..

Jason
