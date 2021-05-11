Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA34C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 17:03:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51B7761168
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 17:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51B7761168
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFEA54B3BC;
	Tue, 11 May 2021 13:03:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mTSyTYlkR2sK; Tue, 11 May 2021 13:03:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 191A04B43F;
	Tue, 11 May 2021 13:03:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0274B436
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 12:29:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wk-UeIwfpXiJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 12:29:08 -0400 (EDT)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36E7F4B42C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 12:29:08 -0400 (EDT)
Received: by mail-pg1-f174.google.com with SMTP id c21so16133785pgg.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 09:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KmxqshdYV3Hb/G9+bRRwvTg3ieHcBavFgU64wcvojXE=;
 b=rOQ5NfBeE+oJ2u0UiFWwvKF7e+VNT7SCqGnZe7jRVSnVtQtCYGKRBWuhSg1N2UQGFk
 otb89kcfpr+ITEPAZ9bWJs/ekJGP+rT9Ynx2ghGOfqQ2IPmUKwhN7+OKPNsrqAYMzguA
 xU12jAxnKZM75uE+0PxCxqTAfuuu3KFCCUGxgtqYAjW2XCu7oCowoTiNQh5fXML52Qt5
 dAZfg+Mvty/XjoQKJ1WJ2sSwSjxcXhwOC1CA6nYUh6bYi5ZejMNZb8/DC0NgDAuJbcSM
 rJPzk6IXkoZm9XNuVJHYO6xTgN0tI/9Zs9KnTQEcQKsCDKNahrnJatg03zCXGHm+qvbu
 ktsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KmxqshdYV3Hb/G9+bRRwvTg3ieHcBavFgU64wcvojXE=;
 b=LsGhEoUB6fiFQVGwASqwdxu+o292WHhK7UjfNW/MYzdAZgNwhzVWO/Slr7q0t5bc0J
 A6hXyGJNDfRVAoQ8iZV4Yg176bfDkUE8FNdz2+k6kfuIGvZzkpyEBbGQhA9nE0pS9Lf8
 Vak69PiSb8eZYwJAhjmyuQ7MQRnVq0yHjJgvHOgSE9i79L4y459nJNHnJelbI/YG/J0C
 GvzWYeLgi7fGNGWGh9K3RGIlgqr0hlWPXF6yR+94zWbuCSU+dKZ18k5U7oDGd5QMfWbH
 qg6DxnANHGCFNhRrRYWIA0BQNztUI0/yUpzk2franaNa+NfdNr/DYFstqiQMi2S3tc+/
 nY9w==
X-Gm-Message-State: AOAM533aLjMbZG/PODzSM5nzUPGO8TbzYrnXGM6GQmWLuWf+eqBh133m
 rMNVKRb44mN8mAdxPdd0o9DJkA==
X-Google-Smtp-Source: ABdhPJyysk2XEIiwzTTwjOnG3me6FVZ4ODHF6bdwN3GT5Th85cVF2MgCrVHo14AypeSynvxEVNHgRA==
X-Received: by 2002:a65:4887:: with SMTP id n7mr9659147pgs.284.1620750547060; 
 Tue, 11 May 2021 09:29:07 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id j23sm14572831pfh.179.2021.05.11.09.29.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 May 2021 09:29:06 -0700 (PDT)
Date: Tue, 11 May 2021 16:29:02 +0000
From: Sean Christopherson <seanjc@google.com>
To: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: arm64: fix boolreturn.cocci warnings
Message-ID: <YJqwzqkrOzpKpUgt@google.com>
References: <202104270655.gBGhIPdZ-lkp@intel.com>
 <20210426223357.GA45871@cd4295a34ed8>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210426223357.GA45871@cd4295a34ed8>
X-Mailman-Approved-At: Tue, 11 May 2021 13:03:53 -0400
Cc: kbuild-all@lists.01.org, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Farrah Chen <farrah.chen@intel.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Robert Hu <robert.hu@intel.com>, Danmei Wei <danmei.wei@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

On Tue, Apr 27, 2021, kernel test robot wrote:
> From: kernel test robot <lkp@intel.com>
> 
> arch/arm64/kvm/mmu.c:1114:9-10: WARNING: return of 0/1 in function 'kvm_age_gfn' with return type bool
> arch/arm64/kvm/mmu.c:1084:9-10: WARNING: return of 0/1 in function 'kvm_set_spte_gfn' with return type bool
> arch/arm64/kvm/mmu.c:1127:9-10: WARNING: return of 0/1 in function 'kvm_test_age_gfn' with return type bool
> arch/arm64/kvm/mmu.c:1070:9-10: WARNING: return of 0/1 in function 'kvm_unmap_gfn_range' with return type bool
> 
>  Return statements in functions returning bool should use
>  true/false instead of 1/0.
> Generated by: scripts/coccinelle/misc/boolreturn.cocci
> 
> Fixes: cd4c71835228 ("KVM: arm64: Convert to the gfn-based MMU notifier callbacks")
> CC: Sean Christopherson <seanjc@google.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
