Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9003B3896
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353950; cv=none; b=jyW6U4gCOM65zMRB0gLwlGBRfJVIFGrjV7FSGhAI+2/T0Mxr5Pws89kBvGma3t7UVx1RzuAb7rW9AUurdQDUvnAE3IZ/faUKqhlEfVDXX+AeJ/yMOUQFS+ioRwaW3yfrAuADGIx2ZvDj/pFQgxO+z/0XOZGUx56kBrzLbioyJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353950; c=relaxed/simple;
	bh=uVsZg6LSMAWkJMOfgWmCb9JZEYXDTnvaEFxeC1Jcino=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=glpneX1AHX5EEugt8gK/qG6y3FnM8luYNpOue0uL0+Vxc41vYKBjKHsrS3EGEkfFMiwGbSmMyrpC41CMTJKUoqpgHTPUq50Lt+RHoNdbeyLV17KV2851r7Zs9he4K9gL6O1M4jQR2YB9TsSO40XKj26gYhJvWrYDiin7MnOYu2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bdCFsHD9; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bdCFsHD9"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so1056856a12.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785353947; x=1785958747; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yz+Y4cDmmkJFalPabDMm+ynUXO0OUxXd4k3RBua3jcw=;
        b=bdCFsHD9fpcBWe56q5YqusZwuHxPbZbyAYo06DExj5ykzBQGAxYvrDyMdzu9Rc9ChV
         C2mLv/YQ74bo6/0mABNaLZzeu1dP8LAJLoHSaubUheTPknxErx1euTmoLqMAwfZA0u8c
         gVu5Iq3IFaBCoPLILbE/WkkUxKujoNQd3LOjwGwwZ9F0mUV9Tz6acH1WXCJHZfNNN99w
         D/W8WHRaAnmOM7Td0fM0KkW6Q+Ve5A8/B8EdhBPrhmhV/e5EgQviyBJU2MHOrW9eU/Ac
         4FR8EyBIAAyyAmwKv9knPb4ak9pg90Fvhs0X/xA17H4TPSDjuC53Xi+qvFiCqfJ+rO2L
         bb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353947; x=1785958747;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yz+Y4cDmmkJFalPabDMm+ynUXO0OUxXd4k3RBua3jcw=;
        b=Gy277lXrj19iLrCvjwR+1c90baYUWmC3NLkTh/EZ1KXTA+jfT+Q5Czm5XTK9HU5Eo7
         7PkDU4p6l7LHo5Pjnm/jk1JSTDOggnBwBwog1KPw8+Zl2B+LX/6rgsAO8Xq4jwxGfsrE
         poejmmcQp6Yx9ySeNP2uRAcuQv0kT/EC7CKFEIomtWwMbiGnTT3M4yYWHLK1rQ5v1+j/
         1dMy0+Kfr537bas5X7mEl4DBka4lOmJNiQU0kz9hJYYXjkUF8iizH9KBx4GPT/mP2+Ka
         6BFAc+tVpkaPXu20PwJ0bQno/EuXlAXHyQy3bQo+Gs3ZV9r3RxgE3fDY3yLLwdglYn1V
         mKFg==
X-Forwarded-Encrypted: i=1; AHgh+RpfTHE8jW3rfYwOP7Z2Cf3tLapN2btMgJ7cSQ3ibgmg2qkEW4gN2mo926l7fHmYHbaZdLmErBg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwU6UcOL7epkYpDbIGwhlv6OvJxOGnvqFr3D3en4gZ3rPc/u/L0
	m3t55QDsMUB9paLRemK/vVRyQ//nq6S2YfOememYKDo8kgrBLiVrHT9JQMmR+et58AAaU8zSxrw
	Y3VeObA==
