Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D099D3B4E9D
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 19:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785352186; cv=none; b=Pk3tvVonh2Yf73EJ877T7X+eLpCpi8Of/8QxfhLUMyd/d/xI02NUleg56nBKMTZ2uHHuoy2GqIK4ubtvXj+FCB8FgPoEL94ZC7ldHqTL/3W6e8fLelfyUVgS6wOJ9El7HbRRhvdrGxlORXjYIoeFhpvzfCj5a/64vMPmSrkIH6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785352186; c=relaxed/simple;
	bh=hNIhsvFq8wG6+0DC6AaTyfTe4s7ctnj612x+RgqzboI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LsJd58wbzI03/URzZlcYGVdNILq2PuuT0HoNC3gPmqb3LpJYp3gG2bJdOe15kMUzkaisIXRWkp1Wxml8zHfOREKw0oKX+J1WWwysoLlrWXFn1/eumD8cls9mw1mDVdjwElYwtn1vW503z+VZbzPFpyicn3/USDaYTj+r6U+PIdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P4/mDj16; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P4/mDj16"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8488ac68185so3017112b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785352184; x=1785956984; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+XMot+n6JciyNBBWBYdqJ5JavyhMGOvDIbDy5VtGrOA=;
        b=P4/mDj16EvDToYoDscsp19kKWgu41A6eo4Ed2qeRT7hCCKtTYSoAG2wOZ5owDZF5qj
         xOzeylee2AQCiPChJiIoLNSRDJPcOAykkhlv1FysE3yykoto3vJ18aJayqLkBzA2nq0j
         U/c8fEpaHPdZFGIgrSl6ogyyO6NRTIEY8p4YohMGyaSAJGJWD34hnnvjavrR30IB6TYW
         NtfNyQRnW25AgKv8/DRwikiEx9Ib03sBXdJ1SZ8rJ0xnFJLgqoxOZaGR1bGUTPX/Dcg8
         7QxrHJ0WGaM65cU/xDkpQzjLrRNt/Z+dBVCQuse/Mlcj+wc9HFAbxxKX1c/XOisIxoNm
         PLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785352184; x=1785956984;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+XMot+n6JciyNBBWBYdqJ5JavyhMGOvDIbDy5VtGrOA=;
        b=ReZpKujbXxZHnQlm0zY7kR75hn79Dbr7mGmx1FneR0nSZO0MSUQ3ET7fRdhQR1/hd9
         nE2ieQVsv1QB+rLO0THA53BPZVfHnH32GWwWNRR/LiDUYS37YXaShwJP8Vmu8S7cDt0R
         cHdprpGHBtykeE/D1dxWISvwsemUp3HF6WGs+ODszRS3c9BrA5BR46YivZPbT2xhauSQ
         MCWbaDeDUf1xIoW7VRvOqWcPfi0oBO9JVqcCjYgwjBNCaUMIz+htbT3YF5sYux0cK2I/
         mYT1aHpMUdUB2OBUlAVuiJKXp+99mZL2i9rsb5n2e01wL+r2Xy5Itg76yjlaLA7eFBIU
         sBCw==
X-Forwarded-Encrypted: i=1; AHgh+RoPEveDOFOi803h7pRYhWXj/JLorQj3a+cWukEXDArIcgz+3rwrMJDqkD7ZFTCMtWZTNKbFhPI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyc0YlMqGsHCmxgRamEPKPe3nDe07KOakelJSEoLtjDQr37clj5
	1+Y2ZQvysDHsOd0FbH5YHwZa9B1ee0quv137Xh7BNHRaklbnRy30XEFSIDfOhjnbPtR3OAIBzPm
	VdA/koQ==
