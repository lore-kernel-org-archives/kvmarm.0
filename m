Return-Path: <SRS0=An/p=IE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E483C433E0
	for <kvmarm@archiver.kernel.org>; Sat,  6 Mar 2021 09:50:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C45C56501B
	for <kvmarm@archiver.kernel.org>; Sat,  6 Mar 2021 09:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C45C56501B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF434B1FD;
	Sat,  6 Mar 2021 04:50:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pz5kC7pJvG+R; Sat,  6 Mar 2021 04:50:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32B624B2BE;
	Sat,  6 Mar 2021 04:50:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B87FC4B2BE
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Mar 2021 04:50:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M6Jrb28yXSUO for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Mar 2021 04:50:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2054B1FD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Mar 2021 04:50:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615024211;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wtTBL6IGeyh8BSRigo0CKkYcexJFfp/4IWRWxSSwnCI=;
 b=QtOWawbr4A6wv8MGCzBcc8LOzR67GhqTNCFmUihaiK0FL7rLoXpuA0dVbXutc5dk1Q2k8S
 FK+ooVQ0qSyGuKnU+aQDf+y9wc6sNjbBhdTar+/RurVY/jH42Qs4kVAboUEGoGJlU+fwzl
 2Mn0pF9NGbR07mJL8/bybVKUO/4YgPk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-Gdh2Z0kBMym0m2O26jqNkw-1; Sat, 06 Mar 2021 04:50:06 -0500
X-MC-Unique: Gdh2Z0kBMym0m2O26jqNkw-1
Received: by mail-wr1-f71.google.com with SMTP id h21so2270693wrc.19
 for <kvmarm@lists.cs.columbia.edu>; Sat, 06 Mar 2021 01:50:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wtTBL6IGeyh8BSRigo0CKkYcexJFfp/4IWRWxSSwnCI=;
 b=t9FoiDLLusKZhTSZDKxU3d5gVvWKVC0x3FrHCbwTbdo8XqHxlJQscLdelJxA3T51hh
 xTEWFAmex4sh6iJnnBbxOGRHaFIgjCPs0PU42YlhXBYWIenJvDGJd7vstwFUpQHIZr94
 f0xjqX2B3duqtp/+l9y2FT59NcK1ejvTo2t22bEIEK9dnbWRzjbMoVozvkJVmgf9VLZZ
 ww4U4lpe1Vst/QHg+TMoWmUE795KwvEbZMUqukidkLbYuDUx4YN/hb2t5YseHi1Ik1nI
 oXXeUl8IFMBVHz/8dnTHQXUqgY/mRkTfDzf7YZFJZ9fYf3XNo09ct2BzkyOTMHTsGz0T
 FYbg==
X-Gm-Message-State: AOAM530exaHDZsn8ZbMre63ybxTQb7vKgTV84hTrFGQzZ73/sGmOA2zt
 NSee1z3AmQkyRn3HQUJnBGCR/f0r/FzYL/B2JU7bWiwYn/aaciZkZKfP3yZI4+pObb20hDJkc38
 601GfiWHDiegS160OEVctRtpG
X-Received: by 2002:a05:600c:2312:: with SMTP id
 18mr12896201wmo.8.1615024205663; 
 Sat, 06 Mar 2021 01:50:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8afe+cwtYmFye2D6e0melYZ9I5pdVrhkTg5wC3o1VvGnf0tHz47eDy06nGS/FpuI4hTDltw==
X-Received: by 2002:a05:600c:2312:: with SMTP id
 18mr12896177wmo.8.1615024205516; 
 Sat, 06 Mar 2021 01:50:05 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
 by smtp.gmail.com with ESMTPSA id m132sm9079567wmf.45.2021.03.06.01.50.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 06 Mar 2021 01:50:04 -0800 (PST)
Subject: Re: [PATCH 0/8] KVM/arm64 fixes for 5.12, take #1
To: Marc Zyngier <maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a42527e-df78-35ea-4b93-8587effb46cd@redhat.com>
Date: Sat, 6 Mar 2021 10:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Howard Zhang <Howard.Zhang@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 05/03/21 19:52, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the first batch of fixes for 5.12. We have a handful of low
> level world-switch regressions, a page table walker fix, more PMU
> tidying up, and a workaround for systems with creative firmware.
> 
> This will need to go on top of the current state of mainline.

Applied to kvm/next (because kvm/master is also on the problematic 
5.12-rc1 tags), thanks.

Paolo

> Please apply,
> 
> 	M.
> 
> Andrew Scull (1):
>        KVM: arm64: Fix nVHE hyp panic host context restore
> 
> Jia He (1):
>        KVM: arm64: Fix range alignment when walking page tables
> 
> Marc Zyngier (4):
>        KVM: arm64: Turn kvm_arm_support_pmu_v3() into a static key
>        KVM: arm64: Don't access PMSELR_EL0/PMUSERENR_EL0 when no PMU is available
>        KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to __vgic_v3_get_gic_config()
>        KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility
> 
> Suzuki K Poulose (1):
>        KVM: arm64: nvhe: Save the SPE context early
> 
> Will Deacon (1):
>        KVM: arm64: Avoid corrupting vCPU context register in guest exit
> 
>   arch/arm64/include/asm/kvm_asm.h        |  4 ++--
>   arch/arm64/include/asm/kvm_hyp.h        |  8 ++++++-
>   arch/arm64/kernel/image-vars.h          |  3 +++
>   arch/arm64/kvm/hyp/entry.S              |  2 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h |  9 +++++---
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c      | 12 ++++++++--
>   arch/arm64/kvm/hyp/nvhe/host.S          | 15 +++++++------
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 ++---
>   arch/arm64/kvm/hyp/nvhe/switch.c        | 14 +++++++++---
>   arch/arm64/kvm/hyp/pgtable.c            |  1 +
>   arch/arm64/kvm/hyp/vgic-v3-sr.c         | 40 +++++++++++++++++++++++++++++++--
>   arch/arm64/kvm/perf.c                   | 10 +++++++++
>   arch/arm64/kvm/pmu-emul.c               | 10 ---------
>   arch/arm64/kvm/vgic/vgic-v3.c           | 12 +++++++---
>   include/kvm/arm_pmu.h                   |  9 ++++++--
>   15 files changed, 116 insertions(+), 39 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
