Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7852BCF4C
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 16:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782146551; cv=none; b=VEytznEzieVb4JZJNC93q+oVrok0wqNyOgGnBbMIV+XLpAwVEsoaXC9XFz16d6uz2cL/9Y53C6z8avdsUCxMDTgc0teerJFtmlD4alI0fAYcrAglgr6Q59bHno/O+hyiBMq2oXR7FMaFPGz1AZgUWYK6pg+gSB9ef7BegTdKLz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782146551; c=relaxed/simple;
	bh=Hsihgo5dHYZsg2AWHDNElWtQuw5yJT42wrZkNqj/5ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ik9sHoAYuRiKMlFtRj6QDOks9RgN+Kn3SSbIneOr3y7b5iKNkVeELx39y3YsRGhCcNYFlRgPm0w+RHFZZ8VAQOK9zi87Qrso8WCGALTt6uuZNbLJxMOeqru+tc3bRZMqZgRWVUy6o/HUFYNKPjEopLfDfeuO78Nisl2JCupBx8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=degiRhtL; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="degiRhtL"
Date: Mon, 22 Jun 2026 11:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782146547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uYmKnUOduquw+47HDL0amZ+DE5jg8rj9YdEgKJDy2GI=;
	b=degiRhtL0C/2hxXmGNt3xr5e+inWh894uA2u3r1urEU+l20Qf+Oviq0x3p6lMKauG8z5WN
	0/X4bFZrbjMzFeQNUCTxHn9QJISQh9t/ojLc+6O3/Kq1e+FMC3S1X7lcG2z+YS5dnb4Ykc
	6LBORckuI/tj7huapWTShcUPrNsRIoU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, joey.gouly@arm.com, 
	maz@kernel.org, thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	imbrenda@linux.ibm.com, marcorr@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2] arm: io: Set is_pl011_uart flag in
 ACPI initialization
Message-ID: <4go6wzmiz3bb25r36i6uyqz3dbjoij2b56q54iuymit5zxobsh@p3ausac7pn3f>
References: <20260619002505.669698-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619002505.669698-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 19, 2026 at 12:25:04AM +0000, Colton Lewis wrote:
> When booting via ACPI on ARM64, the SPCR table is parsed to initialize
> the console UART. However, the code was neglecting to set the
> is_pl011_uart flag. This caused __getchar() to fall back to treating
> the UART as a 16550A device, which fails on systems with a PL011.
> 
> Tests that wait for serial input (like its-migration) would hang
> indefinitely because __getchar() would always return -1.
> 
> Update uart0_init_acpi() to inspect the SPCR interface_type and set
> is_pl011_uart accordingly. Also define DBG2 macros for SPCR
> interface types in lib/acpi.h.
> 
> Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/bringup/acpi-debug-port-table#table-3-debug-port-types-and-subtypes
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Assisted-by: Gemini:gemini-3.1-pro
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
> v2:
>  - Align macro names with Linux kernel DBG2 definitions (Alexandru Elisei).
> 
> v1:
>  https://lore.kernel.org/r/20260513211624.2416284-1-coltonlewis@google.com
> 
>  lib/acpi.h   | 6 ++++++
>  lib/arm/io.c | 3 +++
>  2 files changed, 9 insertions(+)
>

Added

Fixes: 8c065edf33c0 ("lib/arm/io: Fix calling getchar() multiple times")

and queued, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew
