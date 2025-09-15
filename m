Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B99D224891
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757955214; cv=none; b=nS3eVO6SBBSclxTJNDcrMG3BEZklqF1+Yz0SbSeU4LaXRy3lIYS27YHQtsJwbnPOhmgLjecaAsuC1d0NOOtkaGoGWT0YWkKB1UrPgHfUIcv7enpT6Kw6e7HcSUl6wtyLjm72trLBRQcnAd1qjfoFVZGCV67JbmLCRSi01rxhfQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757955214; c=relaxed/simple;
	bh=mr8xIGCKnB4G5+8TaKxfsscKPKoQFGfQ1GJ3Zixoh1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmL77UE3NA+3bC4yXRi2sfqh+MEywOyRxiprqHq1IRRG2cceYv9zeJoaem0AjUX57eOVt34Qd/hahiLkkb6CNOFqnQ9TjvnrNvJDRVDf/kA59x54Cl3+8vY1Cxy/EJG7oesMAzboPdX+FWELclzLnDlskDETD9VqBuXlaxdZT8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0t4FdCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0t4FdCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AA7C4CEF1;
	Mon, 15 Sep 2025 16:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757955213;
	bh=mr8xIGCKnB4G5+8TaKxfsscKPKoQFGfQ1GJ3Zixoh1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0t4FdCPYoAMS0qiePdSzxlUy4bYXgvPVm9AkkdzHGgMNB2ehUk20gtEjPgZPpsQ0
	 XfToX+19n7fkRGseSXXsxkLj0bA5cIdR01fH40KBWHlnCCCHH+mFdgaxyHw0DtDEOq
	 dZ52gcJayhVjEDVjxl64jdBE7aMgsO3ysiA7FB4pyAXQHEzFRWCXEJro+IIhxa2YOW
	 jZ+joc7AMg2WHweYuJ0Y7ZxrL60gJO6p/NjrRZk4wtwRgsBAuYigbO4Almu5OCQ+2H
	 62x/K4utH1BxPUNP/HfVt73xoIwGFPRd6qbOnrG7zN2gCj2HFepJ2cFM1jFPZ0zMKe
	 CygUEu0mz6H1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyCSJ-00000006SZG-1Jin;
	Mon, 15 Sep 2025 16:53:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: Update stale comment for sanitise_mte_tags()
Date: Mon, 15 Sep 2025 17:53:28 +0100
Message-Id: <175795518947.664776.2321133557894998741.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915155234.196288-1-alexandru.elisei@arm.com>
References: <20250915155234.196288-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, pcc@google.com, catalin.marinas@arm.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 15 Sep 2025 16:52:34 +0100, Alexandru Elisei wrote:
> Commit c911f0d46879 ("KVM: arm64: permit all VM_MTE_ALLOWED mappings
> with MTE enabled") allowed VM_SHARED VMAs in a VM with MTE enabled, so
> remove the comment to the contrary.
> 
> Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag initialisation")
> removed the race that can lead to tags being zeroed more than once when
> multiple threads attempt initialisation at the same time, so remove the
> comment about mmap_lock too. Note that sanitise_mte_tags() was never called
> with the mmap_lock held from user_mem_abort() and the race was prevented by
> kvm->mmu_lock.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Update stale comment for sanitise_mte_tags()
      commit: 597f41e1743882db32f99dde062adbec29104586

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


