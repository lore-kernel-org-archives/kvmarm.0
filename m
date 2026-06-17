Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ED6233946;
	Wed, 17 Jun 2026 12:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781697863; cv=none; b=uf+cf8tiuSTrg4JOwxurtCj2g1Ou0t0tg+gcBLjjMCEW7t8RQdfPVdgrA3arFYkBkxmkJk1H0lIFJ7y4lNp2NUulQy4FTIxpMzWfcwsM1dfyH+zt+va1G1xy3+tvqYHBzM2DruPiSVD9lwWXsR9pgCuXHhBL/zXg/4ngbzi+bDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781697863; c=relaxed/simple;
	bh=u8vmPRl2A/r6sSerSRxcMDz+Y4biBq4fJelAyefuXA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nsodRpFTnArpfm77rjjucEt4syVXRMgBwHCV4gLnoZ8SYuEak4IAoETHDFEeKnBe0SWz9Z+qn1B+MYsHzrQxWUushrR16gyQPsJj//NmPBPuqAdnGeOpHJ0zbO3m1Q8I71TPvnN4hhGVoj1zXnD5bhq72zUsOQaN1nUCUfDtgzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGAdk9mW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGAdk9mW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7201F000E9;
	Wed, 17 Jun 2026 12:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781697863;
	bh=LSoCN/yNNnd0t+uZKwuZBg9m7ehh37kmbG1fjTmBLKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGAdk9mWsan0nMEQhyBdfXXvmG5qvQxJtRvfzmxGNWjUpd+Mz21pCXe/6mjvI2Arh
	 6Lm9f3mTpDpbHQqD6hLvY/lCgobbHuyovA8miaxeI3m75l0zixVJ4tfIGBFdwYwhi2
	 HH/b0wUeI1ljXqWtKKJvKmkdK1AymaPEBXT8wlGHWzBh6O6CLTH6vLij1ahPw5VxAy
	 5PNA2Z4dU5aQnm4OW8RvmukQfTXQEDgTRa/pxLWcWqnEzMbdLLWOYvAXTAY4RPHdFL
	 8Akq4kQzoRece66d51+svqaVJlyN0M7rzhr8y78z32YpcW7+6vdpssb4FcG06IgGch
	 IlkTs4tHfYaTg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wZp0H-0000000DfZs-0LWI;
	Wed, 17 Jun 2026 12:04:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Write ESR_EL2 for injected nested SError exceptions
Date: Wed, 17 Jun 2026 13:04:18 +0100
Message-ID: <178169785204.3049672.18218491677214790234.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260615131116.390977-1-tabba@google.com>
References: <20260615131116.390977-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, catalin.marinas@arm.com, will@kernel.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 15 Jun 2026 14:11:16 +0100, Fuad Tabba wrote:
> kvm_inject_el2_exception() writes ESR_EL2 for synchronous exceptions
> but not for SError. enter_exception64() does not write ESR_ELx for any
> exception type, so the constructed syndrome is dropped. A guest L2
> hypervisor taking a nested SError observes stale ESR_EL2.
> 
> This affects both kvm_inject_nested_serror() and the EASE path in
> kvm_inject_nested_sea().
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Write ESR_EL2 for injected nested SError exceptions
      commit: e2cb1f4578625e71f461d5c1ce70984193389cbb

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


