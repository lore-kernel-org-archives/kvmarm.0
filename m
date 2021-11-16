Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64615C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:08:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6139619FA
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:08:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D6139619FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6622D4B139;
	Tue, 16 Nov 2021 11:08:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jjR21DcyHmgp; Tue, 16 Nov 2021 11:08:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECC064B13D;
	Tue, 16 Nov 2021 11:08:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A074B134
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:07:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ogYBn7bewvqp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 11:07:53 -0500 (EST)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 302094B130
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:07:53 -0500 (EST)
Received: by mail-pl1-f179.google.com with SMTP id u17so17782756plg.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 08:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Z2AKx61/RhCe2zs5ofLjhqQARlhS43Ifv8qiPWwvU8w=;
 b=lcsOSKJZX1HW4dBg29cw5mdeiwWY+loBeYbsQV+z2/nV6RWvDRujp8jkar1j2iKk7Z
 Q7kDkSiVYol/fAQwYbdXz6fN2IlDQoEEG233LaBBpiKOliI+F4QJNkSO/vk84Grwjsg1
 xgisig77vEEa4Zd5OSZNhbkVEv6fJSGPJYnEKhE6p2XLpvSYq3J4gQzmDevLkU5rdnAI
 rP9CME4bIKDfKmH+iv15W2ZbpFgsMSUMaP9zPM2kyOtgds+U6deVQ6MfC7qosULoTu5/
 vwD7KCMHs8C2lB+vzVYl7as7WrWnO4BfhRzOPbRRQhhHWPUHJLeuyWBsJIHbOy9ux35U
 p6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Z2AKx61/RhCe2zs5ofLjhqQARlhS43Ifv8qiPWwvU8w=;
 b=4kli6DT6rZr2N480BEcklWusnj6oJhBBwRGK7JmHUHgMgp/GW6jZOhhEFHA+zxRWmf
 bOFFWSSWxhveohlBeS+Rh7zckCpQlAopRyUkX+17P5Yu3xkSLNEeKzhiPLXw1y5x3uAD
 Ky/+rdmrcTC8d2OGom7NP2vWkrTWKzi3tZyytvSwdPg9yabz2wsvi1NLqZwC/oMQ/T2R
 iMZlDEOwhBvKTrWiRVO/WTOAj8QWauZodsCKU2r6U4i6QEeW2rXx94ClpbX1/oKITgX0
 qQXdLIIqMWBTGrRDU41e1lPR+rl+sz9aKp1tjFueLs6rT2adZMSbI2ZPkiwNMiIrRMt0
 LBSA==
X-Gm-Message-State: AOAM530FKMETMyBWPHDhFBluqwm9ZEz92bVi1LMfDhpQ4HFtJ6RZtcly
 FCFzkuGYDxLlXoi35JURZ58v8Q==
X-Google-Smtp-Source: ABdhPJxU6duTqsrTks/nV5OrQqCjn8t+5rodqO/OPYPZOkqch8j1M2u2I4szhAM4KHA4Nd8M6EsWPg==
X-Received: by 2002:a17:902:7890:b0:143:c4f7:59e6 with SMTP id
 q16-20020a170902789000b00143c4f759e6mr22206936pll.87.1637078871989; 
 Tue, 16 Nov 2021 08:07:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id lt5sm2725151pjb.43.2021.11.16.08.07.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 16 Nov 2021 08:07:51 -0800 (PST)
Date: Tue, 16 Nov 2021 16:07:47 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/5] KVM: x86: Use kvm_get_vcpu() instead of open-coded
 access
Message-ID: <YZPXU3eBT8j0fUPs@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-5-maz@kernel.org>
 <YYWOKTYHhJywwCRk@google.com>
 <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
Cc: Juergen Gross <jgross@suse.com>, Anup Patel <anup.patel@wdc.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Nov 16, 2021, Paolo Bonzini wrote:
> On 11/5/21 21:03, Sean Christopherson wrote:
> > But I think even that is flawed, as APICv can be dynamically deactivated and
> > re-activated while the VM is running, and I don't see a path that re-updates
> > the IRTE when APICv is re-activated.  So I think a more conservative check is
> > needed, e.g.
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 5f81ef092bd4..6cf5b2e86118 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -272,7 +272,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
> > 
> >          if (!kvm_arch_has_assigned_device(kvm) ||
> >              !irq_remapping_cap(IRQ_POSTING_CAP) ||
> > -           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
> > +           !irqchip_in_kernel(kvm) || !enable_apicv)
> >                  return 0;
> > 
> >          idx = srcu_read_lock(&kvm->irq_srcu);
> 
> What happens then if pi_pre_block is called and the IRTE denotes a posted
> interrupt?
> 
> I might be wrong, but it seems to me that you have to change all of the
> occurrences this way.  As soon as enable_apicv is set, you need to go
> through the POSTED_INTR_WAKEUP_VECTOR just in case.

Sorry, I didn't grok that at all.  All occurences of what?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
