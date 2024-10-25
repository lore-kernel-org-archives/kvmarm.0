Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D996213133
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729894582; cv=none; b=pIF3iwPGbzCHM/Vj6tSLTVDcvEqtbp4hB/yAf65b3MgjFeE3ak11sto54HiYd5lZS69ppisn8rglsQuPNbhJrN/VCZkR4jtcoVkt/Rtm2bQV7RZfrRONgdNV2XQBIBiqr6UYGDahHWHHiG8l7DMTxT+QH1o001KGJmgrOIWiAOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729894582; c=relaxed/simple;
	bh=WqLDa1SPD7IthRjPjRNIk08Duyo07rCazr5EEuw+mRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzo4a+uGr2yuVJmiPFvFqzK085eRHkrwlyuTQ2zoPqekRpgEdA2PlpoDEkzCWKvKndG1Pd6KFp41TYSXiWkKgptScBcVUUw3ngDnJ8olywrwF2dzFMLHb4u9cb8vN5Wkqtt+crwInWc+zn240szlVs2J7h76VObrRnSrJqKDyQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ijXdlP1I; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ijXdlP1I"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729894578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UI1vTxlBOxYE5W4xsGO7gchMf+mOAzEAvs84vZBAp0U=;
	b=ijXdlP1IJrJOQ+IsWfLev5HcVuwPf2qY7Xha9nF+1Hjf5SkAHdXobRxt5zA9IYzdOrlbJM
	c17M+IZuvvHP6vQ64U+fwRnPELCXzN7JV1sg4QT7bT+guKjOpYc+xn5ck0bVCok+6vWluJ
	c9JeOIHEkWMk/PHFxdxJr2KKXGnzgho=
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/2] KVM: arm64: Simplify handling of GICv3 hardware with broken SEIS
Date: Fri, 25 Oct 2024 22:16:07 +0000
Message-ID: <172989453422.3686528.17691027763300650560.b4-ty@linux.dev>
In-Reply-To: <20241022144016.27350-1-will@kernel.org>
References: <20241022144016.27350-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 22 Oct 2024 15:40:14 +0100, Will Deacon wrote:
> While looking at reducing the host memory mapped into pKVM at EL2, I
> noticed that the GICv3 CPU interface emulation for hardware with broken
> SEIS implementations can be simplified and the corresponding mapping of
> 'kvm_vgic_global_state' can be dropped.
> 
> Please have a look!
> 
> [...]

Included Marc's recommended changelog addition.

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: Just advertise SEIS as 0 when emulating ICC_CTLR_EL1
      https://git.kernel.org/kvmarm/kvmarm/c/ad361ed4771d
[2/2] KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2 with pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/8aaf3f7dce74

--
Best,
Oliver
