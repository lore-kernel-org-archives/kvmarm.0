Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234DEC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 17:53:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A69564B1AC;
	Mon, 29 Nov 2021 12:53:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EzLazPudFK5a; Mon, 29 Nov 2021 12:53:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 570194B1B0;
	Mon, 29 Nov 2021 12:53:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86B6E4B1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 12:53:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sGXJKVMDn-ul for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 12:53:55 -0500 (EST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B15F4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 12:53:55 -0500 (EST)
Received: by mail-ed1-f48.google.com with SMTP id o20so75036859eds.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 09:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=1y5DEAA90y8cYxRCLd33wqhLVpAEzLmdNKss0/RInBo=;
 b=E58dL1Cy0ML/Fq7U+4vMD/XpyhySESNFxGtsJEr0iGA5QuLlhcOX/A4/jdDRZEzDIQ
 fPsLvJxXz3PX63V9su/FgauAMqwxco+y+olI1dCd3mpfxLlYlBPlhWOjrxeLq9guNxSM
 eEfi9IneXptokJh8diXl/ugbj5GCH/6ELhKn4aofNdddGLZ+OqUWg1z9TxLUnKXffmNg
 lUaqpY0k7AwGkJ3OL2ZtKNoHyBmTZ4KtwmtpxoPlTCt2JnQOPjXQ7vH4M7rfgBjlRgND
 uViwUXN3LorpSW+ON86lkQL5g7/VvacQD/GzeWK08eJHfKwJKQfnwt7i4lLeeVe5Mvw/
 ad3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=1y5DEAA90y8cYxRCLd33wqhLVpAEzLmdNKss0/RInBo=;
 b=oH7kh9dlrYcUzIA5GUPYXzKFsX4W9utF1vbCEqBit4G8aOeNxCYED7fW4l9cbxp2CU
 t+L+bQzTsoUIg4vhYTFbQv2Rd/egV456swwzqVPige6xBi7CuQa+WtPb1ummsoL+5gma
 8rL7HauwBwKC7ioCeG5XTuMAfwluSWVl5UVqV11cHZ6OdjMfMSMhHqbduYy0vqT8FssI
 CkYQa6LkFPckiXOJhECaFN5tp9pfggOgmTvPKyjRaYPYWFBZt5izVoRAjD7pwmJhO8du
 G58teghM7g5sJIPSNaovNc0PrBnV1OIFdkFmqoHQjqrk5N6Ltq5lS6mgSCnKMHrK/JBa
 kuzQ==
X-Gm-Message-State: AOAM532GBl1CfkgFEVz7xOAFE1XexRfYclamY1BcG/txAQ3x3Kqj3OVI
 rvgHU5ethXXQcPkAQKV3B+o=
X-Google-Smtp-Source: ABdhPJyEFZTCnn35jIBM5GkhncH3CSPbL5gmVmWsUh9Tr+ztH5c8bc9QO9Acd3UAKwaA5P3qYhybfg==
X-Received: by 2002:a05:6402:2744:: with SMTP id
 z4mr77472004edd.310.1638208434290; 
 Mon, 29 Nov 2021 09:53:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.googlemail.com with ESMTPSA id gt18sm7974997ejc.46.2021.11.29.09.53.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 29 Nov 2021 09:53:53 -0800 (PST)
Message-ID: <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
Date: Mon, 29 Nov 2021 18:53:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUNBfJh35WXMV0M@google.com>
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

On 11/29/21 18:25, Sean Christopherson wrote:
> If a posted interrupt arrives after KVM has done its final search through the vIRR,
> but before avic_update_iommu_vcpu_affinity() is called, the posted interrupt will
> be set in the vIRR without triggering a host IRQ to wake the vCPU via the GA log.
> 
> I.e. KVM is missing an equivalent to VMX's posted interrupt check for an outstanding
> notification after switching to the wakeup vector.

BTW Maxim reported that it can break even without assigned devices.

> For now, the least awful approach is sadly to keep the vcpu_(un)blocking() hooks.

I agree that the hooks cannot be dropped but the bug is reproducible 
with this patch, where the hooks are still there.

With the hooks in place, you have:

	kvm_vcpu_blocking(vcpu)
	  avic_set_running(vcpu, false)
	    avic_vcpu_put(vcpu)
	      avic_update_iommu_vcpu_affinity()
	      WRITE_ONCE(...) // clear IS_RUNNING bit

	set_current_state()
	  smp_mb()

	kvm_vcpu_check_block()
	  return kvm_arch_vcpu_runnable() || ...
	    return kvm_vcpu_has_events() || ...
	      return kvm_cpu_has_interrupt() || ...
		return kvm_apic_has_interrupt() || ...
		  return apic_has_interrupt_for_ppr()
		    apic_find_highest_irr()
		      scan vIRR

This covers the barrier between the write of is_running and the read of 
vIRR, and the other side should be correct as well.  in particular, 
reads of is_running always come after an atomic write to vIRR, and hence 
after an implicit full memory barrier.  svm_deliver_avic_intr() has an 
smp_mb__after_atomic() after writing IRR; avic_kick_target_vcpus() even 
has an explicit barrier in srcu_read_lock(), between the microcode's 
write to vIRR and its own call to avic_vcpu_is_running().

Still it does seem to be a race that happens when IS_RUNNING=true but 
vcpu->mode == OUTSIDE_GUEST_MODE.  This patch makes the race easier to 
trigger because it moves IS_RUNNING=false later.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
