Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BC9C07E9B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:57:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D20761164
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D20761164
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B02214B0CA;
	Tue, 20 Jul 2021 07:57:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WG7ThJDVrogq; Tue, 20 Jul 2021 07:56:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5BBE4B098;
	Tue, 20 Jul 2021 07:56:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDED4B08E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:56:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uBIr1HpSShG4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 07:56:57 -0400 (EDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A77294A32E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:56:57 -0400 (EDT)
Received: by mail-wm1-f45.google.com with SMTP id
 a23-20020a05600c2257b0290236ec98bebaso1888269wmm.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 04:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=WheQ7fUX5EA867I+bv9cFye5SAD4lIhGyGX5hYkcj+M=;
 b=vhIcOCOvy5Rai9IUroGOqHvmtz2lTrczf34W0vWXkqQkyInbPoQYwfN0oToFxuLqji
 ir9eSpzqiHc4OYCUazxINKpDTodBu3AhlbpSxd7yywx03U7AmZ2V27Tz9BMu5d6Y4dqQ
 4nQTxB8Ji3Ng/pegFcNH2Lwx7Evla81MoA0JPk4OFxMNXo6T6zsBd9rZy2w3QhMQq/Rb
 /SEWgi8DzAYYNDXHhXGjJimRiuoL0wwvbGpG7AYgfjYuKeoSm2a9B6gvWOpYVLFIxC02
 SocqIuB4fm7W3uVn4Leh6atXqmdtuTkkskx06YtjEMbA/2vDqNc3uNraOjezdjS8A6iz
 V5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=WheQ7fUX5EA867I+bv9cFye5SAD4lIhGyGX5hYkcj+M=;
 b=qN6STcT2XmsgMSN8uILrW60OL9nlaPV06bO2OB07yCJqjtSYWF3NNb/F11ivGf7Pw5
 2mJ3xDTLtzw29d6eM3D/x4qLd86yZnBpJx2YfU+FvVbtAQekZLnPXinwxvCcipVmhrUz
 n4mHepUlIroiBTH9LxZhij/8KLpAEOMTjUQgApB+yozMrwKgs0ZkqpPp2uxcotmGWplc
 Ly3dqq2QXJ6tDHDxUEi/RxqCYquiYI230b/zFGxMt4/57AuqIM5h3hmzHdvaBN3m+jmV
 Pv/DUdYsQBCgNNLVzwLrKMa02EGvfo5mshIwgpp2xIgoxRBMGi0qLFu9mdCfn6HYegtg
 hAZw==
X-Gm-Message-State: AOAM530M9feUw6wT6pSyqOW5uXcoyRXfT9TCQ5zugvrSz9RVhKdYZo/V
 DBe5GD3w941LLOgs47OQSbJxew==
X-Google-Smtp-Source: ABdhPJwJrV/b4HrNOBTUVc50mwLqlvQcj8GwTPDgrlDwpIuPjeOwLY1hcD8a9O+QoPfgfmLgXfG+yQ==
X-Received: by 2002:a1c:1f47:: with SMTP id f68mr31394200wmf.58.1626782216570; 
 Tue, 20 Jul 2021 04:56:56 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id j12sm23997076wrq.83.2021.07.20.04.56.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 04:56:55 -0700 (PDT)
Date: Tue, 20 Jul 2021 12:56:52 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/14] KVM: arm64: Continue stage-2 map when re-creating
 mappings
Message-ID: <YPa6BGuUFjw8do+o@google.com>
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-4-qperret@google.com>
 <87lf62jy9z.wl-maz@kernel.org> <YPV+2jQ/Q/ie14Fn@google.com>
 <875yx59ysd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875yx59ysd.wl-maz@kernel.org>
Cc: kernel-team@android.com, qwandor@google.com, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
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

On Tuesday 20 Jul 2021 at 09:26:10 (+0100), Marc Zyngier wrote:
> Right, but this is on a different path, right? Guests can never fault
> multiple mappings at once, and it takes you a host hypercall to
> perform this "multiple leaves at once".

Right.

> Is there any way we can restrict this to the hypercall? Or even
> better, keep the hypercall as a "one page at a time" thing? I can't
> imagine it being performance critical (it is a once-off, and only used
> over a rather small region of memory). Then, the called doesn't have
> to worry about the page already being mapped or not. This would also
> match the behaviour of what I do on the MMIO side.
> 
> Or do you anticipate much gain from this being able to use block
> mappings?

Not really no, especially given that mappings of shared pages will be
forced to page granularity thanks to the other patch we discussed in
this series. I was just hoping to reduce the overhead a bit by reducing
the number of hypercalls. But as you said, this probably doesn't matter
all that much, so happy to rework that. I'll look into making the hcall
use one page at a time, and hopefully that'll simplify a few other
things in the check_host_share_hyp() path near the end of this series.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
