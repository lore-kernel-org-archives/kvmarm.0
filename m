Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84FBC49361
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:46:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4744461412
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4744461412
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1564A524;
	Thu, 17 Jun 2021 07:46:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CyUTkF9FbSYy; Thu, 17 Jun 2021 07:46:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20E749FB7;
	Thu, 17 Jun 2021 07:46:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20A5140874
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:46:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xHYdRBopcVZc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 07:46:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B73840642
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:46:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623930373;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ujv31ni+pedAzRqkqN94IhUeHH6igQoDkhQGmN9rbYg=;
 b=M6L1mTafPswJKarRnC+9Rg9l27Jrnsm2dzFzftOWOU3J6x3FYItDzIioiE1I95G+3C9zZ5
 QgGhMN/D5n7yalKArgMLAYiO3P2lac2c9pHsKyRJ9QV4Gu1fhEtLMibrOY4GjKDdKL8JeV
 GuJyY2yx5BcwDSFHUYo6BGu/vLEkr6M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-0lid0L_CP8WE3pMpXu4f7A-1; Thu, 17 Jun 2021 07:46:11 -0400
X-MC-Unique: 0lid0L_CP8WE3pMpXu4f7A-1
Received: by mail-ed1-f69.google.com with SMTP id
 y18-20020a0564022712b029038ffac1995eso1351960edd.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 04:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Ujv31ni+pedAzRqkqN94IhUeHH6igQoDkhQGmN9rbYg=;
 b=FRlEJtAgXwWNt5f6ZepfgbXPzVFgeSYTYomqMDqEKVQzhiaQAkxdMTCqZUljrmWb/6
 AbNwD6DPL5ych2cOb3SOShqmkVlRTTYmYymkfow+teQW5OwfcatlWBYUFPxA1qBXyAOj
 IQ0MX1wz6b8dsXEZJTKpBFH/A2Z5tZ3V//L7g3aSNpjizXZTLO72+Hd9o7SE8VTfvXOQ
 e719cPMas2mSKxbxz9epgXbZmy3BxRwqTzKH+Bl2SOtpS5SSohiYH/2ODwVbVKLCs00T
 w2f1JfY857C6Hb4M8Zl+75iE4PvL9/HSUGOuSpHqzI0drJLgMoF8ilJpTIOnFDp89tHW
 J6mA==
X-Gm-Message-State: AOAM530Ox0pA8vDbUzhLmmoONNpYfPh/a/3KWPp3k9+v+O6qQAxqVope
 ueIfB27+Rqe98n9o7zeQPaSg+9fQFribLCJoieWETdfrInUKZbR2i8Pmz+mmFxQS04dT5mJbF7g
 v8w/6vDOpPQADLdOPRmHLgLqG
X-Received: by 2002:aa7:cf0d:: with SMTP id a13mr5826496edy.384.1623930370812; 
 Thu, 17 Jun 2021 04:46:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGp0u6bbKTpBWAweRlzIakuy+NTS2L7DG9uaEaAYNed1OyNxc+QE79jbRlb3hr0uHlxKTUpw==
X-Received: by 2002:aa7:cf0d:: with SMTP id a13mr5826434edy.384.1623930370434; 
 Thu, 17 Jun 2021 04:46:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id t14sm1472804edr.36.2021.06.17.04.46.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 17 Jun 2021 04:46:09 -0700 (PDT)
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
To: Greg KH <gregkh@linuxfoundation.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com>
 <YMrkGZzPrt0jA1iP@kroah.com>
 <0d959828-da89-bceb-f7cc-35622a60c431@redhat.com>
 <YMs1Pwf+nSQsfVUW@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <348aa108-076b-04dd-9fd2-e840a7a85f5d@redhat.com>
Date: Thu, 17 Jun 2021 13:46:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMs1Pwf+nSQsfVUW@kroah.com>
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

On 17/06/21 13:42, Greg KH wrote:
> On Thu, Jun 17, 2021 at 01:29:22PM +0200, Paolo Bonzini wrote:
>> On 17/06/21 07:56, Greg KH wrote:
>>> On Thu, Jun 17, 2021 at 04:41:44AM +0000, Jing Zhang wrote:
>>>> +string starts at the end of ``struct kvm_stats_desc``.
>>>> +The maximum length (including trailing '\0') is indicated by ``name_size``
>>>> +in ``struct kvm_stats_header``.
>>>
>>> I thought we were replacing [0] arrays with [], are you sure you should
>>> be declaring this as [0]?  Same for all structures in this document (and
>>> code).
>>
>> In C code [0] is a bit more flexible than [].  I think in this particular
>> case [] won't work due to how the structures are declared. In the
>> documentation [] is certainly clearer.
> 
> Look at all of the patches that Gustavo has been doing all over the tree
> for this work, you do not want to make him do this again here.
> 
> Gustavo, is [0] ok for fields like these?

I should be able to get back to KVM stuff later today, I'll check myself 
if [] can be applied and reply.  I had queued an early version of these 
for my local build to play with them but I haven't been able to do a 
complete review.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
