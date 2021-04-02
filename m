Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B245FC433B4
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:38:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 278AF61164
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:38:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 278AF61164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA37B4B30B;
	Fri,  2 Apr 2021 13:38:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4ez4k2fbCyYZ; Fri,  2 Apr 2021 13:38:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C0E94B354;
	Fri,  2 Apr 2021 13:38:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B9A4B30B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 13:38:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xqSf1PzYsegB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 13:38:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46C2C4B2EA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 13:38:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617385126;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TKDRlulogoRtKYWAUF1pyaqEOli9TuwMVFnHg7gDyqg=;
 b=SPv70vAssGxeWskwIjz44+8Y540A4Z+bEV3DJDBgeoczZq/+BCzVgMNPYJftN06vxqowQb
 3oxVbGc51WvJye0c005rii3ntG8c9yJj6cDbnAOqNuhYHEfTEQIegz2PV9pAhZUGd7F09u
 R6ISiCgoXUb6BBxCWrzrTqb65PG2Elk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-IL-1eVwnP_S3-BJPUSW-Kw-1; Fri, 02 Apr 2021 13:38:44 -0400
X-MC-Unique: IL-1eVwnP_S3-BJPUSW-Kw-1
Received: by mail-ej1-f72.google.com with SMTP id e13so3332115ejd.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 10:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=TKDRlulogoRtKYWAUF1pyaqEOli9TuwMVFnHg7gDyqg=;
 b=OrbtlW2PqzKYMlRW/pjK6tnUiQe2X4ZEA9bmyJuo2AvHuE3ZcEIu8XN2+rXuYWgfZR
 aw422FlUGMHG9iu/ylvzNWmfHKPxHFjBj3wh4mYg5NL1eq6E2RH8eoYI9ZjO9jEUG9XU
 dprp/wPtsXusNnI5CXalGsXshc5gZtWhyE94M1I6WSKlkL9JXXBanhOcHDn5Z2nPx84g
 wg2wdZVyQa2pEa3f/DiPriCcmyMDreM6SPxwdjN86O32XscO9JfOqiHYtjQahl7Wm6pg
 vDx59L3MfvmggPJXCCCYYZRNgpc2nR4mHycx+WE2uijcJztez3ytvvj8kegfHbqmBhy3
 woaA==
X-Gm-Message-State: AOAM5305XCTBXzsXpUrz/Bk1ecZ0RRczMMA4EdZW1box+vg2xjZXYDFV
 FnhcHgEiL1wxra1c4c1ZhMtFvsGfnrmbetEIa8sUje9DwlF3BTc7SWjG8YfqePTCnLt6ebpcgVD
 IWFHX6ZPuDxf+68UDFS2oOJCb
X-Received: by 2002:a17:907:3f10:: with SMTP id
 hq16mr2635484ejc.181.1617385123131; 
 Fri, 02 Apr 2021 10:38:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAS7ZbtJVwnzUWnA/6X0McPrVes3ar3lqem09HSmYxMrqLZW+HviZElaAarzltynI2Jr8wwA==
X-Received: by 2002:a17:907:3f10:: with SMTP id
 hq16mr2635443ejc.181.1617385122924; 
 Fri, 02 Apr 2021 10:38:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id y17sm4462135ejf.116.2021.04.02.10.38.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Apr 2021 10:38:42 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] KVM: my debug patch queue
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb7f918c-932f-d558-76ec-801ed8ed1f62@redhat.com>
Date: Fri, 2 Apr 2021 19:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
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

On 01/04/21 15:54, Maxim Levitsky wrote:
> Hi!
> 
> I would like to publish two debug features which were needed for other stuff
> I work on.
> 
> One is the reworked lx-symbols script which now actually works on at least
> gdb 9.1 (gdb 9.2 was reported to fail to load the debug symbols from the kernel
> for some reason, not related to this patch) and upstream qemu.

Queued patches 2-5 for now.  6 is okay but it needs a selftest. (e.g. 
using KVM_VCPU_SET_EVENTS) and the correct name for the constant.

Paolo

> The other feature is the ability to trap all guest exceptions (on SVM for now)
> and see them in kvmtrace prior to potential merge to double/triple fault.
> 
> This can be very useful and I already had to manually patch KVM a few
> times for this.
> I will, once time permits, implement this feature on Intel as well.
> 
> V2:
> 
>   * Some more refactoring and workarounds for lx-symbols script
> 
>   * added KVM_GUESTDBG_BLOCKEVENTS flag to enable 'block interrupts on
>     single step' together with KVM_CAP_SET_GUEST_DEBUG2 capability
>     to indicate which guest debug flags are supported.
> 
>     This is a replacement for unconditional block of interrupts on single
>     step that was done in previous version of this patch set.
>     Patches to qemu to use that feature will be sent soon.
> 
>   * Reworked the the 'intercept all exceptions for debug' feature according
>     to the review feedback:
> 
>     - renamed the parameter that enables the feature and
>       moved it to common kvm module.
>       (only SVM part is currently implemented though)
> 
>     - disable the feature for SEV guests as was suggested during the review
>     - made the vmexit table const again, as was suggested in the review as well.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (9):
>    scripts/gdb: rework lx-symbols gdb script
>    KVM: introduce KVM_CAP_SET_GUEST_DEBUG2
>    KVM: x86: implement KVM_CAP_SET_GUEST_DEBUG2
>    KVM: aarch64: implement KVM_CAP_SET_GUEST_DEBUG2
>    KVM: s390x: implement KVM_CAP_SET_GUEST_DEBUG2
>    KVM: x86: implement KVM_GUESTDBG_BLOCKEVENTS
>    KVM: SVM: split svm_handle_invalid_exit
>    KVM: x86: add force_intercept_exceptions_mask
>    KVM: SVM: implement force_intercept_exceptions_mask
> 
>   Documentation/virt/kvm/api.rst    |   4 +
>   arch/arm64/include/asm/kvm_host.h |   4 +
>   arch/arm64/kvm/arm.c              |   2 +
>   arch/arm64/kvm/guest.c            |   5 -
>   arch/s390/include/asm/kvm_host.h  |   4 +
>   arch/s390/kvm/kvm-s390.c          |   3 +
>   arch/x86/include/asm/kvm_host.h   |  12 ++
>   arch/x86/include/uapi/asm/kvm.h   |   1 +
>   arch/x86/kvm/svm/svm.c            |  87 +++++++++++--
>   arch/x86/kvm/svm/svm.h            |   6 +-
>   arch/x86/kvm/x86.c                |  14 ++-
>   arch/x86/kvm/x86.h                |   2 +
>   include/uapi/linux/kvm.h          |   1 +
>   kernel/module.c                   |   8 +-
>   scripts/gdb/linux/symbols.py      | 203 ++++++++++++++++++++----------
>   15 files changed, 272 insertions(+), 84 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
