Return-Path: <SRS0=BSt1=FK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C3DC433FE
	for <kvmarm@archiver.kernel.org>; Sun,  6 Dec 2020 10:56:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8761F22D2C
	for <kvmarm@archiver.kernel.org>; Sun,  6 Dec 2020 10:56:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8761F22D2C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9A024B1B5;
	Sun,  6 Dec 2020 05:56:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pPBqDVp+ds-g; Sun,  6 Dec 2020 05:56:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E2E4B1D7;
	Sun,  6 Dec 2020 05:56:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A60C4B1AF
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Dec 2020 05:56:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OEZAqRTFj171 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Dec 2020 05:56:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 511B04B150
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Dec 2020 05:56:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607252185;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zb05xp01BEyQm5LEh62oLhnL6kPgxUW55TugbE4oo4M=;
 b=Ktt6kk5NrOvCO8vcK7SSxx3aE5umzFoOgtKNVDWTazxiBV20+540r9E6yywj2ru7tZYryP
 C2TB2POScsNJrsmgSqD99HO5REL9EmrYebmM26kESg3paQOBNpp8D+RalfKnuoaGWFHJaT
 AkGXWzGpbytCDvONoAtpDGUwqlnnkeE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-WT2hq-FCPQalaqLeIAzdlw-1; Sun, 06 Dec 2020 05:56:21 -0500
X-MC-Unique: WT2hq-FCPQalaqLeIAzdlw-1
Received: by mail-wr1-f69.google.com with SMTP id p18so4118254wro.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 06 Dec 2020 02:56:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=zb05xp01BEyQm5LEh62oLhnL6kPgxUW55TugbE4oo4M=;
 b=PPwizT4aZYZ0wFhHYicrKF5tGxskB5DfX5vMe3SHm3yZkOYCMBhtgZ5hR4FCnbNxu1
 2VwMPvksivFFKeuNXecT5dnWv2XmA3YwWNYm0VTpZvu8PI+gpDHJUMSnwlo4VbruR2p6
 pB1Gm4qppEEZtXOUJHNAX4iSAb0Afs+++6sgPL65w7iGw4P3vLludbvy95cMGeXqlFia
 yBWWW1qgXiDau5vjBZnnkjtNJNrxP542AGIrq2zXwki3EUPVuefLX/TPBRJpVdhKGyut
 QcpiORS+Qp6ZwdNNEm6iKavLNcq+TJRoECpGP/XpI13P430UWGsLh0f3DdYSPHmvOB4V
 +tuA==
X-Gm-Message-State: AOAM532vSB7OKKP/N4hWRmTZQZSWtPcy8wbeigPYPO9mAnXD1zT/uQgK
 nq4vVs4j5H1kjKlHXPmaJmtOTA2/6erP3gqrdY5R2vCFxffuFEoe8qEHWZrKyhhP06peWOw9uwo
 VpB6WNj2jVJWCQFqWGrK/pRk4
X-Received: by 2002:a7b:cf37:: with SMTP id m23mr12991482wmg.37.1607252180121; 
 Sun, 06 Dec 2020 02:56:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGX3cca6nPagY2g70Cl2YOoYgsl0EaRP4WwTL7DXdmVUAvbBY8Gmu27mN+p01TBovcAihFAA==
X-Received: by 2002:a7b:cf37:: with SMTP id m23mr12991464wmg.37.1607252179933; 
 Sun, 06 Dec 2020 02:56:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id w17sm10634246wru.82.2020.12.06.02.56.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 06 Dec 2020 02:56:18 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.10, take #5
To: Marc Zyngier <maz@kernel.org>
References: <20201204181914.783445-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8775fc2-8501-1674-03f4-d6660987a86f@redhat.com>
Date: Sun, 6 Dec 2020 11:56:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204181914.783445-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Yanan Wang <wangyanan55@huawei.com>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 04/12/20 19:19, Marc Zyngier wrote:
> Hi Paolo,
> 
> A week ago, I was hoping being done with the 5.10 fixes. I should
> obviously know better.
> 
> Thanks to Yanan's excellent work, we have another set of page table
> fixes, all plugging issues introduced with our new page table code.
> The problems range from memory leak to TLB conflicts, all of which are
> serious enough to be squashed right away.
> 
> Are we done yet? Fingers crossed.

Pulled, thanks.  I am not sure I'll get my own pull request to Linus 
today, though.

Paolo


> Please pull,
> 
> 	M.
> 
> The following changes since commit 23bde34771f1ea92fb5e6682c0d8c04304d34b3b:
> 
>    KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace (2020-11-17 18:51:09 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-5
> 
> for you to fetch changes up to 7d894834a305568a0168c55d4729216f5f8cb4e6:
> 
>    KVM: arm64: Add usage of stage 2 fault lookup level in user_mem_abort() (2020-12-02 09:53:29 +0000)
> 
> ----------------------------------------------------------------
> kvm/arm64 fixes for 5.10, take #5
> 
> - Don't leak page tables on PTE update
> - Correctly invalidate TLBs on table to block transition
> - Only update permissions if the fault level matches the
>    expected mapping size
> 
> ----------------------------------------------------------------
> Yanan Wang (3):
>        KVM: arm64: Fix memory leak on stage2 update of a valid PTE
>        KVM: arm64: Fix handling of merging tables into a block entry
>        KVM: arm64: Add usage of stage 2 fault lookup level in user_mem_abort()
> 
>   arch/arm64/include/asm/esr.h         |  1 +
>   arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>   arch/arm64/kvm/hyp/pgtable.c         | 17 ++++++++++++++++-
>   arch/arm64/kvm/mmu.c                 | 11 +++++++++--
>   4 files changed, 31 insertions(+), 3 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
