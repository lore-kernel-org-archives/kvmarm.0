Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD7814388B;
	Mon,  1 Jul 2024 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719834532; cv=none; b=NIjfuLe0KYsmvsWoNiTg4rUzpPBHiKEj5CRrLCKH1DdX9PZmT1v2MsSmIg8OE7RqGQIYOET1bVCD32PyBoskZy0OxVLy8LJPTH/n1ChDFI/So1LrQaONUZ4o2huT44acZwaKlI4j7ej05onQzmadbHVyjhHBeyPnNJVkIW8w70g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719834532; c=relaxed/simple;
	bh=FGSasi1X6d9H9NocHvxjWDtoMqp6R1Ug2tFx0cHB52k=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=da7DJ9Pk7/y7CCaxg+l0ar4EvHx+sej/mc+RppgV1P4nQIlQ0fqB0F1OuAHmaiDpd3N8n85Ohrpv+zf66f1oSLNN5WHSqykMvf65zU9N3A7FP/4rhLOWCgzny/dnDNe1WvbyC7EYsuf/e3GXzMn2UQe8PeyTkTcsfXyMxbEeeFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iecMrQa6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iecMrQa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F71C116B1;
	Mon,  1 Jul 2024 11:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719834531;
	bh=FGSasi1X6d9H9NocHvxjWDtoMqp6R1Ug2tFx0cHB52k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iecMrQa6ooDAEfgAMKPOMXxsRSH7X9Ii1FmGlimqtYmayWOhhSCmXoJveUmINRdUS
	 pPigKE6aT/Y4QLrv63T8fQWec7Bmp+7rZ/K4nY5W4zx7eI4aTmzN1dI5v9XV2jdj8U
	 i3LCJ/7lXZSN/Um0PwzLRr2xk82Mf3CO5cBxRFgHS6tnPcTLW3ZkNE/j+d9o7ubqmw
	 6uudVJxONK6/cxZTbORtw9xJu63smdGEKUfWK2u8xQrEGkcfYGfP3/HQeM/S8Meyr5
	 BsdeBjn91pvvldebRBhItXlaKO95M8CmLHjVbZq+gKV12g2/3EXD1tXllzRvJF/rUo
	 Cl0lvwXogw5PA==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sOFWb-008m5s-JJ;
	Mon, 01 Jul 2024 12:48:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 01 Jul 2024 12:48:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
 ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] KVM: arm64: Replace custom macros with fields from
 ID_AA64PFR0_EL1
In-Reply-To: <20240613102710.3295108-2-anshuman.khandual@arm.com>
References: <20240613102710.3295108-1-anshuman.khandual@arm.com>
 <20240613102710.3295108-2-anshuman.khandual@arm.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <0c0b5e903874704de7b49265596fff88@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, ryan.roberts@arm.com, oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2024-06-13 11:27, Anshuman Khandual wrote:
> This replaces custom macros usage (i.e ID_AA64PFR0_EL1_ELx_64BIT_ONLY 
> and
> ID_AA64PFR0_EL1_ELx_32BIT_64BIT) and instead directly uses register 
> fields
> from ID_AA64PFR0_EL1 sysreg definition.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
