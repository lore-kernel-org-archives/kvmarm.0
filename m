Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6C3C38A2A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 15:08:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 008D12073A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 15:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QLPKtMif"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 008D12073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96C174B29E;
	Thu,  7 May 2020 11:08:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZhqtONCnOhNL; Thu,  7 May 2020 11:08:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 365054B3D0;
	Thu,  7 May 2020 11:08:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C491F4B2A4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 11:08:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6X+StM91dAcv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 11:08:51 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D0CC4B29E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 11:08:51 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id y4so6802511wrm.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 May 2020 08:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=TQa81UcYxl76b0HSzt9euhUmUepcpv3Z6r/LM6Ln5KE=;
 b=QLPKtMifAlPpfvwJKFqGd26kBFWPILMeiCXFGFuEBE548R8w7lgb/0jsPh1bu3DHka
 breNdX586T44AB8m87A/JFIhSjk18lq8Ve/dJA8HOPPUdvxMajShm3p9OrMioRH7BjNk
 OtO/C7ZoIrq3QXqeHbPkDtJj/UCSnMPHzfmtbcFPKku/qJ3SLGEvDZfQNIGTDQOHihp2
 RZUnfXmJAg5LekkpLJLHtjTC60tVDp/QS+HCO4fpBcJAltENqV7gK5zsOYx3ba2n1ytG
 Gid9G0dnaQqFzt1Mv4dH7ozS4PPRWrE3NnI+YiPyf0hsTtLfCKlYI43SN/29CxJTkK6U
 Irsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TQa81UcYxl76b0HSzt9euhUmUepcpv3Z6r/LM6Ln5KE=;
 b=dpesNTOJxfFx2cPvD2a5XXa2KN3aeoPAhIzaPNO1JnHlEgGh7ZhO3/a8/ju2bwEykU
 TTDQqZT0NnRYJxFCblcyIG+HjpsUjBzU3RKmw6jbC0i0gyD8pC6gd3j5kOB61FxEcI71
 jQFue0AmYspV1x3g7LRXW4B+ZmNHWK6ldhLocJlc0wB3xWYuxkawdOMOiKDmUnllw7SY
 k+XvpPSD7OT3W91ZAfKr/bF8UAgq9U1cXIphnheNhnx3hgUJ25eW1Y19/Ucc6WP4zj9g
 9OIZCGfSQzoUIbtBJN5tCdJDTMli5aQJ4GZWv086HWX55sMWbLRUqYBRYnK2D71O0J5q
 dbwA==
X-Gm-Message-State: AGi0PuZzuNAI8O2bvxQM0x4faNl57neyE+HMkV/29ndTag7OTcIFe5RI
 mNjwv4T7QwQeVQg6ueKauVprXFQfoW8=
X-Google-Smtp-Source: APiQypIHxYj17NVfmcnSuGrpk40/cA1y0gsCzWWQg9AehmmC7nw/0HsXW/bsHDdO/dPr7ICzSJ0SUQ==
X-Received: by 2002:a5d:5445:: with SMTP id w5mr15635148wrv.422.1588864130021; 
 Thu, 07 May 2020 08:08:50 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id u2sm10491869wrd.40.2020.05.07.08.08.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 May 2020 08:08:49 -0700 (PDT)
Date: Thu, 7 May 2020 16:08:43 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 07/26] KVM: arm64: Add a level hint to
 __kvm_tlb_flush_vmid_ipa
Message-ID: <20200507150843.GG237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-8-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-8-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

> -void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
> +void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
> +					 phys_addr_t ipa, int level)

The level feels like a good opportunity for an enum to add some
documentation from the type.

>  static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
>  {
> -	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
> +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, 0);

With the constants from the next patch brought forward, the magic 0 can
be given a name, although it's very temporary so..

Otherwise, looks good.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
