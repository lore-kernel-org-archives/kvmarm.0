Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9181927AC2F
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 09:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757065289; cv=none; b=E7eEMwglCZqVwndhB2XJaSPnRSysdIUkhovD0qmXHtl3zj36bGYh4wMlDkxOT/6GN6Kr5yWrJI6DADNmN/7GmMQHFkwXIvOugpQ3lbgYilm4PwUUeJl8uyskihYPSumqJ0E/F1LjjcNRY2shoUe/wvcRF5Ir407mhL7WXJa+G28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757065289; c=relaxed/simple;
	bh=uk+qLQLDtRvS4MkPbhsWGc9Ftz18/PORzXeYF3PUwMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TS4yiqs3SuXSM7l/BYrtJYAO48n7/X/mJNQcRpZfmBSA7+7nXvZReOiopojQXQtxR8mXCNpAmxQbNveiMkhfDGI5+EexSYFL69M6CWADmfCnnIUS8ZmahD23hSs+jLmaDXFBkxNxP+lx2DAK5yEEgxoh8XK9ka5yK3W2BetpcPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A0w1z7Dv; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A0w1z7Dv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757065285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8XOvxlNGGHJoLa5Vx3ErGAvajcQpTrIPeSJD9PSV10=;
	b=A0w1z7DvZDe/KnnN8T47etkJWRrtB7CkxzLUmCf1ShOOB8lFX8wDeJXi1ugCG1FJhJefr9
	U2wt/iIG9rpMMNbnFIhKpGQuEkh0GTYwSl40cwe4pQCXwCveOhw61iPR4gI6kfMy4QYOso
	n+6fS1vUo9rUYzAQBRzvzdopdVM2IuI=
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 0/2] KVM: arm64: VHE: Debug fixes
Date: Fri,  5 Sep 2025 02:41:07 -0700
Message-Id: <175706523474.1669883.3863665313729519721.b4-ty@linux.dev>
In-Reply-To: <20250902130833.338216-1-alexandru.elisei@arm.com>
References: <20250902130833.338216-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 02 Sep 2025 14:08:31 +0100, Alexandru Elisei wrote:
> This is v2 of the patch that zeroes PMSCR_EL1 [1] at boot, hopefully now it's
> not as bad.
> 
> Picked up another fix - patch #2 ("KVM: arm64: VHE: Save and restore host
> MDCR_EL2 value correctly") is new.
> 
> [1] https://lore.kernel.org/kvmarm/20241106122654.38234-1-alexandru.elisei@arm.com/
> 
> [...]

I squashed the suggestion into the second patch.

Applied to fixes, thanks!

[1/2] KVM: arm64: VHE: Initialize PMSCR_EL1
      https://git.kernel.org/kvmarm/kvmarm/c/e643542c7160
[2/2] KVM: arm64: VHE: Save and restore host MDCR_EL2 value correctly
      https://git.kernel.org/kvmarm/kvmarm/c/2f67b9a64842

--
Best,
Oliver
