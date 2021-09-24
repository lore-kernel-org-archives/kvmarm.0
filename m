Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1033DC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 08:31:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7180E6124F
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 08:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7180E6124F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 000B94B11E;
	Fri, 24 Sep 2021 04:31:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gJIM3bcRe4AF; Fri, 24 Sep 2021 04:31:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF7FB4B0FC;
	Fri, 24 Sep 2021 04:31:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 482D14B093
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 04:31:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pLqq8xX-IJtl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 04:31:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11BAB4057F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 04:31:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632472266;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XSnZGJCbTcSJO6rG4phjkfI1j3OdPwdw6IlhGD/k0Oo=;
 b=bgDyA7Lovh1YWtEh0MKOkNqunUlaeV3k+FS+Xh0RAxSIsecWg9sy3rebqraOM8SsM35Zo1
 vi5Cnzt3qQc55KYl9ckMYjN74dqubiVIp2qZZX7yOqHTN5SNMNjhTBNa4E6nQ/c+pvrIT7
 lv0/aATCuEk6GTsH3qjZz7qEcJ0d3Zs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-QlYPSsYqOZar-yZ6PWw18A-1; Fri, 24 Sep 2021 04:31:03 -0400
X-MC-Unique: QlYPSsYqOZar-yZ6PWw18A-1
Received: by mail-ed1-f72.google.com with SMTP id
 q17-20020a50c351000000b003d81427d25cso9450443edb.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 01:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=XSnZGJCbTcSJO6rG4phjkfI1j3OdPwdw6IlhGD/k0Oo=;
 b=z2QhP7uS69PPgTgXj/fRZjnWvhRL9h32hECXCCG2y0u2IIq6XKT0CecgwAYmsUyhyK
 mGn/lLZNul4vQYreFWcw4eyT4yA3xZXQSPW71wwIcDebf3x5zcWR+Q613bf4NqygJeF7
 O8SepgLTrrauj9XpdzBWpAgIZDfPYo9L+aCZXXZfwYH/KHZPXEoQnENf5TLY8l9pLfO9
 RWiESF3TofyBsLf/K/Y6UrMfuLg+TpMk1qp7ZOZafzJ+UeQooZZI4KcruTF8DtAt5WQs
 iBwSQrj8dWF+JhhWHLLmfo4XCT5hA67G1mp+9D17IXay9Q3pFs0NeXEcxfAbCea9/4MV
 8SyQ==
X-Gm-Message-State: AOAM530F8Iq+QXXMVfWOLNYTXFSqv/5rrWztzo0eYMLpQ76SZJgKMpT1
 RPg8j7XkNNektiaJ+UK600mBgC7B3Y5BSC5jXHYZrvUbPvzUCxZguKCuw8VJ/043wNVHAfdvNEa
 oA0tsd9ui1LikTg+IvFc/vm4i
X-Received: by 2002:a50:cf48:: with SMTP id d8mr3594334edk.293.1632472262401; 
 Fri, 24 Sep 2021 01:31:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB6fhbrACM6SNmaKLXqckkt9a//IZZDZktY0WH+vM3AOK0/WS0xxZ16zy87K95z3GoU0t8WQ==
X-Received: by 2002:a50:cf48:: with SMTP id d8mr3594312edk.293.1632472262220; 
 Fri, 24 Sep 2021 01:31:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id eg39sm5347244edb.16.2021.09.24.01.31.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Sep 2021 01:31:01 -0700 (PDT)
Message-ID: <82950bfb-4624-b90d-0533-f62aeeb1b7de@redhat.com>
Date: Fri, 24 Sep 2021 10:30:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v7 3/6] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
To: Marcelo Tosatti <mtosatti@redhat.com>, Oliver Upton <oupton@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-4-oupton@google.com>
 <20210820124611.GA77176@fuller.cnet>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210820124611.GA77176@fuller.cnet>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On 20/08/21 14:46, Marcelo Tosatti wrote:
> On Mon, Aug 16, 2021 at 12:11:27AM +0000, Oliver Upton wrote:
>> Handling the migration of TSCs correctly is difficult, in part because
>> Linux does not provide userspace with the ability to retrieve a (TSC,
>> realtime) clock pair for a single instant in time. In lieu of a more
>> convenient facility, KVM can report similar information in the kvm_clock
>> structure.
>>
>> Provide userspace with a host TSC & realtime pair iff the realtime clock
>> is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
>> realtime value, advance the KVM clock by the amount of elapsed time. Do
>> not step the KVM clock backwards, though, as it is a monotonic
>> oscillator.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Oliver Upton <oupton@google.com>
> 
> This is a good idea. Userspace could check if host and destination
> clocks are up to a certain difference and not use the feature if
> not appropriate.
> 
> Is there a qemu patch for it?

Not yet, but Maxim had a patch for a similar series (though with a 
different userspace API).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
