Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DED2C3F2CD
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 15:29:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC0E020409
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 15:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC0E020409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 690FF4B09A;
	Mon, 23 Mar 2020 11:29:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5oQWeNwy3xvS; Mon, 23 Mar 2020 11:29:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D1144A588;
	Mon, 23 Mar 2020 11:29:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6023F4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 11:29:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id skttKOvYrCwT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 11:29:12 -0400 (EDT)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA1F04A4A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 11:29:11 -0400 (EDT)
IronPort-SDR: lNXOidjzJarZE/n92nk5PCX1udampwCjog4W0eonFkGLLaomMxmsI5YLVRa9hulBXL4v71C3bi
 Lgec/jmksrDA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Mar 2020 08:29:10 -0700
IronPort-SDR: yayqoarf0l9NveDHmC/sqla8uNPjr0N8shaxffNuAwPkByVFjT7hsOSfphorNwP7R2dv9kN0mF
 tMgMyB8VORFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; d="scan'208";a="269910183"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2020 08:29:09 -0700
Date: Mon, 23 Mar 2020 08:29:09 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate
 struct
Message-ID: <20200323152909.GE28711@linux.intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-3-sean.j.christopherson@intel.com>
 <87lfnr9sqn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87lfnr9sqn.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
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

On Mon, Mar 23, 2020 at 01:10:40PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > +
> > +	.runtime_ops = &svm_x86_ops,
> > +};
> 
> Unrelated to your patch but I think we can make the naming of some of
> these functions more consistend on SVM/VMX, in particular I'd suggest 
> 
> has_svm() -> cpu_has_svm_support()
> is_disabled -> svm_disabled_by_bios()
> ...
> (see below for VMX)
> 
> > +
> >  static int __init svm_init(void)
> >  {
> > -	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
> > +	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
> >  			__alignof__(struct vcpu_svm), THIS_MODULE);
> >  }
> >  
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 07299a957d4a..ffcdcc86f5b7 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7842,11 +7842,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
> >  }
> >  
> >  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> > -	.cpu_has_kvm_support = cpu_has_kvm_support,
> > -	.disabled_by_bios = vmx_disabled_by_bios,
> > -	.hardware_setup = hardware_setup,
> >  	.hardware_unsetup = hardware_unsetup,
> > -	.check_processor_compatibility = vmx_check_processor_compat,
> > +
> >  	.hardware_enable = hardware_enable,
> >  	.hardware_disable = hardware_disable,
> >  	.cpu_has_accelerated_tpr = report_flexpriority,
> > @@ -7981,6 +7978,15 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> >  };
> >  
> > +static struct kvm_x86_init_ops vmx_init_ops __initdata = {
> > +	.cpu_has_kvm_support = cpu_has_kvm_support,
> > +	.disabled_by_bios = vmx_disabled_by_bios,
> > +	.check_processor_compatibility = vmx_check_processor_compat,
> > +	.hardware_setup = hardware_setup,
> 
> cpu_has_kvm_support() -> cpu_has_vmx_support()
> hardware_setup() -> vmx_hardware_setup()

Preaching to the choir on this one.  The VMX functions without prefixes in
in particular annoy me to no end, e.g. hardware_setup().  Though the worst
is probably ".vcpu_create = vmx_create_vcpu", if I had a nickel for every
time I've tried to find vmx_vcpu_create()...

What if we added a macro to auto-generate the common/required hooks?  E.g.:

  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
	MANDATORY_KVM_X86_OPS(vmx),

	.pmu_ops = &intel_pmu_ops,

	...
  };

That'd enforce consistent naming, and would provide a bit of documentation
as to which hooks are optional, e.g. many of the nested hooks, and which
must be defined for KVM to function.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
