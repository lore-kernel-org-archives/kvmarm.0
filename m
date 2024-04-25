Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926AD80BFF
	for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714084902; cv=none; b=pcDT6jJahJ0TWgqRHZlQw1d/n3eL9wJL6AMovpyh3zdGqVWnJfWINFIysNea7yIMKpM/iOUgQuOu2Fkjz8v8KHNgcLApJN/XQuMy8HxenbsSujBhQmcZ+Q+S0OkkC7yhtR+6MiuR1p5n4ZMDxjZR6jGrvJ9682ECdD09JoE1Mfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714084902; c=relaxed/simple;
	bh=oIbf+AzJRKngb2p73mGFU+CuiAIWLnjaDZekQY9OMek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbta8w3Q579TkTgwx6h213ylTA4G8y/Q4qfdeJRQ1z96w8diCE/8mtgRwv8l8j+4bQcYIdMv7is91V6CeI2PjjflxTtAluOtgWnRTrz7bnU1AUSDz03FngxXVVbnAoyN84TyWnb3UEAiGBBAD+mdxe1ioYx6OkhNfanrfNigjXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=flIG79Ky; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="flIG79Ky"
Date: Thu, 25 Apr 2024 22:41:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714084898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GCaJfAPaJTJk4qPysJNwA1mMKwjvwJd7/RjWgxHGHyY=;
	b=flIG79Ky9avijT6lxv6ruTzaWrjTez3ao65sse6mEFWL42L71Fy+HwoaFDVgbhqSQc8Plc
	2zVls0Jn+yPxfrWHmLf2RsKd04+qj9yHIh5kAk1zeFvGngWMAknB7HIf4j1elRNjy/VQeD
	3uDkbrZxw2MMlKn7IbsrZ3Do8tWuOuc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH] KVM: selftest: Define _GNU_SOURCE for all selftests code
Message-ID: <ZircHEd4GZPApm21@linux.dev>
References: <20240423190308.2883084-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423190308.2883084-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 23, 2024 at 12:03:08PM -0700, Sean Christopherson wrote:
> Define _GNU_SOURCE is the base CFLAGS instead of relying on selftests to
> manually #define _GNU_SOURCE, which is repetitive and error prone.  E.g.
> kselftest_harness.h requires _GNU_SOURCE for asprintf(), but if a selftest
> includes kvm_test_harness.h after stdio.h, the include guards result in
> the effective version of stdio.h consumed by kvm_test_harness.h not
> defining asprintf():
> 
>   In file included from x86_64/fix_hypercall_test.c:12:
>   In file included from include/kvm_test_harness.h:11:
>  ../kselftest_harness.h:1169:2: error: call to undeclared function
>   'asprintf'; ISO C99 and later do not support implicit function declarations
>   [-Wimplicit-function-declaration]
>    1169 |         asprintf(&test_name, "%s%s%s.%s", f->name,
>         |         ^
> 
> When including the rseq selftest's "library" code, #undef _GNU_SOURCE so
> that rseq.c controls whether or not it wants to build with _GNU_SOURCE.
> 
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
