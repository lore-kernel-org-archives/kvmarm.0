Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67054C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 18:05:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC80620836
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 18:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ghOooeTc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC80620836
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF0924B132;
	Thu, 11 Jun 2020 14:05:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tbzcRGyxdXvN; Thu, 11 Jun 2020 14:05:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A5CD4B145;
	Thu, 11 Jun 2020 14:05:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1307A4B132
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 14:05:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N5s6DAxTRn38 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2020 14:05:02 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C54944B130
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 14:05:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1591898702;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7cOqWTuYUa9FE9GP6fpBOyXkY5kMzNQixiqzTqJRGBI=;
 b=ghOooeTcLtaSo9x+LHcqZrfBO+oTZAOVdqfZ4EhJn3KkZZAbiTbPpHpKUhgfhNLIYoNzIr
 ifX9EuS+IfHO4YGYrTMOpGNXbNuKcAw6hJA6RgfcqmTgaXZT0NczFmxDYN8/9aSc50yqGF
 sTFLvLFgmTtLgs4lJtphzuIJo/E6jS4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-UxWq_IpkN-u-aOr0XOMjfA-1; Thu, 11 Jun 2020 14:04:56 -0400
X-MC-Unique: UxWq_IpkN-u-aOr0XOMjfA-1
Received: by mail-wm1-f72.google.com with SMTP id l2so1308782wmi.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 11:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=7cOqWTuYUa9FE9GP6fpBOyXkY5kMzNQixiqzTqJRGBI=;
 b=MFMwMbayX0OZ4HnVR3bcB8/WRg1ZskbOxenKtV2zLMOBVUB5BJZwu9VDJFavAls8/v
 yk01O8UOqsp3+eiPDAmEOqbtr9u36GDqnu7F9RcAh2Jl7c8gkyulIftuUJHbcIXH33/B
 wRtP7rSYBXC2N/6Jr5XkqnIy5nWwbqaQi3SUxHru+ZR03+Htx/afUVaTGxh+HowdrkG1
 SS2T9CDsDSBHNzqLtm3MZ7ZPvjpJOcbCBvM2b5fCcABzwpqVRkP/HCfBCOxNXPAR9XQk
 LTcDxmHbpnYfMBXUv4pRXPWCcjvAWKqIaw/yd7GkrIL4UFn3WLRoKlvFD2B+s0lxr2y6
 Kd3g==
X-Gm-Message-State: AOAM533u/eIEueArFDuHexgIs2iesrJtGyB0P/ETnm/x3cbMQFFOaibX
 tu2gVWBvAyyRr0vfoaxTzZP62OjU9RoxNFJ0dX2Wn32CYYAmidRvR+vz7TkZppRqh7HSkJLMUvr
 1dnqa7KwPaCoDoBR4VWdHT7MS
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr9180034wmh.8.1591898695049;
 Thu, 11 Jun 2020 11:04:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR4smWGm/DBrvqHqnYi+0pYh8w7qlAz7vSbFH29HX9jSbIpMW1S4TmGZ3yFk17wCx3012mHw==
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr9180010wmh.8.1591898694794;
 Thu, 11 Jun 2020 11:04:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d?
 ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
 by smtp.gmail.com with ESMTPSA id v7sm6110537wro.76.2020.06.11.11.04.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 11 Jun 2020 11:04:54 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.8, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20200611090956.1537104-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be82c5cb-be6d-74f7-9b77-dbd1648a8933@redhat.com>
Date: Thu, 11 Jun 2020 20:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200611090956.1537104-1-maz@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

On 11/06/20 11:09, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's a bunch of fixes that cropped up during the merge window,
> mostly falling into two categories: 32bit system register accesses,
> and 64bit pointer authentication handling.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 8f7f4fe756bd5cfef73cf8234445081385bdbf7d:
> 
>   KVM: arm64: Drop obsolete comment about sys_reg ordering (2020-05-28 13:16:57 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-1
> 
> for you to fetch changes up to 15c99816ed9396c548eed2e84f30c14caccad1f4:
> 
>   Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next (2020-06-10 19:10:40 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for Linux 5.8, take #1
> 
> * 32bit VM fixes:
>   - Fix embarassing mapping issue between AArch32 CSSELR and AArch64
>     ACTLR
>   - Add ACTLR2 support for AArch32
>   - Get rid of the useless ACTLR_EL1 save/restore
>   - Fix CP14/15 accesses for AArch32 guests on BE hosts
>   - Ensure that we don't loose any state when injecting a 32bit
>     exception when running on a VHE host
> 
> * 64bit VM fixes:
>   - Fix PtrAuth host saving happening in preemptible contexts
>   - Optimize PtrAuth lazy enable
>   - Drop vcpu to cpu context pointer
>   - Fix sparse warnings for HYP per-CPU accesses
> 
> ----------------------------------------------------------------
> James Morse (3):
>       KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
>       KVM: arm64: Add emulation for 32bit guests accessing ACTLR2
>       KVM: arm64: Stop save/restoring ACTLR_EL1
> 
> Marc Zyngier (9):
>       KVM: arm64: Flush the instruction cache if not unmapping the VM on reboot
>       KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
>       KVM: arm64: Handle PtrAuth traps early
>       KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
>       KVM: arm64: Remove host_cpu_context member from vcpu structure
>       KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
>       KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
>       KVM: arm64: Move hyp_symbol_addr() to kvm_asm.h
>       Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next
> 
>  arch/arm64/include/asm/kvm_asm.h     | 33 ++++++++++++++++--
>  arch/arm64/include/asm/kvm_emulate.h |  6 ----
>  arch/arm64/include/asm/kvm_host.h    |  9 +++--
>  arch/arm64/include/asm/kvm_mmu.h     | 20 -----------
>  arch/arm64/kvm/aarch32.c             | 28 ++++++++++++++++
>  arch/arm64/kvm/arm.c                 | 20 ++++++-----
>  arch/arm64/kvm/handle_exit.c         | 32 ++----------------
>  arch/arm64/kvm/hyp/debug-sr.c        |  4 +--
>  arch/arm64/kvm/hyp/switch.c          | 65 ++++++++++++++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/sysreg-sr.c       |  8 ++---
>  arch/arm64/kvm/pmu.c                 |  8 ++---
>  arch/arm64/kvm/sys_regs.c            | 25 +++++++-------
>  arch/arm64/kvm/sys_regs_generic_v8.c | 10 ++++++
>  13 files changed, 171 insertions(+), 97 deletions(-)
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
