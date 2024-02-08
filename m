Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C2762D4
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 13:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707398891; cv=none; b=RGOu2B4XuZD9CUsHStTNjji61rWMfrKfff+YNebxcOzUdo7kd4T0BlrF8HtW44R8+zxfVenIUkYaY5EUhNxJtPzSSOIbYbi3W5plzPUgx8myBbMGv+a5qQmHqesg1ofePueEjyo6+bMSfqB3qUfg1+FBFs2vdSZU1TM/7WaLG9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707398891; c=relaxed/simple;
	bh=gNIkqPKNhiBjCZQ8oBYht001bB4QZiycc1ANIM1dGzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gtqalb7jCBwc5UDF6IUYAFrx2QgGVnlZ5qY/dsnaGBvRvS2yeHy6cJri/mqrfQLPlFRYEY+Ly+xt/Fv4bmMvfXZOBU9g918I5KxrGHteK7MU7fcxenz21MKfXHCwwNl994TZYuNS4SiZ5GR78WIezSWFZz6wP1uViuPVtWfgdqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nso1E9Ae; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nso1E9Ae"
Date: Thu, 8 Feb 2024 13:28:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707398887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5GXASM88lSpru4mOfS9feCUAUHk/xaBVPwiBCs6tZso=;
	b=Nso1E9AeB7QJB9zlavDTtNgdXuA/FvvSO8ItEA69sNLuviA2zUvFZaQ5tpyqnT8+WDtojd
	JzNwv4JxIbRvg/qXPcx/dsEQtkNXSlTXte0zCDHAQ82lYL3un+eNenj2bCASSFZop3thlD
	1kzC5JrI4lpzC0H0SxK6Ze7SWpVje+s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: removed unused kern_hyp_va asm macro
Message-ID: <ZcTW43v46Z3oT4Qf@linux.dev>
References: <20240208105422.3444159-1-joey.gouly@arm.com>
 <20240208105422.3444159-3-joey.gouly@arm.com>
 <86jznf5dqm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jznf5dqm.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 08, 2024 at 12:42:25PM +0000, Marc Zyngier wrote:
> On Thu, 08 Feb 2024 10:54:22 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > The last usage of this macro was removed in:
> >     commit 5dc33bd199ca ("KVM: arm64: nVHE: Pass pointers consistently to hyp-init")
> > 
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h | 21 ---------------------
> >  1 file changed, 21 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index d248a7ae627a..961d4431654b 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -53,27 +53,6 @@
> >  
> >  #include <asm/alternative.h>
> >  
> > -/*
> > - * Convert a kernel VA into a HYP VA.
> > - * reg: VA to be converted.
> > - *
> > - * The actual code generation takes place in kvm_update_va_mask, and
> > - * the instructions below are only there to reserve the space and
> > - * perform the register allocation (kvm_update_va_mask uses the
> > - * specific registers encoded in the instructions).
> 
> Consider moving this comment to the C version instead of deleting it
> completely (the part about the register allocation is pretty crucial).
> 
> Oliver can probably fix this when applying it, and my previous Ack
> still stands.

Yeah -- this comment is still rather useful. I'll fix it up when I apply
the series.

-- 
Thanks,
Oliver
