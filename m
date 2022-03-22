Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E14C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 13:45:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D959349F2F;
	Tue, 22 Mar 2022 09:45:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 43BtlcJxZ6u0; Tue, 22 Mar 2022 09:45:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E64049F3E;
	Tue, 22 Mar 2022 09:45:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4230549F2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 09:45:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jlZ1C328q46r for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 09:45:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF6B449F2E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 09:45:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647956701;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ANKRQzRELaWdzD2QZS9qzovKRV7eroomvX7D4M7GefI=;
 b=ffIGVL4PPnnMxIdJivdHpxsXnt4Vzs3oMXtKYANY+VTrECz/HIgDFKboTzEkse2oSmZLXX
 vk1y21EBiZquugxa2ekHNbsLIDb8EDO7I2v+i9zZcN3DLrN0MPapmuFPbyTuTsINdPrr88
 Q3ifd07zSJejTXs9qYj63ZfdfMyxEZM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-ovwsJZXMMmmA35BvFYWvoA-1; Tue, 22 Mar 2022 09:44:40 -0400
X-MC-Unique: ovwsJZXMMmmA35BvFYWvoA-1
Received: by mail-wm1-f71.google.com with SMTP id
 2-20020a1c0202000000b0038c71e8c49cso1318153wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 06:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=ANKRQzRELaWdzD2QZS9qzovKRV7eroomvX7D4M7GefI=;
 b=6dUJHrYEaZ71+zAHoiwixMdAJuKRkbzf50cFEezB7O6iVAeKZDG/becGJGrcf0HEbN
 eQMkP1T9tJbspvSrm7agbMC50VYN+hOjJyUlU3q/s61GrKZaOly2Xh2dD6RJrhpnToVC
 2JYFUO+kazamDJh3cGSnAh/1V+uOg5LQelztoDxWMGAsnp4Pjks0MgS4WF2g4Zdzopi2
 w01RmuBD44hY1TYOpy6keWDaAvw/9hfKtwjRkD7nCB1N4H586Ivwz2FGe04quhucJw2/
 R+b/GmHmm6rwSzTcIt1yDPq6jJyUWMDwEpNzgJinp1GyroYWX+tkFEvOrwZYG5xu2OPs
 VAYQ==
X-Gm-Message-State: AOAM530EoKqLn8iagQOaoqeDBgiDUlHcq8mkbnfTQb4yVqqU+qciJaVa
 pmnrpdTCNoVGJlzwqsTejUQgAagnIXb7PCRmVsF0HS+IDmKxGDWwq1G+w7Pksdt2lb8TAEpo+Zc
 7fhlDNULeGF8INIueeVS6NHfe
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id
 j14-20020a05600c190e00b0038cb1eaf4acmr3938607wmq.70.1647956678927; 
 Tue, 22 Mar 2022 06:44:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKzYLnUW0xmdSIOPKaXoGHiETfm21cVrTbD3uRC5iXSe1fa2PPvEzTtyV8TFh7MPCRVt9NLQ==
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id
 j14-20020a05600c190e00b0038cb1eaf4acmr3938572wmq.70.1647956678543; 
 Tue, 22 Mar 2022 06:44:38 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
 by smtp.gmail.com with ESMTPSA id
 e8-20020a056000178800b00203da3bb4d2sm16782777wrg.41.2022.03.22.06.44.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Mar 2022 06:44:37 -0700 (PDT)
Message-ID: <da339883-fc3a-da42-a071-d6e6c9f88b3e@redhat.com>
Date: Tue, 22 Mar 2022 14:44:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
To: Andrew Jones <drjones@redhat.com>, Bill Wendling <morbo@google.com>
References: <20220316060214.2200695-1-morbo@google.com>
 <20220318093601.zqhuzrp2ujgswsiw@gator>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220318093601.zqhuzrp2ujgswsiw@gator>
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

On 18/03/2022 10.36, Andrew Jones wrote:
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
> We're not getting as much interest in the submodule discussion as I hoped.
> I see one vote against on this thread and one vote for on a different
> thread[1]. For now I'll just commit a big rebase patch for libfdt. We can
> revisit it again after we decide what to do for QCBOR.

I recently learnt that there are indeed people who ship kvm-unit-tests with 
their distro - at least buildroot has a package:
https://git.busybox.net/buildroot/tree/package/kvm-unit-tests

So one more argument for copying the files over instead of using submodules: 
The tarballs for tags will be self-contained, e.g.:

https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/archive/v2022-03-08/kvm-unit-tests-v2022-03-08.tar.gz

If we use submodules, I guess the content of the submodule content will be 
missing in there?

  Thomas

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
