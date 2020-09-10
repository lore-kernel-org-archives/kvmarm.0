Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A94EC43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 04:06:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CF8421D82
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 04:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ogpyzys7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CF8421D82
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B96C04B380;
	Thu, 10 Sep 2020 00:06:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fNP-QDIIkJEO; Thu, 10 Sep 2020 00:06:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE1C4B368;
	Thu, 10 Sep 2020 00:06:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 232E84B35E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 00:06:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9S5HBR9rz2-z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 00:06:32 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 365CE4B340
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 00:06:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599710791;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=k7S4zxxxQYlErRgGmXJ+wYF+gTxt1V5R+2Y3W49tJzc=;
 b=Ogpyzys7m6ZpENgkBtH4/RTFAZkOpR4Pz+jYpRChNkrVzKgT0OoiWlCIsQcs3+JbIsvIzh
 ODzpHdjFy4BNxs2ZbLsiw8g9Vczt3Zm8HxK8DAquA1FrFv29ukyZkfUDcymRKBwKLEbClx
 Jk79IlczU+FOxdAA4YP95j2yU/k0a3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-5o-Q4SMMPRiENsZSv6gtlw-1; Thu, 10 Sep 2020 00:06:29 -0400
X-MC-Unique: 5o-Q4SMMPRiENsZSv6gtlw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43C3C1008548;
 Thu, 10 Sep 2020 04:06:27 +0000 (UTC)
Received: from [10.64.54.123] (vpn2-54-123.bne.redhat.com [10.64.54.123])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 071CE5D9EF;
 Thu, 10 Sep 2020 04:06:16 +0000 (UTC)
Subject: Re: [PATCH v4 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200907152344.12978-1-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <4e41d4c5-1d36-fb28-880d-94235def35ed@redhat.com>
Date: Thu, 10 Sep 2020 14:06:04 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200907152344.12978-1-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will and Marc,

On 9/8/20 1:23 AM, Will Deacon wrote:
> Hi all,
> 
> Here's version four of the KVM page-table rework I previously posted here:
> 
>    v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
>    v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
>    v3: https://lore.kernel.org/r/20200825093953.26493-1-will@kernel.org
> 
> Changes since v3 include:
> 
>    * Removed some more unused code from the old implementation
>    * Renumbered KVM_PGTABLE_PROT_* to match file permissions in hex dumps
>    * Simplified kvm_granule_shift() and removed kvm_start_level()
>    * Only clear valid bit when invalidating a PTE, leaving phys addr intact
>    * Fail gracefully when attempting to allocate without a memory cache
>    * Rewrote stage2_apply_range() as a function instead of a macro
>    * Fixed fault address rounding with hugetlbfs
>    * Fixed permission fault handling when dirty logging is enabled
>    * Added comments
>    * Added reviewer tags
> 
> Many thanks to Alex and Gavin for their comments.
> 
> Will
> 

[...]

Eventually, I'm lucky finding a machine from our pool where 16KB page
size is supported. I tried this series (v4) on this machine, everything
looks good as we expected:

    Host:   5.9.0-rc3 + patchset (v4)
            CONFIG_ARM64_VA_BITS=47
            CONFIG_ARM64_PAGE_SHIFT=14
            Hugepagesize: 32768 kB      (from /proc/meminfo)
    Config: -HugeTLBfs/-THP
            +HugeTLBfs/-THP
            -HugeTLBfs/THP
    Guest:  CONFIG_ARM64_PAGE_SHIFT=12/14/16

Let me know in case there are more tests needed from my side.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
