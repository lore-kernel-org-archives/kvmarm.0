Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D830DD07
	for <kvmarm@lists.linux.dev>; Sat, 10 Jan 2026 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040591; cv=none; b=pd2b1f0ZNccu+tLdLZSbVsL3GTh0PLCGkRYupmlFOgo3zVkm6zhb/9Mcxe9rck4iWy76jz9PP2LbHVVP6vSLUwgiKNba0y80QkIJGFTEoaeA+TVH/NWlUv9soln8+TWvn0+iYJLIJ+28IIKusrrCfjBYbynE0ItowSy/cFomAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040591; c=relaxed/simple;
	bh=N3UMkFVCDtVmeRbXTdo2Nl9ogv3n9yOtKBTkaeAWGhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rENLK2UdpmHogwK59grIAwxWRJZiRn4xZP/qyMaWf5kMdn6LyxqzbTrjcsRgPpEvFMrIm824BuBg3kofBMcX0tSumvR2zsJEhp0SFN+NPok1H5m9hKEsoXa7jd8UDcsxDaOoRVrgLTM91YZp1Fu5ueauAdQ9+NlV/cRPXFOJUyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAbtghIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAbtghIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67503C16AAE;
	Sat, 10 Jan 2026 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768040591;
	bh=N3UMkFVCDtVmeRbXTdo2Nl9ogv3n9yOtKBTkaeAWGhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAbtghIZE65q86ZWR+0D58ouko1Ed+zlgQd3WZKqTebzDxRMikA06xdx0vUWkM129
	 P11O65bnfZ4qAalb6GZEtFrCbsnYPWCtQ1TkKYA2MOcAbj0w/yY1F1h+4RAMRIpX+f
	 beib+35gL3T+exMlX6XWkIfIAJT5tP1SUelDT2CttGuISJP9SWc9vRV+DXQL5VbBnZ
	 Kuu7020c2y3pZ4sS3xMoxgTi0DoaWahA7ilUGAJj29cTh4SoKEmuxn1YaFZW3kkCm/
	 wDvhcCYIZe3Yn4oypG61i/dpVMMxBeJlaRHa8wZ0kfaZWPMyUiCW6zHnsjfEhk+CL+
	 SatmICIf309TQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: (subset) [PATCH 01/30] KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers
Date: Sat, 10 Jan 2026 02:22:48 -0800
Message-ID: <176804045762.916140.4830938298669479954.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-2-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org> <20260105154939.11041-2-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 05 Jan 2026 15:49:09 +0000, Will Deacon wrote:
> Commit ddcadb297ce5 ("KVM: arm64: Ignore EAGAIN for walks outside of a
> fault") introduced a new walker flag ('KVM_PGTABLE_WALK_HANDLE_FAULT')
> to KVM's page-table code. When set, the walk logic maintains its
> previous behaviour of terminating a walk as soon as the visitor callback
> returns an error. However, when the flag is clear, the walk will
> continue if the visitor returns -EAGAIN and the error is then suppressed
> and returned as zero to the caller.
> 
> [...]

Applied to fixes, thanks!

[01/30] KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers
        https://git.kernel.org/kvmarm/kvmarm/c/19cffd16ed64

--
Best,
Oliver
