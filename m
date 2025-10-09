Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5F328151E
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049078; cv=none; b=T3xeYmisEgmf5jJJZpaGIzMo0e62yVWTVLwVHyfvni5By2uTZ44hzZNIdsFyjNeoBILNCfDIRQ4zxHBA+Q6maDOCj+oRQhsPPDu4p89Kv0yNbqikZTFIHEGitMu/Ntc1Qj3EyH4FmnqZsSLN/0BIw8XXLH5TeBfIh0D1naDM8UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049078; c=relaxed/simple;
	bh=Yn2kvTm+mZNDuY39ANHX4G7xDC5i9BaIUGRte74CguA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JmS8gvSUqbqD+6wMAbWKJq5W+bwH4JniyAg6oMBS7ETRGjkKJEntZj+sW3PwSM3ZdjHbkdMOjg5/r+oeLyGrY8U1uu9UeNhLydJJBhYmQoLxZBWyHt1JdKL1dJsTpm7AP8h7oobi2TN/CDgdT/IL2SOz5f6HxM+3h3UmyKonmX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eEg6wdSA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eEg6wdSA"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so4453584a91.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 15:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049076; x=1760653876; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oyn4fVoh4cjthxckvqweX9TO6N78roW7lipNMYAXPf4=;
        b=eEg6wdSAMBYMpsLODvE7z8Oc1QbBWpvFLBXWqSRxYifRZVsiZ1/s7QZn+iRd1xCInv
         hrrM/lnP4uI3iSzseJUrgSuw8of3O2/NXlTvntPr2E+VASUCYEv0H89RTe6w0i6wf2c9
         M35uw0/ca/YDxdyAO39k+lqJdKO83r6LUutf1oXBtt7G0/LJ/bGIwX/0vwNpCDDyYot1
         P2h5iir1Vh7vAnbUwVsjpKdUZCa0qDjckVwRBDhr2Mtj4fIpKflqzK3kh1PTg4WX8Hiv
         yp52F5Qg8XkgoEEVHFsarlm/zcPZ4aVUy73ZNozJqy7sAe3XROtPD+lqjBLB4UXRAp4L
         QzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049076; x=1760653876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oyn4fVoh4cjthxckvqweX9TO6N78roW7lipNMYAXPf4=;
        b=WjLugBGJY2Bag9e7+7xZJMcNK21JEdxKPrh2PLPAeenPpZr6BeZKs5nutz0LlGgmLO
         TXwMahoH1bRBGiJ/4KIx5CV4cbnqR2JHr133Fr0Z1BKB0/sjDlYcm4HhydjH6vMqnrvZ
         F8MIcQ7qaKvnzgYWD0zPW6psRDgT7x2FjNP2L/sXckkkhfLGXjfgnTv/pdHenternMJK
         nb6dNOIFIqq4zKZtVznbLn2fFRmhnbIatxiR9Qhdc4ioUXjq8mqayAEYClvVdRQodA2F
         uxqcIEcbnhhygaw5sQWgDE9YW9ZktvJ4L0lP4bjkxCUeKMcBkbyHWKAe/qUGV0fyn5ou
         8c7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWhBkrnfbK6HC1spx1fS+fg4F17GU6v9cf5etUEnZIh0P25R1tBfymA8LEiW/laz0i5/85gw2M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzuSwycUUfQ8O6WyiBrSTmghl/anQKkoGz0Hnv92sXT+slKGPur
	XHtkFnujrnJdvPqutdhOWreHgOPY/XbHfv72y92Vegs31foQyIPtnWVb2KmIYGu0rhOwlsbdMpC
	eH5GbAvRrr6jnV9rX0Go7IYD29Q==
