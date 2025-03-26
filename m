Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B63219A90
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743015109; cv=none; b=HkM+25haVl76U9jmRbHvv0NelmJdZfTpiFl3kwVxDLRQxmv4Zblfxc2ZTs1y1I6oDehKU7iobWJmSDsKTY9bXrtMUcz3xC/w/IdLGQULZKuahPBI5AFWBsR9jzy+0RISOCC6qtWJR0O+Kq4AHZHmH00tQDG4oXHI7EHD5hOfVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743015109; c=relaxed/simple;
	bh=lrUgJMih6ZTpw55f6DR9oOLtoyDL+/x9zkHA2LrqQw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBrsEbVcurUz4ejp4+wtbbpGzTDBJxMei8PfFrveJmipIJLTD4I17xKgsFyQCtxvkx5xB7+c2TmDuznoyts63Rs2BYPHGRm6ltvE2XtQCiMWtqppH5wst5C07V/ZYJ3FO6YwRUGue2lrB6Gv+JB0RStdEvtUGh6JISh3f9rL2ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MSZ7FCH4; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MSZ7FCH4"
Date: Wed, 26 Mar 2025 19:51:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743015104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voLt4fdXkebJ8L5qGd4jfGNS1skgHWQ+LCozPmJP+KU=;
	b=MSZ7FCH4Xov8R8XeH4gys0oHruqKkh9bTmrsyVLsIIO6DS06RHAmdvtLm3jLtsNmzDx3vs
	Fk09iJ8yU1xL+QQDBL4dynEcNxydkaLNMuMva01esQVZviti/FdEOsycKLf8xy5FNoZKRt
	I2jds9vfmYQybdHRoddC0bHmDmg7fBU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/5] arm64: Change the default QEMU CPU
 type to "max"
Message-ID: <20250326-adedac8bee1bcff68cb0b849@orel>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 25, 2025 at 04:00:28PM +0000, Jean-Philippe Brucker wrote:
> This is v3 of the series that cleans up the configure flags and sets the
> default CPU type to "max" on arm64, in order to test the latest Arm
> features.
> 
> Since v2 [1] I moved the CPU selection to ./configure, and improved the
> help text. Unfortunately I couldn't keep most of the Review tags since
> there were small changes all over.
> 
> [1] https://lore.kernel.org/all/20250314154904.3946484-2-jean-philippe@linaro.org/
> 
> Alexandru Elisei (3):
>   configure: arm64: Don't display 'aarch64' as the default architecture
>   configure: arm/arm64: Display the correct default processor
>   arm64: Implement the ./configure --processor option
> 
> Jean-Philippe Brucker (2):
>   configure: Add --qemu-cpu option
>   arm64: Use -cpu max as the default for TCG
> 
>  scripts/mkstandalone.sh |  3 ++-
>  arm/run                 | 15 ++++++-----
>  riscv/run               |  8 +++---
>  configure               | 55 +++++++++++++++++++++++++++++++++++------
>  arm/Makefile.arm        |  1 -
>  arm/Makefile.common     |  1 +
>  6 files changed, 63 insertions(+), 20 deletions(-)
> 
> -- 
> 2.49.0

Thanks Jean-Philippe. I'll let Alex and Eric give it another look, but
LGTM.

drew
