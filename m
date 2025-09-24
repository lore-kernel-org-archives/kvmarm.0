Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881B8313290
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739103; cv=none; b=nFiPpgTJ7AwDdI5k0tdNDu6T6aeXnrIPznrHuC1tp1fcrsOsEOFkR3aB3I2JJyzdge58xxMu3kEAX0uqMAE8TFlZ05vcWYs3AeWwieRgDYUbgheXj4j8s591mzwmwOsQnXhW9pP4YVMxAiPM6qP/+ewZDikU55AUXDoT466aM/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739103; c=relaxed/simple;
	bh=95MgXGYYkvrygb2g8tEA265wYoLf6AlcXd3IUgR7nEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ISOh38+v30/XZM7ZzmrE0zlVSFSQiK0y/7SLfaFstIplLYqbaqnYMriTKFkofdkMqiDNaS3CUYy3+p4D3UOzMCQqHaLUDN6bYBDvpaZtE4GLLsMVq0JRLynbByg0ha6bLsK08xaGMhDBBiNGgjrXCSQRkSKU0271MzDDVAwu2qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUnlPT0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUnlPT0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB4DC4CEE7;
	Wed, 24 Sep 2025 18:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758739103;
	bh=95MgXGYYkvrygb2g8tEA265wYoLf6AlcXd3IUgR7nEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUnlPT0GuSrikXjoSnfslInpNlOFOLUuEEk9Ycjhsps3aIrREcLJr4e8+7OLaeKYO
	 PB+tHASBZppSC5aIQZS8lTTqEyMfbPiKc1cSp3sgH9MBu4PaVLbzc5haVVmToNJyYX
	 uzRIqY8+A6+6bdYTm7fbbw8p0Af2LBKOCUJLuzuNr3QP5KYrqTTvWv1acCZc56X3KL
	 JiGiXDUrqz+PaRcm56H1zqH1n37qCbFVYvT+59RSOXXk/NSeN19rQ5jyCnJ5FV2Ljs
	 bIzKfWXiyY3CutariSAv5+E9ZV1PJx97hCvklBEFpgdwgu3qF8JsAQR5MGnO+4+1za
	 +AioXk8S8zbnQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v1UNh-000000097O5-0Kdm;
	Wed, 24 Sep 2025 18:38:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Cope with arch silliness in EL2 selftest
Date: Wed, 24 Sep 2025 19:38:18 +0100
Message-ID: <175873909799.2373062.6729560774456739629.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250923173006.467455-1-oliver.upton@linux.dev>
References: <20250923173006.467455-1-oliver.upton@linux.dev>
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

On Tue, 23 Sep 2025 10:30:06 -0700, Oliver Upton wrote:
> Implementations without FEAT_FGT aren't required to trap the entire ID
> register space when HCR_EL2.TID3 is set. This is a terrible idea, as the
> hypervisor may need to advertise the absence of a feature to the VM
> using a negative value in a signed field, FEAT_E2H0 being a great
> example of this.
> 
> Cope with uncooperative implementations in the EL2 selftest by accepting
> a zero value when FEAT_FGT is absent and otherwise only tolerating the
> expected nonzero value.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: selftests: Cope with arch silliness in EL2 selftest
      commit: 75b2fdc1a82195997cab4836f9e511cbe8c8eb52

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


