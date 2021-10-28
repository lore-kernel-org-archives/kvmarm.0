Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78D2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 15:55:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6618A610D2
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 15:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6618A610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E53644B08D;
	Thu, 28 Oct 2021 11:55:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ngtuSvCq0f-Q; Thu, 28 Oct 2021 11:55:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCAA84B099;
	Thu, 28 Oct 2021 11:55:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 920684A524
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:55:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0yudJ93wyBRo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 11:55:47 -0400 (EDT)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 401874A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:55:47 -0400 (EDT)
Received: by mail-pl1-f180.google.com with SMTP id t11so4715713plq.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=m0tHnHlQJDBdfArgGfCXfVMbH9LdSSnDL35miUYeLjs=;
 b=QQmaJ8nXN2KbyIG5k1JyBoSquPg6yk3b/FNSx1V8PjEEIwsY4bZfol7aYj6Ws7u8lu
 AL3QNRVPk8G4o1zbT2wS3T+0q2unqIYIGvpD4X4hbS+GWLCfdCjK1582SOfCPxgbXaj6
 rp1/zAb/gxsig9wW4x8Hmz3hVUCDwIHJtvbG8WTJj+OyXJ9Qbywk0hsQ9i5L1juwa1hs
 n78Jiehn21G0dcgi1vzqMRfnUHdXLWIscCjEk3VHPYnbJSs6c8My2YAhN/ZegigH9hDg
 LWqS5PZjO6n0Z4WJ0z7BuPmceVWRsCdNKwW5JM9MnEgXi3tzkHrjJO1A1KNXmTOVd/Xz
 cMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=m0tHnHlQJDBdfArgGfCXfVMbH9LdSSnDL35miUYeLjs=;
 b=YRhgCm+j8WhzTJN0EWFYXmyM/J5VQbfyhfRj98ZKyHYj47WXxQdReyTJ0SzJvKFq6+
 S43TFGTKuJndezjNCuEIqAeJgzImUxBX7Nj9R3Z2DNDXWsgmvDPFpVU9vLkxRt4TzSZQ
 qALQ7zf8wxvJjO7vTnDb9i8PtPSSuAQWRdNQraYg4XiXJfDFSRgG8bGLYJznoqwZCZED
 Lnr2Oo8z8LVbe+8fXaOGd2b+09nDgWJ5ifFRcRko+5NtTvWyOZxIUUD10oeOQ2oUttnL
 S6B8G9N0DtomKiJHBwPSztUkH3DyPe4iR4tYgYb0I5yWj3Ac8KM0jnz9GVCau7bXEylm
 5KhA==
X-Gm-Message-State: AOAM5319NpXGBpB90n80J7001Zyn/BZMGMgxrRSxIav+VLPd84zUn2C8
 G0fyuA38N+YeEdTGerS9pK2dTQ==
X-Google-Smtp-Source: ABdhPJwGUzCGTG+bFEKCx4HxRTPn7WtM79GFmjO7irPTWNvcrtXMPEuDRtNZ53pGeMNDkz8HGfA6sw==
X-Received: by 2002:a17:90b:17d0:: with SMTP id
 me16mr13884280pjb.152.1635436545938; 
 Thu, 28 Oct 2021 08:55:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id s12sm3788591pfg.70.2021.10.28.08.55.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Oct 2021 08:55:45 -0700 (PDT)
Date: Thu, 28 Oct 2021 15:55:41 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control"
 exactly once per loop iteration
Message-ID: <YXrH/ZZBOHrWHz4j@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-27-seanjc@google.com>
 <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
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
> > Use READ_ONCE() when loading the posted interrupt descriptor control
> > field to ensure "old" and "new" have the same base value.  If the
> > compiler emits separate loads, and loads into "new" before "old", KVM
> > could theoretically drop the ON bit if it were set between the loads.
> > 
> > Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/posted_intr.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 414ea6972b5c..fea343dcc011 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -53,7 +53,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >  
> >  	/* The full case.  */
> >  	do {
> > -		old.control = new.control = pi_desc->control;
> > +		old.control = new.control = READ_ONCE(pi_desc->control);
> >  
> >  		dest = cpu_physical_id(cpu);
> >  
> > @@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
> >  	     "Wakeup handler not enabled while the vCPU was blocking");
> >  
> >  	do {
> > -		old.control = new.control = pi_desc->control;
> > +		old.control = new.control = READ_ONCE(pi_desc->control);
> >  
> >  		dest = cpu_physical_id(vcpu->cpu);
> >  
> > @@ -160,7 +160,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
> >  	     "Posted Interrupt Suppress Notification set before blocking");
> >  
> >  	do {
> > -		old.control = new.control = pi_desc->control;
> > +		old.control = new.control = READ_ONCE(pi_desc->control);
> >  
> >  		/* set 'NV' to 'wakeup vector' */
> >  		new.nv = POSTED_INTR_WAKEUP_VECTOR;
> 
> I wish there was a way to mark fields in a struct, as requiring 'READ_ONCE' on them
> so that compiler would complain if this isn't done, or automatically use 'READ_ONCE'
> logic.

Hmm, I think you could make an argument that ON and thus the whole "control"
word should be volatile.  AFAICT, tagging just "on" as volatile actually works.
There's even in a clause in Documentation/process/volatile-considered-harmful.rst
that calls this out as a (potentially) legitimate use case.

  - Pointers to data structures in coherent memory which might be modified
    by I/O devices can, sometimes, legitimately be volatile.

That said, I think I actually prefer forcing the use of READ_ONCE.  The descriptor
requires more protections than what volatile provides, namely that all writes need
to be atomic.  So given that volatile alone isn't sufficient, I'd prefer to have
the code itself be more self-documenting.

E.g. this compiles and does mess up the expected size.

diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 7f7b2326caf5..149df3b18789 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -11,9 +11,9 @@ struct pi_desc {
        union {
                struct {
                                /* bit 256 - Outstanding Notification */
-                       u16     on      : 1,
+                       volatile u16    on      : 1;
                                /* bit 257 - Suppress Notification */
-                               sn      : 1,
+                       u16     sn      : 1,
                                /* bit 271:258 - Reserved */
                                rsvd_1  : 14;
                                /* bit 279:272 - Notification Vector */
@@ -23,7 +23,7 @@ struct pi_desc {
                                /* bit 319:288 - Notification Destination */
                        u32     ndst;
                };
-               u64 control;
+               volatile u64 control;
        };
        u32 rsvd[6];
 } __aligned(64);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
