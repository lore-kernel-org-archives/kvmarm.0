Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE8CC48BD1
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 10:33:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C28E5613E9
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 10:33:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C28E5613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C5D74B0DA;
	Fri, 11 Jun 2021 06:33:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id edswvvAmyhzq; Fri, 11 Jun 2021 06:33:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 133B84B0B4;
	Fri, 11 Jun 2021 06:33:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DEC74A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 06:33:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V9zQWkEKRCRW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 06:33:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5220740291
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 06:33:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623407584;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WBC8jsi6sMgVpUZekFliEqdwU62og4a57VgKDjRa+Sc=;
 b=JdoarL0oYacmDFvO6soFuu8iGOkbp2NNQaRiSau5t9FgWt8Kv8K6h8yAS83fEywrrf3473
 SVLdTMxLXbHKSWfYcWAmuI2UCuNmVm1w0GUDH/xjerDN7hak7tHSe4XjCWJ0oKrRhcrAP+
 TIcfF6jd/fYfdf17k3/wigrwDZZ4wXQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-jEJZbmaYORiFJJfSzFMVbw-1; Fri, 11 Jun 2021 06:33:00 -0400
X-MC-Unique: jEJZbmaYORiFJJfSzFMVbw-1
Received: by mail-wr1-f72.google.com with SMTP id
 m27-20020a056000025bb0290114d19822edso2413388wrz.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 03:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=WBC8jsi6sMgVpUZekFliEqdwU62og4a57VgKDjRa+Sc=;
 b=EZH1oaMCD5hmmCMHsUWQ9KtcC44Txx6s2dMTCNQIg3TcedQyx23WC7mnFOCzjWbr/q
 VKj2Ns8vHzJkMK752qIVDZ//TCzDtBE1V8qiRmahrxgVyh+n9MN5BLRa8SbBnQbrBRfc
 YEJQ8xzWL28OoW1yHU0fwrcfCbvzf+HXl2J01A19cwwWjulC/bvPD/kgdEGYUcInvC6/
 VncNBJCcRxlr2aDccLrOfcdkAyQkRh3/dKG0QQlzufJAR7fuc6Z6VGXBus9oSaaoaLPw
 itWOT6ScNf7kFGwvqyo6Bcjz7UM0HVH21NAy0OT9YVzAMjYJ513Tmlju6Y38pA+1UgH9
 IoSg==
X-Gm-Message-State: AOAM531g8ojIbsR4+Mc0HXseJ3sy4SUInPTNIdnatS9T2hYxd+0CYDk7
 2z55dPoUFVG0BwXtXQWPLg5xFysy817aLkPHvzVGTeg82WUlxvlPTHkpOFdcD/LF8b7Q9yZNW5+
 loBaHKz41UXRF+eturkojKJrq
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr2224951wrb.255.1623407579425;
 Fri, 11 Jun 2021 03:32:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf8tRH1WD2BkDk0nh3u9+JxAlR1FoBopNGcMDh/7aHVklUCngEpCzpbjrac9bNu9rkTLOqQw==
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr2224904wrb.255.1623407579190;
 Fri, 11 Jun 2021 03:32:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id s62sm12741514wms.13.2021.06.11.03.32.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Jun 2021 03:32:58 -0700 (PDT)
Subject: Re: [PATCH v7 2/4] KVM: stats: Add fd-based API to read binary stats
 data
To: Jing Zhang <jingzhangos@google.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com>
 <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
 <CAAdAUtjAuDdyBz7qd7UE0WuY77US-bhY1-jA9E11ddhZ0=gw6g@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2ed4afbf-c5b8-82a5-5fc6-04f00f933761@redhat.com>
Date: Fri, 11 Jun 2021 12:32:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAdAUtjAuDdyBz7qd7UE0WuY77US-bhY1-jA9E11ddhZ0=gw6g@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 11/06/21 00:47, Jing Zhang wrote:
> Hi Paolo,
> 
> On Thu, Jun 10, 2021 at 11:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 03/06/21 23:14, Jing Zhang wrote:
>>> +#define DEFINE_VM_STATS_DESC(...) {                                         \
>>> +     STATS_DESC_COUNTER("remote_tlb_flush"),                                \
>>> +     ## __VA_ARGS__                                                         \
>>> +}
>>> +
>>> +#define DEFINE_VCPU_STATS_DESC(...) {                                               \
>>> +     STATS_DESC_COUNTER("halt_successful_poll"),                            \
>>> +     STATS_DESC_COUNTER("halt_attempted_poll"),                             \
>>> +     STATS_DESC_COUNTER("halt_poll_invalid"),                               \
>>> +     STATS_DESC_COUNTER("halt_wakeup"),                                     \
>>> +     STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                          \
>>> +     STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),                             \
>>> +     ## __VA_ARGS__                                                         \
>>
>> Let's instead put this (note it's without braces) in macros like these
>>
>> #define KVM_GENERIC_VM_STATS()                                                  \
>>          STATS_DESC_COUNTER("remote_tlb_flush"),
>>
>> #define KVM_GENERIC_VCPU_STATS(...)                                             \
>>          STATS_DESC_COUNTER("halt_successful_poll"),                             \
>>          STATS_DESC_COUNTER("halt_attempted_poll"),                              \
>>          STATS_DESC_COUNTER("halt_poll_invalid"),                                \
>>          STATS_DESC_COUNTER("halt_wakeup"),                                      \
>>          STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                           \
>>          STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),
>>
>> and it can be used in the arch files.  In fact it can even be added in patch 1 and
>> switched to STATS_DESC_* here.
>>
>> Paolo
>>
> I just remember that the reason I used braces is due to following
> error from checkpatch.pl:
> ERROR: Macros with complex values should be enclosed in parentheses

No, just ignore the bogus error from checkpatch.pl.  But, thanks for 
checking!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
