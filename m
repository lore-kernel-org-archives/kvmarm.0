Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F04D2FA0DE;
	Mon, 15 Sep 2025 09:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757930002; cv=none; b=o9iZPmRu4G97UMb2ycr9EQrMq9jCt5Yutb7q0iE8YqERicQTR24OyxRy1pZ+R4Fy5wepYLSkc2hFZFO1plCGXy33p90fNcRnaSYebT710W49NBpWI5zRCjKEpJn9GMnKS61lcE16D60mXhbUM9JnPh2kDWVAzyvsTJBPy3SiFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757930002; c=relaxed/simple;
	bh=VExY4NPjfZpQJf4u88T+AAZWTi12kWN4VPC1o7qUEXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PRP+oXdadfqwhsn53J6kpAzXwuDbIVmmnNXIrGH072Mu9xQHM53X1LXn33LsGrYVBtTSgScociLo/aAWdVZsVGhOuO/Of/5xhEWBZeE4prv2DOTGSqTxA/Jm6ASLYKjPNeDTJESNiydt0aIxjHGQYXLQ4n76XZo+wfTHlgpe9B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RES8IUpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RES8IUpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE44EC4CEFD;
	Mon, 15 Sep 2025 09:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757930001;
	bh=VExY4NPjfZpQJf4u88T+AAZWTi12kWN4VPC1o7qUEXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RES8IUpKVfB5x16IQm0LsH7FrmzAiJ9MaEDjeyYnhqxUaoFMiK0ThEZjsKxZKt74N
	 aVk8YTlUo8EdOQn2ZYfbWndt+xwj5VNKDvkIcEr/KHFzLLTwaed5LbIRXNR9ycLMo2
	 kLdS2sRjlSo+57MYDpf4r7COwQwh9+Q43U2miybm581sJtWtn/AFo8IAP+25hbJnmR
	 E5OFPVOWKgSuF/BCb6xXS1qGh8u9RG5F16/UvLYd64fjURUNuXfKLXS1bmdI52gxtw
	 D1xoT8jaUZRp3fG5qZbSdMxkZyH2C6VXJJN6Bl0u9vhVuGh+LyX3de5uxujrFrMhTR
	 HpI8L/uUnLLPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy5tf-00000006JZO-2xh4;
	Mon, 15 Sep 2025 09:53:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Per Larsen <perlarsen@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	ahomescu@google.com,
	armellel@google.com,
	arve@android.com,
	ayrton@google.com,
	qperret@google.com,
	sebastianene@google.com,
	qwandor@google.com
Subject: Re: [PATCH v11 0/6] KVM: arm64: Support FF-A 1.2
Date: Mon, 15 Sep 2025 10:53:15 +0100
Message-Id: <175792995612.521593.7894673693279210618.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
References: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, sudeep.holla@arm.com, perlarsen@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, arve@android.com, ayrton@google.com, qperret@google.com, sebastianene@google.com, qwandor@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 20 Aug 2025 01:10:04 +0000, Per Larsen wrote:
> The FF-A 1.2 specification introduces a new SEND_DIRECT2 ABI which
> allows registers x4-x17 to be used for the message payload. This patch
> set prevents the host from using a lower FF-A version than what has
> already been negotiated with the hypervisor. This is necessary because
> the hypervisor does not have the necessary compatibility paths to
> translate from the hypervisor FF-A version to a previous version.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Correct return value on host version downgrade attempt
      commit: f414269392443f666bd8bef0cb3f0b53d5147be3
[2/6] KVM: arm64: Use SMCCC 1.2 for FF-A initialization and in host handler
      commit: 6f4c348b1d5c08f1105e645700962cc4353a8ac9
[3/6] KVM: arm64: Mark FFA_NOTIFICATION_* calls as unsupported
      commit: 79195f342417ff773048515964707aba3bfe0e41
[4/6] KVM: arm64: Mark optional FF-A 1.2 interfaces as unsupported
      commit: 8d24683e3e0f93b4bfdb558df50923514042817b
[5/6] KVM: arm64: Mask response to FFA_FEATURE call
      commit: 3f5952917498e7bb9d227812d4349668f62c413b
[6/6] KVM: arm64: Bump the supported version of FF-A to 1.2
      commit: 162190f2ccdc5964efa2a26e9fc3e56cf80fc29b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


