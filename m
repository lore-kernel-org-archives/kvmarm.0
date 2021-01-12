Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86DAC4332B
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 09:52:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27434230FF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 09:51:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27434230FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8A04B34C;
	Tue, 12 Jan 2021 04:51:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uQVWpGaPmdfW; Tue, 12 Jan 2021 04:51:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A2CA4B22D;
	Tue, 12 Jan 2021 04:51:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88A854B22D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 04:51:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j0Ps1rKNOWrb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 04:51:55 -0500 (EST)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5145D4B228
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 04:51:55 -0500 (EST)
Received: by mail-wm1-f54.google.com with SMTP id c124so1322786wma.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 01:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kGqJqM+WMCcTD3fT9OGAlv624iwYZ5dObhUcI90VOiI=;
 b=YNctUgf8dt27MHnsqHy7GGqQMGB0dlxnW6P/Hq8s5vrm9RNUkp9NGZkONE++kDxT7T
 U7jU4by85oPF1vJDzvJwcAfOPnBUCXR/zclJrHyu1tzh1u92lNkPlR2+3z46r1fq/g5m
 IrR+vuZMuPGO1P7fyyICYqnduVYU1NJ892fvjXVaIYRoHRNk8oW9bxZA4FBKwZq9Rlo6
 2kbyY3Q//P6GDLoCmbPwp3QW0XeFbfEviwnu6em2BJXwTLGoXEMAet88e90/JKRuOHLe
 XQfOh9mIVLfUWGpeTYNpES7H9flRB7wNdv6zktN03Bb8yauJt9FzGvVzjI2Xm6/jpVIa
 0tIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kGqJqM+WMCcTD3fT9OGAlv624iwYZ5dObhUcI90VOiI=;
 b=e4RVyVnEgQHsYR+tZb/6hMKfVOAY8hxbrpQbcD3U80xIwiH8ywwuvPhAxOGyDgISQb
 1Mb/mEiKJEVPiJjUwPAAfsZoJCsF0RnPsVIuU6rscl0vpx59DbX0kUZGTiOODqPhOxrt
 c0A9XI0e6SmDWSOoNW+uY4PDQG4grZ2k5a1W1L5PO/5wBjVa2ULcHx3u4kAfB24MOP5z
 EB/0V+t9/WhFR3uWggbbr3FnzBC69EvTg3tmhHbu5wOPiM9JI21Sl+sD2jRrRZSbREfj
 ve2e2FEfKlmIGinKexCXI3EmXsLt5sZ5/WjB2Ti14vsrrAi0//LC+hgD6p+lfs+zHGzg
 3wWg==
X-Gm-Message-State: AOAM533ZqSStF9hm9ty/dyYl26QuvYd6SktlU+KjOsJysWSTVnhmpfOw
 HodRoe7LBT2BZVkP3HuxU75Agw==
X-Google-Smtp-Source: ABdhPJyannuEzJ8s+cicyxOh3wgUmPKHSocFYoH2gsdTqcMhFGEpJUgFPRSxz6Y87UQnjYt6TxbX8g==
X-Received: by 2002:a7b:c246:: with SMTP id b6mr2773011wmj.154.1610445114219; 
 Tue, 12 Jan 2021 01:51:54 -0800 (PST)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id b7sm3938742wrv.47.2021.01.12.01.51.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Jan 2021 01:51:53 -0800 (PST)
Date: Tue, 12 Jan 2021 09:51:51 +0000
From: Quentin Perret <qperret@google.com>
To: Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH v2 15/26] of/fdt: Introduce
 early_init_dt_add_memory_hyp()
Message-ID: <X/1xN2UxiUxkzAiN@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-16-qperret@google.com>
 <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
Cc: devicetree@vger.kernel.org, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Monday 11 Jan 2021 at 08:45:10 (-0600), Rob Herring wrote:
> On Fri, Jan 8, 2021 at 6:16 AM Quentin Perret <qperret@google.com> wrote:
> >
> > Introduce early_init_dt_add_memory_hyp() to allow KVM to conserve a copy
> > of the memory regions parsed from DT. This will be needed in the context
> > of the protected nVHE feature of KVM/arm64 where the code running at EL2
> > will be cleanly separated from the host kernel during boot, and will
> > need its own representation of memory.
> 
> What happened to doing this with memblock?

I gave it a go, but as mentioned in v1, I ran into issues for nomap
regions. I want the hypervisor to know about these memory regions (it's
possible some of those will be given to protected guests for instance)
but these seem to be entirely removed from the memblocks when using DT:

https://elixir.bootlin.com/linux/latest/source/drivers/of/fdt.c#L1153

EFI appears to do things differently, though, as it 'just' uses
memblock_mark_nomap() instead of actively removing the memblock. And that
means I could actually use the memblock API for EFI, but I'd rather
have a common solution. I tried to understand why things are done
differently but couldn't find an answer and kept things simple and
working for now.

Is there a good reason for not using memblock_mark_nomap() with DT? If
not, I'm happy to try that.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
