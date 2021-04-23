Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BC7C433B4
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 13:01:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 013EA61406
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 13:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 013EA61406
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 561AA4B37F;
	Fri, 23 Apr 2021 09:01:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PeuFX9u9IAaA; Fri, 23 Apr 2021 09:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 723284B3C1;
	Fri, 23 Apr 2021 09:01:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5699D4B37F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 09:01:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XP+lgECETAX2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 09:01:08 -0400 (EDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
 [209.85.208.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F1E74B30C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 09:01:08 -0400 (EDT)
Received: by mail-ed1-f50.google.com with SMTP id k17so17865946edr.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 06:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2rHamcAk69i1heErTD043nvHWdBaYcGMYqk0SxlLX3w=;
 b=AI4OF1eHAcLvyWD6iouxBu3wzPXbE7lqxD/nvUDlUK6sCGPvqEiURU18cQsgP60E9B
 79XpQibjTf/FlzQDqoN1m5Xox0apvDhFykYVGLADrOrtndSOh4jcTHehoSL6CP5+tm3A
 K0hA7VUPU7KcWWquu+KenypCJDq2PzLWPT13f3BEr3icJCOt6wvTHM2Vbdp3dw0p4ELx
 dJMs/UerJVfhV13oS+6JAVOptYzHzjOwPt3NZPtEdroHfd5ogVdtz78kjCWB/KMlKxrO
 UeVaHJ8m1HYcZ0RhK4C8RpAYQU5X1LCldsFsS/aQlKYGbqWoMuPE27tWoUwBkuhT49t9
 nruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2rHamcAk69i1heErTD043nvHWdBaYcGMYqk0SxlLX3w=;
 b=jIBqqKFCiJFluDGuiOWSYIT2vfnfTBPMeo6x20ivbXW4ERJoshk4cubnE6n+TcxzVL
 JOo60VfgEmmeR1gUEum1mOz86GuQttfZdauvMbR90iNb7H/Njx8CdHeug4nibfbdEMpT
 mFeNGSP0u7Lyndw5GVj/KKlhkKebE3IDOEHEYMBX0Ls80FV6vNXVK51/HxwXgIG17lON
 aCQNWS5yuLYMQ4+paNC7ws9QwPTEDoskjk8Am5MGq20sCo+a7EZtHIwb6G/T7Jvlo2xS
 MqY1ibuB2dcj1f9AF4FAJVSpk87zoS4fRphhYttq+9S5OUX4T2Zo5Bd2gcUxL6kKJ5JS
 kG5g==
X-Gm-Message-State: AOAM533PPtJYEdlU6vi/o472+7otIeyzSJlkY3CY93dM6suxRMKipT++
 hhEQNu/ha864oWO+MTaJ24DZMw==
X-Google-Smtp-Source: ABdhPJyDrw4UO6yanfUyRpsU9b8VpZWr1Al+SSF6+YcbsniqaahON/TAvV32FxXYlw+iumrp6+ExVg==
X-Received: by 2002:a05:6402:4d1:: with SMTP id
 n17mr4292611edw.118.1619182867214; 
 Fri, 23 Apr 2021 06:01:07 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
 by smtp.gmail.com with ESMTPSA id d14sm4537418edc.11.2021.04.23.06.01.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Apr 2021 06:01:06 -0700 (PDT)
Date: Fri, 23 Apr 2021 15:00:48 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Sumit Gupta <sumitg@nvidia.com>
Subject: Re: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Message-ID: <YILFAJ50aqvkQaT/@myrica>
References: <f99d8af1-425b-f1d5-83db-20e32b856143@redhat.com>
 <1619103878-6664-1-git-send-email-sumitg@nvidia.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1619103878-6664-1-git-send-email-sumitg@nvidia.com>
Cc: vdumpa@nvidia.com, wangxingang5@huawei.com, kvm@vger.kernel.org,
 lushenming@huawei.com, maz@kernel.org, joro@8bytes.org, will@kernel.org,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 vsethi@nvidia.com, alex.williamson@redhat.com, vivek.gautam@arm.com,
 zhangfei.gao@linaro.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

Hi Sumit,

On Thu, Apr 22, 2021 at 08:34:38PM +0530, Sumit Gupta wrote:
> Had to revert patch "mm: notify remote TLBs when dirtying a PTE".

Did that patch cause any issue, or is it just not needed on your system?
It fixes an hypothetical problem with the way ATS is implemented. Maybe I
actually observed it on an old software model, I don't remember. Either
way it's unlikely to go upstream but I'd like to know if I should drop it
from my tree.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
