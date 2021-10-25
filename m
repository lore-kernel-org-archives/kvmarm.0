Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1583C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 13:53:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59BF560EC0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 13:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 59BF560EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98BE4B188;
	Mon, 25 Oct 2021 09:53:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MAQuGCoQ8WVX; Mon, 25 Oct 2021 09:53:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8573C4B166;
	Mon, 25 Oct 2021 09:53:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D44364B131
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 09:53:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aprQn5SWH-5D for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 09:53:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3A34B126
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 09:53:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635170029;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ldvB0XPe33TqQvODn/mAyWJW6RTodpHfwe2FHTdvAFU=;
 b=GXXFhEzliPEcJLvvZzh2shwmCdmugPPyjAFuSYTsiTvYCYYFX5h8IzKurdQ7NgbL/4jHE+
 6uCNHLVbNt2NQZGVgXIKUvUW9VOM34Qlyq+qWvr6sPqANxm3NfqJ8FkrSUJSNBzcVur770
 t1Z1Mf6r6cH5IQWNHrvwOQLEtF9w8lM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-zLyU5cVfOXi7aDrL6nNNYQ-1; Mon, 25 Oct 2021 09:53:48 -0400
X-MC-Unique: zLyU5cVfOXi7aDrL6nNNYQ-1
Received: by mail-wm1-f69.google.com with SMTP id
 b197-20020a1c1bce000000b0032ca040eb40so3204170wmb.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 06:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=ldvB0XPe33TqQvODn/mAyWJW6RTodpHfwe2FHTdvAFU=;
 b=iNuqfOP8NXItQyHL6ixEcieA4MYBcgXLKHOEqb4whdCHsY1DHl9G+dVjErcGJ1g670
 jLVHH3vAMw8mTYu4xIIX40to/ofBAKhkpAAzyXtEzo5Cg9H6ueRWveZBCgTTQ87WoEEP
 UKTBnPCM76kkvXFL9ewtxeaSKg2JfG1CfeB4XEfRhE1MqVsjw+BVnoy7H4cr4ln/6l/X
 mHDNlBS0SS/IwmsKhJ96edhelztQMLf3YtD2adNtvkTZfOziHNVzx7Bi0hoSjc+j+TGk
 wIy6+yg8EeyEMkfpqMXeXuO5Ry7BwGQgHzSzk8Al6EOWSC8QRIcIYuHl+p/mIyOccsQR
 UpAw==
X-Gm-Message-State: AOAM532h12suamc1WAq09Jii/ClcNNkU0+XWwTPupFTmNaykZ+TtAQOO
 JMuhrFOY+tZYGm9fiU/PVSlazJSqfUTFKXwvioRqtZbUyc+GN86olMA5D8oRF2pLgxLjRODg9OZ
 zi9Y6IgYlW7/lGbuOR7p0VYaF
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr23196018wrq.8.1635170027208; 
 Mon, 25 Oct 2021 06:53:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEcYontEfeBK4K4y+WBxRPdIWb2mvxosMQ7CiN54IG+B17uliVNi9fSUiTsG9r0hC4umYIPQ==
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr23195965wrq.8.1635170026960; 
 Mon, 25 Oct 2021 06:53:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id l20sm21932937wmq.42.2021.10.25.06.53.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 06:53:46 -0700 (PDT)
Message-ID: <acfdf0f5-0a18-162a-c785-fa0a520e3364@redhat.com>
Date: Mon, 25 Oct 2021 15:53:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 22/43] KVM: VMX: Drop unnecessary PI logic to handle
 impossible conditions
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-23-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-23-seanjc@google.com>
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
> Drop sanity checks on the validity of the previous pCPU when handling
> vCPU block/unlock for posted interrupts.  Barring a code bug or memory
> corruption, the sanity checks will never fire, and any code bug that does
> trip the WARN is all but guaranteed to completely break posted interrupts,
> i.e. should never get anywhere near production.
> 
> This is the first of several steps toward eliminating kvm_vcpu.pre_cpu.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/posted_intr.c | 24 ++++++++++--------------
>   1 file changed, 10 insertions(+), 14 deletions(-)

The idea here is to avoid making things worse by not making the list 
inconsistent.  But that's impossible to do if pre_pcpu goes away, so 
fair enough.

Paolo

> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 67cbe6ab8f66..6c2110d91b06 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -118,12 +118,10 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>   	} while (cmpxchg64(&pi_desc->control, old.control,
>   			   new.control) != old.control);
>   
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
> -		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		list_del(&vcpu->blocked_vcpu_list);
> -		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		vcpu->pre_pcpu = -1;
> -	}
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	list_del(&vcpu->blocked_vcpu_list);
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	vcpu->pre_pcpu = -1;
>   }
>   
>   /*
> @@ -153,14 +151,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>   
>   	WARN_ON(irqs_disabled());
>   	local_irq_disable();
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
> -		vcpu->pre_pcpu = vcpu->cpu;
> -		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		list_add_tail(&vcpu->blocked_vcpu_list,
> -			      &per_cpu(blocked_vcpu_on_cpu,
> -				       vcpu->pre_pcpu));
> -		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -	}
> +
> +	vcpu->pre_pcpu = vcpu->cpu;
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	list_add_tail(&vcpu->blocked_vcpu_list,
> +		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>   
>   	WARN(pi_desc->sn == 1,
>   	     "Posted Interrupt Suppress Notification set before blocking");
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
