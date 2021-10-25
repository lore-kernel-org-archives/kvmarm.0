Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDD2C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:35:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 495EC60F4F
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:35:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 495EC60F4F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C26C04B108;
	Mon, 25 Oct 2021 10:35:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QIqWqI+b9Jac; Mon, 25 Oct 2021 10:35:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBB44B0DF;
	Mon, 25 Oct 2021 10:35:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F7264B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:34:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C+b8NL2tJjbU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 10:34:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2287405A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:34:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635172497;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gyRr+oxbdq+D1XVZyshzBJhdWV6eJMpRCL2oDxsSBbM=;
 b=SQBkGLBaOxog2hLaf6YXCS+UY/ndEWjokIqxk8Ws8KqvyTEE0Co3Z7LtBTIp697U1HlcgV
 DbTijGyr0ZSgkptCt4zGUrPXkUOcf8Ijn+i1BCLw8Bp7+I2iJW+Lhv0qI9q2PEV85OkVUT
 aMLTaFhNymZBkzU0xhx83l44CfHd3SE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-Kt8_rBF5OzO0cyX1WeKU4Q-1; Mon, 25 Oct 2021 10:34:56 -0400
X-MC-Unique: Kt8_rBF5OzO0cyX1WeKU4Q-1
Received: by mail-ed1-f69.google.com with SMTP id
 z1-20020a05640235c100b003dcf0fbfbd8so10115959edc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 07:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=gyRr+oxbdq+D1XVZyshzBJhdWV6eJMpRCL2oDxsSBbM=;
 b=BC00LvlOH4vzxocRKcJTwCNiXCC3bDJ4SoKCSwO2lTMBRukvRwarcxwPqrMZcLePVq
 tNjAVHNiG3FZo8sDPLHWD55gn+RD1MVJjgo20XYyHPC6BV7LzQc1rc5ne6Q1rX3+ck5q
 eKJoD0G4w5/Hgy/7dwRDUzX32bOlt6C7s9vzns6lgEtd1kzdoBSrb1a+Onzh0a1zkkYT
 F9VtEwQzjr0M3AE4wR3cLsOQyyxi0YiPqdnMLXqQsf2ceDTi4Cdl3C1Ar5HTUrpdhpE5
 wL0VGmyRn0kJMybNEqXP8J+qsAZQv5K5ZAolUMdjG5iAM7g+ozRapPmyXKAuJkq5PMdU
 QqRg==
X-Gm-Message-State: AOAM530eD8LHUjoA0z5ouhlkniRU7na8U0GbiOc6SUry9ja3iR0KTmX1
 rjho+Z/lkshDEDss6LoYy1/+xgPBfwb5uiTCHTigY+JSJvM5HyTFRIAxqLPM5YiTHKP2pHrqJEh
 WjLxyXv/Lm0DTa8qP4lcPuTHf
X-Received: by 2002:a05:6402:5112:: with SMTP id
 m18mr26543457edd.101.1635172494814; 
 Mon, 25 Oct 2021 07:34:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1PVpqtFTaT+fZx+ngmF47w1xHlBRHe6pB6EMZ006WM53WXRFnHCfF7AOxx4PQB6o6e4saOQ==
X-Received: by 2002:a05:6402:5112:: with SMTP id
 m18mr26543421edd.101.1635172494578; 
 Mon, 25 Oct 2021 07:34:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m15sm10124432edd.5.2021.10.25.07.34.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 07:34:53 -0700 (PDT)
Message-ID: <335822ac-b98b-1eec-4911-34e4d0e99907@redhat.com>
Date: Mon, 25 Oct 2021 16:34:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 39/43] KVM: VMX: Don't do full kick when triggering
 posted interrupt "fails"
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-40-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-40-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/10/21 04:12, Sean Christopherson wrote:
> +		/*
> +		 * The smp_wmb() in kvm_make_request() pairs with the smp_mb_*()
> +		 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU
> +		 * is guaranteed to see the event request if triggering a posted
> +		 * interrupt "fails" because vcpu->mode != IN_GUEST_MODE.

This explanation doesn't make much sense to me.  This is just the usual 
request/kick pattern explained in 
Documentation/virt/kvm/vcpu-requests.rst; except that we don't bother 
with a "kick" out of guest mode because the entry always goes through 
kvm_check_request (in the nVMX case) or sync_pir_to_irr (if non-nested) 
and completes the delivery itself.

In other word, it is a similar idea as patch 43/43.

What this smp_wmb() pair with, is the smp_mb__after_atomic in 
kvm_check_request(KVM_REQ_EVENT, vcpu).  Setting the interrupt in the 
PIR orders before kvm_make_request in this thread, and orders after 
kvm_make_request in the vCPU thread.

Here, instead:

> +	/*
> +	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
> +	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
> +	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
> +	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
> +	 */
>  	if (vcpu != kvm_get_running_vcpu() &&
>  	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> -		kvm_vcpu_kick(vcpu);
> +		kvm_vcpu_wake_up(vcpu);
>  

it pairs with the smp_mb__after_atomic in vmx_sync_pir_to_irr().  As 
explained again in vcpu-requests.rst, the ON bit has the same function 
as vcpu->request in the previous case.

Paolo

> +		 */
>   		kvm_make_request(KVM_REQ_EVENT, vcpu);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
