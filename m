Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F41C48BE5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:14:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7A67613DD
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A67613DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D7914B0D5;
	Fri, 11 Jun 2021 08:14:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yzZQ2INrwA6n; Fri, 11 Jun 2021 08:14:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 263514B0A0;
	Fri, 11 Jun 2021 08:14:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 789AF4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GDikc2tVmwYA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 08:14:15 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5194E4B092
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:14:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623413655;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tshLc4zdYGgPabfNvrWwtgUPpGh1iSBRoaKHJCb/8hw=;
 b=PMI2b6zBnWHuxdj543hlg7h0EXf0fTk0tnlT6pTbIzGd0QQG09ZoMII4o0VpoVLgUFTViD
 3MojeNqYmPqNFj8TGJvxxazwWXBzZ86l5Cwf2Q7x/2SB39QRhjJm/FleCl2NuEixi9+3NK
 sBFcpACCHILfCb2QetHonb5Dg5bJjAg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-I3UP2d5IMj6ZZVR05y07Pw-1; Fri, 11 Jun 2021 08:14:13 -0400
X-MC-Unique: I3UP2d5IMj6ZZVR05y07Pw-1
Received: by mail-wr1-f71.google.com with SMTP id
 e11-20020a056000178bb0290119c11bd29eso2550274wrg.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 05:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=tshLc4zdYGgPabfNvrWwtgUPpGh1iSBRoaKHJCb/8hw=;
 b=aqrZEh4zKnCJzEEh3b0TOtTy7mRlXVnFj3TUEU9tC17H6Nzx3/ttkPmtD7bihGa2hW
 Scpmcp/Bx8c9+2gYuIKcl3P2hKf0S8ymU/7PdmLQjz2o4HhlgbTbaA+iJv1vA+yozcZ3
 myVWo/bUPET5Wx1KxNYzlRD54ppR+KoLfiIdF53yESRFWJKp3MBYkz2b2gvIh/4PHVNw
 LXkXo7LLyBdksx2pa+HSxwmG+4bBFnMWWP7eWghoqJ6H4cxequP0JSITeD3moZt6CJPE
 fshmFzKlAnwNFU9blJffYzUJtbxLOq0/sUjejnlr8xVUh/Kgr+L1yFaABFvP/EdbA4T0
 x9ng==
X-Gm-Message-State: AOAM531fW48rfbSkJHDzXHTuS9nFHszw7Q+G1QyqJ9Lz1uuS+AsBwr4O
 4vVOqmPj1z402POyiJ1lL44HJhb3HZtcYTuRITNDUj9W/aF9aCzSZHFD+WrOqMK4OCD+rlqWjqo
 LwfSDtdEv7hyZ6ysYohfCe69n
X-Received: by 2002:a05:600c:3650:: with SMTP id
 y16mr3677449wmq.92.1623413652697; 
 Fri, 11 Jun 2021 05:14:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzekCA0/z805DZlMHydl4+u+pU/IhlWHIqCvhI6IwFtHm385E+SV0tWtc3pGZK67eFkb8/Udw==
X-Received: by 2002:a05:600c:3650:: with SMTP id
 y16mr3677424wmq.92.1623413652485; 
 Fri, 11 Jun 2021 05:14:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id r18sm6837910wro.62.2021.06.11.05.14.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Jun 2021 05:14:11 -0700 (PDT)
Subject: Re: [PATCH v7 1/4] KVM: stats: Separate generic stats from
 architecture specific ones
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-2-jingzhangos@google.com>
 <03f3fa03-6f61-7864-4867-3dc332a9d6f3@de.ibm.com>
 <bdd315f7-0615-af69-90c3-1e5646f3e259@redhat.com>
 <c0173386-0c37-73c0-736a-e904636b6c94@de.ibm.com>
 <c5199e63-762d-a731-7ef2-c2af3a8cb0c3@redhat.com>
 <050e9d8e-278d-278c-13f7-ea0b39d13fbe@de.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8dd7259c-d0f6-6816-178f-ab0f0b486955@redhat.com>
Date: Fri, 11 Jun 2021 14:14:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <050e9d8e-278d-278c-13f7-ea0b39d13fbe@de.ibm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 11/06/21 14:08, Christian Borntraeger wrote:
>>
>> I always interpreted it as "number of times the KVM page table 
>> management code needed other CPUs to learn about new page tables". 
>> Whether the broadcast is done in software or hardware shouldn't 
>> matter; either way I suppose there is still some traffic on the bus 
>> involved.
> 
> 
> My point is that KVM page table management on s390x completely 
> piggy-backs on the qemu address space page table management from common 
> code for the last level.
> And due to the way we handle page tables we also do not teach "other 
> CPUs". We always teach the whole system with things like IPTE.

But that just means that you'll have fewer KVM-exclusive and thus nicer 
numbers than x86 or ARM. :)  It still makes sense to count 
gmap_flush_tlb calls.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
