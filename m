Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C029C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 06:31:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC39E2067C
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 06:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJ0wgOAW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC39E2067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49C104BF17;
	Tue, 18 Aug 2020 02:31:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CP3iLSjIc9Tl; Tue, 18 Aug 2020 02:31:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F4FD4BF61;
	Tue, 18 Aug 2020 02:31:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2C594BF3A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 02:31:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8yFzCsY-Mlm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Aug 2020 02:31:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3DE74BF17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 02:31:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597732277;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KmRLPfSWkEBQgpTHY9W7Qe7QZ1EnQbdh33fVf10hkAI=;
 b=SJ0wgOAWfqr0THi9W8yx22QaiFL2LOCHrYyO7wYaFCNDeNW2+qOrtqxYW20xNWpRjsX9gL
 1WKNay3DIiAl9eJ0YBuLLmsjJ28BRQzYzhe1A/F9embVPYnuwV/vhFQ8wAXiwWd4PeVPga
 tvDms7vQVrQYZhRc3Z+i1wpKZY7GfHI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-zNcUrNTzPQe_-0idY2cxyw-1; Tue, 18 Aug 2020 02:31:11 -0400
X-MC-Unique: zNcUrNTzPQe_-0idY2cxyw-1
Received: by mail-wr1-f70.google.com with SMTP id b18so7844243wrn.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 23:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=KmRLPfSWkEBQgpTHY9W7Qe7QZ1EnQbdh33fVf10hkAI=;
 b=k5l2Y1oRBm9sPnChi/6MNbbjGZuXgsYAIKmZOAMfH29gW17Jj+H+pBEkMNIq0f1qDD
 4PYG4D98OUothAj6jxiclMjjCu294frJ7X+RWzI1b/6ITkFTWsUzMrolQVOSdOS1zVLU
 bn9ICuMY4u6ocy9bsg38WNtTdXoCmPJGaETWXQzX73gOKICKQJrtL+ma2qekj+Q1Zkyl
 m/Yx7M1/o+tJ8n4wz1By8xWf3MWVyggjkId1xRfgVjEJQA3Jc/Wd3YOuTdDGFMyCoyBL
 VQmXZwNJXwL4e+1Gm0hVdwq0xIh7wfQA+C9xY4Yaur6MWOLJhwbzKOAfZRpIlHXgKFf8
 eD/Q==
X-Gm-Message-State: AOAM532dGVwkqSKrU2iYBSVY5NDbnqdi+T1pAaXlYZo6wrThXMsLKiE5
 AIJZhavlItHeXroF7BqBGL0NJ5ANGG/2p2CdfoC1zfrEsEIN8PRWWgjYZ0s1EXs+iKkL0vlYjbL
 NYWR2gUG3n5/7WeuUQtGB3sTd
X-Received: by 2002:adf:df89:: with SMTP id z9mr18730291wrl.395.1597732270032; 
 Mon, 17 Aug 2020 23:31:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPB8f/uccX694hKHkN5+J5pWk6Dx0FQTiyjeONl3Wl6YBHXs3vqZafBJ+p7LBVG4M6e7mTNA==
X-Received: by 2002:adf:df89:: with SMTP id z9mr18730262wrl.395.1597732269719; 
 Mon, 17 Aug 2020 23:31:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977?
 ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
 by smtp.gmail.com with ESMTPSA id b203sm32630286wmc.22.2020.08.17.23.31.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 17 Aug 2020 23:31:08 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: arm64: Fix sleeping while atomic BUG() on OOM
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200811102725.7121-1-will@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff1d4de2-f3f8-eafa-6ba5-3e5bb715ae05@redhat.com>
Date: Tue, 18 Aug 2020 08:31:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200811102725.7121-1-will@kernel.org>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Marc Zyngier <maz@kernel.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>
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

On 11/08/20 12:27, Will Deacon wrote:
> Hi all,
> 
> While stress-testing my arm64 stage-2 page-table rewrite [1], I ran into
> a sleeping while atomic BUG() during OOM that I can reproduce with
> mainline.
> 
> The problem is that the arm64 page-table code periodically calls
> cond_resched_lock() when unmapping the stage-2 page-tables, but in the
> case of OOM, this occurs in atomic context.
> 
> These couple of patches (based on 5.8) propagate the flags from the MMU
> notifier range structure, which in turn indicate whether or not blocking
> is permitted.
> 
> Cheers,
> 
> Will
> 
> [1] https://android-kvm.googlesource.com/linux/+/refs/heads/topic/pgtable
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> --->8
> 
> Will Deacon (2):
>   KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
>   KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set
> 
>  arch/arm64/include/asm/kvm_host.h   |  2 +-
>  arch/arm64/kvm/mmu.c                | 19 ++++++++++++++-----
>  arch/mips/include/asm/kvm_host.h    |  2 +-
>  arch/mips/kvm/mmu.c                 |  3 ++-
>  arch/powerpc/include/asm/kvm_host.h |  3 ++-
>  arch/powerpc/kvm/book3s.c           |  3 ++-
>  arch/powerpc/kvm/e500_mmu_host.c    |  3 ++-
>  arch/x86/include/asm/kvm_host.h     |  3 ++-
>  arch/x86/kvm/mmu/mmu.c              |  3 ++-
>  virt/kvm/kvm_main.c                 |  3 ++-
>  10 files changed, 30 insertions(+), 14 deletions(-)
> 

These would be okay for 5.9 too, so I plan to queue them myself before
we fork for 5.10.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
