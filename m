Return-Path: <SRS0=LaKu=5Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1B2C2D0EA
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 08:32:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 463E120784
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 08:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYKMi/Pg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 463E120784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C12584B151;
	Thu,  9 Apr 2020 04:32:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IkcVnbDxdC0X; Thu,  9 Apr 2020 04:32:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2214B156;
	Thu,  9 Apr 2020 04:32:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 318754B0CF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 03:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XuRgytDjWF1M for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 03:45:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E80A4B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 03:45:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CA93220678;
 Thu,  9 Apr 2020 07:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586418352;
 bh=l8NzhKGSW5e+lStH7nKV3Pogb9us5XvLBT3TJJbhUwI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=sYKMi/Pgr13POQ6gmP2oi1lDrpn0nXxjqswB/Pr0GVxUUE+paQiHl6fsf+8ORfw6p
 L/+reWUwuP4P8hdIMinREX2O1BP64AYLh1TPcAsIW4aj9dvSHOLHu9B9rDtMVJ6+I+
 zkCoLKp3seuZveLxmB2+9h6enwMZ8mlPopqLj3wM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jMRsk-001qL2-00; Thu, 09 Apr 2020 08:45:50 +0100
Date: Thu, 9 Apr 2020 08:45:46 +0100
From: Marc Zyngier <maz@kernel.org>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 03/35] docs: fix broken references to text files
Message-ID: <20200409084546.51ecb701@why>
In-Reply-To: <2e12bf13355bd06748fed5d135fd4de3d94ad5fd.1586359676.git.mchehab+huawei@kernel.org>
References: <cover.1586359676.git.mchehab+huawei@kernel.org>
 <2e12bf13355bd06748fed5d135fd4de3d94ad5fd.1586359676.git.mchehab+huawei@kernel.org>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: mchehab+huawei@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, corbet@lwn.net, stern@rowland.harvard.edu,
 parri.andrea@gmail.com, will@kernel.org, peterz@infradead.org,
 boqun.feng@gmail.com, npiggin@gmail.com, dhowells@redhat.com,
 j.alglave@ucl.ac.uk, luc.maranget@inria.fr, paulmck@kernel.org,
 akiyks@gmail.com, dlustig@nvidia.com, federico.vaga@vaga.pv.it,
 harryxiyou@gmail.com, alex.shi@linux.alibaba.com, pbonzini@redhat.com,
 paulus@ozlabs.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@linux.ie, daniel@ffwll.ch, mathieu.poirier@linaro.org,
 suzuki.poulose@arm.com, mike.leach@linaro.org,
 alexander.shishkin@linux.intel.com, hirofumi@mail.parknet.co.jp,
 miklos@szeredi.hu, akpm@linux-foundation.org, dledford@redhat.com,
 jgg@ziepe.ca, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 linux-arch@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux
 ppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
X-Mailman-Approved-At: Thu, 09 Apr 2020 04:32:30 -0400
Cc: kvm@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Akira Yokosawa <akiyks@gmail.com>, dri-devel@lists.freedesktop.org,
 linux-unionfs@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, Harry Wei <harryxiyou@gmail.com>,
 Alex Shi <alex.shi@linux.alibaba.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 kvm-ppc@vger.kernel.org, David Airlie <airlied@linux.ie>,
 Doug Ledford <dledford@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
 linux-arm-kernel@lists.infradead.org, Federico Vaga <federico.vaga@vaga.pv.it>,
 Jade Alglave <j.alglave@ucl.ac.uk>, Daniel Lustig <dlustig@nvidia.com>,
 Mike Leach <mike.leach@linaro.org>, Andrea Parri <parri.andrea@gmail.com>,
 Daniel Vetter <daniel@ffwll.ch>, "Paul E. McKenney" <paulmck@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Nicholas Piggin <npiggin@gmail.com>, Maxime Ripard <mripard@kernel.org>,
 Luc Maranget <luc.maranget@inria.fr>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 David Howells <dhowells@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, linux-fsdevel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 linuxppc-dev@lists.ozlabs.org
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

On Wed,  8 Apr 2020 17:45:55 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Several references got broken due to txt to ReST conversion.
> 
> Several of them can be automatically fixed with:
> 
> 	scripts/documentation-file-ref-check --fix
> 
> Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org> # hwtracing/coresight/Kconfig
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/arm/pvtime.rst                |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c                     |  2 +-
>  virt/kvm/arm/vgic/vgic.h                             |  4 ++--

Acked-by: Marc Zyngier <maz@kernel.org> # kvm/arm64

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
