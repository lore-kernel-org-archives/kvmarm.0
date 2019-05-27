Return-Path: <SRS0=Q2PW=T3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A120C04AB3
	for <kvmarm@archiver.kernel.org>; Mon, 27 May 2019 15:15:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EDBCD217F4
	for <kvmarm@archiver.kernel.org>; Mon, 27 May 2019 15:15:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDBCD217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 454C64A4C1;
	Mon, 27 May 2019 11:15:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M1i9V2a3IhsA; Mon, 27 May 2019 11:15:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 493F94A4C3;
	Mon, 27 May 2019 11:15:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7D004A47E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 May 2019 11:15:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gg1h+mQXSimE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 May 2019 11:15:36 -0400 (EDT)
Received: from mail-vk1-f194.google.com (mail-vk1-f194.google.com
 [209.85.221.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4A1E4A32E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 May 2019 11:15:36 -0400 (EDT)
Received: by mail-vk1-f194.google.com with SMTP id g194so3907187vke.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 May 2019 08:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=S3tITZHYfrewmW5oJlisGGiL7wfHqP1R9OVY9cCC4GU=;
 b=OKjD0E9btF6gPoEO+Paij4uXA/yhJ0nnL+2ED2nTCeVmKaqR1zHPmMsjrXBRC6id9u
 7t48pNT3x4ncn9lw+87NwOlbzJt5wJbrr1vrtvu1Npijgk3ZRHv+UNnu58CtafAjg+X0
 voBjtDRIY1o0sqa37TGpyhMfOen5+wlN99PwUzw3kRQNs1/dZQ2NkyBlZyLPO6oGJugb
 5HK8wLrf4wkHasKO/GoUkauCvLLTY5uVZnsvZmZKr6DVsb1DwsY1Rk0OIlOhtQtjuazU
 kTi/2M38s+G1vn0azznNQpcav9PzuJqicqRJp/Hpq4/kTILVCmpy8uJALnaBZ8IxlmtQ
 MoZg==
X-Gm-Message-State: APjAAAXaWaolTbZK1ESQ7zQMOnkkOof+NSh/uv59b1RrBU6n6rJMhgLt
 J0vwRKuDNAFal+BdM17ZrJt5+Q==
X-Google-Smtp-Source: APXvYqxJCHIEBYM/VufOiGYY7G560g6K/dg4+SJBDDD3dVA0O70dd9ZnwStYxTkM8qVIYrC3jk8P+g==
X-Received: by 2002:a1f:7cc7:: with SMTP id x190mr19173038vkc.92.1558970136480; 
 Mon, 27 May 2019 08:15:36 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net.
 [100.0.197.103])
 by smtp.gmail.com with ESMTPSA id w131sm6373477vsw.7.2019.05.27.08.15.34
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Mon, 27 May 2019 08:15:35 -0700 (PDT)
Date: Mon, 27 May 2019 11:15:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7 0/7] Add virtio-iommu driver
Message-ID: <20190527111345-mutt-send-email-mst@kernel.org>
References: <20190115121959.23763-1-jean-philippe.brucker@arm.com>
 <20190512123022-mutt-send-email-mst@kernel.org>
 <20190527092604.GB21613@8bytes.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190527092604.GB21613@8bytes.org>
Cc: virtio-dev@lists.oasis-open.org, kevin.tian@intel.com,
 lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com,
 devicetree@vger.kernel.org, linux-pci@vger.kernel.org, jasowang@redhat.com,
 will.deacon@arm.com, robin.murphy@arm.com,
 virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org,
 robh+dt@kernel.org, marc.zyngier@arm.com, bhelgaas@google.com,
 frowand.list@gmail.com, kvmarm@lists.cs.columbia.edu
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

On Mon, May 27, 2019 at 11:26:04AM +0200, Joerg Roedel wrote:
> On Sun, May 12, 2019 at 12:31:59PM -0400, Michael S. Tsirkin wrote:
> > OK this has been in next for a while.
> > 
> > Last time IOMMU maintainers objected. Are objections
> > still in force?
> > 
> > If not could we get acks please?
> 
> No objections against the code, I only hesitated because the Spec was
> not yet official.
> 
> So for the code:
> 
> 	Acked-by: Joerg Roedel <jroedel@suse.de>

Last spec patch had a bunch of comments not yet addressed.
But I do not remember whether comments are just about wording
or about the host/guest interface as well.
Jean-Philippe could you remind me please?

-- 
MST
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
