Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30C9C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:57:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 045AF619BD
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 045AF619BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA0B4B373;
	Wed, 31 Mar 2021 03:57:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IeoeoGbQgOK8; Wed, 31 Mar 2021 03:57:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3275F4B3CE;
	Wed, 31 Mar 2021 03:57:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FF664B3A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EV3yj5+NWQbo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 03:57:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44EAB4B373
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:57:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617177446;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QzUhMnMU3zQi7kbLUex8emke2jBdKMAGI8Tet8F4dtw=;
 b=Lv82hY6rJw7tyNyg2cK0p8g3vYcqXAbAE9lnQB4c4HBqTPVQ3B750bSkkwXeQa0nYG2S2k
 jahKJwB11U2KmgzO5hjmm3OdzDRMpVTgR59zXi4Q0tUwqqGJQqc2Y3RFAjZQOeLGDtKKoP
 chRnYogT1Vak/I/Nl/FcYA3CJ3S/V3g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-3MjPIvV2PTaRLbsdPnPCsA-1; Wed, 31 Mar 2021 03:57:22 -0400
X-MC-Unique: 3MjPIvV2PTaRLbsdPnPCsA-1
Received: by mail-wr1-f69.google.com with SMTP id h5so562457wrr.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 00:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=QzUhMnMU3zQi7kbLUex8emke2jBdKMAGI8Tet8F4dtw=;
 b=qP1Q9Ajsscb4IFO6/t4iLFqEP/46d+NZxccqlgWt5IYzxest8wFbsMJEvpWBP0ouUF
 n/kmA4iV2LV/2AkLPsq91TuBuTvSWtpfBUes0GuLZUE8pEnUeg5zoCxNr6t/TxiX7m9I
 NabgDQw7bfX4SgtZ/zimgKXUsoBlWdSFWJiT5aIsBdXZfYJVfCrnVtwwL6OMF5powuT4
 BAtOdX0OMJ08OLqeeC7g/Ur5Ej81SYHjrC67FT6An4PCp0d5DAAkjouY15ZiJNA89vhG
 Vj20ZChUAfZYw+EoMrDoSbsH5xoygiYAV5oclYOBBamU19wgyghMYQ1JzeFsaq4zVw5b
 /cHA==
X-Gm-Message-State: AOAM532u4RfTnQC9poOHpdbfB1iq+Fm4laM3qXnWvZ6b8L39ukilaML/
 gkpmUwqetFZAh90SO13TUVnlDa/IEk2GmGKflpFas2XeXtxOYNYmqbtapfG4QELeVghya8xpw/D
 ZvB5Frfy2gUaYO1RfxFaGvDg8
X-Received: by 2002:a05:600c:190a:: with SMTP id
 j10mr1935797wmq.140.1617177441068; 
 Wed, 31 Mar 2021 00:57:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyg+EcdGfruRX3HrpM78c15MOqjXD+Pq6QPq9lrCE+nNtYrHVJVg0glnjf7PSn4UemOs7R8Kw==
X-Received: by 2002:a05:600c:190a:: with SMTP id
 j10mr1935760wmq.140.1617177440807; 
 Wed, 31 Mar 2021 00:57:20 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
 by smtp.gmail.com with ESMTPSA id b65sm2631515wmh.4.2021.03.31.00.57.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 00:57:19 -0700 (PDT)
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210326021957.1424875-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2ca8cb2-5c91-b971-9b6e-65cf9ee97ffa@redhat.com>
Date: Wed, 31 Mar 2021 09:57:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
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
> The end goal of this series is to optimize the MMU notifiers to take
> mmu_lock if and only if the notification is relevant to KVM, i.e. the hva
> range overlaps a memslot.   Large VMs (hundreds of vCPUs) are very
> sensitive to mmu_lock being taken for write at inopportune times, and
> such VMs also tend to be "static", e.g. backed by HugeTLB with minimal
> page shenanigans.  The vast majority of notifications for these VMs will
> be spurious (for KVM), and eliding mmu_lock for spurious notifications
> avoids an otherwise unacceptable disruption to the guest.
> 
> To get there without potentially degrading performance, e.g. due to
> multiple memslot lookups, especially on non-x86 where the use cases are
> largely unknown (from my perspective), first consolidate the MMU notifier
> logic by moving the hva->gfn lookups into common KVM.
> 
> Applies on my TDP MMU TLB flushing bug fixes[*], which conflict horribly
> with the TDP MMU changes in this series.  That code applies on kvm/queue
> (commit 4a98623d5d90, "KVM: x86/mmu: Mark the PAE roots as decrypted for
> shadow paging").
> 
> Speaking of conflicts, Ben will soon be posting a series to convert a
> bunch of TDP MMU flows to take mmu_lock only for read.  Presumably there
> will be an absurd number of conflicts; Ben and I will sort out the
> conflicts in whichever series loses the race.
> 
> Well tested on Intel and AMD.  Compile tested for arm64, MIPS, PPC,
> PPC e500, and s390.  Absolutely needs to be tested for real on non-x86,
> I give it even odds that I introduced an off-by-one bug somewhere.
> 
> [*] https://lkml.kernel.org/r/20210325200119.1359384-1-seanjc@google.com
> 
> 
> Patches 1-7 are x86 specific prep patches to play nice with moving
> the hva->gfn memslot lookups into common code.  There ended up being waaay
> more of these than I expected/wanted, but I had a hell of a time getting
> the flushing logic right when shuffling the memslot and address space
> loops.  In the end, I was more confident I got things correct by batching
> the flushes.
> 
> Patch 8 moves the existing API prototypes into common code.  It could
> technically be dropped since the old APIs are gone in the end, but I
> thought the switch to the new APIs would suck a bit less this way.
> 
> Patch 9 moves arm64's MMU notifier tracepoints into common code so that
> they are not lost when arm64 is converted to the new APIs, and so that all
> architectures can benefit.
> 
> Patch 10 moves x86's memslot walkers into common KVM.  I chose x86 purely
> because I could actually test it.  All architectures use nearly identical
> code, so I don't think it actually matters in the end.
> 
> Patches 11-13 move arm64, MIPS, and PPC to the new APIs.
> 
> Patch 14 yanks out the old APIs.
> 
> Patch 15 adds the mmu_lock elision, but only for unpaired notifications.
> 
> Patch 16 adds mmu_lock elision for paired .invalidate_range_{start,end}().
> This is quite nasty and no small part of me thinks the patch should be
> burned with fire (I won't spoil it any further), but it's also the most
> problematic scenario for our particular use case.  :-/
> 
> Patches 17-18 are additional x86 cleanups.

Queued and 1-9 and 18, thanks.  There's a small issue in patch 10 that 
prevented me from committing 10-15, but they mostly look good.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
