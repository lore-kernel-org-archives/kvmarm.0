Return-Path: <SRS0=kG2x=5J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66C3C4332B
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 08:17:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 332BC207FF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 08:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GcF9qP06"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 332BC207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD7C4A4C0;
	Tue, 24 Mar 2020 04:17:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6+fZWOeZm0Q7; Tue, 24 Mar 2020 04:17:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A36B4B0A1;
	Tue, 24 Mar 2020 04:17:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D1F84A500
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 12:25:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mk9l1-SQw-ja for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 12:25:03 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 702954A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 12:25:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584980703;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1KcTBJzO6vWLTAizjBFxPBY9nEeHoxSdUmsZCL+8CkQ=;
 b=GcF9qP062I8K4Xi3e94Z56vUeNSlc5bZWi23TzP66M2pi0NJXoQcglV7jZMTW0694H0/It
 FRieHsXHSIBsLfsQiOaw1LAQE8XYB7w/y+JLmW3SdG1BrgCUWaAdbS6XnH50QG0RZiBmA/
 niwkREzvxVOkPzY2B03fEFoRxjx6F1Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-aOfV0Q_AOu6WJHkENRGuCg-1; Mon, 23 Mar 2020 12:25:00 -0400
X-MC-Unique: aOfV0Q_AOu6WJHkENRGuCg-1
Received: by mail-wm1-f71.google.com with SMTP id f8so27423wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 09:24:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=X1Ry1yiWvSlF/GO2rvf8iBUf/GEmj9nn1/CSsWhpLSU=;
 b=rq2GgQx2DoX/kOJEofGd9gXWXK3oS+7rAl8+LnTFB6oAGHvoVb85IvA7OXZWjH21bl
 OhBfkve8oMCNEsLuobj5Us4IvbHHG9IZHbfmt6Wk9acxgiVRabiGA/2g2CEB/1MPphzp
 LuXPyrjBNFsY8sdlsZ1AOQSQ+LEjxtWhHpFwhfvoenHh8DBooz5n1b1N28iNWa82AlA5
 3ru06YYq/TBK3mGw6unO7lzenADwe6qnHOnXyhpol79s7r9frI1jUCDslR/WmnCDlWxv
 SbWEz3IqYzm+k5t0SFHQi0hnaWL85ycbsW8QE2j92uCepfyLr7ONw+8jJjn7/XJou/Ok
 ZU0w==
X-Gm-Message-State: ANhLgQ0l/xRWcob7yBT2GNZVtKqK4BFQMWKgkLMIL0/vO91dpmz2gFNE
 kp7tIW64k9kn0xiGJpFudu3+198tvKTf3CzP8o0C8pTIJCVKrUu49en1rq+4W8XYmJ5iSSI7tb+
 TWEX3vOKtsS5JyBC4fAtaMdyg
X-Received: by 2002:a05:600c:3cb:: with SMTP id z11mr75064wmd.94.1584980698709; 
 Mon, 23 Mar 2020 09:24:58 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsn477+cxrvpcfJzZ9WXWmF0SKMmbIayFwHATIum/A7SWzS2LgH2WXH6U684IfdISlyncs+7g==
X-Received: by 2002:a05:600c:3cb:: with SMTP id z11mr75027wmd.94.1584980698414; 
 Mon, 23 Mar 2020 09:24:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id p10sm19419160wrm.6.2020.03.23.09.24.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Mar 2020 09:24:57 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate
 struct
In-Reply-To: <20200323152909.GE28711@linux.intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-3-sean.j.christopherson@intel.com>
 <87lfnr9sqn.fsf@vitty.brq.redhat.com>
 <20200323152909.GE28711@linux.intel.com>
Date: Mon, 23 Mar 2020 17:24:56 +0100
Message-ID: <87o8sn82ef.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Tue, 24 Mar 2020 04:17:11 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Mar 23, 2020 at 01:10:40PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > +
>> > +	.runtime_ops = &svm_x86_ops,
>> > +};
>> 
>> Unrelated to your patch but I think we can make the naming of some of
>> these functions more consistend on SVM/VMX, in particular I'd suggest 
>> 
>> has_svm() -> cpu_has_svm_support()
>> is_disabled -> svm_disabled_by_bios()
>> ...
>> (see below for VMX)
>> 
>> > +
>> >  static int __init svm_init(void)
>> >  {
>> > -	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
>> > +	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
>> >  			__alignof__(struct vcpu_svm), THIS_MODULE);
>> >  }
>> >  
>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index 07299a957d4a..ffcdcc86f5b7 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -7842,11 +7842,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>> >  }
>> >  
>> >  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>> > -	.cpu_has_kvm_support = cpu_has_kvm_support,
>> > -	.disabled_by_bios = vmx_disabled_by_bios,
>> > -	.hardware_setup = hardware_setup,
>> >  	.hardware_unsetup = hardware_unsetup,
>> > -	.check_processor_compatibility = vmx_check_processor_compat,
>> > +
>> >  	.hardware_enable = hardware_enable,
>> >  	.hardware_disable = hardware_disable,
>> >  	.cpu_has_accelerated_tpr = report_flexpriority,
>> > @@ -7981,6 +7978,15 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>> >  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>> >  };
>> >  
>> > +static struct kvm_x86_init_ops vmx_init_ops __initdata = {
>> > +	.cpu_has_kvm_support = cpu_has_kvm_support,
>> > +	.disabled_by_bios = vmx_disabled_by_bios,
>> > +	.check_processor_compatibility = vmx_check_processor_compat,
>> > +	.hardware_setup = hardware_setup,
>> 
>> cpu_has_kvm_support() -> cpu_has_vmx_support()
>> hardware_setup() -> vmx_hardware_setup()
>
> Preaching to the choir on this one.  The VMX functions without prefixes in
> in particular annoy me to no end, e.g. hardware_setup().  Though the worst
> is probably ".vcpu_create = vmx_create_vcpu", if I had a nickel for every
> time I've tried to find vmx_vcpu_create()...
>
> What if we added a macro to auto-generate the common/required hooks?  E.g.:
>
>   static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> 	MANDATORY_KVM_X86_OPS(vmx),
>
> 	.pmu_ops = &intel_pmu_ops,
>
> 	...
>   };
>
> That'd enforce consistent naming, and would provide a bit of documentation
> as to which hooks are optional, e.g. many of the nested hooks, and which
> must be defined for KVM to function.

Sounds cool! (not sure that with only two implementations people won't
call it 'over-engineered' but cool). My personal wish would just be that
function names in function implementations are not auto-generated so
e.g. a simple 'git grep vmx_hardware_setup' works but the way how we
fill vmx_x86_ops in can be macroed I guess.

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
