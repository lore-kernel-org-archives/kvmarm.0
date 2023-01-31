Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9264A20E4
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675162852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/vEsADki5Q+vuh8+dW4Sfzn1JKelRrET+KVQthmdvnY=;
	b=AkFmtlyqbxpqQtzQ6M9XztLMoVJwRNvngyXjCgyAr5fi0CHW3GmMhZachd0MUHqY/Pxwc8
	bgzcXPJoGu9NNVspBBQf109OwoW63oGeEJJS8+9T32GLZLZMYBYbjrw40fDuRUJz2W/IzC
	21eVtARkes3OrTQwRRRVUz+r4FC+3Ug=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-189-C7BOgeRUMu2LWCnI0-T60w-1; Tue, 31 Jan 2023 06:00:49 -0500
X-MC-Unique: C7BOgeRUMu2LWCnI0-T60w-1
Received: by mail-qk1-f198.google.com with SMTP id g22-20020a05620a13d600b00726e7ad3f44so428352qkl.8
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 03:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/vEsADki5Q+vuh8+dW4Sfzn1JKelRrET+KVQthmdvnY=;
        b=ZjBUaVear8hs5VrTQunz1MZ332sjQyLxdiL3OJzK4liTODpRQ1PKn4rohr1HDZTCIb
         1VqicKcbH7PmSrEbLwTPk0A4ypbfjzShxdDpKvqanHJ5Y/UvOPEFhHeEx1ql7SjmKczZ
         2C40Pj/dYKJLtzxOh6AhM2YaLRxr8FQx7Rh4oyKJaY84lP1KUohi0RygnqF381frDHPt
         7Gt+G2cuMYEvLMt2Aia8fmKyFiELckhLyYdiWxRZRXt9FROPc2v3pvfhrr2sVCLcnDSp
         Af2i9sp9jWUroryvbnAJ5gL54qkrPqGdxgnojfmRHFBF+EH1yzPksraVxu6Jqw9jbcHS
         U5UQ==
X-Gm-Message-State: AO0yUKVJESeFtnuzi2ksn61HK019yMNoegsomWnheadYq+vaeKbla33V
	gNCNWkFRqeohRWzajwqkwctjHw7Rq9uE8ytrRm6N510U4qeAZ7B7nY1Ib5qmdlKMVThZJvt0jR3
	uCJ3mMqzdvpcP585O
X-Received: by 2002:a05:622a:15c5:b0:3b8:6d92:bf62 with SMTP id d5-20020a05622a15c500b003b86d92bf62mr8431743qty.46.1675162848827;
        Tue, 31 Jan 2023 03:00:48 -0800 (PST)
X-Google-Smtp-Source: AK7set/mF94pWQd+qQNFN9TC5e4kLKvyGLJUhAz/q6EAFVu/nFoMdMZzTxlkBcszPUc11acZsafETg==
X-Received: by 2002:a05:622a:15c5:b0:3b8:6d92:bf62 with SMTP id d5-20020a05622a15c500b003b86d92bf62mr8431703qty.46.1675162848602;
        Tue, 31 Jan 2023 03:00:48 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-155.web.vodafone.de. [109.43.176.155])
        by smtp.gmail.com with ESMTPSA id o11-20020ac8428b000000b003b63b8df24asm2119653qtl.36.2023.01.31.03.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 03:00:48 -0800 (PST)
Message-ID: <0fac7f76-d74d-0ed1-f810-617e9e80165f@redhat.com>
Date: Tue, 31 Jan 2023 12:00:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>, pbonzini@redhat.com,
 nrb@linux.ibm.com, imbrenda@linux.ibm.com, marcorr@google.com,
 alexandru.elisei@arm.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230130195700.729498-1-coltonlewis@google.com>
 <20230130195700.729498-2-coltonlewis@google.com>
 <20230131063203.67qgjf2ispi2k6hd@orel>
 <03662bf9-1c92-085b-7418-f3a218093051@redhat.com>
 <20230131105746.yypnggzz7ifjmp4d@orel>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230131105746.yypnggzz7ifjmp4d@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/01/2023 11.57, Andrew Jones wrote:
> On Tue, Jan 31, 2023 at 08:41:39AM +0100, Thomas Huth wrote:
>> On 31/01/2023 07.32, Andrew Jones wrote:
>>> On Mon, Jan 30, 2023 at 07:57:00PM +0000, Colton Lewis wrote:
>>>> Replace the MAX_SMP probe loop in favor of reading a number directly
>>>> from the QEMU error message. This is equally safe as the existing code
>>>> because the error message has had the same format as long as it has
>>>> existed, since QEMU v2.10. The final number before the end of the
>>>> error message line indicates the max QEMU supports. A short awk
>>>
>>> awk is not used, despite the comment also being updated to say it's
>>> being used.
>>>
>>>> program is used to extract the number, which becomes the new MAX_SMP
>>>> value.
>>>>
>>>> This loop logic is broken for machines with a number of CPUs that
>>>> isn't a power of two. This problem was noticed for gicv2 tests on
>>>> machines with a non-power-of-two number of CPUs greater than 8 because
>>>> tests were running with MAX_SMP less than 8. As a hypthetical example,
>>
>> s/hypthetical/hypothetical/
>>
>>>> a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
>>>> 6. This can, in rare circumstances, lead to different test results
>>>> depending only on the number of CPUs the machine has.
>>>>
>>>> A previous comment explains the loop should only apply to kernels
>>>> <=v4.3 on arm and suggests deletion when it becomes tiresome to
>>>> maintian. However, it is always theoretically possible to test on a
>>
>> s/maintian/maintain/
>>
>>>> machine that has more CPUs than QEMU supports, so it makes sense to
>>>> leave some check in place.
>>>>
>>>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>>>> ---
>>>>    scripts/runtime.bash | 16 +++++++---------
>>>>    1 file changed, 7 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>>>> index f8794e9a..587ffe30 100644
>>>> --- a/scripts/runtime.bash
>>>> +++ b/scripts/runtime.bash
>>>> @@ -188,12 +188,10 @@ function run()
>>>>    # Probe for MAX_SMP, in case it's less than the number of host cpus.
>>>>    #
>>>>    # This probing currently only works for ARM, as x86 bails on another
>>>
>>> It just occurred to me that this code runs on all architectures, even
>>> though it only works for Arm. We should wrap this code in $ARCH
>>> checks or put it in a function which only Arm calls. That change
>>> should be a separate patch though.
>>
>> Or we just grep for "max CPUs", since this seems to be used on other
>> architectures, too:
>>
>> $ qemu-system-x86_64 -smp 12345
>> qemu-system-x86_64: Invalid SMP CPUs 12345. The max CPUs supported by
>> machine 'pc-i440fx-8.0' is 255
>>
>> ?
>>
> 
> Yes, if we can find an arch-common way to set MAX_SMP, then the variable
> could be used in their test configs and gitlab-ci scripts. For example,
> afaict, x86 doesn't have any tests that run with more than 4 cpus at the
> moment. Being able to bump that up for some tests might increase test
> coverage. That said, it might be stretching the scope of this patch a bit
> much. How about we keep the grep the same for now and guard with $ARCH.
> Other architectures can either share Arm's grep, tweak the grep and share
> it, or add their own grep, when/if they want to start using MAX_SMP.

Ok, fair point, we still can adjust later.

  Thomas


