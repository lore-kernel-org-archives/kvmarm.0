Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61714C2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:34:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9A74613F1
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 11:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9A74613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4933A49F82;
	Thu, 17 Jun 2021 07:34:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UCM6q-Z8Msln; Thu, 17 Jun 2021 07:34:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B11BC4A3A3;
	Thu, 17 Jun 2021 07:34:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4341149F82
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:34:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LPhQ4I8nz1lL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 07:34:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5396040821
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:34:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623929646;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=eFNQaz+UBr3+VeZ6q7OSgOqHodPl71Dh+9dEuoGcM+Q=;
 b=X5h/oeCAI8KRRy4Ex5oWRMnZDuesw1Sm6Gy2/17xW5kGa2gfOFGLqhpOIl2daBPrN8MQSM
 SipPCYm0e0KmuciNbz36CZSZvD5gPbRvgcbWWh6T3kxwfCKHNApXWmMPz8D2369MV2LP1j
 TRM8qsXIxBThVUH220dTPLxM7gA4IvM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-ruzrMOJPP4uCUmsj7Ozfzw-1; Thu, 17 Jun 2021 07:34:05 -0400
X-MC-Unique: ruzrMOJPP4uCUmsj7Ozfzw-1
Received: by mail-ed1-f71.google.com with SMTP id
 h11-20020a50ed8b0000b02903947b9ca1f3so1044111edr.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 04:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=eFNQaz+UBr3+VeZ6q7OSgOqHodPl71Dh+9dEuoGcM+Q=;
 b=TGr5rQV9Dkuvx2kywj3AORfRputxcqp/XhXoEHLAnCDS1Hu+5BmJ2uAK0Vew4y1/f0
 QjsSzcaWi2yfNUUqG+6nkfeWuM3e/3Q1IKYV9M/dcyeG/0ovmCSa9NZb1sGsnD5i64nE
 mDOb3AEryFzPg81qB2wADN5SAi3EuNHtmGprDYiwdRgdhU3jbNX3PlmmGgCMTLhFKvOT
 NItDqB7K1aiKBSmh6dE/QtQh7yekap8JjVcwOYtMWK7txG7u5Hk5shjnh6HsqAVcQdIy
 s10jIrRpNxjtOwCjPhHTRWVs5IDoa9Dr4HBoi3Y5z/N8gE/w4IMC8hkT9wVdW/Zyg3IU
 YdcA==
X-Gm-Message-State: AOAM531Zu3Ii8YS2NcWiAVqvzfQDGkybFw8a1gCpLS9SDQra6+pVdNun
 r3dcm4VBjq+V4sfvfY0s8mC8wVW864ELACjWqZBRXAqo4SZ7qhqfiww2qMCRnULfSYye4AMaF7D
 eWaOih93slB9ELMOQ44xIUAci
X-Received: by 2002:a17:906:ca4a:: with SMTP id
 jx10mr4731044ejb.200.1623929246066; 
 Thu, 17 Jun 2021 04:27:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw32CbI/7oXViDiR3/KwQ1e7FS2cEfJU4e5y3PkNkTiAFxV1nv9UNltBlc/li58ogeNN1nAkA==
X-Received: by 2002:a17:906:ca4a:: with SMTP id
 jx10mr4730994ejb.200.1623929245836; 
 Thu, 17 Jun 2021 04:27:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id s5sm4131010edi.93.2021.06.17.04.27.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 17 Jun 2021 04:27:25 -0700 (PDT)
Subject: Re: [PATCH v10 2/5] KVM: stats: Add fd-based API to read binary stats
 data
To: Greg KH <gregkh@linuxfoundation.org>, Jing Zhang <jingzhangos@google.com>
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-3-jingzhangos@google.com>
 <YMr4rArKvj3obDEM@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b9cc4df4-a502-31ec-0f5d-32a53c372f06@redhat.com>
Date: Thu, 17 Jun 2021 13:27:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMr4rArKvj3obDEM@kroah.com>
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

On 17/06/21 09:24, Greg KH wrote:
>> Provides a file descriptor per VM to read VM stats info/data.
>> Provides a file descriptor per vCPU to read vCPU stats info/data.
> Shouldn't this be two separate patches, one for each thing as these are
> two different features being added?

They share a lot of code.  We could have three patches though:

- add common code for binary statistics file descriptor

- add VM ioctl to retrieve a statistics file descriptor [including the 
definition of VM stats descriptors]

- add VCPU ioctl to retrieve a statistics file descriptor [again 
including the definitions of VCPU stats].

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
