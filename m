Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946A023534D
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098129; cv=none; b=F3Ij7TZmFxvdDc1X+CfLClfH+m+7QlFQNMftc/cJj1Dg+HZPM4HvZvYqEPjliSaQi2aRUmOYcW+zlA5jS/Rm6PFCBTqAYjnSXT20ETTrNX4GnJL7A/AGpdFngQOfJuxPQPr8XEvSxL3itJq/HNJZvkuBEn+cFiSlu0otBrTog4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098129; c=relaxed/simple;
	bh=+qjsBJLhpM1olxeer6ILy3R9POMXDh/s6Ahq8YqfhG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DfIAuz4SsRIgO9YdF9Viz38xXdWoWKLaNYdjXuLMYDKkdNU+3gi+uuT3flIGBWwnwWSHHGcbRden8GRgmkSANej0TS/IxsvfBPypC8MW1pKzIQt8KAXs3QZb83ToYw21/EzAzYfBAssSg7RPRzBrQM3WyJ1S3+sWP1RXA5mibX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aHrSa4hh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aHrSa4hh"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2356ce66d7cso4944785ad.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 14:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752098127; x=1752702927; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xbl942qlboFFMIegFraxpdF+FM9j3v0rANtDQn4ybbE=;
        b=aHrSa4hhBHio6etwkE+RgMxMyR0fGmymARgUNjiIUnIbY7Mxko9+waIpikQywzfgNa
         ch6qimjIqX75KmDDIYeZtfjkSWD1V92jp5FYXhUTq1Y8yWYzel/rPq8N9+Y2l8+S/Rm2
         o/yJZvrr8969XscfKf8FZiiF4B6iU4JM/F3kgcfOA2LoO5erCs7iYw7/Y3SxouyoXpZr
         +XIDBJaljoSJ3fZ8yokjoVYvFrnX7XMAKrYKSWQXesN9f1plzQK7liZE7MTucOwZMtmN
         J4YWF8xC/GzYaG8eMk1flxiMmI3i1+aZo0S3CxMCJHBNINXsV4X71N6kVc+GWzZx6qpy
         KLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752098127; x=1752702927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xbl942qlboFFMIegFraxpdF+FM9j3v0rANtDQn4ybbE=;
        b=A5lE20AGCeMFGU6t1/SBHoiuGhUzZQU1I/iYXEtbh55UuwULp6m0dkgVMz1cGOTbao
         lIn0zbYZv7fidoA7uLRUNxBEEMG8AUlPfjf8uvwig/21fE9GZqG+bR1CwWPIRvHQsGKm
         Z05GzyPyaigW5lEkgNXK0v6UVC6qB0GSOKuJT6cC60hJsHFDHaIwAaZYupKXF/yNQez5
         FPqw1EwHN39aEnPPPdQ2KtZ422q0g5Tj+ihAaYJyfnEX0TwlIax1wHYzo/As+q0oHXmI
         8FC6v8sB+iyVe+aaOKdSTb1baHwD6eyHgjOj4yUjfeR5u5c1BfIyu0IcWWtDAkgqlI/E
         H7Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWB2u+ScwA26gaBm7KxHWmCd8yX/5xkNgm5bzH35XgJep6ohgcLBsL8BSPkIYkrbC/YcrdPldw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAFeNX9ja2AcLPMuUmYJoTkb/6vnj2Fi3d6sHc4RiOwt5s6Hqm
	3fiT06LHSH6XmHsKgIFNWvJEGm1Rh+mWkunajoTlxdkZA9avXnTc/UprpdzVmWA8rQ9P2oMNp9j
	pNywg9g==
X-Google-Smtp-Source: AGHT+IF1wEjrFTfY6N7MTYPdwThi568/YkhVSNLJZftbK5IeWVpMVD+nKlM0Ig+cQGCrWJrZozYL3NOkd1E=
X-Received: from pjyd8.prod.google.com ([2002:a17:90a:dfc8:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b0f:b0:235:ea0d:ae10
 with SMTP id d9443c01a7336-23de47f8b60mr1057985ad.12.1752098126914; Wed, 09
 Jul 2025 14:55:26 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:55:25 -0700
In-Reply-To: <20250606235619.1841595-7-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-7-vipinsh@google.com>
Message-ID: <aG7lTY2ItIkfX7dm@google.com>
Subject: Re: [PATCH v2 06/15] KVM: selftests: Add a flag to print only test
 status in KVM Selftests run
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> Add a command line argument, --print-status, to limit content printed on
> terminal by default. When this flag is passed only print final status of
> tests i.e. passed, failed, timed out, etc.
> 
> Example:
>   python3 runner --test-dirs tests  --print-status
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/runner/__main__.py    | 5 +++++
>  tools/testing/selftests/kvm/runner/test_runner.py | 3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index 48d7ce00a097..3f11a20e76a9 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -59,6 +59,11 @@ def cli():
>                          type=int,
>                          help="Maximum number of tests that can be run concurrently. (Default: 1)")
>  
> +    parser.add_argument("--print-status",
> +                        action="store_true",
> +                        default=False,
> +                        help="Print only test's status and avoid printing stdout and stderr of the tests")
> +
>      return parser.parse_args()
>  
>  
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index 0a6e5e0ca0f5..474408fcab51 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -17,6 +17,7 @@ class TestRunner:
>          self.tests = []
>          self.output_dir = args.output
>          self.jobs = args.jobs
> +        self.print_status = args.print_status
>  
>          for test_file in test_files:
>              self.tests.append(Selftest(test_file, args.executable,
> @@ -29,7 +30,7 @@ class TestRunner:
>      def _log_result(self, test_result):
>          logger.log(test_result.status,
>                     f"[{test_result.status}] {test_result.test_path}")
> -        if (self.output_dir is None):
> +        if (self.output_dir is None and self.print_status is False):

This flag confused the hell out of me.  It's not at all obvious that it *reduces*
output, and that it overrides all the other --print-xxx options.  I see no reason
to provide this.  I suspect most users will want curated console information, or
none at all.

If we keep this, the runner should explicitly disallow --print-status with any
other --print-xxx option.

>              logger.info("************** STDOUT BEGIN **************")
>              logger.info(test_result.stdout)
>              logger.info("************** STDOUT END **************")
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 
