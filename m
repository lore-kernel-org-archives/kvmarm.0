Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4349C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A18F4B172;
	Tue,  8 Feb 2022 08:58:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bgE2E17GnIwx; Tue,  8 Feb 2022 08:58:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D36A34B1B6;
	Tue,  8 Feb 2022 08:58:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BDE34A369
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:23:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x9XZOQoCApsN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 19:23:17 -0500 (EST)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com
 [209.85.166.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 349CE49F55
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:23:17 -0500 (EST)
Received: by mail-io1-f54.google.com with SMTP id d188so19157400iof.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 16:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=UH8TTlZtdHU9hR5j1dqwl9ALQq10XFCDiBTi5RqX1c8=;
 b=g6Dh2iJc4xhQ5QUXM3RIwFCepnYrrcXYwgJjxQwaGCpAzZApiIz5cYMgrpUt2MxVmP
 C6p4ZqV56muyss08V7ysJHiOgYhM4AmjYtLCHr+LFQN2YucIBj2WH6ONyUAfeoVqxbzX
 kFVUyO7TDcJowmMnWdKqxaj10IJe7NwNrLPmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=UH8TTlZtdHU9hR5j1dqwl9ALQq10XFCDiBTi5RqX1c8=;
 b=k0IIsbZ7qtAFBBBuIHzPmUaxt195naRZGPrY4NkpUjDE0zBL8B1Qy7zu6IRdM3QgRf
 M3CkEueXUwHMIz+5ekpLi60TsjK7wZX4j5sf/eyfvxlwM1TAXUI3gXsBsKmP+TZb6h/9
 7VefXpHL/Xk09RsojM7fJcVzGtjVATpkHdx/mbluuNf5lALMcAOA3l+LAaThnh7Cwqcr
 j8TvHmjrGzNY6DjADMdjmeb21mSg1kndZHZ616nK0mgAe9Y0TH3NPq6TNHS0FcHQrKtc
 LeulJ6Jr6Ev1Z0Xrfxgif57diSu2JqhZ4cT3coZi7E/wq6vhZduGPZMGbYq6MG0uoFAW
 VUPg==
X-Gm-Message-State: AOAM532I9KM9jdAwzUzNNrcMHNxEEXNA+BG8gincuG2H5ziEYSbBbT4Z
 lVVcpUlWFooWqqDSEkEVbXWgeA==
X-Google-Smtp-Source: ABdhPJwN5ALMcRd5AUptbs+L7Oy82xGgQ9E1wuWR+EuGvaictbSKagsy6lWgthJkTLbShyxqI6RIuA==
X-Received: by 2002:a6b:e60d:: with SMTP id g13mr940588ioh.39.1644279796551;
 Mon, 07 Feb 2022 16:23:16 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id c9sm6401156ile.38.2022.02.07.16.23.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 16:23:16 -0800 (PST)
Subject: Re: [PATCH v11 32/40] kselftest/arm64: Add tests for TPIDR2
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-33-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <14e08c27-289d-8c39-15ef-220e0a7949f0@linuxfoundation.org>
Date: Mon, 7 Feb 2022 17:23:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-33-broonie@kernel.org>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 08 Feb 2022 08:58:27 -0500
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <skhan@linuxfoundation.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2/7/22 8:21 AM, Mark Brown wrote:
> The Scalable Matrix Extension adds a new system register TPIDR2 intended to
> be used by libc for its own thread specific use, add some kselftests which
> exercise the ABI for it.
> 
> Since this test should with some adjustment work for TPIDR and any other
> similar registers added in future add tests for it in a separate
> directory rather than placing it with the other floating point tests,
> nothing existing looked suitable so I created a new test directory
> called "abi".
> 
> Since this feature is intended to be used by libc the test is built as
> freestanding code using nolibc so we don't end up with the test program
> and libc both trying to manage the register simultaneously and
> distrupting each other. As a result of being written using nolibc rather
> than using hwcaps to identify if SME is available in the system we check
> for the default SME vector length configuration in proc, adding hwcap
> support to nolibc seems like disproportionate effort and didn't feel
> entirely idiomatic for what nolibc is trying to do.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   tools/testing/selftests/arm64/abi/.gitignore |   1 +
>   tools/testing/selftests/arm64/abi/Makefile   |   9 +-
>   tools/testing/selftests/arm64/abi/tpidr2.c   | 298 +++++++++++++++++++
>   3 files changed, 307 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/arm64/abi/tpidr2.c
> 
> diff --git a/tools/testing/selftests/arm64/abi/.gitignore b/tools/testing/selftests/arm64/abi/.gitignore
> index b79cf5814c23..b9e54417250d 100644
> --- a/tools/testing/selftests/arm64/abi/.gitignore
> +++ b/tools/testing/selftests/arm64/abi/.gitignore
> @@ -1 +1,2 @@
>   syscall-abi
> +tpidr2
> diff --git a/tools/testing/selftests/arm64/abi/Makefile b/tools/testing/selftests/arm64/abi/Makefile
> index 96eba974ac8d..c8d7f2495eb2 100644
> --- a/tools/testing/selftests/arm64/abi/Makefile
> +++ b/tools/testing/selftests/arm64/abi/Makefile
> @@ -1,8 +1,15 @@
>   # SPDX-License-Identifier: GPL-2.0
>   # Copyright (C) 2021 ARM Limited
>   
> -TEST_GEN_PROGS := syscall-abi
> +TEST_GEN_PROGS := syscall-abi tpidr2
>   
>   include ../../lib.mk
>   
>   $(OUTPUT)/syscall-abi: syscall-abi.c syscall-abi-asm.S
> +
> +# Build with nolibc since TPIDR2 is intended to be actively managed by
> +# libc and we're trying to test the functionality that it depends on here.
> +$(OUTPUT)/tpidr2: tpidr2.c
> +	$(CC) -fno-asynchronous-unwind-tables -fno-ident -s -Os -nostdlib \
> +		-static -include ../../../../include/nolibc/nolibc.h \
> +		-ffreestanding -Wall $^ -o $@ -lgcc
> diff --git a/tools/testing/selftests/arm64/abi/tpidr2.c b/tools/testing/selftests/arm64/abi/tpidr2.c
> new file mode 100644
> index 000000000000..351a098b503a
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/abi/tpidr2.c
> @@ -0,0 +1,298 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/sched.h>
> +#include <linux/wait.h>
> +
> +#define SYS_TPIDR2 "S3_3_C13_C0_5"
> +
> +#define EXPECTED_TESTS 5
> +
> +static void putstr(const char *str)
> +{
> +	write(1, str, strlen(str));
> +}
> +
> +static void putnum(unsigned int num)
> +{
> +	char c;
> +
> +	if (num / 10)
> +		putnum(num / 10);
> +
> +	c = '0' + (num % 10);
> +	write(1, &c, 1);
> +}
> +
> +static int tests_run;
> +static int tests_passed;
> +static int tests_failed;
> +static int tests_skipped;
> +
> +static void set_tpidr2(uint64_t val)
> +{
> +	asm volatile (
> +		"msr	" SYS_TPIDR2 ", %0\n"
> +		:
> +		: "r"(val)
> +		: "cc");
> +}
> +
> +static uint64_t get_tpidr2(void)
> +{
> +	uint64_t val;
> +
> +	asm volatile (
> +		"mrs	%0, " SYS_TPIDR2 "\n"
> +		: "=r"(val)
> +		:
> +		: "cc");
> +
> +	return val;
> +}
> +
> +static void print_summary(void)
> +{
> +	if (tests_passed + tests_failed + tests_skipped != EXPECTED_TESTS)
> +		putstr("# UNEXPECTED TEST COUNT: ");
> +
> +	putstr("# Totals: pass:");
> +	putnum(tests_passed);
> +	putstr(" fail:");
> +	putnum(tests_failed);
> +	putstr(" xfail:0 xpass:0 skip:");
> +	putnum(tests_skipped);
> +	putstr(" error:0\n");
> +}
> +
> +/* Processes should start with TPIDR2 == 0 */
> +static int default_value(void)
> +{
> +	return get_tpidr2() == 0;
> +}
> +
> +/* If we set TPIDR2 we should read that value */
> +static int write_read(void)
> +{
> +	set_tpidr2(getpid());
> +
> +	return getpid() == get_tpidr2();
> +}
> +
> +/* If we set a value we should read the same value after scheduling out */
> +static int write_sleep_read(void)
> +{
> +	set_tpidr2(getpid());
> +
> +	msleep(100);
> +
> +	return getpid() == get_tpidr2();
> +}
> +
> +/*
> + * If we fork the value in the parent should be unchanged and the
> + * child should start with the same value and be able to set its own
> + * value.
> + */
> +static int write_fork_read(void)
> +{
> +	pid_t newpid, waiting, oldpid;
> +	int status;
> +
> +	set_tpidr2(getpid());
> +
> +	oldpid = getpid();
> +	newpid = fork();
> +	if (newpid == 0) {
> +		/* In child */
> +		if (get_tpidr2() != oldpid) {
> +			putstr("# TPIDR2 changed in child: ");
> +			putnum(get_tpidr2());
> +			putstr("\n");
> +			exit(0);
> +		}
> +
> +		set_tpidr2(getpid());
> +		if (get_tpidr2() == getpid()) {
> +			exit(1);
> +		} else {
> +			putstr("# Failed to set TPIDR2 in child\n");
> +			exit(0);

Is this test expected to fail? Is that why it exits with 0 status?


> +		}
> +	}
> +	if (newpid < 0) {
> +		putstr("# fork() failed: -");
> +		putnum(-newpid);
> +		putstr("\n");
> +		return 0;

Same here - returning 0 indicates test passing which could mean a false
positive.

> +	}
> +
> +	for (;;) {
> +		waiting = waitpid(newpid, &status, 0);
> +
> +		if (waiting < 0) {
> +			if (errno == EINTR)
> +				continue;
> +			putstr("# waitpid() failed: ");
> +			putnum(errno);
> +			putstr("\n");
> +			return 0;
> +		}
> +		if (waiting != newpid) {
> +			putstr("# waitpid() returned wrong PID\n");
> +			return 0;
> +		}
> +
> +		if (!WIFEXITED(status)) {
> +			putstr("# child did not exit\n");
> +			return 0;
> +		}
> +
> +		if (getpid() != get_tpidr2()) {
> +			putstr("# TPIDR2 corrupted in parent\n");
> +			return 0;
> +		}
> +
> +		return WEXITSTATUS(status);
> +	}
> +}
> +
> +/*
> + * sys_clone() has a lot of per architecture variation so just define
> + * it here rather than adding it to nolibc, plus the raw API is a
> + * little more convenient for this test.
> + */
> +static int sys_clone(unsigned long clone_flags, unsigned long newsp,
> +		     int *parent_tidptr, unsigned long tls,
> +		     int *child_tidptr)
> +{
> +	return my_syscall5(__NR_clone, clone_flags, newsp, parent_tidptr, tls,
> +			   child_tidptr);
> +}
> +
> +/*
> + * If we clone with CLONE_SETTLS then the value in the parent should
> + * be unchanged and the child should start with zero and be able to
> + * set its own value.
> + */
> +static int write_clone_read(void)
> +{
> +	int parent_tid, child_tid;
> +	pid_t parent, waiting;
> +	int ret, status;
> +
> +	parent = getpid();
> +	set_tpidr2(parent);
> +
> +	ret = sys_clone(CLONE_SETTLS, 0, &parent_tid, 0, &child_tid);
> +	if (ret == -1) {
> +		putstr("# clone() failed\n");
> +		putnum(errno);
> +		putstr("\n");
> +		return 0;

Same commnet here - just making sure there are no false positives

> +	}
> +
> +	if (ret == 0) {
> +		/* In child */
> +		if (get_tpidr2() != 0) {
> +			putstr("# TPIDR2 non-zero in child: ");
> +			putnum(get_tpidr2());
> +			putstr("\n");
> +			exit(0);
> +		}
> +
> +		if (gettid() == 0)
> +			putstr("# Child TID==0\n");
> +		set_tpidr2(gettid());
> +		if (get_tpidr2() == gettid()) {
> +			exit(1);
> +		} else {
> +			putstr("# Failed to set TPIDR2 in child\n");
> +			exit(0);
> +		}
> +	}
> +
> +	for (;;) {
> +		waiting = wait4(ret, &status, __WCLONE, NULL);
> +
> +		if (waiting < 0) {
> +			if (errno == EINTR)
> +				continue;
> +			putstr("# wait4() failed: ");
> +			putnum(errno);
> +			putstr("\n");
> +			return 0;
> +		}
> +		if (waiting != ret) {
> +			putstr("# wait4() returned wrong PID ");
> +			putnum(waiting);
> +			putstr("\n");
> +			return 0;
> +		}
> +
> +		if (!WIFEXITED(status)) {
> +			putstr("# child did not exit\n");
> +			return 0;
> +		}
> +
> +		if (parent != get_tpidr2()) {
> +			putstr("# TPIDR2 corrupted in parent\n");
> +			return 0;
> +		}
> +
> +		return WEXITSTATUS(status);
> +	}
> +}
> +
> +#define run_test(name)			     \
> +	if (name()) {			     \
> +		tests_passed++;		     \
> +	} else {			     \
> +		tests_failed++;		     \
> +		putstr("not ");		     \
> +	}				     \
> +	putstr("ok ");			     \
> +	putnum(++tests_run);		     \
> +	putstr(" " #name "\n");
> +
> +int main(int argc, char **argv)
> +{
> +	int ret, i;
> +
> +	putstr("TAP version 13\n");
> +	putstr("1..");
> +	putnum(EXPECTED_TESTS);
> +	putstr("\n");
> +
> +	putstr("# PID: ");
> +	putnum(getpid());
> +	putstr("\n");
> +
> +	/*
> +	 * This test is run with nolibc which doesn't support hwcap and
> +	 * it's probably disproportionate to implement so instead check
> +	 * for the default vector length configuration in /proc.
> +	 */
> +	ret = open("/proc/sys/abi/sme_default_vector_length", O_RDONLY, 0);
> +	if (ret >= 0) {
> +		run_test(default_value);
> +		run_test(write_read);
> +		run_test(write_sleep_read);
> +		run_test(write_fork_read);
> +		run_test(write_clone_read);
> +
> +	} else {
> +		putstr("# SME support not present\n");
> +
> +		for (i = 0; i < EXPECTED_TESTS; i++) {
> +			putstr("ok ");
> +			putnum(i);
> +			putstr(" skipped, TPIDR2 not supported\n");
> +		}
> +
> +		tests_skipped += EXPECTED_TESTS;
> +	}
> +
> +	print_summary();
> +
> +	return 0;
> +}
> 

With the comments explained or addressed:

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
