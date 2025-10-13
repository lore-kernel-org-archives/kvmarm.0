Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F369E29C328
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374572; cv=none; b=uFmh4S9i2YgEjj+cVOz9Zap5jJ0i5H/Gc0oKkItL8ofS+Th8WL8PGwx66NJJZHtj3nL4RRde0wXRmQ+/zNOtE9vELCM0amaNgpMp2FnN0PnMgcD0FfWr50OsHWVQs2/tgQmyzbSKT5Zf/dQzcn+sW/ElHVSA1ZmdwXFHifzL/0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374572; c=relaxed/simple;
	bh=VLx0dgWdml1YTHWBd/ahmUvzFvDeaZCQ/nUFL9Vk1GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+Z/vdTLbsFmgAg5PEKy7rLn1exuZGnm7WktmjewtXqE7TsHKYVq3rPUWcNcCLYYXLdgrfOyIhgWVyLKLv9UDkKtID/HQ0hT/b8XiC3tsC4zFWxUO5Sf9aJSskF5a1dVrzWLYHL2QLM3PIHHc1r7xMYWBqsAYRqQO6hF+ZLudPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TezMqgeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TezMqgeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698BEC4CEE7;
	Mon, 13 Oct 2025 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374571;
	bh=VLx0dgWdml1YTHWBd/ahmUvzFvDeaZCQ/nUFL9Vk1GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TezMqgeA2mS6j1Drb4WhFs070xdLj4S2lqzaEcidKL9tqpyC2t8WnV5lg6F58YfUU
	 KvZi24/7fKweFngtTjjgJ7QrMjgFFHzN0RnhtXNzBNQnNZd9Cb4Wy54ACFvo7nd4wO
	 vj1DLiwGHEELQ6ZRBjmIrU42jdiBWWhhxR0YwrQKSA83uouDpjySnshhpZwdbOlYoo
	 0R2O8KQfZuyLtJuzQ5BMN7uSFFOZXLpjjwWVJ3r7vLtFwBghTj76lCRY9HWpHSi+Mk
	 hfUIdi4nP8VHIiRT5EsJeRMYgOIWWG7wvLXx1nQIjfbFFDX2tWT2sUAfLkw2iYHyE8
	 Ene4DKNu7RPAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8LqD-0000000DaUZ-1YXi;
	Mon, 13 Oct 2025 16:56:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: nv: FGT traps of MDSCR_EL1
Date: Mon, 13 Oct 2025 17:56:06 +0100
Message-ID: <176037441182.969330.1167396258919460534.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924235150.617451-1-oliver.upton@linux.dev>
References: <20250924235150.617451-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 24 Sep 2025 16:51:48 -0700, Oliver Upton wrote:
> KVM now traps MDSCR_EL1 (and a hell of a lot of other things) because of
> bad architecture redirecting the register to the VNCR. Marc reports that
> this hurts (surprised?) meaning it is probably time to send in the FGTs.
> 
> As part of this the FGT configuration becomes contextual to the vCPU. FGT
> computation is now hoisted up into vcpu_load() which avoids doing a
> bunch of bit twiddling on every entry into the guest.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Compute per-vCPU FGTs at vcpu_load()
      commit: fb10ddf35c1cc3b2888a944c0a3b1aa3baea585e
[2/2] KVM: arm64: nv: Use FGT write trap of MDSCR_EL1 when available
      commit: e0b5a7967dec05144bc98125f98c47f74fd1152b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


