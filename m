Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE952F2A;
	Mon, 21 Jul 2025 17:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753119957; cv=none; b=CYb2oy/f8lYg2eQtwKhBnI/jj05IFczZpD6NxLXWsYH36AxFh34o3C4sdpOV6vyY9hTDc/00BjRnoZKe20I3utkRwtvbECvgerSfIoF9eC5i1ruJCySKSrRoHxRqAfPGWtIi0JadxzOKuIl+vZa7YSztQ2Gu+WSEdDVZ7Lrwkh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753119957; c=relaxed/simple;
	bh=O0zfAfduBUbLbWf83/6krXEHER/tdRj0Hvvb37jb62A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGLzojqOcClLNJXj9csEVVuK7DV2KpjU46/Wz0P4vPdUpkw+zwWu7sBYatUuTbwZMEftTyQLicaAd7pPc/CBvfxbNsgiCEFVsXSb/wuA/qcjsUmLpL0lDRaxb7CN4KG4D2hu5rDx16xS8uoLI8iljnT96roH9zRdbsKUfT9qa54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZ7FSTUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZ7FSTUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B0AC4CEED;
	Mon, 21 Jul 2025 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753119957;
	bh=O0zfAfduBUbLbWf83/6krXEHER/tdRj0Hvvb37jb62A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZ7FSTUaMx4xX7JIngOhQxfb2uAGgbPqHq804i0Xq4y5PjJO0yjHhC1oI/ja/QSQD
	 bN0ingyjFKo29Hy8YjRrFW5E5oIGoL7j8JWCu637IvDHr7OORVsHK+R+j4yECPfWJn
	 yoZlSaTLgvsukYPF09f36O2HYHGgO/MfMU6m+s136SVo9dHPrRYAZpGDO5eNoQapbz
	 tPIZ/AvfbvzQLiJ8fqnOlvWVbQXqi/fS62P3unI00c9OrZsXMW95x4Euq62wtEe14o
	 IfJScq1msWA4HF/UegjMgxjlpJIEVADTNm+gDqdTYEGT0w/lNAoOD+J+1yE4zGXRJM
	 eredAQvF3Vv6w==
From: Will Deacon <will@kernel.org>
To: mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	arnd@arndb.de,
	wei.liu@kernel.org,
	romank@linux.microsoft.com,
	mhklinux@outlook.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	kvmarm@lists.linux.dev,
	Jack Thomson <jackabt.amazon@gmail.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	roypat@amazon.com,
	Jack Thomson <jackabt@amazon.com>
Subject: Re: [PATCH] arm64: kvm, smccc: Fix vendor uuid
Date: Mon, 21 Jul 2025 18:45:48 +0100
Message-Id: <175311813171.3793918.5949198639937646656.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250721130558.50823-1-jackabt.amazon@gmail.com>
References: <20250721130558.50823-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 21 Jul 2025 14:05:58 +0100, Jack Thomson wrote:
> Commit 13423063c7cb ("arm64: kvm, smccc: Introduce and use API for
> getting hypervisor UUID") replaced the explicit register constants
> with the UUID_INIT macro. However, there is an endian issue, meaning
> the UUID generated and used in the handshake didn't match UUID prior to
> the commit.
> 
> The change in UUID causes the SMCCC vendor handshake to fail with older
> guest kernels, meaning devices such as PTP were not available in the
> guest.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: kvm, smccc: Fix vendor uuid
      https://git.kernel.org/arm64/c/ab1612211532

There was a stray "getting hypervisor UUID")" line in the original
commit message after the Fixes: tag, so I dropped that bit.

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
