Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63C5368396;
	Thu, 30 Oct 2025 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761841424; cv=none; b=e2CiMzwkfqi/e1NH0fjAFIcWlu5X3jNbwua7WTRwxPIItinw8bZLgCRIz7Z6Qkb/miO/j4/xK4QR2P+SO9O1ku9ddF4NG1U3WBzvU97dJGi94/8LJMBZyJz1MslzUddbOJxZ15cvnZp3+eUDEfKSwwdDjA3q3at1W/IhdzqK848=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761841424; c=relaxed/simple;
	bh=QWMPQo2xAH0nVjguJgabX/CKiz1G+XFeSJIPZzq2RX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJlyeizXVR5eLTaaD4Gv7fzTCTRS4CW6IF8x0uxB3quAG8fmKyfIvy5oFMPcFiqfd/aAsZuDtSbQ8jYJiawsHnJ/upvndvSkb/sPhsyY5vsXwmF8BzK9woeviG/l9WYg8HTF3RoRq249V+E0VqU9ItWHeERlO+gBRdDlKOYDAH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lC2Qf7z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lC2Qf7z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51835C4CEF8;
	Thu, 30 Oct 2025 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761841424;
	bh=QWMPQo2xAH0nVjguJgabX/CKiz1G+XFeSJIPZzq2RX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lC2Qf7z3gzI4hcYBakTotXArYL+2a4IRhcLv37Duop1VcKGrYfMjGqwxyXmKgljIy
	 T1vvj1uVxs4U2hrwzYFO7yOV5/5NMs8E3JqvxeFdyvn5NRwZ6UvBDpBmg9AGSYk5OC
	 8U0KBCqTlBQ/cfmYoEh3szJ4u+7MvabgyL2di2MLM/q9Dby9GUu93zKOMvwpHWcpf5
	 K1MxvgjofTR+PRj5ZQLG3CMUX+QraE4nqGObZQt755y6KFINTsDgQXBZwGKXelZgue
	 +sRkDbSudpSR0W92FZ2axAUMg2NYSJy5AZwZspVkITKpxUaONsxEzmj30L/favqFzS
	 CWtuo57c4BZDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vEVR8-000000013BL-0vbN;
	Thu, 30 Oct 2025 16:23:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	will@kernel.org,
	catalin.marinas@arm.com,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	joey.gouly@arm.com,
	Sebastian Ene <sebastianene@google.com>
Cc: ayrton@google.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	vdonnefort@google.com,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Check the untrusted offset in FF-A memory share
Date: Thu, 30 Oct 2025 16:23:39 +0000
Message-ID: <176184141934.2037838.2419455993784869828.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017075710.2605118-1-sebastianene@google.com>
References: <20251017075710.2605118-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, will@kernel.org, catalin.marinas@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, joey.gouly@arm.com, sebastianene@google.com, ayrton@google.com, yuzenghui@huawei.com, qperret@google.com, vdonnefort@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 17 Oct 2025 07:57:10 +0000, Sebastian Ene wrote:
> Verify the offset to prevent OOB access in the hypervisor
> FF-A buffer in case an untrusted large enough value
> [U32_MAX - sizeof(struct ffa_composite_mem_region) + 1, U32_MAX]
> is set from the host kernel.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Check the untrusted offset in FF-A memory share
      commit: 103e17aac09cdd358133f9e00998b75d6c1f1518

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


