Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BA6746A
	for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 19:17:38 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id n18-20020a056e02101200b0030f2b79c2ffso7978563ilj.20
        for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 11:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fyjTkhLZrTWoohCjmvJTtd+0ORPc3EOyjvAY5L0UihY=;
        b=DQgC+wref3ZZfq6NQghpzBT98IfRGeaWFdnnz9gIXiBMXGqmfgPFA+roHd4SPrNDqy
         D18K14KSNvVAYw3H/FcCnO/m+c7YNJH++8qPENzq2Q/hSDWKNhVhrTYGSX39XzSQwpZI
         RsoeP/O4VVN9QciM3k0bjutGtnzQ4Eyl7ZI0TVBemYoW1en8XqedhcwRw+YtKktllIoG
         jUhtN72OJx0iVRFY65N/uh6lbpWQuAHlUXHxMIMhNKF8O+bA6jsEbClseLkENel6tZH1
         HJ7Vc41AJDqFJkMVhJJw54yDzq85LtJaUVX85zcRytyKxN/e2nV5dVihzZiLX1ujGLTC
         noMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fyjTkhLZrTWoohCjmvJTtd+0ORPc3EOyjvAY5L0UihY=;
        b=6KbPtQ5hZpy8mda+S1mQnssYHepvFk9e66FOfLpYvAPrbF5EuC+diekWijhhnfEO4a
         kEC/F1Zbxsu16dvibSwYohdrKp27f2dLEQsvHKDzaJTvaW+6gHOn2IJ3adyNn0hghwzq
         iLGPm8SitoppJR2LCaS3L5MTYIZEqLSkpdz31mgtKHR0mgAX+h97HzI7xW2XwSy7HLaV
         9pS2cyFezR2vx4NLlrglVpNpNISRw3ZKak1JpgtcgRmFZqvRRNBj/DpBadL4x+kSanBR
         k3pLThb8XeSraRnLYhVweewA4nc8+ZjbcEzryYBdDoy8uRbHoH4JOQBj9UNd8aKVOR53
         GFVQ==
X-Gm-Message-State: AO0yUKV9vAbflbpqM7pL4uzF3jDNF8bg9bYB23Pn146Cy2NbZbBKDBI6
	WGOPQpHQ2X+7g7sg8fXupzIsDwXBOFc/VLL1yw==
X-Google-Smtp-Source: AK7set9uBH10NEbDk25RdS04vdk09knEV6dLDqseOWFpSz/3rjXgHZLPhALFwTdpz0RuKLKnNwP8m6rTTHk6BEIgrA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:6d19:0:b0:71b:cd53:2de1 with SMTP
 id a25-20020a6b6d19000000b0071bcd532de1mr756925iod.61.1675106257880; Mon, 30
 Jan 2023 11:17:37 -0800 (PST)
Date: Mon, 30 Jan 2023 19:17:36 +0000
In-Reply-To: <20230112085307.jvx5px2b3pfmwd6v@orel> (message from Andrew Jones
 on Thu, 12 Jan 2023 09:53:07 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt8rhjygq7.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
From: Colton Lewis <coltonlewis@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	imbrenda@linux.ibm.com, marcorr@google.com, alexandru.elisei@arm.com, 
	oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Sorry I missed this email earlier.

Andrew Jones <andrew.jones@linux.dev> writes:

> On Wed, Jan 11, 2023 at 09:54:22PM +0000, Colton Lewis wrote:
>> Replace the MAX_SMP probe loop in favor of reading a number directly
>> from the QEMU error message. This is equally safe as the existing code
>> because the error message has had the same format as long as it has
>> existed, since QEMU v2.10. The final number before the end of the
>> error message line indicates the max QEMU supports. A short awk
>> program is used to extract the number, which becomes the new MAX_SMP
>> value.

>> This loop logic is broken for machines with a number of CPUs that
>> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
>> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
>                                                                      ^ 1

>> 6. This can, in rare circumstances, lead to different test results
>> depending only on the number of CPUs the machine has.

> I guess that problem doesn't go away if we don't set the number of CPUs
> to be the same, regardless of machine, i.e. we're still picking a
> machine-specific value when we pick MAX_SMP. I think I know what you
> mean though. For gicv2 tests on machines that support non-power-of-2
> CPUs greater than 8 it's possible to end up with less than 8 for
> MAX_SMP, which is surprising. Maybe while fixing the shift above you
> can change the text to be more in line with that?

I will rephrase the message and fix the shift.


>> A previous comment explains the loop should only apply to kernels
>> <=v4.3 on arm and suggests deletion when it becomes tiresome to
>> maintian. However, it is always theoretically possible to test on a
>> machine that has more CPUs than QEMU supports, so it makes sense to
>> leave some check in place.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   scripts/runtime.bash | 16 +++++++---------
>>   1 file changed, 7 insertions(+), 9 deletions(-)

>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index f8794e9..4377e75 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -188,12 +188,10 @@ function run()
>>   # Probe for MAX_SMP, in case it's less than the number of host cpus.
>>   #
>>   # This probing currently only works for ARM, as x86 bails on another
>> -# error first. Also, this probing isn't necessary for any ARM hosts
>> -# running kernels later than v4.3, i.e. those including ef748917b52
>> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
>> -# point when maintaining the while loop gets too tiresome, we can
>> -# just remove it...
>> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
>> -		|& grep -qi 'exceeds max CPUs'; do
>> -	MAX_SMP=$((MAX_SMP >> 1))
>> -done
>> +# error first. The awk program takes the last number from the QEMU
>> +# error message, which gives the allowable MAX_SMP.
>> +if $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
>> +      |& grep -qi 'exceeds max CPUs'; then

> If the message has always been the same then the -i on grep shouldn't be
> necessary.

True. I was only copying the grep command that was there.

>> +	GET_LAST_NUM='/exceeds max CPUs/ {match($0, /[[:digit:]]+)$/); print  
>> substr($0, RSTART, RLENGTH-1)}'
>> +	MAX_SMP=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |&  
>> awk "$GET_LAST_NUM")

> We should restructure this so we only have to invoke QEMU once and I
> think we can do it with just bash and grep. Something like

>   if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |&  
> grep 'exceeds max CPUs'); then
>       smp=${smp##*\(}
>       MAX_SMP=${smp:0:-1}
>   fi
Good idea.
