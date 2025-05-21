Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF36129E6E
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 09:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747818529; cv=none; b=aDRjY6PTnVkz+r/JfRNMVjBpAiKye0yIVX40ONgRbo4r/CeUVUN+ydZu8bLBYLtZKYwD9KeRmidhdX05VDy1im+8i5/Q+5hHP4pVSikU7Gsf8Aa8fmRXaMq5iDS7iD0fW53Cu4HFwLeUpZUQlQiqQGIH6bu1bE7va2w84eccLa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747818529; c=relaxed/simple;
	bh=Q8ICU0HW7kHVJWjIv6+77XsYzfgUxCqB0oF7lY2UNWw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZeFwZ/393ranMbkkq/hrUUMNST8MPEZKrqoHStrcbsN0IKMrGL1uwv1O5LqLWBgYwkaFLL6CjHOVZFtPstIrcPyvclZCYvym46zttO162zkbtRvdCZ/U8SElCmnJHWVyszE8k5VqSxIAozxLx2ramHscpk0JrIicuLF9oZIG58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vj/fm0Hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vj/fm0Hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA87C4CEE4;
	Wed, 21 May 2025 09:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747818529;
	bh=Q8ICU0HW7kHVJWjIv6+77XsYzfgUxCqB0oF7lY2UNWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vj/fm0Hu82tp28P2AwLohhiM6Cy6S2LVIJ3vloHt11uteg5LI6qt6mxud8ArjJzVy
	 gHTRele2W9LOj5Yf2AELLU7O3Oq3H4Sw6+/xcG0l8ckyzvnYlLRo5GLVakpv/GkqYy
	 +TizPivmuGtlPLEwc8VeMm9Y15WCzyylhlCVkSK600OVit+oAw191hS8ckg0VWJeWC
	 Cnq+ykSekqtfSt+XRGfkPWMzI5ekS4UAYhCWj9//P7R1FrxC+RtB4beTzrt2tLZ/gP
	 sKBQbyLU62zv7W8KmYsFYKj/QtRiMUHADq2EWVFnR2bwl/NRAfg3q0WDL+4EISWTPD
	 842g8YQLkwDJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uHfRO-00Grjx-JP;
	Wed, 21 May 2025 10:08:46 +0100
From: Marc Zyngier <maz@kernel.org>
To: KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Jing Zhang <jingzhangos@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: vgic-its: Add debugfs interface to expose ITS tables
Date: Wed, 21 May 2025 10:08:43 +0100
Message-Id: <174781851463.4059676.13869760892502643353.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220224247.2017205-1-jingzhangos@google.com>
References: <20250220224247.2017205-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, jingzhangos@google.com, oliver.upton@linux.dev, joey.gouly@arm.com, yuzenghui@huawei.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 20 Feb 2025 14:42:46 -0800, Jing Zhang wrote:
> This commit introduces a debugfs interface to display the contents of the
> VGIC Interrupt Translation Service (ITS) tables.
> 
> The ITS tables map Device/Event IDs to Interrupt IDs and target processors.
> Exposing this information through debugfs allows for easier inspection and
> debugging of the interrupt routing configuration.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: vgic-its: Add debugfs interface to expose ITS tables
      commit: 30deb51a677b96f0faf20373995fe0fb4a78b8b8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


