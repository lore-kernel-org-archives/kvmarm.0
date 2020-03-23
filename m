Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB2AC54FD0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B89E920735
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lv68lBgV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B89E920735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 709284B0BB;
	Mon, 23 Mar 2020 09:35:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UCtX5CFVd7zy; Mon, 23 Mar 2020 09:35:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C8FD4B0D0;
	Mon, 23 Mar 2020 09:35:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D01BE4A534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cvBMYLpb3hh1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 08:46:30 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F32D14A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:46:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584967589;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YdFpUchc9Jk3kYBBsZjPPjHpUFyVWFs7ezq+T4dqNO0=;
 b=Lv68lBgVBzp5smwRVMsnGYS/8ifcnVph8DguuqWt/+KYqwVdnHEOANbee7fKRCWmyMUBAc
 C1wWtm+8wGR3BR6nl2wbMdaSjNjNSEFkKqTSPjbzYbynAFWeOSw91PnNiGR1MuZmJQ6SuN
 sHBLCT2w+LprbIkyGD1s/cC7lddRoUA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-gKbuWjmvN2G9DAD5i_ZpQg-1; Mon, 23 Mar 2020 08:46:26 -0400
X-MC-Unique: gKbuWjmvN2G9DAD5i_ZpQg-1
Received: by mail-wm1-f69.google.com with SMTP id y1so1986981wmj.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 05:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=7ey+1F39M8ByNAstuPtE4DBKq3YafypzQysKAMbXteM=;
 b=Fc8/K2Mz1q8HeZ6mgYHc2LJAOLfm0pd5TZoivAyYfbltI+Q6vxVv+PpJsAUAPy1Vz6
 4nFEh1Plmh4igBySdDCJ/0n1ea1CL86RXCX4NnHUkMzxpWQoCWWvT8adfcsFN710JA0e
 KQzp+8elFbfVRZRzn6Kirjvl7c12I1/IvCkjjYc1nejdTKktxZ4b66cJw6qJP9S5XO0r
 qgTdKFv41cOpiStBbhABatsS/Dz90bwfsLTKGVUgRLyYyjDIJf7D1Au3AQxQgmgjUjKE
 PINswA2z7xiU74dZEZsLg9B4Gq5NgTpL5buRFqVwQjxDF785o/g8W7nBQeyyIHCxz+C6
 7vJw==
X-Gm-Message-State: ANhLgQ1H+eVUfTjIKgbI9H5vd/1yRFTUjU1gM/s4hrKSoIrFY/G3UBUw
 BQ0WgvVHySQQI7FbxmQ1+wPzLfadpW4hFkZKD2/vM3E4JhlDwoO33A9z4GnisTjwtJoM8GBl9L0
 4KAZ2wyREh/iwNfMQH0ikJF/g
X-Received: by 2002:a1c:6745:: with SMTP id b66mr27121459wmc.30.1584967584693; 
 Mon, 23 Mar 2020 05:46:24 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs9yhBZxRUgm+rnsEcxWBh8IaB2Gorhbhsei0xdDIWP+ldbP2TNlbOrXiLaqIWct/my8m4nng==
X-Received: by 2002:a1c:6745:: with SMTP id b66mr27121425wmc.30.1584967584395; 
 Mon, 23 Mar 2020 05:46:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id f15sm23749313wru.83.2020.03.23.05.46.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Mar 2020 05:46:23 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 7/9] KVM: x86: Drop __exit from kvm_x86_ops'
 hardware_unsetup()
In-Reply-To: <20200321202603.19355-8-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-8-sean.j.christopherson@intel.com>
Date: Mon, 23 Mar 2020 13:46:22 +0100
Message-ID: <87a7479r35.fsf@vitty.brq.redhat.com>
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

> Remove the __exit annotation from VMX hardware_unsetup(), the hook
> can be reached during kvm_init() by way of kvm_arch_hardware_unsetup()
> if failure occurs at various points during initialization.
>
> Note, there is no known functional issue with the __exit annotation, the
> above is merely justification for its removal.  The real motivation is
> to be able to annotate vmx_x86_ops and svm_x86_ops with __initdata,
> which makes objtool complain because objtool doesn't understand that the
> vendor specific __initdata is being copied by value to a non-__initdata
> instance.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 54f991244fae..42a2d0d3984a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1056,7 +1056,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  struct kvm_x86_ops {
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
> -	void (*hardware_unsetup)(void);            /* __exit */
> +	void (*hardware_unsetup)(void);
>  	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(int index);
>  	void (*cpuid_update)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bbe0d165a0c..fac22e316417 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7652,7 +7652,7 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  	return to_vmx(vcpu)->nested.vmxon;
>  }
>  
> -static __exit void hardware_unsetup(void)
> +static void hardware_unsetup(void)
>  {
>  	if (nested)
>  		nested_vmx_hardware_unsetup();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
