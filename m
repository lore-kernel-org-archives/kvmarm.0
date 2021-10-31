Return-Path: <SRS0=q2PC=PU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E310C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E94DF60EE3
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E94DF60EE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BC354B213;
	Mon,  1 Nov 2021 17:40:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cdGOfzxnp6RP; Mon,  1 Nov 2021 17:40:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 611E34B267;
	Mon,  1 Nov 2021 17:40:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 270F64B0C2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 18:48:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mD96XJrjvgLa for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 Oct 2021 18:48:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDFDF4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 18:48:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635720520;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IAXDzBRARqGuWFKHNo+aw3J6+tC4cDZIOgfc+O9TnKM=;
 b=KXf8KnsELmuZ68+O4xGbHDKP39F/ob3GelkkJxFi755vN7e9wqF+ePCZhqxdPO6sBszYU9
 hT+52st9P5rDrHcPtgu3+ehl9/g5cVvarto9lr4UZCE0O0wM6sQaXgUJBO+pU9WCgoxHVU
 UEUE/6OfNKltvSic9RP5pxmurnoDBog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-DA7Ib6_UPm-Qx5l3Quy1qw-1; Sun, 31 Oct 2021 18:48:35 -0400
X-MC-Unique: DA7Ib6_UPm-Qx5l3Quy1qw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95B171006AA2;
 Sun, 31 Oct 2021 22:48:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 03B4019C79;
 Sun, 31 Oct 2021 22:48:18 +0000 (UTC)
Message-ID: <20a17d75855dfb9bd496466fcd9f14baab0b2bda.camel@redhat.com>
Subject: Re: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control"
 exactly once per loop iteration
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Date: Mon, 01 Nov 2021 00:48:17 +0200
In-Reply-To: <YXrH/ZZBOHrWHz4j@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-27-seanjc@google.com>
 <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
 <YXrH/ZZBOHrWHz4j@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

On Thu, 2021-10-28 at 15:55 +0000, Sean Christopherson wrote:
> On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> > On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > > Use READ_ONCE() when loading the posted interrupt descriptor control
> > > field to ensure "old" and "new" have the same base value.  If the
> > > compiler emits separate loads, and loads into "new" before "old", KVM
> > > could theoretically drop the ON bit if it were set between the loads.
> > > 
> > > Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/posted_intr.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > > index 414ea6972b5c..fea343dcc011 100644
> > > --- a/arch/x86/kvm/vmx/posted_intr.c
> > > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > > @@ -53,7 +53,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> > >  
> > >  	/* The full case.  */
> > >  	do {
> > > -		old.control = new.control = pi_desc->control;
> > > +		old.control = new.control = READ_ONCE(pi_desc->control);
> > >  
> > >  		dest = cpu_physical_id(cpu);
> > >  
> > > @@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
> > >  	     "Wakeup handler not enabled while the vCPU was blocking");
> > >  
> > >  	do {
> > > -		old.control = new.control = pi_desc->control;
> > > +		old.control = new.control = READ_ONCE(pi_desc->control);
> > >  
> > >  		dest = cpu_physical_id(vcpu->cpu);
> > >  
> > > @@ -160,7 +160,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
> > >  	     "Posted Interrupt Suppress Notification set before blocking");
> > >  
> > >  	do {
> > > -		old.control = new.control = pi_desc->control;
> > > +		old.control = new.control = READ_ONCE(pi_desc->control);
> > >  
> > >  		/* set 'NV' to 'wakeup vector' */
> > >  		new.nv = POSTED_INTR_WAKEUP_VECTOR;
> > 
> > I wish there was a way to mark fields in a struct, as requiring 'READ_ONCE' on them
> > so that compiler would complain if this isn't done, or automatically use 'READ_ONCE'
> > logic.
> 
> Hmm, I think you could make an argument that ON and thus the whole "control"
> word should be volatile.  AFAICT, tagging just "on" as volatile actually works.
> There's even in a clause in Documentation/process/volatile-considered-harmful.rst
> that calls this out as a (potentially) legitimate use case.
> 
>   - Pointers to data structures in coherent memory which might be modified
>     by I/O devices can, sometimes, legitimately be volatile.
> 
> That said, I think I actually prefer forcing the use of READ_ONCE.  The descriptor
> requires more protections than what volatile provides, namely that all writes need
> to be atomic.  So given that volatile alone isn't sufficient, I'd prefer to have
> the code itself be more self-documenting.

I took a look at how READ_ONCE/WRITE_ONCE is implemented and indeed they use volatile
(the comment above __READ_ONCE is worth gold...), so there is a bit of contradiction:

volatile-considered-harmful.rst states not to mark struct members volatile since
you usually need more that than (very true often) and yet, I also heard that
READ_ONCE/WRITE_ONCE is very encouraged to be used to fields that are used in lockless
algorithms, even when not strictly needed,
so why not to just mark the field and then use it normally? I guess that
explicit READ_ONCE/WRITE_ONCE is much more readable/visible that a volatile in some header file.

Anyway this isn't something I am going to argue about or push to be changed,
just something I thought about.

Best regards,
	Maxim Levitsky



> 
> E.g. this compiles and does mess up the expected size.
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index 7f7b2326caf5..149df3b18789 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -11,9 +11,9 @@ struct pi_desc {
>         union {
>                 struct {
>                                 /* bit 256 - Outstanding Notification */
> -                       u16     on      : 1,
> +                       volatile u16    on      : 1;
>                                 /* bit 257 - Suppress Notification */
> -                               sn      : 1,
> +                       u16     sn      : 1,
>                                 /* bit 271:258 - Reserved */
>                                 rsvd_1  : 14;
>                                 /* bit 279:272 - Notification Vector */
> @@ -23,7 +23,7 @@ struct pi_desc {
>                                 /* bit 319:288 - Notification Destination */
>                         u32     ndst;
>                 };
> -               u64 control;
> +               volatile u64 control;
>         };
>         u32 rsvd[6];
>  } __aligned(64);
> 


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
