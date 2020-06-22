Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E32CC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:20:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA9F1206FA
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="rfeS1Uw1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA9F1206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 052BB4B0B1;
	Mon, 22 Jun 2020 06:20:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id POS6vEYXIWv5; Mon, 22 Jun 2020 06:20:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65A154B0CD;
	Mon, 22 Jun 2020 06:20:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E15374B092
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:20:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZcsTzCrXiN4T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 06:20:44 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 742484B085
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:20:44 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id g18so7011671wrm.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 03:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=K1WHdNmDOX4BgFR//IfTLKehGJqrVesoSzoLydKqUHI=;
 b=rfeS1Uw1taWTRr/Gdwzfa6fudxK3gOylCvzERoZh1LAyDoT0O140GcXF/e7MRNtajq
 TewuP/PkZb6EC7OwWRUnw8dQxV0sOAP/6KM2moncHL1bnUWyJTr8H7oWsqAPi6va35V5
 UnjwUNrokqE66FBwwmX4FpsSoSyH2VLSmVxNVO9zSzb+KLCaRPuwo2LSI+6gkr2jO25I
 dpFzJz0MS7ZPrZNfY+z4mvucVmiO9xHNhHPTZxD4zXDYspek63rfwrnneDRWR9ngbdCq
 2Mxo/BU4atCUa5f5+EaFwoMj/AbhFN3tTTrAgBYhmYt49EiHyRunOWpRFh3Qgd0TG6OD
 /7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=K1WHdNmDOX4BgFR//IfTLKehGJqrVesoSzoLydKqUHI=;
 b=auGwRZ5B66KQ9bmtRuHSZNXfvJ+fLAaYDnNSnvPMYvy3YW4OP8SSONmE68IYdF7R8i
 lVISc25LOHBB7hxJUl4WsTucG3kpM0qgvEVpbcYGW342SxTLyububUnO364DTdPgkgXj
 0ICZ8k05NHO0M2/WD+e3wtmT4YQIpVaHLbsIUrGffqmZbNdZi/Z7ZtlVMGSzZPFj3r81
 pHp9LPEqn1/gMHqyfN6yqmtAYEZf6wXttTpvsZKOw4tXQgbwNtwwoSD/6i1PAUOt07lr
 WjAHx981PdkOcyy53tXyQSqZkFXieHRkSDfbSMyBpk1Q6ADvlelw4BX+IQhk4WrCk4b+
 zBFw==
X-Gm-Message-State: AOAM532zivn6TYfFEk3ivVgKuIVayyEGuZ3oe3cLp6R64Cdu+dJ4E1Wt
 1DHAIt0dKVlKUIt/Y2aznyAYDw==
X-Google-Smtp-Source: ABdhPJxa46K/Mbvsrk+5fxMUoe4KQE4DGTtB9HnW10GAVrdSftQMvPpwxbTt0fQruBPFR0WjoekYug==
X-Received: by 2002:adf:f542:: with SMTP id j2mr3995338wrp.61.1592821243187;
 Mon, 22 Jun 2020 03:20:43 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:49d8:6d83:2bcd:21c9])
 by smtp.gmail.com with ESMTPSA id j41sm18213045wre.12.2020.06.22.03.20.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Jun 2020 03:20:42 -0700 (PDT)
Date: Mon, 22 Jun 2020 11:20:41 +0100
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 05/15] arm64: kvm: Build hyp-entry.S separately for
 VHE/nVHE
Message-ID: <20200622102041.myve2otyoj5q7j5s@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
 <20200618122537.9625-6-dbrazdil@google.com>
 <5029f8fb4a7816e11de7469c09347c79@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5029f8fb4a7816e11de7469c09347c79@kernel.org>
Cc: kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hi Marc,

> > -	void *dst = lm_alias(__bp_harden_hyp_vecs + slot * SZ_2K);
> > +	char *vec = has_vhe() ? __bp_harden_hyp_vecs
> > +			      : kvm_nvhe_sym(__bp_harden_hyp_vecs);
> 
> If we get this construct often, then something that abstracts
> the uggliness of the symbol duality would be nice...

Agreed, I do hope that this will end up being limited to finding the address of
the hyp-init vector once EL2 becomes self-contained. Even this vector selection
can be done in EL2 where the symbol duality does not exist.
If we were to hide it, there is a trade off between code "elegance" and clarity
of what's happening under the hood. I was thinking we could extract this
`has_vhe() ? foo : __kvm_nvhe_foo` as a `#define foo` but I do worry that
anybody debugging this code would be cursing my name. It would also not work
with other macros that take symbol names, notably kvm_ksym_ref. But that can be
rewritten to accept a pointer instead. The more verbose but less magic approach
is to have a bunch of different helpers for various situations, eg.
__pa_symbol_nvhe. What would be your preference?

-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
