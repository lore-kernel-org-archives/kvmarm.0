Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3859C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 18:05:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5BE49F28;
	Tue, 22 Mar 2022 14:05:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7l-52NBKrVmw; Tue, 22 Mar 2022 14:05:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A24449EEE;
	Tue, 22 Mar 2022 14:05:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D12F849EEA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:04:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8A2md7VT8cC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:04:57 -0400 (EDT)
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com
 [209.85.166.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2F1449ECB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:04:57 -0400 (EDT)
Received: by mail-il1-f178.google.com with SMTP id d3so13007580ilr.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=mnfs0TGaLCiuR8+h7Bh7JMBdIzmhOD0lSzxPoaLstY0=;
 b=Ai5ApELwIGxbAGkA7bjCsyR06EgM1YDueepe43Ht6yQpfzmaehyh2jghZB+UEQXXp+
 b+yG8TxNPBHJ0lGuUDHKcIy+5RFBdedUl80l+9B1M/CnuJhACvcHwDNTPmMyUoHHurFt
 TaUwbc9sNQaTF5RbHPk58TCMYSygYYVu4HZSVd0889x8GIjwqkWK3K+uBhrFsXkW645y
 OaeOFOp7ujmNQJ6VtHXVLUoUe51I723IzUqprOMnhYMgqV8nG56hucbv2Rhy4KwOnGps
 6O9vq0L+84lmtJ/G4x85esjVcmytLf1zstdDHAJqIgMZzdNG91ghhvfIcWN5gka3rysA
 pmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mnfs0TGaLCiuR8+h7Bh7JMBdIzmhOD0lSzxPoaLstY0=;
 b=H/1JZe3aoxhR2k1FsHmMDfXrTnPv4Q066vflc3sQUpzgsZ6GyYuc8OKWNmMfWM0U2z
 wpn14JYg2eqvP5Ox8nYNBvK33wrB/tzLu4rkI5PJWWS9FGCz+EA96FyBysLDJN3Z7A+D
 VaFPE24OPwlizr6FXGjJbt0paLXHTHJ0UqNd7qbJz5VNUiI97yVEWAnl9R1QeIrHMwYS
 11LigDUKMmvtDSRyZUloZzBfuqcSD/0XXNCNQ+YghDGbJF1XaYrzojat37Xmva5TkuKk
 FlX4GuOGQAAOXBTUcEvVNWuQGtRD58+fCCm+QHvd4UMcuz2NT8OeOJANymMqJxaHeR3O
 Utlw==
X-Gm-Message-State: AOAM533OXOsF2FXqyLsQQLgXWWFy0wy1nP0MSF3ilq3DNqoDUaqTi5Ej
 GwVWzICrtyLJeM8zzbjV+aFeJXojabjNZA==
X-Google-Smtp-Source: ABdhPJye2KWFKxhR/JkKla/5EeDb9ty681k7BmUZOKULsq7C/DlrxsaYNUuo5fKFZrXcVmXaz73tVA==
X-Received: by 2002:a05:6e02:1b09:b0:2c8:3fa3:d7a1 with SMTP id
 i9-20020a056e021b0900b002c83fa3d7a1mr2564306ilv.173.1647972296912; 
 Tue, 22 Mar 2022 11:04:56 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 9-20020a056e0220c900b002c8276ca065sm4070180ilq.2.2022.03.22.11.04.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 11:04:56 -0700 (PDT)
Date: Tue, 22 Mar 2022 18:04:52 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 03/22] KVM: arm64: Support SDEI_VERSION hypercall
Message-ID: <YjoPxLAMIPobBzS0@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322080710.51727-4-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 22, 2022 at 04:06:51PM +0800, Gavin Shan wrote:
> This supports SDEI_VERSION hypercall by returning v1.1, which is
> the specification version we're following. The vendor is set to
> 'KVM'.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 8a9b477b8977..5a3a64cd6e84 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -118,6 +118,14 @@ static bool remove_all_vcpu_events(struct kvm_vcpu *vcpu,
>  	return pending;
>  }
>  
> +static unsigned long hypercall_version(struct kvm_vcpu *vcpu)
> +{
> +	/* v1.1 and the vendor is KVM */
> +	return (1UL << SDEI_VERSION_MAJOR_SHIFT) |
> +	       (1UL << SDEI_VERSION_MINOR_SHIFT) |
> +	       0x4b564d;

It looks like the SDEI specification states that the vendor-defined
version number is 32 bits. Could we just use one of the
ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_{0,3} values instead?

ASCII 'KVM' is neat, but in reality guest software will just throw it in
a macro regardless. Might as well use one of the values we've already
trained it to use :-)

Also, it would appear that guest discovery of SDEI relies upon KVM
reporting a valid SDEI version. IMO, this patch should come at the very
end when KVM actually implements SDEI.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
