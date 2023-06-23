Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D00100AB
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 16:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687536211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yGvZEb4xaeTCLlMZCHf/6JLvoihCjh5MngBavGT5bMs=;
	b=DhEdJhdNx+WcDykrv8x9+RBJisPJqH499XmnRbR5//9B8OIYoNr6gD2JVqUsnwJVS4OWg1
	EWosfYir8reJxnJx4b0K+2wPuVOePsW8CxZ1Ixd8pBfZ7BUqm6EAWGpeP/jy4lr1s/sQQo
	NhPmZQM5boZZhL9D7Z3qVKsw4sxh2oM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-DIntmpvFMcaRIpi9Mqwexg-1; Fri, 23 Jun 2023 12:03:28 -0400
X-MC-Unique: DIntmpvFMcaRIpi9Mqwexg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f624a4ea72so608971e87.2
        for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 09:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687536207; x=1690128207;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGvZEb4xaeTCLlMZCHf/6JLvoihCjh5MngBavGT5bMs=;
        b=hq1ylFvlSUYiZ8awrCj5/ztTvy38KOd5pAY0NbH06OhwbkF/NV39os1I0Eloq2JZSa
         I6yxQEAsRJYQ03S0zJVPEgVcWZmWP//J0ZMHnqlEwUbIDwcQkkvv8D1vwhgPxxLthoAs
         MrqLopyk2EjVVHbNJy/HUBsJ1YVKdKR1V8KdQcHUxEL2JaPQPtxQCoXiBG+Ilncvn9+n
         2sUoa2FeWMJhPymqcVQajwsoAU1taOe0LxvQrAU3rV5hrMEEvFpWQMfOm6JTDJuYhdep
         uMz27zYxe+CmmBeZPRXH2OJ/1E/146aSm6XicjXkr0bTOLIwCfjlZRiOr7g7AJOtcURw
         gBEg==
X-Gm-Message-State: AC+VfDxPCjPLFchs1LAHrAqws8kzLjUZTE6KyxWNIZjIIjEOa98PHmM1
	EAw7UIr2UtGuUiBXaDG1rxGlaTyB70SVUr9ghbdv4Ai83w8nZLiQyQH5KVntkFaPprRvoq23/F7
	uPGdSxr7Hi3t8GoEJ
X-Received: by 2002:a19:6601:0:b0:4f6:6037:128e with SMTP id a1-20020a196601000000b004f66037128emr13950318lfc.57.1687536207032;
        Fri, 23 Jun 2023 09:03:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4FhNowTVfmy0Vku7MNzLc5bMuiBYL6uHFIN/glgac8uc/9qkhgwWZMHcPVOfP2JGnHjumDqA==
X-Received: by 2002:a19:6601:0:b0:4f6:6037:128e with SMTP id a1-20020a196601000000b004f66037128emr13950297lfc.57.1687536206687;
        Fri, 23 Jun 2023 09:03:26 -0700 (PDT)
Received: from [192.168.8.100] (tmo-099-170.customers.d1-online.com. [80.187.99.170])
        by smtp.gmail.com with ESMTPSA id f2-20020a056402004200b0051bde3e1e48sm3461571edu.96.2023.06.23.09.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 09:03:25 -0700 (PDT)
Message-ID: <fc70263c-b7af-d8e0-14f4-4ffcde67aa3e@redhat.com>
Date: Fri, 23 Jun 2023 18:03:23 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH 2/2] Link with "-z noexecstack" to avoid
 warning from newer versions of ld
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Nico_B=c3=b6hr?= <nrb@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Andrew Jones
 <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Laurent Vivier <lvivier@redhat.com>
References: <20230623125416.481755-1-thuth@redhat.com>
 <20230623125416.481755-3-thuth@redhat.com> <ZJWrKtnflTrskPkX@google.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <ZJWrKtnflTrskPkX@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/06/2023 16.24, Sean Christopherson wrote:
> On Fri, Jun 23, 2023, Thomas Huth wrote:
>> Newer versions of ld (from binutils 2.40) complain on s390x and x86:
>>
>>   ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies
>>                executable stack
>>   ld: NOTE: This behaviour is deprecated and will be removed in a
>>             future version of the linker
>>
>> We can silence these warnings by using "-z noexecstack" for linking
>> (which should not have any real influence on the kvm-unit-tests since
>> the information from the ELF header is not used here anyway, so it's
>> just cosmetics).
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 0e5d85a1..20f7137c 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>>   
>>   autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>>   
>> -LDFLAGS += -nostdlib
>> +LDFLAGS += -nostdlib -z noexecstack
> 
> Drat, the pull request[1] I sent to Paolo yesterday only fixes x86[2].

Oops, sorry, I did not notice that patch in my overcrowded mailboxes (or 
forgot about it during KVM forum...) :-/

> Paolo, want me to redo the pull request to drop the x86-specific patch?

I can also respin my patch on top of your series later ... the problem 
currently also only seems to happen on x86 and s390x, on ppc64 and aarch64, 
the linker does not complain ... so maybe it's even better to do it 
per-architecture only anyway? Opinions?

  Thomas

