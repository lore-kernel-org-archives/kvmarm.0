Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B853F6C2C
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782484629; cv=none; b=Qe71TVHYlKEtfVNfWPQk6v/uh3XSf12Gm42v17KChLHfHDDobLelJwNrMQEGTL64xoL8LdHsDPVWAmOqHii2Ev6KVSFgW/7ONqLbaOM1SnQEB+88cHvsoH8t0ho8w5KyYUVVad7MruA6Gw3WQGG+xj68ab7z41es87SPMrigu8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782484629; c=relaxed/simple;
	bh=sYHBKoeQBLDW1+h2a0g2z+3lGKhh5lF4r8GC2caMUao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwivJpGuJZUYvt/bpqd2YfPEJZNAsK4As5vUuPjcALpdjDhbBnq2CenZvQmF1vfgExogZghiCWTAeLPdIw0scwRx4U2XjAyoNdwwGfGjkumTBiRtlv+ZhlN4DrCmTEsrDrgVDiNBOIxiRiiL5LjPlZXBRLwvS4L7boKBlQTTID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tK0NRC7n; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tK0NRC7n"
Date: Fri, 26 Jun 2026 09:37:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782484626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mQ0p8wz0mfX3OjDlaW1+q5Mk90upe28fYXxWxeJRofg=;
	b=tK0NRC7nIe8yHBcgPPmlFcSiWGtpn637TfOhPAAWLT0aGu/7LiuN+cmipP6xgXoMYrHe6E
	BXWHEyBPMKwdSM1WACMpnNVpezYwLUYOJxJ1u8rmuCPB10/sdmVKwSbdWyuiPxS6w6ylxQ
	UUEZr/SlJCi3pMalYHd4Vc8NEmWmJKc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, jingzhangos@google.com, 
	alexandru.elisei@arm.com, Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1] arm64: update ESR_ELx definitions to
 match Linux kernel
Message-ID: <ggcgjlswla2t5eg6iuzm5lowiv32nzua3qocmqkmrfchibcx3n@3f3a6gi7grwh>
References: <20260422130820.4023122-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422130820.4023122-1-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 22, 2026 at 02:08:20PM +0100, Joey Gouly wrote:
...
> +#define ESR_ELx_FSC_MASK	(0x3F)

Linux calls this ESR_ELx_FSC. I've fixed it up on merge and applied to
https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew
