Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E0B75809
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 10:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878118; cv=none; b=Y3KC184bW7b6FIOR9MIrUvAxmUi79SNe7bm3vKjdqrDZCvqyL9lwFGbPHZR998/eSOdB/IBFXbOOQF2sT7Yf8RNUsZgcBwJeR1ajv3KqhWymOukhTWvfyumfTugteYG0QqqthNWKmCglcDoznmT6ATA1h3c/0wTjC0SI+X8a7W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878118; c=relaxed/simple;
	bh=GeDBK0JlY/sKI5arszBnlEWbhL/ulKPkZIdTnjYk/IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hCHXE0QNcFYqj8x77nh2Ukt7jhXJJYpM/D2fRNK9NXxeLqxLvSZDFoqDdG2GwzoN2Ect1IdSNiZWsVMaffgzGqwTVtLEtXa2rcuK7IGTrS5QrtmUocPHFZE3T7tNxDC7+LXDIXGgHb3ys4LwdgGgip126rWvsp/HZFDJXp8Hfis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljfIYvot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljfIYvot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184571F000E9;
	Wed, 27 May 2026 10:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779878117;
	bh=E5FwMpqgi5opvx3+Z4IrpRGnIWohL5+9jNaT6GKo168=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljfIYvotYh64+qXVwcocQuGn6klVXrc3oa7e6uOZAp2jzAzV9AvaHB32u9ni+FOQu
	 Hck9Z1I8vzei/H0Pee86Y4cQ6FKKCNEqrv4wXZpR4CuyESRcze3w/KaiCv5NszAH9Q
	 47Jv8J22SagH6EPFl+j53Ih6l5/R1+FKVMqfB/F9O/YXTaS2N+h+4UmsUELNMLwtUN
	 7SsvkIoz62f/oneE3YmEmpHei9t5GpUQo2DozHPgfhG8YUuhf2qh5po7mez1d5dlcm
	 6bGMQ5teERiLFRQPp8fZSUmplt2PeUSCD+/+uGpn0H36LTukgKwT/I2LiiPbCvyJgS
	 s1+B5P6FC7Maw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSBbW-00000006dhm-3YCo;
	Wed, 27 May 2026 10:35:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Fix CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC
Date: Wed, 27 May 2026 11:35:11 +0100
Message-ID: <177987810336.1512096.911930782876644415.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520220830.273289-1-vdonnefort@google.com>
References: <20260520220830.273289-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org, vdonnefort@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 20 May 2026 23:08:30 +0100, Vincent Donnefort wrote:
> A typo in the config guard in __hyp_do_panic broke the stage-2 disabling
> and made backtraces for pKVM quite unreliable.
> 
> Fix that typo.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC
      commit: 373452ac0649846431ca0f88574a2fa6382d2045

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


