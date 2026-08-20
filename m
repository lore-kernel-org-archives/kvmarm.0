Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEB4379C24
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268895; cv=none; b=bc7n5ZnAzUsHlfeHrterlOqelkBLm21KTlz8QOSHYF5SM7mnenGS5qcSSY6Ta0sB92sDXrg+ThHJutXauTw0NiskWpTCRzdOlmjej2b7f/jHLPK/kHvjI01g4MWO4H2wZJdygRKGMlIEE047gOMlpNCrB87egeV2oHXfAczyEYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268895; c=relaxed/simple;
	bh=5m/klP2vHwixD6wHT2BQQp8NENTfNe5t/LUi3+O4aL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZB9A46kQmRCume9zMgSfT1ZF51YuKuyiHcOpS5++G9I2vqaO1yGPG95l9pTFNcO1mVTF4LW5ZGCqxXGJHZprWaDITzab6dVKZo6hL7zPnyFdoZTgifqtQLE9zA5n9BNS3a1GfGP2PfI7RWMHs+R6qo/aKBw6xebFA5hzi0e2s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BZPGnmLo; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BZPGnmLo"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cede6375caso40745ad.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787268893; x=1787873693; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jfLGikGnd4S9+6yfPqbmN/NLYjJGhV8nPuxpkvVhdQ0=;
        b=BZPGnmLo9Wve/M6QU0oH4BbtYcGeeRtuy4Q1YIStOhzl5d1U668JsgYX3G7zPUMVdF
         t7DcD+G8bZfLmHLPa+XDWy0auxl5tWNeT1DA6kNbCeFOvSiZk2aU9HEImpwtsK9C5Qgp
         o4AuLVEYaOqrudd+b7sn7UmbsIDOkSxJw9XKtBEm8P6EuIIY3bMDjTRApzzRP2TeDOmF
         LyOQIBqGjHpaVX/BGtWvi3erPc4RBve9q1UN3/wtxL/X0JFDED9bw3o0A9bezK3II9iM
         44Y1XbIe2FrGOX3lFpJVMNQhQD/Mrh+HRYCCSwsem34CTxQR/81DasIbTh+qpmv9OFys
         rsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787268893; x=1787873693;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jfLGikGnd4S9+6yfPqbmN/NLYjJGhV8nPuxpkvVhdQ0=;
        b=jTKRGDIGrIFHV3ecS01CemIj7KdIk36EZ/4RBC8kgaMoCI9BU9/9pD/eM0Kl7uv9Gy
         21ZWTJNLWc2xBqSJ4g5fyfoFO1DIA53nnIMbSMVHkpvHwkgt4NTqxDgbnMmmdlo/6Smn
         Gj5ay7KA9B8bOa9CMg4EdIpPY64cGAHOifEFRd6LaErsBT3J0C91ogN8ezm7R8STG+ws
         FUSiPDS4uz67wCDdLAAYZFk0TVj7vOK94oH0qu7LrUtRdLYyz8jC8mP9M/Ydw60jj+sV
         T1t0sZrTyP316cJ1PNhvErv0uMdxlc94bnTOx+jxodl4WsgMXtYrlEe2y6GqaAJN0gNC
         Ee6w==
X-Forwarded-Encrypted: i=1; AHgh+RqHZdTIj/Lne50rxnIHQWsm5+BcxCMw36VU2jpmCmDeSOrf2fdxx4ZSLRc0wZYnkQNj055T4Vg=@lists.linux.dev
X-Gm-Message-State: AFuF++lQyI5kZOB+qXGWzU5Ip2EhHRMAspb31NQW9NIic6FAut2tDHUY
	pqQQmMVdM7ikZq2GLi1M0TULpM52n/8mk/fNwskPp5J842x27VYLoRHO4CGfk1Tzcg==
X-Gm-Gg: AR+sD10xcT3gdrSVezxHhW2o6x4fapDVGvj2QD17BDnv00Bne5AxhGwEZaH8pLr7o+I
	1lr/TrxpaCMz57njVjhvjY271cExMobu9Tdedsg4307YP6xPwd5AjcmjpaorcicHi3oehXyNc3M
	MTw1HdPa2+lWVepERVRDOTFsRzKalhpya4IlJT9LkNStGODBq/oFEqH+VtcObUS+7CZt/ITIP+9
	kAEs044SOyvFhb6mybJPDsH0TBiriXNCprvqdrG4pypd6TqUlk1wi2eGy0H4H8+S24N2Bo/guXz
	uWiKgENwqpdOS79WPEVPdp8UOqnM7i+pmto16Q7em5ejOh01LujvBaixC4VNpDLkvvqdJ6UQWWM
	At908dU/fSrWqTeg+PE26O0JrPEtJvcms5gGfUsd2fBYlpHX4gQJchIgdcARZuwi940JJGaglxt
	vzPCZkntXZD4hQvFf1M7iXtFnz0iCqqJWQ6OFtWUSzhDNZRfTM/MhnojX4dtRRouNHu8Q114DXl
	4tpjM3bETMZRgrA/ho16KPx+mRe0qSDiJp4
X-Received: by 2002:a17:903:26c5:b0:2d5:db3d:1a45 with SMTP id d9443c01a7336-2d64b497c99mr3853495ad.18.1787268892710;
        Thu, 20 Aug 2026 16:34:52 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c4b82e5csm644924a91.16.2026.08.20.16.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 16:34:51 -0700 (PDT)
Date: Thu, 20 Aug 2026 16:34:47 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: t@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com
Subject: Re: [PATCH v4 3/9] KVM: selftests: Add timeout option in selftests
 runner
