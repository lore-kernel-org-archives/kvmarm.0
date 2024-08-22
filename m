Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9D326AC1
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346472; cv=none; b=reIrRebHiYnNEG9X2GaO73sg0MIjvTS8tsyDL8MJeUCjpneRFutmJ2KAue+kgtWLgN886BtOoobxUKwbcfqJqALQ4fFl50VWOyOOXFXhykHorGIyNsEYhyCJKURLkeRsXu8O4kVrJKOJ/CpMcUILQVpL7UbtV57E2X0NLRp6x7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346472; c=relaxed/simple;
	bh=abNbRCmvXLH/Tfykdx5aUA/V33nTyAAVIElYlJpE8Xk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQ7laMQX4Ulvi79XQAUm3fO3VSnNyAniCqqMlZfCigRKMQd7nq++x6e0ARuIc+meg6xt4OBqtQr6rG+H651Sby3LLE6Tfes5+5BUo+ZeYz4e/EushOfzbQ+zSLW4sJ4C9n7UTVrkJV6DR3VdtazXUtnDOpF1aWy5JFOfDHlK9bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsrTe/Ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsrTe/Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3FDC32782;
	Thu, 22 Aug 2024 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724346471;
	bh=abNbRCmvXLH/Tfykdx5aUA/V33nTyAAVIElYlJpE8Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsrTe/AdRmuSs9A3QN/P0kL++3fx/3Z3m29xDI+Cfs+jwvQwX32ZIqOJmPGNFTtBs
	 ejZP8aJrMZxA2vKJORlj6px1vSSHcCVmUuJUTy28nq3jx9XCwSOk2pw/KHKMtveScB
	 qMt+yttTXcw4xQZs47+FQF0ps8MCcGveF4OzxbcO4WHnuggS4iw0F5NAcmXtuFDnXZ
	 7kzN0+FrO9MK7P8wVIS7v8vNA5yEoiuEe1+3aq1UB73CeZkI+75zm25YtQ8mn28yDk
	 pImp+HdxUDL65SCsqmn6QTHFLIr6nx35pspvf5i1SJdosQicwVWroBUARFOAcyLoeV
	 j5yPTMLQ9hd2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1shBHo-0061zY-VX;
	Thu, 22 Aug 2024 18:07:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: will@kernel.org,
	catalin.marinas@arm.com,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	linuxarm@huawei.com
Subject: Re: [PATCH v3] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1 writable from userspace
Date: Thu, 22 Aug 2024 18:07:44 +0100
Message-Id: <172434645587.3704052.425194410416640895.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240816132819.34316-1-shameerali.kolothum.thodi@huawei.com>
References: <20240816132819.34316-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, shameerali.kolothum.thodi@huawei.com, will@kernel.org, catalin.marinas@arm.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com, linuxarm@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 16 Aug 2024 14:28:19 +0100, Shameer Kolothum wrote:
> KVM exposes the OS double lock feature bit to Guests but returns
> RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
> systems where this feature differ. Add support to make this feature
> writable from userspace by setting the mask bit. While at it, set the
> mask bits for the exposed WRPs(Number of Watchpoints) as well.
> Also update the selftest to cover these fields.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1 writable from userspace
      commit: 980c41f554c3029ce4f99678c0cd95296212775f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


