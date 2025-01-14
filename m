Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E0A14C5A1;
	Tue, 14 Jan 2025 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867267; cv=none; b=Y3mVn8u/IcRQaE4vdGfsmNsWN4jhwzLLCO0VKbfB7j1+CmuRKAenPKiaCaeGIqfgLUZg8S8/vF/hIZISqHQnDuBCA9GncBGbM6PVptuhYj/9AtS4w49dABSDP6KxLyE7nEtlBatg/PPM5zNNACC3yfLbDypkT1TGzKJyQNy73Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867267; c=relaxed/simple;
	bh=OJUsxyrxfC11aQT26TYfZHa68Gx/au1vC79F/kqbr4M=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S90xk1tBBKRkdXooYVsBCrtSAHGBLL/zsp/yxX6KpFAKWStwSHXPJEg+3yNLcxM6Uz4cVMXnZeqRcNCgi6wYBIdRvVPbBZcBRcnaFbhAOXIMZYLF+iAJMhm7PYgZK51SPF+tsEpthQME+brjG64jc458gwulp4HPCwkx+MyaC/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXnV/r9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXnV/r9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA55C4CEDD;
	Tue, 14 Jan 2025 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736867266;
	bh=OJUsxyrxfC11aQT26TYfZHa68Gx/au1vC79F/kqbr4M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eXnV/r9WUSVIa5mpEYC0Ii8R3z9An4EuL+3t/H4jmYLyWT22LC5ojAMXfN78yI1Tu
	 x5UdwirEFdkPqZvVZ5lqPQZ1lI8PXoy8bPZ5naoykYIipP5dukhr7tgyd3Cmijq69h
	 Kpj+EkMfGf6KaoQQ3cPKsKH+jBrPpLNLxF2G+JmOVDoQJGFt2bBf567jKsYrYe0vc/
	 OoPsY/aP0peoscsY0qQYFLawglUFGOPRykmnbi1b41xOpUQ1SV1dQqGSfjU+3ghIYV
	 yUK12JaDPxn9FKYuhtiMngf0Vut3qPUFK9Udcn6gX2FiqfSI2hvHYvUKjasYe2Dzxr
	 Ahy2BIcFVMfiw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tXiW8-00CApI-4F;
	Tue, 14 Jan 2025 15:07:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: catalin.marinas@arm.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH] KVM: arm64: Fix the upper limit of the walker range
Date: Tue, 14 Jan 2025 15:07:40 +0000
Message-Id: <173686725256.1564007.10057410083015197983.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250114145050.563658-2-sebastianene@google.com>
References: <20250114145050.563658-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, sebastianene@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 14 Jan 2025 14:50:51 +0000, Sebastian Ene wrote:
> Prevent the walker from running into weeds when walking an
> entire address range.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Fix the upper limit of the walker range
      commit: bc9e4ec6e98838314c07575a5fbc06755d21913c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


