Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9990212B3D
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 09:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748597266; cv=none; b=N8m1dgt03+metWl0gW9bALVc83o9QWvUhPD1ZsXVoUUh0psI/5KdYreYJeDhn3gR+GSviga3w/mifhtYfC+kWX0ZRtqnJw0MXdpR87uxlk0HFqRDKk7TMUhtwZEUmhYHlUgG/YOpaIvT6zwJw9QtFDQjVhLCpV8RdXGIG9tX1iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748597266; c=relaxed/simple;
	bh=BfDBWaH+bJ58F06SMIRI1yZY1zg0J69UAxOI6infm10=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjC5tAYN82hxn12ihs/7gkiq3qhMdP6ibh3WTxVzqMbv3KrtzIr9Kv8/lZoYexYqKSFWwzJDnba9WCMP2XNiH2EBPw8wZ9dmKLM1J8t9bNDIYlNVIiFY2XazA+LrkwYWIsFcMQhKBGpPQT+HNBP7l0zjzngsT0uwnUHvHZMMORU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4J2GRQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4J2GRQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A01C4CEEB;
	Fri, 30 May 2025 09:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748597266;
	bh=BfDBWaH+bJ58F06SMIRI1yZY1zg0J69UAxOI6infm10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4J2GRQvouH7L9uxLceCUH8hLwPpUnG5Dtt5R+hu1nz/p0pZR27IMUgqNGuTdG01T
	 gDTg6e2qvHWs5ogY6yxbVq+VSPX6JFc1hr4s23yKa70OfQra5pmQwwIK/yfnWwCsXt
	 sWFFhBhMd8FqE94iJhglBUXim+By0Kk/dckl67b3e88vlxu908EEKhHvKp08An9/8x
	 OU67ExJ5ukAtHJDn84HhLLPBYSwImKog2MgknwnujBNUjlyO0eN7+1KUVAUmGxWQrL
	 rwQ6AXntEJQSWKI1Tp37v4nMuhAKSoeFc5MpNLMwj/RXJiomj9aSUL3l4pzQNJ9pOK
	 zldQyFXIkqfrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uKw1f-001oIX-Ug;
	Fri, 30 May 2025 10:27:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Mask out non-VA bits from TLBI VA* on VNCR invalidation
Date: Fri, 30 May 2025 10:27:39 +0100
Message-Id: <174859721251.1152851.5430955827758174565.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250525175759.780891-1-maz@kernel.org>
References: <20250525175759.780891-1-maz@kernel.org>
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

On Sun, 25 May 2025 18:57:59 +0100, Marc Zyngier wrote:
> When handling a TLBI VA* instruction that potentially targets a
> VNCR page mapping, we fail to mask out the top bits that contain
> the ASID and TTL fields, hence potentially failing the VA check
> in the TLB code.
> 
> An additional wrinkle is that we fail to sign extend the VA,
> again leading to failed VA checks.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Mask out non-VA bits from TLBI VA* on VNCR invalidation
      commit: 667304740537e546dac676be9eb81cee41d2ebdd

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