X-Received: from pffz14.prod.google.com ([2002:aa7:990e:0:b0:848:49f6:6f5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9290:b0:848:88e6:95d3
 with SMTP id d2e1a72fcca58-84eba1ecb98mr1356b3a.72.1785352184010; Wed, 29 Jul
 2026 12:09:44 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:09:43 -0700
In-Reply-To: <20260331194202.1722082-10-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-10-vipinsh@google.com>
Message-ID: <ampP93AEMawDmv4E@google.com>
Subject: Re: [PATCH v4 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, anup@brainfault.org, atish.patra@linux.dev, 
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 31, 2026, Vipin Sharma wrote:
> +Generate Default Tests
> +======================
> +
> +Generate the default test case files using the provided make target::
> +
> +  # make tests_install
> +
> +This creates the ``testcases_default_gen`` directory containing ``default.test``
> +files. Each KVM selftest has a directory with a ``default.test`` file. This file
> +contains the executable path relative to the KVM selftest root directory
> +(``/tools/testing/selftests/kvm``). For example, the ``dirty_log_perf_test``
> +entry looks like::
> +
> +  # cat testcases_default_gen/dirty_log_perf_test/default.test
> +  dirty_log_perf_test
> +
> +In above testcase, the runner executes ``dirty_log_perf_test``. Testcase files
> +can provide extra arguments to the test::
> +
> +  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
> +  dirty_log_perf_test -x 2 -v 5 -i 10

This is obviously not about the default tests.

> +
> +In this case, the runner executes ``dirty_log_perf_test`` with the specified
> +options.
> +
> +Examples
> +========
> +
> +Display all options::
> +
> +  # python3 runner -h
> +
> +Run all default tests::
> +
> +  # python3 runner -d testcases_default_gen

s/testcases_default_gen/$(DEFAULT_TESTCASES), because the user (like me) might
change it.

Something like this, if we go testcases => install route?

Generate Default Tests
======================

Generate the default test case files using the provided make target::

  # make testcases

Create a ``$(INSTALL_PATH)/$(DEFAULT_TESTCASES)`` directory and a sub-directory
for each KVM selftest, and populate each selftest sub-directory with a
``default.test`` file, where ``default.test`` contains the unqualified
executable path.

For example, the ``dirty_log_perf_test`` entry looks like::

  # cat $(DEFAULT_TESTCASES)/dirty_log_perf_test/default.test
  dirty_log_perf_test

Note, the ``testcases`` target is dependent on the ``install`` target, i.e.
installing testcases will also run ``install``.

Testcase Syntax
===============

Testcase files can provide extra arguments to the test::

  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
  dirty_log_perf_test -x 2 -v 5 -i 10

In this case, the runner executes ``dirty_log_perf_test`` with the specified
options. 

Examples 
========

Display all options::

  # python3 runner -h

Run all default tests::

  # python3 runner -d $(DEFAULT_TESTCASES)

Run tests in parallel::

  # python3 runner -d $(DEFAULT_TESTCASES) -j 40

Print only passed test status and failed test stderr::

  # python3 runner -d $(DEFAULT_TESTCASES) --print-passed status \
  --print-failed stderr

Run test binaries from a different directory (e.g., out-of-tree builds)::

  # python3 runner -d $(DEFAULT_TESTCASES) -p /path/to/binaries

Save all test outputs (stdout, stderr, status) to a directory::

  # python3 runner -d $(DEFAULT_TESTCASES) -o test_outputs

Run specific testcase files::

  # python3 runner -t tests/dirty_log_perf_test/2slot_5vcpu_10iter.test

> +
> +Run tests in parallel::
> +
> +  # python3 runner -d testcases_default_gen -j 40
> +
> +Print only passed test status and failed test stderr::
> +
> +  # python3 runner -d testcases_default_gen --print-passed status \
> +  --print-failed stderr
> +
> +Run test binaries from a different directory (e.g., out-of-tree builds)::
> +
> +  # python3 runner -d testcases_default_gen -p /path/to/binaries
> +
> +Save all test outputs (stdout, stderr, status) to a directory::
> +
> +  # python3 runner -d testcases_default_gen -o test_outputs
> +
> +Run specific testcase files::
> +
> +  # python3 runner -t tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
> -- 
> 2.53.0.1118.gaef5881109-goog
> 
