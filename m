Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCDE235C01
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 23:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759879587; cv=none; b=GiSNUULCMYwUTGz18hWl8Y0Xiq20UxsfgHWexqnND4TMqKwI9gqe8pv8WQ5LVxCsaKrtf6VTO+v+az33nA2TlXKkK/pVcj8OPCnKfKtmOviYdsGaAfRIg13Y8bFLqRri5kDyMj6M+xxo1EgqtQsTfoaXJFPgFyA9jBljnlm1vKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759879587; c=relaxed/simple;
	bh=x9Hj7pps/DCj63r8ZU2YP6qTMJf1vzu9l3cbjHgb0GM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3wq5M8rAZIobr6eOognOr2dYdVWCvSzJ/T20o+z4DB4rFSZQPRAzKIr8rFXcF5+yw2gDlJU+SYEFfnaiKRLApHq+m7Vc2snyMlIw+VDjHpMNAIbA9VT06Qp4uwF9YQ06vfC684gBvTnbA8CZrYuaQYVH2Z2YgMbPvVvbc4C7tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FS8QTTiF; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FS8QTTiF"
Date: Tue, 7 Oct 2025 16:26:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759879582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g03LvFQRmEMkNtv8DIpDALsz8Mtogbh+FxF6LYdiL5Y=;
	b=FS8QTTiF6ggBAVHhyzBsWz22l74ZvpkuB84cxa5A7K2zFbb2TOxID3KzvNQducnHcZKSzW
	jWT3+Rqmt5V+//jJJGTec2m4PMpxfZ99RUGNJiEq7544d44ArQbQuszqH/4uIdF1qQjMMT
	QQVKtQ4WdAmhB/KnN9c5iOiy6sEp/DI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jan Kotas <jank@cadence.com>
Cc: Marc Zyngier <maz@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Message-ID: <aOWhlvC1kROWfMSv@linux.dev>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org>
 <aNXGW8C_S1TbFR9-@linux.dev>
 <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 07, 2025 at 11:12:31AM +0000, Jan Kotas wrote:
> Hello,
> 
> I was finally able to do some validation, sorry for a long delay.

No worries, thanks for testing.

> First I applied the "Don't advance PC" patch on top of 6.16.9.
> It fixed the error message, but the Guest didn’t boot.
> I didn’t debug it further.
> 
> Then I applied it on top of 6.17 along with Oliver’s second patch.
> Guest OS stops booting because of an exception, when accessing ZCR_EL2.
> 
> I checked the ESR_EL2 register and it has 0x66000000:
> 
> Access to SVE functionality trapped as a result of CPACR_EL1.ZEN,
> CPTR_EL2.ZEN, CPTR_EL2.TZ, or CPTR_EL3.EZ
> 
> I’ll continue the debug to make sure the issue is not on our end.

Could you please share the repro steps? Also, is the guest kernel
unmodified? FWIW, I tested kvmarm/next as the kernel at all levels,
kvmtool as the VMM and E2H=RES1.

While the trap to L0 is unavoidable, reinjecting the SVE trap depends on
the L0 view of CPTR_EL2 which originates from the in-memory value.
Unless there's a bug lurking this should always be in agreement with the
effective value programmed in CPACR_EL1.

Thanks,
Oliver
