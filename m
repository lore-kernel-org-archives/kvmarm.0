Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693F637F8B6;
	Fri,  6 Mar 2026 10:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772794103; cv=none; b=krOxU0KhkSbGnoeroRPj/EuhL6oqkC3/o3wzWGgURs4jgTJbs65UeXgfc0TFhoTNxYaw1lrqukkz7E4JtfsDYzFYhIqlhaLZjY+G1GIF9S64QtULZLg34hdBOK8n0Fct3v7E3xSkOVgtYFKg370EDCU/i6GAv9PnuQX0YiEu/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772794103; c=relaxed/simple;
	bh=MdElHuWuXCJux7zqmegpUP2Qfg6BCPRGxfz5Oung5eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRmZcdG2QeB+AcUbO4FO/pitB/GV0nEUw1SOv2oz+O3Fquev8wa9nCJVftG2HppmG5h124jp8cohTg+cL+Fb8CsqaxQbQ+YpaqOoUYJj5ByeT/pnuH2/JhvEDtpEmrqjZKbdYM5cFaZvgZ4mK423oq1513dhBA1hxObA00aOrYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWkIXjPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWkIXjPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01699C4CEF7;
	Fri,  6 Mar 2026 10:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772794103;
	bh=MdElHuWuXCJux7zqmegpUP2Qfg6BCPRGxfz5Oung5eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWkIXjPnPdH0SHTldhJPXKsQaMYFRSs2jegGWAt3uSTgeuKRbS8jDJ1Xl8nk7pinr
	 2tz2JYIx2x8S5YFGD23PAsbtIwO0RNDqeAJm9COClpgJc3nofEb4A5AboftsVa0LK3
	 /FkA9iFDmhccA30lxN+BKUJJAtWkmAvear8dtPeJyoMKN89DzX/0PA2kmaW3uZmoYU
	 h+6cxqmpWVRd0OlDLyywMCcu2M7kPxLpZnx08yFYwlXzGO/N34CwPQo848PslGtHGh
	 MQPddDCPoqMrjtkpprvuw097Rt2x3Ib8D/R40S20VrhDSS4bkq7kOl0DkuxA6P6axG
	 isOFuqI1hLCKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vySjE-0000000Gnnk-2qan;
	Fri, 06 Mar 2026 10:48:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	yangyicong@hisilicon.com,
	wangzhou1@hisilicon.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v1 0/2] KVM: arm64: Fix a couple of latent bugs in user_mem_abort()
Date: Fri,  6 Mar 2026 10:48:17 +0000
Message-ID: <177279406014.3200749.4050138870760336994.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304162222.836152-1-tabba@google.com>
References: <20260304162222.836152-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 04 Mar 2026 16:22:20 +0000, Fuad Tabba wrote:
> While digging into arch/arm64/kvm/mmu.c with the intention of finally
> refactoring user_mem_abort(), I ran into a couple of latent bugs that
> we should probably fix right now before attempting any major plumbing.
> 
> You might experience some deja-vu looking at the first patch. A while
> back (in 5f9466b50c1b), I fixed a struct page reference leak on an
> early error return in this exact same block. It turns out that another
> early exit was introduced later on (for exclusive/atomic faults), and it
> fell into the exact same trap of leaking the page.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Fix page leak in user_mem_abort() on atomic fault
      commit: e07fc9e2da91f6d9eeafa2961be9dc09d65ed633
[2/2] KVM: arm64: Fix vma_shift staleness on nested hwpoison path
      commit: 244acf1976b889b80b234982a70e9550c6f0bab7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


