Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C567EC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 06:56:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F64F610E5
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 06:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F64F610E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 877354B267;
	Wed,  6 Oct 2021 02:56:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zm3f-aiCgzrn; Wed,  6 Oct 2021 02:56:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B06C4B285;
	Wed,  6 Oct 2021 02:56:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE154B270
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 02:56:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HhlgzuU1S0JP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 02:56:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C31C84B267
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 02:56:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633503403;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uiC3Hk8XqY2sMj+wVrs/NsuZmiiYNNu/UVBg88+/rP8=;
 b=VaJmNYmjb6L9kSRerdOurlXUNMOeyqlTuZ/7Zk0+LVZyuGQaWq0mm7ZrJ8HdKav9e1oOUK
 K3bwsvPKeck96BimyyFa0cSsttj5Ch+Po8dOmGrsZX9l5lxLwCvTIZIUSJ43AZnFi0muUN
 lIT2ejLQ+8KehBr6BKkvlSszrZ0SwBo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-4S0pI9bDORe8eJvbHOYK2g-1; Wed, 06 Oct 2021 02:56:42 -0400
X-MC-Unique: 4S0pI9bDORe8eJvbHOYK2g-1
Received: by mail-ed1-f71.google.com with SMTP id
 1-20020a508741000000b003da559ba1eeso1680534edv.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 23:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uiC3Hk8XqY2sMj+wVrs/NsuZmiiYNNu/UVBg88+/rP8=;
 b=5Cg3E/jRn0cuoj0FRxniI+8l18JLNX92FeJKXbpRJ4IB+MB16vdQtc39E1lNqEyPrv
 SzRSfFu2v0yUOfOZY9hL3N7h+0hT6CgoHQzYw6iVefuJNClt6w8wNiQJs25tWfOFEmz3
 1MvHZgZm2BdHMqwu4JrGcrAnfKf7dVk2tC2poz/m04exmZaTiSoOeUPY2lUmAurklwvQ
 Cu3KeHy/D4npcehy6D0CSarxcXk0BB9Ga0SbNCafz0JSWVsNN5bi5LTolPHr+hFjWhT9
 xrTt55p0DJ8wHHKqTg7DBI/hvEhio2FkWLlopzGj6FpX1/PVsVFVQtmXi19UP+4fxbsv
 PdOg==
X-Gm-Message-State: AOAM532KMTJUQbadHumqO+b6rCzrai1Ig98PQ8FROR8kLz1sVQBVnrTo
 2e2Cn+sG31+70Rgmmzu2Jh7n7Sp20lcHzh02rTlc5N9bUcYq/A+2szCnq/kLI41IX8W/3nnzDW5
 3UGjxmr7gg5jhCtkxQu+Iaa3N
X-Received: by 2002:a17:906:eda6:: with SMTP id
 sa6mr25760763ejb.443.1633503400887; 
 Tue, 05 Oct 2021 23:56:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRCEWg6sFWHgAZxAqk+17ELwV6v2RpvEUUC2eCzGOjfWloxHfVfzRRZi2235VjOzwS7iPORw==
X-Received: by 2002:a17:906:eda6:: with SMTP id
 sa6mr25760739ejb.443.1633503400725; 
 Tue, 05 Oct 2021 23:56:40 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id u6sm9591413edt.30.2021.10.05.23.56.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 23:56:40 -0700 (PDT)
Date: Wed, 6 Oct 2021 08:56:38 +0200
From: Andrew Jones <drjones@redhat.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v6 09/12] KVM: arm64: Initialize trap registers for
 protected VMs
Message-ID: <20211006065638.hiroylzs6vo2j6j4@gator.home>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-10-tabba@google.com>
MIME-Version: 1.0
In-Reply-To: <20210922124704.600087-10-tabba@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, Sep 22, 2021 at 01:47:01PM +0100, Fuad Tabba wrote:
> Protected VMs have more restricted features that need to be
> trapped. Moreover, the host should not be trusted to set the
> appropriate trapping registers and their values.
> 
> Initialize the trapping registers, i.e., hcr_el2, mdcr_el2, and
> cptr_el2 at EL2 for protected guests, based on the values of the
> guest's feature id registers.
> 
> No functional change intended as trap handlers introduced in the
> previous patch are still not hooked in to the guest exit
> handlers.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h       |   1 +
>  arch/arm64/include/asm/kvm_host.h      |   2 +
>  arch/arm64/kvm/arm.c                   |   8 ++
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  14 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile       |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  10 ++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 186 +++++++++++++++++++++++++
>  7 files changed, 222 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c

Regarding the approach, LGTM

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
