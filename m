Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DF52E6CAB
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782485480; cv=none; b=JQVvb4QpuCxEEu56mC0/+SHL7ZtcKuQSJVXVbwUJIE1rcOtZv/O5lxZTHh8xi4gdN3xxj34LYB9o1NV5pU0NOnUIvDXndkhQkHQWkkbacuTcah8qRoF7T9vYG0ZCfPhLgs9Gsphwu3xReYEi4N3dlcqqtKOHc8L4b7dwZfBSs/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782485480; c=relaxed/simple;
	bh=cM68SuMjZv2m3K7DEYYDc0slZUvqKGg6mUypY81WxgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taWppfIFcnk4KefmlXBTqNYtSBpuRipXHztOe96EH7y7ZCgF0H3Yk+jWvL3dkPja9a/NCjHdVzZLmVq70kYUIMlWifmxqD0bsAYsmf1E7BcOkpbhfYJu58VUVt7/uY2EwZIKfPKBggyKsqFI6W4aBVwfdf4Qae/98CtSRhBYeXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PixD8Nff; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PixD8Nff"
Date: Fri, 26 Jun 2026 09:51:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782485477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=42ZF3w7QBbFMjR4/h/Ii596eOHocAtJ1W4fiiX9bgJQ=;
	b=PixD8Nff7pl1yzH+kW3xDqSwFblVlRH9zFQnHQKFFPpJf/iPseHyCihRZipPniCpDCnulP
	X3khtycEapjkyQdNqv/m3WOhpw+2nsBg7Mmri5/NFDGiaR2azPzase3kZueXvFj573Sdoh
	paeJxq44+U0daFkCe+XXTADoTm7kyCA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, joey.gouly@arm.com, 
	maz@kernel.org, thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	imbrenda@linux.ibm.com, marcorr@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2] arm: io: Set is_pl011_uart flag in
 ACPI initialization
Message-ID: <afz75mglpsbhr2rhny34k5tdk5ed4et3yu66goanxhkjwcwiae@2fqvntcnpxgk>
References: <20260619002505.669698-1-coltonlewis@google.com>
 <4go6wzmiz3bb25r36i6uyqz3dbjoij2b56q54iuymit5zxobsh@p3ausac7pn3f>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4go6wzmiz3bb25r36i6uyqz3dbjoij2b56q54iuymit5zxobsh@p3ausac7pn3f>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 22, 2026 at 11:42:28AM -0500, Andrew Jones wrote:
> On Fri, Jun 19, 2026 at 12:25:04AM +0000, Colton Lewis wrote:
> > When booting via ACPI on ARM64, the SPCR table is parsed to initialize
> > the console UART. However, the code was neglecting to set the
> > is_pl011_uart flag. This caused __getchar() to fall back to treating
> > the UART as a 16550A device, which fails on systems with a PL011.
> > 
> > Tests that wait for serial input (like its-migration) would hang
> > indefinitely because __getchar() would always return -1.
> > 
> > Update uart0_init_acpi() to inspect the SPCR interface_type and set
> > is_pl011_uart accordingly. Also define DBG2 macros for SPCR
> > interface types in lib/acpi.h.
> > 
> > Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/bringup/acpi-debug-port-table#table-3-debug-port-types-and-subtypes
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Assisted-by: Gemini:gemini-3.1-pro
> > Signed-off-by: Colton Lewis <coltonlewis@google.com>
> > ---
> > v2:
> >  - Align macro names with Linux kernel DBG2 definitions (Alexandru Elisei).
> > 
> > v1:
> >  https://lore.kernel.org/r/20260513211624.2416284-1-coltonlewis@google.com
> > 
> >  lib/acpi.h   | 6 ++++++
> >  lib/arm/io.c | 3 +++
> >  2 files changed, 9 insertions(+)
> >
> 
> Added
> 
> Fixes: 8c065edf33c0 ("lib/arm/io: Fix calling getchar() multiple times")
> 
> and queued, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue
>

Merged.

Thanks,
drew
