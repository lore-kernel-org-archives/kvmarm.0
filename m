Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503C2C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 18:11:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE5AD64F45
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 18:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE5AD64F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DB2A4B3F5;
	Fri, 12 Mar 2021 13:11:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d8vPeiPVC-gJ; Fri, 12 Mar 2021 13:11:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21D564B40B;
	Fri, 12 Mar 2021 13:11:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0998E4B40B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 13:11:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id elUFyuUst20Y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 13:11:17 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F9014B3F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 13:11:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615572676;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SQXRSD89A8xhrCuxpBydg6Y3MyKh1PtNusEjHfIcj18=;
 b=KZ8yOtidfGUcx654m9Pe4lxyuho4yK6NSU0ZJbKsZ832NWmTMviBuXC7ZIXX9BDoh98D6i
 1NZIJdP7mBqHMr4r+s4HUF6jJzTXwm6UOuCSZofo0inrTUZk8UyAR2zzPgKPyfIyq44ZJv
 30HjzYMhdZbmDkjzkQaT/7RRnmXpXuM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-eDo03unRPxGV4kLVMrgSFw-1; Fri, 12 Mar 2021 13:11:15 -0500
X-MC-Unique: eDo03unRPxGV4kLVMrgSFw-1
Received: by mail-wr1-f70.google.com with SMTP id z6so11482106wrh.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:11:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=SQXRSD89A8xhrCuxpBydg6Y3MyKh1PtNusEjHfIcj18=;
 b=WfemxPx0y2mNU7UWsJ47bcg/7uerKyNwCC3UqrCu/cv90HKfh8tV2MX5/CXUhACTBA
 cDv9AaziLwH9Ov1A+Nfc3DQi9SI3mOceeT+HuF6IIqz+gFbGieKXFdNcyKQTfbCUbWhy
 fVXW4ViUZ4UlRkpcF7EG+QvVfYGBtMf48HGQeI9Z9qfX3EQ4oxYekermFOA4L1suaNka
 JJ9Q3cicR72cPj7WqQ54Qe+hpwZBx1KdO/+G4D8FGW45mnNob/qmJkbd1lUSrEaZNlv+
 fiZJ1Ls+tOYaOW3ucydoGGSIsIMinPUiMDwTbdELDRriike6KlwbQUmvGJqMRBoVfVNz
 pd9Q==
X-Gm-Message-State: AOAM53042/QSSj83ucXMMLZUEpEfzYWVaPcWo3ZYhmxkn5TvrTsGT6nC
 0ObzBBjfk18bY9MHsGaXWDv1KN+3GdZe4bNk0XUr1qnUVnXTzb/e5i4uDdm/rno5W+9BM+WgiyY
 W5M13eBudFsE1Mi2ACZsfI7be
X-Received: by 2002:a1c:498b:: with SMTP id
 w133mr14755136wma.134.1615572673376; 
 Fri, 12 Mar 2021 10:11:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2aInA1bidlltyWIjYrqBjK+SGizjJOOZcscWT2RiFNd2X/0uEYFLiJqfA7xaEL8hELymOZw==
X-Received: by 2002:a1c:498b:: with SMTP id
 w133mr14755105wma.134.1615572673180; 
 Fri, 12 Mar 2021 10:11:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id y8sm2934326wmi.46.2021.03.12.10.11.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 12 Mar 2021 10:11:12 -0800 (PST)
To: Jing Zhang <jingzhangos@google.com>
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
 <CAAdAUtjj52+cAhD4KUzAaqrMSJXHD0g=ecQNG-a92Mqn3BCxiQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
Message-ID: <ac7462de-1531-5428-5dca-4e3dfb897000@redhat.com>
Date: Fri, 12 Mar 2021 19:11:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAAdAUtjj52+cAhD4KUzAaqrMSJXHD0g=ecQNG-a92Mqn3BCxiQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 Linux S390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, Linux MIPS <linux-mips@vger.kernel.org>,
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

On 10/03/21 22:41, Jing Zhang wrote:
>> I would prefer a completely different interface, where you have a file
>> descriptor that can be created and associated to a vCPU or VM (or even
>> to /dev/kvm).  Having a file descriptor is important because the fd can
>> be passed to a less-privileged process that takes care of gathering the
>> metrics
> Separate file descriptor solution is very tempting. We are still considering it
> seriously. Our biggest concern is that the metrics gathering/handling process
> is not necessary running on the same node as the one file descriptor belongs to.
> It scales better to pass metrics data directly than to pass file descriptors.

If you want to pass metrics data directly, you can just read the file 
descriptor from your VMM, just like you're using the ioctls now. 
However the file descriptor also allows a privilege-separated same-host 
interface.

>> 4 bytes flags (always zero)
>> 4 bytes number of statistics
>> 4 bytes offset of the first stat description
>> 4 bytes offset of the first stat value
>> stat descriptions:
>>    - 4 bytes for the type (for now always zero: uint64_t)
>>    - 4 bytes for the flags (for now always zero)
>>    - length of name
>>    - name
>> statistics in 64-bit format
> 
> The binary format presented above is very flexible. I understand why it is
> organized this way.
> In our situation, the metrics data could be pulled periodically as short as
> half second. They are used by different kinds of monitors/triggers/alerts.
> To enhance efficiency and reduce traffic caused by metrics passing, we
> treat all metrics info/data as two kinds. One is immutable information,
> which doesn't change in a given system boot. The other is mutable
> data (statistics data), which is pulled/transferred periodically at a high
> frequency.

The format allows to place the values before the descriptions.  So you 
could use pread to only read the first part of the file descriptor, and 
the file_operations implementation would then skip the work of building 
the immutable data.  It doesn't have to be implemented from the
beginning like that, but the above format supports it.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
