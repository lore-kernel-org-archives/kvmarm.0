Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEAEC49361
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 11:03:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC06F61459
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 11:03:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC06F61459
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EAB94B0FF;
	Tue, 15 Jun 2021 07:03:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hbpCEmwLa7FL; Tue, 15 Jun 2021 07:03:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 420E94B0AD;
	Tue, 15 Jun 2021 07:03:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B61974B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 07:03:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMwOn+VpwN-t for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 07:03:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17344B09A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 07:03:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623755021;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iEAQAQmkLLT7lE0HbV2Awm5nECfUPpZCvFSfqi2dN24=;
 b=dgU/gWK0iVVvZnA7dQMnHYQsjxQh186wjN2Y59+jDfpuXAi/C/jQh59iVs45YCtdWpeh2I
 WrIv/ZsxXitFxUTtDE/jZE4TT4Vk8D5ShGgDY8cmAfLeptx4Hgcc8dVnzpShkbedDH9GFW
 R2+QwFP8emCv4zImix8NIEAkmpUGA1g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-40f0HwfiPsOFc05WPRSgew-1; Tue, 15 Jun 2021 07:03:40 -0400
X-MC-Unique: 40f0HwfiPsOFc05WPRSgew-1
Received: by mail-ej1-f71.google.com with SMTP id
 k1-20020a17090666c1b029041c273a883dso4385533ejp.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 04:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=iEAQAQmkLLT7lE0HbV2Awm5nECfUPpZCvFSfqi2dN24=;
 b=Q3vB+TYuZLhqlKwewYNsntWx8WSeXqI7+KZv2s6ukm0zNay2dyuUP8zR+31AHDTsHc
 g4DazlHHLHVVxwztl6922ONopDqP1nqE2+p+Cqcdb3+5lL9SdlB9ZwfEeJ8GnEss9KHV
 qjmHOAPHE8LgT21cL3luHiPUROSaL/gY6WykPxhq5erA1cQfJkSADQLYPevACi57iqis
 tSHs2YYZ49LTYTpeFDdCDXhMjJNeFVld+tf4kIjXOZvwqnYQpl7cHEt46vC/oSgnvhvh
 c98xLAj1NE/Q0hSeOs2DHrtIiTnkwmBWAiJw+bIz/5YnLPYUXaNKcqDYlzRwm37xEFub
 QO1w==
X-Gm-Message-State: AOAM530W62+cxfAomUUXkZVtkO0aJ1an2igLjtcCTrrXwZPlT/0oB2SU
 U9s3m1kv1KuOPA5LLg8fda8neKHX43PAWf2/zt3tZ94+b6CpaLh9YV3vkVz47f1CCxgb1Qgn7AZ
 tY7fJE+6J7eFGj742T2hQQVmW
X-Received: by 2002:aa7:cb90:: with SMTP id r16mr22601071edt.121.1623755019251; 
 Tue, 15 Jun 2021 04:03:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyVGoTcEFV+m9u1f3g2PKtrTco2TK6Sy4Mfoi+BgNSLuNotL7Uvem+oaDEtZ7dwo5Mk49IJg==
X-Received: by 2002:aa7:cb90:: with SMTP id r16mr22601014edt.121.1623755018970; 
 Tue, 15 Jun 2021 04:03:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id h8sm10123527ejj.22.2021.06.15.04.03.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Jun 2021 04:03:38 -0700 (PDT)
To: Leon Romanovsky <leon@kernel.org>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <YMg5xPbmK3myjIX8@unreal> <15875c41-e1e7-3bf2-a85c-21384684d279@redhat.com>
 <YMhcek2cIu3Oz5Ek@unreal>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
Message-ID: <9df462c0-e0ea-8173-0705-369d6a81107c@redhat.com>
Date: Tue, 15 Jun 2021 13:03:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMhcek2cIu3Oz5Ek@unreal>
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

On 15/06/21 09:53, Leon Romanovsky wrote:
>> Sorry for my naive questions, but how does telemetry get statistics
>> for hypervisors? Why is KVM different from hypervisors or NIC's statistics
>> or any other high speed devices (RDMA) that generate tons of data?
>
> So the answer to the question "why KVM is different" is that it doesn't
> have any stable identification except file descriptor. While hypervisors
> have stable names, NICs and RDMA devices have interface indexes etc.
> Did I get it right?

Right.

> And this was second part of my question, the first part was my attempt to
> get on answer why current statistics like process info (/proc/xxx/*), NICs
> (netlink) and RDMA (sysfs) are not using binary format.

NICs are using binary format (partly in struct ethtool_stats, partly in 
an array of u64).  For KVM we decided to put the schema and the stats in 
the same file (though you can use pread to get only the stats) to have a 
single interface and avoid ioctls, unlike having both ETH_GSTRINGS and 
ETH_GSTATS.

I wouldn't say processes are using any specific format.  There's a mix 
of "one value per file" (e.g. cpuset), human-readable tabular format 
(e.g. limits, sched), human- and machine-readable tabular format (e.g. 
status), and files that are ASCII but not human-readable (e.g. stat).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
