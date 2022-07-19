Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF14C43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 13:04:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1324CAD2;
	Tue, 19 Jul 2022 09:04:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9JZQggkLSK6L; Tue, 19 Jul 2022 09:04:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93C1A4CABC;
	Tue, 19 Jul 2022 09:04:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0562A4CAB7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 09:04:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XQit6LQoWc-P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 09:04:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A47D4CAAD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 09:04:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1658235880;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/m2NS+tTnqV4bKM9ewNHJoxDhTc6Y1oQ8gKFxD1trHs=;
 b=HNq5hpxj0IYa9fVhhKY1jWOdxEZSOyNOdX75O+f20xeujPxIJGZjUKF+1cR66cTw5GIaTP
 w0Q6BpzPLbjas+AZQNIIVJw7kPjNSVMNLBaUxUcBvVapGjanFf6NX1LAESteZOldOYcfrj
 bQx/IYNB38Dl3Jo9vlAOY7omlluZotw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-6q2IyO1ZNRCFNrV8u7aWfQ-1; Tue, 19 Jul 2022 09:04:37 -0400
X-MC-Unique: 6q2IyO1ZNRCFNrV8u7aWfQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 x21-20020a05640226d500b0043abb7ac086so9872315edd.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 06:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=/m2NS+tTnqV4bKM9ewNHJoxDhTc6Y1oQ8gKFxD1trHs=;
 b=VZ4VWiECHyiUuuM86JjgHgulAFsUUEfi1AulXwRJqxk7cXG35DUfeKv4ZNctw37JU7
 Ssle3k0D4xhByp22o1tIczT/50B87wfNBfOypKY9XPr+S6EsTDyfJyOaD7Yg2IncwAoe
 +65il5pL3tGWdZrcbpruCZNVFODhFZwvdhVQtN58RMaN+e/HazAyF2vChxN3ITG1VICN
 j9IddLQVvLDLvj2uNMpqzCvee3xVCh29c8XOU6lFinUEqZ+2veYo7o0PxGXnlVJUoVuG
 p5pfFjhPLXeBJ+0V0g4ohyZ4Rf2AK2/bT9vmpxmJO40P2lRA5nVq4GJ0c+IccY+sRsPS
 5CFQ==
X-Gm-Message-State: AJIora+MDB4KtbFH747U3YxF32zhTZ0zkzlNr9MhdAiRMR6TV8hdEogZ
 vX8WHnPFkbnXAEw/FRhCsOl++I80RvRocbtba78ucLiA1bpk+ZrtsHPvyW6Dm5wGlt1ClEzOFnY
 fWXjOhwwD2oWcaXw+XKatl/b3
X-Received: by 2002:a05:6402:350a:b0:43a:a486:102e with SMTP id
 b10-20020a056402350a00b0043aa486102emr43636761edd.372.1658235875769; 
 Tue, 19 Jul 2022 06:04:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s+cBWjyzT7qfuJ3TW1q0EwoQB2LiMwqu8M2+a2tuJ83sI8IhDZhkXHpLK2PXU5altkDE6pPg==
X-Received: by 2002:a05:6402:350a:b0:43a:a486:102e with SMTP id
 b10-20020a056402350a00b0043aa486102emr43636731edd.372.1658235875538; 
 Tue, 19 Jul 2022 06:04:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 lv8-20020a170906bc8800b0072b91a3d7e9sm6670356ejb.28.2022.07.19.06.04.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 19 Jul 2022 06:04:34 -0700 (PDT)
Message-ID: <2b9070bd-61b2-0057-003e-f6c46f6c34a8@redhat.com>
Date: Tue, 19 Jul 2022 15:04:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4] KVM: selftests: Fix target thread to be migrated in
 rseq_test
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20220719020830.3479482-1-gshan@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220719020830.3479482-1-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: shan.gavin@gmail.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, linux-kselftest@vger.kernel.org, shuah@kernel.org
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

On 7/19/22 04:08, Gavin Shan wrote:
> In rseq_test, there are two threads, which are vCPU thread and migration
> worker separately. Unfortunately, the test has the wrong PID passed to
> sched_setaffinity() in the migration worker. It forces migration on the
> migration worker because zeroed PID represents the calling thread, which
> is the migration worker itself. It means the vCPU thread is never enforced
> to migration and it can migrate at any time, which eventually leads to
> failure as the following logs show.
> 
>    host# uname -r
>    5.19.0-rc6-gavin+
>    host# # cat /proc/cpuinfo | grep processor | tail -n 1
>    processor    : 223
>    host# pwd
>    /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
>    host# for i in `seq 1 100`; do \
>          echo "--------> $i"; ./rseq_test; done
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
>   tools/testing/selftests/kvm/rseq_test.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 4158da0da2bb..2237d1aac801 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -82,8 +82,9 @@ static int next_cpu(int cpu)
>   	return cpu;
>   }
>   
> -static void *migration_worker(void *ign)
> +static void *migration_worker(void *__rseq_tid)
>   {
> +	pid_t rseq_tid = (pid_t)(unsigned long)__rseq_tid;
>   	cpu_set_t allowed_mask;
>   	int r, i, cpu;
>   
> @@ -106,7 +107,7 @@ static void *migration_worker(void *ign)
>   		 * stable, i.e. while changing affinity is in-progress.
>   		 */
>   		smp_wmb();
> -		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
> +		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
>   		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
>   			    errno, strerror(errno));
>   		smp_wmb();
> @@ -231,7 +232,8 @@ int main(int argc, char *argv[])
>   	vm = vm_create_default(VCPU_ID, 0, guest_code);
>   	ucall_init(vm, NULL);
>   
> -	pthread_create(&migration_thread, NULL, migration_worker, 0);
> +	pthread_create(&migration_thread, NULL, migration_worker,
> +		       (void *)(unsigned long)gettid());
>   
>   	for (i = 0; !done; i++) {
>   		vcpu_run(vm, VCPU_ID);

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
