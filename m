Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8402B23534D
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097977; cv=none; b=kbEp1/LvQPfrx+R/hYpk1uj66QDmDc8S1MbJOv1rViYWRaUI/t0l9g1FJnnbZFzYP2DPCbyOzwrDM7CSLZa3U/Vt10NcNaIXIdLJzWM9MzkzXxTL4V7EP86OK453M+vI99ntkRV/rm5RUKR6jqMsPe8DSgcxJSjfzkJ2WUP1iOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097977; c=relaxed/simple;
	bh=/xPZTCZzCNuaaDNsgHugb6Xu5bYNi2rMFwbd7L507CQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i4U5WoVI9zbYRtLOciQYEB39ye6/R6DtreIkhJR3kHYU6xFdcTJLEb9pekPXlHGSDo6dvJ/M2ZBe1iM/uLQZ+3jyqDlUOj2g2Y34jjTMT1BggDxVJi0ItYbM7yiTLRWLEpJa6qdWhEPm9PjQIhOkj+BVQCIWIlxij0f8vAFKXOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4rDX9jxK; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4rDX9jxK"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31f4a9f67cso402623a12.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752097975; x=1752702775; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XTdASi6OvVTUFFgJuSQBI9XSgCI41XMYqPCdISt4Bfc=;
        b=4rDX9jxKTU8axPO78jD6+JWBdgCGrzs2n4mED2wb06MOCV1HY91J58DJXlrKvDbsPY
         IZbY742yAcDOsPf2AAfMIvFBWbyXHaGKsQA1wl8KRZvwp8r3CqqwC/NnVBThs+Sfx/WD
         /lCGkwYyjc4PWMh5mDoF7Ipgz8WMS4tc6NzOVJgvutuCwnqvaz7s6bOAeSTJ1aota4SP
         8MYtsBB4nauWin1npe8XDjUUAr0y/YQn3DNrnt5WIY50dAdZ7fJCChdPpee8mj3zqrJM
         nz/JAfjPSysunjQMKQY7Z8gSTX2dTFpQeX7V9usamb2DMThixrkmvdLlom4UIwSIa/vc
         XPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752097975; x=1752702775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTdASi6OvVTUFFgJuSQBI9XSgCI41XMYqPCdISt4Bfc=;
        b=F2JPMr7Ojh4Y5Od3755ul5k3Dco/kfJbe/uCQx8JmwJ4ok0kFxl0G6S9wnm8Mw89zP
         eiROjo3/TIHt2VNOKAnCWXmxtsTzcgNXFreMyd+4aC9P68h4pu2TZvDlZ26Z3ZmUNSr9
         U5ufOe3Y8Wvc2cN1fsx3Ivj+KU8K7oNoTWNodMG2nT+UV9VRr5+uPdZw0pnbSn00GwHU
         TvSOmMjEoqZ/FOL39n1FIMgMHjS8i/oNQqeT1vVfmL7CpsuObQlOHVNYGx+85TKG/6Aq
         4r9r0dM32kUo51rtdpplCDDpVZbVtB3+/7+ReOH9NYMCZgr65Igj0lnuafwg/90NVJRh
         P5rg==
X-Forwarded-Encrypted: i=1; AJvYcCX2K+ltbYsaeTKT++NKhDQtiKGOHg7c86CoeQu020PZhncWldDgcUl3e5iichIiixfI30BtkjE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDixJJeo3uhSLPysDLUzpifM21RhI9517Q4GuplXypwXcoXyLI
	PYM2xUt1h3vhcG5H5GtdUPU7mPOyEwZNkvNxnk27gc6APXBqR40BkkImUINlXwldp2lYsrrIUjf
	Y7YXW2A==