X-Google-Smtp-Source: AGHT+IEmelRZ9ZJu08/OiMaUmje11/Gsz4SbXx5oLReryhBGhZaItJQt2LKWHVGmxTYaiV6rsN3g3rToagNXnHp9Yg==
X-Received: from pjboa10.prod.google.com ([2002:a17:90b:1bca:b0:330:7dd8:2dc2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:268c:b0:330:6d5e:f17b with SMTP id 98e67ed59e1d1-33b513b3e20mr11757701a91.21.1760049076512;
 Thu, 09 Oct 2025 15:31:16 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:31:15 -0700
In-Reply-To: <20251007221420.344669-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-8-seanjc@google.com>
Message-ID: <diqzikgnhfm4.fsf@google.com>
Subject: Re: [PATCH v12 07/12] KVM: selftests: Report stacktraces SIGBUS,
 SIGSEGV, SIGILL, and SIGFPE by default
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Register handlers for signals for all selftests that are likely happen due
> to test (or kernel) bugs, and explicitly fail tests on unexpected signals
> so that users get a stack trace, i.e. don't have to go spelunking to do
> basic triage.
>
> Register the handlers as early as possible, to catch as many unexpected
> signals as possible, and also so that the common code doesn't clobber a
> handler that's installed by test (or arch) code.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I tested this with

diff --git i/tools/testing/selftests/kvm/guest_memfd_test.c w/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..f6de2a678bf99 100644
--- i/tools/testing/selftests/kvm/guest_memfd_test.c
+++ w/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -182,6 +182,8 @@ static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
        TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
        TEST_EXPECT_SIGBUS((void)READ_ONCE(mem[accessible_size]));
 
+       mem[accessible_size] = 0xdd;
+
        for (i = 0; i < accessible_size; i++)
                TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);

And got

==== Test Assertion Failure ====
  lib/kvm_util.c:2299: false
  pid=388 tid=388 errno=29 - Illegal seek
     1  0x000000000040a253: report_unexpected_signal at kvm_util.c:2299
     2  0x000000000042615f: sigaction at ??:?
     3  0x000000000040283f: test_fault_sigbus at guest_memfd_test.c:183 (discriminator 4)
     4  0x0000000000402c1c: test_fault_private at guest_memfd_test.c:200
     5   (inlined by) __test_guest_memfd at guest_memfd_test.c:376
     6  0x0000000000401e15: test_guest_memfd at guest_memfd_test.c:401
     7   (inlined by) main at guest_memfd_test.c:491
     8  0x000000000041ea03: __libc_start_call_main at libc-start.o:?
     9  0x0000000000420bac: __libc_start_main_impl at ??:?
    10  0x0000000000401fe0: _start at ??:?
  Unexpected SIGBUS (7)

I expected the line number to be 185 but the report says 183. Not sure
if this is a compiler issue or something caused by macros, or if it's
because of signals mess with the tracking of instruction execution.

Either way, this is a very useful test feature, thanks!

Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8b60b767224b..0c3a6a40d1a9 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2290,11 +2290,35 @@ __weak void kvm_selftest_arch_init(void)
>  {
>  }
>
> +static void report_unexpected_signal(int signum)
> +{
> +#define KVM_CASE_SIGNUM(sig)					\
> +	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
> +
> +	switch (signum) {
> +	KVM_CASE_SIGNUM(SIGBUS);
> +	KVM_CASE_SIGNUM(SIGSEGV);
> +	KVM_CASE_SIGNUM(SIGILL);
> +	KVM_CASE_SIGNUM(SIGFPE);
> +	default:
> +		TEST_FAIL("Unexpected signal %d\n", signum);
> +	}
> +}
> +
>  void __attribute((constructor)) kvm_selftest_init(void)
>  {
> +	struct sigaction sig_sa = {
> +		.sa_handler = report_unexpected_signal,
> +	};
> +
>  	/* Tell stdout not to buffer its content. */
>  	setbuf(stdout, NULL);
>
> +	sigaction(SIGBUS, &sig_sa, NULL);
> +	sigaction(SIGSEGV, &sig_sa, NULL);
> +	sigaction(SIGILL, &sig_sa, NULL);
> +	sigaction(SIGFPE, &sig_sa, NULL);
> +
>  	guest_random_seed = last_guest_seed = random();
>  	pr_info("Random seed: 0x%x\n", guest_random_seed);
>
> --
> 2.51.0.710.ga91ca5db03-goog
