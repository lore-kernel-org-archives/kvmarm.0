Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCFC15DBC1
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 05:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750053334; cv=none; b=pqxn87ze95ytUQY6hcMdDqjmBw1MyZ9oVOVAwdzibGyPEwoehVAKhoWkWxiNo5zwF8s7jUM1MXFnUQl4jjBayLOT7SMUgXb+p2QImtRgwtymoh03amygO1Kv4ZEaXKTTCCD+r0MHzc3sLvWH1vZ4VtiXZYshoNX1qNY4/WAfK6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750053334; c=relaxed/simple;
	bh=0WlCw1kWmn+BwzaXsYcqHtP+tCAqKJVKSkhSVmkxpoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFRooZTE9BQZWB8lUtlzEh+S9xUksg4fVMqo2wseDF9bZAEf7bbpeDlTGz0kiZy67s3LLa5X7bTjWvC0Bpux16GK5Z61WXRg8fSCsxTnCshFWba473NNzhmlQQHNOIbgugYdRTm772Ubi7lg6f7iqx/JeO8ZLVNRq0dL7PLI84U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZWVWV3p4; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZWVWV3p4"
Date: Sun, 15 Jun 2025 22:55:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750053329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+kz97nTQZlnksCETF2OO3FxTKc75UDfdQVAlEutLyMk=;
	b=ZWVWV3p4mOCIZ6vd1VtWMmbvFOZ/gc24FpyWZDUAQ7axxp1+7BwXiIHMiyV/URDGODXbgC
	YopKxt2lnCASWFo3uAQN0bAllHo7N1ZdWaB+xZZswK5kpTtpPcId3bWYvqYk95ILqv/mBX
	YxvQVQczSf7I6VeKWacsG0us+Mx5H+c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix s_cpu_if->vgic_lr[] indexing in
 vgic_v3_put_nested()
Message-ID: <aE-xyGGpHXdJ_pcF@linux.dev>
References: <20250614145721.2504524-1-r09922117@csie.ntu.edu.tw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250614145721.2504524-1-r09922117@csie.ntu.edu.tw>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 14, 2025 at 10:57:21PM +0800, Wei-Lin Chang wrote:
> s_cpu_if->vgic_lr[] is filled continuously from index 0 to
> s_cpu_if->used_lrs - 1, but vgic_v3_put_nested() is indexing it using
> the positions of the set bits in shadow_if->lr_map. So correct it.

The changelog is a bit too mechanical and doesn't actually add anything
to the diff. Maybe:

  Shadow LRs may exist at different indices from the corresponding LRs
  in the guest hypervisor's vgic, as the shadow LRs are populated
  contiguously in vgic_v3_create_shadow_lr().

  Use the correct shadow LR index when forwarding vIRQ state back to the
  guest hypervisor's vgic in vgic_v3_put_nested().

Diff itself LGTM.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
