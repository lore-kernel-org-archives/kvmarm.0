Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45671388E72;
	Thu,  1 Oct 2026 11:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790854685; cv=none; b=j3F7cRxSC4MLkWRmCt/iDqSzfjU7sEaWe/16ZgJRfSFEzU39q/OnaM7ojGRvap4XuyAXcCMCzkmjuq5a/ScLXUFm2yfGXuaIBqLWqFCrQUZXSVlFB3SnPwZZmHGLRAvcv8010z30ZTF5mJnUit2mz1sqopYX0tagGKw2Jt4K5dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790854685; c=relaxed/simple;
	bh=+uTAAIuJ4cVZdZYoK/KXpFZRggMZT5MarFhidf6c9A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqP3cpSXXQnTbG1p0NXG6SO34CkJVmw7OriIAHO0oxW1gw6iY2t6lIQSlRNsw5g2skrtbRM6evy4wSzGhTCYkdhYQTVyZmJeHzKtIU+bmxCCr6IowsLzQxwBFjtlxT5RuIRtNzk3aXPizmxI7SdCzW6TgHuMmkD0pV45X3WYWz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owmb2avY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owmb2avY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854931F000FF;
	Thu,  1 Oct 2026 11:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854679;
	bh=+uTAAIuJ4cVZdZYoK/KXpFZRggMZT5MarFhidf6c9A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=owmb2avYwgYjpPDOgFaY4OK9bgZasHXnVO1SSc9RvVuEk25I43mulFVpU34i3MFQz
	 EVN4xJwdbpfoa7mxJL8k4wiIYyLIM71wFWczqwQn1C56JEg8DtzeVXuJ6HxmN/B5sB
	 3c4kJDgRckEQ9WzlvMBI7w65grL+t0C5oSi1aoB0ffhdbWC7jkrfQvZAVnOem+//rM
	 JPdF21oc0y15A2M1FOFS/mV0XnmGK4ryT+0gsUB+egdy2ZCIxSbvKqFUbWC052douM
	 +bYHCrzDWUYJaRL/9+/tlbrGeRx4tQot/0DdqDejT7EzIDOMBAj8Gze4fFnF5DSZNL
	 gHUXe10VLukjg==
Date: Thu, 1 Oct 2026 12:37:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 05/15] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Message-ID: <ar5D-SBtUCqAz0CM@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-5-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-5-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:15PM +0100, Mark Brown wrote:
> As per DDI 0487 R_WTXBY we need to manage PSTATE.EXLOCK when entering an
> exception, when the exception is entered from a lower EL the bit is cleared
> while if entering from the same EL it is set to GCSCR_ELx.EXLOCKEN.
> Implement this behaviour in enter_exception64().
>
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

I think this was just nits from v20, all LGTM so happy to re-tag:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo
