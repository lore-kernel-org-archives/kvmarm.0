Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBF13EF662;
	Wed,  6 May 2026 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778084087; cv=none; b=Kr62wfHusJCY5/FLrxbjTqACYxUh3nOtOxGcCstUz9rSD0cZqz43rED3LpnRsaIXNMledUcSmvyv0I9oUcnyaGWXsoBavPbamKdty1C76Kb9nP3m94YuQ8oLxuAtjAo64dzncJszdMGVyExWF7rAFpb8lwB/pV91IK7rPAbVuOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778084087; c=relaxed/simple;
	bh=7EoFpIqU2CY22TlcKHX1E+bFT6rvufgU5nKroWLs2cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QKxWYvNAouGjX16RdfNHGMcl/vaGFFM7Qe3Gqp9RRFH6aSpB4vYDZFh1hwPs3NBLOWF5++wAt6DAj7J1+i6dP9Z051JA1eQr2y70hJRkqB2IpzjfO9xYec0zbPbtjhvjnUBkOTUyMDFxp7WMc4HPWVLV7ASFytaRHLEypziTZ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIxHMony; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIxHMony"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FE9C2BCF4;
	Wed,  6 May 2026 16:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778084086;
	bh=7EoFpIqU2CY22TlcKHX1E+bFT6rvufgU5nKroWLs2cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIxHMonyq1fOO8k8K595ytjPY6L/xMoNUXFblzwYg9ZXf8fL5h5ikvvZX/Idh75Hf
	 3xP71VnX9wjjd0DxpTinrY2E3ofkxR89hX6OKJtVaivwfEVXXNQDknZlNZ4Hy3UTDd
	 h5YoWID5TNljH6LbVY4azh+utumI7Tfa+XmWyAO0uDBWlOVttzjQYEoAkT/mfHQxca
	 UInn+oRUNEuEFKTNIFFdyCkUqnBYm/zd9OXQ5sw5sIi0S3YP7YP9Lc9PLMt45QwxHI
	 tPnvY4KAS5hrrP68b63LJkiQSPnwaiHQJbAiEC9J0S3A5v0UiIq2irkn/AgN74jjK8
	 +MI81HQtOVmNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wKetY-00000000MId-2aiV;
	Wed, 06 May 2026 16:14:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: nv: Consider the DS bit when translating TCR_EL2
Date: Wed,  6 May 2026 17:14:42 +0100
Message-ID: <177808404890.2712489.4128021964001358070.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260505144735.1496530-1-weilin.chang@arm.com>
References: <20260505144735.1496530-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, weilin.chang@arm.com, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 05 May 2026 15:47:35 +0100, Wei-Lin Chang wrote:
> When running an nVHE L1, TCR_EL2 is mapped to TCR_EL1. Writes to the
> register are trapped and written to TCR_EL1 after a translation.
> Booting an nVHE L1 with 52-bit VA isn't working because the translation
> was ignoring the DS bit set by the guest, hence causing repeating level
> 0 faults. Add it in the translation function.
> 
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Consider the DS bit when translating TCR_EL2
      commit: 8d9b9d985ad3a81c751a6b97edaf1d3c0780af7c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


