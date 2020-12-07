Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF54C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 14:17:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17AF1235FC
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 14:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17AF1235FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE6F4B27A;
	Mon,  7 Dec 2020 09:17:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yr8o1Hdnv0is; Mon,  7 Dec 2020 09:17:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C9034B1AE;
	Mon,  7 Dec 2020 09:17:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E614B183
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 09:17:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8lvKeLV0cjWs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 09:17:10 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97FC24B150
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 09:17:10 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id 3so13751005wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2020 06:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kpILaO0BvUDEaamvD3auxRaFopgV8/tde37CbHQBxLo=;
 b=V3KQF6vAE2qBEq0iO2Z1ORNELzls6FWH3ugS+2WBuDcDgLaAKTSFcwgtqaorc4ajKH
 hUHkGlRE61kQLwKfV/ahdjDCJ7ypio6hIYUB56dv+mAkLUSVmUzXr8omti53YG0uzOCE
 4t3ImOSvgcIJNzqhhO/loymajzZm3ySqXjwjQYDSP7FE6XqNtDFckzrf5CQbSp367zOQ
 00eBHCu4uNZTxd6pm+8ucfsNaHCjVwofHvKaVhm6Owr2NM2eQsw+syFF75ZXXjkBg/zQ
 prHdzvGKPqauKwmgNZ/gTPas2eIBgel+ZlSsg3jY3cVHjeyWr610CR5eBDnwgYB5SFix
 SS+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kpILaO0BvUDEaamvD3auxRaFopgV8/tde37CbHQBxLo=;
 b=aFk8E+04gPBGmAO4NwKVu06Crw9lfKdGL2evNYnhJav1D2cqH2hk7UrYHC5fkCjSnw
 x2uyWQK8bv9Mf0iSRG+haR+oSjAWcehsyXR2xfFDoKIktLLcrA9gtU8hk7yXMGAMub6u
 qAdlyCCpBi5ha2C5IMbdwPZ/OKI2ZwjNFseDYDrvr1welLREogJ0ozOv5RgaMesBem51
 UMnV3wC3jA49S1X/CD053IdhOnxjL+nHpVHt9yntbXlcOIH+IMgEd/Hm4+H//BrIEQBi
 YZsteFfwLBFIgHQ/zZGeiRNHQIowII208740KSRHWq+b4l0hj88Dza8lK8YpZsFhsvvP
 y4yg==
X-Gm-Message-State: AOAM531wIx95u8d/zTJ3eBl+MfZm0GhFW1Q+INgahidcqjhemR8I9wjO
 r17cvxdoCSXVUpQm8x/M8anhNg==
X-Google-Smtp-Source: ABdhPJzJBMkWIAniHhwGekiItn1n3GcOUh0z1Qlh+dQe+IC2XxS+ZCQILeol3+1m4x7UDQHqENdlmg==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr18529183wml.33.1607350629505; 
 Mon, 07 Dec 2020 06:17:09 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id d187sm11690076wmd.8.2020.12.07.06.17.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Dec 2020 06:17:08 -0800 (PST)
Date: Mon, 7 Dec 2020 14:17:02 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
Message-ID: <X845XjjQ+s/NB7A9@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
 <X8p5kLSIq2MoQZ24@google.com>
 <CA+EHjTxW_z-P8bK7gCjGv2eBCAHFsvE873Gr2KyVq5-+_Mdv=g@mail.gmail.com>
 <X84Y07kbeSL4xcNJ@google.com>
 <d6a674a0e8e259161ab741d78924c756@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d6a674a0e8e259161ab741d78924c756@kernel.org>
Cc: "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
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

On Monday 07 Dec 2020 at 13:54:48 (+0000), Marc Zyngier wrote:
> None. Whichever name you pick, someone will ask you to change it.
> Just call it Bob.

:-)

> What I really *don't* want is see a blanket rename of existing symbols
> or concepts.

Understood. I'll go with pkvm_create_mappings() and friends for all the
new functions unless someone comes up with a better name in the meantime.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
