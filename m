Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB82D77F6;
	Wed,  1 Oct 2025 08:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759308935; cv=none; b=a0e/KCJG7+NbQaVyRug+8A9UFICfpGqPdBDOWeD7SEI9/YN+tFRjMdgfVqy5uUiW+McK6Fmosl1ZK3ZH/e2tGl8gCi3LelcMR/jVlJHxaXfMjTQ8PXg+tVwgzJDvVl+Ff/nmrkTYH6Pyq+YRa5cbLzgLH41YOC+BKQdVQg27CsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759308935; c=relaxed/simple;
	bh=wryoM0pYpUXsQEkqU0pa4KCIgDFGqs0LofSC+bJAj3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldqx52BZ3yX32W5lwBO77TIYdjJKCCOw+uFi0RU0rcJRiMjiKNjGQhq7sQawUFHbWimGFsfO1lSdIbgDOzJZYYfv+uV2zs1RzscpnNPHXj2jijFwAl7o3ibqEDtmddRvrHD+8dl/P9iB2APW82YE0IUhfW18ZdSonGNQzwGe22Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHL+q6yM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHL+q6yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D9AC4CEF4;
	Wed,  1 Oct 2025 08:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759308935;
	bh=wryoM0pYpUXsQEkqU0pa4KCIgDFGqs0LofSC+bJAj3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHL+q6yMo6fQWn+9jmpefGfwfcwBuA3EavvDxqJRyGNmSUNrffT0gWw456PGlo8Rp
	 Hk9ZuAla77ahah1RwXA/UjSA/0lztF0IJSicT+PYj9QB+Gn/ROHAKFYdTKMIUoUZY3
	 cem++1rW7r8ZwzvwHfKq3Hy/6HKcL3NYdX8iCW0jHXtHYS/8D6fSbM1oVtqRuaHNBE
	 pO3i7uN0Qc1zXvXX7Dp2iNLjAOdo8v0bjzfoNUowwO9ukvPc24VUMToDnEu5qhRD7+
	 23mdQAunfcxyl3ijnBxoivqQx+2RQL1aMLEkbVz4J84z9fdtHsYIf8G2kHnswEvVu2
	 a/dLN+1+WfPLQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3scX-0000000Akaz-0WpK;
	Wed, 01 Oct 2025 08:55:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Osama Abdelkader <osama.abdelkader@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Remove unreachable break after return
Date: Wed,  1 Oct 2025 09:55:27 +0100
Message-ID: <175930892727.3590435.8643027286411287206.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250930135621.162050-1-osama.abdelkader@gmail.com>
References: <20250930135621.162050-1-osama.abdelkader@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, osama.abdelkader@gmail.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 30 Sep 2025 16:56:21 +0300, Osama Abdelkader wrote:
> Remove an unnecessary 'break' statement that follows a 'return'
> in arch/arm64/kvm/at.c. The break is unreachable.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Remove unreachable break after return
      commit: 55eeaa24c9ac3a22f9c220500e23ee8b6ddff751

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


