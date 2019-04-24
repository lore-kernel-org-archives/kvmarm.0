Return-Path: <SRS0=bv25=S2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7592BC10F11
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 14:21:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE3AB218FC
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 14:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sAm5MXiR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE3AB218FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 729314A4E8;
	Wed, 24 Apr 2019 10:21:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id InGqO3RtUf+p; Wed, 24 Apr 2019 10:21:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D03C4A4A9;
	Wed, 24 Apr 2019 10:21:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5BE4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:21:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5rtPWGYjCvos for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 10:21:37 -0400 (EDT)
Received: from mail-yb1-f196.google.com (mail-yb1-f196.google.com
 [209.85.219.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64BE24A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:21:37 -0400 (EDT)
Received: by mail-yb1-f196.google.com with SMTP id a13so996511ybm.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 07:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=XFgiOU+IFpTLzIbSG0pRnLvcmQ+HnbdvSe0p2WFb6Ns=;
 b=sAm5MXiR2N3H1OAr87W5AlZDl/Yr4NBX+L+1U376zVnxPVkaXe9AxIMLZGzcAV3M4R
 aBoOrcLMPh8JL7DTJ7Nre1QpDAodLJaR7MbWjuM7ImeBXypmWV0zDwQu65F+vCtfJKVt
 SqFIdbbiDA/O8tElyJ0mDI04FEkJbUYSZSoRME5bx6yOep9/qAP5S8HyXipjsB2/Xya9
 0WCpQrgMtZLP7k7V7nNX/nwFJi1665ddjbky3zocbqJPOVKkrlVoLDk153ECc/ATIW9u
 V5PjU5EjXAfQRHZ/HzGXUSDhBybaQRXttaeZi3/z/Do33fs0Bwt/ZE64k9vB54blZ4lL
 J2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=XFgiOU+IFpTLzIbSG0pRnLvcmQ+HnbdvSe0p2WFb6Ns=;
 b=K60GplxypTfl3qwsGc6X8moaai67G87RXyq/TmkwPg44PwcSNUb8NNFjzSwpSIxsCf
 dchX/eDVyab4UCm8BoNGOUEBc5fPTxm7SWCqmCKOpD5VjtkrQwQu4Fgfg4qvVE/jUsP/
 Uy471MEnG0tX3CKtzuRUVby0GVJVgvhUBPwLYjaTePdod6V2KN7JtBXTnKcd9J3qH4db
 sT2wF2VJG52Rtoq4IhIskdkGwSC8xDEHobn2KpIIsYUSSo0V6i3ibjn5j1DqG0zv/ekv
 kn0pIHo195TDKB/e9Y5LpUnIWfE/7e22BvU4C1iFpHaz/kogkgmIQ2cP6odIOUbeLqvh
 9rFA==
X-Gm-Message-State: APjAAAVaTgwxNnZLdiOWCRQyK2Jhaz0vZlLQ/mS6WAqJ/q7L0YUe6Y37
 FsV9LMRUiRbFlg1wGC8woiCLJQ==
X-Google-Smtp-Source: APXvYqxGuKXBAiAT1SL0myPL/oP9LsFU39gRc6j4K6UaBr3+N14QlWP3EnW3UZK0nc1I7RrhKZySkQ==
X-Received: by 2002:a25:3745:: with SMTP id e66mr2043860yba.521.1556115696815; 
 Wed, 24 Apr 2019 07:21:36 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li931-65.members.linode.com.
 [45.56.113.65])
 by smtp.gmail.com with ESMTPSA id b131sm7213247ywb.103.2019.04.24.07.21.32
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Wed, 24 Apr 2019 07:21:35 -0700 (PDT)
Date: Wed, 24 Apr 2019 22:21:27 +0800
From: Leo Yan <leo.yan@linaro.org>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Will Deacon <Will.Deacon@arm.com>,
 Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
 Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>,
 Robin Murphy <Robin.Murphy@arm.com>
Subject: Re: [PATCH v4 0/3] vfio-pci: Support INTx mode re-enabling
Message-ID: <20190424142127.GC8948@leoy-ThinkPad-X240s>
References: <20190408012719.16158-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190408012719.16158-1-leo.yan@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190424142127.Y4i_w0F69K8ILRVZQKyJmk-9qwHBGKr0jfrLmfur8R4@z>

Hi Will,

On Mon, Apr 08, 2019 at 09:27:16AM +0800, Leo Yan wrote:
> When enable vfio-pci mode for NIC driver on Juno board, the IRQ is
> failed to forward properly from host to guest, finally root caused this
> issue is related with kvmtool cannot re-enable INTx mode properly.
> 
> So the basic working flow to reproduce this issue is as below:
> 
>     Host             Guest
> -------------  --------------------
>   INTx mode
>                  MSI enable failed in NIC driver
>                  MSI disable in NIC driver
>                  Switch back to INTx mode --> kvmtool doesn't support
> 
> So this patch is to support INTx mode re-enabling; patch 0001 is one
> minor fixing up for eventfd releasing; patch 0002 introduces a new
> function vfio_pci_init_intx() which is used to finish INTx one-time
> initialisation; patch 0003 is the core patch for support INTx mode
> re-enabling, when kvmtool detects MSI is disabled it rollbacks to INTx
> mode.
> 
> This patch set has been tested on Juno-r2 board.
> 
> == Changes for V4 ==
> * Removed the unnecessary comments in patch 0003 (Jean-Philippe).
> * Added Jean-Philippe's review tags.

Could you pick up these 3 patches and merge into kvmtool?  All of them
has been received reviewing tag from Jean-Philippe.  Thanks.

> == Changes for V3 ==
> * Add new function vfio_pci_init_intx() for one-time initialisation.
> * Simplized INTx re-enabling (don't change irq_line anymore at the
>   runtime).
> 
> 
> Leo Yan (3):
>   vfio-pci: Release INTx's unmask eventfd properly
>   vfio-pci: Add new function for INTx one-time initialisation
>   vfio-pci: Re-enable INTx mode when disable MSI/MSIX
> 
>  include/kvm/vfio.h |  1 +
>  vfio/pci.c         | 95 ++++++++++++++++++++++++++++++----------------
>  2 files changed, 64 insertions(+), 32 deletions(-)
> 
> -- 
> 2.19.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
