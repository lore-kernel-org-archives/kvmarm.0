Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3853FC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 06:32:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAECF60EE3
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 06:32:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AAECF60EE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E8D4B0ED;
	Fri, 24 Sep 2021 02:32:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ByMe7F9qR8B; Fri, 24 Sep 2021 02:32:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177C14B10A;
	Fri, 24 Sep 2021 02:32:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4BF4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 02:32:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v0YJApG1BZc1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 02:32:22 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7A64B0ED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 02:32:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632465142;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uBkIEJDbBxNlkgRFQ8/A7W9IW8llN+C89N+NmBdxBxI=;
 b=ei5/XZ5zj6blC4g6MU4KHkkboYTMHS1GSpSeRYSPJvsfpI3yvXz23jqW47mllwA8yLbce0
 i2CQPhZdR/t6VVWmREFtmrOwWZUapuPewsTA5KQNvUIfKMa5gJXfzO6S+XoOM1dJzNUaQW
 6CbrR2/jrbhkKflXFFQj2yPLwJkP7uM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-VR6eeA_BMAmUhxf0ounA8g-1; Fri, 24 Sep 2021 02:32:21 -0400
X-MC-Unique: VR6eeA_BMAmUhxf0ounA8g-1
Received: by mail-ed1-f69.google.com with SMTP id
 z6-20020a50cd06000000b003d2c2e38f1fso9257613edi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 23:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=uBkIEJDbBxNlkgRFQ8/A7W9IW8llN+C89N+NmBdxBxI=;
 b=O7PM/FwlBzCInd3L6nOl93Pq/mcC/vFILjm6CXaCPCHHnPjQjDOrFcbbivV0bm/s9I
 R/2QDzWYyGKjKudp7FSt5oF0FlfyyVu821+DGW9jrFEbF7RUR+/7aoAxw+BGazA6gd4F
 Jcn9Du5VhwRx2oF5ZPG9TsNflcrLBrEnX0gXHA2TclDQTPcyX2Fgm2QnYVsno4OiOKD+
 HSpXLF+9s4aHqS1yg+D5HGbaL1s8u1VS0cA8NZMxigK5k7nqBUQf/FgPaAlaJ/57vfo9
 F1DIatL6GOj4kJUzgxKGLzW2yh+n1NLj6rCKAI1XATRdMSfOthCv7NVoNmElo+oRGU6w
 /RMQ==
X-Gm-Message-State: AOAM530P9k5+S8XSAmB8v0xqY7+V2YwVr1KVnzUCUPY4NLXWLy2t4s1H
 4zn8ax37zYFBV5zzjlFPh9GnrHOk9wMkxj/IbI5A860s3mM/neIR25+9XMwY+OpDZ8OrC4lHk0/
 TgwfkwhxrZMzfpbKkRWYZqMG+
X-Received: by 2002:a17:906:a08a:: with SMTP id
 q10mr9422227ejy.100.1632465139706; 
 Thu, 23 Sep 2021 23:32:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxHd4Z7Fb67q6/aljQvFd/oji25j39N16vuz/cbgsNufLPXtff1UfRG/aqAS1OzSfftRTGLw==
X-Received: by 2002:a17:906:a08a:: with SMTP id
 q10mr9422207ejy.100.1632465139453; 
 Thu, 23 Sep 2021 23:32:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id m13sm4383956ejn.3.2021.09.23.23.32.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Sep 2021 23:32:18 -0700 (PDT)
Message-ID: <f32ec41b-792c-3db3-3940-5d78f19a3d8f@redhat.com>
Date: Fri, 24 Sep 2021 08:32:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
To: Oliver Upton <oupton@google.com>, Sean Christopherson <seanjc@google.com>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <CAOQ_QsgScBRB+BEMC0Ysdq8EjLx3SLB9=pV=P4kQ3bfchm15Mw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAOQ_QsgScBRB+BEMC0Ysdq8EjLx3SLB9=pV=P4kQ3bfchm15Mw@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On 24/09/21 02:10, Oliver Upton wrote:
>>>         */
>>>        vm = vm_create_default(VCPU_ID, 0, guest_code);
>>> +     ucall_init(vm, NULL);
>> Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
>> going to remember to add this next time I write a common selftest, arm64 is the
>> oddball here.
> I think that is best, I was planning on sending out a fix that does
> this later on. Just wanted to stop the bleeding with a minimal patch
> first.

For now I've queued it, for 5.16 we can do it in vm_create().

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
