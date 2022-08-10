Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D700CC00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 12:19:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E3E84D8AE;
	Wed, 10 Aug 2022 08:19:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vehLJ80cnn7y; Wed, 10 Aug 2022 08:19:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 325BD4D8C0;
	Wed, 10 Aug 2022 08:19:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 011934D8AE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:19:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V6nHUEMFRWaT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 08:19:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BFB4D7DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:19:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660133956;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0z7Zcbu+4x+/8ByQeQoUUCbO5l7ndOcAPekSmvOfATk=;
 b=iataZB7t0KvU4TuKQ661NFatO3dECgsWpahJx2nCBcKBHoICvzYoHU/Cr7INbaotBy6dhP
 x7/3paPMCAs6+Zrde031uXrXBkMhrUWv1wtUAVk1s9PIpOTLjH2ZfPwRyz4UmE1PfjqMyX
 Uji/rhKecV3TATVeBmenrE5FGHxZTrc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-183-25gez7GGNQWbppGYFs9YhA-1; Wed, 10 Aug 2022 08:19:15 -0400
X-MC-Unique: 25gez7GGNQWbppGYFs9YhA-1
Received: by mail-ed1-f71.google.com with SMTP id
 m22-20020a056402431600b0043d6a88130aso9027490edc.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=0z7Zcbu+4x+/8ByQeQoUUCbO5l7ndOcAPekSmvOfATk=;
 b=nu12oETE1ypwGoCYYki4Gcmpc5/scwTS0cyM+V2+qntKG5PAFGX7D5q1qElMgnRZui
 qTguEgP0J0sk87Yd1AuKOJgmSBlPKWpL2GKUi8sonVZqKXX9KxA+Ty5TkiunyaX90ok1
 8IcB/UV/vjKwFxjsMuaLU4mHNtrQPC4DNiLBy0dTmMcu/Z23mU1eNSuQNh24ZMObsx/2
 tI1leWHSFqRJebXILnb+715PJfkOIlE1sJHX248n1AJuIpOAqSECqzzGfC/CEYZnO9X2
 X+HOf13Y9kYKICLtOG/Q8mmxhQ7y6JqOzYx4XixVeeD/PKKlbqOdnivA9uix3HZJskUh
 MMgg==
X-Gm-Message-State: ACgBeo1b7B5zyhtwA3FoLSz7COv4RGQR3C/kvLxAHBd+THppi8CHoqR/
 fjcWhfuj9F2CH1usB50RTXPMoWF2TdTVYFFuWz0186djXjCBFksmbT+WOoMLPCEPxsnaIvS6gKz
 3tRwHr+loXyzy3KwRgyN54h4G
X-Received: by 2002:a17:906:5a6a:b0:730:bc8a:57dd with SMTP id
 my42-20020a1709065a6a00b00730bc8a57ddmr19475541ejc.301.1660133954448; 
 Wed, 10 Aug 2022 05:19:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4KWNsnIMIIjdxc45teRDYtyGYIM95O2JKOc/vdql5qtoATPjlBo5mU4aLGO+26B65zs0mtZQ==
X-Received: by 2002:a17:906:5a6a:b0:730:bc8a:57dd with SMTP id
 my42-20020a1709065a6a00b00730bc8a57ddmr19475525ejc.301.1660133954210; 
 Wed, 10 Aug 2022 05:19:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 fu14-20020a170907b00e00b007330ad36237sm699707ejc.151.2022.08.10.05.19.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Aug 2022 05:19:13 -0700 (PDT)
Message-ID: <ae135a39-4190-041b-93dd-be2610125631@redhat.com>
Date: Wed, 10 Aug 2022 14:19:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
 <bb97efaf-4f58-c192-a489-e71ebbebce8c@redhat.com>
 <392275844.358.1660133856396.JavaMail.zimbra@efficios.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <392275844.358.1660133856396.JavaMail.zimbra@efficios.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu <yihyu@redhat.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On 8/10/22 14:17, Mathieu Desnoyers wrote:
> Indeed, this hack seems to be a good approach to immediately fix things without
> moving around all source files and headers. In the longer term, I'd prefer Sean's
> proposal to move rseq.c to tools/lib/ (and to move rseq headers to tools/include/rseq/).
> This can be done in a follow up phase though. I'll put a note on my todo list
> for after I come back from vacation.

Great, Gavin, are you going to repost using librseq?

>> Yeah, rseq_test should reuse librseq code.  The simplest way,
>> if slightly hackish, is to do something like
>> 
>> diff --git a/tools/testing/selftests/kvm/Makefile
>> b/tools/testing/selftests/kvm/Makefile
>> index 690b499c3471..6c192b0ec304 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -37,6 +37,7 @@ ifeq ($(ARCH),riscv)
>>  	UNAME_M := riscv
>>  endif
>>  
>>  LIBKVM += lib/assert.c
>>  LIBKVM += lib/elf.c
>>  LIBKVM += lib/guest_modes.c
>> @@ -198,7 +199,7 @@ endif
>>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>>  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>> -	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
>> +	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES) -I../rseq
>>  
>>  no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
>>          $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)
>> 
>> 
>> and just #include "../rseq/rseq.c" in rseq_test.c.



Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
