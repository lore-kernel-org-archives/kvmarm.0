Return-Path: <SRS0=G0pq=PO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D734BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Oct 2021 16:12:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5813660527
	for <kvmarm@archiver.kernel.org>; Tue, 26 Oct 2021 16:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5813660527
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8A144B0D0;
	Tue, 26 Oct 2021 12:12:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bVNo8tCuK3vJ; Tue, 26 Oct 2021 12:12:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5AD4A534;
	Tue, 26 Oct 2021 12:12:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 256DE4A49C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 12:12:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 35WlOvfB+fyL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Oct 2021 12:12:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC67A4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 12:12:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635264741;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=y/8qPSuga2nSdD4ObnPRjMzoPwBrPBTCysCx0s1aic4=;
 b=HXeh27CV8hJRaETDK6hQOpnP45k3CVN3SmEZGClNq7UYeHDti1sMQE40Q9KP2PP6tyaQ2I
 orJVQXxUk8U1XN2n6u+a3epp9C/dCkhT5MuzOp8x/Js6W5Za41+LrdIs+yGwZJjYq0362v
 79f1/BmEa6EFyJMmnSf2RTCKnOJQnls=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-w5TawSx-MziT0siX2VBZhw-1; Tue, 26 Oct 2021 12:12:20 -0400
X-MC-Unique: w5TawSx-MziT0siX2VBZhw-1
Received: by mail-ed1-f70.google.com with SMTP id
 k28-20020a508adc000000b003dd5e21da4bso5905230edk.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 09:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=y/8qPSuga2nSdD4ObnPRjMzoPwBrPBTCysCx0s1aic4=;
 b=AJgmPsb8TE/jM+1mZDJ1npUXKx98uek3dApKGd2/QwbLDNrRZLmfR/hvtimiQqYVt7
 gWKDdIVTyJOhCom7bRTWpsMAPZ4QizouXQfDBjSRQFKHQ70DtVFUXTdoCMbFnZxSNz6k
 kXS5T5gbVaqzrkvbRZ/01FRCQHkjC5n/zpXvWFr976u5ZP7HbsAIiuPOg6LhYd9LiYG+
 pRY++JqJW+/1ozt5NTPZESPHTn2y8NZTAsYpkcJ+pbV3EaZUPPZE2ntrpVO5a1SGGD6e
 EcTiPyrz1t+hxL7hLCIxnH17LGIDtJVHr2j1/30XswqxV5yxspN0Xc9v7GqTaAxbWRFX
 JsOg==
X-Gm-Message-State: AOAM533Mu8w8fRdhaq5Tm4jmicp8U1sWDIF0nsbV2RUJByjmA30uFSMD
 dxFUyh8bhiq5oSdNiNaXfpeHPbWDNUU8VyQS1aoIC0kenkuxFcrlHatc4em4YRUMLGj4y2VnajS
 MyCFJ0PJDoTY+jUvBcul1b5bG
X-Received: by 2002:aa7:da84:: with SMTP id q4mr36991777eds.371.1635264738790; 
 Tue, 26 Oct 2021 09:12:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwASeQAxYa4SVxx7fzZJcK2OTnFNOTNNHLf+PErJyPRemx/Rf7LwxYWqAfn33dB1Qf24eGGDw==
X-Received: by 2002:aa7:da84:: with SMTP id q4mr36991714eds.371.1635264738510; 
 Tue, 26 Oct 2021 09:12:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id n1sm4753815edf.45.2021.10.26.09.12.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 26 Oct 2021 09:12:17 -0700 (PDT)
Message-ID: <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
Date: Tue, 26 Oct 2021 18:12:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out
 arch callback hook
To: Marc Zyngier <maz@kernel.org>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-11-seanjc@google.com>
 <9236e715-c471-e1c8-6117-6f37b908a6bd@redhat.com>
 <875ytjbxpq.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <875ytjbxpq.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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

On 26/10/21 17:41, Marc Zyngier wrote:
>> This needs a word on why kvm_psci_vcpu_suspend does not need the
>> hooks.  Or it needs to be changed to also use kvm_vcpu_wfi in the PSCI
>> code, I don't know.
>>
>> Marc, can you review and/or advise?
> I was looking at that over the weekend, and that's a pre-existing
> bug. I would have addressed it independently, but it looks like you
> already have queued the patch.

I have "queued" it, but that's just my queue - it's not on kernel.org 
and it's not going to be in 5.16, at least not in the first batch.

There's plenty of time for me to rebase on top of a fix, if you want to 
send the fix through your kvm-arm pull request.  Just Cc me so that I 
understand what's going on.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
