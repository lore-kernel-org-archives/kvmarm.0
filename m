Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF745C3F2CD
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 16:23:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6688A2051A
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 16:23:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6688A2051A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C575F4A500;
	Mon, 23 Mar 2020 12:23:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sgc4K6O-hcTI; Mon, 23 Mar 2020 12:23:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF8854A524;
	Mon, 23 Mar 2020 12:23:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15FCE4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 12:23:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dc33S6k7fMPm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 12:23:33 -0400 (EDT)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A3A44A49F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 12:23:33 -0400 (EDT)
IronPort-SDR: yo7oIls2yYwHf/cAhzqsMVZKXyZgddINZ6H78xYDPDaRcBAME/MHmBtvZWKcPNsXE9IAQP/RBl
 L6sJPSsJi1xw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Mar 2020 09:23:06 -0700
IronPort-SDR: MSUbytwPG21W6dHu5U5WS4F+QkOtlYnEVMtPHZM2yy05ToGOBSa/Iia6kA8iGdkqDv5h8AChKj
 rBEIy+2a4Nvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; d="scan'208";a="357139587"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 23 Mar 2020 09:23:05 -0700
Date: Mon, 23 Mar 2020 09:23:05 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 4/9] KVM: VMX: Configure runtime hooks using vmx_x86_ops
Message-ID: <20200323162305.GL28711@linux.intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-5-sean.j.christopherson@intel.com>
 <87ftdz9ryn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ftdz9ryn.fsf@vitty.brq.redhat.com>
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

On Mon, Mar 23, 2020 at 01:27:28PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Configure VMX's runtime hooks by modifying vmx_x86_ops directly instead
> > of using the global kvm_x86_ops.  This sets the stage for waiting until
> > after ->hardware_setup() to set kvm_x86_ops with the vendor's
> > implementation.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 15 ++++++++-------
> >  arch/x86/kvm/vmx/nested.h |  3 ++-
> >  arch/x86/kvm/vmx/vmx.c    | 27 ++++++++++++++-------------
> >  3 files changed, 24 insertions(+), 21 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 4ff859c99946..87fea22c3799 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -6241,7 +6241,8 @@ void nested_vmx_hardware_unsetup(void)
> >  	}
> >  }
> >  
> > -__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
> > +__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
> > +				     int (*exit_handlers[])(struct kvm_vcpu *))
> >  {
> >  	int i;
> >  
> > @@ -6277,12 +6278,12 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
> >  	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid;
> >  	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
> >  
> > -	kvm_x86_ops->check_nested_events = vmx_check_nested_events;
> > -	kvm_x86_ops->get_nested_state = vmx_get_nested_state;
> > -	kvm_x86_ops->set_nested_state = vmx_set_nested_state;
> > -	kvm_x86_ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> > -	kvm_x86_ops->nested_enable_evmcs = nested_enable_evmcs;
> > -	kvm_x86_ops->nested_get_evmcs_version = nested_get_evmcs_version;
> > +	ops->check_nested_events = vmx_check_nested_events;
> > +	ops->get_nested_state = vmx_get_nested_state;
> > +	ops->set_nested_state = vmx_set_nested_state;
> > +	ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> > +	ops->nested_enable_evmcs = nested_enable_evmcs;
> > +	ops->nested_get_evmcs_version = nested_get_evmcs_version;
> 
> 
> A lazy guy like me would appreciate 'ops' -> 'vmx_x86_ops' rename as it
> would make 'git grep vmx_x86_ops' output more complete.

Ah, didn't think about that, obviously.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
