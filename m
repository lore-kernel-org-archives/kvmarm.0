Return-Path: <SRS0=XU7X=JY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89847C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 15:23:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4E3F61077
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 15:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4E3F61077
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 354DA4B173;
	Tue, 27 Apr 2021 11:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dj7012ZBNM6O; Tue, 27 Apr 2021 11:23:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ECDE4B168;
	Tue, 27 Apr 2021 11:23:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 396044B169
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 11:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bcuphXwQQf22 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Apr 2021 11:23:46 -0400 (EDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0709E4B167
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 11:23:46 -0400 (EDT)
Received: by mail-ed1-f48.google.com with SMTP id h8so30304310edb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 08:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gc8woWbNxJbdvRRggI1IoUfbNc9lkDvROsvEblMei44=;
 b=lHGyM1d4Yy8DrhiOvl+mjtGGME5UNFBuzOhI7Nn9p7VfCVa/JwXm73/nfjycJXjkp4
 EJAk/7o0DUGO/VajmOLMlhIBYX9ICQ/jdpAwZuPb/KynHPPnKHGRxsdEtqKftN7lw5/E
 yi47mPq1fc+f1on1f1qFJPNr1OCMWE/KGHvDrosC5VSK+EkZMLLvIwVXZtdugCRWQuCL
 3x5yMxbq2deYKwZZc8sU+s/Ptr0lpMVxNPvdPM2HPzhQmaptrG1hrqWqN7+sIn9OLKW9
 cDDPdU+OVltMGb7CVfZqkXFlfIcQ/iGWZ3u4QhDXrTev/WdDiBcNF4BYl+2PLvJEa/UX
 Jw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gc8woWbNxJbdvRRggI1IoUfbNc9lkDvROsvEblMei44=;
 b=F/5RlZ+ha9CPGiXzgPQ7tcBggonF5147xr4JlgGfrerkGQNseAm5FHRxfqZ9M4Dgbw
 sNeOc96ypcxXCB4nQATw6+TJR7fvGH5poTWk4aVzTab/FMtZwvrR/ZRX/8rwzf2L7LkJ
 HA6EeE3g6IZNxz10VW3V3ih1LsE2qPgYa2fQjOJqwVWStABhdL3HmWG4h6x9Ce7TMk4V
 m7U+0CeogTaLftFPASZgNq4Mr42mOMdZ+hq6WfKsWUtwWoCyFV30hjfCzyowv2iRvBzO
 dTesBBjJJ5T/H9A8qzW5SUvFkFcZw+B1Pi0/1CoWFhBqxdFCxv7e9vwU/Mq57sFL0VrU
 PKCA==
X-Gm-Message-State: AOAM5326uOeNoLXIM4yaHXyaIAhvOBii+7ii5LSgPr6/gwKBs0P32aXQ
 3EDy1RpLwo9Uuw/OgtfutMSjEg==
X-Google-Smtp-Source: ABdhPJzUbrl2tMkMNoxFod1mRAGmCI1qrAttTgk/bfethyZA8K+AFiBsKzPZFj4LAwxcZcPOR1Gpkw==
X-Received: by 2002:a05:6402:1cb9:: with SMTP id
 cz25mr5022442edb.163.1619537024959; 
 Tue, 27 Apr 2021 08:23:44 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
 by smtp.gmail.com with ESMTPSA id f11sm140948ejc.62.2021.04.27.08.23.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Apr 2021 08:23:44 -0700 (PDT)
Date: Tue, 27 Apr 2021 17:23:26 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
Message-ID: <YIgsbp/hRxM9U+ZN@myrica>
References: <20210426103605.616908-1-maz@kernel.org>
 <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Krishna Reddy <vdumpa@nvidia.com>, Sumit Gupta <sumitg@nvidia.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Tue, Apr 27, 2021 at 03:52:46PM +0100, Alexandru Elisei wrote:
> The comment [1] suggested that the panic is triggered during page aging.

I think only with an out-of-tree patch applied
https://jpbrucker.net/git/linux/commit/?h=sva/2021-03-01&id=d32d8baaf293aaefef8a1c9b8a4508ab2ec46c61
which probably is not going upstream.

Thanks,
Jean

> vfio_pci_mmap() sets the VM_PFNMAP for the VMA and I see in the Documentation that
> pages with VM_PFNMAP are added to the unevictable LRU list, doesn't that mean it's
> not subject the page aging? I feel like there's something I'm missing.
> 
> [1]
> https://lore.kernel.org/kvm/BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com/
> 
> Thanks,
> 
> Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
