Return-Path: <SRS0=lrOB=GC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E45AC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 09:09:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D56521D94
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 09:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D56521D94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6DBC4B154;
	Wed, 30 Dec 2020 04:09:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4p1fh7tyIhqW; Wed, 30 Dec 2020 04:09:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F262D4B168;
	Wed, 30 Dec 2020 04:09:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 174B44B318
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 17:33:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Dt00xVI+8gr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Dec 2020 17:33:36 -0500 (EST)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F03F34B2C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 17:33:35 -0500 (EST)
Received: by mail-pj1-f41.google.com with SMTP id lj6so2146407pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 14:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GkyE8LbEEVHxy2CefSeYkkl16YrbDYCmT2Fd0SUPzw4=;
 b=UVBWYgTKbE2/khVyuxEmmeEnea2wHbJ8CU/QZoRuDgulV+M8EF/8sKV5ArBqZbJ2tU
 PBVlvmoXOYCTCenfdsbD6fZ/AgsdjkWjGp89pZI9Ujkqu+TBnRpfeII2OjeUNZmTt03P
 BwlSoalZ7f09msNNCnkVTYp2yx+XxuNu9B1JM0WI83E3sEA7B+nnTzbPeCVikkTqUC8p
 N7L1AEcPVJi7CCzajME8xn82q6yMacLJir4nKLqTNzseYBPiFMnu1RvisrnTzlkH/1w1
 Qm1tQMItkc05HqXNvcmHCCRRfHdz/edzxWlOBL9cJs3vmvGJ5GEZv9jXK28KX9iESuSB
 qKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GkyE8LbEEVHxy2CefSeYkkl16YrbDYCmT2Fd0SUPzw4=;
 b=hTM4CsjiGVUun+dMnQ6xXVy3dNyAUwPfo5gY2PM53VfXdj5OEYOeLZ2efnojyMAK0W
 T2AXT/14Zeue6dTfuvbtTkvFFkHWCvtDmnBoZWhg9fw4+3wRlk+jXIrIxeeqzpf5RqgI
 WKSSMhjkX5c+pQ4G/ZtbIAZOIc1G8AUKWWa08Em8izboq+MOPbUT8P2+t+5LhcElJKfN
 qRJkx52EfVXl8urarZ6Vu7ur4OnmDcmTmozrd6jSvKeOvtZzrAz8U6ZWsFNfZwJV/IJ/
 dUtKXoalPrzwb0WABbZI6ehcqmWjrCBtSZgsKbwtc9rHI8hUva4jIMs1d9GYCQPjMNr4
 DgsA==
X-Gm-Message-State: AOAM531GO/SbHOeEQiYKhKtoOxxBC9B3M9DogVVFAt4SLKVW7ascpzkC
 uFzc7wemZ2kPjCoPzhOvjGo=
X-Google-Smtp-Source: ABdhPJzWfsuoOOQdYJzhN3RMoSpW8gv2xP1t3iR2LTYbbXm4GATIPF4MTrOww6Wg8mRqcVYYcs14Nw==
X-Received: by 2002:a17:90a:c20b:: with SMTP id
 e11mr5784720pjt.43.1609281214864; 
 Tue, 29 Dec 2020 14:33:34 -0800 (PST)
Received: from Ryzen-9-3900X.localdomain (ip68-104-204-241.ph.ph.cox.net.
 [68.104.204.241])
 by smtp.gmail.com with ESMTPSA id 77sm41028915pfx.156.2020.12.29.14.33.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 29 Dec 2020 14:33:34 -0800 (PST)
Date: Tue, 29 Dec 2020 15:33:31 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix section mismatches around
 hyp_cpu_pm_{init,exit}
Message-ID: <20201229223331.GA212@Ryzen-9-3900X.localdomain>
References: <20201229214336.4098955-1-natechancellor@gmail.com>
 <49e9d2e2e7103c49882b54c18c567667@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49e9d2e2e7103c49882b54c18c567667@kernel.org>
X-Mailman-Approved-At: Wed, 30 Dec 2020 04:09:16 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 clang-built-linux@googlegroups.com, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Dec 29, 2020 at 10:11:07PM +0000, Marc Zyngier wrote:
> On 2020-12-29 21:43, Nathan Chancellor wrote:
> > Commit fa8c3d65538a ("KVM: arm64: Keep nVHE EL2 vector installed")
> > inadvertently changed clang's inlining decisions around
> > hyp_cpu_pm_{init,exit}, causing the following section mismatch warnings:
> > 
> > WARNING: modpost: vmlinux.o(.text+0x95c6c): Section mismatch in
> > reference from the function kvm_arch_init() to the function
> > .init.text:hyp_cpu_pm_exit()
> > The function kvm_arch_init() references
> > the function __init hyp_cpu_pm_exit().
> > This is often because kvm_arch_init lacks a __init
> > annotation or the annotation of hyp_cpu_pm_exit is wrong.
> > 
> > WARNING: modpost: vmlinux.o(.text+0x97054): Section mismatch in
> > reference from the function init_subsystems() to the function
> > .init.text:hyp_cpu_pm_init()
> > The function init_subsystems() references
> > the function __init hyp_cpu_pm_init().
> > This is often because init_subsystems lacks a __init
> > annotation or the annotation of hyp_cpu_pm_init is wrong.
> > 
> > Remove the __init annotation so that there are no warnings regardless of
> > how functions are inlined.
> > 
> > Fixes: 1fcf7ce0c602 ("arm: kvm: implement CPU PM notifier")
> > Fixes: 06a71a24bae5 ("arm64: KVM: unregister notifiers in hyp mode
> > teardown path")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1230
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Hi Nathan,
> 
> Already posted[1] last week.
> 
> Thanks,
> 
>         M.
> 
> [1] htps://lore.kernel.org/r/20201223120854.255347-1-maz@kernel.org
> -- 
> Jazz is not dead. It just smells funny...

Sorry for the duplicate, I am usually good at spotting that :(

Cheers,
Nathan
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
