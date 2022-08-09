Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3217C25B07
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 06:44:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315424CF6F;
	Tue,  9 Aug 2022 02:44:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oNsCPPvDwYav; Tue,  9 Aug 2022 02:44:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8653C4D038;
	Tue,  9 Aug 2022 02:44:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D79BE4CE0B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 02:44:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ay4unuYOORmu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 02:44:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3F9A4CF6F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 02:44:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660027479;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CR6YkkBfyaob1O/ChtSSoS1BxAeM9gKVCgsFRDj4SAA=;
 b=RMFr3cKXrwFuwQAHPTGBVn6C2q2wYPFikuLGepft03iB5Z7FaAimHTeg0oZzDVuizH7zh5
 iQ5uuV8pmCwjkTZSd0YRAdv9fNg2U6ZjBoxC9Wnqa/6pN1S1XHXlZJ+DmdRCIOXbritoAS
 6J9Wlg/1wk+7tQtBXITSjxUbKsAazw8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-cbov0cI9NWG7_T_0ybwJ4w-1; Tue, 09 Aug 2022 02:44:37 -0400
X-MC-Unique: cbov0cI9NWG7_T_0ybwJ4w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22A4880391B;
 Tue,  9 Aug 2022 06:44:37 +0000 (UTC)
Received: from [10.64.54.189] (vpn2-54-189.bne.redhat.com [10.64.54.189])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BAEA1121315;
 Tue,  9 Aug 2022 06:44:32 +0000 (UTC)
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
To: Florian Weimer <fweimer@redhat.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
Date: Tue, 9 Aug 2022 18:45:26 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <8735e6ncxw.fsf@oldenburg.str.redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, andrew.jones@linux.dev,
 mathieu.desnoyers@efficios.com, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

Hi Florian,

On 8/9/22 4:33 PM, Florian Weimer wrote:
>> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
>> index a54d4d05a058..acb1bf1f06b3 100644
>> --- a/tools/testing/selftests/kvm/rseq_test.c
>> +++ b/tools/testing/selftests/kvm/rseq_test.c
>> @@ -9,6 +9,7 @@
>>   #include <string.h>
>>   #include <signal.h>
>>   #include <syscall.h>
>> +#include <dlfcn.h>
>>   #include <sys/ioctl.h>
>>   #include <sys/sysinfo.h>
>>   #include <asm/barrier.h>
> 
> I'm surprised that there isn't a Makefile update to link with -ldl
> (still required for glibc 2.33 and earlier).
> 

In next revision, I will add '-ldl' into tools/testing/selftests/kvm/Makefile.


>> @@ -36,6 +37,8 @@ static __thread volatile struct rseq __rseq = {
>>    */
>>   #define NR_TASK_MIGRATIONS 100000
>>   
>> +static bool __rseq_ownership;
>> +static volatile struct rseq *__rseq_info;
>>   static pthread_t migration_thread;
>>   static cpu_set_t possible_mask;
>>   static int min_cpu, max_cpu;
>> @@ -49,11 +52,33 @@ static void guest_code(void)
>>   		GUEST_SYNC(0);
>>   }
>>   
>> +static void sys_rseq_ownership(void)
>> +{
>> +	long *offset;
>> +	unsigned int *size, *flags;
>> +
>> +	offset = dlsym(RTLD_NEXT, "__rseq_offset");
>> +	size = dlsym(RTLD_NEXT, "__rseq_size");
>> +	flags = dlsym(RTLD_NEXT, "__rseq_flags");
>> +
>> +	if (offset && size && *size && flags) {
>> +		__rseq_ownership = false;
>> +		__rseq_info = (struct rseq *)((uintptr_t)__builtin_thread_pointer() +
>> +					      *offset);
> 
> __builtin_thread_pointer doesn't work on all architectures/GCC versions.
> Is this a problem for selftests?
> 

It's a problem as the test case is running on all architectures. I think I
need introduce our own __builtin_thread_pointer() for where it's not
supported: (1) PowerPC  (2) x86 without GCC 11

Please let me know if I still have missed cases where __buitin_thread_pointer()
isn't supported?

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
