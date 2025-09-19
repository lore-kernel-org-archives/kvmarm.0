Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EAC21323C
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285564; cv=none; b=QI/IauYNwYi9KUqHEsbAFM8OfTJLfnxFOq4rNUG+sMeYuFsy/KINNj5G+6+jIZloSR8WF4qMQaFZ1J2MGV4knMixIYusWEWZ9S3grEUg7FVjiNQA+seHR33XKsZ/0BbPkv0uEIN2ETTrY/koJURak6o8oh+1WUEI+wlZ1R5yBl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285564; c=relaxed/simple;
	bh=z7+hvtXaa47S/4/Qps8ZvpqkawthHpIksZpRsMljA+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXlqMLEZTuDWNDlr9GiKWZpyY6cEgK6UsQgLGYiOKSNgx26Afwb8NHRxYVVndIwQCrBhaqCZ4x3QlzWp5tCMW3gEbKnqrY0d1pxQfZqU3A3w5gR8s67KmJHrTWtmxeyrxbiifsUJNvHrC4xn8PRI1e3b7jh5XAZomFDe9Jgp1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNkqEDQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNkqEDQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBB2C4CEF1;
	Fri, 19 Sep 2025 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758285563;
	bh=z7+hvtXaa47S/4/Qps8ZvpqkawthHpIksZpRsMljA+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNkqEDQ4dzRUy61+nCDyYqHSYN8SVI97YQfk9Aoydnv+9Emo5drPJ9IW4RTyeXQlt
	 YE1hXGkdPG2aQDamMbCkl3PwrLNbPvaTXSeKF48mGiKV1ylPsBs7Ztib+6BgDvfdYT
	 ddB4kTUV5U4H6mB8Dv4r0b2DeaCmvu0MehQn+X66kTt1oNc7F+qxp3R6KJ5iF+Z2po
	 FfHUkF5Qz+1GwVOwhON7WKL/LL99Q78106hacc8lnHPVwdkNwv4XnA5Y/vswt3iKYi
	 agfcLnq6t2wr9fOM2d0ydDvV5OPJ6zSFXnwRhjsGKexfobf9R90oJoredVJKzj7KPl
	 1ef8x0ojPVilg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzaOX-00000007m8a-43e5;
	Fri, 19 Sep 2025 12:39:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: nv: Fix SError injection at EL2
Date: Fri, 19 Sep 2025 13:39:18 +0100
Message-ID: <175828552717.1679154.16303509920084066521.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250918164632.410404-1-oliver.upton@linux.dev>
References: <20250918164632.410404-1-oliver.upton@linux.dev>
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

On Thu, 18 Sep 2025 09:46:30 -0700, Oliver Upton wrote:
> FEAT_NV2 keeps us out of the loop on changes to HCR_EL2. That really
> sucks when the guest hypervisor toggles bits that affect the hyp
> context, such as TGE and xMO.
> 
> The architecture now allows an implementation to treat HCR_EL2.AMO as 1
> any time that HCR_EL2.{E2H,TGE} = {1, 0}, effectively allowing us to
> hide what would otherwise be a quality of emulation bug in SError
> injection.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: nv: Treat AMO as 1 when at EL2 and {E2H,TGE} = {1, 0}
      commit: ff37a41db8b47834b747b3bb427825fc75bc86a7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


