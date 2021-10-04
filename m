Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F367C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:13:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F357D61350
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F357D61350
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A27694B2A6;
	Mon,  4 Oct 2021 14:13:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yq-JFzmLX-eA; Mon,  4 Oct 2021 14:13:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB5C04B2A8;
	Mon,  4 Oct 2021 14:13:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C6764B2A1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:13:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WQTV-7hRCVvf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 14:13:48 -0400 (EDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 368B74B252
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:13:48 -0400 (EDT)
Received: by mail-ot1-f47.google.com with SMTP id
 l16-20020a9d6a90000000b0053b71f7dc83so22699369otq.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 11:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GbdWS7O+5glk2eGl8y+sbYBXK1dhg+jDTiIjq/zLXkk=;
 b=30tg7j7iLhyi6M54gjeCLfYudlJ5ti33yRJcu0T1WRv1AWzY8muwaUOr0OFOX5SceF
 DDmI2pMhq0oytFlof+fQ8FzL0ukuU7jzTJaxQfTsM5ifY8MIh5hxHtSpIfxbVOv/pwp6
 DdY6ytdulcKMZCylkPyb5HKdhFyc9cH/9J0TwLVw16tcCwq4mz498Mm7n6JGDZo9v+WH
 kpNusTFzGzv1vsbdM5GallhOWeuYs666E4t88goYfzKYKspcP1HS9o6cUhY81ejaTIV2
 PCWukAR8RU/ycPrXpmssjhMQvnqDFEJQDQ6h6X/tO86iaMOm/lKKks0Fr/tAjt+eFugj
 ymXQ==
X-Gm-Message-State: AOAM533MNV9jLyI8cnFTbcw4cCV5XPN7KNrLEVzUa1KH5SeeYaBxGNNU
 r4h3zaL3ztzgcRAMKuQpAw==
X-Google-Smtp-Source: ABdhPJyVSoPfOlG3bABMGNUkllimA8tjCoYiWHbAbImE0Mv1LkkBB12zo19HHkTpIqYjKjTEECrEKQ==
X-Received: by 2002:a9d:4696:: with SMTP id z22mr10532837ote.293.1633371227643; 
 Mon, 04 Oct 2021 11:13:47 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net.
 [66.90.148.213])
 by smtp.gmail.com with ESMTPSA id b23sm2467983oie.29.2021.10.04.11.13.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 11:13:47 -0700 (PDT)
Received: (nullmailer pid 1588870 invoked by uid 1000);
 Mon, 04 Oct 2021 18:13:46 -0000
Date: Mon, 4 Oct 2021 13:13:46 -0500
From: Rob Herring <robh@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 2/2] of, numa: Fetch empty NUMA node ID from distance
 map
Message-ID: <YVtEWnahMZcysdTg@robh.at.kernel.org>
References: <20210927064119.127285-1-gshan@redhat.com>
 <20210927064119.127285-3-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210927064119.127285-3-gshan@redhat.com>
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org,
 catalin.marinas@arm.com, rdunlap@infradead.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, maz@kernel.org, will@kernel.org,
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

On Mon, 27 Sep 2021 14:41:19 +0800, Gavin Shan wrote:
> There is no device node for the empty NUMA node. However, the
> corresponding NUMA node ID and distance map is still valid in
> "numa-distance-map-v1" compatible device node.
> 
> This fetches the NUMA node ID and distance map for these empty
> NUMA node from "numa-distance-map-v1" compatible device node.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  drivers/of/of_numa.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Applied, thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
