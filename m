Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812BCC47082
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 08:05:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F20BA611C1
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 08:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F20BA611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 684384B09E;
	Mon,  7 Jun 2021 04:05:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pJ2kKDDyUbPO; Mon,  7 Jun 2021 04:05:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA36C4A173;
	Mon,  7 Jun 2021 04:05:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6396D4A173
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 04:05:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U3-5IyUGcdJa for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 04:04:57 -0400 (EDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4742449FB0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 04:04:57 -0400 (EDT)
Received: by mail-wm1-f48.google.com with SMTP id
 f16-20020a05600c1550b02901b00c1be4abso1606339wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jun 2021 01:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=45tZHTOhPWrMm2QuGwxst35nsbkg8Cc+rbe4pv2DS3s=;
 b=kIsPzVm/6HfQ2rSo6tvkvnj7PQ6cJswWvGgwdkdgaH6igE7n3GHPEMG2vp4Z472uwB
 +KsYt5wzp2s9ftXX/i4EIBLcJJxmFL4qHM5xrQibJ27PSXZLrogYgU+O7HQZGR+iyAcp
 ENqqFR0FScR0zbmHj60qWp3rM2QnSbnXLNJCCWzx48KNOVPLofYBkXxm2MKyVbnpoaEi
 VJ0S4j/02+fK0RKfpkMJgSC1sOAzhVdo9mdLOvhwevYnuhSQzcP/zVsLUUlTiGrBi8mP
 Z7vBYKauVcdW7lLENQosyuNUX/zVoCIl0Ac6KBIXKDIAfV+f1nQstXLthFWW2QDqXWoB
 sxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=45tZHTOhPWrMm2QuGwxst35nsbkg8Cc+rbe4pv2DS3s=;
 b=TjUOe2hRua+A4lvZBhUrmqDBSQn+j4d/nqn9+1Vn1YtRXwqfj6LJOFaLQrZT4CnSox
 F6I0TAr5SmlilGojMwUXCRR3s4s7enlD81sucBFuDvX43/gr7l+8aoYAGOjjCRbyxdPt
 SOniJNMgTlcXpvVEhCUWmQeCZKESdHAwHXrSrgMHMgll4aZdITDjRgGg8h9/DIkvFEMd
 gbwfi6K9qiOlvYz7EDzwMW0dne/6bLA6yOEbRKXLop4izit1lBdPkmX6xL+Yhm7rEGx2
 mfZ/rUZ0TsKkChWcLYy97EaUS5J4yZ6ayarZ1euyOGFyJvOrzYw16Y3DGNggIUpxfnT6
 utjg==
X-Gm-Message-State: AOAM530VA2hKK0vRUsoY0uSw8FaPzbAyhOwDYB3zZ1m3ZRpA0hBA36fz
 BaX797A4+QOqjiLhcvhmHnCPXg==
X-Google-Smtp-Source: ABdhPJxhLwD0/g3fyDKT04YjO9SBSS50dsCkWXljDRLq8PTa8wtbKxGm26XKKJlsPURCnhuE70CeEQ==
X-Received: by 2002:a7b:c098:: with SMTP id r24mr15440340wmh.35.1623053096135; 
 Mon, 07 Jun 2021 01:04:56 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com.
 [35.195.168.105])
 by smtp.gmail.com with ESMTPSA id k5sm275646wmk.11.2021.06.07.01.04.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Jun 2021 01:04:55 -0700 (PDT)
Date: Mon, 7 Jun 2021 08:04:52 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/7] KVM: arm64: Unify MMIO and mem host stage-2 pools
Message-ID: <YL3TJDlMNCyq7JK3@google.com>
References: <20210602094347.3730846-1-qperret@google.com>
 <20210602094347.3730846-5-qperret@google.com>
 <b4e4647166447d8fd22b360369de4acb@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b4e4647166447d8fd22b360369de4acb@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Sunday 06 Jun 2021 at 11:31:20 (+0100), Marc Zyngier wrote:
> On 2021-06-02 10:43, Quentin Perret wrote:
> > We currently maintain two separate memory pools for the host stage-2,
> > one for pages used in the page-table when mapping memory regions, and
> > the other to map MMIO regions. The former is large enough to map all of
> > memory with page granularity and the latter can cover an arbitrary
> > portion of IPA space, but allows to 'recycle' pages.
> > 
> > However, this split makes accounting difficult to manage as pages at
> > intermediate levels of the page-table may be used to map both memory and
> > MMIO regions. Simplify the scheme by merging both pools into one. This
> > means we can now hit the -ENOMEM case in the memory abort path, but
> > we're still guaranteed forward-progress in the worst case by unmapping
> > MMIO regions. On the plus side this also means we can usually map a lot
> > more MMIO space at once if memory ranges happen to be mapped with block
> > mappings.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> 
> This patch fails to apply on top of -rc4. Did you use some more exotic
> base or, as I suspect, a development tree?
> 
> Please check and respin the series if necessary.

I used kvmarm/next, but clearly an out-of-date one. I'll respin -- sorry
about that.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
