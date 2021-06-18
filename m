Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2504C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:37:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D1C56121D
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:37:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D1C56121D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1DC4A98B;
	Fri, 18 Jun 2021 04:37:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S4jwfrN9fEfH; Fri, 18 Jun 2021 04:37:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7A74A1A7;
	Fri, 18 Jun 2021 04:37:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4274A40FC7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:37:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zEZqkbX-RsD7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 04:37:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86DB040870
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:37:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624005453;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wzqa8rS1pmB4o6NDr4muJNg1165tCr6NUIhZ4XLKVno=;
 b=DmUkyx/3SwWQMaCfpCXL9x0hAwNZMEpWlMsp/wOFG15jYa1UAYr/Uq6Q4DlHqWS5ekhhld
 l1yAZkMEMFzEW3fbgOdF1F5EFn0nFychof812WcleUoHLcMzZ4ifphYUXoNzt2sJUxL1BB
 8jhpD7PkzM2xyYvqqxpQ+AiZaE9Whzk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-bK_4js4eNh-yZJM8CWDkTQ-1; Fri, 18 Jun 2021 04:37:32 -0400
X-MC-Unique: bK_4js4eNh-yZJM8CWDkTQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 ch5-20020a0564021bc5b029039389929f28so3126194edb.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 01:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wzqa8rS1pmB4o6NDr4muJNg1165tCr6NUIhZ4XLKVno=;
 b=eZmJfeeyy1HcvIHBbrQ3lN09ywzivCCKxpbMSCOl30kbWOJBlI7Vkbp/R3qkhq4qxC
 Zm5v7qHHnlfW2S25kDyMMsGgZZ+SNBHSNpDmPmMyxlFwesMFy+auTwcwV3tUQyS/NaNV
 ZemgJj+ApI+pDZNm2Iu9EQkt5gERwkeJNBaR0g7eiRVjm6FXcMYng6+aqtchHi3LFSPh
 IPb1rvW/GwFnSPvRw9bqOctzKilVT/xh+HG49yecAQdT8c9yqPZJolQb8QmrUa+y9sKo
 wnZxe7BeyxNzKbgoKtY31B3SqkYnqpFM/O3fGFElIh5DNaCRTtPXX8BQJSLunHXH+ynM
 JS7w==
X-Gm-Message-State: AOAM5325IUGrYtbY3fTqMKv5SEW29nSrtBNusDlDBBAU7hhRUavCkH5x
 fQzf9a+HvNU/tMIEk1TmueORfqwwuXd0tKq5Y740jAVT4LVpxzumCTCk46FK3tDgy1F6aNaGtmB
 cZJ9cWbRd35DN00ZsGr1aAHQt
X-Received: by 2002:a17:907:2135:: with SMTP id
 qo21mr10007179ejb.385.1624005451041; 
 Fri, 18 Jun 2021 01:37:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGqTUCCnmlm2i4BwK6ow8EEW5K1lZq6PRO7ZAfVpPo/7FV7YEyqCjtEH5lpza698HypRTM1w==
X-Received: by 2002:a17:907:2135:: with SMTP id
 qo21mr10007135ejb.385.1624005450841; 
 Fri, 18 Jun 2021 01:37:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id df20sm5460460edb.76.2021.06.18.01.37.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 18 Jun 2021 01:37:30 -0700 (PDT)
Subject: Re: [PATCH v11 5/7] KVM: stats: Add documentation for binary
 statistics interface
To: Greg KH <gregkh@linuxfoundation.org>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-6-jingzhangos@google.com>
 <YMxE8pUrbQkwlpbD@kroah.com>
 <0036c55a-72d6-7b5c-a6fd-3a285476e522@redhat.com>
 <YMxZ2Z9s5YRvhetZ@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c8f1fada-a7b7-0f41-c57f-7164a8211d68@redhat.com>
Date: Fri, 18 Jun 2021 10:37:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMxZ2Z9s5YRvhetZ@kroah.com>
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

On 18/06/21 10:31, Greg KH wrote:
> Ok, it's your maintenance burden, not mine, I was just suggesting a way
> to make it easier :)
> 
> I'll not complain about this anymore...

I wish there was a way to keep them in sync without either sacrificing 
the quality of the documentation or reading kvm.h 100 times, I would 
jump on it!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
