Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF8278B4E
	for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713986134; cv=none; b=QMjdH5nt0R6loe1TvguG4t8aeRq2LjDXBlJd0OqweUNUY5FDXSMP1OUP8mqLx5cHRkCYMpqKnAc2gzTYrlTqo0dSwTC4ft80B8rQee9yd6fLmxSbamJjZnKAVWkuYVSCx6mj4peOgDuWEHfzQBH6L8TpfrYb2cfQ+VxzPRCBxww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713986134; c=relaxed/simple;
	bh=cbs4/GsRFbvvwAe9pesFouoUlPJUcj+w4760zN9rM0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmsK61DiaYT9osnAGu4kUWPZMXwEYSm0kxr0RNVB0L3Uf+aKo2wSyUX9wEgXQTuZcr8jDm+eOGEA5nO/89EqVKBxnHmhTuX32WC8K6ciKg+RrkVjBO3MkwTTJ65pCWIBCZJI/qfQQ2krwI0T+MMiJSf7zc/y9pVp+CO5stGIFxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f2Ehzlp9; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f2Ehzlp9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713986130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0j4vcSotV/ab5MF4MQ/aE+G24A8P8JLJufLFK3Fsk8U=;
	b=f2Ehzlp9Y3QKl29jh0E6wfi4deuDgFWgTeIEDJ75XR1NdVNOVALCuxQ0YE/UP6H5CsCV6i
	kCq59FQKWz2hLq1j7VcrV0KRotTjatBAl5b8k9GMBsYEoCPVAzBb5ZIZ1Nv/qwNe7U8uUn
	yXCfBYcx23bdV3tA2dIKTTsFBi79ZSE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	James Morse <james.morse@arm.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Avoid NULL dereference in vgic-v2 device attr accessors
Date: Wed, 24 Apr 2024 19:15:19 +0000
Message-ID: <171398579443.3801637.10801372488006477660.b4-ty@linux.dev>
In-Reply-To: <20240424173959.3776798-1-oliver.upton@linux.dev>
References: <20240424173959.3776798-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 24 Apr 2024 17:39:57 +0000, Oliver Upton wrote:
> Alex reports that it is possible to trigger a NULL dereference via the
> vgic-v2 device attribute accessors, stemming from a lack of sanitization
> of user input...
> 
> Here's a fix + regression test for the bug. Obviously, I intend to take
> these as a fix ASAP.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/2] KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
      https://git.kernel.org/kvmarm/kvmarm/c/6ddb4f372fc6
[2/2] KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF
      https://git.kernel.org/kvmarm/kvmarm/c/160933e330f4

--
Best,
Oliver
