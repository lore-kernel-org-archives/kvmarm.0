Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D4D484237
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823090; cv=none; b=LopwwJU9oD4Cv2LAZybGulimnasgSQ6Ns8SS3xBS7UEpl863LLKVrZVTvaxI26hDuzNks49qhLD4yjxCc6PvhT+nKSKtxLhTUsP1UryCU29QBy9Kc5bLGnTHG1PknoclWZ3+IuFj3Qg1slbPbV+ZTAKOxDMNOpzgOyIzB9c0hU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823090; c=relaxed/simple;
	bh=T3r4bWTwaBX3JLARqUj+GIjpQU0WmkYEJ0ruJpUNozc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWiR+SW2AxxRZBrzdrPiKGa5RiejAl4oRd7xlE3jiUNq5FVeWwOKPM2VZyT2gvc8AoMTSASXAK6mLAhmTliUOdMsnGpDbhQGAXbM1ljNSVnIJtHkmxQ5NFCkCtHi9chkLR+hOtJaUjURd3g10RaMUJtIuuxvnJUL4r3bwKdhsnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BY5ndC9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BY5ndC9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E9B1F00A3A;
	Thu, 23 Jul 2026 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784823088;
	bh=OUOMMMwQfpWkQuL5zRBMp7jRaM606M40dEn2DKXdTFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BY5ndC9e6eqpbogkfVicaynkK/X9u5jVfXDJ9lwTRKo0LQwFDTuqAjy7lkONiG/j9
	 cbuoF8vT8/wFU5rZFeTF3xE+pt5RgEyD0/7PEBIg9dHzLqIrusA2ga5bzyiQKSrD4V
	 iZ5/pJBHUpszfKZMvKrT80fk3LLlBT3yHTAUtTCloc3E46iaeR1BXm5SWN+GiQYWQ7
	 u/7b2VOFq4vtOk6ll3IOQWqWWcjlq8UBBixLVKYLwuEsmLX2yF2DTffVpizXUVxCrx
	 HvVeoZtKJ1GYzH9LCeEtG8RDAXQwtoXY9R1ZtUr2+Vw2JIXfMoyW/YW2vFfvTBaqpH
	 Rt3YSh/blp1UA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmw11-00000008734-1ATM;
	Thu, 23 Jul 2026 16:11:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2] KVM: arm64: Fix hyp_trace clock disabling
Date: Thu, 23 Jul 2026 17:11:16 +0100
Message-ID: <178482303773.3351010.6581445728887586605.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715105100.3178255-1-vdonnefort@google.com>
References: <20260715105100.3178255-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 15 Jul 2026 11:51:00 +0100, Vincent Donnefort wrote:
> Fix the disable path in hyp_trace_clock_enable(), which fell through to
> re-initialize and reschedule the clock after cancelling the work. Return
> early instead.
> 
> While at it, cleanup hyp_trace_clock::lock which is unused and
> hyp_trace_clock::running which is redundant: the trace_remote framework
> already serializes calls to the callback enable_tracing.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix hyp_trace clock disabling
      commit: bbece712cfc7f286b2908ac120dcf700279d87eb

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


