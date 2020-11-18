Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CD3C63777
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 09:25:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD1B22467D
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 09:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="qsrid+z+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD1B22467D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B064B5B5;
	Wed, 18 Nov 2020 04:25:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KxwY4rogcrJu; Wed, 18 Nov 2020 04:25:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B01EB4B5CC;
	Wed, 18 Nov 2020 04:25:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A58C74B5B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 04:25:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zfrOJDFwbI8e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 04:25:52 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D1104B5AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 04:25:52 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id 1so2019087wme.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 01:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=X6ZFH7heqse89aEGvMmhzcbSi20z75OlSQMAgPLbESY=;
 b=qsrid+z+rmZ3dQS0wbdI0bNgj4M5MSLp+gEMgXV6pD107XERnbrCeb4fuwBhnXhhMC
 KXHYWC1kNKIJwZf7/xLoXfFqgCbE7c7yJinhL5z2ssGTC0kKTYOLhj2uVu+wJGWo5dvF
 bKfxyw2bfxI+GEnta7thOy7XNgPTU7LaBgO2AVpLbhmzaG4wPNFDr2QN527GIGPTo0Q1
 3jFoNmlWzG5xyLLI4l21CFDARG//t9l5aIqjFYnqj8/1USJfj1/jNHLBXFv2Zbu82e2H
 bDyce1abLLvAKmygjJypUQPKmCk40uitrOiVVix8cWwFTz6HsQiLudWBBn5aw365LAWr
 1Ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=X6ZFH7heqse89aEGvMmhzcbSi20z75OlSQMAgPLbESY=;
 b=m9JSgFRkn6cR/IPEwNq3Woeu0lhYRXR/s7EEqSUFd278BpsUPES6b4gXOCp3z89h+C
 RD2rtKEZ3xJUTx4MSjhDhePpZiCMwAiS/ArtrXpTp8WwDAwqPYkZnJyBZ1aSHuqI7eJj
 LHVV3+eQyiClor7KI+qMauZ83rm/CmaiDVvtTlR0riRsUkAl67qt2ZlrcNE50M8CQ9N/
 APACYjWSRuYjKSxnMfM40fVjyBVngg0FptLz06Z7vjajHt6Zi9rZpjMmn/sWtHhOMYw6
 fOwHesLTXURR63z95O1h7LsRO77gJKT5JYyKzPKQMZQayTv0CZd++rSTKRC8LPDcTxYt
 Uxng==
X-Gm-Message-State: AOAM531wMKGcDLKJvGcpYJJxhLE1SnXddB9bQNLReSGAYZXbXOnFTfcp
 niRRoJtetYr4YWu8yd/IQ3t09Q==
X-Google-Smtp-Source: ABdhPJyzHPcv8qy3yk+iw5C1CfQhs0U063gy6g1/i2mGk7ekBPYQXw+3gsJbk8sWoUnBUh/4KANvSQ==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr3370259wmi.124.1605691551308; 
 Wed, 18 Nov 2020 01:25:51 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id t136sm2716518wmt.18.2020.11.18.01.25.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Nov 2020 01:25:50 -0800 (PST)
Date: Wed, 18 Nov 2020 09:25:47 +0000
From: Quentin Perret <qperret@google.com>
To: Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 15/27] of/fdt: Introduce early_init_dt_add_memory_hyp()
Message-ID: <20201118092547.GA2031536@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-16-qperret@google.com>
 <CAL_Jsq+xAy9+HjH6vqfmaAEKBe9MMm+wWvUtiz5dFnHmMneqNw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+xAy9+HjH6vqfmaAEKBe9MMm+wWvUtiz5dFnHmMneqNw@mail.gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
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

Hi Rob,

On Tuesday 17 Nov 2020 at 13:44:53 (-0600), Rob Herring wrote:
> Can this be done right after we add all the memblocks using the
> memblock API?

Possibly, but the thing I'm a bit worried about is the way 'no-map'
regions are removed from memblocks early on.

The EL2 object needs to know about these parts of memory too (and in
fact we may be able to enforce the 'no-map' attribute at the host stage
2 level as well). It's also possible we'll need to have portions of the
guests payload preloaded (and verified) by the bootloader into reserved
memory regions, possibly no-map, to make sure the host does not mess
with them in a normal use-case. So, I couldn't find a much better place
than this one but suggestions are very much welcome.

I'll have a go at the memblock stuff to see if I find a way to make it
work from that angle.

> I thought EFI would also need to be handled, but looks
> like it just calls early_init_dt_add_memory_arch(). That's odd
> especially for ACPI systems...
> 
> I don't really like putting what looks like an arm64 only hook here,
> but then I don't want an arm64 version of
> early_init_dt_add_memory_arch() either. We're almost to the point of
> getting rid of the arch specific ones. But I don't have a better
> suggestion currently.

Ack, the ugly truth is that this is likely to remain arm64-specific. I
figured this was simple enough that we might want to consider it,
though.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
