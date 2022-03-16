Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C74C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 07:53:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C14E949F27;
	Wed, 16 Mar 2022 03:53:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y6ZI03M0Yceh; Wed, 16 Mar 2022 03:53:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E67249F21;
	Wed, 16 Mar 2022 03:53:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01CC3408AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 03:53:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OkI315hpNzUW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 03:53:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA57F4088C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 03:53:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647417229;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xbrJE+kT+A4TgNq8to760TzvdzqcyJdX7Cp/jTz5ddk=;
 b=XugeXJ7Eus/5iy1hfbiMcEoIEXCkmqdo1nM5R6fxUkNJOgO/tqeh6nU58s21yLm0sLqu33
 wBmuu870yMRwQN4fX1IQ3boA70wcc39B+n8bIJU60vjIzwCFLUtzaXMnUATRJt5CScL82a
 Czrv1Zd0QS14HxXDaaIx8oFLU5RmRdU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-oFTkfQxHNQaJB1UCY7lPDQ-1; Wed, 16 Mar 2022 03:53:48 -0400
X-MC-Unique: oFTkfQxHNQaJB1UCY7lPDQ-1
Received: by mail-wm1-f70.google.com with SMTP id
 n62-20020a1ca441000000b0038124c99ebcso501816wme.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 00:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=xbrJE+kT+A4TgNq8to760TzvdzqcyJdX7Cp/jTz5ddk=;
 b=kw8ereJSNG3TWn5swKboABrIOPzJQTsK5gp+w+0qYr4CsStq1encdWGk7v3Q/KVzCr
 ct6bqddyDn1LKeP+t+q/gPPqvYIX7GpwshWSXqoVsZwoujfuhXHP/z8+QBxTdDLbUfCO
 te6jL0juMMvibIMHAX5n8sIN9sHTrH947PX3c/8AZIXzEk/BYytb0PHe1f8yS6PBgfrX
 +4S8EWOOizTGfPYNQxWwxXUlEKwviIYCO6DpQhcAOFaAI/s0jdkzBvG0J1I22HlJl6Vi
 b/mMvfa0FHVMQPPi+zUqBoJBQEjmpo+eiQEeyi5D86WeSdXaIFAk39hYIlk+wBKl2NuT
 YRMA==
X-Gm-Message-State: AOAM533Wj6kBImpoRCrLpz8FphctVSOdb0YU0Xz8cE2Ak0XRK64s9rBW
 pLj/KyzMjL9u/PCc3CuW0I7f88OLGyrF4F9O5nQuPIfT+K7uxhda0G30T6XAcZfeOwubGAmVl0Y
 Nlul6Hwf4p3B4rvbvjIPad7E7
X-Received: by 2002:a1c:4c13:0:b0:389:a4ab:df7c with SMTP id
 z19-20020a1c4c13000000b00389a4abdf7cmr6206723wmf.14.1647417226853; 
 Wed, 16 Mar 2022 00:53:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+ih92S8u3acUVacRNC38Qj2+u/ewT64E9VVLdgOqn7mbnYPyPFAiPxKeeFBjt2DWcwzIGBA==
X-Received: by 2002:a1c:4c13:0:b0:389:a4ab:df7c with SMTP id
 z19-20020a1c4c13000000b00389a4abdf7cmr6206704wmf.14.1647417226551; 
 Wed, 16 Mar 2022 00:53:46 -0700 (PDT)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
 by smtp.gmail.com with ESMTPSA id
 k18-20020a5d6d52000000b00203da94cf01sm982259wri.14.2022.03.16.00.53.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Mar 2022 00:53:46 -0700 (PDT)
Message-ID: <334cc93e-9843-daa9-5846-394c199e294f@redhat.com>
Date: Wed, 16 Mar 2022 08:53:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
To: Andrew Jones <drjones@redhat.com>, Bill Wendling <morbo@google.com>
References: <20220316060214.2200695-1-morbo@google.com>
 <20220316074356.n7e5lzrmnal2dcgu@gator>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220316074356.n7e5lzrmnal2dcgu@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=thuth@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
 kvm@vger.kernel.org, david@redhat.com, kvm-ppc@vger.kernel.org,
 Nikos Nikoleris <nikos.nikoleris@arm.com>, pbonzini@redhat.com,
 imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

On 16/03/2022 08.43, Andrew Jones wrote:
> On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
>> Clang warns about using a bitwise '|' with boolean operands. This seems
>> to be due to a small typo.
>>
>>    lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>>            if (can_assume(LIBFDT_ORDER) |
>>
>> Using '||' removes this warnings.
>>
>> Signed-off-by: Bill Wendling <morbo@google.com>
>> ---
>>   lib/libfdt/fdt_rw.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
>> index 13854253ff86..3320e5559cac 100644
>> --- a/lib/libfdt/fdt_rw.c
>> +++ b/lib/libfdt/fdt_rw.c
>> @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
>>   			return struct_size;
>>   	}
>>   
>> -	if (can_assume(LIBFDT_ORDER) |
>> +	if (can_assume(LIBFDT_ORDER) ||
>>   	    !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
>>   		/* no further work necessary */
>>   		err = fdt_move(fdt, buf, bufsize);
>> -- 
>> 2.35.1.723.g4982287a31-goog
>>
> 
> This is fixed in libfdt upstream with commit 7be250b4 ("libfdt:
> Correct condition for reordering blocks"), which is in v1.6.1.
> We can either take this patch as a backport of 7be250b4 or we
> can rebase all of our libfdt to v1.6.1. Based on the number of
> fixes in v1.6.1, which appear to be mostly for compiling with
> later compilers, I'm in favor of rebasing.

+1 for updating to v1.6.1 completely.

> Actually, we can also use this opportunity to [re]visit the
> idea of changing libfdt to a git submodule. I'd like to hear
> opinions on that.

I'm always a little bit torn when it comes to this question. Sure, git 
submodules maybe make the update easier ... but they are a real pita when 
you're working with remote machines that might not have direct connection to 
the internet. For example, I'm used to rsync my sources to the non-x86 
machines, and if you forget to update the submodule to the right state 
before the sync, you've just lost. So from my side, it's a preference for 
continuing without submodules (but I won't insist if everybody else wants to 
have them instead).

  Thomas

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
