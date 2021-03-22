Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6283C433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 14:19:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C70D6196C
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 14:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C70D6196C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A982E4B380;
	Mon, 22 Mar 2021 10:19:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 33uSVjv43HGu; Mon, 22 Mar 2021 10:19:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2A6F4B300;
	Mon, 22 Mar 2021 10:19:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B46294B2F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 10:19:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FCjuFYgfqvze for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 10:19:52 -0400 (EDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 882204B2F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 10:19:52 -0400 (EDT)
Received: by mail-wr1-f49.google.com with SMTP id j18so17120671wra.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 07:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pu5z42QVaf24rLBi+z7TEIvMrv7JJaCJisu7Lt46g5A=;
 b=lIcT4jmSofsgtqFJrXxirehwOaHWSwyzdqjqm1XPXPhEXg3cn1xRv4m2ZG+JCrJaQE
 yYC241C904ty8cKHg+Zy/awmqiLeS6JesA+2eVGgmMi5S4TIDscPM/ci8H9HV6uUh5Gk
 rTqny3M4uk9AYDfZIkdMvsKdUgF76tZpEgpPz66d6WHonw7NAiTG7SdH/N3aOVPN6Pbn
 abIO9COUceKtdP4HQc+FxP8n+rFFhpEIjYTDV0Y696YpBrmWTHVRdKByFsOWQi6oHOWo
 tv3ry/HLxKt4iQ+CCvBuKw3X1TI4Yl7piOctl625KVXmshHcmonC3MkDBGR9IruWqEEt
 Gosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pu5z42QVaf24rLBi+z7TEIvMrv7JJaCJisu7Lt46g5A=;
 b=hZ0IWQe8oGTLTUWSIvzMy9plauvUCqd17ZiqsuiJfhyN2F6zMRq2DOkoFPNJbgHXxW
 hItjhbNRF16sd1d6PpYDuUab6qRXh8um4pzc5WYgoj00Aw2RX5AXbiG4AAYzV+xlLFVp
 daCU3gHhkP2aoqmYoHrca78cJvXt7vKW6KnWnffnhjl++u8iFcOSZ6tE/nhPTbEuALWl
 XTIk3v7/1q1DsdtFBusla9Kujqu1nnLwbckNUS10xNtK5iNR2CvJneqwAfa+idTIKef6
 xZwdBMTRvS6EgcZcxDSETXiOwbeLwudf0bbsvXLayKg9+lqWUKbPtNNk86LerJwhox7X
 hvsQ==
X-Gm-Message-State: AOAM532wyrxmjff0d7IjwG1O1RLkR5dwkjrNhjKo5Gczc3UdN7B+IeWO
 iOEIhwWW1el6kLI1tecqLzY3tw==
X-Google-Smtp-Source: ABdhPJwj8gq5zhlHMExf+1jG9iBIEkRK4vGue0nQMyroI0Z5Wmndn2pz4FSD9q7V5hqtn9QMvKeA6Q==
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr18514820wrz.373.1616422791417; 
 Mon, 22 Mar 2021 07:19:51 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id v3sm16837255wmj.25.2021.03.22.07.19.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Mar 2021 07:19:51 -0700 (PDT)
Date: Mon, 22 Mar 2021 14:19:48 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 13/38] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <YFinhL6hHWwT7ztb@google.com>
References: <20210319100146.1149909-1-qperret@google.com>
 <20210319100146.1149909-14-qperret@google.com>
 <87o8fbgv5l.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87o8fbgv5l.wl-maz@kernel.org>
Cc: kernel-team@android.com, android-kvm@google.com, catalin.marinas@arm.com,
 mate.toth-pal@arm.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hey Marc,

On Monday 22 Mar 2021 at 13:44:38 (+0000), Marc Zyngier wrote:
> I can't say I'm thrilled with this. Actually, it is fair to say that I
> don't like it at all! ;-)

:-)

> Copying whole structures with pointers that
> make no sense at EL2 feels... wrong.

And I don't disagree at all. I tried to keep this as small as possible
as the series is already quite intrusive, but I certainly understand the
concern.

> As we discussed offline, the main reason for this infrastructure is
> that the read_ctr macro directly uses arm64_ftr_reg_ctrel0.sys_val
> when ARM64_MISMATCHED_CACHE_TYPE is set.

Indeed that is the only reason.

> One thing to realise is that with the protected mode, we can rely on
> patching as there is no such thing as a "late" CPU. So by specialising
> read_ctr when compiled for nVHE, we can just make it give us the final
> value, provided that KVM's own __flush_dcache_area() is limited to
> protected mode.
> 
> Once this problem is solved, this whole patch can mostly go, as we are
> left with exactly *two* u64 quantities to be populated, something that
> we can probably do in kvm_sys_reg_table_init().
> 
> I'll post some patches later today to try and explain what I have in
> mind.

Sounds great, thank you very much for the help!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
