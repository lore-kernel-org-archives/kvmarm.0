Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931313EFD00
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779979203; cv=none; b=sKQoRQ8wJDmPU7IT5KiC9SMUPKxbkDTcCAH8/Xgch9pUd0dORrWSDqOfIVLc+bu4K5bdFn1nBdMfrsAvoXRGZoyiwmyEyLA9b8X/pDQXTS+FnSd/Gh8yJgHyVAiiUxi+HLFNCW57fxtX/5Rt5W33d6VJ+RJ3o0M/iugXo2Jzr+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779979203; c=relaxed/simple;
	bh=FPxL+Y4CDV+4Xb+Gsr7Kh4lp4ilrQJ5GQvNmdDy2MJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkHijB4pbup2zYvtlyOn1oAthQcUkk6H3XVpr0w9EMqD8BhZHgVCTZOd8+l0gex1Sg577YqRsin78YGOofQwMPFvr0huXHNvkzc9VwrgMEbmmqSJHKonQUYJJdqjzoShg/CV0aIGCZFke5pr4ZvuI6u3pJO/cFbp47kameXg4sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IFMN3XxQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IFMN3XxQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A149C22BE;
	Thu, 28 May 2026 07:39:55 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AEAA3F905;
	Thu, 28 May 2026 07:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779979200; bh=FPxL+Y4CDV+4Xb+Gsr7Kh4lp4ilrQJ5GQvNmdDy2MJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IFMN3XxQ1OYeUKhOpN0qN/tjsPh+ECPdeOrPsG/e1OJT2Az0vjnKh+vSZIT5pdiAy
	 fjdTwIP/FM1jJmGkrLBhdvH4f+Wj0t1+OlxqLY5KoWxQuTkgSiRrHNU42xCZ06sXrO
	 5B/ECxbjB9WZxCVcIrhCX4J4Ak958quTDmPB39MU=
Date: Thu, 28 May 2026 15:39:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
Message-ID: <ahhTunyXYeU8gjEO@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com>
 <eea3a8de-c9b0-4cb4-9364-b3f9659f5278@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eea3a8de-c9b0-4cb4-9364-b3f9659f5278@arm.com>

On Thu, May 28, 2026 at 01:30:27PM +0100, Vladimir Murzin wrote:
> On 5/21/26 14:25, Mark Rutland wrote:

> > +static inline void __sme_load_za(struct sme_state *state, unsigned long svl)
>                                     ^
>                              Should it be const?

> > +static inline void sme_load_state(struct sme_state *state, bool zt)
>                                      ^
>                              Should it be const?

Yes in both cases!

Sorry about that; fixed locally now.

Mark.
