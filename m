Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127B6C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 14:35:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E15423436
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 14:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E15423436
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7164B165;
	Wed, 13 Jan 2021 09:35:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WgGaPpor5lkT; Wed, 13 Jan 2021 09:35:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 191294B164;
	Wed, 13 Jan 2021 09:35:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B71A4B164
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 09:35:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t5CxW9K-slj7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 09:35:04 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B01114B161
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 09:35:04 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id y23so1807954wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 06:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=k8M4ay0pyWeTUsp8VTnmXaOTFerFbqdBD2/I+a5rVXU=;
 b=QRj1w8Zq8rESBoWrOk4jhvDSx+r0QWDtuf8GtQvgUpnFqBkcPHdTvb7c85hHF2l7cc
 qDKLJjq9Ii0ShbvDAU8iPTjVj20pMzOpAmpTWPBPhfpw7RQO8ZxSx4EUM8mZsSiXOwQL
 mdSHwkiWfb6QKpJX/SX1f5FrqdKK38gVDw2QhYa4LBWQ5jOkpmSnlu6QgdD7PLAOsV1i
 pjdicHccdwcNo3H+EHeD0jh7OVRjagkZ/8yX0F72Uzi/JeXwMnfHry8HzfWpKUBOJuAj
 gvO7/YEvY/bLsnuixLd6a0UD+ErWYadkCVa8OGxI4YHgEEgNnjV4lTOzzUhdH+UO71MZ
 81gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=k8M4ay0pyWeTUsp8VTnmXaOTFerFbqdBD2/I+a5rVXU=;
 b=oaIgXgOwHXoDqiithXHKIEY7wzuXYlyrbwSuPVw2LbLkUzvqg+TRlwr6LEHgm8lOuZ
 fOtnmaVGYyiIgcsn8cSHshzT3zZd9HZMu7cv31jpm/0TNZjwAeBkK4RrDdLHrXfFqzSY
 3ky1fgEA+x6+6Q3VrFoL40j2nzA3vFoIteRa7ZiueWcbSgGURYwwBEE0qBB8IDtMt+0G
 CBLzczZtDLMnr1cK01D4s2iJNomYV1EvPcEjQkwpXFOq1P46xWEBhdUKImi+m44LGNMP
 /lKS8ZDW8SDoMANyGfllzP55gaCuuzM+XYcZYby8JtQ0/hUr9YvsQmAMySRGspHr159a
 LU5g==
X-Gm-Message-State: AOAM532rdOkGA67h5GdQvBVB6PIhTUD+/ZjA18dp/dpy5Om+A7dVHxlC
 cSai/RxzBm0hqNF4Ympz+yQ56g==
X-Google-Smtp-Source: ABdhPJyeEFIkF9DIJ5QpLZTm88kYBUJZLogYBqCXhodFTAckts1/BoAtWv9HKHGKxjjjbk2k938twA==
X-Received: by 2002:a1c:7f83:: with SMTP id a125mr2516711wmd.86.1610548503499; 
 Wed, 13 Jan 2021 06:35:03 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id v7sm3410751wma.26.2021.01.13.06.35.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 Jan 2021 06:35:03 -0800 (PST)
Date: Wed, 13 Jan 2021 14:35:00 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH v2 13/26] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <X/8FFKOLOVD9Ee2F@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-14-qperret@google.com>
 <d55643ea391f73a2297f499f3219ba8a@kernel.org>
 <X/8CR5eXGGccFjaL@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <X/8CR5eXGGccFjaL@google.com>
Cc: devicetree@vger.kernel.org, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
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

On Wednesday 13 Jan 2021 at 14:23:03 (+0000), Quentin Perret wrote:
> Good point, that would be nice indeed. Can I use that from outside an
> __init function?

Just gave it a go, and the answer to this appears to be yes,
surprisingly -- I was expecting a compile-time warning similar to what
we get when non-__init code calls into __init, but that doesn't seem to
trigger here. Anyways, I'll add the annotation in v3.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
