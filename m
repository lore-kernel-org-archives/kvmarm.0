Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3175DC433C1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 08:35:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 744E36198A
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 08:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 744E36198A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7584B3EF;
	Wed, 31 Mar 2021 04:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m5Ws8mGJT-2V; Wed, 31 Mar 2021 04:35:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2C504B3E0;
	Wed, 31 Mar 2021 04:35:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BB7E4B3DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 04:35:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yPc2uTF8kEqM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 04:35:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 392DA4B395
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 04:35:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617179740;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mgm8G5pUG1KmGb3in7+y2xmYF44JOnlI4lr2O/Z99Vg=;
 b=H8sUHIZGKT09uO2730bAmBZBHmp4NxN8aS6UmkHDK8fLmH0NnKty2Zbi5rbX4VdOdapDAu
 J7roS4DFnLnzGKel+jGmOCs4dVlUxFVSPqnoKWdvSVIRarmotwEFpvjaL5MV4WLFB03Q7/
 2w9O/SbsOwoFAFGOMtYxmwsfVj7jaT4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-McMvYR53MPOEIRcjmsPFNA-1; Wed, 31 Mar 2021 04:35:38 -0400
X-MC-Unique: McMvYR53MPOEIRcjmsPFNA-1
Received: by mail-wr1-f71.google.com with SMTP id r12so615261wro.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 01:35:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=mgm8G5pUG1KmGb3in7+y2xmYF44JOnlI4lr2O/Z99Vg=;
 b=P6mgN5Onu0m6LtVa5SsQGwHwlc4nCHq6+VEQCh96tUA0PCqAscRr1dVz/jeDi2kxcE
 2xeD1wn1ifHND4ODDx/SVrO2bupjez44nf923A5D1jXkUciIpkicUzOD0Naf/N3gRx5j
 TJ2mg/P8yi47pc4S1Y7ZrN5uC7ggGnrXrxys34FcPMsBTqm/TKjOkURgeBXrpXHPAgVB
 OGaZDREE18xTbc8O6bP+/14vEG/T7li455vgzuJOxva2B3CxMNHBk4A0w2NWtrNsAQhV
 jxsTdBpUuYcIJTp1o/RvRyH3qwgse7M8Um3FAwZcos8GxdFoAjrvV34ep3aPK50zCqDN
 hhcw==
X-Gm-Message-State: AOAM531FnWHEoKr/O+ZGJBCs2wbQRg8jjuEyU0AfNtyJqc/kcfbdS+NE
 EnxpiYfxXFJum0Opa0mG5qMnYX23sx5Ms3GW/ZEnOU63q9jgZuTCC5kc2voGJ61D3DGSMJF97uZ
 pSp7ExxCSEQaOqUidFpxRamWu
X-Received: by 2002:a1c:7fcd:: with SMTP id a196mr2104272wmd.180.1617179736955; 
 Wed, 31 Mar 2021 01:35:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFY4ad6E8SOin2Ll1yPB6Awyjzypf4VdxfkeKjct1tO9FsxKkluxu1V8FPsoliR6ISHwqUjA==
X-Received: by 2002:a1c:7fcd:: with SMTP id a196mr2104245wmd.180.1617179736699; 
 Wed, 31 Mar 2021 01:35:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id a17sm2690084wmj.9.2021.03.31.01.35.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 01:35:35 -0700 (PDT)
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
Date: Wed, 31 Mar 2021 10:35:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-17-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On 26/03/21 03:19, Sean Christopherson wrote:
> +	/*
> +	 * Reset the lock used to prevent memslot updates between MMU notifier
> +	 * range_start and range_end.  At this point no more MMU notifiers will
> +	 * run, but the lock could still be held if KVM's notifier was removed
> +	 * between range_start and range_end.  No threads can be waiting on the
> +	 * lock as the last reference on KVM has been dropped.  If the lock is
> +	 * still held, freeing memslots will deadlock.
> +	 */
> +	init_rwsem(&kvm->mmu_notifier_slots_lock);

I was going to say that this is nasty, then I noticed that 
mmu_notifier_unregister uses SRCU to ensure completion of concurrent 
calls to the MMU notifier.  So I guess it's fine, but it's better to 
point it out:

	/*
	 * At this point no more MMU notifiers will run and pending
	 * calls to range_start have completed, but the lock would
	 * still be held and never released if the MMU notifier was
	 * removed between range_start and range_end.  Since the last
	 * reference to the struct kvm has been dropped, no threads can
	 * be waiting on the lock, but we might still end up taking it
	 * when freeing memslots in kvm_arch_destroy_vm.  Reset the lock
	 * to avoid deadlocks.
	 */

That said, the easiest way to avoid this would be to always update 
mmu_notifier_count.  I don't mind the rwsem, but at least I suggest that 
you split the patch in two---the first one keeping the 
mmu_notifier_count update unconditional, and the second one introducing 
the rwsem and the on_lock function kvm_inc_notifier_count.  Please 
document the new lock in Documentation/virt/kvm/locking.rst too.

Also, related to the first part of the series, perhaps you could 
structure the series in a slightly different way:

1) introduce the HVA walking API in common code, complete with on_lock 
and patch 15, so that you can use on_lock to increase mmu_notifier_seq

2) then migrate all architectures including x86 to the new API

IOW, first half of patch 10 and all of patch 15; then the second half of 
patch 10; then patches 11-14.

> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> +	down_write(&kvm->mmu_notifier_slots_lock);
> +#endif
>  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> +	up_write(&kvm->mmu_notifier_slots_lock);
> +#endif

Please do this unconditionally, the cost is minimal if the rwsem is not 
contended (as is the case if the architecture doesn't use MMU notifiers 
at all).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
