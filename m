From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: Re: [Qemu-devel] [RFC QEMU 1/2] arm/virt: Initialize generic timer
 scale factor dynamically
Date: Fri, 9 Nov 2018 19:12:08 -0800
Message-ID: <7cfea6b6-b0eb-f276-edc7-da2e7f77ded0@oracle.com>
References: <1541616504-68526-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1541616504-68526-2-git-send-email-bijan.mottahedeh@oracle.com>
 <47f78310-56e7-ba5e-0fb1-99830750e49b@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9B94A359
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Nov 2018 22:12:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZmejkLHmEgHX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Nov 2018 22:12:17 -0500 (EST)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CE674A34F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Nov 2018 22:12:17 -0500 (EST)
In-Reply-To: <47f78310-56e7-ba5e-0fb1-99830750e49b@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 11/8/2018 6:21 AM, Richard Henderson wrote:
> On 11/7/18 7:48 PM, Bijan Mottahedeh wrote:
>>   
>> +static void set_system_clock_scale(void)
>> +{
>> +    unsigned long cntfrq_el0;
>> +
>> +    asm volatile("mrs %0, cntfrq_el0" : "=r"(cntfrq_el0));
>> +
>> +    if (cntfrq_el0 == 0) {
>> +        cntfrq_el0 = GTIMER_SCALE_DEF;
>> +    }
>> +
>> +    system_clock_scale = NANOSECONDS_PER_SECOND / (int)cntfrq_el0;
>> +}
> This only works for kvm.
>
> For TCG you need to use the default always.  In particular, it won't even
> compile for an x86 host.
>
>
> r~
Is it ok to ifdef the asm statement with CONFIG_KVM, or what would be 
the correct way to account for TCG vs. KVM?

Thanks.

--bijan
