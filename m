Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A13C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 16:12:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72AC060E8C
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 16:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 72AC060E8C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D89C34B14C;
	Thu, 28 Oct 2021 12:12:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NyO-wHPgDArm; Thu, 28 Oct 2021 12:12:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 380494B1CF;
	Thu, 28 Oct 2021 12:12:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A34524B1CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 12:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TI2q4waoAQkT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 12:12:09 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55F8F4B14C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 12:12:09 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id a26so6404247pfr.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 09:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uDFUXcWiQOAZszlFDFiKgSiJL9HB/WuFg2qPOmsqC9E=;
 b=s8JT5njEusSpDvvGXpDQ9LZlankma9a4yiSWD9KOohfnBHlxyPNl/U/08pekLcb/bC
 ovoSobTTd28f9TmLEDOEfxcyphCFmhjuM9+ON0HPn4qn8BCTN2ldIPxu2jDowg4XqJu6
 3xH28lP4FssgtQ0ca7hD6ajCl1FxkivUDYuXRLmLx2Yi3tCCzZXargRA7TY8R9VN5f+Z
 OVvgBrcUFyQ3a4VjcEcymihbaDJ3t1+Gwm46k3BuLJXPbEryRKF1JBLikEHoHCefGv/7
 I7zNR4Q9EXiCvnW7HnxhjPhNdV9zeEX0aTdpBRV58BMvHDUDx6AGdT+87VVv7qJ97TcC
 uARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uDFUXcWiQOAZszlFDFiKgSiJL9HB/WuFg2qPOmsqC9E=;
 b=0LP3tn9JNK4NK/z9BiD7LD/7Q52fPVc/Vwnfy87QH0Z7vUf7qZp8th/pY3vmmoJVB/
 ksDcn8R47oRizuMXDXf8jEX/guJMfhUk/sEG9dCHq4dBzXvTUCKLx7btBerwNGiYC3r2
 z4s4wfb61b+L6e43No+udRTMuVuApdjOO4GPGIZ7TSe8hPS1qH883F2CZM4U40Mt1S23
 KbjZzbBJAZFZoSrmXLJ563aW5sRyIRplw2l7Ih+kqS2QXz9+gb7j6mm2MYuuqU1C2/0B
 WA2tTgMGdbxSAZt1OKmoB1XSHmRmJ0IMzRobSlvAq2mtuYoi58EgDQmBqbwiuNFRSiWK
 pHOw==
X-Gm-Message-State: AOAM532u1+fSlfwl1bdjTJY13UOnnJFrgx3nvfhq/oYrCwcumHX768Xv
 Vftpw1TwyjPFTArGAVWaIkQjWg==
X-Google-Smtp-Source: ABdhPJzctFKuSMS4ABMglKZzvBYXQnPOjA4L7dQsvoAPPXlll55VtYD46hr5Zh0pXIPugFNW+Dl/hA==
X-Received: by 2002:a05:6a00:1709:b0:47e:493e:ca5f with SMTP id
 h9-20020a056a00170900b0047e493eca5fmr4461870pfc.60.1635437528216; 
 Thu, 28 Oct 2021 09:12:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id f7sm4329616pfv.152.2021.10.28.09.12.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Oct 2021 09:12:07 -0700 (PDT)
Date: Thu, 28 Oct 2021 16:12:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst
 computation out of write loop
Message-ID: <YXrL1EuzZtTR4J1Q@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-28-seanjc@google.com>
 <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
> > out of the loop to write the descriptor, preemption is disabled so the
> > CPU won't change, and if the APIC ID changes KVM has bigger problems.
> > 
> > No functional change intended.
> 
> Is preemption always disabled in vmx_vcpu_pi_load? vmx_vcpu_pi_load is called
> from vmx_vcpu_load, which is called indirectly from vcpu_load which is called
> from many ioctls, which userspace does. In these places I don't think that
> preemption is disabled.

Preemption is disabled in vcpu_load() by the get_cpu().  The "cpu" param that's
passed around the vcpu_load() stack is also why I think it's ok to _not_ assert
that preemption is disabled in vmx_vcpu_pi_load(); if preemption is enabled,
"cpu" is unstable and thus the entire "load" operation is busted.


#define get_cpu()		({ preempt_disable(); __smp_processor_id(); })
#define put_cpu()		preempt_enable()


void vcpu_load(struct kvm_vcpu *vcpu)
{
	int cpu = get_cpu();

	__this_cpu_write(kvm_running_vcpu, vcpu);
	preempt_notifier_register(&vcpu->preempt_notifier);
	kvm_arch_vcpu_load(vcpu, cpu);
	put_cpu();
}
EXPORT_SYMBOL_GPL(vcpu_load);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
