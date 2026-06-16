Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACEF47AF6E
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 18:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634604; cv=none; b=AegeTMlhcey64VGMOLpuvPe/dVa5+3UwalylaOsbuxXSmbsZjubjFMRzzxTcug5B92ZnY/xHpaIWmnULT4pJwa+zKzLKRSr1DMdC0tk3VhWHUeTus7J/gWzJObLmv69SU1FWevo9rDOzO+abE0ycTgonubSpXeYUfvgMwYfMtKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634604; c=relaxed/simple;
	bh=WcM56KEMBI/eo4oA+VeNcao2vPW2ZNhU0wR6yYCjGxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQlCpHZOrmfI49VxiRq3LCJedsQezHP0Gky+qUIWuEsdCUdSR5iVG+7gmv/rlhmedXzppW9meN1YzqYP1Iqny9JS2QQd0UA2l0OxNjo7umeM3TXaF1dn9rITdKy0j8q5/YCPHrGNCg96juw1SjDvFeKRw+naPOSIAsixylMrD2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z5B2Mrtj; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z5B2Mrtj"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c69fa0b1f8so10435ad.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 11:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781634603; x=1782239403; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cX4ssr4Y9/OOfcYZ2FcReQvMLH2Gq4SbTEa5005JITE=;
        b=Z5B2MrtjyF0ydRBpDyQXmKE/jKQEYY5UhR7zPT5oDTE8xqhPA5mIryGxl9BlXA588T
         kbdLpdzsnnUY4bZcAu95d6xdSVg/SukqYWoP/dbcbM30GA1DLQjpzIHWMK/txvLTnBkg
         DK7olHOSHZ03eHvN8mikpsuReyrWAGcyUcWWP+h6fsco3NPBXfehPWbHE3d/iV5XNmIe
         fU6ce3YZgbQTJJd10gPHUdb7N9ZZfrbPyKA2RzI9Js8v5hvQAnn2atce/NpHUo+uWjSA
         nExeHaKBa6xrZaJwRf3WVrM6K09rUKROYHm6my1uYsEQkqzgYZ54XJFTK/1zxIKyYm8C
         TVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781634603; x=1782239403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cX4ssr4Y9/OOfcYZ2FcReQvMLH2Gq4SbTEa5005JITE=;
        b=aohD0S1j/CVWAYQtvakG1U+9dCn+pKaPpqXZ8Fvf14SWz/dQWU74Q/O2BqxIZEXm/D
         uqrD67b8Dq1b5HoKQ0prO00tTnCbGh/sGC5vdlLjJ3fYGRUHnobUm2aRtpJdbDfV+7ct
         pX1fOaw/xi7NysvO8H8gzL3lpC76x/RIhfsBo76UTONM9xvyNHhOwQdIUqkK/OfmwYFK
         QEj4KzaSCiM50dJMkJJ1RB6BGYI3kloxnVwZRCiMn6ERheOr7LWxIGfVbp6kllMZQvt4
         /sh94aJKv8Ff7QEqVs1j3EoFDYk8+7PA8Ws3Hmz6h/ewgSwosS24TDjYAEinLEN+cP3p
         tHCw==
X-Forwarded-Encrypted: i=1; AFNElJ++sbNAada6vL9qyjND8tVv7DNvbZsXL8bKVL6CGcLLyZeHmcKhEofA9Cms6a6vEw/ss6Uruos=@lists.linux.dev
X-Gm-Message-State: AOJu0YzvQrBIccTvniJbbfyGoSqlg/wn6Fe/ligooKYfjeYiDqZy8lKe
	YfDdD6zDwlyAoJy33VrjGJUVnx+ddcR3neTj4DtJdlTO4dLCefpi+EAnqTGaiTP3Qw==
X-Gm-Gg: AfdE7ckwQ1uomxdL15B5TAy5EZgWu4MqlTwjByGXKkMRUBNUIWyCQccYgHUp7gUliVg
	wQ8wQbB3XS7opd4YfoP94uvUtsSAhPwAMiQVutq3XbQ7JLhstUJzKm60KwSNPRY4H3UTBR2UJZs
	EL3ntnzPN/SEUePSWsip7LmTmYsXg03efACarF0Mi9jCDRTePEkMHkc4CgPmjodE3pHVV3bPMdd
	8fmQpM88ysW8PY5ko/ZDX+jKnlTy6zSBLH7TzjLthPbvzEOoujp16r2qzH6qtUl7a2c3/QrYMU+
	QYkOdkylXZ/Y0kL/lVx9RTQ8DjKg0B2zadmjJWLkcf+J4sOSBnoKJQtsU8PRvL6ML7C326EyUDb
	mUR1mFptdUNxuexUOsqtBpUuPLnTtdfvQcaBKCPQNXdCk3c8KIR/feMcn2PtiJqSD2vnmd+kruJ
	hYdyStluq02TGcE3qDtO18HZxxAq7m/Px0TdRf4RwjgiR8lCc2sno8MUs00A==
X-Received: by 2002:a17:902:ce91:b0:2bd:7bec:f0e6 with SMTP id d9443c01a7336-2c6bbc6030fmr270055ad.1.1781634602099;
        Tue, 16 Jun 2026 11:30:02 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521aa047sm4617808a91.3.2026.06.16.11.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 11:30:01 -0700 (PDT)
