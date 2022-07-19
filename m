Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99215C43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 07:24:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF62F4C8D2;
	Tue, 19 Jul 2022 03:24:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oNCYVdl5rhHw; Tue, 19 Jul 2022 03:24:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 993904C8DB;
	Tue, 19 Jul 2022 03:24:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2685B4C8D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 03:24:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dFJESYbuMpoE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 03:24:19 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B53BF4C8D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 03:24:19 -0400 (EDT)
Date: Tue, 19 Jul 2022 09:24:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658215458;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1TLI4cpTkvvZ1FKyQqbMuV6JR4Z1X/NR24gingPwxq8=;
 b=Z3KNNmdbS78+gMFM5ylDfit3NDN6v4XIVpnL5nZlOmOTYa/IY9SqrdhNDxr3pyXbhG+855
 FpALKOao9PZEoNeQim3P5jIwieLcIja0BukbXIWYenXoHXGxfaAcEozHrJaN0Fgo4N7Iu0
 Ry1E/7q6t1vcq0o9eG4UZBZE97EHuUM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4] KVM: selftests: Fix target thread to be migrated in
 rseq_test
Message-ID: <20220719072412.mmuptm3kf6wwi5pt@kamzik>
References: <20220719020830.3479482-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220719020830.3479482-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: shan.gavin@gmail.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Jul 19, 2022 at 10:08:30AM +0800, Gavin Shan wrote:
> In rseq_test, there are two threads, which are vCPU thread and migration
> worker separately. Unfortunately, the test has the wrong PID passed to
> sched_setaffinity() in the migration worker. It forces migration on the
> migration worker because zeroed PID represents the calling thread, which
> is the migration worker itself. It means the vCPU thread is never enforced
> to migration and it can migrate at any time, which eventually leads to
> failure as the following logs show.
> 
>   host# uname -r
>   5.19.0-rc6-gavin+
>   host# # cat /proc/cpuinfo | grep processor | tail -n 1
>   processor    : 223
>   host# pwd
>   /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
>   host# for i in `seq 1 100`; do \
>         echo "--------> $i"; ./rseq_test; done
>   --------> 1
>   --------> 2
>   --------> 3
>   --------> 4
>   --------> 5
>   --------> 6
>   ==== Test Assertion Failure ====
>     rseq_test.c:265: rseq_cpu == cpu
>     pid=3925 tid=3925 errno=4 - Interrupted system call
>        1  0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
>        2  0x0000ffffb044affb: ?? ??:0
>        3  0x0000ffffb044b0c7: ?? ??:0
>        4  0x0000000000401a6f: _start at ??:?
>     rseq CPU = 4, sched CPU = 27
> 
> Fix the issue by passing correct parameter, TID of the vCPU thread, to
> sched_setaffinity() in the migration worker.
> 
> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> ---
> v4: Pick the code change as Sean suggested.
> ---
>  tools/testing/selftests/kvm/rseq_test.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 4158da0da2bb..2237d1aac801 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -82,8 +82,9 @@ static int next_cpu(int cpu)
>  	return cpu;
>  }
>  
> -static void *migration_worker(void *ign)
> +static void *migration_worker(void *__rseq_tid)
>  {
> +	pid_t rseq_tid = (pid_t)(unsigned long)__rseq_tid;
>  	cpu_set_t allowed_mask;
>  	int r, i, cpu;
>  
> @@ -106,7 +107,7 @@ static void *migration_worker(void *ign)
>  		 * stable, i.e. while changing affinity is in-progress.
>  		 */
>  		smp_wmb();
> -		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
> +		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
>  		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
>  			    errno, strerror(errno));
>  		smp_wmb();
> @@ -231,7 +232,8 @@ int main(int argc, char *argv[])
>  	vm = vm_create_default(VCPU_ID, 0, guest_code);
>  	ucall_init(vm, NULL);
>  
> -	pthread_create(&migration_thread, NULL, migration_worker, 0);
> +	pthread_create(&migration_thread, NULL, migration_worker,
> +		       (void *)(unsigned long)gettid());
>  
>  	for (i = 0; !done; i++) {
>  		vcpu_run(vm, VCPU_ID);
> -- 
> 2.23.0

Thanks for figuring this out Gavin and Sean!

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
