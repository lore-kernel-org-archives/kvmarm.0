Received: from out-199.mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C963030D1D
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 07:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hl8QQsfn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697529544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8wO3vSl0A/4QjUqKCic92wzMg8jg3zFJaYhjGnZWDLw=;
	b=Hl8QQsfnTSD3UC0+SFB3YuAzxdU0WT1NtWd3i5GRouPeGkG4Id4GdK2Dh29gTXxjWyrqcC
	uFiXIkDbWrFW5ac9Vm2E+M+JIcW8DxvuF1Pw+14k8IoOvJgdkY+7HoxtxdblRlpVQLezZP
	aywmcoMAK8/stZhtSPFmy6JuQXeJWBo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Move VTCR_EL2 into struct s2_mmu
Date: Tue, 17 Oct 2023 07:58:45 +0000
Message-ID: <169752952219.1493360.11796864762419741247.b4-ty@linux.dev>
In-Reply-To: <20231012205108.3937270-1-maz@kernel.org>
References: <20231012205108.3937270-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 12 Oct 2023 21:51:08 +0100, Marc Zyngier wrote:
> We currently have a global VTCR_EL2 value for each guest, even
> if the guest uses NV. This implies that the guest's own S2 must
> fit in the host's. This is odd, for multiple reasons:
> 
> - the PARange values and the number of IPA bits don't necessarily
>   match: you can have 33 bits of IPA space, and yet you can only
>   describe 32 or 36 bits of PARange
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Move VTCR_EL2 into struct s2_mmu
      https://git.kernel.org/kvmarm/kvmarm/c/bff4906ad66a

--
Best,
Oliver
