Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53261C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 17:27:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1FD6650A5
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 17:27:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1FD6650A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2006E4B5C6;
	Fri,  5 Mar 2021 12:27:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Zd7Qj3tObUR; Fri,  5 Mar 2021 12:27:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD4B4B594;
	Fri,  5 Mar 2021 12:27:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2600D4B56A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 12:27:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mMHxawV4ZXlX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 12:27:44 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5514B54E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 12:27:44 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1614965263;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bLxB2l1qRKkq52ZoCU3NDR4MPkAT8Rs45+g/2VRl+rw=;
 b=aUPT5RB7+1gNVEYyJZ8WywzUs3l9MMH3fbSZX+PAgHyGEnTcENGEZGUukyB3VvERyWhmN+
 0CDl1M/dF0Myo/Pj9I22Y6ksPj6q2gdMlm8x6DhvKsf8EUWG395q5Fmc6mGgp1rVfeUxcP
 YursdeskdAs09zRNMIF5DaQlWMyuMWE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-AcJL3infN8qroLedBa2JpQ-1; Fri, 05 Mar 2021 12:27:40 -0500
X-MC-Unique: AcJL3infN8qroLedBa2JpQ-1
Received: by mail-wm1-f71.google.com with SMTP id m17so661514wml.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 09:27:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=bLxB2l1qRKkq52ZoCU3NDR4MPkAT8Rs45+g/2VRl+rw=;
 b=fk4OwGuyroFq8JzXhOTxAlpmyCs9vIvFE28mZrLj09NRA0P+sFOaKRQ3ivwwlEdTcK
 //1Oc8iRNuZBCyCB88WBJbK4iw1Mx+DLtuDWLQdZXzthbztxoop8j/zjlljpfltgNFO6
 wP8TszMXCxrdVfWEtLvgCgd7ktvZ9ENqhqkplUj7oluux8RcGE8m3Q+Ebi1sQRhgLGl6
 qYl51PUpYGQdkN4GY1XHX0/DtFfufvp8WNJ2eykpcvrAdxy+YOMBNXfmIkypXZaDO6Tk
 wQULQw6oRDULyufQFdUEZ3pWNcGOXFJZFqnBzd18GFOywN7r85ChQoot5KIg5VwLZDfx
 1Reg==
X-Gm-Message-State: AOAM532CouB9qXraGRAXo9SsCWsGDOuoJ/W4h2KZ19agDkqwOsUHBvP6
 8Xi6S5aaGHaTPslspqPZqOnFlkktb0r6hw6nN7ORFwk2Ngyz1Qrtz6KH+T9q8aug0UfvfV8GaDf
 NUCZPK5AzGdwKSwZ6tqozYQY4
X-Received: by 2002:a5d:63d2:: with SMTP id c18mr10413766wrw.277.1614965258863; 
 Fri, 05 Mar 2021 09:27:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkbOTMiAdDixzDlmyw0o+BrvOtsI4Mh4wmSTXrH0tuUAuSZrSvkdc9LdEhdcKIKd6WWY0CAA==
X-Received: by 2002:a5d:63d2:: with SMTP id c18mr10413736wrw.277.1614965258679; 
 Fri, 05 Mar 2021 09:27:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id n5sm5001272wmq.7.2021.03.05.09.27.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 05 Mar 2021 09:27:37 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.12, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20210305164944.3729910-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <847417af-fdab-9ca1-3edc-39f1d77cb6cb@redhat.com>
Date: Fri, 5 Mar 2021 18:27:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305164944.3729910-1-maz@kernel.org>
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

On 05/03/21 17:49, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the first batch of fixes for 5.12. We have a handful of low
> level world-switch regressions, a page table walker fix, more PMU
> tidying up, and a workaround for systems with creative firmware.
> 
> Note that this is based on -rc1 despite the breakage, as I didn't feel
> like holding these patches until -rc2.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit fe07bfda2fb9cdef8a4d4008a409bb02f35f1bd8:
> 
>    Linux 5.12-rc1 (2021-02-28 16:05:19 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-1
> 
> for you to fetch changes up to e85583b3f1fe62c9b371a3100c1c91af94005ca9:
> 
>    KVM: arm64: Fix range alignment when walking page tables (2021-03-04 09:54:12 +0000)

Hi Marc,

due to a severe data corruption bug in 5.12-rc1, Linus suggested not 
including 5.12-rc1 in trees to avoid it eating our filesystems 
unwittingly during future bisections.

Would it be a problem for you to rebase on top of your merge window pull 
request?  If there are conflicts, another possibility is for you to just 
send me the patch series.  I will handle all the topic branch juggling.

This will mean rewriting kvmarm.git's history, but it does seem to be 
the lesser (or the most future-proof) evil.

Thanks,

Paolo

> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.12, take #1
> 
> - Fix SPE context save/restore on nVHE
> - Fix some subtle host context corruption on vcpu exit
> - Fix panic handling on nVHE
> - Prevent the hypervisor from accessing PMU registers when there is none
> - Workaround broken firmwares advertising bogus GICv2 compatibility
> - Fix Stage-2 unaligned range unmapping
> 
> ----------------------------------------------------------------
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
