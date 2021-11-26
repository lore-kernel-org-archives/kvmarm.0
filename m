Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DC8C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 26 Nov 2021 10:42:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B5F4B0DB;
	Fri, 26 Nov 2021 05:42:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CxABantBWWEY; Fri, 26 Nov 2021 05:42:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A694B0DE;
	Fri, 26 Nov 2021 05:42:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87AA14B0A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Nov 2021 05:42:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qb+B01JOOOYq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Nov 2021 05:42:18 -0500 (EST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 452E84B093
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Nov 2021 05:42:18 -0500 (EST)
Received: by mail-ed1-f48.google.com with SMTP id e3so37061417edu.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Nov 2021 02:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=onPF4lXpXF+Dn8bEb7/7mVOAXBedsvvB8Ezt0wTGXKc=;
 b=HFFbX/VlmMzUKvAkhM7xRQgGBYDvXZUScoQa88NqQU6PLV8XGX6Rx9CwAkI0cQNf2y
 t5F+I4nBuhTwqNIswkcVdiE/9PcydACzE+Qdsrp/okMZF9ZpBR4vT0V9jEokUCqrBeu3
 04taIm7qYlO+u7jQixr6jhs7BJF1W0mKcwTZm/Bc5wSvPnJoR8QpIRSTOsg7R3t4M6Ol
 kplMRoUvdLtPX1h5Sp4Z21oCit+K6dLB5Yrcr2Ci/JERKv62lab5a2B1DhFK0RQMEkTa
 7et34rxBLyglNJG302hX0WVj+nI8mkOcD4Tpx0dbMW72TIxPNn7hvwVCuif35x0BK+fq
 6jIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=onPF4lXpXF+Dn8bEb7/7mVOAXBedsvvB8Ezt0wTGXKc=;
 b=EwFNGm0OO2mroV6pSYolazIHUW+r3Ga+5j2ehPT1uxgmNUkZfFXK9BkmE60tfGaDJN
 C2UIPmMdneb9DqKaeuvevhJinBGVrb2Ket9tXV8EkkJ0sTSUc4LumH7scj/j5j9ZZoBF
 CB1rlYU7wipdRv3T9ZecjD/rc7Wj7K+OnblVkvhmDwjI7+MzKn6mbz8cj5XQKSBVuGnt
 OPm1ufxpioFGH2HfPXlPLH+xLoA/POnEG6hXbWckCNlJUajg1u7zqMiekY2zzr6IZm2R
 5v/zeD2BHB6Yo56JKx38XlRlYfX8deeGWvr0IugbitJkPiY08e1J/S6zAj8YgdZjsdnD
 ogOw==
X-Gm-Message-State: AOAM531VOg90Wssbmn8IkfSmMfYqihiZQC30E/bQ0gzU/ItbwWrfyZsb
 KEdrlS3JqbtFlEQosp0my8A=
X-Google-Smtp-Source: ABdhPJzmbvzIUCYm4QDTRJ36NhFszX574agfn+UoV+J/pQcPrKORyNn6DMJIMuqbnSXcRTp0WWxk2Q==
X-Received: by 2002:a05:6402:5c2:: with SMTP id
 n2mr46265739edx.239.1637923337196; 
 Fri, 26 Nov 2021 02:42:17 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a?
 ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
 by smtp.googlemail.com with ESMTPSA id
 sh30sm2791868ejc.117.2021.11.26.02.42.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 26 Nov 2021 02:42:16 -0800 (PST)
Message-ID: <6e375bd2-d740-a00e-91d9-4b1ab2f82cac@redhat.com>
Date: Fri, 26 Nov 2021 11:42:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.16, take #2
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20211125161902.106749-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125161902.106749-1-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chris January <Chris.January@arm.com>, linux-arm-kernel@lists.infradead.org,
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

On 11/25/21 17:19, Marc Zyngier wrote:
> Paolo,
> 
> Here's the second set of fixes for 5.16. The main items are a fix for
> an unfortunate signed constant extension, leading to an unbootable
> kernel on ARMv8.7 systems. The two other patches are fixes for the
> rare cases where we evaluate PSTATE too early on guest exit.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:
> 
>    Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.16-2
> 
> for you to fetch changes up to 1f80d15020d7f130194821feb1432b67648c632d:
> 
>    KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1 (2021-11-25 15:51:25 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.16, take #2
> 
> - Fix constant sign extension affecting TCR_EL2 and preventing
>    running on ARMv8.7 models due to spurious bits being set
> 
> - Fix use of helpers using PSTATE early on exit by always sampling
>    it as soon as the exit takes place
> 
> - Move pkvm's 32bit handling into a common helper
> 
> ----------------------------------------------------------------
> Catalin Marinas (1):
>        KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1
> 
> Marc Zyngier (2):
>        KVM: arm64: Save PSTATE early on exit
>        KVM: arm64: Move pkvm's special 32bit handling into a generic infrastructure
> 
>   arch/arm64/include/asm/kvm_arm.h           |  4 ++--
>   arch/arm64/kvm/hyp/include/hyp/switch.h    | 14 ++++++++++++++
>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  7 ++++++-
>   arch/arm64/kvm/hyp/nvhe/switch.c           |  8 +-------
>   arch/arm64/kvm/hyp/vhe/switch.c            |  4 ++++
>   5 files changed, 27 insertions(+), 10 deletions(-)
> 


Pulled, thanks.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
