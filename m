Return-Path: <SRS0=q2PC=PU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86DAC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 65C8060F36
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 65C8060F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1802F4B235;
	Mon,  1 Nov 2021 17:40:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pvtcVWl1tepp; Mon,  1 Nov 2021 17:40:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82B244B26B;
	Mon,  1 Nov 2021 17:40:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 160094B12C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 18:52:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fxFOXlD9d4x6 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 Oct 2021 18:52:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DADAA4B129
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 18:52:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635720723;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dQzBTZB2neuQYMfndsZa2+3/XGXbUkUJliSXmv07Tbg=;
 b=TewOPruTUwM2k0xjQHDskCDRHUq6yLeFDZgV2emtnflNAZlnNeuc5bGcI/vCBBu54IWtgk
 0CPU8en6ErBnXCC8c5UKQh/v7MG+VS6RIJm1AdmtqOHYJLFugS15F2BPrORuJTuQ8zz7RA
 8lyAGEpBKLMBoK9J2g2HJUp5tu2TSQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-8bdx3_mDPHG0BFe5kWTFcQ-1; Sun, 31 Oct 2021 18:52:00 -0400
X-MC-Unique: 8bdx3_mDPHG0BFe5kWTFcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE91391272;
 Sun, 31 Oct 2021 22:51:56 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9DE0810023AB;
 Sun, 31 Oct 2021 22:51:41 +0000 (UTC)
Message-ID: <432666f36add6647283631770f1b140656c67c62.camel@redhat.com>
Subject: Re: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst
 computation out of write loop
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Date: Mon, 01 Nov 2021 00:51:39 +0200
In-Reply-To: <YXrL1EuzZtTR4J1Q@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-28-seanjc@google.com>
 <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
 <YXrL1EuzZtTR4J1Q@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mailman-Approved-At: Mon, 01 Nov 2021 17:40:12 -0400
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

On Thu, 2021-10-28 at 16:12 +0000, Sean Christopherson wrote:
> On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> > On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > > Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
> > > out of the loop to write the descriptor, preemption is disabled so the
> > > CPU won't change, and if the APIC ID changes KVM has bigger problems.
> > > 
> > > No functional change intended.
> > 
> > Is preemption always disabled in vmx_vcpu_pi_load? vmx_vcpu_pi_load is called
> > from vmx_vcpu_load, which is called indirectly from vcpu_load which is called
> > from many ioctls, which userspace does. In these places I don't think that
> > preemption is disabled.
> 
> Preemption is disabled in vcpu_load() by the get_cpu().  The "cpu" param that's
> passed around the vcpu_load() stack is also why I think it's ok to _not_ assert
> that preemption is disabled in vmx_vcpu_pi_load(); if preemption is enabled,
> "cpu" is unstable and thus the entire "load" operation is busted.

Yes, I even knew about the get_cpu() behavier which indeed has to disable preemption.
But I didn't notice call to it, when I wrote this mail! Later I did notice it but it was
too late. Sometimes sending all the review mails at once at the end does make sense after all,
I guess.

Best regards,
	Maxim Levitsky

> 
> 
> #define get_cpu()		({ preempt_disable(); __smp_processor_id(); })
> #define put_cpu()		preempt_enable()
> 
> 
> void vcpu_load(struct kvm_vcpu *vcpu)
> {
> 	int cpu = get_cpu();
> 
> 	__this_cpu_write(kvm_running_vcpu, vcpu);
> 	preempt_notifier_register(&vcpu->preempt_notifier);
> 	kvm_arch_vcpu_load(vcpu, cpu);
> 	put_cpu();
> }
> EXPORT_SYMBOL_GPL(vcpu_load);
> 


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
