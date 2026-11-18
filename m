Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024389;
	b=RHQzGcwRlizxArrkSMrY7UCWI2A2bUesKAxOet34e1tHyRMa5ufSionjphocltcyv2TK
	 XDnvsppBb32Fd1p2UzXvUSMivDJjgPRHzYdm73kzYr0cc9cIsJif7ohFNkcU4qHJT0+I+
	 oWS8RYCZ+PlUDtl08u6BkWtus8iJ/tkCMYtdBx3OZ62pr0R3ZKXEx8WNRvhCm9EAMuZ+6
	 mRgGqiMJ9xMcboBU44s+q9jOT49xEMzGaP/8hZRrhC8QhzHuti6vCc2UNmYq+zD6d77uY
	 QE4xLNsrYC1ATdYAmomPVYYjDnVPj0j55m6kDAO+nn4mozPPoQLboaOx3pprCWa6afg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024389;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=mIvlMhQp2XPMKkyqstwBRddoJIhsg5ZvouNFjygJYDk=;
	b=zqyuLz01tJF+aWjDWSo2AqK/MkLb0/B+cp5yiimbyAcoD3BjFkgLlct9SqE27yiRowzt
	 pLI5kNM9uhetmruyrTa/nWtD+62bOxBYk/gcQzjydt74y0NjvMhgBfNUPKFxP9nc+QbIM
	 W6rePYviIOI2z9GpoFGdx0Dn0pBLlnY8XIGTX06+ti9x0frCJb/oQWag1TkMjsv2fHXZY
	 H8o+UJrKrwJNpp0mPhtCmkYbvqlgV53FIpwsHZYr2jAQt6KIIsCcg0exK6sykhjyIEffA
	 oIhVT8csPCRVu3VtJePee77u4v1XYZOd6bBmw362RrYhGsSedfk7Of0pWwlRK0Hazxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kKrkgOt9;
	arc=none smtp.remote-ip=91.218.175.19
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B988606A333
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B988606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kKrkgOt9
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+m7k99GokHGG2Xt0WNDUpUu/POJp/u8hXMkzLb7HkPI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795024385; v=1; x=1795629185;
 b=kKrkgOt9Z0+Uxd0OLSeRAMXHHLAwszcLDUbKbF12OkJtRBtdtWKPCEIzYjNBS/HTPbsasfAS
 uB5YRPSbid1q4JNdkyBI3GN/ci90xJ1VOlf8DjQgJu1KHxicG+32bBCr18ovse2tMz48PwuBhzD
 9MA0algsT312UDIoJhrsXcmk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 55e39e18abac30ad;
	Wed, 18 Nov 2026 17:53:05 +0000
X-Mizu-Trace-ID: 55e39e18abac30ad
X-Migadu-Flow: FLOW_OUT
Date: Wed, 18 Nov 2026 18:52:30 +0100
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Laurent Vivier <lvivier@redhat.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, 
	Chinmay Rath <rathc@linux.ibm.com>, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Amit Machhiwal <amachhiw@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] Move position-independant code flags into
 the target specific Makefiles
Message-ID: <av3l0ZC64ouIp4KN@orel>
References: <20261113120101.145183-1-thuth@redhat.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113120101.145183-1-thuth@redhat.com>

On Fri, Nov 13, 2026 at 01:01:01PM +0100, Thomas Huth wrote:
> The settings for position-independant code are currently quite a mess:
> It depends on the target whether we need the flags or rather should even
> disable PIC / PIE, but currently the settings are spread between the
> main Makefile (-fno-pic is the default, unless CONFIG_EFI has been set)
> and the target specific Makefiles.
> This leads to some weird situations where we have -fno-pic in the CFLAGS,
> but link with -pie in the LDFLAGS since we still want to get a relocation
> table, but then again need to add a "-z notext" to the linker flags to
> avoid warnings about relocation entries in the text segment.
> Let's face it: Always adding -fno-pic / -no-pie in the main Makefile is
> a bad idea. Move the settings to the target specific Makefiles instead
> where we know what we really want, and then we can finally drop the
> "-z notext" settings, too.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Makefile            | 6 +-----
>  arm/Makefile.arm    | 2 ++
>  arm/Makefile.arm64  | 3 +--
>  powerpc/Makefile    | 5 ++++-
>  riscv/Makefile      | 1 +
>  s390x/Makefile      | 3 +++
>  x86/Makefile.common | 5 +++++
>  7 files changed, 17 insertions(+), 8 deletions(-)
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>
