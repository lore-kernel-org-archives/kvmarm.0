Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC2876041
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 13:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460910; cv=none; b=Z9tR+AJZ2RVVJinrrg/5GpaDprAHLS4FiwKh+GHymEkK0/5LkpG7HG+HQ/0r3wdq9dVJI3V3manRbMdfOxZ1muEruc/Njz8fjGq6XYvYc4GIA4f8ymiyiE39TWCxkQ+5ZmpqjpSEF7NPVp8BX/mCy27EQ9QKTz4RBkMn7TsD5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460910; c=relaxed/simple;
	bh=mxHCqqVJyWTLNThPMWwO7HztrmqJPlXHx8L8vaa7NCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VQtGDQzjWbRLZjrXMqwElkY6EFechFKoVNbix5H79QhfsHtezfslXPquTv+otzrk8N34Hlv5mtRUP/4h9o24ukXqr0MfWMyyeAD48I4lk1nnSLhJKJ1G2KAmIz578PcBt7A56xZNgW5uPUNs0seFJf88WBbUUGTsviK0FSGN3Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=viyhFYm6; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="viyhFYm6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711460905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2VGWTteO0+TFmvwaciLninPLvbIJwtSZb4p8Z0MFh8=;
	b=viyhFYm6tjgcEVelNULpEePyfDyTR2VG+HQspC2ZbXtNyBItjsB9JXu5+iz5u4+jkgOFVO
	oJgBFF/VDkY44qY0tPxelVkoptXq0Rw5qKViUIai9VlJwsjDM+M8Q7L/qbRLZxyKIdl2y7
	UzsXjJzh9b0RVv5nrhty+MD0LlP6B0Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org,
	Wujie Duan <wjduan@linx-info.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	kvmarm@lists.linux.dev
Subject: Re: (subset) [PATCH] KVM: arm64: Change back kvm fault condition to translation
Date: Tue, 26 Mar 2024 06:48:05 -0700
Message-Id: <171146083370.371832.3901832143255309218.b4-ty@linux.dev>
In-Reply-To: <20240318100249.220897-1-wjduan@linx-info.com>
References: <20240318100249.220897-1-wjduan@linx-info.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Mon, 18 Mar 2024 18:02:49 +0800, Wujie Duan wrote:
> KVM: arm64: Condition should be esr_fsc_is_translation_fault
> 
> In commit '11e5ea5242e3 ("KVM: arm64: Use helpers to
>         classify exception types reported via ESR")'
> the KVM code was optimized, but the code logic was incorrectly modified.
> Therefore, it is being corrected.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Change back kvm fault condition to translation
	f5fe0adeed6019df495497a64cb57d563ead2296

-- 
Best,
Oliver
