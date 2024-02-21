Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCC8383BF
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708510371; cv=none; b=feMImWQaWlOEHd8pf/aE6MGD1Ky1WH2ABrn4sqAgai+OtgDw/qS1PHmHkc8arHYEP9c5PIsUOlgZmG4elueYJm98uhwdRKavV68R8Zra3kL46RKwYyZZ+WTdo4JoXJFyOJ7219SBITrMJKb7xzpC/Kq/8XycvNIicrO3ghaKqNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708510371; c=relaxed/simple;
	bh=NfNeOgOKAjCvmU1Q36XYuPqD2rlE1aD+Cii5HW5BVXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mkk7MJ7MmanozJT5ocFzcVVqmvqwEseE3ldZm4QkuBdTramFvBfeb5Gc6G1LWF+C7r3ExOPUmB9gdY+jsbe9C8q31yz87ftBXfKga0e8FLLYFRWi6BHU0pF+tPfPOMgyBH5BJpwPsznm8V9ot7Atos5mFkrOmT1QAwFVR44MNck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o19szoXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o19szoXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293DBC433C7;
	Wed, 21 Feb 2024 10:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708510371;
	bh=NfNeOgOKAjCvmU1Q36XYuPqD2rlE1aD+Cii5HW5BVXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o19szoXn3Y9VXbrqMBrGcN5Gci+v+EJKhHackY3zhXLaSwXGBgkIQLu3NYrllCL+/
	 BcOt430he9Sa6DCxa2hEM7xF6i8pb8X4D2l1Xub3X4UYRr0EDHI30/9NQ76E0zlM4e
	 qZKS0+XRxEAp+rl81Y+PX5xxwCPWWF4QYK0WwjhcByIxUQ5n/OkBMmPpkuXnHq2Pqv
	 tXMH2yLdeuU2UNCNIt15yihk1zxN4FuGx3aPhujPUqD77rT4whmdrXjrM09d0A1uR8
	 XORMURXVAaiyFHDHmlYn9H8P+XBS6X6ahe1FnNxTyMG3Hq4r7Xqk0Sc+kC0iRL+3GQ
	 sKIFFeihN0YQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rcjaq-005CSq-U4;
	Wed, 21 Feb 2024 10:12:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: vgic-its: Fixes for 6.8
Date: Wed, 21 Feb 2024 10:12:42 +0000
Message-Id: <170851035506.2104698.8052029889733878749.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240221092732.4126848-1-oliver.upton@linux.dev>
References: <20240221092732.4126848-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 21 Feb 2024 09:27:30 +0000, Oliver Upton wrote:
> Spotted a couple issues in the way KVM's ITS emulation handles intids
> returned from vgic_copy_lpi_list().
> 
> Marc, I'd like to get these in ASAP, ideally as fixes for 6.8.
> 
> Oliver Upton (2):
>   KVM: arm64: vgic-its: Test for valid IRQ in
>     its_sync_lpi_pending_table()
>   KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic-its: Test for valid IRQ in its_sync_lpi_pending_table()
      commit: 8d3a7dfb801d157ac423261d7cd62c33e95375f8
[2/2] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
      commit: 85a71ee9a0700f6c18862ef3b0011ed9dad99aca

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


