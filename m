Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32578659
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 07:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675150771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NqWFZCMoZbKjkr6qHV37rtPcyidnztEiuJHNjLKNQDc=;
	b=OyyXxQbkpq4gxgFHnrJws81ShiOLKo437I2HW/OObFoYpou+DKUG9o+jGovGg59NuSBD7R
	mpzZ/ZvTbfLuWZAwMmYkKH4jeNWacOCFPqiBPRFoyRV4IF+sA8uYhA166fVPOLj4UOxLY6
	SR/q7d62nZvd7/jbD2mEfSnzstInZV4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-ItFJHi7KOZ-9RRxdl01w2A-1; Tue, 31 Jan 2023 02:39:17 -0500
X-MC-Unique: ItFJHi7KOZ-9RRxdl01w2A-1
Received: by mail-qv1-f69.google.com with SMTP id j7-20020a0cf507000000b0053b538958d5so3679732qvm.18
        for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 23:39:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqWFZCMoZbKjkr6qHV37rtPcyidnztEiuJHNjLKNQDc=;
        b=8Ap+wR+/NZYXwAfDsvdOfYmSsohO/v0SoduUjoAK40R5CSBJrFItonOB9HpkMpbdCb
         tJ7aaAeLgDkdumf0oRiw2AO1TXqPCxOpfvKRctR8swBs9yPFOrJVJGaBAFDHwvj9LTUG
         N99rJ2GuOIJJkH4Vz+4tKE/1ugUkmtpSfQaQZ3TSwexFmi3RhVRo91ktnEppA5yWRoZu
         AawOW5Ex1Sdw0HOrUi5GihzrJuRChHi8RBIxIn/se3r/RGEUtFuri+ubU9trMThP0URL
         rhl4Bjdo2m8oBjsJSXSaPt6e3v+EbW9QwWxP38ppDsijkcCbr5zoOp9TEzht0kVPwNC4
         fnYg==
X-Gm-Message-State: AO0yUKVBVg5ZHlfk7c++ut29I8eUxrAOeALEvh8kZ4MnRbZqpszYx5Mr
	ZeT9oEKtYE+uPY6SNHu7068eDS7jcHlGol9n1WmT/FcjPOcq117WcQnAGB4UPuZR7O2FKf6cbu6
	4EyZLsYtJLVv8+ohv
X-Received: by 2002:a05:622a:2cd:b0:3b9:a5d8:2c4d with SMTP id a13-20020a05622a02cd00b003b9a5d82c4dmr3906193qtx.53.1675150757406;
        Mon, 30 Jan 2023 23:39:17 -0800 (PST)
X-Google-Smtp-Source: AK7set/kbb8lIoDC0ZfQMp08DIj5gY8IgYDXxQsUxU/5Ud4IjT0Bc+P+4cGPhyTRBTriBOAn0sIwEQ==
X-Received: by 2002:a05:622a:2cd:b0:3b9:a5d8:2c4d with SMTP id a13-20020a05622a02cd00b003b9a5d82c4dmr3906174qtx.53.1675150757167;
        Mon, 30 Jan 2023 23:39:17 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-155.web.vodafone.de. [109.43.176.155])
        by smtp.gmail.com with ESMTPSA id z13-20020ac86b8d000000b003995f6513b9sm9401370qts.95.2023.01.30.23.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 23:39:16 -0800 (PST)
Message-ID: <f679707c-c868-2415-aa1e-d6a853c00e21@redhat.com>
Date: Tue, 31 Jan 2023 08:38:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v2 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
To: Colton Lewis <coltonlewis@google.com>
Cc: pbonzini@redhat.com, nrb@linux.ibm.com, andrew.jones@linux.dev,
 imbrenda@linux.ibm.com, marcorr@google.com, alexandru.elisei@arm.com,
 oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <gsnt7cx3ygnu.fsf@coltonlewis-kvm.c.googlers.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <gsnt7cx3ygnu.fsf@coltonlewis-kvm.c.googlers.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/01/2023 20.19, Colton Lewis wrote:
> Thomas Huth <thuth@redhat.com> writes:
> 
>> On 11/01/2023 22.54, Colton Lewis wrote:
>>> Replace the MAX_SMP probe loop in favor of reading a number directly
>>> from the QEMU error message. This is equally safe as the existing code
>>> because the error message has had the same format as long as it has
>>> existed, since QEMU v2.10. The final number before the end of the
>>> error message line indicates the max QEMU supports. A short awk
>>> program is used to extract the number, which becomes the new MAX_SMP
>>> value.
> 
>>> This loop logic is broken for machines with a number of CPUs that
>>> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
>>> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
>>> 6. This can, in rare circumstances, lead to different test results
>>> depending only on the number of CPUs the machine has.
> 
>>> A previous comment explains the loop should only apply to kernels
>>> <=v4.3 on arm and suggests deletion when it becomes tiresome to
>>> maintian. However, it is always theoretically possible to test on a
>>> machine that has more CPUs than QEMU supports, so it makes sense to
>>> leave some check in place.
> 
>>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>>> ---
...
>>> +if $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
>>> +      |& grep -qi 'exceeds max CPUs'; then
>>> +    GET_LAST_NUM='/exceeds max CPUs/ {match($0, /[[:digit:]]+)$/); print 
>>> substr($0, RSTART, RLENGTH-1)}'
>>> +    MAX_SMP=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& awk 
>>> "$GET_LAST_NUM")
>>> +fi
> 
>> Is that string with "exceeds" really still the recent error message of the
>> latest QEMU versions? When I'm running
> 
>>    qemu-system-aarch64 -machine virt -smp 1024
> 
>> I'm getting:
> 
>>    qemu-system-aarch64: Invalid SMP CPUs 1024. The max CPUs
>>    supported by machine 'virt-8.0' is 512
> 
>> ... thus no "exceeds" in here? What do I miss? Maybe it's better to just
>> grep for "max CPUs" ?
> 
> The full qemu command run by the test is much more complicated. It takes
> a different code path and results in different errors, including the
> "exceeds" one. All my testing has been done with QEMU v7.0, released
> 2022.

Could you please provide such a command line? I haven't been able to 
reproduce this with the current development version of QEMU (using TCG) - 
either I (likely) did something wrong, or the behavior of QEMU changed in 
the past months...

  Thanks,
   Thomas

