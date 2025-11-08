Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC86134AB
	for <kvmarm@lists.linux.dev>; Sat,  8 Nov 2025 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762603144; cv=none; b=C0GNqL90lroHUuL1Lg2r7v8yvphsKu7VsKGnHZ0+KNpP/C6XLHpud7JAZGFhJduxk5RwyU0BxeCLjliAl/MRmFFyxmfuXPB9fpCyV7+Q1W7Vq3PiWKlvgMt3rlM6CnyZEcYWRjWfX8HUL8TmFj29kzH0JFBBgEj07HPxFdlcN28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762603144; c=relaxed/simple;
	bh=qEtlxgV/JD8Coq7HBGJK1HzPkeq6prIPvSIFTb3O24g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BOYgLmktTtC6ms6lcAmeRxmGofTlahMP4lIH293K2QQLPPcBz/SbplSdaN8ZIT28fNTQs9mMlEx6RIIoJvEL0s4VKkDvbpDds0n6YW7RZliDONuLu60Ao3+s+bBzQHLuc8LGLU04v2vZUF3l9yre0J2Ig0jHwh9X/SZhDNy4vBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lplG2b0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lplG2b0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BD4C19421;
	Sat,  8 Nov 2025 11:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762603144;
	bh=qEtlxgV/JD8Coq7HBGJK1HzPkeq6prIPvSIFTb3O24g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lplG2b0HaDMKDbumaUNTvnwFUTv3TDI9r/iaIzgmO+epweTuS3xdWNt/Zte0Y8gPs
	 j8xUn59R9yEhRZjPejheSlg4PjYh+EGfLi6pP07BfYqykpriK94ElT4iF43KQBA2NN
	 nBYTLSdupZjKQCpfU4ePLnqfTdHTI+lOntegAuYVruJyqaDof9elR+sCET4xdlnM0a
	 Zw7ZujXHYbRGCNeAp1p/5V5xUtcjFV/sl0aRwglxVvOcO7uUyns0J0eyV1YM/bQRK4
	 dEvSNv2Hj3AOY44qRaNVnASfETA16J6yhBqCu+r6siuI81g50Nc+4+GnoGtGs3Fe8S
	 c3obwdMQTxvfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vHhaw-00000003Tet-1PsZ;
	Sat, 08 Nov 2025 11:59:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: vgic-v3: Even more locking fun
Date: Sat,  8 Nov 2025 11:58:57 +0000
Message-ID: <176260313760.1201150.12533834837218904173.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251107184847.1784820-1-oupton@kernel.org>
References: <20251107184847.1784820-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 07 Nov 2025 10:48:45 -0800, Oliver Upton wrote:
> v1 => v2:
>  - Make iter_(un)mark_lpis() use of the LPI xarray also disable IRQs
>    (Zenghui)
>  - Fix failure path to drop xa_lock before calling xa_release() in
>    vgic_add_lpi() (Zenghui)
> 
> Oliver Upton (2):
>   KVM: arm64: vgic-v3: Reinstate IRQ lock ordering for LPI xarray
>   KVM: arm64: vgic-v3: Release reserved slot outside of lpi_xa's lock
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic-v3: Reinstate IRQ lock ordering for LPI xarray
      commit: 75360a9a338580990c1ee188d40a838c025bbd30
[2/2] KVM: arm64: vgic-v3: Release reserved slot outside of lpi_xa's lock
      commit: 66768669f27d98b45b20ed401cca913c387a9934

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


