Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A768DC3F2CD
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B7182074D
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q9cqpTkw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B7182074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 016F54B0A3;
	Mon, 23 Mar 2020 09:35:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6dwriebPrBKQ; Mon, 23 Mar 2020 09:35:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C794B0C6;
	Mon, 23 Mar 2020 09:35:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E9B4B08C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:27:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ukQ1jsQTyxSd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 08:27:34 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B928D4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:27:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584966454;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XHqDwnBcQX6Iwh2x6EyPK1O15FlriFbwTmhL0tjClQc=;
 b=Q9cqpTkwan5xiMYqIO8tAufUbuVTmUKdbnDDaj8LW9B7O1HSSkP+3kYtIYTx7c6jNC0SxZ
 l9VONShJukKv3z3ytQH6noXKqloR/MGT3Httk2p1IpOIbsYYmwow82HEirVAXP3XdgLoaZ
 TemjDBnmP8idwPHPEerYGTldRvA84cE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-cvkqTMKxMpewPuNrWrNbAQ-1; Mon, 23 Mar 2020 08:27:32 -0400
X-MC-Unique: cvkqTMKxMpewPuNrWrNbAQ-1
Received: by mail-wr1-f72.google.com with SMTP id p2so7291034wrw.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 05:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=VAG2Qatyfr9ITMHT/x+i3AqePq75ernJyjHorg/4AHo=;
 b=Of9prNunP2hR0DdN67z9L1VnWD3ltJ0Qz9+iIQh1R8ZyokNV/gI6A3xGj//jHDjAy/
 q3U0EwzypdWwTQHikyJLEzsAF9ujIG2aZ8PlriPzGy6FZ0k1KNFnM9vzehA9nZ4n+pWP
 a4UYgCxlu+QCsAGg5HxLmlzvVcJliBu1gKaL2BhJHTtHd0xKtfv8Emrcr60ehkfHAlot
 SAXkvamV6dGycviphAKbUH+Zn+td/XRCtuG4Hv36VUm8hH4bS6r+i9IOgMVvaegqCFSZ
 Qa0O0aLwVuFz+nxy3zt2ixeoe974CZ+JCpjVQTckfU7tQrmlY9iGqEnc5kBN9es7b8B0
 ExkA==
X-Gm-Message-State: ANhLgQ0GTHVPb0Qd/pZ/DLoxSWJA3K+OL4w3bmwY00Q+C4pdU/3FXE0x
 MIiMCxkKiLp7fcZJt7cJ3KjIWEC55CItrZwzLDXaPdK/CwcYPj6eERaOcOu17a5S3WTb72bx8tC
 flXAAmUDXBEJRrpTkgm1QwUGK
X-Received: by 2002:a05:600c:10ce:: with SMTP id
 l14mr12350645wmd.161.1584966451336; 
 Mon, 23 Mar 2020 05:27:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtaue9eiNEXDxuxd28wMxP3Ylw+xs1AMMjsgqF/l/irHmVdBHDVD/xrHC24aOu9ZbqdIgz1FQ==
X-Received: by 2002:a05:600c:10ce:: with SMTP id
 l14mr12350596wmd.161.1584966451052; 
 Mon, 23 Mar 2020 05:27:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id s15sm22694648wrt.16.2020.03.23.05.27.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Mar 2020 05:27:30 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 4/9] KVM: VMX: Configure runtime hooks using vmx_x86_ops
In-Reply-To: <20200321202603.19355-5-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-5-sean.j.christopherson@intel.com>
Date: Mon, 23 Mar 2020 13:27:28 +0100
Message-ID: <87ftdz9ryn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Mon, 23 Mar 2020 09:35:35 -0400
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
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

