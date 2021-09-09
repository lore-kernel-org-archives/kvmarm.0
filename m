Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A93AC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 03:02:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68A4060EE1
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 03:02:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 68A4060EE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B65764B10A;
	Wed,  8 Sep 2021 23:02:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c0bHGn45iw2F; Wed,  8 Sep 2021 23:02:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE1EE4B0C5;
	Wed,  8 Sep 2021 23:02:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17DA84B0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 23:02:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wSGnKZWmsAah for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 23:02:34 -0400 (EDT)
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com
 [209.85.166.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDF094AC80
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 23:02:34 -0400 (EDT)
Received: by mail-il1-f174.google.com with SMTP id h29so473556ila.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 20:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lS2TfPmFq21WQA7kbI98jf7rDXgRBmsiJwAOxbyrVAE=;
 b=E1i9dzXY8FPZ0L+1tJuVo2J7zoe5PQ5Nbe26IR98lKFC/EFy7vzC7ItaFodLhxWHl5
 BC4MTyEER+lWdRHF8GluZ4XPAsX77Y+uxxjgW7B0b6PFqGUtBUANxTpziKk66rKP/ew6
 VcaQtkDrk4p2eK7xJNcdBzliel9JDBPZ7I3YlVvLU8hPNUntp+0+M05YxBLrcpplsf3q
 cZgexH9nLdpb6A98a4Aenh2/cOrv6xIM7meGszXq9kjMA7T7kfXMkRpLzHb+lIpMG+1O
 VO5oLmDy9I5apJ/bpHQNuvc1a4GjsOk3zXsn4WiD+2QmOwTV1OD9GvzLQOqKkP7Dx9lC
 zgrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lS2TfPmFq21WQA7kbI98jf7rDXgRBmsiJwAOxbyrVAE=;
 b=8RpDznq1rsvQD22AY3FTUGMsCWC3s7Ahc6JVhIc3ut/VrSCPL/C1qap66fZXlCOUp8
 jNTlIE28UecsAWLV8p3G8def1KTbk85XA2+mLc+s0VQsZz2WGDhALxFEUf/tgb4AKI7v
 VmnQDH4ySIalFiKHiooR1fO6SxO28KGZZMeQVynmZZCxW0pUdDZaQVm8E+bK2InAbhOP
 05C3xi+1vOxx6SkfVkL4B0n9DX/qNfv0I9tEutFwuzmSNtRt2i23tu4FJw+8E8Jpomxk
 CSG+0eW5cHYME5eaL4Js9tl9viOaGEsd4JcLHi91tUMovb6HVNhmNc8455BtbsPd1nVE
 jq7A==
X-Gm-Message-State: AOAM531UTaINRkkfn9oSsvXmscko/4K1O4f37g/mRYGYfeoiOgQiiFqe
 GMLeKv9fFKnyN3yW9tb8+2sfXQ==
X-Google-Smtp-Source: ABdhPJxnO3Xpf1rxt3cvGCIm05a/BPHERWpzorX/jlAxyWQB/SDLCIR3d7u6J9mGOmi/1JVTQda6Jw==
X-Received: by 2002:a92:c605:: with SMTP id p5mr594556ilm.53.1631156554045;
 Wed, 08 Sep 2021 20:02:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id s1sm282250iln.12.2021.09.08.20.02.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 20:02:33 -0700 (PDT)
Date: Thu, 9 Sep 2021 03:02:29 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 04/18] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
Message-ID: <YTl5RQjJ0EFmhUlG@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-5-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-5-rananta@google.com>
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

On Thu, Sep 09, 2021 at 01:38:04AM +0000, Raghavendra Rao Ananta wrote:
> With the inclusion of sysreg.h, that brings in system register
> encodings, it would be redundant to re-define register encodings
> again in processor.h to use it with ARM64_SYS_REG for the KVM
> functions such as set_reg() or get_reg(). Hence, add helper macro,
> ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> into ARM64_SYS_REG definitions.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index bed4ffa70905..ac8b63f8aab7 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -26,6 +26,20 @@
>  
>  #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
>  
> +/*
> + * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
> + * SYS_* register definitions in sysreg.h to use in KVM
> + * calls such as get_reg() and set_reg().
> + */
> +#define ARM64_SYS_KVM_REG(sys_reg_id)			\

nit: KVM_ARM64_SYS_REG() perhaps? Dunno which is more readable.

> +({							\
> +	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
> +			sys_reg_Op1(sys_reg_id),	\
> +			sys_reg_CRn(sys_reg_id),	\
> +			sys_reg_CRm(sys_reg_id),	\
> +			sys_reg_Op2(sys_reg_id));	\
> +})
> +

Could you also switch all current users of ARM64_SYS_REG() in the KVM
selftests directory in this commit? You can also drop the system
register encodings defined in processor.h

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
