Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DCCC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:04:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE66261058
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE66261058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E629407D1;
	Mon, 27 Sep 2021 11:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DN9vQpA9hYGi; Mon, 27 Sep 2021 11:04:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BD4349F5F;
	Mon, 27 Sep 2021 11:04:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7801407D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:04:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 90eZgI6IINTN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 11:04:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB99940630
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:04:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632755040;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=r/mgKtKp5KKfxcrjzch748kWu470axxG1OqY2NSG+pg=;
 b=YWXa4ceanug9gp8E7xrMg7zT2lRpaIvboHjTbrZkC1+iqqgD9nZhArJN0b6YZ/BhhyGY7U
 ZKdNVxm9q0pvMvapi3c3lW1RdzokydGsQ+IxZB+q/dxOmIVTA51RLe69ybLdo/PwHcYxfi
 BHU1J8Y2YbAfUpOzJtTCSd7xI7wxqu8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-bdwlwixcOKW53G2Hivlaag-1; Mon, 27 Sep 2021 11:03:59 -0400
X-MC-Unique: bdwlwixcOKW53G2Hivlaag-1
Received: by mail-wr1-f70.google.com with SMTP id
 c15-20020a5d4ccf000000b0015dff622f39so14163103wrt.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 08:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=r/mgKtKp5KKfxcrjzch748kWu470axxG1OqY2NSG+pg=;
 b=go58bTibZLRKd5ICuzldbySI21qvxFbqZGTKngzHCJHnOraUK4Z1/A8meR6iCYtSQy
 w3xo+FdOd+/uydBaeowLscDKmBrFCR0JXf9Ksdi8xAfj4TzKIHH74Ny3UPJxebw5wn6t
 uPSgpENIW78zMAnNt1td0eg2oiluZrezUVq9JhxWmy2fNnTFomivH3epqvSdBk8KQk/E
 3iU3cK+7mZTiC4xXnx02GuJPYwhlR3Ua9LC/VbVxu9tlIsbvDZf0sJRLipZIv2bKWkCQ
 uYPStl74QGokg8+VAAegASAZJTyXNhDJ1q3ZNDhAO3YZvo2u0kFlUd8UzSUhMd1Ps7WL
 kp6A==
X-Gm-Message-State: AOAM531/r2BLimY/Vu661k1QCJm7jlGVYhkhrWfiXIAl5I+/hP86mBBa
 OOQowrLDPAZhQLjBVohMBJsY8cn5qQ9Tpa0Lkdo+OLuwqef3PeLkt6+24Ygi7w2nAkgyiKAYkM8
 s1lPp3VGMkrSvmg8labDeywD/
X-Received: by 2002:a7b:c209:: with SMTP id x9mr388010wmi.9.1632755038165;
 Mon, 27 Sep 2021 08:03:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEdm9plI8QQmwPL2SFhkzquOawAtG2L3LzWjsrxEcUhatBpqdEXWMPsZ+lvaoVsF5QfHy+Uw==
X-Received: by 2002:a7b:c209:: with SMTP id x9mr387973wmi.9.1632755037927;
 Mon, 27 Sep 2021 08:03:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id c9sm15544500wmb.41.2021.09.27.08.03.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 27 Sep 2021 08:03:57 -0700 (PDT)
Message-ID: <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
Date: Mon, 27 Sep 2021 17:03:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To: Sean Christopherson <seanjc@google.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YVHcY6y1GmvGJnMg@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 27/09/21 16:59, Sean Christopherson wrote:
>> commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
>> Author:     David Matlack<dmatlack@google.com>
>> AuthorDate: Fri Apr 17 15:14:46 2020 -0700
>> Commit:     Paolo Bonzini<pbonzini@redhat.com>
>> CommitDate: Fri Apr 24 12:53:17 2020 -0400
>> 
>>      kvm: add capability for halt polling
>> 
>> broke the possibility for an admin to disable halt polling for already running KVM guests.
>> In past times doing
>> echo 0 > /sys/module/kvm/parameters/halt_poll_ns
>> 
>> stopped polling system wide.
>> Now all KVM guests will use the halt_poll_ns value that was active during
>> startup - even those that do not use KVM_CAP_HALT_POLL.
>> 
>> I guess this was not intended?

No, but...

> I would go so far as to say that halt_poll_ns should be a hard limit on
> the capability

... this would not be a good idea I think.  Anything that wants to do a 
lot of polling can just do "for (;;)".

So I think there are two possibilities that makes sense:

* track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns 
follow that

* just make halt_poll_ns read-only.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
