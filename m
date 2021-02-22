Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3E5C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 14:49:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E23564E58
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 14:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E23564E58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0904B0D6;
	Tue, 23 Feb 2021 09:49:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 65-2QZ2CpUSr; Tue, 23 Feb 2021 09:49:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B72DB4B1D4;
	Tue, 23 Feb 2021 09:49:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2AB54B159
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 11:25:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kc5idE7keD8R for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2021 11:25:00 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3AE14B14E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 11:25:00 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id b15so4371251pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 08:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=K8Mk8DPpk11B6V3YwuQN3+iAtbjKIINrpZOMJr9ijMU=;
 b=ZkL+DPyOhtNNe7hZI9CaKbe4ebR0w/c08TMwcW6jEWxnEH8r794ZleXZWoZ/UR0m9l
 /JvwszOIsqxGcoQusTcqqjnSjevmzjijIqmibZWhNlf1fAH+fqB2XaC9yYLNGSgQajKW
 cQ37mvXb34+aOOxfrJiSDd0duyNERIQhiKqe1mF+9oUWIOq5QI43wZI8wjHcqYbkkeNz
 F74iB1b0pF2iLrhK6gzgmonIkdXMBmp9UGOP+w4UrVRBbDRpQmc5IjIAIQwXpNnoKanf
 hCRm8lc+Mszq2AP9WNUUdxblVMsJd9jJlh10sSOCswStuXopFHTvKoZcecsf/gsAVlr3
 E8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=K8Mk8DPpk11B6V3YwuQN3+iAtbjKIINrpZOMJr9ijMU=;
 b=VE9IQdFUvYe/JFTSNGJpbzHXOwvRGCDIuwNeLjoWEQY3944k1PqdIwdNebgDF34FIx
 k5b4AuCBH9uZ633dqQZnM1SApkdGNKK5u4xtdeAFtC0gul6yXYZ8b0WbOXJgwoTe/FFx
 /7jqpW6rCn0C9/ErCkn1RZkqpu/rfEfpyqTxSSqTqMXMebxeQw7EvRd1XmGflCIbiuDG
 5sy5d197JFtes9fhJtnncP9aCI+HEZGEhzYMi1Kjs69mnVUMINONGWKL/bYGXROkSV/a
 LfecwdBZPWAqblVCMPNudTDiV+BU/vfq9XBHUFM8Tzn0n/ND9ENc8I7qtdBU7u/P8KE/
 ZNpg==
X-Gm-Message-State: AOAM531G4d2OxkcUCr2gkleZycJ3GjEcpzNQGs9AA7xL7bdwqcYD6Gvt
 Gm9WMd35qniiJqWDPCGOSKHoyA==
X-Google-Smtp-Source: ABdhPJzpaRZ20ovy1dpVfBdxXc3ZVF23iR3XDePJsjQUoeSVBm8Osbw6p/Oa6Rqwlvu7+JfquMJWyQ==
X-Received: by 2002:a17:903:1d0:b029:df:d098:f1cb with SMTP id
 e16-20020a17090301d0b02900dfd098f1cbmr23104083plh.49.1614011099559; 
 Mon, 22 Feb 2021 08:24:59 -0800 (PST)
Received: from google.com ([2620:15c:f:10:655e:415b:3b95:bd58])
 by smtp.gmail.com with ESMTPSA id f2sm21929378pfk.63.2021.02.22.08.24.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Feb 2021 08:24:58 -0800 (PST)
Date: Mon, 22 Feb 2021 08:24:51 -0800
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v4 2/2] KVM: x86/mmu: Consider the hva in mmu_notifier
 retry
Message-ID: <YDPa07i3S3Y7/iwy@google.com>
References: <20210222024522.1751719-1-stevensd@google.com>
 <20210222024522.1751719-3-stevensd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210222024522.1751719-3-stevensd@google.com>
X-Mailman-Approved-At: Tue, 23 Feb 2021 09:49:10 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
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

On Mon, Feb 22, 2021, David Stevens wrote:
> ---
> v3 -> v4:
>  - Skip prefetch while invalidations are in progress

Oof, nice catch.

...

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9ac0a727015d..f6aaac729667 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2758,6 +2758,13 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
>  	if (sp->role.level > PG_LEVEL_4K)
>  		return;
>  
> +	/*
> +	 * If addresses are being invalidated, skip prefetching to avoid
> +	 * accidentally prefetching those addresses.
> +	 */
> +	if (unlikely(vcpu->kvm->mmu_notifier_count))
> +		return;

FNAME(pte_prefetch) needs the same check.

Paolo, this brings up a good addition for the work to integrate the mmu notifier
into the rest of KVM, e.g. for vmcs12 pages.  Ideally, gfn_to_page_many_atomic()
and __gfn_to_pfn_memslot() would WARN if mmu_notifier_count is non-zero, but
that will fire all over the place until the nested code properly integrates the
notifier.  There are a few use cases where racing with the notifier is acceptable,
e.g. reexecute_instruction(), but hopefully we can address those flows without
things getting too ugly.

> +
>  	__direct_pte_prefetch(vcpu, sp, sptep);
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
