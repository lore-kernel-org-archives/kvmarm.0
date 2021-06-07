Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191E4C47082
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 08:49:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89E63611AD
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 08:49:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89E63611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2FB4B08D;
	Mon,  7 Jun 2021 04:49:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iALYsDZufPJ8; Mon,  7 Jun 2021 04:49:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E6BC4B08A;
	Mon,  7 Jun 2021 04:49:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C4D54B08B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 04:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L8v4Mka8X9kv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 04:49:16 -0400 (EDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F0804A98B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 04:49:16 -0400 (EDT)
Received: by mail-wm1-f52.google.com with SMTP id
 b145-20020a1c80970000b029019c8c824054so12073557wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jun 2021 01:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=R2ZopsQZZdXEYjl6azm31E2MzYfojsymg///Se/cAKM=;
 b=RxBciWEa0mOrwTDqwBl7XhVt1Z3tGfff3KVAXfjjxbhvucwuitAYpCjW2AiOfmc4hY
 MW0YwzUHKGA/WeKdlYLraPeOhx4a5uKzxp6v4lLraANt7WimKeIInnK9T/6eWrQjXCT9
 WjObcZ+HYZ3Go8GMia3x24cyu5tbYPVgn1JDv/sRYAPZlA5vtodNND9A/q6x8y8UnXk6
 SuJuhS9v8M4MwoSC+c+Tx7H+ePDwkcKPvy620Tt8pc5u8pj0IFei8NsOk08p/27eHLhl
 SoI75OyhpQKO1uzn4yXdmbM/CqtG6q0nD58HzKEwZj7xuk0c/z3vpR8i7Mvpj1PS7VyY
 r5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=R2ZopsQZZdXEYjl6azm31E2MzYfojsymg///Se/cAKM=;
 b=K0Qus7Wchf7vbCzCEAxgC6lbZS8g9fOpiTLEgRVqiJWe9LGBtSkvporEB6v/mom2f5
 lB6XS4u+kdsyF3C4Qis8u4HCM8DtEZUrxg8pSss7sI+keFiajU18KHTi4/N36GZavQoN
 HZxyp0VQof3Skwws1rjc5rzRBZTY/xHp3RP/lCDhtO+CSgfgqa9GRX9n/JK6bmevQT3m
 V4ZHytF+EfVF/OJW/H7wBXroiRDBUxU7/3Bwca7hQfqnqKmOuweE4VCPK0oj0udwZyYX
 1e1RlTFgjIg38ifUrdk3HK09InqpzJQg7AgxbP4L6uit+hMRv6fqUeoA8WPtWp+IO6lV
 CO5w==
X-Gm-Message-State: AOAM5312U8wtcu990OYAjfDR+Tf5Z9vanGDQGNwJRk9LwyoqLGUR6yG+
 ZkAsC0CgSwehZpRPNzLc1l1Zvw==
X-Google-Smtp-Source: ABdhPJyurKzta3z2CeRnxFd2iiCVeQi8uEXKlJF0ITFMul63PvHyfT+ViQ4DZznWDHGoSIMfaenzLQ==
X-Received: by 2002:a05:600c:21d1:: with SMTP id
 x17mr15424695wmj.167.1623055754959; 
 Mon, 07 Jun 2021 01:49:14 -0700 (PDT)
Received: from myrica (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
 by smtp.gmail.com with ESMTPSA id o18sm5415514wrx.59.2021.06.07.01.49.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Jun 2021 01:49:14 -0700 (PDT)
Date: Mon, 7 Jun 2021 10:48:55 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
 approach)
Message-ID: <YL3ddwlSOsv16F1g@myrica>
References: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
 <e62829990c50479292af94c4152011fc@huawei.com>
 <87sg1xzqea.wl-maz@kernel.org>
 <95bb84ffdb0f4db3b64b38cc3b651f90@huawei.com>
 <87lf7ptztg.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87lf7ptztg.wl-maz@kernel.org>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>, "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Fri, Jun 04, 2021 at 04:27:39PM +0100, Marc Zyngier wrote:
> > > Plus, I've found this nugget:
> > > 
> > > <quote
> > > 	max_pinned_vmids = NUM_USER_VMIDS - num_possible_cpus() - 2;
> > > </quote>
> > > 
> > > What is this "- 2"? My hunch is that it should really be "- 1" as VMID
> > > 0 is reserved, and we have no equivalent of KPTI for S2.
> > 
> > I think this is more related to the "pinned vmid" stuff and was borrowed from
> > the asid_update_limit() fn in arch/arm64/mm/context.c. But I missed the
> > comment that explains the reason behind it. It says,
> > 
> > ---x---
> > 	/*
> > 	 * There must always be an ASID available after rollover. Ensure that,
> > 	 * even if all CPUs have a reserved ASID and the maximum number of ASIDs
> > 	 * are pinned, there still is at least one empty slot in the ASID map.
> > 	 */
> > 	max_pinned_asids = num_available_asids - num_possible_cpus() - 2;
> > ---x---
> > 
> > So this is to make sure we will have at least one VMID available
> > after rollover in case we have pinned the max number of VMIDs. I
> > will include that comment to make it clear.
> 
> That doesn't really explain the -2. Or is that that we have one for
> the extra empty slot, and one for the reserved?
> 
> Jean-Philippe?

Yes, -2 is for ASID#0 and the extra empty slot. A comment higher in
asids_update_limit() hints at that, but it could definitely be clearer

        /*
         * Expect allocation after rollover to fail if we don't have at least
         * one more ASID than CPUs. ASID #0 is reserved for init_mm.
         */

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
