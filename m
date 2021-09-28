Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B034BC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 288FC613C8
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 288FC613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 672D24B174;
	Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GUI4gwsNngfg; Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26D554B129;
	Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 258764B101
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:57:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W6uXycousGb6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:57:54 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2B9E4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:57:53 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id g184so70618pgc.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hbmr+iwzxjrwsm+tEChOCbQhDq6UlfLy+47j+9ocUio=;
 b=LIUKsJb5csfGXRweUbuDpDidwcU5eWp7I/BC8UyxJljOvp53d1+D8/lVafchjWnTQ0
 UFJ3m7MEw7wR7ZRxd8ACwxPZ0m52bD6vj7TVNWZMtZNMTJOZwlD3eAWWyH1Qjhl43L3U
 W1FytngggVEVCnX/gF5j3GcAVm16wdtULlRYpFUEUDEjCyafanTtEjpuUFGcRp39K4zP
 8bcEH690dj17b/WyNjFuFNPEP5hGpR8USgdsDcq9O2S4cVlCSktUAxA777RgXT/lt+Vv
 Bzig6jNqwzLE2GfeCQZTnW8FZN7tYmEiOfv/wCyJ4cPc56oImH3Qexl4IlFXY6fcK+dx
 1HLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hbmr+iwzxjrwsm+tEChOCbQhDq6UlfLy+47j+9ocUio=;
 b=ryzhm+tG7N8adzPxJHGtb44az0idwWjRzdKJv0wuagr8rbM9lNSblIi4UZuWX3P4wF
 Pqz55qnxVkvNA96RQvIGjhx7GakDpQezFNvmpGl4xeQmNWY8tMsl6A+hOzdHM+bjisJ9
 Z/V1Fng3xwsQ8+auQ9rkmrRv3VTXOjq8eFLIKrWR7USMxVhIf+UUELc+K8iCqLb2U143
 qMMbB+AVIn+a6Yzwz6+PkB8j+MEfswDvmmKSG0QSCRC/etnJEpInk4YU8I+YIsuEnhMU
 0RBtV1AxsR0HoqP8cmjbSqdbkDjNY6z+liduHBq2Cni2u6Ho6DTp1IkFeAzDRHSppH+7
 BGqw==
X-Gm-Message-State: AOAM531RM7jHByyC6lJK6GAqIeiYaFONpG2SyTkPqL7FrRqg+6lTon/O
 y45n5HezxBwaKkxnktlfoFG30Q==
X-Google-Smtp-Source: ABdhPJzvJEVMFLwNuCMQ/B/wkbjy954+2YLM0705uJahpnQn4hlzIhG6+toRk9qgzctw/+QJEMGtgw==
X-Received: by 2002:a62:7ccf:0:b0:444:9264:dbcd with SMTP id
 x198-20020a627ccf000000b004449264dbcdmr7051691pfc.50.1632855472798; 
 Tue, 28 Sep 2021 11:57:52 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id f16sm21088582pfk.110.2021.09.28.11.57.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 11:57:52 -0700 (PDT)
Date: Tue, 28 Sep 2021 18:57:46 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 02/14] KVM: Update halt-polling stats if and only if
 halt-polling was attempted
Message-ID: <YVNlqgEKluDRVGv0@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-3-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-3-seanjc@google.com>
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

On Fri, Sep 24, 2021 at 05:55:16PM -0700, Sean Christopherson wrote:
> Don't update halt-polling stats if halt-polling wasn't attempted.  This
> is a nop as @poll_ns is guaranteed to be '0' (poll_end == start), but it
> will allow a future patch to move the histogram stats into the helper to
> resolve a discrepancy in what is considered a "successful" halt-poll.
> 
> No functional change intended.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 768a4cbb26a6..8b33f5045b4d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3214,6 +3214,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
>  void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  {
>  	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> +	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>  	ktime_t start, cur, poll_end;
>  	bool waited = false;
>  	u64 block_ns;
> @@ -3221,7 +3222,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_blocking(vcpu);
>  
>  	start = cur = poll_end = ktime_get();
> -	if (vcpu->halt_poll_ns && halt_poll_allowed) {
> +	if (do_halt_poll) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
>  
>  		++vcpu->stat.generic.halt_attempted_poll;
> @@ -3273,8 +3274,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
> -	update_halt_poll_stats(
> -		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
> +	if (do_halt_poll)
> +		update_halt_poll_stats(
> +			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
>  
>  	if (halt_poll_allowed) {
>  		if (!vcpu_valid_wakeup(vcpu)) {
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
