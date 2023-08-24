Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B891C2B
	for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 07:29:38 +0000 (UTC)
Date: Thu, 24 Aug 2023 09:29:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1692862173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HzkU2I4pC+FzodwyTrsp8nODUEl5lYVUPW3+UDMEpLU=;
	b=QETNpfLtgb6MgUY+Zr1oEGrIHBVbwJKti+F7RWlmnlTq2kEeIEaAVuoTfcOwdfR5PBNlvs
	qTz0CcQfgUenZmXpPKWcYozjnUh516XLyK7mGIeUp22r/AzOGUKtVpShimXQBLqqfkBNbm
	gcwh2vCmo3OIXtcPKkmgdL8bWdDnzV8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] arm64: microbench: Benchmark with virtual
 instead of physical timer
Message-ID: <20230824-1756f41111a789804fb7d049@orel>
References: <20230823200408.1214332-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823200408.1214332-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 23, 2023 at 08:04:08PM +0000, Colton Lewis wrote:
> Use the virtual instead of the physical timer for measuring the time
> taken to execute the microbenchmark.
> 
> Internal testing discovered a performance regression on this test
> starting with Linux commit 680232a94c12 "KVM: arm64: timers: Allow
> save/restoring of the physical timer". Oliver Upton speculates QEMU is
> changing the guest physical counter to have a nonzero offset since it
> gained the ability as of that commit. As a consequence KVM is
> trap-and-emulating here on architectures without FEAT_ECV.

No need to speculate, QEMU is open source :-)  QEMU is setting on offset,
but not because it explicitly wants to.  Simply reading the CNT register
and writing back the same value is enough to set an offset, since the
timer will have certainly moved past whatever value was read by the time
it's written.  QEMU frequently saves and restores all registers in the
get-reg-list array, unless they've been explicitly filtered out (with
Linux commit 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array).
So, to restore trapless ptimer accesses, we need a QEMU patch like below
to filter out the register.

diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 94bbd9661fd3..f89ea31f170d 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -674,6 +674,7 @@ typedef struct CPRegStateLevel {
  */
 static const CPRegStateLevel non_runtime_cpregs[] = {
     { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
+    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
 };

 int kvm_arm_cpreg_level(uint64_t regidx)


> 
> While this isn't a correctness issue, the trap-and-emulate overhead of
> physical counter emulation on systems without ECV leads to surprising
> microbenchmark results.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arm/micro-bench.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index bfd181dc..fbe59d03 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -348,10 +348,10 @@ static void loop_test(struct exit_test *test)
> 
>  	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
>  		isb();
> -		start = read_sysreg(cntpct_el0);
> +		start = read_sysreg(cntvct_el0);
>  		test->exec();
>  		isb();
> -		end = read_sysreg(cntpct_el0);
> +		end = read_sysreg(cntvct_el0);

This patch should be merged too, though, to avoid hitting the issue on
certain versions of QEMU. And, it's pretty clear that the original
authors just picked the ptimer arbitrarily.

> 
>  		ntimes++;
>  		total_ticks += (end - start);
> --
> 2.42.0.rc1.204.g551eb34607-goog

Queued.

Thanks,
drew
