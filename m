Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1241E1A3D
	for <kvmarm@lists.linux.dev>; Wed,  3 Jun 2026 09:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780478733; cv=none; b=bnCUlMv01DxhZtqK2/fMqs5Ez6P4fwhHrqFJMXaPsiuEoOQa9Mwx52rnja1AB02M/5j1SM9/KvHaG4VBNvJUgtF6/3r5ftPGizULzODXpveRLp1r+Hlu8xp4pKXj0Et55zfS4S8JPN9QyVDkZVuSdwV09V6CDewjOXKD0Tl65GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780478733; c=relaxed/simple;
	bh=NsTJnFO14678jH+MJDNJCWiRBgwV46oOz/dG2+avMjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GziUtVpC54usBXG5XsY+a3IY053knWtAlLQcdQJehW5SgJmShmNomwRHazXoJTEBZbGeTu5P88D8qpy+/FrHvey8RMSbbarZK/PP6VY0+r+33oVy8StlC0/+I5hPkK7QFKGjBPKmea5UTck7RiAymSUMpWpj3AZ8y+V3oEbBj+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=axQkMNIM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="axQkMNIM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D3D632E3;
	Wed,  3 Jun 2026 02:25:26 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA52E3F7D8;
	Wed,  3 Jun 2026 02:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780478731; bh=NsTJnFO14678jH+MJDNJCWiRBgwV46oOz/dG2+avMjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=axQkMNIMjPHK+jZE343ctM1yPWI8lFtfozF00JDJSCDBcNNpTUgGL8y7XW/RX4mpD
	 30lgjvV+hPV//CAFE30GmpbsfTk7H3azEpUHTvM8dMaarf6JqrrfjBcc1fRymtI4+W
	 TmmQ0aJgRA/dP+VJkNbOluR93IKx7KWyAfY0tyTM=
Date: Wed, 3 Jun 2026 10:25:23 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	vladimir.murzin@arm.com, will@kernel.org
Subject: Re: [PATCH v3 02/18] KVM: arm64: Don't override FFR save/restore
 argument
Message-ID: <ah_zAzgSBzQsZOOU@J2N7QTR9R3>
References: <20260602151150.925126-1-mark.rutland@arm.com>
 <20260602151150.925126-3-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602151150.925126-3-mark.rutland@arm.com>

On Tue, Jun 02, 2026 at 04:11:34PM +0100, Mark Rutland wrote:
>  SYM_FUNC_START(__sve_restore_state)
> -	mov	x2, #1
>  	sve_load 0, x1, x2, 3
>  	ret
>  SYM_FUNC_END(__sve_restore_state)
>  
>  SYM_FUNC_START(__sve_save_state)
> -	mov	x2, #1
>  	sve_save 0, x1, x2, 3
>  	ret
>  SYM_FUNC_END(__sve_save_state)

Sashiko pointed out that this change opens a type mismatch bug. Details
below; I'll send a v4 which fixes this since it's also a latent issue
elsewhere.

The function prototypes take the FFR parameter as a 32-bit int:

  void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr)
  void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr)

Per the AAPCS64 parameter passing rules, the callee is responsible for
widening values, and where a register contains a 32-bit argument, the
upper 32 bits of the register are permitted to contain arbitrary values.

The CBZ instructions in the sve_save and sve_load macros will consume
all 64 bits of x2, so depending on how the compiler generated the
'restore_ffr' or 'save_ffr' argument (and if the upper 32 bits happen to
be non-zero), it's possible that we'll attempt to save/restore FFR when
we shouldn't. In practice it's most likely the compiler will zero the
entire register when passing false, but the compiler isn't required to
do so.

The same issue exists in the sve_{save,load}_state() and
sme_{save,load}_state() functions before this series, and hence we
should fix that as a preparatory step for the sake of stable kernels.

We happened to avoid that issue in sve_flush_live() by virtue of passing
bool (which the caller has to pass as 0 or 1 specifically) and using tbz
on bit 0.

Mark.
