Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858E72153ED
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 09:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751965229; cv=none; b=eo5ecH1IWzSo0jhuOHPOKbeLXc/6RxEK37crVlR/Sj8z6Zmhq8imhe91/AeCmtHLdseBUp2kYaYn+BVc1jt8X9A4/PJDSCuMdFbkLRC5Hb+VVSG98bNGT1FFYMlbgQvYmZvixZNf0W+lk9mB5xfNJgLB3vLcoMYUO87y/vj9Uf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751965229; c=relaxed/simple;
	bh=Mw08V3r1vtYutAOvt3AQFC8ELsnBU/W7g2ucGWynMSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCrj24m5VOL8GRFakbX8ESzvDxnvgEHnb6sIRrangVdjjYH7TfSeecRff11cnm+ZLj564fJ3qjfPdcCGM6ZFssnXI6s6R/hgqm7jiusPkYXZgSeh9C74jmO07vz8TpYSkNugh2ScIMCMCkrqxV92aUEdT+JqksZt9QlBV+q5bMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cdRGwi3q; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cdRGwi3q"
Date: Tue, 8 Jul 2025 11:00:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751965224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AYV9Gt6GV7S1sBDMLX2bVdkgins9MvusBmTdZ9RaebQ=;
	b=cdRGwi3qrP6mufrMy4fWWBHQ3HqGIRKNF1wDZrd7mXiTELg0s6uKYWkcTWzAMTdOw/5BB2
	FlsHBIPnat+nXZ7FlUjM9MZ2wZZ4BRrDDP7IVwzglgU9jZbAuMsUJgMjTQFkj+Q6JGFYjQ
	xelBn8V3G41a0ravrFO21HNn58EtrWg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Cc: alexandru.elisei@arm.com, cleger@rivosinc.com, jesse@rivosinc.com, 
	jamestiotio@gmail.com, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] riscv: Add kvmtool support
Message-ID: <20250708-5524f73ffad755512205adc5@orel>
References: <20250704151254.100351-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704151254.100351-4-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 04, 2025 at 05:12:55PM +0200, Andrew Jones wrote:
> The first patch is for arm's scripts. It adds a check that I found
> useful on the riscv side. The second patch enables riscv to use
> kvmtool too.
> 
> Andrew Jones (2):
>   arm/arm64: Ensure proper host arch with kvmtool
>   riscv: Add kvmtool support
> 
>  README.md     |   7 ++--
>  arm/run       |   5 +++
>  configure     |  12 ++++--
>  riscv/efi/run |   6 +++
>  riscv/run     | 110 +++++++++++++++++++++++++++++++++++---------------
>  5 files changed, 101 insertions(+), 39 deletions(-)
> 
> -- 
> 2.49.0

Merged.

