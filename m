Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77658224252
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125383; cv=none; b=L3Ca1tsQ76WilK9QlxFtaXf4K3kJXBwvh/p7V5uwEHB9uwpJA33bCCIulc+9oXNSUz0cnZniEOpzw/eED4YQVhKsGO9VkUNt5CoUyMUOdIqVx9imtdnrRZnIoMSPnRafl9Szp+ln7ip/NIW+w5YjBTRoM/si1+F8v8CuSNxwUfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125383; c=relaxed/simple;
	bh=hKIQn2AmjzJkfS19kPV+yKqQIH5fTddBLd+TxSXBe4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqcPT/5E2Z2SPM1Fbdz6GVZHrgQ3HqskYrPJUBvvorSEEDWr0v8B3BwnmVT3bDkBH2C/kGEWZufXGAQxa0s+9MftmFMefLFGMpw7jJR0JWT+d01CC0q0Nc5F3VeY3rG36EE+G9ZJ4aXi9vUDzCcF/3NrYF2UPDYE5zOvLm9mo/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jWgZoB9Z; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jWgZoB9Z"
Date: Tue, 8 Apr 2025 17:16:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744125378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LacdgywqLSBYsY784CiO0oEeShzu3LZMo9cSWTuvHgU=;
	b=jWgZoB9ZWmUEH22k/5xUlcB6ybN59fskmw309GhMFoeArvOT7/N0eMM4hW6LNkOGC99Oxu
	cedsvS2vxZAusZ/HCQydCtshxUlMvK/edQFx06mn+71m4hdDhCp11EB61ia1fMyKL5iAxF
	FoKzwkPItAQLtkBmjc9bpHonHlXqEV0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v4] arm64: Add basic MTE test
Message-ID: <20250408-cefcdc508a94fb29572228f4@orel>
References: <20250227152240.118721-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227152240.118721-1-vladimir.murzin@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 27, 2025 at 03:22:40PM +0000, Vladimir Murzin wrote:
> Test tag storage access and tag mismatch for different MTE modes.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arm/Makefile.arm64            |   8 +
>  arm/cstart64.S                |   4 +-
>  arm/mte.c                     | 313 ++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg             |  19 +++
>  lib/arm64/asm/mmu.h           |   1 +
>  lib/arm64/asm/pgtable-hwdef.h |   3 +
>  lib/arm64/asm/sysreg.h        |  14 ++
>  7 files changed, 361 insertions(+), 1 deletion(-)
>  create mode 100644 arm/mte.c
>

Merged through arm/queue.

Thanks,
drew