> Configure VMX's runtime hooks by modifying vmx_x86_ops directly instead
> of using the global kvm_x86_ops.  This sets the stage for waiting until
> after ->hardware_setup() to set kvm_x86_ops with the vendor's
> implementation.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 15 ++++++++-------
>  arch/x86/kvm/vmx/nested.h |  3 ++-
>  arch/x86/kvm/vmx/vmx.c    | 27 ++++++++++++++-------------
>  3 files changed, 24 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4ff859c99946..87fea22c3799 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6241,7 +6241,8 @@ void nested_vmx_hardware_unsetup(void)
>  	}
>  }
>  
> -__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
> +__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
> +				     int (*exit_handlers[])(struct kvm_vcpu *))
>  {
>  	int i;
>  
> @@ -6277,12 +6278,12 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>  	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid;
>  	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
>  
> -	kvm_x86_ops->check_nested_events = vmx_check_nested_events;
> -	kvm_x86_ops->get_nested_state = vmx_get_nested_state;
> -	kvm_x86_ops->set_nested_state = vmx_set_nested_state;
> -	kvm_x86_ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> -	kvm_x86_ops->nested_enable_evmcs = nested_enable_evmcs;
> -	kvm_x86_ops->nested_get_evmcs_version = nested_get_evmcs_version;
> +	ops->check_nested_events = vmx_check_nested_events;
> +	ops->get_nested_state = vmx_get_nested_state;
> +	ops->set_nested_state = vmx_set_nested_state;
> +	ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> +	ops->nested_enable_evmcs = nested_enable_evmcs;
> +	ops->nested_get_evmcs_version = nested_get_evmcs_version;


A lazy guy like me would appreciate 'ops' -> 'vmx_x86_ops' rename as it
would make 'git grep vmx_x86_ops' output more complete.

>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index f70968b76d33..ac56aefa49e3 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -19,7 +19,8 @@ enum nvmx_vmentry_status {
>  void vmx_leave_nested(struct kvm_vcpu *vcpu);
>  void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
>  void nested_vmx_hardware_unsetup(void);
> -__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
> +__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
> +				     int (*exit_handlers[])(struct kvm_vcpu *));
>  void nested_vmx_set_vmcs_shadowing_bitmap(void);
>  void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
>  enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 82dab775d520..cfa9093bdc06 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7860,16 +7860,16 @@ static __init int hardware_setup(void)
>  	 * using the APIC_ACCESS_ADDR VMCS field.
>  	 */
>  	if (!flexpriority_enabled)
> -		kvm_x86_ops->set_apic_access_page_addr = NULL;
> +		vmx_x86_ops.set_apic_access_page_addr = NULL;
>  
>  	if (!cpu_has_vmx_tpr_shadow())
> -		kvm_x86_ops->update_cr8_intercept = NULL;
> +		vmx_x86_ops.update_cr8_intercept = NULL;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
>  	    && enable_ept) {
> -		kvm_x86_ops->tlb_remote_flush = hv_remote_flush_tlb;
> -		kvm_x86_ops->tlb_remote_flush_with_range =
> +		vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
> +		vmx_x86_ops.tlb_remote_flush_with_range =
>  				hv_remote_flush_tlb_with_range;
>  	}
>  #endif
> @@ -7884,7 +7884,7 @@ static __init int hardware_setup(void)
>  
>  	if (!cpu_has_vmx_apicv()) {
>  		enable_apicv = 0;
> -		kvm_x86_ops->sync_pir_to_irr = NULL;
> +		vmx_x86_ops.sync_pir_to_irr = NULL;
>  	}
>  
>  	if (cpu_has_vmx_tsc_scaling()) {
> @@ -7916,10 +7916,10 @@ static __init int hardware_setup(void)
>  		enable_pml = 0;
>  
>  	if (!enable_pml) {
> -		kvm_x86_ops->slot_enable_log_dirty = NULL;
> -		kvm_x86_ops->slot_disable_log_dirty = NULL;
> -		kvm_x86_ops->flush_log_dirty = NULL;
> -		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
> +		vmx_x86_ops.slot_enable_log_dirty = NULL;
> +		vmx_x86_ops.slot_disable_log_dirty = NULL;
> +		vmx_x86_ops.flush_log_dirty = NULL;
> +		vmx_x86_ops.enable_log_dirty_pt_masked = NULL;
>  	}
>  
>  	if (!cpu_has_vmx_preemption_timer())
> @@ -7947,9 +7947,9 @@ static __init int hardware_setup(void)
>  	}
>  
>  	if (!enable_preemption_timer) {
> -		kvm_x86_ops->set_hv_timer = NULL;
> -		kvm_x86_ops->cancel_hv_timer = NULL;
> -		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
> +		vmx_x86_ops.set_hv_timer = NULL;
> +		vmx_x86_ops.cancel_hv_timer = NULL;
> +		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
>  	}
>  
>  	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
> @@ -7965,7 +7965,8 @@ static __init int hardware_setup(void)
>  		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
>  					   vmx_capability.ept);
>  
> -		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
> +		r = nested_vmx_hardware_setup(&vmx_x86_ops,
> +					      kvm_vmx_exit_handlers);
>  		if (r)
>  			return r;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
