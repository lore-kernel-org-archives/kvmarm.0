Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03742C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 18:55:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDC44B13D;
	Mon, 29 Nov 2021 13:55:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dhLaQJ3yp+L6; Mon, 29 Nov 2021 13:55:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFC4E4B0ED;
	Mon, 29 Nov 2021 13:55:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 550A54B0DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 13:55:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dXQcrswP0ocq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 13:55:20 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF46C4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 13:55:19 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id y7so12964392plp.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 10:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=TYbgQqCpCmOsVo/Ud6S4W0dWbGKnEHCC/sbfSrxRU2Q=;
 b=V9NdrM9IGQ8TORtVAjZzUck1RI7UtY24/5ryhbIDx46VwTLIEKKddxeNbMrV6TQpIl
 KTCIPozOyBw/wCgOEJPsKU3C9LENDNILuHldgqEm6W55x2AEOVy9zbC+oB0Q8kNXcib2
 utENfqKkezcYzZnD0pmUAjWeJ/cGQai7wseSy0Tb7+ezAyGs24Tiec69FywheOS97WPw
 hiOKPwklIAtqAAVwW+TVa82nOI4oJHItJIs2sHILKArSIy33/Br5zlJSRUemG17TIymQ
 2z90v41HGfafPsWOqjYsVFIk8gpVXUcAMJTfJevG+nopt2huTRvy9U+7v5siSDcfSs81
 05ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TYbgQqCpCmOsVo/Ud6S4W0dWbGKnEHCC/sbfSrxRU2Q=;
 b=1meoNtkmUFdhtawnbONFZUa7JreFGffsP6MZY743z9IYFWJl9YYh2kg8SrfWjAW7f/
 Sg89ieOF0Pfr5SKwHCD/OLJ4EIMBVy1Ab0AlLN702D9Q8xwYG9aM6PCkvcHNDrLQ3N29
 KgglbdbePj2CXc4heD51t+kFTU9vqxH2a+aFPZBRre8/Pcu0oOA1r7WLqPqh0ACx6ON3
 jsTQ3A766r/KPiVwZ6OK+8lUywT75BwQ5pFY44f29SygGSeZLy3oH2FGSuecTsUw6xXb
 qV8HJhwzzGLBBATuWF+opcuY7PILDyIIBxlkAut1uBXcrM2fcwEugcp3139DQT5zLbme
 2Q+w==
X-Gm-Message-State: AOAM532WoZD8ASgoiBzCSuGkUuYqQBxAcuyf60QcS+ys7tOninHaW80H
 J/IXPQttZ2HUFFE3A2PT0loK5Q==
X-Google-Smtp-Source: ABdhPJzGwlSa9NgpBenMt4CKt9Ftf4k4qsHL0lT0KjuZVEYivrfeFPAQn3AoVSiAs1eAB5ezweh9DQ==
X-Received: by 2002:a17:90b:2251:: with SMTP id
 hk17mr189639pjb.31.1638212118683; 
 Mon, 29 Nov 2021 10:55:18 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id d17sm17979027pfj.215.2021.11.29.10.55.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 29 Nov 2021 10:55:18 -0800 (PST)
Date: Mon, 29 Nov 2021 18:55:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Message-ID: <YaUiEquKYi5eqWC0@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
 <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Maxim Levitsky <mlevitsk@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Nov 29, 2021, Paolo Bonzini wrote:
> On 11/29/21 18:25, Sean Christopherson wrote:
> > If a posted interrupt arrives after KVM has done its final search through the vIRR,
> > but before avic_update_iommu_vcpu_affinity() is called, the posted interrupt will
> > be set in the vIRR without triggering a host IRQ to wake the vCPU via the GA log.
> > 
> > I.e. KVM is missing an equivalent to VMX's posted interrupt check for an outstanding
> > notification after switching to the wakeup vector.
> 
> BTW Maxim reported that it can break even without assigned devices.
> 
> > For now, the least awful approach is sadly to keep the vcpu_(un)blocking() hooks.
> 
> I agree that the hooks cannot be dropped but the bug is reproducible with
> this patch, where the hooks are still there.

...

> Still it does seem to be a race that happens when IS_RUNNING=true but
> vcpu->mode == OUTSIDE_GUEST_MODE.  This patch makes the race easier to
> trigger because it moves IS_RUNNING=false later.

Oh!  Any chance the bug only repros with preemption enabled?  That would explain
why I don't see problems, I'm pretty sure I've only run AVIC with a PREEMPT=n.

svm_vcpu_{un}blocking() are called with preemption enabled, and avic_set_running()
passes in vcpu->cpu.  If the vCPU is preempted and scheduled in on a different CPU,
avic_vcpu_load() will overwrite the vCPU's entry with the wrong CPU info.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
