Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30488C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D55B66137A
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D55B66137A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D594B104;
	Wed, 29 Sep 2021 03:12:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CdUP2+XU93Ik; Wed, 29 Sep 2021 03:12:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A424B168;
	Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B63804057F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yq9jGgNkqx1q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 18:14:59 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3E724031F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:14:59 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id g184so545401pgc.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 15:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=oDTEp4uXq7wouuQuWuPnWVQXCIo6P8LpvQajseAha48=;
 b=BnufAkDaSqbvE0tuVagV8WXp+XHOA8rRfAQGH7v7vq47FtDaVwPb2gV3pg84col7Jn
 wiWxSJtOhRHOZ1OnBfK1IusCBeqHNprdHmkCTk9hwy1TjpFLJ2o37qhbCK64RU58wR+/
 NVNuIOjncjEgaNz1Aji8RAKlyT10kUNAthNYDNVDkepM7EAAeST1QgAUJgZz9JV6W8pQ
 Ga3dyZRVb1TCTPcNFYt7tNYB7fChJLmzpTPIY1149VIXRC09i0vUfJF6BV+ql+c0RWWW
 CLk/XS24h5X+HgfBHwpw+x6pOo0ByCwKeOnP2OHqWK6fByzx9dwNkhyWHGw0eQ1hWxHI
 bubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oDTEp4uXq7wouuQuWuPnWVQXCIo6P8LpvQajseAha48=;
 b=6jZVPd33LSUu10e/XGZx0EohYlPwK/PRmcjnd3XCGCMwzS7tMB51j179RReFZzNHeh
 N4kFB6s7t2pcqL9VvJkAfMWK0/2PhQDrZEZ0ZXsRWf/Ft2AsE98qyyfy9ygNwsO3dSQx
 N1iK8BLNMl3fWZEqf8yfTaZ2Cp7t28Llau38KvETfUn7eKmRyg6grdg0Uh0E3kjfN1dX
 mvByf2H6QgEwQoa5Ldo292rwmfDRz/yAcRqhLJlaI2rfGUq4Zojdcbm58FclpIV4YDDW
 4D+Bb/EKU4ezfOKtfB1aXPynhxDoCRaaFh/i0X8kNKSs5dbnvxoBBPuJpWzDcY5Id/St
 PuHw==
X-Gm-Message-State: AOAM530mmSL2u9WIMB0p5Ve1u6ca8E7u/NegUYONT2t2T071mdidxUwj
 rj2jOBS2YPd8MiuHAm/WHdSuTA==
X-Google-Smtp-Source: ABdhPJxBJllV/6MHwH/O4bupLMykTY/L8aml4vOWRLyRzjZbQcPh2xbpVAvFMm0QwWZGt6UvJ4KliA==
X-Received: by 2002:a62:dd0a:0:b0:44b:bd85:9387 with SMTP id
 w10-20020a62dd0a000000b0044bbd859387mr2015835pff.49.1632867298411; 
 Tue, 28 Sep 2021 15:14:58 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id d7sm142548pfq.43.2021.09.28.15.14.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 15:14:57 -0700 (PDT)
Date: Tue, 28 Sep 2021 22:14:54 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 14/14] KVM: x86: Invoke kvm_vcpu_block() directly for
 non-HALTED wait states
Message-ID: <YVOT3gj1ulBTNSw3@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-15-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-15-seanjc@google.com>
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

On Fri, Sep 24, 2021 at 05:55:28PM -0700, Sean Christopherson wrote:
> Call kvm_vcpu_block() directly for all wait states except HALTED so that
> kvm_vcpu_halt() is no longer a misnomer on x86.
> 
> Functionally, this means KVM will never attempt halt-polling or adjust
> vcpu->halt_poll_ns for INIT_RECEIVED (a.k.a. Wait-For-SIPI (WFS)) or
> AP_RESET_HOLD; UNINITIALIZED is handled in kvm_arch_vcpu_ioctl_run(),
> and x86 doesn't use any other "wait" states.
> 
> As mentioned above, the motivation of this is purely so that "halt" isn't
> overloaded on x86, e.g. in KVM's stats.  Skipping halt-polling for WFS
> (and RESET_HOLD) has no meaningful effect on guest performance as there
> are typically single-digit numbers of INIT-SIPI sequences per AP vCPU,
> per boot, versus thousands of HLTs just to boot to console.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/x86.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b444f9315766..a0f313c4bc49 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9893,7 +9893,10 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  	if (!kvm_arch_vcpu_runnable(vcpu) &&
>  	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
>  		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> -		kvm_vcpu_halt(vcpu);
> +		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
> +			kvm_vcpu_halt(vcpu);
> +		else
> +			kvm_vcpu_block(vcpu);
>  		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  
>  		if (kvm_x86_ops.post_block)
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
