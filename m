Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FC8C3F2CD
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 16:31:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F80D20774
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 16:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F80D20774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDBB14B08A;
	Mon, 23 Mar 2020 12:31:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id njf9nXf1Y21M; Mon, 23 Mar 2020 12:31:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 951CC4A524;
	Mon, 23 Mar 2020 12:31:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE4FF4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 12:31:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rM2U1ZTKQiod for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 12:31:39 -0400 (EDT)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 846014A49F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 12:31:39 -0400 (EDT)
IronPort-SDR: +FaVmY0TPOlqL2FDu3yT3NgFW6byXlsng/gENRuWnt6dW9qzhTTXqWEovnQo2Vf/Za1KFoIUj6
 +cjbWBaB7WZw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Mar 2020 09:31:38 -0700
IronPort-SDR: szHRtSFDap8tPDDbCZjY8IsJB86JbCOaVx3NCNFM02k1aZo2cLfAgzLVZG93EZD2pGO8Xl0/T8
 x/vNCF1+MuCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; d="scan'208";a="357141639"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 23 Mar 2020 09:31:37 -0700
Date: Mon, 23 Mar 2020 09:31:36 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate
 struct
Message-ID: <20200323163136.GO28711@linux.intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-3-sean.j.christopherson@intel.com>
 <87lfnr9sqn.fsf@vitty.brq.redhat.com>
 <20200323152909.GE28711@linux.intel.com>
 <87o8sn82ef.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87o8sn82ef.fsf@vitty.brq.redhat.com>
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

On Mon, Mar 23, 2020 at 05:24:56PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Mon, Mar 23, 2020 at 01:10:40PM +0100, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> 
> >> > +
> >> > +	.runtime_ops = &svm_x86_ops,
> >> > +};
> >> 
> >> Unrelated to your patch but I think we can make the naming of some of
> >> these functions more consistend on SVM/VMX, in particular I'd suggest 
> >> 
> >> has_svm() -> cpu_has_svm_support()
> >> is_disabled -> svm_disabled_by_bios()
> >> ...
> >> (see below for VMX)
> >> 
> >> > +
> >> >  static int __init svm_init(void)
> >> >  {
> >> > -	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
> >> > +	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
> >> >  			__alignof__(struct vcpu_svm), THIS_MODULE);
> >> >  }
> >> >  
> >> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> > index 07299a957d4a..ffcdcc86f5b7 100644
> >> > --- a/arch/x86/kvm/vmx/vmx.c
> >> > +++ b/arch/x86/kvm/vmx/vmx.c
> >> > @@ -7842,11 +7842,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
> >> >  }
> >> >  
> >> >  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >> > -	.cpu_has_kvm_support = cpu_has_kvm_support,
> >> > -	.disabled_by_bios = vmx_disabled_by_bios,
> >> > -	.hardware_setup = hardware_setup,
> >> >  	.hardware_unsetup = hardware_unsetup,
> >> > -	.check_processor_compatibility = vmx_check_processor_compat,
> >> > +
> >> >  	.hardware_enable = hardware_enable,
> >> >  	.hardware_disable = hardware_disable,
> >> >  	.cpu_has_accelerated_tpr = report_flexpriority,
> >> > @@ -7981,6 +7978,15 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >> >  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> >> >  };
> >> >  
> >> > +static struct kvm_x86_init_ops vmx_init_ops __initdata = {
> >> > +	.cpu_has_kvm_support = cpu_has_kvm_support,
> >> > +	.disabled_by_bios = vmx_disabled_by_bios,
> >> > +	.check_processor_compatibility = vmx_check_processor_compat,
> >> > +	.hardware_setup = hardware_setup,
> >> 
> >> cpu_has_kvm_support() -> cpu_has_vmx_support()
> >> hardware_setup() -> vmx_hardware_setup()
> >
> > Preaching to the choir on this one.  The VMX functions without prefixes in
> > in particular annoy me to no end, e.g. hardware_setup().  Though the worst
> > is probably ".vcpu_create = vmx_create_vcpu", if I had a nickel for every
> > time I've tried to find vmx_vcpu_create()...
> >
> > What if we added a macro to auto-generate the common/required hooks?  E.g.:
> >
> >   static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> > 	MANDATORY_KVM_X86_OPS(vmx),
> >
> > 	.pmu_ops = &intel_pmu_ops,
> >
> > 	...
> >   };
> >
> > That'd enforce consistent naming, and would provide a bit of documentation
> > as to which hooks are optional, e.g. many of the nested hooks, and which
> > must be defined for KVM to function.
> 
> Sounds cool! (not sure that with only two implementations people won't
> call it 'over-engineered' but cool). My personal wish would just be that
> function names in function implementations are not auto-generated so
> e.g. a simple 'git grep vmx_hardware_setup' works but the way how we
> fill vmx_x86_ops in can be macroed I guess.

Ya, I was thinking of just the macro.  Even that has downsides though, e.g.
chasing kvm_x86_ops.hardware_setup() to find VMX's hardware_setup() becomes
a bit kludgy.  On the other hand, _if_ you know how the fill macro works,
getting to the implementation should be easier.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
