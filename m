Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719D2C43603
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 16:48:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00959227BF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 16:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RXFjc1da"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00959227BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4684A7F1;
	Wed, 18 Dec 2019 11:48:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zQr6Z1Nw63mr; Wed, 18 Dec 2019 11:48:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CA624A4CD;
	Wed, 18 Dec 2019 11:48:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B0834A4A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 11:48:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P3J5HBIeA8Qp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 11:48:12 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 320254A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 11:48:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576687691;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3iCukN3naD4fNqdh9fYCT0LHF+dYyNnqG3y3xi+jSBI=;
 b=RXFjc1daOLGSmr58ckpYI8voP/oc/b18GTsGyLt8k0PtKwZ2tVWiS1GZ7EjL6rLdy5qXdq
 kW4t0xIw/crZYnDUftafruCW3+Qs/5jk9ag5eYdhkV1Vd73FRZkbuYl0+Y++E0ZP1WLIW8
 3vVBi6rO1pKkWdtwa2VF1/tWnLgmZNw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-GEtcmbCUOXa3HuNAMY_gwQ-1; Wed, 18 Dec 2019 11:48:09 -0500
Received: by mail-wm1-f69.google.com with SMTP id y125so1979421wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 08:48:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=3iCukN3naD4fNqdh9fYCT0LHF+dYyNnqG3y3xi+jSBI=;
 b=OHTElz1uEWvx577wbDRoxrsYOpPLHzefU/UEr7ReOxrPIjXUJTYYY3dkBgSRnqe7RZ
 /x9qr5rTcpJBEr5h0a7ITd/NpQmm0+rLpu/3dVOABQxyTS1zsK1hbMQPxGxi+TI6VjKH
 QAJ9VzGFsXcT+E1symqFJ5qLB8TAGgJdMzfJmsok0ILKr09ObD5NpFZPiKI9KaDXfEwx
 SA0qqwJBcQW6xkr/Bxpi/NejGgGBfLyaDBOX16/rLXL9cYqM1xNgbLK1DL1rAjbrl02f
 oWNILmgEYCR7EHtHAnd4Rlrn1xOTlQPfV3d/SNAuCq7dfhaPOc806O0/NHFJbXrOcZ8n
 9uTg==
X-Gm-Message-State: APjAAAXWLGfDySTvbflmNlorUXz+cHuslgKqo696SH1Ux44HHWMr4Xsj
 UQyrL0RSwl5ojwcr7irMHS3K8tlSNOdVhQZc3tbqgGrLHv1T/AH6uMarDNT0vREhVCBas3liPJu
 Apou+VUBo4iJ/d7suDffoZZe8
X-Received: by 2002:a1c:bbc3:: with SMTP id l186mr4359427wmf.101.1576687688290; 
 Wed, 18 Dec 2019 08:48:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqx38t0P19/s6RsgvAUv2tWoExNQh9N/QMlt/7vD4SmB6ulBRwM6tY/Yad0hhQ0X8xSOGooRiA==
X-Received: by 2002:a1c:bbc3:: with SMTP id l186mr4359398wmf.101.1576687688016; 
 Wed, 18 Dec 2019 08:48:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c?
 ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
 by smtp.gmail.com with ESMTPSA id c2sm3173159wrp.46.2019.12.18.08.48.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 18 Dec 2019 08:48:07 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm updates for 5.5-rc2
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20191212172824.11523-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8f96563-0cc0-1d00-0eb7-2845dba27d84@redhat.com>
Date: Wed, 18 Dec 2019 17:48:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191212172824.11523-1-maz@kernel.org>
Content-Language: en-US
X-MC-Unique: GEtcmbCUOXa3HuNAMY_gwQ-1
X-Mimecast-Spam-Score: 0
Cc: Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will@kernel.org>,
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

On 12/12/19 18:28, Marc Zyngier wrote:
> Paolo, Radim,
> 
> This is the first set of fixes for 5.5-rc2. This time around,
> a couple of MM fixes, a ONE_REG fix for an issue detected by
> GCC-10, and a handful of cleanups.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit cd7056ae34af0e9424da97bbc7d2b38246ba8a2c:
> 
>   Merge remote-tracking branch 'kvmarm/misc-5.5' into kvmarm/next (2019-11-08 11:27:29 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.5-1
> 
> for you to fetch changes up to 6d674e28f642e3ff676fbae2d8d1b872814d32b6:
> 
>   KVM: arm/arm64: Properly handle faulting of device mappings (2019-12-12 16:22:40 +0000)

Pulled, thanks.

Paolo

> 
> ----------------------------------------------------------------
> KVM/arm fixes for .5.5, take #1
> 
> - Fix uninitialised sysreg accessor
> - Fix handling of demand-paged device mappings
> - Stop spamming the console on IMPDEF sysregs
> - Relax mappings of writable memslots
> - Assorted cleanups
> 
> ----------------------------------------------------------------
> Jia He (1):
>       KVM: arm/arm64: Remove excessive permission check in kvm_arch_prepare_memory_region
> 
> Marc Zyngier (1):
>       KVM: arm/arm64: Properly handle faulting of device mappings
> 
> Mark Rutland (2):
>       KVM: arm64: Sanely ratelimit sysreg messages
>       KVM: arm64: Don't log IMP DEF sysreg traps
> 
> Miaohe Lin (3):
>       KVM: arm/arm64: Get rid of unused arg in cpu_init_hyp_mode()
>       KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()
>       KVM: arm/arm64: vgic: Use wrapper function to lock/unlock all vcpus in kvm_vgic_create()
> 
> Will Deacon (1):
>       KVM: arm64: Ensure 'params' is initialised when looking up sys register
> 
>  arch/arm64/kvm/sys_regs.c     | 25 ++++++++++++++++++-------
>  arch/arm64/kvm/sys_regs.h     | 17 +++++++++++++++--
>  virt/kvm/arm/arm.c            |  4 ++--
>  virt/kvm/arm/mmu.c            | 30 +++++++++++++++++-------------
>  virt/kvm/arm/vgic/vgic-init.c | 20 +++++---------------
>  5 files changed, 57 insertions(+), 39 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