X-Received: from pjbcn20.prod.google.com ([2002:a17:90a:f094:b0:38e:6163:aa2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:37c7:b0:37f:f4ae:5f25
 with SMTP id 98e67ed59e1d1-38f99253d52mr179898a91.20.1785353947403; Wed, 29
 Jul 2026 12:39:07 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:39:06 -0700
In-Reply-To: <20260331194202.1722082-4-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-4-vipinsh@google.com>
Message-ID: <ampW2iHhp6EA21I5@google.com>
Subject: Re: [PATCH v4 3/9] KVM: selftests: Add timeout option in selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>, t@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, anup@brainfault.org, atish.patra@linux.dev, 
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 31, 2026, Vipin Sharma wrote:
> Add a command line argument in KVM selftest runner to limit amount of
> time (seconds) given to a test for execution. Kill the test if it
> exceeds the given timeout. Define a new SelftestStatus.TIMED_OUT to
> denote a selftest final result. Add terminal color for status messages
> of timed out tests.
> 
> Set the default value of 120 seconds for all tests.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  .../testing/selftests/kvm/runner/__main__.py  |  9 +++++-
>  .../testing/selftests/kvm/runner/selftest.py  | 29 ++++++++++++-------
>  .../selftests/kvm/runner/test_runner.py       |  2 +-
>  3 files changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index 9b6c78e69c64..82c543d11c34 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -37,6 +37,11 @@ def cli():
>                          default=".",
>                          help="Finds the test executables in the given path. Default is the current directory.")
>  
> +    parser.add_argument("--timeout",
> +                        default=120,
> +                        type=int,
> +                        help="Timeout, in seconds, before runner kills the running test. (Default: 120 seconds)")
> +
>      return parser.parse_args()
>  
>  
> @@ -44,6 +49,7 @@ def setup_logging():
>      class TerminalColorFormatter(logging.Formatter):
>          reset = "\033[0m"
>          red_bold = "\033[31;1m"
> +        red = "\033[31;1m"
>          green = "\033[32m"
>          yellow = "\033[33m"
>          blue = "\033[34m"
> @@ -52,7 +58,8 @@ def setup_logging():
>              SelftestStatus.PASSED: green,
>              SelftestStatus.NO_RUN: blue,
>              SelftestStatus.SKIPPED: yellow,
> -            SelftestStatus.FAILED: red_bold
> +            SelftestStatus.FAILED: red_bold,
> +            SelftestStatus.TIMED_OUT: red

Responding here because it's easier to see...

In my experience, uniquely identifying segfaults can be super helpful, e.g. (with
the stderr/stdout changes too).

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 13f4cbea1fa7..93ce46e25caf 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -122,6 +122,7 @@ def setup_logging(args):
             SelftestStatus.NO_RUN: blue,
             SelftestStatus.SKIPPED: yellow,
             SelftestStatus.FAILED: red_bold,
+            SelftestStatus.SEGFAULT: red_bold,
             SelftestStatus.TIMED_OUT: red
         }
 
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index 76c3e6d463ee..9ccdeef62a3e 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -18,7 +18,8 @@ class SelftestStatus(enum.IntEnum):
     NO_RUN = 22
     SKIPPED = 23
     FAILED = 24
-    TIMED_OUT = 25
+    SEGFAULT = 25
+    TIMED_OUT = 26
 
     def __str__(self):
         return str.__str__(self.name)
@@ -63,6 +64,8 @@ class Selftest:
                 self.status = SelftestStatus.PASSED
             elif proc.returncode == 4:
                 self.status = SelftestStatus.SKIPPED
+            elif proc.returncode == 139:
+                self.state = SelftestStatus.SEGFAULT
             else:
                 self.status = SelftestStatus.FAILED
         except subprocess.TimeoutExpired as e:
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 66a3c3711a8a..f06965c68520 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -21,6 +21,7 @@ class TestRunner:
         self.print_stds = {
             SelftestStatus.PASSED: args.print_passed,
             SelftestStatus.FAILED: args.print_failed,
+            SelftestStatus.SEGFAULT: args.print_failed,
             SelftestStatus.SKIPPED: args.print_skipped,
             SelftestStatus.TIMED_OUT: args.print_timed_out,
             SelftestStatus.NO_RUN: args.print_no_run
@@ -38,6 +39,7 @@ class TestRunner:
         print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
                 f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
                 f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
+                f"\033[31;1m Segfaults: {self.status[SelftestStatus.SEGFAULT]}" \
                 f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
                 f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
                 f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m",
@@ -47,10 +49,14 @@ class TestRunner:
         print_level = self.print_stds.get(test_result.status, "full")
 
         print("\033[2K", end="\r", flush=True)
-        if (print_level == "full" or print_level == "stdout"):
+        if (print_level == "full"):
             logger.info("*** stdout ***\n" + test_result.stdout)
-        if (print_level == "full" or print_level == "stderr"):
             logger.info("*** stderr ***\n" + test_result.stderr)
+        elif (print_level == "stdout"):
+            logger.info(test_result.stdout)
+        elif (print_level == "stderr"):
+            logger.info(test_result.stderr)
+
         if (print_level != "off"):
             logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
