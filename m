Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC763DA5C8
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057352; cv=none; b=uaWjACfF1Sp8dYKS/Xk6xCMYlcdp+70T/YrFsPoD0GxClbcKy1yFS0FpUezwQVpylXh5NNFrBLLunFRr/3XKjhc9Q+rooQeXxRZzoYOZE8fi1aVNDfybm67VzY/Z4sdhMmQQKgvSN15LTrP7Z7KgzKZXtfFQ0gfsHXFS0/nnOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057352; c=relaxed/simple;
	bh=9AFYi/BUXHOTKuIIr5yD3BrO5yqcxVBx5c2H4HAuZuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IM9UNN/zS1KPS0D3H4UbsAnJt9unwK8cjItqQAcoKrTO9a54xuSdZCQWrNz/y+ukwVGPckuzV4nGn57mFhfGgAG96JfSg6dohNxXdqtZzyU1FTCIdux0vyVrK1bxqS2PNYURJyJnNKGZCNMutTigOGgW/wVYUjm/O39R3/SFwK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwWWSN3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwWWSN3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E6EC2BCAF;
	Wed,  1 Apr 2026 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775057352;
	bh=9AFYi/BUXHOTKuIIr5yD3BrO5yqcxVBx5c2H4HAuZuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwWWSN3z4ipuPYch2D02vHE3/nVffyQAuFT9mEj8KLq+2zART7k3q2aCl6NCFB2W5
	 +W2bDigTNrRGGDpdK9tPXGBiCIS+ftfYgYFJdFZ4shG3+TPH7iXDehTfhz7AE1DgaH
	 7036xW/wGE41ikko7qK5Rm/n7DN7wG0qM3h6R6MJVfCvVHD3L0qHKRuoUA69tiAm2z
	 Zd+ikdYGGyq1fXRGV4XoY5s6jxdqWkodascjinlRLtmYgrYl4KSml0PF9pY31uV0h1
	 TxHPX2Yb3ss6i+U2RLn9v4S1n0TXg3nqWcTOONnEVKHxOjgxnWPQXzzUAv8zcMlf9e
	 dltwMMAJJDYTw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7xVF-00000007vAb-459l;
	Wed, 01 Apr 2026 15:29:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Fix teardown of non-protected VMs with pKVM
Date: Wed,  1 Apr 2026 16:29:07 +0100
Message-ID: <177505732750.363663.2457509354584161463.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331155056.28220-1-will@kernel.org>
References: <20260331155056.28220-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, linux-arm-kernel@lists.infradead.org, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, qperret@google.com, tabba@google.com, vdonnefort@google.com, smostafa@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 31 Mar 2026 16:50:52 +0100, Will Deacon wrote:
> Sashiko continues to throw rocks at me.
> 
> This time, it spotted that my fix (introduced in v5 [1] of the pKVM
> series) to prevent taking a reference on a VM in the 'is_dying' state
> also prevents unsharing of pages shared with a non-protected VM if that
> VM is torn down by its VM fd being destroyed, rather than the usual path
> via the MMU notifiers.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Prevent teardown finalisation of referenced 'hyp_vm'
      commit: 760299a1d8102b36bed5c25c5a3f94b5a0eee081
[2/3] KVM: arm64: Allow get_pkvm_hyp_vm() to take a reference to a dying VM
      commit: 2400696883870ec3fb0fb9925426c62a3383ca36
[3/3] KVM: arm64: Don't hold 'vm_table_lock' across guest page reclaim
      commit: bc20692f528b2ac8226bafe5b1db9a1f8be96dbf

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


