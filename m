Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A91CF7CE
	for <kvmarm@lists.linux.dev>; Wed,  4 Sep 2024 10:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725445873; cv=none; b=D0s+OCcFkIGceV54Or3E2in+HpD+ODbmhnEghbbaE1/2QE7UyeF0XsfSDy+6wa/+I3Q4mrEYD9RqP+HynWExqmwr+/GwyaJ397lT5BEz1Jo5Bhu93UxrYGN0/hcfvQSPsF0whalqfR9awJVSdtRWjGlo6uKwzAlGik8y3yzxd0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725445873; c=relaxed/simple;
	bh=yv0iiZG0Kyn4Al40nqXubRhpkBZN/vHgckwGLpDXWv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYfX6biNnc8EDP7xzBhqb5yCAe7dY80AMhO7jNowkgu0JHJNwNEduhX/NY0W3jHItO86oVhpIfCau15xe18bCXBDFGJCrTpk2m2ilXXqK0uHIeTxtSNAz0jLz9sB4XSfpYh3acoGUKU+ni5SWVYqEelqszGtASAfYZZQKzP+z70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a1K0DUpO; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a1K0DUpO"
Date: Wed, 4 Sep 2024 12:31:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725445868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VyKvNgtoMrVx3fAVtA4/OoVtytmNaDZAp4IyKrDyjcI=;
	b=a1K0DUpO8mmErOfKiPgYIgei6ZCFtp1C2g0grZ5qpQey1pE+U28UYPP/mvF2Yor9qCra6i
	DQMbXlZP2SpLxrunSfSiRNIcOqjlRzeD7CaCqH2l4S16/xYJ10yf3sYekwjJJoB9bYrsw4
	EOuiWCeXPXU5Y7KCOOnts/OmTGKGLB0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/3] Support cross compiling with clang
Message-ID: <20240904-b4568b20f98773096c0ebbf8@orel>
References: <20240903163046.869262-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903163046.869262-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 03, 2024 at 06:30:47PM GMT, Andrew Jones wrote:
> Modify configure to allow --cc=clang and a cross-prefix to be specified
> together (as well as --cflags). This allows compiling with clang, but
> using cross binutils for everything else, including the linker. So far
> tested on riscv 32- and 64-bit and aarch64 (with some hacks to the code
> to get it to compile - which is why there's no gitlab-ci patch for aarch64
> in this series). I suspect it should work for other architectures too.
> 
> Andrew Jones (3):
>   riscv: Drop mstrict-align
>   configure: Support cross compiling with clang
>   riscv: gitlab-ci: Add clang build tests
> 
>  .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
>  configure      | 11 ++++++++---
>  riscv/Makefile |  2 +-
>  3 files changed, 37 insertions(+), 4 deletions(-)
> 
> -- 
> 2.46.0

When compiling with clang and --config-efi I hit

lib/efi.c:342:29: error: field 'vendor' with variable sized type 'struct efi_vendor_dev_path' not at the end of a struct or class is a GNU extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
  342 |         struct efi_vendor_dev_path      vendor;
      |                                         ^
1 error generated.

Our efi code is exactly the same as the Linux code, but Linux avoids that
warning with -Wno-gnu. We could also add that to EFI_CFLAGS, but I think
I'll just add -Wno-gnu-variable-sized-type-not-at-end since I like seeing
these things as they come.

I'll send a v2 with a Makefile patch added.

Thanks,
drew
