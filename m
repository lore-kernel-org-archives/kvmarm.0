Return-Path: <SRS0=T6xz=FI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3B8C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 18:02:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C60DB22BE8
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 18:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C60DB22BE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F38EE4B173;
	Fri,  4 Dec 2020 13:02:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dEGwkf9Swyt6; Fri,  4 Dec 2020 13:02:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBC84B146;
	Fri,  4 Dec 2020 13:02:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 726F14B127
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 13:01:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ihwmQ+n4TFXW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2020 13:01:57 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FAC74B125
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 13:01:57 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id 3so7791253wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Dec 2020 10:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GunWet4p4NzVbI1r1RYLjYsxsi2RUASEtxkEDiSdayU=;
 b=Jfc+OXEDeUa9mmISz8ZsnfdTU5azIgUzZSQjepScJvm9Yeu8TYr4EJM80uzI2fPPUb
 +VHfBX79uMGHB9tHKddRRiKYoDNVPsF81RdvXjX2YfemDOeWnvFmz3ZxiR/7JPAX22f6
 5tMT6fGr07JcUY7GB6TGOBnJAKFTflWYID7FgrAq2cOxXoeSVAUMIZbgYmETKwvczVHC
 i2uHt2MIyl9qCZGghiulFP8richVb8xc9cRAfdQic9NmrXZkgiKYKb9exgtCKAG2qi7s
 +K6FOWmZssDvDm3FjzNmaKJV02LM7JGkf/1TCuPcURVOz8hqELdq/Q7z3jGSEoQGCoBB
 FD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GunWet4p4NzVbI1r1RYLjYsxsi2RUASEtxkEDiSdayU=;
 b=ivlRzyihmgjCTnDYl1/8y1+cZ/MN34r7e9oKIqlMBWAPKoXrrb76VOy9eg5Udx+p3u
 k//uxb/49Sn7ZZc7p+yCmrFE7PcJAMyoaUvGBmY2YLGlEw5ye0e28yogxDAhBC4XgCKX
 HHVP1TxW9BkZXjxHTRohzYHltqPh5GphJ8p1lI0ejyQHcI2Jor/1VOl/62403Nqum1wP
 a9+X+O++7QlNyYmcBOQ5OQCL0wI14GbuiKXONmxPXksC6GM3i4iZm/pAY6nm46HekAGH
 uCAnhOfi4u3XazIN2voKEEKXSmiRR4Uxg2LQedWL/4Q4q8UmDN0I0Tb5vc2RguWBOL8y
 w+ZQ==
X-Gm-Message-State: AOAM5339rQHIdioDswClI55Z++BiSVs1WZs9qnuA2KhRYdpCAcJ3AKh1
 VjRhxC+tIAUcIaAX+mrMQAYrHg==
X-Google-Smtp-Source: ABdhPJxSC8KwxX3qUAPvNVm0RO0ZB//wClhZM8fadV8xFb6AM2n7EFO2SRqrA/auNGP2dVoT3/qMcQ==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr5577311wmi.35.1607104916154; 
 Fri, 04 Dec 2020 10:01:56 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id u66sm4104667wmg.30.2020.12.04.10.01.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Dec 2020 10:01:55 -0800 (PST)
Date: Fri, 4 Dec 2020 18:01:52 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
Message-ID: <X8p5kLSIq2MoQZ24@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Thursday 03 Dec 2020 at 12:57:33 (+0000), Fuad Tabba wrote:
<snip>
> > +int hyp_create_idmap(void);
> > +int hyp_map_vectors(void);
> > +int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
> > +int hyp_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> > +int hyp_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> > +int __hyp_create_mappings(unsigned long start, unsigned long size,
> > +                         unsigned long phys, unsigned long prot);
> > +unsigned long __hyp_create_private_mapping(phys_addr_t phys, size_t size,
> > +                                          unsigned long prot);
> > +
> 
> nit: I also thought that the hyp_create_mappings function names are a
> bit confusing, since there's the create_hyp_mappings functions which
> use the aforementioned *hyp_pgtable.

Sure, happy to re-name those (and hyp_pgtable above). Any suggestions?


<snip>
> > +SYM_FUNC_START(__kvm_init_switch_pgd)
> > +       /* Turn the MMU off */
> > +       pre_disable_mmu_workaround
> > +       mrs     x2, sctlr_el2
> > +       bic     x3, x2, #SCTLR_ELx_M
> > +       msr     sctlr_el2, x3
> > +       isb
> > +
> > +       tlbi    alle2
> > +
> > +       /* Install the new pgtables */
> > +       ldr     x3, [x0, #NVHE_INIT_PGD_PA]
> > +       phys_to_ttbr x4, x3
> > +alternative_if ARM64_HAS_CNP
> > +       orr     x4, x4, #TTBR_CNP_BIT
> > +alternative_else_nop_endif
> > +       msr     ttbr0_el2, x4
> > +
> > +       /* Set the new stack pointer */
> > +       ldr     x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> > +       mov     sp, x0
> > +
> > +       /* And turn the MMU back on! */
> > +       dsb     nsh
> > +       isb
> > +       msr     sctlr_el2, x2
> > +       isb
> > +       ret     x1
> > +SYM_FUNC_END(__kvm_init_switch_pgd)
> > +
> 
> Should the instruction cache be flushed here (ic iallu), to discard
> speculatively fetched instructions?

Hmm, Will? Thoughts?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
