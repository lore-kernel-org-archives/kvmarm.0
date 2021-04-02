Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0321C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:07:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0884E61158
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:07:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0884E61158
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2024B371;
	Fri,  2 Apr 2021 13:07:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RBjI3dLE-vPq; Fri,  2 Apr 2021 13:07:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8A934B343;
	Fri,  2 Apr 2021 13:07:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1CAF4B343
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 13:07:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ckuLsJnoc53J for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 13:07:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9CCC4B2EF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 13:07:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617383259;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pay6FFP22GZUza5aFGS6CFJxV2F4MgiZsF6UU6/dhI8=;
 b=ATPcKbtHy6g4Ua0i/mWArcrbdGqgCyPxF8ZWPn+cprx4iqJvFfQFEi8EUdNBD1wwuWW+Ye
 Cv9Z5VHa6IU9RIcWDtWE0PAHnzWBMcfDwerw4E6FOKHQ1vzhsnLymPzKKlFPkvXUssxKrY
 eeXuDYbBLPX4DVx6SMBe1bzIMJE4S6g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-liQu17DGOlGmQuR_1AuYgQ-1; Fri, 02 Apr 2021 13:07:37 -0400
X-MC-Unique: liQu17DGOlGmQuR_1AuYgQ-1
Received: by mail-ej1-f71.google.com with SMTP id p11so3333520eju.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 10:07:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=pay6FFP22GZUza5aFGS6CFJxV2F4MgiZsF6UU6/dhI8=;
 b=ZeRh/t+0cvuCpNI3yChbJdHpNnuGuz4qe++yoD9jD/4kmfKk7ZH2ZOAUTNan+72+nZ
 XWI7DelLereRXu2KwrUIK5FFSKKx8V+tmKZ9MkX2jdUqSYVIl8OcT+Pq90Qe6EPARxbX
 LOcPNvQvzW26e+Cl9NmGpUQkfOyyQPjf2G9OGgpoOqiHkbso/12bEzjCQ8lFNwkYbUK5
 ylyfVNhYH8gWx9YS6zDcCJV2K5BaPNCLD+I3IdiwnV6WuatejMziuM5EE7rdYVmnRJtz
 pUg5URYm7kWBu/gi5hvTNfqp/4ooRimEAgBNy8ebCxos9mzRLXuqimk3s1xtRju8VkVD
 Sl9A==
X-Gm-Message-State: AOAM532zF46fTTvrXfTYeL/L5igSmMkPjuj8R3/T/gpXikeuTHj9Ap2k
 cLPxPsqsi3cL8n31Gd5FTFoUq5ExNPI2x7jqwPU3uEQVlilJwhk7D8dSFJ3LS4USXq6Ua+UBWE4
 Nceh/lHBEZa1hAUYtdgX8LE0c
X-Received: by 2002:a17:906:b7d1:: with SMTP id
 fy17mr1377115ejb.110.1617383255827; 
 Fri, 02 Apr 2021 10:07:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXsPPad+p73EMnvJYFjYKnSnzORC6vJi4cBRKTJqD3MK+cq9HDx86dIhXgIO61njm5wpECng==
X-Received: by 2002:a17:906:b7d1:: with SMTP id
 fy17mr1377082ejb.110.1617383255634; 
 Fri, 02 Apr 2021 10:07:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id k12sm5638463edo.50.2021.04.02.10.07.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Apr 2021 10:07:34 -0700 (PDT)
Subject: Re: [PATCH v2 6/9] KVM: x86: implement KVM_GUESTDBG_BLOCKEVENTS
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
 <20210401135451.1004564-7-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9e1ca0c-d6cb-7477-55f2-c4861d8f8704@redhat.com>
Date: Fri, 2 Apr 2021 19:07:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401135451.1004564-7-mlevitsk@redhat.com>
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
> KVM_GUESTDBG_BLOCKEVENTS is a guest debug feature that
> will allow KVM to block all interrupts while running.
> It is mostly intended to be used together with single stepping,
> to make it more robust, and has the following benefits:
> 
> * Resuming from a breakpoint is much more reliable:
>    When resuming execution from a breakpoint, with interrupts enabled,
>    more often than not, KVM would inject an interrupt and make the CPU
>    jump immediately to the interrupt handler and eventually return to
>    the breakpoint, only to trigger it again.
> 
>    From the gdb's user point of view it looks like the CPU has never
>    executed a single instruction and in some cases that can even
>    prevent forward progress, for example, when the breakpoint
>    is placed by an automated script (e.g lx-symbols), which does
>    something in response to the breakpoint and then continues
>    the guest automatically.
>    If the script execution takes enough time for another interrupt to
>    arrive, the guest will be stuck on the same breakpoint forever.
> 
> * Normal single stepping is much more predictable, since it won't
>    land the debugger into an interrupt handler.
> 
> * Chances of RFLAGS.TF being leaked to the guest are reduced:
> 
>    KVM sets that flag behind the guest's back to single step it,
>    but if the single step lands the vCPU into an
>    interrupt/exception handler the RFLAGS.TF will be leaked to the
>    guest in the form of being pushed to the stack.
>    This doesn't completely eliminate this problem as exceptions
>    can still happen, but at least this eliminates the common
>    case.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

The patch uses BLOCKIRQ instead of BLOCKEVENTS.

Paolo

> ---
>   Documentation/virt/kvm/api.rst  | 1 +
>   arch/x86/include/asm/kvm_host.h | 3 ++-
>   arch/x86/include/uapi/asm/kvm.h | 1 +
>   arch/x86/kvm/x86.c              | 4 ++++
>   4 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9778b2434c03..a4f2dc84741f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3338,6 +3338,7 @@ flags which can include the following:
>     - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
>     - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
>     - KVM_GUESTDBG_EXIT_PENDING:  trigger an immediate guest exit [s390]
> +  - KVM_GUESTDBG_BLOCKIRQ:      avoid injecting interrupts/NMI/SMI [x86]
>   
>   For example KVM_GUESTDBG_USE_SW_BP indicates that software breakpoints
>   are enabled in memory so we need to ensure breakpoint exceptions are
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cc7c82a449d5..8c529ae9dbbe 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -227,7 +227,8 @@ enum x86_intercept_stage;
>   	KVM_GUESTDBG_USE_HW_BP | \
>   	KVM_GUESTDBG_USE_SW_BP | \
>   	KVM_GUESTDBG_INJECT_BP | \
> -	KVM_GUESTDBG_INJECT_DB)
> +	KVM_GUESTDBG_INJECT_DB | \
> +	KVM_GUESTDBG_BLOCKIRQ)
>   
>   
>   #define PFERR_PRESENT_BIT 0
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 5a3022c8af82..b0f9945067f7 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -282,6 +282,7 @@ struct kvm_debug_exit_arch {
>   #define KVM_GUESTDBG_USE_HW_BP		0x00020000
>   #define KVM_GUESTDBG_INJECT_DB		0x00040000
>   #define KVM_GUESTDBG_INJECT_BP		0x00080000
> +#define KVM_GUESTDBG_BLOCKIRQ		0x00100000
>   
>   /* for KVM_SET_GUEST_DEBUG */
>   struct kvm_guest_debug_arch {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 956e8e0bd6af..3627ce8fe5bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8460,6 +8460,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>   		can_inject = false;
>   	}
>   
> +	/* Don't inject interrupts if the user asked to avoid doing so */
> +	if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ)
> +		return;
> +
>   	/*
>   	 * Finally, inject interrupt events.  If an event cannot be injected
>   	 * due to architectural conditions (e.g. IF=0) a window-open exit
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
