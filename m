Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982B5C49EA4
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:28:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D6326121D
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:28:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D6326121D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A9F740FC7;
	Fri, 18 Jun 2021 04:28:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pyggFv2dfZwl; Fri, 18 Jun 2021 04:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CC934A1A7;
	Fri, 18 Jun 2021 04:28:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A65DC40870
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:28:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bpmXDkdVs9ee for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 04:28:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 966EC407F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:28:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624004931;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2dX1Z1B4jDVkxeyQIb00TBL9OAqb/e0k+UeCSPEL6lM=;
 b=Vvn032ENBgFnkOuTzKqptjPXV0MdMk+v36tnx+ISPrpm5CIFL9fzaCutXDlSD9nwMy05AB
 FykGmO0YnMFulOhDJkXUVF2VxipNsObl0ZtfTFD85AjGXf9Y4YxFDv67lyVuWtgxlCLIZG
 8gxqmezP2SKX275K8LiCYgB8n3dwEdw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-K5wlZeL_NZ2osQIjIXP0jw-1; Fri, 18 Jun 2021 04:28:50 -0400
X-MC-Unique: K5wlZeL_NZ2osQIjIXP0jw-1
Received: by mail-ed1-f69.google.com with SMTP id
 x12-20020a05640226ccb0290393aaa6e811so3123774edd.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 01:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2dX1Z1B4jDVkxeyQIb00TBL9OAqb/e0k+UeCSPEL6lM=;
 b=h+YnDoA25JPSYXruif8PablnZT4Hox/lfCd6a/lnhsHExgE3rVSmbFmlYZs45U8h1c
 BMuBTkdtw7jhBe7mIfmQnnL1jQ+slBqBBrOyqQTvf8ZRCaioVM/s/ZICawHXvwsmuUeK
 IAJZs5mhOIfjx4NmIBzBkE11T/gAjPARsPl7X4/sAwcdIk5wMihXIdle/LRndyQGHIg4
 esanJip49GwUY0v9VX1xSzOO/LvsT5bs0UkDCNxSMHigblFchq7rxWoa8iisa29XmIHx
 1KvYXNvxW1nI1jkq7SbsVzTKyWkWC7EjntbBVgayp+j5lNEErDPyR9+q3ggRPd8dpkbR
 zL3A==
X-Gm-Message-State: AOAM531Hxio4aCB7bf//+CFnn6nF28yLAmmzMs56D2OloCbBQkKZOowA
 UKQ97ApFciWV3/58mxRAsZW46MdKh3BqDwujwJQwDguOda2tP76/3tw/rcoJLOyRiEGRTU9dNic
 2eFwWtMiX0Ff2FescrJ9dXndw
X-Received: by 2002:a17:907:2648:: with SMTP id
 ar8mr9824428ejc.67.1624004928740; 
 Fri, 18 Jun 2021 01:28:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxEeRkMy/icCxnO1ZwArvUqnCPkqScwHQd07KbiNxNFCpJPaEhOwv7LrjsH24qmyNHLMlMAg==
X-Received: by 2002:a17:907:2648:: with SMTP id
 ar8mr9824392ejc.67.1624004928541; 
 Fri, 18 Jun 2021 01:28:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id lu21sm730110ejb.31.2021.06.18.01.28.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 18 Jun 2021 01:28:47 -0700 (PDT)
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary stats
 data
To: Greg KH <gregkh@linuxfoundation.org>, Jing Zhang <jingzhangos@google.com>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com>
 <YMxDv5BgfdMn2Y9b@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9919638-06e2-2c4a-a6a6-f00fca6d78f8@redhat.com>
Date: Fri, 18 Jun 2021 10:28:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMxDv5BgfdMn2Y9b@kroah.com>
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

On 18/06/21 08:57, Greg KH wrote:
>> + * 2. Read descriptors from its offset and discover all the stats by parsing
>> + *    descriptors. This is a one-time work for the lifecycle of the
>> + *    corresponding vm/vcpu stats fd.
>> + * 3. Periodically read stats data from its offset.
> You forgot "2.5.  rewind fd pointer position", see below...

Or use pread (that's what the test does).  I'll do a copy-editing pass 
and be sure to mention that as well.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
