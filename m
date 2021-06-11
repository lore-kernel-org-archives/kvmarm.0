Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E852BC48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:04:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62C70613CF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62C70613CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D044F4B0A1;
	Fri, 11 Jun 2021 08:04:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C7WJMuoMb-wr; Fri, 11 Jun 2021 08:04:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0A384B0CC;
	Fri, 11 Jun 2021 08:04:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2C974B099
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:04:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vPRaQzY7A+zf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 08:04:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 285354AC80
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:04:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623413060;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SJDmCGSzSoN+SjlCljTi/drpSsUmCLU82T+0nPdBIYI=;
 b=g5+y2B1/D2EMMpr32ip4QR2U6Pw5dLY8cK3izENNVAtvQFB7lOCjwPK+SOyqEu3TKBjT7s
 ocmqKiIORkWVbxTrtJStCIImcU9wCi5tR/5guh3/Tpgi0lV7iB/Z/0buzZ1djiuvlR3Q4O
 xWDAtlgEkML6G8tC5jbEDpmUl2CNpU8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-iMFbWMFHMFCa_J3Mt_ZcDQ-1; Fri, 11 Jun 2021 08:04:03 -0400
X-MC-Unique: iMFbWMFHMFCa_J3Mt_ZcDQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 g14-20020a5d698e0000b0290117735bd4d3so2504982wru.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 05:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=SJDmCGSzSoN+SjlCljTi/drpSsUmCLU82T+0nPdBIYI=;
 b=i6Tq9UwepIGzvJ6iTMPCUzbRA3sOMXoO21bjxbEz9KftHjBv4HDmXFFZpfyF4Z6LxZ
 bq7oRZTiGdBn9EDdpSPXyubW2bvpSkdB0+DbAW5RiFxhIqv1nCu5QYoU+f9kv5vqvRtM
 UHaBh/Ff3v5hBE5gEdnpSLrDe+29EUPby6TORFvjz3FSSlyQ6TWOVhjpWGEHE8pTWpmK
 YfZQ49Rqsqyh8ItKu5Y2apU+FIGuIK9nmiwSlxO7j0GqkpRvqLtWDFuIx8aZX6yY81Jb
 DwJ1QHnVebOuES3fc4cKyJh2UPdpljzVOBwoxbghijWcBBEYaDDU1MlWTtYLNHYklePO
 8gEQ==
X-Gm-Message-State: AOAM531QNZA8W/XnJaU7fKHtfxQBEwunkBham5vr9V8U6QMApSehRilK
 F4bpxTGTnjSjRhcobOY1O9wvA7UKOFuW45tz7Y0mIlDFU4hAuWKRjv13B7ddKz+JHNr9TvRJ0Vq
 zklP1eQom7WYqAj2Nw0RsoTRo
X-Received: by 2002:a7b:c0cb:: with SMTP id s11mr3607773wmh.21.1623413042145; 
 Fri, 11 Jun 2021 05:04:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG2XIC2YxHXVTDi+gO8yJwV9JxmgIYE7VFZU1/ddoPOqjwHeITDdMBlqBjpf4Ks7p+wpwf+g==
X-Received: by 2002:a7b:c0cb:: with SMTP id s11mr3607733wmh.21.1623413041887; 
 Fri, 11 Jun 2021 05:04:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id o20sm11859481wms.3.2021.06.11.05.04.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Jun 2021 05:04:01 -0700 (PDT)
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
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c5199e63-762d-a731-7ef2-c2af3a8cb0c3@redhat.com>
Date: Fri, 11 Jun 2021 14:03:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c0173386-0c37-73c0-736a-e904636b6c94@de.ibm.com>
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

On 11/06/21 14:00, Christian Borntraeger wrote:
> What is the semantics of remote_tlb_flush?

I always interpreted it as "number of times the KVM page table 
management code needed other CPUs to learn about new page tables". 
Whether the broadcast is done in software or hardware shouldn't matter; 
either way I suppose there is still some traffic on the bus involved.

ARM is also not updating the stat, I'll send a patch for that.

Paolo

> For the host:
> We usually do not do remote TLB flushes in the "IPI with a flush 
> executed on the remote CPU" sense.
> We do have instructions that invalidates table entries and it will take 
> care of remote TLBs as well (IPTE and IDTE and CRDTE).
> This is nice, but on the other side an operating system MUST use these 
> instruction if the page table might be in use by any CPU. If not, you 
> can get a delayed access exception machine check if the hardware detect 
> a TLB/page table incosistency.
> Only if you can guarantee that nobody has this page table attached you 
> can also use a normal store + tlb flush instruction.
> 
> For the guest (and I guess thats what we care about here?) TLB flushes 
> are almost completely handled by hardware. There is only the set prefix 
> instruction that is handled by KVM and this flushes the cpu local cache.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
