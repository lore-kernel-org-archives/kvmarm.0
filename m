Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DCEC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:37:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 320E6613A7
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:37:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 320E6613A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4D054B133;
	Wed, 29 Sep 2021 09:37:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A4sUeQP-AYiI; Wed, 29 Sep 2021 09:37:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A784B11F;
	Wed, 29 Sep 2021 09:37:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6684B0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:37:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GASW+CEHaBgX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 09:37:45 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D28A84B0D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:37:44 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id s21so4313591wra.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 06:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GQngVFrcSLt3738tom0raKa/V+AyipPcvJvJUkznr8o=;
 b=Sb8vISEBHGBaDEV7cQFVHvQeXaw47giV2fPWGnOdgbplmnLy+Ycj6u1WIDNRGDsR2l
 7dQ57cJ2X0xfUHnT8RpOk5DB71L4xb80F2L63SSs2WW6X3mtw71lrFdpwEbRSN9f7/Wg
 nXbhesNfJgMcvnruu3JAKXlAE4/z48pC3iDiyc/29BQ3ecEn3xTPlAJG7LPr9EUEQZiB
 tRu2eK/6PoEPojOEcS+8sLahbrorHywurQy1lx6h+Y+4JYxw+lKS8qINu+SWYx/OAS5M
 91QzE8SF9NytVtZAZzGtl4VzQsYp3MOXiGY5a/UKlBB47lv46EMRlxNac268k1SDQ98/
 ZqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GQngVFrcSLt3738tom0raKa/V+AyipPcvJvJUkznr8o=;
 b=xc35ieNkIbCoYNs+1+yextWrmqsGDHnoSEH80sbZFfsLWbQbWWhROlj3OiZnffUJDk
 eDF5mRqkEAnEg4eOTrsC3MWfsfmPKJo8mZyUneFBeSXkTBmUqrK7z/adJfXaB7dYalPk
 xspQR23aQjmHkBSW/8s2G2ESgyTx/A1J9Esc78n5JDPZKayZG3555Tgi3NQxNKz5gqaX
 DYBbJt36Xp4A5Y42YplhDzoGVWH/35GnG+t6THuJ1OmyOiyfVcdub5/EQ1bQ5pYdE+4p
 TNz/5T2tiqT2AcHrDhAscGdeVB8Ifp2RSCz9WveeScvIkKktkv4dB//gCWyYt7KKeNrQ
 p4Fw==
X-Gm-Message-State: AOAM5308sqFurmjYFkYLLLcyDrp0JPpn1eWP7mzcpJaD8/FfrOX2WxUo
 Ss9mJwPX+s/54UzGVvlaai/XDw==
X-Google-Smtp-Source: ABdhPJyUsyDaeAJIw09c6/ICrEZ1hJdgcEoeKOJbnbHV1QOQ+ACfduyIGWrR/uKyoe1BvuBJ5kIr3A==
X-Received: by 2002:adf:d1c5:: with SMTP id b5mr7082197wrd.252.1632922663834; 
 Wed, 29 Sep 2021 06:37:43 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:1ebb:fd0f:cf53:11c5])
 by smtp.gmail.com with ESMTPSA id a63sm1640423wme.18.2021.09.29.06.37.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Sep 2021 06:37:43 -0700 (PDT)
Date: Wed, 29 Sep 2021 14:37:40 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/5] KVM: arm64: Reject stub hypercalls after pKVM has
 been initialised
Message-ID: <YVRsJNAwFytnmqTR@google.com>
References: <20210923112256.15767-1-will@kernel.org>
 <20210923112256.15767-3-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210923112256.15767-3-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Thursday 23 Sep 2021 at 12:22:53 (+0100), Will Deacon wrote:
> The stub hypercalls provide mechanisms to reset and replace the EL2 code,
> so uninstall them once pKVM has been initialised in order to ensure the
> integrity of the hypervisor code.
> 
> To ensure pKVM initialisation remains functional, split cpu_hyp_reinit()
> into two helper functions to separate usage of the stub from usage of
> pkvm hypercalls either side of __pkvm_init on the boot CPU.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
