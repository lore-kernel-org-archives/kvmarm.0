Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A9EC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:11:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6299564FC8
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:11:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6299564FC8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4EC4B616;
	Wed, 10 Mar 2021 12:11:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y07XnyJfNsa2; Wed, 10 Mar 2021 12:11:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADA9B4B615;
	Wed, 10 Mar 2021 12:11:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 619DE4B615
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:11:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X5XMuDZ1STcJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:11:55 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A0154B5FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:11:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615396315;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=npEmB1G2ved3m8cb8eHAFpucuy0wI7cKFS8zXAK0eEM=;
 b=fZguM4zlbiE12hiujL7b/K/5x3buo4dshiDIUoIK3kTC5i8eMnf2sCMaaBjjRhG4G2DVUe
 0xy3Nt+7W9EvSTDCs+MABMPGMFeaZQCszBgwvbc+pYbmkC7kEfuUNIYJBxukgTYlODk1qD
 oz9vlOyDKM7o4yzlxk448gvLB+fF77s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-Ym8cDOZxNX6zgMsrWytCSQ-1; Wed, 10 Mar 2021 12:11:51 -0500
X-MC-Unique: Ym8cDOZxNX6zgMsrWytCSQ-1
Received: by mail-ej1-f70.google.com with SMTP id bg7so1473152ejb.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:11:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=npEmB1G2ved3m8cb8eHAFpucuy0wI7cKFS8zXAK0eEM=;
 b=tExGl243tqkMIfQmG4SMWo6PKLaZiQSGvyHc4Ms6idEZZQ6PYRSjkwzFfuf29hHps8
 kg2ZgFfT4GBBrJC8uPPF1ojbI4fM+YQeRO4lymW27KG5AiUrBU4qtY6nZqnWKFCLx0rH
 OWhVsLzcQdRgxE7HYI9mcQXiWLRcrWokIFBQ0fXnQ5wb5p2fpnLUnC1e/MpiqKu9TYK1
 5l+SpoZdg3rfaPPpc3wKTRfn4/YQOtFm8nTKJDgpnAp7XhI0+hGl5FJ3GYlgBjBklK/P
 i9DGk6ib1nPwHYErA1pBeiDiyXL7CIqU81hKzCUlZEGnilt9+cM1yofRFVwqNVZtE4Ty
 eZmw==
X-Gm-Message-State: AOAM533Yxp/gYpdaX+mGJcmvSuQGYyiRJJDTeSNBA96Znreo8UZzMAua
 MgfVLmKoyBm8B/6CvMrcHQ+Cergerae4bKi6Z1kwpk135JN4wJx82mJHFwtRDlqhL7qSA9L6shg
 HJJPn/hcDquX1bZcGTTLvgCOh
X-Received: by 2002:a17:906:29c3:: with SMTP id
 y3mr4574760eje.430.1615396310181; 
 Wed, 10 Mar 2021 09:11:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPss/0WtwYTPFF2AWpi4QdCF2rQJI8+OlQAs4Ax1N/oVR6iCHbCOYshTcU9dU+pTRgby2Rsw==
X-Received: by 2002:a17:906:29c3:: with SMTP id
 y3mr4574734eje.430.1615396309942; 
 Wed, 10 Mar 2021 09:11:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id n25sm11384840edq.55.2021.03.10.09.11.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Mar 2021 09:11:49 -0800 (PST)
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
To: Marc Zyngier <maz@kernel.org>
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <875z1zxb11.wl-maz@kernel.org>
 <a475d935-e404-93dd-4c6d-a5f8038d8f4d@redhat.com>
 <8735x3x7lu.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2749fe68-acbb-8f4d-dc76-4cb23edb9b35@redhat.com>
Date: Wed, 10 Mar 2021 18:11:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8735x3x7lu.wl-maz@kernel.org>
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
 Oliver Upton <oupton@google.com>, Huacai Chen <chenhuacai@kernel.org>,
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

On 10/03/21 18:05, Marc Zyngier wrote:
> On Wed, 10 Mar 2021 16:03:42 +0000,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 10/03/21 16:51, Marc Zyngier wrote:
>>>> +	kvm_for_each_vcpu(j, vcpu, kvm) {
>>>> +		pdata = data + VM_STAT_COUNT;
>>>> +		for (i = 0; i < VCPU_STAT_COUNT; i++, pdata++)
>>>> +			*pdata += *((u64 *)&vcpu->stat + i);
>>> Do you really need the in-kernel copy? Why not directly organise the
>>> data structures in a way that would allow a bulk copy using
>>> copy_to_user()?
>>
>> The result is built by summing per-vCPU counters, so that the counter
>> updates are fast and do not require a lock.  So consistency basically
>> cannot be guaranteed.
> 
> Sure, but I wonder whether there is scope for VM-global counters to be
> maintained in parallel with per-vCPU counters if speed/efficiency is
> of the essence (and this seems to be how it is sold in the cover
> letter).

Maintaining VM-global counters would require an atomic instruction and 
would suffer lots of cacheline bouncing even on architectures that have 
relaxed atomic memory operations.

Speed/efficiency of retrieving statistics is important, but let's keep 
in mind that the baseline for comparison is hundreds of syscalls and 
filesystem lookups.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
