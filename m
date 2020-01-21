Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5BDC2D0DB
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 15:12:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0627124125
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 15:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d03V+NNb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0627124125
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CDD64AFDA;
	Tue, 21 Jan 2020 10:12:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Ecw2SOu1XH2; Tue, 21 Jan 2020 10:12:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 654B64B00C;
	Tue, 21 Jan 2020 10:12:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 323654B01A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 10:12:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nb0BlMWz2Nlx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 10:12:55 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2744B00C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 10:12:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579619575;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bu/iMoYfYBgd5jXQviUDjY/CFaD1fKEaBQDIzi7DS7k=;
 b=d03V+NNbwDAzbtz9CSnilOjPjOhh3OLD5C2Hd9nY014CwZUOgl1CR+DuZJinDiMw8o/6Kf
 IqFT4b8zqmg/WqdbEpSpXqqnAWyngWuLBnevXOe33oTNfaemXM6ulRkKtABlXC3RFosHCi
 MLB+n22AES15BjXHpD4ofD9LZ/0CZnw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-IN9cFT-iMHqqWzTr_809ag-1; Tue, 21 Jan 2020 10:12:51 -0500
Received: by mail-wm1-f71.google.com with SMTP id t4so734883wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 07:12:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=bu/iMoYfYBgd5jXQviUDjY/CFaD1fKEaBQDIzi7DS7k=;
 b=qwMYTlw5O+/XppbAA9Du5O5XP26g9kU4OcPWuZljbqiI/VmIC+RRzyEvjTWUEVyGF+
 MsK8ez3gABMQV2D8YLV+s62cbSEdLMa60GVBkJReIgj+nluRLsP6qGnDN2ejpRwDOlQI
 htAT7G5tV3G27kNoEusxzegVXiTSRzu0sIZUjl/GHpYFYLonqkz2FcO4I7jM6bihUDg1
 DT+9kaG8ilovLmJuBGNy79/Qi2W7GDP21K2qA3U/Or0CHVkEBn10MxGpeaDr6TPhO5KP
 JKLKfNyc2Kei8TvdgPQs1xItkJ9jMgcOuoFeweG5icldNdRjQkh6cyz6kyXwyVuWzjV0
 yiVg==
X-Gm-Message-State: APjAAAVz8z0z0me3HuYltbvPfQNJLMr8JmuOAbUUH9r6O3iqhyB7tmT0
 yOIVDltUR8ChUMNKIqXmoH/25prhK9vPPeB3djXW43KzBKAKR9gNJj6Y63sw30edT/LtsPzSDnJ
 sJT5B/kdAQ4o702nsFaO5oDeh
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr5000213wmd.5.1579619569963; 
 Tue, 21 Jan 2020 07:12:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqx3W9/IFqNtFmh53Y8FuFyZdMe+4NHjz+xYUeI++YvzTVDVuRT0IkPp6ekS3qHgnEBSwWauFA==
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr5000170wmd.5.1579619569664; 
 Tue, 21 Jan 2020 07:12:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id b16sm54711240wrj.23.2020.01.21.07.12.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 07:12:49 -0800 (PST)
Subject: Re: [PATCH 12/14] KVM: x86/mmu: Fold max_mapping_level() into
 kvm_mmu_hugepage_adjust()
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-13-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <52cf5d90-5e65-4878-b214-7e1809224688@redhat.com>
Date: Tue, 21 Jan 2020 16:12:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-13-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: IN9cFT-iMHqqWzTr_809ag-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
 Barret Rhoden <brho@google.com>, kvm-ppc@vger.kernel.org,
 Liran Alon <liran.alon@oracle.com>, Andy Lutomirski <luto@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Jason Zeng <jason.zeng@intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 08/01/20 21:24, Sean Christopherson wrote:
> -	level = host_pfn_mapping_level(vcpu, gfn, pfn);
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!memslot_valid_for_gpte(slot, true))
> +		return PT_PAGE_TABLE_LEVEL;

Following up on my remark to patch 7, this can also use
gfn_to_memslot_dirty_bitmap.

Paolo

> +
> +	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
> +	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
> +		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
> +			break;
> +	}
> +
> +	if (max_level == PT_PAGE_TABLE_LEVEL)
> +		return PT_PAGE_TABLE_LEVEL;
> +
> +	level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
>  	if (level == PT_PAGE_TABLE_LEVEL)
>  		return level;
>  
> @@ -4182,8 +4172,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	if (lpage_disallowed)
>  		max_level = PT_PAGE_TABLE_LEVEL;
>  
> -	max_level = max_mapping_level(vcpu, gfn, max_level);
> -
>  	if (fast_page_fault(vcpu, gpa, error_code))
>  		return RET_PF_RETRY;
>  
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0560982eda8b..ea174d85700a 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -817,8 +817,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	else
>  		max_level = walker.level;
>  
> -	max_level = max_mapping_level(vcpu, walker.gfn, max_level);
> -
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
