Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994742AF17
	for <kvmarm@lists.linux.dev>; Fri,  1 Mar 2024 19:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709319807; cv=none; b=AWcRsWs7Wm/Fse/C1qrvkuVjOAeFyZq3/OFUKuEOW+pwZnJNAHHLpmnkIO9nj3IrGwS6KILAnWTb0cydeR6UMKDxSNFI65ZiBQH9bqPy1mHnR+Yz/N72rKyAmlyQPjnp4TOnXx8qBJnkkz9H6eYe8PX+MX0RWrpuQ16KdgEfpI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709319807; c=relaxed/simple;
	bh=1cZqnZmdHKKZkhk+c1RSUoMsvk7V3EezrBDtydC2bvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IY/K6Fv8yQH1gDOe1bpUmjud575Y5QSccW+3jmSmNMavnQQJkNgoKi9xSGonoF93NP104KF/Efz+QhEsO82y/WgoO29pkQEkf0WbYxA9YzWopigJhXUfu73QVls4PcArkYbnQpojpjy0XTpg/BHuIffGmZeuN5cU6PPV9wiWyik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nyd0oFQL; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nyd0oFQL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709319803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrpNm4mnC143yOwr9eZ6I1eNSSegZA2JNP9wWT05P3c=;
	b=nyd0oFQLTLeY4XnLHZjrEoYj5Jjk6OZhUnrnG918Ds+3rqimoW02ZTZ6+yaQ8I6L158BVH
	AtW5HUIhdOVAiKVGXfFfG6cd+s3nG/9hgEWO98p0lmZu57MlhwQ3rmrVfQlThZVPo7QO2V
	4nB5jLSS0gbPFNW/GkVSGvjsl4Jbxnk=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix TRFCR_EL1/PMSCR_EL1 access in hVHE mode
Date: Fri,  1 Mar 2024 19:03:09 +0000
Message-ID: <170931978598.3080605.10344567074374622004.b4-ty@linux.dev>
In-Reply-To: <20240229145417.3606279-1-maz@kernel.org>
References: <20240229145417.3606279-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 29 Feb 2024 14:54:17 +0000, Marc Zyngier wrote:
> When running in hVHE mode, EL1 accesses are performed with the EL12
> accessor, as we run with HCR_EL2.E2H=1.
> 
> Unfortunately, both PMSCR_EL1 and TRFCR_EL1 are used with the
> EL1 accessor, meaning that we actually affect the EL2 state. Duh.
> 
> Switch to using the {read,write}_sysreg_el1() helpers that will do
> the right thing in all circumstances.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Fix TRFCR_EL1/PMSCR_EL1 access in hVHE mode
      https://git.kernel.org/kvmarm/kvmarm/c/9a3bfb27ef65

--
Best,
Oliver
