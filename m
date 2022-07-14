Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D740AC43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 14:03:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6704C553;
	Thu, 14 Jul 2022 10:03:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o9wfHE0Yq1Du; Thu, 14 Jul 2022 10:03:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E360F4C540;
	Thu, 14 Jul 2022 10:03:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D60214C52E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 10:03:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wynVCGcUfKXd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 10:03:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B978A4C52D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 10:03:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657807390;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7XtdxK0LWmb1Jf+89i4Nsc+LkvKFkGHcgSyZX0xXxyI=;
 b=aZiKQzDzdkT5eFTdeOVcaf1+2ljWPKw7p67CtXGPhM5qlYLjYny+pSJzcU4QI9A05I5zMG
 Z9rq98Ye6+6jp019RYqIrDvmYN2YPMAnTgOmS2d+DfJlrG5ZxK3bQ/JW9S+QS2ts+qCsxa
 8HNuxIgZgMAcAy8Pp0HMpatjRADiTNk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-Gv5N2R4sOOq9Pw1HTuwPyQ-1; Thu, 14 Jul 2022 10:03:08 -0400
X-MC-Unique: Gv5N2R4sOOq9Pw1HTuwPyQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 z20-20020a05640240d400b0043a82d9d65fso1594414edb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 07:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=7XtdxK0LWmb1Jf+89i4Nsc+LkvKFkGHcgSyZX0xXxyI=;
 b=LpdqzEJT0cIT1D3dh/sO6fSb9Al0c0WOIsD3TTigqJ51DWLuFUmx2Xe+CH10rR6nUV
 5OUXshY6ujTRHkx8cmMB+5c2yNOiBsW3EtS4sttC/7EAos8WWBeGow1E34djFun/0a7f
 eoasauOzC5YKzyclvvh6sdZ8ttp2mDvIuRaQCQMCVG/302Lo139p59I/pqntROhqdYYl
 9bxhBcdOUNj1KV6mJ4uH55VReWZY135x+QEVUPJjicyY3vptcckqqGBwRts3KDRWVCgc
 3ipDWrh3vh7i3J1R4o8u1X1QETJyXBHu60RbF7d8JxmO5zjd50WalhYJuSBCgQTQCRLG
 uv5Q==
X-Gm-Message-State: AJIora/A2Rgab+FCktsEm8xRh6qboFcoSukrIY9WrmpDzPuUVPx0Mapv
 0QIWkCrstQIyQzQWdE9kDVmRKfonm4aa6/wRWUwWhd5Fi+DgawBSGbGDcrlOjoX/V7dMsqOo5DS
 if/qK4GQl7HI6X4QfY8LASb3G
X-Received: by 2002:a05:6402:40ce:b0:43a:918d:a73f with SMTP id
 z14-20020a05640240ce00b0043a918da73fmr12619743edb.387.1657807387224; 
 Thu, 14 Jul 2022 07:03:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t8bK5AXcuJxMiU/pYnK7wAsXNRmsbk7m7pn+eL/yzuEBAI/N/AVsUo8KbNwnQSVLyg0gEIxA==
X-Received: by 2002:a05:6402:40ce:b0:43a:918d:a73f with SMTP id
 z14-20020a05640240ce00b0043a918da73fmr12619713edb.387.1657807386962; 
 Thu, 14 Jul 2022 07:03:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 b10-20020a1709063caa00b0072ee79bb8ebsm228499ejh.126.2022.07.14.07.03.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 14 Jul 2022 07:03:06 -0700 (PDT)
Message-ID: <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
Date: Thu, 14 Jul 2022 16:03:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20220714080642.3376618-1-gshan@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220714080642.3376618-1-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, mathieu.desnoyers@efficios.com,
 linux-kselftest@vger.kernel.org, maz@kernel.org, shuah@kernel.org
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

On 7/14/22 10:06, Gavin Shan wrote:
> In rseq_test, there are two threads created. Those two threads are
> 'main' and 'migration_thread' separately. We also have the assumption
> that non-migration status on 'migration-worker' thread guarantees the
> same non-migration status on 'main' thread. Unfortunately, the assumption
> isn't true. The 'main' thread can be migrated from one CPU to another
> one between the calls to sched_getcpu() and READ_ONCE(__rseq.cpu_id).
> The following assert is raised eventually because of the mismatched
> CPU numbers.
> 
> The issue can be reproduced on arm64 system occasionally.

Hmm, this does not seem a correct patch - the threads are already 
synchronizing using seq_cnt, like this:

	migration			main
	----------------------		--------------------------------
	seq_cnt = 1
	smp_wmb()
					snapshot = 0
					smp_rmb()
					cpu = sched_getcpu() reads 23
	sched_setaffinity()
					rseq_cpu = __rseq.cpuid reads 35
					smp_rmb()
					snapshot != seq_cnt -> retry
	smp_wmb()
	seq_cnt = 2

sched_setaffinity() is guaranteed to block until the task is enqueued on 
an allowed CPU.

Can you check that smp_rmb() and smp_wmb() generate correct instructions 
on arm64?

Paolo

>    host# uname -r
>    5.19.0-rc6-gavin+
>    host# # cat /proc/cpuinfo | grep processor | tail -n 1
>    processor    : 223
>    host# pwd
>    /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
>    host# for i in `seq 1 100`;   \
>          do echo "--------> $i"; \
>          ./rseq_test; sleep 3;   \
>          done
>    --------> 1
>    --------> 2
>    --------> 3
>    --------> 4
>    --------> 5
>    --------> 6
>    ==== Test Assertion Failure ====
>      rseq_test.c:265: rseq_cpu == cpu
>      pid=3925 tid=3925 errno=4 - Interrupted system call
>         1  0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
>         2  0x0000ffffb044affb: ?? ??:0
>         3  0x0000ffffb044b0c7: ?? ??:0
>         4  0x0000000000401a6f: _start at ??:?
>      rseq CPU = 4, sched CPU = 27
> 
> This fixes the issue by double-checking on the current CPU after
> call to READ_ONCE(__rseq.cpu_id) and restarting the test if the
> two consecutive CPU numbers aren't euqal.
> 
> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 4158da0da2bb..74709dd9f5b2 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -207,7 +207,7 @@ int main(int argc, char *argv[])
>   {
>   	int r, i, snapshot;
>   	struct kvm_vm *vm;
> -	u32 cpu, rseq_cpu;
> +	u32 cpu, rseq_cpu, last_cpu;
>   
>   	/* Tell stdout not to buffer its content */
>   	setbuf(stdout, NULL);
> @@ -259,8 +259,9 @@ int main(int argc, char *argv[])
>   			smp_rmb();
>   			cpu = sched_getcpu();
>   			rseq_cpu = READ_ONCE(__rseq.cpu_id);
> +			last_cpu = sched_getcpu();
>   			smp_rmb();
> -		} while (snapshot != atomic_read(&seq_cnt));
> +		} while (snapshot != atomic_read(&seq_cnt) || cpu != last_cpu);
>   
>   		TEST_ASSERT(rseq_cpu == cpu,
>   			    "rseq CPU = %d, sched CPU = %d\n", rseq_cpu, cpu);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
