Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26344C433E7
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 09:48:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96B562076D
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 09:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="A7ZsCQpb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96B562076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 190344B2EC;
	Mon, 13 Jul 2020 05:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sjVqm-VriCLo; Mon, 13 Jul 2020 05:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1665D4B319;
	Mon, 13 Jul 2020 05:47:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 885F64B316
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 05:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FbPTGOZRN81y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 05:47:56 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E67F4B315
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 05:47:56 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id l17so12674122wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 02:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wU36Y0dkg3gAVd6d1AcAnpID0ooqTkwf12/Wn37dSh8=;
 b=A7ZsCQpbegT8axsNvUlyF9UT89ZbeiGiZkLrgxw1YmwTLxFMJeSBX5PVPDvwemiCQf
 +xdOx4uXQ04sxIVCK4z4DHESzUOUwvxMl1Pbr2+u1DqVXylIXHlVdC9tQ8cu4q2bMAkp
 3wcfRjrV8MULjMq8vbKugMS7E27X5BQMVf3Gk7wUolkk8AQHn380jLXMJcIFP+iHcONA
 wF86WUEtjwWADcagCLRleHr0e33uzB5lqVIMz3Q7LzU4PjbEaF6qRmFAEMcxtiKTvCaW
 lbrWyFdP56eeGYvwuHdtddQQo1T2XJL+8FS5TzY3Ak5EL5I/kkTT71VshclQHeN7BbpE
 25RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wU36Y0dkg3gAVd6d1AcAnpID0ooqTkwf12/Wn37dSh8=;
 b=IOc9W+Zu1HcnknwDRSMH4FaJiqKSBuZprXoicNRMSSHiTevEfVMUGfUP9WSlwXa4FF
 As4Om4/00off/THrZmvEXGomR5+ndbJaZ4YG1RmQxb0Pz9TL1XCoKjbpgIhcAidu/CfH
 f8627yrbiLLDo8bF8d15JD/M5MM4A2iEXoRDiuAL6u+yJPKbcrQ6DR7lgzn1H6U38IqH
 92pjGGmP+n+QK+y7tOkqByUEd37gt9NqxiGYlEAS9A+5T7HMLkcvJl0t41AG143++Agu
 eNd68maMRMsDWNl0C7k7v+JhIkFkbtcl3IJsWnrorknXS5pfI3MYGzkYAY+qhWUJ2gZM
 ozSw==
X-Gm-Message-State: AOAM530+IaHdDzDTb8k5gdtq49hX0dhb9h3kOEGTWCd2u03nyV2PeXXj
 Ma/0wX6nhkV9fF1how7IdgceuA==
X-Google-Smtp-Source: ABdhPJwyciHJulV8GXvdtkPxOyujpSo+cQuGQ3mGaHjDjrbR5btQ2IIFf/d0BtLDW6TxzTCNb06wKA==
X-Received: by 2002:a1c:c387:: with SMTP id t129mr17858571wmf.27.1594633675285; 
 Mon, 13 Jul 2020 02:47:55 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id z6sm19636364wmf.33.2020.07.13.02.47.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Jul 2020 02:47:54 -0700 (PDT)
Date: Mon, 13 Jul 2020 10:47:49 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
Message-ID: <20200713094749.GA1705612@google.com>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200615132719.1932408-2-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
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

On Mon, Jun 15, 2020 at 02:27:03PM +0100, Marc Zyngier wrote:
> -static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
> +static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm_s2_mmu *mmu,
>  						  struct tlb_inv_context *cxt)
>  {
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> @@ -79,22 +79,19 @@ static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
>  		isb();
>  	}
>  
> -	/* __load_guest_stage2() includes an ISB for the workaround. */
> -	__load_guest_stage2(kvm);
> -	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
> +	__load_guest_stage2(mmu);
>  }

Just noticed that this drops the ISB when the speculative AT workaround
is not active.

This alternative is 'backwards' to avoid a double ISB as there is one in
__load_guest_stage2 when the workaround is active. I hope to address
this smell in an upcoming series but, for now, we should at least have
an ISB.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
