Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45514155351
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 22:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722895914; cv=none; b=IK44vBtSxnbJGWpm55xC+rSkzYm1yN/oGCROuG/saqp84hmLHEuiKyHVoQKyl5xfXBsmlghQF7N7N4KND1X/v51QUUoDiU3g2Qej6aRLNrLBKxjWfvjYVvXakiCaEMusqvwvcpF03AXfzVptVuzM6o1I9Z/LBGhTirwsug9qUbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722895914; c=relaxed/simple;
	bh=Pp8aI2iKwR2+GXwRveJhNG/mEYK/NXdxdq6bH9iCZlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DpfSiD2Xs41AjzAz3gmeHmNz+5Z9KKdjzyGIxgv+idcq4y5KHJKJ0cNuZTq17QCHiuC9G5OCX5rlqTMr7GPDwEbxsHUSlndbWPqJSPoDeYWgEd1eAEuahkJMkIsrtLabNo7OMKzzk+0gsLUB/xhf2YTrIvgKPMWEm632sPNfHOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BnaOc+Ez; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BnaOc+Ez"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722895909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i82Zqt9HJw3+2eWcSnsUdFIB5iBF/cVdpLNcBIBj4gA=;
	b=BnaOc+Eznw4rmWsuRx3tNOPr8LSWsQfKKlg7aMGj0eIiP3ocDM/FZcaN/9CtqBiRtq0sGS
	NnxnRFmrAIlxtzmcfgpdzQYt9/tyQ25XUCMgc+jVzQGGcu80BNNDq7u2qbT91sizhdK3rY
	D0k9WuBF8SS/y1LfX6efZPz57zT+GNg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Danilo Krummrich <dakr@kernel.org>,
	christoffer.dall@arm.com,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	james.morse@arm.com
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: free kvm->arch.nested_mmus with kvfree()
Date: Mon,  5 Aug 2024 22:11:38 +0000
Message-ID: <172289578015.3402139.7931482525792832503.b4-ty@linux.dev>
In-Reply-To: <20240723142204.758796-1-dakr@kernel.org>
References: <20240723142204.758796-1-dakr@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 23 Jul 2024 16:20:52 +0200, Danilo Krummrich wrote:
> kvm->arch.nested_mmus is allocated with kvrealloc(), hence free it with
> kvfree() instead of kfree().
> 
> 

Vacation + catching a bug while I was out got me waaaaay behind. Sorry
I hadn't grabbed this yet.

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: free kvm->arch.nested_mmus with kvfree()
      https://git.kernel.org/kvmarm/kvmarm/c/32b9a52f88a5

--
Best,
Oliver
