Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EFA246BB9
	for <kvmarm@lists.linux.dev>; Thu,  3 Jul 2025 09:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751535702; cv=none; b=FvFQz65FtaLrIfwNtuKrdu9CkrxgxZqC1/finCtUQAa+0vwgdggsmKn8zWuiKQ7D3nIVJ1J4dqcmafhlnN45wEtei2u9QNmRU6uTA4UYF7EckizUqu+wgfnGQNmhkDKS5zqwbREWX/B6+szSHBrIB/vLwMI8mv7X6YxBjHF5VIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751535702; c=relaxed/simple;
	bh=JRq4m39oWeiIfgUhjZzJpp2KxxVmCuR34R6ncKYxyrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AGvcnv5YxZntcxKjQuXG4QOIbrNasFHShyrixqTaBRh2STpSx2p0nh7wmUrBP0eAlrEFtPR5TJs0E37w+km0ETrTwk4ihUBfoUMEmWTWIQtM4FhgS9zlgRsWwMM9ioqZug2Yjg1DaWDG/UxUkn9PQD1wwZi1UBAkm6cc/YKU7rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AltaEVSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AltaEVSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32A2C4CEEB;
	Thu,  3 Jul 2025 09:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751535701;
	bh=JRq4m39oWeiIfgUhjZzJpp2KxxVmCuR34R6ncKYxyrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AltaEVShCSAPXyqd2hSKGhKdsFmhptkQM4UbA+IeyQuKsGk/vwRVqwWVFELB4VWTR
	 adRfFhzp0TFcNbCg67sA1+K8ISfj58+TIg5OjozvdOaBiKDFH4qBNcAHvHvO7Uwu3s
	 1swOz2n6SkwQrO7c4YBek7KTjY8jEIJ8wgXA+lpBcUh5ZjFosUlcTyQew5bpSKiH2q
	 3yli9ndSHFVyhq51Yu+vsSL9VIx/y/9n1vLzL6cb18TZCARv0iOHAuDVfrc/QgbeFq
	 Q6A2bw1tzKiEETB+ywtqNh4Fn33SUCjm3m2TwKM3olh1delA+lClPiItBPyMprxKzE
	 oKzD9KBttn/TA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uXGRn-00CFX8-Kp;
	Thu, 03 Jul 2025 10:41:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Fix handling of FEAT_GTG for unimplemented granule sizes
Date: Thu,  3 Jul 2025 10:41:36 +0100
Message-Id: <175153569168.947020.1733550411428596443.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250701142225.753984-1-maz@kernel.org>
References: <20250701142225.753984-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 01 Jul 2025 15:22:25 +0100, Marc Zyngier wrote:
> Booting an EL2 guest on a system only supporting a subset of the
> possible page sizes leads to interesting situations.
> 
> For example, on a system that only supports 4kB and 64kB, and is
> booted with a 4kB kernel, we end-up advertising 16kB support at
> stage-2, which is pretty weird.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix handling of FEAT_GTG for unimplemented granule sizes
      commit: 105485a182dc6ba32e55db46839af756c105afae

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


