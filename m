Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BBBC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 13:52:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7F1A4C532;
	Thu, 14 Jul 2022 09:52:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cOXi8n3Yu2Wi; Thu, 14 Jul 2022 09:52:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF914C4E4;
	Thu, 14 Jul 2022 09:52:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0C0A4C4E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 09:52:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3jA4Oe2Qjc3e for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 09:52:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3BCB4C4BD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 09:52:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657806730;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/DbMY4fkJWP+PysgOKi02iEpV+7O3rbRErGJbwgQ+eQ=;
 b=ZTLuzZXfaTc3mrwQygEl7utWfb98JcfGP/kIpiq38a+4lZeCLyV1UaEFw5fG/bZsEDey32
 1H4mjFKeA/t6aLE3+YJyiiBEApSYClDF34LeTCh5g4jOKP7HUn9mSe1b0zpwCbqZSpCQRZ
 fJKxMbS2sLZjNAHxd20dKkKZYSPNVJY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-qNZA8LMBNKW2jAkXJpECtQ-1; Thu, 14 Jul 2022 09:52:09 -0400
X-MC-Unique: qNZA8LMBNKW2jAkXJpECtQ-1
Received: by mail-ej1-f72.google.com with SMTP id
 sa13-20020a1709076d0d00b0072a8791298aso791572ejc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 06:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=/DbMY4fkJWP+PysgOKi02iEpV+7O3rbRErGJbwgQ+eQ=;
 b=Lt8Bn/Ufw7Mg9gvYK0hS5tNqi5VhnXRCB4zjzLFyIA5AjKs6mwOZdVkTpJyzT6uGuG
 G3fLq5AhikB2sGgJFY5PDYzilFFMevKGvBQ9LlYWauEnnrtdQfwH//MVYGZbBsjoYaNr
 LZ8ER1TEQRDywEEJ8BVEXZvIMzP61NXjCr8QaTjFbpM8bfJUdUv/Z3+xZ5KF9DwiWM7T
 0JQZVX1z+hEWt+63STMT7pzsX1spbYyVotRLveEkrxgmaLfpW8hoHXCUxQeX64OlAy4I
 u4b3/IV4dqJzFTEg8D6oOf4Kmt113HvWldDFntG4+qPxF3cN/IULmjKLVQ/L1/iGgQJR
 2/9g==
X-Gm-Message-State: AJIora9rMjf+KRZteT52C0s4l0K9YfQCTj2RoFbXc88VOxJq3vy0eGZ0
 ve4xFk5DblwnA7da1wxWQ67aqg8jAabJeI183zpj7d3Em/OxsT1p7esi7Bf5EbEDbjKcx3pJRhV
 CKOkJ/oL+3Xx7o0v6HFjZqmPd
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id
 ew8-20020a056402538800b00435071b5d44mr12127193edb.364.1657806727966; 
 Thu, 14 Jul 2022 06:52:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t9j243sp0KAU90kUpGzuuJ6eriMDQU6VG9uY7+LPoOkHNVc5QAtLQp/FA07g5PE0QNkP3Luw==
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id
 ew8-20020a056402538800b00435071b5d44mr12127159edb.364.1657806727740; 
 Thu, 14 Jul 2022 06:52:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 s18-20020a170906501200b007121361d54asm734486ejj.25.2022.07.14.06.52.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 14 Jul 2022 06:52:07 -0700 (PDT)
Message-ID: <c5d81d4a-5002-3ffe-e70e-f4238da873c5@redhat.com>
Date: Thu, 14 Jul 2022 15:52:06 +0200
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
> 
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

Queued for -rc, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
