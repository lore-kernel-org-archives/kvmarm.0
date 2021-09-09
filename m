Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8588CC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 02:47:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F110B61181
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 02:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F110B61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71B014B0A0;
	Wed,  8 Sep 2021 22:47:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SJTvtXhMAfFs; Wed,  8 Sep 2021 22:47:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8146E4B0DB;
	Wed,  8 Sep 2021 22:47:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 721904A193
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 22:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ZDoDBycFp8X for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 22:47:44 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E15B4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 22:47:44 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id s10so648554lfr.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 19:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JZuJyqgIQ3oQtgMoTdVtSIrlc/hlmnNYpLQyvIq2xfg=;
 b=VZXmr2CtnEu1xnlQB4sj2Toq9NyQnwr3mAwinwc9e8osCTTaXFE+U4Fud4LA4LQwHL
 tKIq+ogy26qQ/8sq5IHh1IZf4M4UAzkPAVyKYHJor1xFMGUQVY8Gu3C67tp1bAAGmALc
 1vk19c5020uz/heFydrcvHLZ7iJAhJqPZCCH9/lxWmAtmgqVSUAsGQzpDbEXNU/rp8Eo
 ftURTDAMe4WoRh6lSolAyHoT2Uz9IwQvq4w1ttJUdRzg234sqSsL8cps/95yAkAPqClc
 M/+o+mVAN9ae1EQE0dH6Jjidt6164K1TboKNNsnUWx9A4aZu6ESEx2imAPJDnA6rVaUp
 QZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JZuJyqgIQ3oQtgMoTdVtSIrlc/hlmnNYpLQyvIq2xfg=;
 b=FM3zVmLKYZC2+CGuSEmY7ZMZOs04XoUc4UlnJVtHTdUAM8C2pfNUp7n31DWITLjnuF
 CfmPIYkPLAtMhIVp7gtsTukugRjEJDDIF7Zc/CohW4iLcVN2tNIp1cT8KLGZMjrs1NOt
 yoXpk5gvusr1PKJZqLADrC9o3sLSpq5pjZDEgKzcusrEjfYBnza31VW2Apcvl0NarP3d
 5ovFrm8yfkV1l60gQZQy/UV6wG/H/UUOFwbdLW3sJ6NlPpk/lDFFxS5hQx13OfGp4VUm
 7KtlDUub2hwvf185rbiGFP7CQr3+YHMVsO6u5xkgnjrcj7Td9ZsT6/w3g4bqD1XlUzxd
 ljCQ==
X-Gm-Message-State: AOAM531EP7UGJN87bttpsYfUoNtHsDUVDR5wx0YvEVHaFxtUSAviVFNG
 slxbYbpGD+zamZIvkCO1kWibNyiN7uM2oGeXRlIPjQ==
X-Google-Smtp-Source: ABdhPJwf+kTCeI6PWF0qQnERCUUUEE8rZRrAMp2Rah12EYfVEJ+5BQho5Hay73HyIRWt9EKzJwn1d+yIQ9o2ln5e0jc=
X-Received: by 2002:a05:6512:114c:: with SMTP id
 m12mr626886lfg.150.1631155662626; 
 Wed, 08 Sep 2021 19:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
In-Reply-To: <20210909013818.1191270-3-rananta@google.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 8 Sep 2021 22:47:31 -0400
Message-ID: <CAOQ_Qsh=F-tTre_ojiLXUfAriH-coTF_gXCcLyRb3kKM+LLhQA@mail.gmail.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Raghu,

On Wed, Sep 8, 2021 at 9:38 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> into selftests to make use of all the standard
> register definitions in consistence with the kernel.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
>  1 file changed, 1278 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h

This belongs in tools/arch/arm64/include/asm/sysreg.h, I believe.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
