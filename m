Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22429C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8BB76137E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C8BB76137E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62BCE4B14C;
	Wed, 29 Sep 2021 03:12:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1M2oDUzk7o90; Wed, 29 Sep 2021 03:12:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FAF84B163;
	Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58FAB4086C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:12:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RDsgX0KjS3fV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 18:12:56 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4269940191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:12:56 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id 66so125773pgc.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 15:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=mlGjiTQKkKxj4KcXOOnDVYyCs2ZSFatBALPcwummKQM=;
 b=jNRMWegrFCxfd1N3NSKKno4QA4WsToa8zhOgjhCTO9pYDJCneH2oOgqg6dFx8DO9WF
 fwg1HEPb3KvCAeF3bRE0/7Ymnd8Dfky61i04gYYvZL7w8j6q8Y/ySOjvayDVBN4iOWxC
 +FGF2ioFURjwyLWgi9QR0Ok/CwEElNFeuVoB9sT6QJJNTKVvZ0sDmvGthThk9iVZyaDD
 F1ZENnMgH4SFf4Va3ys/kvLX4q8l6AVlrCj4ZEeSj63wNA0C7PdNfwD7gNXfs0xY8fuO
 bpPRJE2F3EWvgtBjP8eZIeX/TGj2enUv06ukSy0MfjiC+Vq77zG/0ySvIBOJhAHJ8ZTc
 80iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mlGjiTQKkKxj4KcXOOnDVYyCs2ZSFatBALPcwummKQM=;
 b=haxKozDdvXdN8V89wfkr7xf9kAL8nPOmzxwELxzdJIzd2985LAAWYSAOLpzx13CuKn
 2mFq7YFlhhzxS79AJAhsvkp62pNPRr94UyC29agLe/AFgkxMwLLqW7wLjlVinbBMBjVJ
 EEpDUYZnBje3wkb1xSPUwU9+iqzYbShv1W1eQ/tGjkM0D+BdTDyDfHAnarRa4At5gUwO
 8H4drYet8l33nt9l+hw+HpOSssM0PYpksHwGC4yVMv00Deoku6HxbeWTKDV7S0ln/qf2
 fIksa+CDAlKGCigv4CDZQtvYlLqERigvjUR7PAzbxlKKy6g9FZUyQqMcIMfbwzgHAgUA
 xSww==
X-Gm-Message-State: AOAM531XITpzqJnIvnwtF7dRAdCXlD9PxX/5rZxSQq3nXxKZ0foHaZPI
 KwxMoZDWfKjScbo30WRq7YZOnA==
X-Google-Smtp-Source: ABdhPJwMJ6PXu1iYzvoK+xsmZtCnYCHuS4ke1upsonClun/Rtn4gUyNzkh7CQWduaPHweqPWa/7aGA==
X-Received: by 2002:aa7:83c4:0:b0:44b:bc59:1a46 with SMTP id
 j4-20020aa783c4000000b0044bbc591a46mr2781583pfn.77.1632867175070; 
 Tue, 28 Sep 2021 15:12:55 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id q6sm104284pjd.26.2021.09.28.15.12.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 15:12:54 -0700 (PDT)
Date: Tue, 28 Sep 2021 22:12:50 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 13/14] KVM: x86: Directly block (instead of "halting")
 UNINITIALIZED vCPUs
Message-ID: <YVOTYk9aSl72hCmX@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-14-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-14-seanjc@google.com>
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
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

On Fri, Sep 24, 2021 at 05:55:27PM -0700, Sean Christopherson wrote:
> Go directly to kvm_vcpu_block() when handling the case where userspace
> attempts to run an UNINITIALIZED vCPU.  The vCPU isn't halted and its time
> spent in limbo arguably should not be factored into halt-polling as the
> behavior of the VM at this point is not at all indicative of the behavior
> of the VM once it is up and running, i.e. executing HLT in idle tasks.
> 
> Note, because this case is encountered only on the first run of an AP vCPU,
> vcpu->halt_poll_ns is guaranteed to be '0', and so KVM will not attempt
> halt-polling, i.e. this really only affects the post-block bookkeeping.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0d71c73a61bb..b444f9315766 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10127,7 +10127,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  			r = -EINTR;
>  			goto out;
>  		}
> -		kvm_vcpu_halt(vcpu);
> +		kvm_vcpu_block(vcpu);
>  		if (kvm_apic_accept_events(vcpu) < 0) {
>  			r = 0;
>  			goto out;
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