Date: Tue, 16 Jun 2026 11:29:56 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, pbonzini@redhat.com, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	anup@brainfault.org, atish.patra@linux.dev, zhaotianrui@loongson.cn, 
	maobibo@loongson.cn, chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com
Subject: Re: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
Message-ID: <20260616175210.GA1675268.vipinsh@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com>
 <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
 <aisHySKe0PwM5DSg@google.com>
 <CAEvNRgE-qt8DAjOeE5ANpXzrgEKs+2_wh4YSmY=pe6krngBXqQ@mail.gmail.com>
 <aitbveI2Sdx4s4BP@google.com>
 <CAEvNRgFLnGkqvvks3joAwPjqLz=ATmqiS0UWk71g+YEsxNsfsg@mail.gmail.com>
 <aiycmwMbhWuYghJh@google.com>
 <CAEvNRgGkjcVN80W7cNd1-tEUXAfnFXEekokh_VbMDb9XdecVVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgGkjcVN80W7cNd1-tEUXAfnFXEekokh_VbMDb9XdecVVQ@mail.gmail.com>

On Tue, Jun 16, 2026 at 09:15:24AM -0700, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Jun 12, 2026, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >>
> >> > On Thu, Jun 11, 2026, Ackerley Tng wrote:
> >> >> Sean Christopherson <seanjc@google.com> writes:
> >> >>
> >> >> > On Wed, Jun 10, 2026, Ackerley Tng wrote:
> >> >> >> Vipin Sharma <vipinsh@google.com> writes:
> >> >> >> My (future) use case is that with hugepages, I want to run something
> >> >> >> like
> >> >> >>
> >> >> >>   ./guest_memfd_test --order=0
> >> >> >>   ./guest_memfd_test --order=9
> >> >> >>   ./guest_memfd_test --order=18
> >> >> >>
> >> >> >> And 0, 9 and 18 are the supported HugeTLB orders on the machine being
> >> >> >> tested. I'd like to iterate over supported HugeTLB orders at runner
> >> >> >> runtime instead of at build time.
> >> >> >
> >> >> > No.  The right way to handle this is to define testcases for the "interesting"
> >> >> > sizes, and then rely on the test itself to SKIP if the size is unsupported.  This
> >> >> > is no different than a test that requires EPT, or nested VMX, or nested SVM, etc.
> >> >>
> >> >> That should work too. So at build time I'd make it define all the
> >> >> possible HugeTLB sizes on every arch, and then skip as necessary.
> >> >
> >> > Not necessarily at "build time", the testcases can also come from your local
> >> > environment.
> >> >
> >> >> Why though, why not find the supported sizes at runtime?
> >> >
> >> > You can find the supported sizes at runtime, just not in the test runner.  I want
> >> > the runner itself to be largely oblivious to what's its running.  Disallowing
> >> > more or less _any_ test specific configuration/setup in the runner is the only
> >> > way I see of keeping the runner strictly focused on running tests/testcases.
> >>
> >> The runner should 100% focus on running tests, I think it's hard for the
> >> runner to avoid the process of test discovery though.
> >>
> >> The current test discovery process is to go down the tree of directories
> >> and find files, 1 file == 1 testcase. Each file should (statically)
> >> contain a single command.
> >>
> >> Since you're not opposed to runtime discovery of test cases, how about
> >> something like:
> >>
> >>     if the test case file has executable permissions
> >>         execute it and get back a list of test cases to be run.
> >
> > I don't hate it, but I still dislike the idea.  I am all in favor of runtime
> > *discovery* of testcases, but I am staunchly opposed to runtime *definition* of
> > testcases.

I don't think we should support this kind of usecase. Our goal is to
keep test runner as simple as possible. This will add one extra parsing
logic in the runner and also add more wrapper scripts in kvm selftests
for tests to create their own dynamic variants.

If dynamic variation is needed, then there is one option in this runner.
As testcases are executed by runner in a shell environment. This
basically means the test will run as a shell script and provide variable
expansion or call other terminal commands if present. One can define
interesting configuration which can be dynamic based on the host in a
testcase file. For example if one writes a test command as:

  dirty_log_perf_test -x 1 -v $(nproc) -i $(( (RANDOM % 5) + 2 ))

This will run above dirty_log_perf_test with the number of vCPUs equal
to the host CPU count and some randomly selected iteration count between
2 to 6.

This way one can provide interesting configurations which can test max
of a system in a separate test directory which can be invoked when
needed.

For predefined input values of a test, either one can write multiple
*.test files or use kselftest harness and add kselftest API based test
cases. Both option will still require that test should SKIP if something
needed is not present on the host as mentioned below.

> >
> > If I define guest_memfd testcases for 4KiB, 2MiB, and 1GiB pages, but the
> > underlying system only support 4KiB and 2MiB, then I want to see a SKIP for the
> > 1GiB testcase.  If the definition is dynamic, then the 1GiB testcase simply won't
> > exist.
> >
> 
> Seeing the SKIP is a huge advantage over dynamic definition. Thanks for
> explaining. Makes a lot of sense now to have everything defined statically.
> 