Message-ID: <20260820233109.GD618052.vipinsh@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com>
 <20260331194202.1722082-4-vipinsh@google.com>
 <ampW2iHhp6EA21I5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ampW2iHhp6EA21I5@google.com>

On Wed, Jul 29, 2026 at 12:39:06PM -0700, Sean Christopherson wrote:
> On Tue, Mar 31, 2026, Vipin Sharma wrote:
> > Add a command line argument in KVM selftest runner to limit amount of
> > time (seconds) given to a test for execution. Kill the test if it
> > exceeds the given timeout. Define a new SelftestStatus.TIMED_OUT to
> > denote a selftest final result. Add terminal color for status messages
> > of timed out tests.
> > 
> > Set the default value of 120 seconds for all tests.
> > 
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  .../testing/selftests/kvm/runner/__main__.py  |  9 +++++-
> >  .../testing/selftests/kvm/runner/selftest.py  | 29 ++++++++++++-------
> >  .../selftests/kvm/runner/test_runner.py       |  2 +-
> >  3 files changed, 27 insertions(+), 13 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> > index 9b6c78e69c64..82c543d11c34 100644
> > --- a/tools/testing/selftests/kvm/runner/__main__.py
> > +++ b/tools/testing/selftests/kvm/runner/__main__.py
> > @@ -37,6 +37,11 @@ def cli():
> >                          default=".",
> >                          help="Finds the test executables in the given path. Default is the current directory.")
> >  
> > +    parser.add_argument("--timeout",
> > +                        default=120,
> > +                        type=int,
> > +                        help="Timeout, in seconds, before runner kills the running test. (Default: 120 seconds)")
> > +
> >      return parser.parse_args()
> >  
> >  
> > @@ -44,6 +49,7 @@ def setup_logging():
> >      class TerminalColorFormatter(logging.Formatter):
> >          reset = "\033[0m"
> >          red_bold = "\033[31;1m"
> > +        red = "\033[31;1m"
> >          green = "\033[32m"
> >          yellow = "\033[33m"
> >          blue = "\033[34m"
> > @@ -52,7 +58,8 @@ def setup_logging():
> >              SelftestStatus.PASSED: green,
> >              SelftestStatus.NO_RUN: blue,
> >              SelftestStatus.SKIPPED: yellow,
> > -            SelftestStatus.FAILED: red_bold
> > +            SelftestStatus.FAILED: red_bold,
> > +            SelftestStatus.TIMED_OUT: red
> 
> Responding here because it's easier to see...
> 
> In my experience, uniquely identifying segfaults can be super helpful, e.g. (with
> the stderr/stdout changes too).

Sounds good to me, patch below looks fine.

> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index 13f4cbea1fa7..93ce46e25caf 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -122,6 +122,7 @@ def setup_logging(args):
>              SelftestStatus.NO_RUN: blue,
>              SelftestStatus.SKIPPED: yellow,
>              SelftestStatus.FAILED: red_bold,
> +            SelftestStatus.SEGFAULT: red_bold,
>              SelftestStatus.TIMED_OUT: red
>          }
>  
> diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
> index 76c3e6d463ee..9ccdeef62a3e 100644
> --- a/tools/testing/selftests/kvm/runner/selftest.py
> +++ b/tools/testing/selftests/kvm/runner/selftest.py
> @@ -18,7 +18,8 @@ class SelftestStatus(enum.IntEnum):
>      NO_RUN = 22
>      SKIPPED = 23
>      FAILED = 24
> -    TIMED_OUT = 25
> +    SEGFAULT = 25
> +    TIMED_OUT = 26
>  
>      def __str__(self):
>          return str.__str__(self.name)
> @@ -63,6 +64,8 @@ class Selftest:
>                  self.status = SelftestStatus.PASSED
>              elif proc.returncode == 4:
>                  self.status = SelftestStatus.SKIPPED
> +            elif proc.returncode == 139:
> +                self.state = SelftestStatus.SEGFAULT
>              else:
>                  self.status = SelftestStatus.FAILED
>          except subprocess.TimeoutExpired as e:
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index 66a3c3711a8a..f06965c68520 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -21,6 +21,7 @@ class TestRunner:
>          self.print_stds = {
>              SelftestStatus.PASSED: args.print_passed,
>              SelftestStatus.FAILED: args.print_failed,
> +            SelftestStatus.SEGFAULT: args.print_failed,
>              SelftestStatus.SKIPPED: args.print_skipped,
>              SelftestStatus.TIMED_OUT: args.print_timed_out,
>              SelftestStatus.NO_RUN: args.print_no_run
> @@ -38,6 +39,7 @@ class TestRunner:
>          print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
>                  f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
>                  f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
> +                f"\033[31;1m Segfaults: {self.status[SelftestStatus.SEGFAULT]}" \
>                  f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
>                  f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
>                  f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m",
> @@ -47,10 +49,14 @@ class TestRunner:
>          print_level = self.print_stds.get(test_result.status, "full")
>  
>          print("\033[2K", end="\r", flush=True)
> -        if (print_level == "full" or print_level == "stdout"):
> +        if (print_level == "full"):
>              logger.info("*** stdout ***\n" + test_result.stdout)
> -        if (print_level == "full" or print_level == "stderr"):
>              logger.info("*** stderr ***\n" + test_result.stderr)
> +        elif (print_level == "stdout"):
> +            logger.info(test_result.stdout)
> +        elif (print_level == "stderr"):
> +            logger.info(test_result.stderr)
> +
>          if (print_level != "off"):
>              logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
