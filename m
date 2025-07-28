Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE3F275873
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753722981; cv=none; b=X2iiYjxwGspUNeVzmkBWee0nj+VG0e0pudkMrrdnF52tP1bwnBpXPtdLp0fotNJXcp625su6pS1U6r6aUsP0UzOclCeVOc6sIWYzqrKF1CSOmtqMoOwMyC7EvuDF2TJAiQxPWxMCSOxjDehup0sBI1M+PxLbx3dZza87HqCDwKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753722981; c=relaxed/simple;
	bh=LX+4z9a19+vrk1cjEv/t7kBuoQ+qZTWr8cF/WLUp6qM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MHKwdRckuHbPDWLetFoSk6TBQmjc9VDAfW3BJnZkZt69WLZgKA7QMZNwG5Iv/yinUCNujl0WFV1xU/pFYHe2MDtIN8GDsAzmFci1bMkyBOgsaaNlLgk5ti6x2zxL2r7Ir5Rw0/Xzo3nDgwN+7UCNAn/Fq5gWAW6vjk/C14K82y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UvmCu+a0; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UvmCu+a0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753722978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+EX8Ujtll6q1V2wTm+Odo+Wk0R0hOLjhIyBpLeu9H+0=;
	b=UvmCu+a0hwJ4aIwfn6iRgKyY4/c5KL/uHlexc98SSe3TC2EEYcyOGuvDsk1mhgKtpdAllx
	tbh7WHGntdtF2GqdH7DiEs97IsrbFkCXJ9ecgsb+6Jqmwx/Jv/++lbolpZphSr8I7BDICs
	gFwQ5v2SqUr4qsnHWq8tJsI4N0zqvRY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eauger@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v5 0/6] KVM: arm64: Allow userspace to write GICD_TYPER2.nASSGIcap
Date: Mon, 28 Jul 2025 10:15:51 -0700
Message-Id: <175372292710.2891555.12732015097175534422.b4-ty@linux.dev>
In-Reply-To: <20250724062805.2658919-1-oliver.upton@linux.dev>
References: <20250724062805.2658919-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 23 Jul 2025 23:27:59 -0700, Oliver Upton wrote:
> v4 -> v5:
>  - Fix polarity of nASSGIreq masking (Ben)
>  - Explicitly call out some subtle changes made in changelogs (Eric)
>  - Avoid open-coding irq_is_ppi() (Eric)
> 
> Oliver Upton (4):
>   KVM: arm64: Disambiguate support for vSGIs v. vLPIs
>   KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
>   KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
>   Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Disambiguate support for vSGIs v. vLPIs
      https://git.kernel.org/kvmarm/kvmarm/c/82221a4e66f0
[2/6] KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
      https://git.kernel.org/kvmarm/kvmarm/c/ef364c5b4357
[3/6] KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
      https://git.kernel.org/kvmarm/kvmarm/c/f26e6af75782
[4/6] KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
      https://git.kernel.org/kvmarm/kvmarm/c/c652887a9288
[5/6] KVM: arm64: selftests: Add test for nASSGIcap attribute
      https://git.kernel.org/kvmarm/kvmarm/c/15b5964a411f
[6/6] Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init
      https://git.kernel.org/kvmarm/kvmarm/c/eed9b1420907

--
Best,
Oliver
