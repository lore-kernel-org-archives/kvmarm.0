Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3021C2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:34:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81F6B61404
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81F6B61404
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2294540895;
	Thu, 17 Jun 2021 07:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZmPcPGi3TveG; Thu, 17 Jun 2021 07:34:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7244A3B4;
	Thu, 17 Jun 2021 07:34:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E63049F8F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:34:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AXJueMQ83tHg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 07:34:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46CB04086A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:34:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623929671;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KwQqoYgcuee30cxqMSNTKwW1ocgA4MOYfQQA575EikA=;
 b=SgQKEp8Jlm1Fn+MQUZ2JLx65lggZEcZwIG4DnQOBAeKG7GGv8ZuncdTK6BbivVI0BX1he9
 j1HDo6EyS78pHfY8UkyFpDuReTcCiu5tDxM5BuErpS0Moa222D9XsvpQTGHlMDj2Zu+P6N
 N8foIUATGV6I4EZboS4smPrMSKa6BaU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-MoEWGWwPPg-jVqitUb7zsQ-1; Thu, 17 Jun 2021 07:34:30 -0400
X-MC-Unique: MoEWGWwPPg-jVqitUb7zsQ-1
Received: by mail-ej1-f70.google.com with SMTP id
 hz18-20020a1709072cf2b02903fbaae9f4faso2051284ejc.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 04:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=KwQqoYgcuee30cxqMSNTKwW1ocgA4MOYfQQA575EikA=;
 b=f4Cx+f7EjA5MaWadWu4bst1+g5h8SmrFPrbxJzObLADB+CBM2ouO6japTlk9lgtc9e
 cVg/dB4VblNcgcifw8oiwKmFKnznti5UlBsZG3ttiNvD20oM/YH2xDeNckBUBGmORL78
 gCCddSwtgI2upoN5uTB/+L2unsQJqH9XpcwU5WYPIX1PhPQW3X2JRWpt3kGFtwJyWSGP
 l5hTXTEWOGubrqG0nVKf+T0q4EDi/mQGZbWluuIOkSHfY9q/nFQ/J8qdKN1ncqtVjc2b
 tqY/0y24/TKNMaBQ91inoaJC+HbEl6bkJ9JI1FyQLsxAMRqmmFF2W80VL9ZCQ3xo9JM1
 QCzw==
X-Gm-Message-State: AOAM532Fj7B0MJ+2EAAPkJbfgdLmIdXMI6zqlOII4xbapzV7FUaxiqjz
 dofDx0mPoitBZ5C3LC7aOe9yIHrIAGNIve2/4TUnEj4ScJLjN50flJwTufXhapgHSZtc1GeJGkK
 ZRd85hIBWgMlnz1Cpr15H9N/7
X-Received: by 2002:a17:906:b24a:: with SMTP id
 ce10mr4692520ejb.83.1623929364992; 
 Thu, 17 Jun 2021 04:29:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQxoLzPkjG7qTF6pnm47FJcTyBPVefQu9Gb2o8Ewl83hG/K5uvahTR/5zWHNZRrxu3APLVbA==
X-Received: by 2002:a17:906:b24a:: with SMTP id
 ce10mr4692477ejb.83.1623929364822; 
 Thu, 17 Jun 2021 04:29:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id du16sm3512028ejc.42.2021.06.17.04.29.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 17 Jun 2021 04:29:24 -0700 (PDT)
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
To: Greg KH <gregkh@linuxfoundation.org>, Jing Zhang <jingzhangos@google.com>
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com>
 <YMrkGZzPrt0jA1iP@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d959828-da89-bceb-f7cc-35622a60c431@redhat.com>
Date: Thu, 17 Jun 2021 13:29:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMrkGZzPrt0jA1iP@kroah.com>
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

On 17/06/21 07:56, Greg KH wrote:
> On Thu, Jun 17, 2021 at 04:41:44AM +0000, Jing Zhang wrote:
>> +	struct kvm_stats_desc {
>> +		__u32 flags;
>> +		__s16 exponent;
>> +		__u16 size;
>> +		__u32 offset;
>> +		__u32 unused;
>> +		char name[0];
>> +	};
> 
> <snip>
> 
>> +The ``unused`` fields are reserved for future support for other types of
>> +statistics data, like log/linear histogram.
> 
> you HAVE to set unused to 0 for now, otherwise userspace does not know
> it is unused, right?

Jing, I think you planned to use it with other flags that are unused for 
now?  But please do check that it's zero in the testcase.

> It is not a pointer, it is the data itself.
> 
>> +string starts at the end of ``struct kvm_stats_desc``.
>> +The maximum length (including trailing '\0') is indicated by ``name_size``
>> +in ``struct kvm_stats_header``.
> 
> I thought we were replacing [0] arrays with [], are you sure you should
> be declaring this as [0]?  Same for all structures in this document (and
> code).

In C code [0] is a bit more flexible than [].  I think in this 
particular case [] won't work due to how the structures are declared. 
In the documentation [] is certainly clearer.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
