Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A57129E6E
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747818560; cv=none; b=GuZTxJBlVrYSMx5cHbcAnQSdqPw0FeMYHC6gl5P36vxGtF6icIAsGOjRYvJVWiw++Z2DkpIgOL7mD1m5hw2XAdXg032qs8k0VF2Xf3SV3VZ9tgWV3mPBxalWLDMDpwoMpGfeOGlbBek3OIq+a2BqplYLG2DhhlMkb1kERrblyz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747818560; c=relaxed/simple;
	bh=rQWeD7Zv9S8lUfwgwcqjvMT3NtNYxB+ORXu2V9AzkaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JH/n1IsBzJyVmUJC7zJhj/uF5UtlCS3xh/FEzyP7xOqGhmlh14sVsv6LYMGZpee+tfwehlS4RX+RLYWlxzPB1NaZu8GZimHrILKsVSj/X3L0+G3LB//XZrXlG2n7xyKtJqv4QRPqRGuJDO2YsdWT+sIon077P5wdYiTQ7tTWeag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xn9Uwkn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xn9Uwkn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C42CC4CEE4;
	Wed, 21 May 2025 09:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747818555;
	bh=rQWeD7Zv9S8lUfwgwcqjvMT3NtNYxB+ORXu2V9AzkaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xn9Uwkn6mweXruw9RicrdMOuWK+snyHBEQ9ymv6cVIFJJ/n12Qbx4bthyH8LdXujB
	 kkiNJRLevZHe2P8JflQXN0pbI1S8mbqKt8SJbEJ1yIzedDS34lS6OgA3G2zk1sQDrb
	 CtZ/+6k4E5xJq085hXQDR43k5boJ80Tgg7XjyX53C40YNpPq56Su9gXZWd6RsFv2B3
	 O+Q8jhKk5Wamqn3DTpSJ4mXu5BnzNQYXzc4XgmNs+sukudYGMaFaCMThDvufi85PR+
	 A+/Tzuup5+JsPgnXmBW2WsGkuN/FafeRJvg2pIh9x+Q7vk6i+Y/o71h959EQ7yMwku
	 pPTgfrPf0e4gw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uHfRo-00GrlR-NR;
	Wed, 21 May 2025 10:09:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Hold mmu_lock when invalidating VNCR SW-TLB before translating
Date: Wed, 21 May 2025 10:09:09 +0100
Message-Id: <174781853950.4059800.1864401181776978793.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250520144116.3667978-1-maz@kernel.org>
References: <20250520144116.3667978-1-maz@kernel.org>
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

On Tue, 20 May 2025 15:41:16 +0100, Marc Zyngier wrote:
> When translating a VNCR translation fault, we start by marking the
> current SW-managed TLB as invalid, so that we can populate it
> in place. This is, however, done without the mmu_lock held.
> 
> A consequence of this is that another CPU dealing with TLBI
> emulation can observe a translation still flagged as valid, but
> with invalid walk results (such as pgshift being 0). Bad things
> can result from this, such as a BUG() in pgshift_level_to_ttl().
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: nv: Hold mmu_lock when invalidating VNCR SW-TLB before translating
      commit: d43548f422f27219eff5ce1897336af2c4f15091

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


