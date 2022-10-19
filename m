Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ADAC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 23:32:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FFCE4B8EE;
	Wed, 19 Oct 2022 19:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8x+sqiB99h9e; Wed, 19 Oct 2022 19:32:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 524864B8F2;
	Wed, 19 Oct 2022 19:32:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7685F4B64B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:32:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D6KE3A3wV681 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 19:32:41 -0400 (EDT)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E35B4B646
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:32:41 -0400 (EDT)
Received: by mail-pl1-f172.google.com with SMTP id c24so18691298pls.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 16:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=GOdTdD623/YusJfsR/UmEt7HXnKEb0mP+WLNynhu5/Y=;
 b=RWtmUC50GX+0ZQ32g5qbwMLI9xk+r3RrIN8WIX6WSDXgNKi/IH1rFAOE4BaRmDOCQk
 q7NcLh/IYp1ium4abQncAyZUxt/D3M5+XQl9CoRXilqBPO8N7h8Jf1CsFhYVmbXfCDdJ
 GbBFo1r2OXRzCG1d6k4VKyRHomEcqSQLuRT1GyZuynIX/BDcf2/PoFz/pjQyhWdxhJ7R
 sVD0VYdKcDhEum9a00zy7yQZGSf1l+tyC0pHYAEN1ldQKbAxqHQ5v3UZrDNPbgf8ayEb
 tsZrpuY+i/Gwr3TBh/bb8CgBxKZoVz2rjfEqDWpfKxbbZxwNuW3dc3dvsTFn1MN1mOlW
 kiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=GOdTdD623/YusJfsR/UmEt7HXnKEb0mP+WLNynhu5/Y=;
 b=P32SMf/TBGsjLWVMLYzrGs91ZP+OTwEd0zK9acnHAGseY+I+zZYDdVhkkX/itJ8DOX
 +lMHhpdk+wRKgb3W5SOA6bCzYPo4JtdURiKvrl+tU9elu6Ap85ctK+jl0qoQl/eKHD1m
 +8ykOh+aC5ysOmVM3pvCfq1143+vBF8WhlZ1EGa5ntGy2n/aBz84A1yzlRZBPAsqIMoK
 g7iS3i3e7rt8O6M0/E0e1noDThl1vO7810uW+t+tg/EwvFbc14hAQFS5MtUT8aBFJJTh
 m2wmTA1vcg6D+KcU8+GCZyoPsMhzcZO7sABCrE2/FZQA9vgmSbzF8+sgn8titzD2ZUBW
 MmPw==
X-Gm-Message-State: ACrzQf1IC9KYrNDv6sFfNeyC7mhtOONa2EEeVufGQyS4wdM58M7B72Yt
 /4bkbWgZlbbrX+9kHghRg+4Y6w==
X-Google-Smtp-Source: AMsMyM7CQOx8R08XpaqcxD826bEvd+nBp7WOm8CizWjgaSQhvlO4ECeDzJxBWgIKiZPBPtpO/OIQMw==
X-Received: by 2002:a17:902:e3cd:b0:17f:9c94:b22f with SMTP id
 r13-20020a170902e3cd00b0017f9c94b22fmr10927856ple.80.1666222360234; 
 Wed, 19 Oct 2022 16:32:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 f14-20020a170902ab8e00b001783f964fe3sm11270350plr.113.2022.10.19.16.32.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 16:32:39 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:32:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y1CJFLVnnbX4Ck85@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007233253.460257-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221007233253.460257-1-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
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

On Fri, Oct 07, 2022, Oliver Upton wrote:
> @@ -1534,7 +1517,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	 */
>  	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
>  			       PAGE_SIZE, __pfn_to_phys(pfn),
> -			       KVM_PGTABLE_PROT_R, NULL);
> +			       KVM_PGTABLE_PROT_R, NULL, KVM_PGTABLE_WALK_SHARED);

All MMU notifier events acquire mmu_lock for write when invoking arch code, i.e.
this isn't a shared walk.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
