Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C370C4321E
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 21:53:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC1934BA12;
	Wed,  9 Nov 2022 16:53:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U4PD8VfCiGNV; Wed,  9 Nov 2022 16:53:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D20754BA17;
	Wed,  9 Nov 2022 16:53:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A283D4BA15
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 16:53:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MKiCm7shPHfK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 16:53:50 -0500 (EST)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E6224BA12
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 16:53:50 -0500 (EST)
Received: by mail-pg1-f177.google.com with SMTP id r18so17334077pgr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 13:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=OjtTll63kEDv75PwR7o0lnOxIMI339azC+QX7bn1Io8=;
 b=ZO89qv+qCkNp/HiQ4Q6ZJHGSsutpkVQ0xhTCiLfOk0GkhfFmwFuMtZN/Ed/uuBdDsm
 b4X5XeR59abjiW7lNZ1Z9sR8LJFUsx+a9B2SHUeRRp6/cYrXLpoetVMHXFuCgwZAQnqE
 pZ/BWXqM7bIWHIcqAXTSDbjGG1ERbeFNTk0Y4PtVgfNcm9PuSJ9sfiFrUcEyBLE9HlM8
 QkMLkRFVrLYk5OZ84sNAclJOw5/83UK4EKX6nFYv+wTNUyqxRuFtrezzGGJav2rHU/CN
 Zf6bz4ZbCHT13Hi9brY3D91Fmcisb7qCwzTNns0F2mJxXzQkAu6FEZ58AeO8lHDoc3Oi
 RJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=OjtTll63kEDv75PwR7o0lnOxIMI339azC+QX7bn1Io8=;
 b=Bj2ULUImTusOkb1HaazXSC3uJFzH2MVKut+AZjkn0cNQJ+KcgvPr+JsJeW3IPc+wgp
 1P2ZivQXjyII/mPEQSqjLY+RJx/ya0PH77utAIPQ+IgwOKpnnAuRXLC08foCg+FFYQQh
 dRhL7njXwemEXI8K9WFlf11lbN9jkJ9bJOd9DuHkoGovm/TYHbYI1BKccI5+R06G4yOZ
 y8Y4FFoL/xdGqYqA6uYQ8gWkAAAQ/TwKaw6TTtN0MXCYMX2WMsTu9J/u6t3Fk+2UkTTX
 jg1Zv+zKZEe30NEyYHFJuhr7CeuXnJEiaIFPMTEKAUL7ISKyXpW6DRTTTrRCXEB9NHDu
 +E2w==
X-Gm-Message-State: ACrzQf2ZCS0rHzI/ABH+UYvMjxScmzcV7MENU/op+TF08pJbDdCazJNs
 g/XVoQ1xsv64k2A7ETd31AB+5w==
X-Google-Smtp-Source: AMsMyM405OCKBpJo33fzWng4KuCQaVeCIAwiX562TxX4BcFcitQF+k78e7DEu09G23/oE/uOT0+mjQ==
X-Received: by 2002:aa7:859a:0:b0:56b:d76d:8c76 with SMTP id
 w26-20020aa7859a000000b0056bd76d8c76mr61634658pfn.77.1668030829526; 
 Wed, 09 Nov 2022 13:53:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 j12-20020a170902da8c00b00186b04776b0sm9672086plx.118.2022.11.09.13.53.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Nov 2022 13:53:49 -0800 (PST)
Date: Wed, 9 Nov 2022 21:53:45 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2whaWo3SIOOMKOE@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221107215644.1895162-9-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
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

On Mon, Nov 07, 2022, Oliver Upton wrote:
> Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> release the RCU read lock when traversing the page tables. Defer the
> freeing of table memory to an RCU callback. Indirect the calls into RCU
> and provide stubs for hypervisor code, as RCU is not available in such a
> context.
> 
> The RCU protection doesn't amount to much at the moment, as readers are
> already protected by the read-write lock (all walkers that free table
> memory take the write lock). Nonetheless, a subsequent change will
> futher relax the locking requirements around the stage-2 MMU, thereby
> depending on RCU.

Two somewhat off-topic questions (because I'm curious):

 1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
    faults (handle_access_fault()) and/or write-protection faults without acquiring
    mmu_lock?

 2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
    for the RCU-less hypervisor code?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
