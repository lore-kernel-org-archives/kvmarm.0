Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74AEC43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 09:22:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFA84A105;
	Fri, 17 Jun 2022 05:22:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D6ylUt0n+woW; Fri, 17 Jun 2022 05:22:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6554B287;
	Fri, 17 Jun 2022 05:22:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B22DA4B178
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 05:22:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dwauKG7WyliT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 05:22:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8865F4A105
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 05:22:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655457740;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0FjuEQv4Qeb+ua2EzfVRmN0EZRhGaGIjPcxZ3XMGWqQ=;
 b=RoW4V/2cIjCODXreqwy4XfQmIUUugPlbAckZCowhMmSfkXNhA3ncncd+xlnot2VMxWxsDW
 F/yOLGjdpGzjb7Z4qh7xt1t3tXbjubD1C/YDe9H0uyOL+RzVhj+CipJ9O9yl8JAWXp4Vm+
 nwEt0awW4uKWPJrr33+L8i4z9Iw4Dzc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-M1368SW4O2-zE5JELEabsQ-1; Fri, 17 Jun 2022 05:22:17 -0400
X-MC-Unique: M1368SW4O2-zE5JELEabsQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 w22-20020a05640234d600b0043559f4c95aso1853759edc.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 02:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=0FjuEQv4Qeb+ua2EzfVRmN0EZRhGaGIjPcxZ3XMGWqQ=;
 b=W/402hgSqvNljpbmGDAteVEPD+1ILsbwHbRJmkta+/wxK4PE9CeHNSPix3b5G9CrEJ
 kFRZ7CQ4N7EkANVKQ2cXTEfrE/UCgouQl2wRPXPkpKCJgmU4WmrBtV8nHmXKbpX9ZwWO
 zN86t2WlQ14Tjn78aOOLwBg1T+FT002U0K6yzHApeGXrIxZwWQ7w+j8pMYmjFtiZb4V0
 q7zmAM68q9rmKEdHABhXI5BY3e/vPylFVjIb54smOPVzcfNAZWtudOy1mGX0qczGmknh
 lSGj8+9kcO/YBfU/J7jYHqK8SGvKyFVQoIt9lC+UFYQfH6VRvyRiTPWfhPOsVY5Wsca1
 eafw==
X-Gm-Message-State: AJIora8gDw2H8IGwZhNd118MB/fox/tdeQCv+uak9ilr5pj9iDfI5QRq
 057O/1kEtXqNZWLSZ55JBxCVArZBa8fkmYGfkyOHIF9UIJKQYMcVtLiAs5kileZ3d+8TQE6fqJ7
 g4fyiUJOC72MUhtb0U1lofNk2
X-Received: by 2002:a17:907:c202:b0:710:8d1c:2501 with SMTP id
 ti2-20020a170907c20200b007108d1c2501mr8036313ejc.377.1655457736795; 
 Fri, 17 Jun 2022 02:22:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sxScwELvm5Z4jJpyq2068amOUJIbJurQnj8zaZ+VzizUFIGSt842UCMnLfjZlggLVeac5uRA==
X-Received: by 2002:a17:907:c202:b0:710:8d1c:2501 with SMTP id
 ti2-20020a170907c20200b007108d1c2501mr8036279ejc.377.1655457736560; 
 Fri, 17 Jun 2022 02:22:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 h18-20020a056402281200b0043173ab6728sm3611928ede.7.2022.06.17.02.22.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 17 Jun 2022 02:22:13 -0700 (PDT)
Message-ID: <34e1b920-0a6b-5030-bbd9-6b1816789b8d@redhat.com>
Date: Fri, 17 Jun 2022 11:22:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
To: Andrew Jones <drjones@redhat.com>, David Laight <David.Laight@aculab.com>
References: <3e73cb07968d4c92b797781b037c2d45@AcuMS.aculab.com>
 <20220615185706.1099208-1-rananta@google.com>
 <20220616120232.ctkekviusrozqpru@gator>
 <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
 <20220616162557.55bopzfa6glusuh5@gator>
 <7b1040c48bc9b2986798322c336660ab@linux.dev>
 <2ec9ecbfb13d422ab6cda355ff011c9f@AcuMS.aculab.com>
 <20220617072800.cvqb4wmafxdi3knq@gator>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220617072800.cvqb4wmafxdi3knq@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Colton Lewis <coltonlewis@google.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On 6/17/22 09:28, Andrew Jones wrote:
> On Thu, Jun 16, 2022 at 09:54:16PM +0000, David Laight wrote:
>> From: oliver.upton@linux.dev
>>> Sent: 16 June 2022 19:45
>>
>>>
>>> June 16, 2022 11:48 AM, "David Laight" <David.Laight@aculab.com> wrote:
>>>> No wonder I was confused.
>>>> It's not surprising the compiler optimises it all away.
>>>>
>>>> It doesn't seem right to be 'abusing' WRITE_ONCE() here.
>>>> Just adding barrier() should be enough and much more descriptive.
>>>
>>> I had the same thought, although I do not believe barrier() is sufficient
>>> on its own. barrier_data() with a pointer to uc passed through
>>> is required to keep clang from eliminating the dead store.
>>
>> A barrier() (full memory clobber) ought to be stronger than
>> the partial one than barrier_data() generates.
>>
>> I can't quite decide whether you need a barrier() both sides
>> of the 'magic write'.
>> Plausibly the compiler could discard the on-stack data
>> after the barrier() and before the 'magic write'.
>>
>> Certainly putting the 'magic write' inside a asm block
>> that has a memory clobber is a more correct solution.
> 
> Indeed, since the magic write is actually a guest MMIO write, then
> it should be using writeq().

It doesn't need to use writeq() because no special precautions are 
needed with respect to cacheability or instruction reordering (as is the 
case with hardware registers).

WRITE_ONCE is okay, especially since the code never reads it (and if it 
did it would also use READ_ONCE).

Paolo


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
