Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5789C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BA0A6137E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7BA0A6137E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A214B0F1;
	Wed, 29 Sep 2021 03:12:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1FfJSIqNuXtK; Wed, 29 Sep 2021 03:12:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 024604B15E;
	Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 779994048A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:08:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id URRBhaZWcfax for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 18:08:38 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BB3640191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:08:38 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id w19so185787pfn.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 15:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=7rZGZtXj4Kjef8XTrbQn+IEWHZmecIVKI32pSog3bGg=;
 b=Gu0/C+e+W8WPTJ9kWJuQrZyoELFPICJgw72WckzL3ovfDopNe/Y4j2IPagVtUNhWwr
 9Qjfpn7SXH4wDFaqEdg5HJLXeLxphcPK9HcAugMDnWCpp68Xe6/ys1kzGwvSk+KcGCM4
 H64DJ7Tp5uRS7wp3aWTm1GhwRjDkRVaP2QPSIltqiZGDJzmU5Y11dt/buGH/9lHZ3SWJ
 bNi0rTAatQvQMs/Fb32BQ7aRL6utqOVWshzHxUOyBU70FP8VoWG62/RzZsJ4kBiRc9ua
 EQxp57U7HkBAHrtePs5fCEn33r7qnlM/POKA5AQ8Js4rYnMiBHo1lKgjrUm4AiUxx6TO
 BFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7rZGZtXj4Kjef8XTrbQn+IEWHZmecIVKI32pSog3bGg=;
 b=gwjDO9wXllbwRiNwCW2EvnCXuQLRNbrK4cs72kb0ulyFY8KOJJdUB7nhGAGBnmyHth
 lsvanqmNwBLmiFGgbRg3sr9eC6lSPuN8oQbbrOwKjAGnXE6MwE9TdSXNrv0y6HJSO3o6
 eyUdgIEck2MCZ2VC8LvNdyBPkCZ4OMuYCAx4bvJUCu7tCY64bhI0X3yZ78CCpFJqrWhi
 wQ8fIvedTiFPyCuviEekzLvzuYVuBmgiyy/0SrNj0ttSgYlpCmqVxjsQaDK0TUc4Ylem
 HFLIAFn5ePMHPQYwhfwS2cUGYZW/SMB1llap7lmx3Aj6dB4CbtOhNN7ATrH+ZDngsIky
 nNFA==
X-Gm-Message-State: AOAM5301BQx6I/MIja5QGr8yyJdnso0HD5A1O0Kt6KnCITqJRFLCgsXC
 OH0lFT36jcXmh6TPSAHwZBca9Q==
X-Google-Smtp-Source: ABdhPJzadyVUO8UyxBHsA0YYc+iUIbEvRB9U2t+kYPdczvOjLMgOq7SgcZR4mYDt3YnbOWn2xcwTMQ==
X-Received: by 2002:a05:6a00:26cc:b0:440:51c6:fa38 with SMTP id
 p12-20020a056a0026cc00b0044051c6fa38mr7862566pfw.45.1632866917363; 
 Tue, 28 Sep 2021 15:08:37 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id v6sm132638pfv.83.2021.09.28.15.08.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 15:08:36 -0700 (PDT)
Date: Tue, 28 Sep 2021 22:08:33 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 12/14] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
Message-ID: <YVOSYaNx0vd4SYHk@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-13-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-13-seanjc@google.com>
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

On Fri, Sep 24, 2021 at 05:55:26PM -0700, Sean Christopherson wrote:
> Calculate the halt-polling "stop" time using "cur" instead of redoing
> ktime_get().  In the happy case where hardware correctly predicts
> do_halt_poll, "cur" is only a few cycles old.  And if the branch is
> mispredicted, arguably that extra latency should count toward the
> halt-polling time.
> 
> In all likelihood, the numbers involved are in the noise and either
> approach is perfectly ok.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2980d2b88559..80f78daa6b8d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3267,7 +3267,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  
>  	start = cur = poll_end = ktime_get();
>  	if (do_halt_poll) {
> -		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> +		ktime_t stop = ktime_add_ns(cur, vcpu->halt_poll_ns);
>  
>  		do {
>  			/*
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
