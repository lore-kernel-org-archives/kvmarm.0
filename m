Return-Path: <SRS0=FDwM=5C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6ABC2BB1D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 13:42:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 506F420770
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 13:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="MGDRAHHw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 506F420770
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED50E4ACC9;
	Tue, 17 Mar 2020 09:42:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ziepe.ca
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vKgQXrooCAbd; Tue, 17 Mar 2020 09:42:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 679544B098;
	Tue, 17 Mar 2020 09:42:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBDDB4A522
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 09:25:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XtdUIPMjm7ci for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2020 09:25:58 -0400 (EDT)
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com
 [209.85.219.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6E8A4A319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 09:25:58 -0400 (EDT)
Received: by mail-qv1-f65.google.com with SMTP id a10so10791979qvq.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 06:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ziepe.ca; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=149vrDC6Ny5kXlZ3c9yb3Ff3i3SdoOBmg7pfld3LKGI=;
 b=MGDRAHHwM4nroOOuiUdxwzeDLPsUSxkKGB1ZBFk85k2dwJdJTHMO8PEvHSg2fVErKC
 xbyOzKDkvp5ST2WwzC+GHN4a0yqFAY4pquPxURWoEm5babHrmv41sG04VZtMii9smFBi
 npONJDDXJCv1pMi4ZyGmSrpR4itL6lpn//Whw93FEmcsdwIhQaGMygrv0IxYCF/CIf6e
 A5KYy2R78gVt9xaczD36OBsEfKo76u/YveXPSIXg1stdm9llUXaTvmmz7+djHoeqj25m
 k6WX9vZgfDVYYUp8MszMkTZpAxuWbQ5QLXn6OJXFdneBqng5r8BZ7FIMyRYxs+n/udis
 UKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=149vrDC6Ny5kXlZ3c9yb3Ff3i3SdoOBmg7pfld3LKGI=;
 b=jSR88UglVj9HEnXGyqFn0EALPeweymVRWDlU8WcVqbYvbLSLAtsrpQZ1x0WwU4dlM9
 0ldTjP35J7uxZnClO74QrI8CpdVBMZfYLqtNwJnfpsYs05gcA3MPbl7YKhMOGawwGCnP
 Bda/ALTwZf/SZDOCU3O+05mptYGWNiQiLUbCWsrfmAs3ElRy5aUyM9OdLZSdyI0A914i
 PZZsXE9yBl9h367ewfcccyX53pgu/OlF4bG24PCmD73NFfWRLt7B/msBX6b/+u5Sj0tB
 DG8jOuYJN0RAQ31AE13/CFz9jdLQ9Dj0gjCKoSmshtGTyhZLA3E/eB0wqB4tK+7vOlLz
 1mCw==
X-Gm-Message-State: ANhLgQ0XRqrtVYOjAUF6TvzT6CqugWwN9blmKfd1YSIPFVD9zvYtJFOs
 BR+1kIVxG8flk9y5wdER/olV/w==
X-Google-Smtp-Source: ADFU+vud8ckGfbpq7RFxGRUQtjLFosMM5WbNx995vqc+P+Orw+3LIFDIv/yLP5SnzTRZvkDSJttSbw==
X-Received: by 2002:a0c:bf46:: with SMTP id b6mr4911822qvj.47.1584451558143;
 Tue, 17 Mar 2020 06:25:58 -0700 (PDT)
Received: from ziepe.ca
 (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net.
 [142.68.57.212])
 by smtp.gmail.com with ESMTPSA id u77sm1882170qka.134.2020.03.17.06.25.57
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Tue, 17 Mar 2020 06:25:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
 (envelope-from <jgg@ziepe.ca>)
 id 1jECEH-00027w-2X; Tue, 17 Mar 2020 10:25:57 -0300
Date: Tue, 17 Mar 2020 10:25:57 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 08/12] docs: fix broken references to text files
Message-ID: <20200317132557.GS20941@ziepe.ca>
References: <cover.1584450500.git.mchehab+huawei@kernel.org>
 <35dcbefd50875b92aaf5b7671d4c57c50b4274fe.1584450500.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <35dcbefd50875b92aaf5b7671d4c57c50b4274fe.1584450500.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Mailman-Approved-At: Tue, 17 Mar 2020 09:42:09 -0400
Cc: kvm@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Akira Yokosawa <akiyks@gmail.com>, dri-devel@lists.freedesktop.org,
 linux-unionfs@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, Harry Wei <harryxiyou@gmail.com>,
 Alex Shi <alex.shi@linux.alibaba.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, linux-rdma@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
 David Airlie <airlied@linux.ie>, Doug Ledford <dledford@redhat.com>,
 Alan Stern <stern@rowland.harvard.edu>, linux-arm-kernel@lists.infradead.org,
 Federico Vaga <federico.vaga@vaga.pv.it>, Jade Alglave <j.alglave@ucl.ac.uk>,
 Daniel Lustig <dlustig@nvidia.com>, Mike Leach <mike.leach@linaro.org>,
 Andrea Parri <parri.andrea@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
 "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Nicholas Piggin <npiggin@gmail.com>, Maxime Ripard <mripard@kernel.org>,
 Luc Maranget <luc.maranget@inria.fr>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 David Howells <dhowells@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Marc Zyngier <maz@kernel.org>,
 linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org
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

On Tue, Mar 17, 2020 at 02:10:47PM +0100, Mauro Carvalho Chehab wrote:
> Several references got broken due to txt to ReST conversion.
> 
> Several of them can be automatically fixed with:
> 
> 	scripts/documentation-file-ref-check --fix
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>  Documentation/admin-guide/kernel-parameters.txt      |  2 +-
>  Documentation/memory-barriers.txt                    |  2 +-
>  Documentation/process/submit-checklist.rst           |  2 +-
>  .../translations/it_IT/process/submit-checklist.rst  |  2 +-
>  Documentation/translations/ko_KR/memory-barriers.txt |  2 +-
>  .../translations/zh_CN/filesystems/sysfs.txt         |  2 +-
>  .../translations/zh_CN/process/submit-checklist.rst  |  2 +-
>  Documentation/virt/kvm/arm/pvtime.rst                |  2 +-
>  Documentation/virt/kvm/devices/vcpu.rst              |  2 +-
>  Documentation/virt/kvm/hypercalls.rst                |  4 ++--
>  arch/powerpc/include/uapi/asm/kvm_para.h             |  2 +-
>  drivers/gpu/drm/Kconfig                              |  2 +-
>  drivers/gpu/drm/drm_ioctl.c                          |  2 +-
>  drivers/hwtracing/coresight/Kconfig                  |  2 +-
>  fs/fat/Kconfig                                       |  8 ++++----
>  fs/fuse/Kconfig                                      |  2 +-
>  fs/fuse/dev.c                                        |  2 +-
>  fs/overlayfs/Kconfig                                 |  6 +++---
>  include/linux/mm.h                                   |  4 ++--
>  include/uapi/linux/ethtool_netlink.h                 |  2 +-
>  include/uapi/rdma/rdma_user_ioctl_cmds.h             |  2 +-

For the rdma files

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
