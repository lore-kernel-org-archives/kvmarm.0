Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A22D2E5418;
	Mon, 15 Sep 2025 09:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757929883; cv=none; b=SHjh3AZrdP6MADhK3WN/PkSXpgXbiczGcZaAzc+1HrwCKqkaDttLHc3SYnw4K/eLP0NbcoA3lEcBqmF5XobJF2EUThTe0cKqhnFZOOKmr8qwBkw/AzBof+UyVuIICEjHdy6r6nV/a0LBFSO4YEHKyEsN4pXdkxb38LLTBbOvt6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757929883; c=relaxed/simple;
	bh=WnvFPefftVMi57x0Cm0fT5bmITli/JYWAqUWuBi4lYE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6DnSEvPlzsUFX1vbGh5YKhS9isNDCeEIa4Zx8l1nyreiFYg1HFygi2dKmQb3nHwP9bwQTS0P33ynzC5PTOcUEGhbRk9xpdBr8zq7dAQcSdy8SNGXKiN1wy8e41IOJ64yCBgLFMjeZZ61rfPDWkQAPltaKTEWEtjkG812zGEPyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u2vgHIqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u2vgHIqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AD5C4CEF1;
	Mon, 15 Sep 2025 09:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757929881;
	bh=WnvFPefftVMi57x0Cm0fT5bmITli/JYWAqUWuBi4lYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2vgHIqFRTWF1iMBEYAe1cawXkRSaQXb66y5dTwbpcu9S3aQ6ro0/N3L9M6e5zlnT
	 xP5p/0a/gtSDrRuZ38hsR7bKZNxu7N/9JSyXNPbBgjqwif1n7MhplpMCo735Hrlj0Q
	 icL9TrZOGRA6GtCcnEzznvt9RUkg2Zi7BYY2ID2Jkg1b7EaK3MOIVt4op3hpIpkC0Z
	 DyxrhrX6oyVWWTYEs/50KhqLHiDf/m51uMQVd5dXcaL4ShZP4bumIKO6PswBpx4VOj
	 v1G/zLkFm8TjWWyyrSwUtfkMxBbnFtmfeWxwPuF59QulO6S8iDVnd6V3KDdRLjo+dM
	 iAA/ckjxuBxqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy5rj-00000006JXG-3XXW;
	Mon, 15 Sep 2025 09:51:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>
Cc: james.morse@arm.com,
	tabba@google.com,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix debug checking for np-guests using huge mappings
Date: Mon, 15 Sep 2025 10:51:16 +0100
Message-Id: <175792986708.521391.13226361640238803389.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250815162655.121108-1-ben.horgan@arm.com>
References: <20250815162655.121108-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, ben.horgan@arm.com, james.morse@arm.com, tabba@google.com, vdonnefort@google.com, qperret@google.com, ryan.roberts@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 15 Aug 2025 17:26:55 +0100, Ben Horgan wrote:
> When running with transparent huge pages and CONFIG_NVHE_EL2_DEBUG then
> the debug checking in assert_host_shared_guest() fails on the launch of an
> np-guest. This WARN_ON() causes a panic and generates the stack below.
> 
> In __pkvm_host_relax_perms_guest() the debug checking assumes the mapping
> is a single page but it may be a block map. Update the checking so that
> the size is not checked and just assumes the correct size.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix debug checking for np-guests using huge mappings
      commit: 2ba972bf71cb71d2127ec6c3db1ceb6dd0c73173

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


