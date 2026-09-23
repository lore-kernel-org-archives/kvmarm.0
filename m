Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AB7329E55;
	Wed, 23 Sep 2026 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168418; cv=none; b=Fcny0xZLykJgT1PlVN5fMmzJGXw51t9iXp8Q4OOo1bDh7H7lYVfcVFQnbl87qFZQsoR6QKDAxX4zSL8DjQjuYQTD/A54U49P8XLjZnR8SZ+PVc6WiB9Zrl2oE7QWmtJEtaH271MNxYMdvhMny7uEA8A7uDx0w1Qe8tiliaxDPNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168418; c=relaxed/simple;
	bh=Ruv7lvlH59PJHkZsRe0UxAono6K00Z1r+lBjRShEIbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckuFUf0kl0Z/YLw3kNvTzQUb/mqPZ7DMUrReGiT/a0x7vEHzmQS+rfk/h/7PvnsuZc4JGVH6Xho7t/CqGjOSU/Lgvn1cwmSAuvZGF08pF/B7JLkQGLV+0Iwan4LAAYsjGo5n8SXhjPe3oMDO4VE2iQmIh+Y7v2WSbvI+9kZoyjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSejrNXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSejrNXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E81F000FF;
	Wed, 23 Sep 2026 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790168416;
	bh=bygnlyduWNX9bGl+OAOhRpG2bzPfJz7Wo7gATpHhbZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSejrNXcWpOIhzmDIgz77w5u8mRJlnIHTcFuakWa+LN4RJ/GWzRCYCTlaKyEaF6qh
	 PFH8GvS+RkCjHo3jXbZ85iR5PV3EJt52wNg798gUdjROejL9ssUTX6aNMzk/MHy2+U
	 IzZ+xAtk2Ph9TZJ6mtcCLJV2GjYWOF2T0LmrddSAfa1Ug6MlPcTxwYcAg8ZS+pIn0x
	 zb4NoK17FNt7tZcwSLyBA6ylQD9yDixwXpDn71N+jWgTXUG+WX30ry0KJ/HXt9yA4x
	 DGDOAt+Oobz74m4tH66qILPGlbrizeNTrHE1A8RS+MZB4Y5sMBkw9/yBr0uIIA97qB
	 ArMpJjI90PiAQ==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: mark.rutland@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
Date: Wed, 23 Sep 2026 14:00:05 +0100
Message-ID: <179016687079.3278822.12341361045842371613.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260922181430.3532371-1-fuad.tabba@linux.dev>
References: <20260922181430.3532371-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 22 Sep 2026 19:14:30 +0100, Fuad Tabba wrote:
> __init_el2_fgt2() writes one mask to both HDFGRTR2_EL2 and HDFGWTR2_EL2.
> PMZR_EL0 is write-only, so its trap bit, nPMZR_EL0, exists only in
> HDFGWTR2_EL2 and is therefore never set: a PMZR_EL0 write from the host
> traps to EL2, where the nVHE hypervisor has no handler and BUG()s. The
> kernel never writes PMZR_EL0, but kernel.perf_user_access=1 has the PMU
> driver set PMUSERENR_EL0.UEN for a task with a user-read event, so a
> write from EL0 reaches the trap and takes the host down without a panic
> message.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
      https://git.kernel.org/arm64/c/2bc6b218717b

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
