Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B001C2447
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153408; cv=none; b=QAvptqFGc7s3odz0oNd+3psnMq4fGJYf9Q8ELSdbGz6SI0G/LrrxRGM1tRqSDny9u2T6DA+tdix6EnvkwJgUUdGsDxSbQLejIfMHXRe1pPIosvRMR2a4wF9fdaKdVmHWRagaqFXRU2Ghx7vkkTMHMwLadiGTooCbVGsakcBc1bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153408; c=relaxed/simple;
	bh=OiRhL5jlHUDrHhoi0/wnDMk5R/gMqYMIS18bOIwq+V8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=piHfhxU2twgzVlXEhoFJzb6zGqpzvNHYf1etIa2ZRJ8xvVJkEfo54fwJ5lUWjtaombPBlyPUOEPicZ/eBVW5MnFHIirrGOBR2mgxrHPOpJTqBeTJMNIaqGantRgmlLQ66e/NEFRHWGtbkXwj2Cfc2wdvOxWejBFbVA8/qsaa5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIx9ZbUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIx9ZbUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D358C4CEC3;
	Thu, 17 Oct 2024 08:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729153406;
	bh=OiRhL5jlHUDrHhoi0/wnDMk5R/gMqYMIS18bOIwq+V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIx9ZbUV+p7eqXu99xi05RPZRJqJbL+WdjQ6mmhDNwubtcryC4laLFy+fyMu+a/6t
	 5WmfcspMfiZ6xPGGOCyMTZglS0cZsw/ZBDj6ZsNgbnitayuVx1iKAO5qTwAwSb0rDw
	 vFf5Kx7NUgySSIyDMkRUCOYS+9fY5piqI9F4sO7UAUSqHlgoOxSVqnms/fY9M3RQZc
	 w70Hikq5WhwGthwIoSwxAt1KToQV1ZCavvPO3RWTfoChjL93NKSNdd2Q258NPC7lsb
	 F6AhZoV37OuUGiC1XyPBgqg0WsOhZB8FQRZKb9DtmYidZUQfNS1bVEfe9KoiKafDSw
	 rVyggZWe/PVAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t1Ln2-004MEs-KU;
	Thu, 17 Oct 2024 09:23:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Ensure VGIC is fully initialized before entering guest
Date: Thu, 17 Oct 2024 09:23:19 +0100
Message-Id: <172915337760.953359.3029869838538281479.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241017001947.2707312-1-oliver.upton@linux.dev>
References: <20241017001947.2707312-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 17 Oct 2024 00:19:45 +0000, Oliver Upton wrote:
> Fix for the race [*] that I had mentioned last week. The first patch
> isn't entirely necessary, but it gets rid of a bogus check that could've
> potentially raced with kvm_vgic_map_resources() as vgic_dist::ready is
> no longer protected with the config_lock.
> 
> Applies to kvmarm/fixes.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
      commit: 5978d4ec7e82ffc472ac2645601dd10b09e61b0f
[2/2] KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration
      commit: 78a00555550042ed77b33ace7423aced228b3b4e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