X-Google-Smtp-Source: AGHT+IFmEFlAWWCJkx2sQJoOnRz9L04dVDgiZhvskOboq7Is0Q/s9F5fo+EcgpfALlAli5CGcDY8mYpclV0=
X-Received: from pjbpq7.prod.google.com ([2002:a17:90b:3d87:b0:313:17cf:434f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d8b:b0:312:db8:dbd1
 with SMTP id 98e67ed59e1d1-31c3eeece0cmr314345a91.5.1752097974921; Wed, 09
 Jul 2025 14:52:54 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:52:53 -0700
In-Reply-To: <20250606235619.1841595-5-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-5-vipinsh@google.com>
Message-ID: <aG7ktaz8l4zrwPDX@google.com>
Subject: Re: [PATCH v2 04/15] KVM: selftests: Add option to save selftest
 runner output to a directory
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> -    def run(self):
> +    def _run(self, output=None, error=None):
>          run_args = {
>              "universal_newlines": True,
>              "shell": True,
> -            "capture_output": True,
>              "timeout": self.timeout,
>          }
>  
> +        if output is None and error is None:
> +            run_args.update({"capture_output": True})

The runner needs to check that its min version, whatever that ends up being, is
satisfied.

capture_output requires 3.7, but nothing in the runner actually checks that the
min version is met.  If you hadn't mentioned running into a problem with 3.6, I
don't know that I would have figured out what was going wrong all that quickly.

There's also no reason to use capture_output, which appears to be the only
3.7+ dependency.  Just pass subprocess.PIPE for stdout and stderr.

> +        else:
> +            run_args.update({"stdout": output, "stderr": error})
> +
>          proc = subprocess.run(self.command, **run_args)
>          return proc.returncode, proc.stdout, proc.stderr
> +
> +    def run(self):
> +        if self.output_dir is not None:
> +            pathlib.Path(self.output_dir).mkdir(parents=True, exist_ok=True)
> +
> +        output = None
> +        error = None
> +        with contextlib.ExitStack() as stack:
> +            if self.output_dir is not None:
> +                output_path = os.path.join(self.output_dir, "stdout")
> +                output = stack.enter_context(
> +                    open(output_path, encoding="utf-8", mode="w"))
> +
> +                error_path = os.path.join(self.output_dir, "stderr")
> +                error = stack.enter_context(
> +                    open(error_path, encoding="utf-8", mode="w"))
> +            return self._run(output, error)
> diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
> index 4c72108c47de..664958c693e5 100644
> --- a/tools/testing/selftests/kvm/runner/selftest.py
> +++ b/tools/testing/selftests/kvm/runner/selftest.py
> @@ -32,7 +32,7 @@ class Selftest:
>      Extract the test execution command from test file and executes it.
>      """
>  
> -    def __init__(self, test_path, executable_dir, timeout):
> +    def __init__(self, test_path, executable_dir, timeout, output_dir):
>          test_command = pathlib.Path(test_path).read_text().strip()
>          if not test_command:
>              raise ValueError("Empty test command in " + test_path)
> @@ -40,7 +40,11 @@ class Selftest:
>          test_command = os.path.join(executable_dir, test_command)
>          self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
>          self.test_path = test_path
> -        self.command = command.Command(test_command, timeout)
> +
> +        if output_dir is not None:
> +            output_dir = os.path.join(output_dir, test_path.lstrip("/"))
> +        self.command = command.Command(test_command, timeout, output_dir)
> +
>          self.status = SelftestStatus.NO_RUN
>          self.stdout = ""
>          self.stderr = ""
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index 1409e1cfe7d5..0501d77a9912 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -13,19 +13,22 @@ logger = logging.getLogger("runner")
>  class TestRunner:
>      def __init__(self, test_files, args):
>          self.tests = []
> +        self.output_dir = args.output
>  
>          for test_file in test_files:
> -            self.tests.append(Selftest(test_file, args.executable, args.timeout))
> +            self.tests.append(Selftest(test_file, args.executable,
> +                                       args.timeout, args.output))
>  
>      def _log_result(self, test_result):
>          logger.log(test_result.status,
>                     f"[{test_result.status}] {test_result.test_path}")

Previous patch, but I missed it there.  Print the *name* of the result, not the
integer, which is arbitrary magic.  i.e

        logger.log(test_result.status,
                   f"[{test_result.status.name}] {test_result.test_path}")

> -        logger.info("************** STDOUT BEGIN **************")
> -        logger.info(test_result.stdout)
> -        logger.info("************** STDOUT END **************")
> -        logger.info("************** STDERR BEGIN **************")
> -        logger.info(test_result.stderr)
> -        logger.info("************** STDERR END **************")
> +        if (self.output_dir is None):

Ugh.  I want both.  Recording to disk shouldn't prevent the user from seeing
real-time data.

Rather than redirect to a file, always pipe to stdout/stderr, and then simply
write to the appropriate files after the subprocess completes.  That'll also force
the issue on fixing a bug with timeouts, where the runner doesn't capture stdout
or stderr.

> +            logger.info("************** STDOUT BEGIN **************")
> +            logger.info(test_result.stdout)
> +            logger.info("************** STDOUT END **************")
> +            logger.info("************** STDERR BEGIN **************")
> +            logger.info(test_result.stderr)
> +            logger.info("************** STDERR END **************")

This is unnecessarily verbose.  The logger spits out a timestamp, just use that
to demarcate, e.g.

	logger.info("*** stdout ***\n" + test_result.stdout)
	logger.info("*** stderr ***\n" + test_result.stderr)

yields

14:52:29 | *** stdout ***
Random seed: 0x6b8b4567

14:52:29 | *** stderr ***
==== Test Assertion Failure ====
  x86/state_test.c:316: memcmp(&regs1, &regs2, sizeof(regs2))
  pid=168652 tid=168652 errno=4 - Interrupted system call
     1	0x0000000000402300: main at state_test.c:316 (discriminator 1)
     2	0x000000000041e413: __libc_start_call_main at libc-start.o:?
     3	0x00000000004205bc: __libc_start_main_impl at ??:?
     4	0x00000000004027a0: _start at ??:?
  Unexpected register values after vcpu_load_state; rdi: 7ff68b1f3040 rsi: 0

>  
>      def start(self):
>          ret = 0
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 
