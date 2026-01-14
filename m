Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365CA38FEE3;
	Wed, 14 Jan 2026 11:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768389896; cv=none; b=SdnD8S5x8gPB3k15GOvE9Ogk4G8BW9l0b0ksQBpHuWyknjC7MYLjPpc50vQky4AWzlWQO0/9FOGWPWfNrwSBXyfeH9jRe4lalNWcB8DKN/8H3X5t4dYNEUpT3KvH/vCcH35iMLMhqdCSvK1I0ZUYO7rNmlzfoyVVGHnZFfhVvEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768389896; c=relaxed/simple;
	bh=iJLNoucZhPgroGfA+0z3zT8eafKTFprZmaAe4syhOrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N4n0/XxTUnUNEw+XzezpVPvZ9BvITboVOoV/HIF2fGIvFicfsVuvdoxKGQXudAIL0zAn4bKTvm+ms+KdJfEH+WiKKO36kiwYq+KwwZVIk6eflOxPUAgXcmoCGrXGUWaiJu0ENjdPqEVweXxPMHSBb3fBxKhbm3Ak6hRW0jj8VhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ctt8xlq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ctt8xlq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACD8C4CEF7;
	Wed, 14 Jan 2026 11:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768389895;
	bh=iJLNoucZhPgroGfA+0z3zT8eafKTFprZmaAe4syhOrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ctt8xlq+BMVDXDWYhbbvV39G7apVaVVDgd9wXOUbHuYlreHqZuXogAPj69y102szr
	 192Xcrhk1SM+OErZldUV/qHVC75Gqk+AJ0o6oN6hplccFDJTHFtN4ETiwjcvq1SMUP
	 FC/8UAJBuSTZk1SfZNS6+6kq7ZPAb5xWMXUHNMooOvbeE4Af4NDQQNTIcBTJX8canN
	 Z7Qq7KWeqXGH7/XMjaX2W0xZ499pFFF4AgDNEeCczvP730lqZOKcV1/Zf9bB2LELdF
	 V0dg4uDYQBd0T7p3OENomVI/+D8yG5d17yGXhxYQCQTfYGi8j5cWAitaloD1rqtMmr
	 GRkH8/Uv5hxtg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vfyzd-000000029Zc-1uug;
	Wed, 14 Jan 2026 11:24:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	oupton@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: fix missing <asm/stackpage/nvhe.h> include
Date: Wed, 14 Jan 2026 11:24:49 +0000
Message-ID: <176838987352.3448823.13539745930697394773.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260112160413.603493-1-ben.dooks@codethink.co.uk>
References: <20260112160413.603493-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, ben.dooks@codethink.co.uk, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, oupton@kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 12 Jan 2026 16:04:13 +0000, Ben Dooks wrote:
> Include <asm/stackpage/nvhe.h> for kvm_arm_hyp_stack_base
> declaration which fixes the following sparse warning:
> 
> arch/arm64/kvm/arm.c:63:1: warning: symbol 'kvm_arm_hyp_stack_base' was not declared. Should it be static?
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: fix missing <asm/stackpage/nvhe.h> include
      commit: 4b16ad0bf821d4aceb050e9f569dc329883f1c5b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


