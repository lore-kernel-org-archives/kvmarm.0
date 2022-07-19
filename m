Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE31CCA479
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 00:14:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C26994CB69;
	Mon, 18 Jul 2022 20:14:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7QIkCG9TbX-Y; Mon, 18 Jul 2022 20:14:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AFEA4CB71;
	Mon, 18 Jul 2022 20:14:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F0F64CB19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 20:14:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EGF+qEsO06pX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 20:13:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D81634CB10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 20:13:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1658189638;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1wKQgGK8BeGoD+ZzlJLfhSADz2IoDkHod2Zuz9U3oUY=;
 b=LzNCudYm35amssgO5AXNgwuBczJ5n1OAZjb2HEy9I2xj5dtJRdbflMeUy8pEeY/7v44HVd
 47SKNyJvmyUG/BQfNA6/P34z6+ZL3eIqSfVeDyH6tlllIX44gOdameygg0o4GpmW2Nm8yH
 22e9INAaAbSQiuKJg3eMXRQHP0B5whw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-XkZOUjJhMw6uJ_0WPGr90Q-1; Mon, 18 Jul 2022 20:13:57 -0400
X-MC-Unique: XkZOUjJhMw6uJ_0WPGr90Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C8D18037AA;
 Tue, 19 Jul 2022 00:13:56 +0000 (UTC)
Received: from [10.64.54.37] (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 560002166B26;
 Tue, 19 Jul 2022 00:13:53 +0000 (UTC)
Subject: Re: [PATCH v3] KVM: selftests: Fix target thread to be migrated in
 rseq_test
To: Sean Christopherson <seanjc@google.com>
References: <20220719013540.3477946-1-gshan@redhat.com>
 <YtXw5DKI7z9s1TA6@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <08b942d5-ad06-4c38-ee53-8ff3caf30694@redhat.com>
Date: Tue, 19 Jul 2022 12:13:32 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YtXw5DKI7z9s1TA6@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Cc: shan.gavin@gmail.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
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

Hi Sean,

On 7/19/22 9:46 AM, Sean Christopherson wrote:
> On Tue, Jul 19, 2022, Gavin Shan wrote:
>> ---
>> v3: Improved changelog (Oliver Upon)
> 
> Sorry I didn't catch v3, I saw that you waited but just didn't get to this earlier :-/
> 

Not a problem at all :)

>> ---
>>   tools/testing/selftests/kvm/rseq_test.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
>> index 4158da0da2bb..c83ac7b467f8 100644
>> --- a/tools/testing/selftests/kvm/rseq_test.c
>> +++ b/tools/testing/selftests/kvm/rseq_test.c
>> @@ -38,6 +38,7 @@ static __thread volatile struct rseq __rseq = {
>>    */
>>   #define NR_TASK_MIGRATIONS 100000
>>   
>> +static pid_t rseq_tid;
>>   static pthread_t migration_thread;
>>   static cpu_set_t possible_mask;
>>   static int min_cpu, max_cpu;
>> @@ -106,7 +107,8 @@ static void *migration_worker(void *ign)
> 
> Pass the target TID to the worker, then there's no need to use a global and no
> chance of consuming rseq_tid "uninitialized".  The casting to convert gettid() to
> a "void *" is annoying, but not the end of the world.
> 

I was thinking of the scheme, but passing the address of a local variable
for the thread ID. Your suggestion also makes sense to me.

>>   		 * stable, i.e. while changing affinity is in-progress.
>>   		 */
>>   		smp_wmb();
>> -		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
>> +		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask),
>> +				      &allowed_mask);
> 
> Eh, let this poke out, don't think it's worth wrapping here.
> 

Ok, I was trying to follow rule of 80-characters per line, even it's
not strictly needed nowadays. It's also fine not to follow :)

I just picked your code and posted v4:

https://lore.kernel.org/kvmarm/20220719020830.3479482-1-gshan@redhat.com/T/#u

Thanks,
Gavin

> E.g.
> 
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index aba7be178dab..a54d4d05a058 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -80,8 +80,9 @@ static int next_cpu(int cpu)
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
> @@ -104,7 +105,7 @@ static void *migration_worker(void *ign)
>   		 * stable, i.e. while changing affinity is in-progress.
>   		 */
>   		smp_wmb();
> -		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
> +		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
>   		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
>   			    errno, strerror(errno));
>   		smp_wmb();
> @@ -227,7 +228,8 @@ int main(int argc, char *argv[])
>   	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>   	ucall_init(vm, NULL);
> 
> -	pthread_create(&migration_thread, NULL, migration_worker, 0);
> +	pthread_create(&migration_thread, NULL, migration_worker,
> +		       (void *)(unsigned long)gettid());
> 
>   	for (i = 0; !done; i++) {
>   		vcpu_run(vcpu);
> 
> base-commit: ad6cb756bb497997032df2bda7cbdff076e4a66a
> --
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
