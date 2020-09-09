Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F07C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 15:20:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A650F20C09
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 15:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JCm0NzJu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A650F20C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F072A4B5F8;
	Wed,  9 Sep 2020 11:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oCbjl5dUh8Ir; Wed,  9 Sep 2020 11:20:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E68674B343;
	Wed,  9 Sep 2020 11:20:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33C8D4B2F3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 11:20:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oJ2dTo-pa3kh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 11:20:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE144B2EE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 11:20:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599664836;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nYNO+AKEPgBW6vTBqHGF1fYVln/0uSeBDRwExSc81XY=;
 b=JCm0NzJuq/7qiguisi4BkcVIPeOFfvfeCKnyEnrzL0B/c3FwMIQMPGB4oJTZN1Le7xnymY
 XfgdbgwXMxYVdPS/fBb9NBr/1Y64jT5eRZ+jjU9M9kaSIglCQbUiy1kPh0WWsMocfCG4G7
 gt7UVJngxDIDnvBYCZcWaH9KiTcrhQM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-LaJ_gEjjPEC2RkHdROfJFw-1; Wed, 09 Sep 2020 11:20:34 -0400
X-MC-Unique: LaJ_gEjjPEC2RkHdROfJFw-1
Received: by mail-ej1-f72.google.com with SMTP id gt18so1429092ejb.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2020 08:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=nYNO+AKEPgBW6vTBqHGF1fYVln/0uSeBDRwExSc81XY=;
 b=aoRqnaI0EnlrU976RsSHW5fzHqqLkiH32vZ/KUjaHGtS5pXb59gwS7PVuQ2ct8oIOB
 LeehPAnCOFYiN6oaXYePuPzPjgMWQN5FR99IugAvIDRrc1KWh/4kZPLSOT0H369vrwS2
 LDhl9oAElUJjycVQFVkOtCUPIz8JUYp0tE87b0gWUY5UkqJp+nS6PAO6pREK2FTOFHhm
 w2yD/h3/QiATk36tpKmnHB5lIu5MhQJ84ll0jolqWCm3s6PmlM0yvu8bwm169Tzjg/1J
 U2wVfKJpAMvBjhfBczJvtn7TptcwMf+gmgtBYLHY7rKn4MqASCo62Lssib0pChPI8T+y
 d0tw==
X-Gm-Message-State: AOAM530d0eFaZuvdASz6St+YjJD9FI1GPiJ8Ned726qR8kxSo840lteB
 5vDKHoTdxGOV/7l+JjQn0XhsosFJfk5qTZOEVR20srSNDLMcq0yyikjZKLknUhUObu0y+sc3tBo
 httmfc+EwRz2TkCtHeyhFz8rw
X-Received: by 2002:aa7:c1c3:: with SMTP id d3mr4712084edp.228.1599664832317; 
 Wed, 09 Sep 2020 08:20:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/buxcR3k3TYh22ywGq6QmpgD+APHFSZ/u2IydDFW2LmR/OY3181D7GwPj31tu14P28jmFEw==
X-Received: by 2002:aa7:c1c3:: with SMTP id d3mr4712059edp.228.1599664832099; 
 Wed, 09 Sep 2020 08:20:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4025:be55:3943:81a0?
 ([2001:b07:6468:f312:4025:be55:3943:81a0])
 by smtp.gmail.com with ESMTPSA id b10sm2399995eje.65.2020.09.09.08.20.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Sep 2020 08:20:31 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.9
To: Marc Zyngier <maz@kernel.org>
References: <20200904104530.1082676-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7afbf0f-2e14-2720-5d23-2cd01982e4d1@redhat.com>
Date: Wed, 9 Sep 2020 17:20:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 04/09/20 12:45, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's a bunch of fixes for 5.9. The gist of it is the stolen time
> rework from Andrew, but we also have a couple of MM fixes that have
> surfaced as people have started to use hugetlbfs in anger.

Hi Marc,

I'll get to this next Friday.

Paolo

> Please pull,
> 
> 	M.
> 
> The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:
> 
>   Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.9-1
> 
> for you to fetch changes up to 7b75cd5128421c673153efb1236705696a1a9812:
> 
>   KVM: arm64: Update page shift if stage 2 block mapping not supported (2020-09-04 10:53:48 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for Linux 5.9, take #1
> 
> - Multiple stolen time fixes, with a new capability to match x86
> - Fix for hugetlbfs mappings when PUD and PMD are the same level
> - Fix for hugetlbfs mappings when PTE mappings are enforced
>   (dirty logging, for example)
> - Fix tracing output of 64bit values
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>       KVM: arm64: Update page shift if stage 2 block mapping not supported
> 
> Andrew Jones (6):
>       KVM: arm64: pvtime: steal-time is only supported when configured
>       KVM: arm64: pvtime: Fix potential loss of stolen time
>       KVM: arm64: Drop type input from kvm_put_guest
>       KVM: arm64: pvtime: Fix stolen time accounting across migration
>       KVM: Documentation: Minor fixups
>       arm64/x86: KVM: Introduce steal-time cap
> 
> Marc Zyngier (2):
>       KVM: arm64: Do not try to map PUDs when they are folded into PMD
>       KVM: arm64: Fix address truncation in traces
> 
>  Documentation/virt/kvm/api.rst     | 22 ++++++++++++++++++----
>  arch/arm64/include/asm/kvm_host.h  |  2 +-
>  arch/arm64/kvm/arm.c               |  3 +++
>  arch/arm64/kvm/mmu.c               |  8 +++++++-
>  arch/arm64/kvm/pvtime.c            | 29 +++++++++++++----------------
>  arch/arm64/kvm/trace_arm.h         | 16 ++++++++--------
>  arch/arm64/kvm/trace_handle_exit.h |  6 +++---
>  arch/x86/kvm/x86.c                 |  3 +++
>  include/linux/kvm_host.h           | 31 ++++++++++++++++++++++++++-----
>  include/uapi/linux/kvm.h           |  1 +
>  10 files changed, 83 insertions(+), 38 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
