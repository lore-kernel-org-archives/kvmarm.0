Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F29D18C33E
	for <kvmarm@lists.linux.dev>; Wed,  3 Jul 2024 23:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049174; cv=none; b=mmC9ueOJorWQjaCd5ijBB/vZjibQeJo0FeaNe8+Ma6pfDn/UyFBbD96+69WkY8w89vpTpcL7SI3fJh6nsF7AvcR7pbCjZP984rbAfKSdD3dY9zjxqh3VkdjJdqDebqaBjMwT4+L9R7/dzKbPOCfhfA44hunyHISm/1KXPH2OVJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049174; c=relaxed/simple;
	bh=J8ZytsHv/eiIugqmuZNx1f9UJ1w/St+hFYhzQlfKsO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZccaHpk171P9QpgnfCnFenuEPjgDHYKGUwHe6saMAUHAXxe0Aqt0SvAqalac6ruF1CzSuzm2ctrNTz7bPUOuQhurDmOx+W/99lUDUGvNpctSnL27+93O51Xhsr/fZgOm5p8d1lzO+EUiccTM+DCgmOcFEmOyN3FkKHiWqBXsTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j3RO1CEO; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j3RO1CEO"
X-Envelope-To: kvm@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720049170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tcq0ZOKXKwseUjH1zgxoSvLVWz7sVlSTBdvlYKuy7So=;
	b=j3RO1CEOknLlNqRoQuOoFPjR3HfDohNi09ZJdGWuf1Mo7IwlihYRhPpb6wkv1qGuN5Zc3o
	Qz0OXviSNGkBWHGUPXLjj8jCf4PfDhwW8V3qGPGTvwR9XSESpsPnqAHFLZplQLLzkorbFy
	A5ikl1wEzaOifuyt7AO4PjyI2lZ9yaQ=
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: maz@kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Truely enable nXS TLBI operations
Date: Wed,  3 Jul 2024 23:25:54 +0000
Message-ID: <172004909841.2946123.11548804717263824415.b4-ty@linux.dev>
In-Reply-To: <20240703154743.824824-1-maz@kernel.org>
References: <20240703154743.824824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 3 Jul 2024 16:47:43 +0100, Marc Zyngier wrote:
> Although we now have support for nXS-flavoured TLBI instructions,
> we still don't expose the feature to the guest thanks to a mixture
> of misleading comment and use of a bunch of magic values.
> 
> Fix the comment and correctly express the masking of LS64, which
> is enough to expose nXS to the world. Not that anyone cares...
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: nv: Truely enable nXS TLBI operations
      https://git.kernel.org/kvmarm/kvmarm/c/3cfde36df7ab

--
Best,
Oliver
