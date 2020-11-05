Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC57FC00A89
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 11:05:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA5C020782
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 11:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="AYd2XxNy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA5C020782
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EAFA4B7FC;
	Thu,  5 Nov 2020 06:04:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HMDCMFrsGrQo; Thu,  5 Nov 2020 06:04:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4368F4B7E6;
	Thu,  5 Nov 2020 06:04:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA4384B722
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 06:04:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qAM6hCSjaaEs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 06:04:55 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA54F4B71F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 06:04:55 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id h22so1175909wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2020 03:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=122idc9ISzYUVyUTZxvj63kGf6qbL9E93JAVHSUYL5E=;
 b=AYd2XxNy9cevjTd5a9GWeI6c3UkIp+hfXlb81qU3LLyhlfpYBMPQeFuUFrRxGJiE/b
 hbzJiB1uhqyhYBuvVxRMQoz84h3qrKYEiUi8EQE1p9xbmZmf1cUK0oJglUKfEpDOPVTG
 UlJRyY5W+PhXM0/UUU0jUWEkA03sZMtCXRn1RmieN1Qid7ucRGZR2sxYXmVLa37b8APn
 t9uCN3tklmqFYC1u4TJLK7BW4hiQvmGuU891iKbJIhv/Z+5zwNY9Kr0Q//kuZRMJDXEL
 hB/NzXHCY44H5EDVI+GyC5OrXgWssnWs0Z3iT4+JAqYK4Z8jqVe3e1zUDlzHH1KKjIlJ
 oGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=122idc9ISzYUVyUTZxvj63kGf6qbL9E93JAVHSUYL5E=;
 b=m+iZ0wpimdIGVyOr/PPXJ1gUmvGCz3v/tYyge2PS/Aa6Kzo+9dt0SGcSIiZ8aCRlVc
 DR7v+dcGp+v6WRJB75aM5XLHF8CPebw3ANcrfPKaCD/GUriOYLKZR+VZDeAAhRmwxLOV
 qIDzpl4O2CWK2jKByrv4sgLWmsRBArtJMWydDySoNFa28AO8lP0nPKYx4vADTY+uPEpy
 V4mDFde31TrcbfDkoaU5YQ7IaNR6PeKCSGtDuprqvsjglNaLL663r8++h8P8w0aTLXe5
 RdQS0xREQSD7DQQdI2XHUVGoMBhCTEEs8K/gQIDAhBcODv9xvO/KAVqYxDXrnBJ6sSmX
 cyNw==
X-Gm-Message-State: AOAM533fJMUJ3AOlKYasKqc+EQFbbvCCnFqcvlFG8H80wMC04x/MJppj
 i7hcifgt+CL2AGSXVsUnKLzYnA==
X-Google-Smtp-Source: ABdhPJwDkxXA6NnnBuUAc9HIvD0y2HJ2+YaH0fpN0/rXlsl/uP2RFH5TYMmqQ4jC+tOsJPAgxuY5wQ==
X-Received: by 2002:a1c:e087:: with SMTP id x129mr2090930wmg.2.1604574294545; 
 Thu, 05 Nov 2020 03:04:54 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:64da:f1d0:8ee7:66f5])
 by smtp.gmail.com with ESMTPSA id y185sm2168277wmb.29.2020.11.05.03.04.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 Nov 2020 03:04:53 -0800 (PST)
Date: Thu, 5 Nov 2020 11:04:52 +0000
From: David Brazdil <dbrazdil@google.com>
To: Andrew Walbran <qwandor@google.com>
Subject: Re: [RFC PATCH 23/26] kvm: arm64: Intercept host's CPU_SUSPEND PSCI
 SMCs
Message-ID: <20201105110452.3ulxvaywgbqa6ilx@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
 <20201104183630.27513-24-dbrazdil@google.com>
 <CA+_y_2GgF7W8f=_3Y+-Nyb+JWTCqCvtE7OT=kabAqxnp6vLnOw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+_y_2GgF7W8f=_3Y+-Nyb+JWTCqCvtE7OT=kabAqxnp6vLnOw@mail.gmail.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Android Kernel Team <kernel-team@android.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

> > Add a handler of CPU_SUSPEND host PSCI SMCs. When invoked, it determines
> > whether the requested power state loses context, ie. whether it is
> > indistinguishable from a WHI or whether it is a deeper sleep state that
> Do you mean WFI?
Of course, sorry, just a typo.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
