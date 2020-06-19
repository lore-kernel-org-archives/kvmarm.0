Return-Path: <SRS0=kKHV=AA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C1FC433E1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 12:11:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFE7A206F1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 12:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="aAA1aFkx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFE7A206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DCF64B176;
	Fri, 19 Jun 2020 08:11:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Mccx+t9n37m; Fri, 19 Jun 2020 08:11:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F4744B0F1;
	Fri, 19 Jun 2020 08:11:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7510B4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 08:11:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pPWyzSFiZ7GZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2020 08:11:10 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CE8F4B097
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 08:11:10 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id l11so9485072wru.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 05:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uw1fRJk8W9uzHYW58SXoTwxg2AWOnCyPtVa0nujwxNo=;
 b=aAA1aFkxA985YEVfjLAPiKf66EhzPWckcNx4xKon5snQWNwK/YtUsVhxAr8entll5J
 FqpecJvgTmxRT5+MvuHxJe9wSNpmI0nvvrBzF3a6gi+LUIybTOg+JYdbJqT0dZYlFxMk
 KKN+iSVJrEIms+E2BI5fXbNWVdsb2j9/Lm4zmMbjwR4aASLWSTAHS8bjK4ndoX9Radrz
 tAJ9VVNEEMY8zPNBspED7etWgK9KAxQVfeSI4+eLeelOpXXdGi5OUzXSQ1/NP3AapKjN
 3YhofK/HVDX+bv/bUFdvGIO34LjDkJ5lop0TmHsA2yBXmfMLzQrW56prXHQF0G2R0N+F
 /h3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uw1fRJk8W9uzHYW58SXoTwxg2AWOnCyPtVa0nujwxNo=;
 b=tBSUwZ6+o575NomGzdO3FVw56T8KQQDZEUNeswtwCGjqRmLotb7+M+hdE+uWlqwjNu
 qAZsDB56szwmHM/PVzYLMSKuIrjAi0pvZ7kwh2RmVvVrLJmkR2M13UTez0RyD15wJOsD
 gOVNjz+sAD7atnF5EgK/eCfhpl/AYC7k/VcLEWqnF/MntyKLRiGOUdhnLS7tAFSDlcmX
 xIeRH/iyIGeubXoWrRNmYBZ4JVEFByuproYfKF+5iurD5UecR3NU05mHi16HxjPKy16i
 OTJr2cfn5r580RuaNuY/O8tH/5n6xiXXIU+pZVhkVDfmA9o8982IDzV5v8Nsx5e5AHTq
 XkWg==
X-Gm-Message-State: AOAM531vGQnF+NtSind0YiisRJBqt+DnKh+AAI/VIGXRT4m86lVqrggc
 FyVFKeDoid5un8gKKZZI3kPbhQ==
X-Google-Smtp-Source: ABdhPJzXf4aN7gKCGZYXPOoqVI1aLeO650Z1tn89qTbHzCNLC55N0Ab6rAbplKt8XgQAxTgA+V7Dkw==
X-Received: by 2002:a5d:4282:: with SMTP id k2mr3727602wrq.196.1592568669243; 
 Fri, 19 Jun 2020 05:11:09 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:d994:d48b:4a9:7c2b])
 by smtp.gmail.com with ESMTPSA id l8sm6886721wrq.15.2020.06.19.05.11.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Jun 2020 05:11:08 -0700 (PDT)
Date: Fri, 19 Jun 2020 13:11:06 +0100
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 03/15] arm64: kvm: Add build rules for separate nVHE
 object files
Message-ID: <20200619121106.sz5qxxkb53ida5qa@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
 <20200618122537.9625-4-dbrazdil@google.com>
 <09976ea31931481f4e00d627dc5e06fe@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <09976ea31931481f4e00d627dc5e06fe@kernel.org>
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

Hey Marc,

> I guess that one of the first use of this __KVM_NVHE_HYPERVISOR__
> flag could be the has_vhe() predicate: if you're running the nVHE
> code, you are *guaranteed* not to use VHE at all.

Sure, I'll add that to the next respin. If I'm reading __is_defined correctly,
it means I have to define the flag as =1. Easy.

Thanks,
-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
