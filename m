Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB57CCA47C
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 00:22:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A2364C280;
	Thu, 14 Jul 2022 20:22:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9BOVJ7j6qNG3; Thu, 14 Jul 2022 20:22:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00EF74C296;
	Thu, 14 Jul 2022 20:22:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA30A4C280
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 20:22:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KDWoTASViAM5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 20:22:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8CD94C267
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 20:22:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657844532;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JDKBdO2ynojitcW0UwD3EnMXjp2f1L6/iJQpfcNZFPM=;
 b=V0rsTOYwfC+lrBTcmjq5fWGVd/abXGvATDt3Y+I1GKq3LfFr8ZAe2u9VwoL4uKvROqnLpx
 009Rxi9OBf6wZXXZlO4EABx7/yu0GOrHDmS05nS6HSeiirht71nhAe0t0jQfjdknmNs3YJ
 WoqMygVxMqjTDiEB6w3LsIM5LGB/47o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-tIbxiXzvM4-kc2o0I5BDCQ-1; Thu, 14 Jul 2022 20:22:08 -0400
X-MC-Unique: tIbxiXzvM4-kc2o0I5BDCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 530FC3C01E15;
 Fri, 15 Jul 2022 00:22:08 +0000 (UTC)
Received: from [10.64.54.37] (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9448D40885A1;
 Fri, 15 Jul 2022 00:22:03 +0000 (UTC)
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20220714080642.3376618-1-gshan@redhat.com>
 <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
 <YtA3s0VRj3x7vO7B@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <be806f9c-861a-8da8-d42e-1d4271c3a326@redhat.com>
Date: Fri, 15 Jul 2022 12:21:42 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YtA3s0VRj3x7vO7B@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 mathieu.desnoyers@efficios.com, linux-kselftest@vger.kernel.org,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Paolo and Sean,

On 7/15/22 1:35 AM, Sean Christopherson wrote:
> On Thu, Jul 14, 2022, Paolo Bonzini wrote:
>> On 7/14/22 10:06, Gavin Shan wrote:
>>> In rseq_test, there are two threads created. Those two threads are
>>> 'main' and 'migration_thread' separately. We also have the assumption
>>> that non-migration status on 'migration-worker' thread guarantees the
>>> same non-migration status on 'main' thread. Unfortunately, the assumption
>>> isn't true. The 'main' thread can be migrated from one CPU to another
>>> one between the calls to sched_getcpu() and READ_ONCE(__rseq.cpu_id).
>>> The following assert is raised eventually because of the mismatched
>>> CPU numbers.
>>>
>>> The issue can be reproduced on arm64 system occasionally.
>>
>> Hmm, this does not seem a correct patch - the threads are already
>> synchronizing using seq_cnt, like this:
>>
>> 	migration			main
>> 	----------------------		--------------------------------
>> 	seq_cnt = 1
>> 	smp_wmb()
>> 					snapshot = 0
>> 					smp_rmb()
>> 					cpu = sched_getcpu() reads 23
>> 	sched_setaffinity()
>> 					rseq_cpu = __rseq.cpuid reads 35
>> 					smp_rmb()
>> 					snapshot != seq_cnt -> retry
>> 	smp_wmb()
>> 	seq_cnt = 2
>>
>> sched_setaffinity() is guaranteed to block until the task is enqueued on an
>> allowed CPU.
> 
> Yes, and retrying could suppress detection of kernel bugs that this test is intended
> to catch.
> 

Well, I don't think migration_worker() does correct thing, if I'm understanding
correctly. The intention seems to force migration on 'main' thread by 'migration'
thread?  If that is the case, I don't think the following function call has correct
parameters.

     r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);

     it should be something like:

     r = sched_setaffinity(getpid(), sizeof(allowed_mask), &allowed_mask);

If we're using sched_setaffinity(0, ...) in the 'migration' thread, the CPU
affinity of 'main' thread won't be affected. It means 'main' thread can be
migrated from one CPU to another at any time, even in the following point:

     int main(...)
     {
           :
           /*
            * migration can happen immediately after sched_getcpu(). If
            * CPU affinity of 'main' thread is sticky to one particular
            * CPU, which 'migration' thread supposes to do, then there
            * should have no migration.
            */
           cpu = sched_getcpu();
           rseq_cpu = READ_ONCE(__rseq.cpu_id);
           :
     }

So I think the correct fix is to have sched_setaffinity(getpid(), ...) ?
Please refer to the manpage.

    https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html
    'If pid is zero, then the calling thread is used'

>> Can you check that smp_rmb() and smp_wmb() generate correct instructions on
>> arm64?
> 
> That seems like the most likely scenario (or a kernel bug), I distinctly remember
> the barriers provided by tools/ being rather bizarre.
> 

I don't see any problems for smp_rmb() and smp_wmb() in my case. They have
been translated to correct instructions, as expected.

#define smp_mb()        asm volatile("dmb ish" ::: "memory")
#define smp_wmb()       asm volatile("dmb ishst" ::: "memory")
#define smp_rmb()       asm volatile("dmb ishld" ::: "memory")

--------------

One more experiment for sched_setaffinity(). I run the following program,
the CPU affinity of 'main' thread isn't changed, until the correct
parameter is used, to have sched_setaffinity(getpid(), ...).

sched_setaffinity(0, ...)
-------------------------
[root@virtlab-arm01 tmp]# ./a
thread_func: cpu=0
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
thread_func: cpu=1
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
main: mask=0x000000ff
   :

sched_setaffinity(getpid(), ...)
--------------------------------
thread_func: cpu=198
main: mask=0x00000001
main: mask=0x00000001
main: mask=0x00000001
main: mask=0x00000001
main: mask=0x00000001
main: mask=0x00000001
main: mask=0x00000001
main: mask=0x00000001
main: mask=0x00000001
thread_func: cpu=198
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
main: mask=0x00000002
   :

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <sched.h>

#define NR_CPUS	8
static int thread_exit = 0;

static void *thread_func(void *data)
{
	cpu_set_t allowed_mask;
	int ret, i;

	for (i = 0; i < NR_CPUS; i++) {
		CPU_ZERO(&allowed_mask);
		CPU_SET(i, &allowed_mask);
#if 1
		sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
#else
                 sched_setaffinity(getpid(), sizeof(allowed_mask), &allowed_mask);
#endif
		fprintf(stdout, "%s: cpu=%d\n", __func__, sched_getcpu());

		sleep(1);
	}

	thread_exit = 1;
	return NULL;
}

int main(int argc, char **argv)
{
	pthread_t thread;
	cpu_set_t allowed_mask;
	int mask, i, count = 0;

	pthread_create(&thread, NULL, thread_func, NULL);

	while (!thread_exit) {
		usleep(100000);

		mask = 0;
		sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
		for (i = 0; i < NR_CPUS; i++) {
			if (CPU_ISSET(i, &allowed_mask))
				mask |= (1 << i);
		}

		fprintf(stdout, "%s: mask=0x%08x\n", __func__, mask);
	}

	return 0;
}


Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
