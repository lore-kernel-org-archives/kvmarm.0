Return-Path: <SRS0=roT/=JX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1D3C43460
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 12:55:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C853F61359
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 12:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C853F61359
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 281964B08D;
	Mon, 26 Apr 2021 08:55:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 37FooqebQdvZ; Mon, 26 Apr 2021 08:55:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 265CE4B092;
	Mon, 26 Apr 2021 08:55:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDE2D4B08B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 08:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QMDsvo4eSoHG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Apr 2021 08:55:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D244AEF8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 08:55:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619441733;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=E96iHRi0pDB8Gx/hvOHUwMH9SmXwt6oYBpOC2eqrBwY=;
 b=G01ZSW3byI1cQm2ZFl9uyU8Gwcp3elGNwvwGInnIIvzdh0wn5zvgALgf3A6SWUpk0fxdlf
 gkaOqtG4dBJMfLCND8A7/1iLjJpzY7Cs9+cVfM+rc16evAlCKyV3DSYwWtN+h442jR4QF2
 QdjZRTCcU0auadVmrIG1fl6i7JeJRSk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-ox-s-fAiPJqFOVOvEveCng-1; Mon, 26 Apr 2021 08:55:29 -0400
X-MC-Unique: ox-s-fAiPJqFOVOvEveCng-1
Received: by mail-ej1-f71.google.com with SMTP id
 x21-20020a1709064bd5b029037c44cb861cso10132142ejv.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 05:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=E96iHRi0pDB8Gx/hvOHUwMH9SmXwt6oYBpOC2eqrBwY=;
 b=gQhkF4ImLCDUNkRfcgCERmGMcDOT2N/ogK3wWHeXrWAWq91VwesBJl7TeV6PmttkBy
 P4LYm7hk6smASfbN5QPCoCKjT6PnYvySugWA9ean0C621wEzSMlqJ84MG8HMmFw8ep+x
 P0M8m/XoEHnen7rDS4xQf/Dto5pWBwUFsMlHr5ZSGyl4UwTCHjhRycc1ID+fTTMTNWDK
 gwYyy8gQlKCSRoG0tC4tjt+/gUDqOC0mrXiPIxWpVLzrk0dS5k4WS32RvTlvqFtRv+ka
 dNhNuB5BpBlAy4O3xRDz1Zz7zymFdKzPqBn8UjU/BWwHAMN+MA2QXbe3fj+sPSlSY6lM
 udmQ==
X-Gm-Message-State: AOAM531axT5vdBnw7c5Kt8cNN+PBeE4jFS8iBpd7OzwDvBeUbZJbfJEn
 uOG7LBMEcg7fX/iO4PMFjsAEMVRS8yFKfMalspR4aIrWRkcJOnFVFsNZ4HPeSdZtcTRky4fXv++
 MgqPg0r7fpaXpFWZRRiSr82pT
X-Received: by 2002:a17:906:64f:: with SMTP id
 t15mr18008577ejb.411.1619441728603; 
 Mon, 26 Apr 2021 05:55:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTtmFyrhUELiEp1Slv3Dv1f/poXDpkq6nkg7FLSZqKNS3iFCBG4GlPkVuX75QtDDae6M/k8A==
X-Received: by 2002:a17:906:64f:: with SMTP id
 t15mr18008528ejb.411.1619441728303; 
 Mon, 26 Apr 2021 05:55:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id la24sm12007107ejb.71.2021.04.26.05.55.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 26 Apr 2021 05:55:27 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] KVM: my debug patch queue
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
 <cb7f918c-932f-d558-76ec-801ed8ed1f62@redhat.com>
 <6d7146021f3435330b42f2e1b917d4b5dea00edc.camel@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <afba4cd8-72d3-ae18-df22-92be3b8eb321@redhat.com>
Date: Mon, 26 Apr 2021 14:55:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <6d7146021f3435330b42f2e1b917d4b5dea00edc.camel@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, "open list:S390" <linux-s390@vger.kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 "maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Kieran Bingham <kbingham@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <linux-arm-kernel@lists.infradead.org>, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
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

On 26/04/21 14:43, Maxim Levitsky wrote:
> On Fri, 2021-04-02 at 10:38 -0700, Paolo Bonzini wrote:
>> On 01/04/21 15:54, Maxim Levitsky wrote:
>>> Hi!
>>>
>>> I would like to publish two debug features which were needed for other stuff
>>> I work on.
>>>
>>> One is the reworked lx-symbols script which now actually works on at least
>>> gdb 9.1 (gdb 9.2 was reported to fail to load the debug symbols from the kernel
>>> for some reason, not related to this patch) and upstream qemu.
>>
>> Queued patches 2-5 for now.  6 is okay but it needs a selftest. (e.g.
>> using KVM_VCPU_SET_EVENTS) and the correct name for the constant.
> Do you mean to add a kvm-unit-test or to add a test to kernel's kvm unit tests
> for this?

selftests is used for those in the kernel.  "Unit test" can mean both, 
but usually it means kvm-unit-tests because they're easier to write.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
