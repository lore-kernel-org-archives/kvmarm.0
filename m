Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139D23EF0BF
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774617404; cv=none; b=rIm8zWUbkEbuuNwS/DKy6ycSZCh78vAoySXJqi77cYhKTQaYXsQDzfrKNJ7usxT0YCLYGqaHFSXlM53IHLf5KC7kPbrPGorXGY2Xj0z9fhuHEDFFCxWd28J8rhkSyxfx32aT55+67jY7dtCQukgfRWY5F/ydu2L/uLvQvMVhLM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774617404; c=relaxed/simple;
	bh=hCvQnYCBMadBb41sDOIC7/X2d4bp47XZvczCJW89veA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j44DbG0whUNa/BeXuYs6wVFb6Tr6NO8XimEBKTfIBnZLhf9WhWwpLLAiOp6P3nRAnKN5qIroucH7/tsq7JQ2/9z85dO6JbLra6grj9qNUr82PM9yDsM8suD1Io4T35brIkXn3lvDtBUP+nzomTFaWr+PghvhcnRYgfz+Jk50wcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YkSN9AUQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YkSN9AUQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86F7B35A1;
	Fri, 27 Mar 2026 06:16:36 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F05233F915;
	Fri, 27 Mar 2026 06:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774617402; bh=hCvQnYCBMadBb41sDOIC7/X2d4bp47XZvczCJW89veA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YkSN9AUQseR1kOgjTvOjuH5RoY7tsvhDl64v/ztTPODkcniNwe7c5605JdzGxvUMw
	 UGQmokfgFrWnwVukxlHV7Xpzq1mUZT6/8aOqS54x/7KzhguAR0NmZxP98B7cdJWSaI
	 jiTMrXgr1VBgaKt7sfDQR1ogiKHkXXJ1rWjf0DHM=
Date: Fri, 27 Mar 2026 13:16:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, maz@kernel.org, oupton@kernel.org,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, broonie@kernel.org,
	ardb@kernel.org, suzuki.poulose@arm.com, lpieralisi@kernel.org,
	joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: (subset) [PATCH v17 0/8] support FEAT_LSUI
Message-ID: <177461632621.2272468.5197255307509898250.b4-ty@arm.com>
References: <20260314175133.1084528-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314175133.1084528-1-yeoreum.yun@arm.com>

On Sat, 14 Mar 2026 17:51:25 +0000, Yeoreum Yun wrote:
> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
> 
> This patchset support FEAT_LSUI and applies it mainly in
> futex atomic operation and others.
> 
> [...]

Applied to arm64 (for-next/feat_lsui), thanks!

I decided to drop patch [6/8] (arm64: armv8_deprecated: disable swp
emulation when FEAT_LSUI present). The way FEAT_LSUI support looks now,
we still have uaccess_enable_privileged() working properly and we could
even support SWP emulation using exclusives. While it's highly unlikely
to see both 32-bit EL0 and FEAT_LSUI in practice, models may support the
combination and disabling SWP emulation feels pretty artificial.

[1/8] arm64: cpufeature: add FEAT_LSUI
      https://git.kernel.org/arm64/c/7181f718cb0f
[2/8] KVM: arm64: expose FEAT_LSUI to guest
      https://git.kernel.org/arm64/c/f6bff18d05ed
[3/8] KVM: arm64: kselftest: set_id_regs: add test for FEAT_LSUI
      https://git.kernel.org/arm64/c/42550d7d8aa6
[4/8] arm64: futex: refactor futex atomic operation
      https://git.kernel.org/arm64/c/eaa3babcceaa
[5/8] arm64: futex: support futex with FEAT_LSUI
      https://git.kernel.org/arm64/c/44adf2bf40ef
[7/8] KVM: arm64: use CAST instruction for swapping guest descriptor
      https://git.kernel.org/arm64/c/16dbe77a5be2
[8/8] arm64: Kconfig: add support for LSUI
      https://git.kernel.org/arm64/c/377609ae8b6a

-- 
Catalin
