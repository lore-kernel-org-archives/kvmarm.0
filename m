Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E870C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 14:24:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D5C965077
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 14:24:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D5C965077
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F2F4B380;
	Tue, 16 Mar 2021 10:24:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OK5z2hw1YUi1; Tue, 16 Mar 2021 10:24:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D55D24B3C1;
	Tue, 16 Mar 2021 10:24:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D24EB4B3C1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 10:24:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A2IPosUP0KqB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 10:24:45 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D26404B380
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 10:24:45 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id u16so10576600wrt.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 07:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=U1myjpduufIFHbOjx3MC14gmPXuJUxpXkD0h1tMVdZk=;
 b=orKtTHYuQ/AxMaqkOv5uEGAjqkfhFo6g71B5d/6YVdr5R83v71IWcJwyPLMm9hGeez
 vPAl9OQU798cfL3MGn+dQEq1TCDdtuF+jKCWZQZF69gyNntgvJm564dsGpGFzL0voXxM
 OZBuwXc66wy3w1US4kMx3uOfkQImgIf2NxFAP0MUgPZPlpN8LS51Siw4CuHU1L9VbdBn
 uFlARkm1AzA0m/KPYnKnU33GxnqUqD5qUY07eSXRySqXptvV7Zb7NKSuw1MD0mC807nw
 j80tjsCLAZikF/SHzJ9QOq3r5jZxRXAB79Zvd2zleCjlece3JSaX9MHqTp8TaUGmWPBU
 da8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=U1myjpduufIFHbOjx3MC14gmPXuJUxpXkD0h1tMVdZk=;
 b=IbBZA2WcCvUKciOvZYxnphcxVF5luZoY7fjUM0Dts7Fhbj6R0P3vK6rJvb2NrKxj37
 OsnVG2p4aU6xAt6Xhn318F9DFMB8A24wNWM9U3evUAgQvuGyWvHhlBufpFcnQQyHha7E
 KNDGHO2Wj5IQ/kDk39KS/m1HcI/MHkXY3swYrGtp6Mof4EQ07YRjxa11Zv4O1qz65j3Y
 Lob2QSnSr4VLjBREhO8dZlLq6+eK+KiyVnullEgfvtMjasGBQTHDXqblFVQ9mVGaLHOO
 D2+eYGbpTu4sxrr23vnITSdXPGQuUBO/RY4EdXA/Ozx/LISdTJBxjdNwM/BMQGYmiXgD
 +Ivw==
X-Gm-Message-State: AOAM531cHUYQAWqBiu3MVY1FDmIfHKl3Qt8SCvWq5bh7+HcQNqwhHltz
 ZUfybTfH7bioj5UHq1o2rdadng==
X-Google-Smtp-Source: ABdhPJyyMor4Qq/YcVIHZI9X70Br34uiGRVd4G+U5M+lj7mhFa3mulxofA2zCrgyj6FCxFn+sZd73A==
X-Received: by 2002:a05:6000:1281:: with SMTP id
 f1mr5274571wrx.243.1615904684787; 
 Tue, 16 Mar 2021 07:24:44 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com.
 [34.76.131.216])
 by smtp.gmail.com with ESMTPSA id v9sm22615975wrn.86.2021.03.16.07.24.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 16 Mar 2021 07:24:43 -0700 (PDT)
Date: Tue, 16 Mar 2021 14:24:38 +0000
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 08/10] KVM: arm64: Add a nVHE-specific SVE VQ reset
 hypercall
Message-ID: <YFC/pmzqSuXq+3+I@google.com>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-9-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-9-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 broonie@kernel.org, Will Deacon <will@kernel.org>, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Tue, Mar 16, 2021 at 10:13:10AM +0000, Marc Zyngier wrote:
> ZCR_EL2 controls the upper bound for ZCR_EL1, and is set to
> a potentially lower limit when the guest uses SVE.
> 
> In order to restore the SVE state on the EL1 host, we must first
> reset ZCR_EL2 to its original value.
> 
> Provide a hypervall that perform this reset.

Is there a good reason to have an explicit hypercall vs trapping the
host access to SVE and restoring in that event?

It's quite easy to do trap handling at EL2 now and it could let things
be even lazier, if that's any benefit in this case.

Trapping seems to have had a bad rep in other conversations but I'm not
sure the same reasoning applies to this as well, or not.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
