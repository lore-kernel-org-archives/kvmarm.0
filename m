Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9687E2144AF
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739444771; cv=none; b=YI66Qporql8OZA3xB1JX+MyEw35M7WsuhcUuEToV6ZPaUuaFbUJknxxDEwbw7UPJ9geDWhyONcAGQONoSSbdrQSd2r44o1h4zG/ujBoSGdu6vBR1vqbFMixAZbf2GuXzyY6erExt3Dl0/68/nXtO1gM8K2mZC5tT9I9MgQR2JXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739444771; c=relaxed/simple;
	bh=vzJhRKbm7doJ1xKI3GNgdwCsFtvU+/qRlVqY+hygGro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=If8FJ2V0z1nUgZFfvEaw9yVyCTyTgLEY1Vh8X25fHVg7IdCKkXxKTWoeGdRY+eaadtrv6g0Pa/TfvTWVCLm4CPhXyHdbWqzAL+lCRnBtDPOP1Pc3i+y4OyDWcRPRmzNcXFwI8ZlnwqIm8VDld9XORCliZdbXM9W3qEQZo5U+cuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iglMK53L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iglMK53L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B965C4CED1;
	Thu, 13 Feb 2025 11:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739444771;
	bh=vzJhRKbm7doJ1xKI3GNgdwCsFtvU+/qRlVqY+hygGro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iglMK53LnkSTqT+T9DhbWoF5uTSfMXJn2hxzXp/YgtSTvr0LdqIwPizvDhy6HAKh9
	 kD4QhKGc7sg9RhDHCw2J90OO/0Gvfo5HeG1UamBIkMTco9LY5Hjw9AA+0qpk+viJ6N
	 kkxqQDXD9oOvoaEl4/YRQE6ybU84RCeMURXRd5zQHct/MPvDx+4ENyQxbLaDXmbOzG
	 vA3pfXJH69AR9nfnFjdsEXIt1GbQ7XFRGJ8q2ov9hTO9RezG8yVIGmONVh82qQSCX5
	 70RqrLiVz249B4lzJL+azphYwGKY0aad6RJQVnrZuTmOTZURde7m55fq4zyuC71vfx
	 GDHIz6L8J62Gg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tiX2m-003eD6-G0;
	Thu, 13 Feb 2025 11:06:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Convert timer offset VA when accessed in HYP code
Date: Thu, 13 Feb 2025 11:06:04 +0000
Message-Id: <173944474879.2872565.11761069838298587953.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250212173454.2864462-1-maz@kernel.org>
References: <20250212173454.2864462-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, lkft@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 12 Feb 2025 17:34:54 +0000, Marc Zyngier wrote:
> Now that EL2 has gained some early timer emulation, it accesses
> the offsets pointed to by the timer structure, both of which
> live in the KVM structure.
> 
> Of course, these are *kernel* pointers, so the dereferencing
> of these pointers in non-kernel code must be itself be offset.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Convert timer offset VA when accessed in HYP code
      commit: 18ec0be672a4a27aa045cf692eeb1e180a202e0c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


