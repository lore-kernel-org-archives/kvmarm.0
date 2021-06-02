Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A9BC47083
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 10:50:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE3F36023F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 10:50:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE3F36023F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4208A406E0;
	Wed,  2 Jun 2021 06:50:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bRCUHXseJayR; Wed,  2 Jun 2021 06:50:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D8940877;
	Wed,  2 Jun 2021 06:50:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 826DF4086A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 06:49:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lbwYIMNVNxkY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 06:49:54 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEED3406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 06:49:54 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id
 t4-20020a1c77040000b029019d22d84ebdso3469553wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 03:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=iBPgoenc4+VXFgVYv4Mb1skeP6ikfbF6DUFZDuY5ah0=;
 b=qMBk9o3bcP5GtSnrBEjM+uWb62KPrE2rQIg+ZFejyIJ7KDc7EuHbWv6Ier5kZTigIR
 5mXf3/3MmGJskgrxiaqGw4px5jD+G+hWfPNKX0VB3Q90xVaVC9W2ub5I3+4rYkIr8C6L
 chxtaxQI8hnb/YGqTd3MdhmSJpqeWk8UrZcTCfv9IvFWRmdLQcBX8tWbGKN4KBvbOEJ+
 EETPihJUuo8Fv747IZjxQehWVelRce/UwRVy83oJFO+hbvPTHpQi+IVjW3yMXgmJzK+H
 F27yNQMNOwh5K9XYmMwdm2gEuDDNQoEjQcctogIZhgnGP8eVl1utqqHRhFOj1a+KnMcs
 NNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=iBPgoenc4+VXFgVYv4Mb1skeP6ikfbF6DUFZDuY5ah0=;
 b=OKPJjT5uvzxMC5ZnMf3loZvZWfPYuM9ixqAle21rTzERPIU/l9kyYcf3r323EPMImu
 GVZ3/xoI94wQGGWFgaMVL1jNtQYuRsYgivMKJbXSTKR7tEuj3SYEFIJFIYdLuVvxzp0k
 /O18AmQgC7pznLjGB1jApQFCIuZBZXhxqg9DV4VGt+qDvMC2PMS6cSQxaWN1eLxM+8HN
 G7Bjc2VOcJzyiEiFaod/iCfPt/hnarbKa2wzpmY25wE/Y9nDnJuSrg01bePoGtkAVLuf
 Q2j2wwCTKbb4Wy2TgKFGlA0VqkHNEmO/dX2ssE3RclJC0x5iAuT9NOqjqaYVFl5Ce37u
 1rcQ==
X-Gm-Message-State: AOAM531egivSbpBs9e4woBosSeCPB+osj6SchDApmD6hRc9/+sntLHHd
 aope5UjWMvvRIyn4UdpevKAHfg==
X-Google-Smtp-Source: ABdhPJxJX3H2bjJ6ZWWGMvygaz55JMVzxmecp5Rkf4VcZ3RHRl9KDTV+xgJcccrQmFsHPJCg9w3A/w==
X-Received: by 2002:a7b:cc8f:: with SMTP id p15mr4585583wma.111.1622630993639; 
 Wed, 02 Jun 2021 03:49:53 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com.
 [35.195.168.105])
 by smtp.gmail.com with ESMTPSA id a123sm2687146wmd.2.2021.06.02.03.49.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Jun 2021 03:49:53 -0700 (PDT)
Date: Wed, 2 Jun 2021 10:49:50 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 2/6] KVM: arm64: Move D-cache flush to the fault
 handlers
Message-ID: <YLdiTnfuhMimU4dE@google.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-3-wangyanan55@huawei.com>
 <877djc1sca.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877djc1sca.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wednesday 02 Jun 2021 at 11:19:49 (+0100), Marc Zyngier wrote:
> On Thu, 15 Apr 2021 12:50:28 +0100,
> > @@ -583,6 +589,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  {
> >  	kvm_pte_t new, old = *ptep;
> >  	u64 granule = kvm_granule_size(level), phys = data->phys;
> > +	struct kvm_pgtable *pgt = data->mmu->pgt;
> >  	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> >  
> >  	if (!kvm_block_mapping_supported(addr, end, phys, level))
> > @@ -606,6 +613,13 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> >  	}
> >  
> > +	/* Perform CMOs before installation of the guest stage-2 PTE */
> > +	if (pgt->flags & KVM_PGTABLE_S2_GUEST) {
> > +		if (stage2_pte_cacheable(pgt, new) && !stage2_has_fwb(pgt))
> > +			__flush_dcache_area(mm_ops->phys_to_virt(phys),
> > +					    granule);
> > +	}
> 
> Rather than this, why not provide new callbacks in mm_ops, even if we
> have to provide one that is specific to guests (and let the protected
> stuff do its own thing)?

Ack, an optional callback in the mm_ops sounds much nicer.

> One thing I really dislike though is that the page-table code is
> starting to be littered with things that are not directly related to
> page tables. We are re-creating the user_mem_abort() mess in a
> different place.

+1, we should probably keep the page-table code as close as possible
to a standalone and architecturally-compliant library as opposed to a
mess of unrelated logic, simply because that will lead to a cleaner and
more maintainable design in the long run, and because that will ease the
interoperability with EL2 in protected mode.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
