Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D426C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 16:46:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E134B290;
	Mon,  4 Apr 2022 12:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ziepe.ca
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f6FMs2a56L0m; Mon,  4 Apr 2022 12:46:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 090234B2A5;
	Mon,  4 Apr 2022 12:46:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7978E48F9C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 09:24:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id In6wyFJuhu5h for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 09:24:08 -0400 (EDT)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ED8B49E46
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 09:24:08 -0400 (EDT)
Received: by mail-qk1-f172.google.com with SMTP id w141so7555313qkb.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 06:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ziepe.ca; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Dj909oRaNRb7301+COOAr97OsAL18eivV1Pl1t4/Y+Y=;
 b=R2BOiI73bs4bhzycM+H031R9LnpSNDl9hKlfXb/Dsoc/YoMnaNNRKuQM34krIxm7bA
 UdsRcGSrXdyKB/quZlwiHCdQaKXaV+f12rnrSF+IMmSYVRVeRgWOr1Rs7fay6xmOVLY8
 gSTwID3IsnJpPaf4UShy9BcWjNLRqILCMZ+ILJ3BbBwQLna9/74cnfwKsp8+RXQ6WYz9
 dITlk4nDyLpanZaCHbh4P8ed9NWhbgc+yoMtAyXPlBDSHqcsPyowJ4JOOSG3rDrQZvfw
 sFTcXv/Ie18QUyJRu8j5PZ+bBcdiGYnl/hzo2dqUc/Yc3Pwe1Ut+ImfYz41fTLY4VEPS
 sT9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Dj909oRaNRb7301+COOAr97OsAL18eivV1Pl1t4/Y+Y=;
 b=G91fERIQbEs6uvhSpMj2ALLGWjR79e1hbKy/pa1RNzK2aU0L5cQoBA3FvXomPvFJiJ
 nJ0bPogX3JTBuXovZXq7UMpPvCMHRd5Rmcq+gwLwt3zXdOH0bSo+sQkAt5+lw5EmF1x3
 jC+Q4/kb5ZNT4rtsgGV5EU2L+VymGWc1foDD6PSIhI1f1yLtdAPX1MQSydNOeqrM6lQi
 81po13Hkp0SRehCyXhSkfMlcw4rPIwDIIdfVyDPCM3kAHlIpxBIILkS2oWjW2kmXLx7m
 k9lV9uVzeT1srA3cbektKUZ1OWxnmiuWxWud7YAuVJ3d6ZDvXxJobWREdhkLZ4qMeVrH
 aERw==
X-Gm-Message-State: AOAM530awEKTqjXc2VaKTkAvpSizDDbTYkbgyd4pDsg2jIfnmEn8UQ9y
 KRMoPf/2lCF9ue9FN3PNvyOOUQ==
X-Google-Smtp-Source: ABdhPJwd0cXQeoez8xJ261ZBrwRTk36GjcX534AnDsLUP+ScvuOwmJyyalnuuG5orGBA0Q0zQDNBsg==
X-Received: by 2002:a37:c4c:0:b0:67b:2b35:762 with SMTP id
 73-20020a370c4c000000b0067b2b350762mr13415114qkm.6.1649078647740; 
 Mon, 04 Apr 2022 06:24:07 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26]) by smtp.gmail.com with ESMTPSA id
 d126-20020a37b484000000b0067e60283d08sm6476475qkf.40.2022.04.04.06.24.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Apr 2022 06:24:07 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94) (envelope-from <jgg@ziepe.ca>)
 id 1nbMgf-00CAIu-Pe; Mon, 04 Apr 2022 10:24:05 -0300
Date: Mon, 4 Apr 2022 10:24:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] kvm/arm64: fixed passthrough gpu into vm on arm64
Message-ID: <20220404132405.GQ64706@ziepe.ca>
References: <20220401090828.614167-1-xieming@kylinos.cn>
 <87tubcbvgk.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87tubcbvgk.wl-maz@kernel.org>
X-Mailman-Approved-At: Mon, 04 Apr 2022 12:46:48 -0400
Cc: sashal@kernel.org, catalin.marinas@arm.com, linux@armlinux.org.uk,
 linux-kernel@vger.kernel.org, xieming <xieming@kylinos.cn>,
 alex.williamson@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Apr 01, 2022 at 05:48:59PM +0100, Marc Zyngier wrote:

> NAK. For a start, there is no such thing as 'write-combine' in the ARM
> architecture, and I'm not convinced you can equate WC to Normal-NC.
> See the previous discussion at [1].
> 
> [1] https://lore.kernel.org/r/20210429162906.32742-1-sdonthineni@nvidia.com

We've had a lot of discussions with ARM related to how this works with
drivers like mlx5 that use WC.

ARM has now published some guidance on this:

https://community.arm.com/arm-research/m/resources/1012

As an ecosystem we seem to be drifting toward Normal-NC for this
behavior (largely because it is what Linux does). At least that is
what we are testing and qualifing ARM CPUs against mlx5 with.

I'm guessing it will turn into a SBSA like thing where the ARM ARM is
kind of vauge but a SOC has to implement Normal-NC in a certain way to
be functional for the server market.

Jason
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
