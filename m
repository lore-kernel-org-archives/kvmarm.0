Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E90366052
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823077; cv=none; b=qzlrCIbTDe5qTYRGCsyMsRNHLx1f+bxnN8fdAVXsoBeBfJyobbvm9+6BnBVviQZPlWv2fD/myjBFB7OOZ8Gg/x20CvgMtQ8PFrc7PGZPMthpGFZNHOMvgeIpBKouY8ry7JIOBTPLL0FJ8BbbT4X8bb/5rmD/lWozym8DHnjDgkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823077; c=relaxed/simple;
	bh=5SDbRiwMVyKTz+LqRJXGzj6ALWRSBn+4IUa38TMR/nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a19+34drKrpxyXC74pEcreMILuBgo6YWIzS1om3J+lSRbXQDmI/a8s41nLQfOLyTYUjTkcIQ2WXu6yPINo0BNwkG8aau32tFVuWd2uIlzL6FFmYHiF1Vkpyt/EHL4yROXT2SohM8jZAwF28woJHupHt2fRFYTJ5d7mMFmhbbBY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGZg3kF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGZg3kF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86B71F000E9;
	Thu, 23 Jul 2026 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784823076;
	bh=qOr5ljlsCVeZSINefwBYhyhG9tgMsXZ5YrKDjgTEp3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGZg3kF5RRE/dU4u8hgLFE7Ix1M/4LBFVq/cba/cFQn4j72rLx2A5gb0A0P5k0SaC
	 fRGweiuYPywAKiHt7Aqbz7u5Xvfcivcpl6enKOD9OukULeR/a0MeV5bGci7CggmyUz
	 ISHx49pH4Km/kElspV2HZO03ic4WS6VDHXFu6jA0lDzwtd16xLn+aXbKB1yzgZNiiU
	 gi+rBTptKCsnVjn0Hc796sZ6U7ATU6lwxJvgDwa7+WBppjbTO08txpdTPc8Qhykx2S
	 fwoTahA8SzGr2Q4XmpvPSvC/wGUiyX/HQup1twixgBUR3J5D9OOYscQwsmISAGkB0W
	 s+Lzw65QyYE0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmw0j-0000000871w-0mTO;
	Thu, 23 Jul 2026 16:11:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: steven.price@arm.com,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v4] KVM: arm64: Reject guest_memfd memslots when the VM has MTE
Date: Thu, 23 Jul 2026 17:10:57 +0100
Message-ID: <178482303779.3351010.2125689517087655754.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722090354.94245-1-alexandru.elisei@arm.com>
References: <20260722090354.94245-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, alexandru.elisei@arm.com, steven.price@arm.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 22 Jul 2026 10:03:54 +0100, Alexandru Elisei wrote:
> The user cannot use MTE on VMAs created by mapping a guest_memfd file,
> as arch_calc_vm_flag_bits() does not set VM_MTE_ALLOWED.
> 
> When creating a guest_memfd backed memslot,
> kvm_arch_prepare_memory_region() rejects the memslot if MTE is enabled for
> the VM and if guest_memfd has been mapped in a VMA that intersects the
> memslot.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Reject guest_memfd memslots when the VM has MTE
      commit: 679d7201c1f09e37fa1c12ce28d84079c17fc87f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


