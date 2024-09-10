Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C01194C77;
	Tue, 10 Sep 2024 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725995022; cv=none; b=cN53aOBDiJGzpcb0Vn4VjY6sIQAM6fz9PFSHDlNdYq8DYzl9AqkJM3QxRK/qF0BzXiHHPKKK+2DyynNaFaU2TA3x1uaLNImuVYI432urGR38djsm/KensZEx5YPvMzqq4mEoSD8ucfUmavSKEJE7HtqRHGCLX8Rr1qbu5q3muKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725995022; c=relaxed/simple;
	bh=Co4ADdsEjs85AzGRn11Whp1E96utgCJRRG663qhSJP8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZlQlHkmlXk5SjbGyq+kET12J9jGy7cfn0F8zTwvFtHTXNcsJ9JFykk4zy9xe/cT9u1HHEdyWgm/O6nUdr5vHp9IVbLDVp6Y0Su7qbWrIxD33YAw2WxIhPQn82oZ4tTwiye7p1GINidSwleo3iUBXvlqyTdruhAJHjpse3r796M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a75+01pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a75+01pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85F2C4CEC3;
	Tue, 10 Sep 2024 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725995022;
	bh=Co4ADdsEjs85AzGRn11Whp1E96utgCJRRG663qhSJP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a75+01pd/CaDbfq5OPrILQnUgG6cibFEbjYI2zPFNmPOEUrWazVjwgNuBczakThkU
	 FqHA3xTMyF8zd1A4sMOq4JEZ9klWWXLJ0IWfUv4OUkz1Xp2mJZE39Zf876ZMNUlXWy
	 9FYD5R5D3Rxpt58GFDojbmgFui+U7DmUtjVRZo0aMrNWNKCa5oGHDOPpH6W4AnYUKT
	 mL83V5XKOnCYW9yzj48Av8cSyDSttSk/QT0HfwZGIeF7+8NrIPSVf5BL2SeVqR89jy
	 Zyis4mh7IIFMuuSDwvJ8Ux7gI1DosJtvPAgbYaYFiVy9nv5k1i8zBngUoUjHWBXDYp
	 RCVvB+5fttVvg==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Anastasia Belova <abelova@astralinux.ru>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: KVM: define ESR_ELx_EC_* constants as UL
Date: Tue, 10 Sep 2024 20:03:34 +0100
Message-Id: <172598897949.2321375.16307784891758642562.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240910085016.32120-1-abelova@astralinux.ru>
References: <20240910085016.32120-1-abelova@astralinux.ru>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 10 Sep 2024 11:50:16 +0300, Anastasia Belova wrote:
> Add explicit casting to prevent expantion of 32th bit of
> u32 into highest half of u64 in several places.
> 
> For example, in inject_abt64:
> ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT = 0x24 << 26.
> This operation's result is int with 1 in 32th bit.
> While casting this value into u64 (esr is u64) 1
> fills 32 highest bits.
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: KVM: define ESR_ELx_EC_* constants as UL
      https://git.kernel.org/arm64/c/b6db3eb6c373

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
