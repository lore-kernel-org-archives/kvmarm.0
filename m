Return-Path: <SRS0=kePE=PC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3CAC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:33:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2B5B6109E
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C2B5B6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EB7E4B11E;
	Thu, 14 Oct 2021 05:33:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 75PvoKSnRsoQ; Thu, 14 Oct 2021 05:33:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A89A4B104;
	Thu, 14 Oct 2021 05:33:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4020A4B104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:33:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PGIL194+OuF0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Oct 2021 05:33:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 623AA4B102
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:33:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634204020;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=g+qKgYe2or+Sc1RbFHq4jz8CZNRQL9bv8FnY68X7aPs=;
 b=AOuBD/BJcUBnw3D6Js0V+QFuGBbNRBId9NBbR0prCnddMyhdYJmbDG944R0jzNCKP4rBbW
 0LDv2wpWp9Z/VBWvu231oQRwuo/EFvK1w1wX2coI0jxPdQAfMAqNSqjEMJmsn8+R2WXta+
 zoanuDK0XJufNeEQ4goXkqyA5e7lX0w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-6p79FJQPOJeEWDt3k8m0ZA-1; Thu, 14 Oct 2021 05:33:38 -0400
X-MC-Unique: 6p79FJQPOJeEWDt3k8m0ZA-1
Received: by mail-ed1-f71.google.com with SMTP id
 u17-20020a50d511000000b003daa3828c13so4657109edi.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 02:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=g+qKgYe2or+Sc1RbFHq4jz8CZNRQL9bv8FnY68X7aPs=;
 b=TNpp6a0BSrZfE/AJxQA4SuTSfZU44U3MjGsikPa5HJ/Hm7mVvK1UZgB9ztCJrR1qA2
 5kaHOA1w51ku+tQTsojMEr5UNJypopm7UR/ykjNjPK4Oar2HUsATna1tjvTfguApccYG
 +0mk5RdM0En8evwdPXs+3xvcGtUNzbU5HNJyK8vP6y0prwrRn/RQ4ZEFNoj5oy5kq6Ri
 qP4sSeAu0nT5V2Kek9eyaUBo8AFtLx9lcJzUeQqsH3v/JocFQ6BowO5CKpPl5XP/KAz4
 SpA8lQVRbc+7YPb0tQWb4WUi43acMjw04ResTaVIv7egLfgPQy2QlgEYz8erzpOhr/oW
 bqEQ==
X-Gm-Message-State: AOAM531LXh3MLAMcuHMTLOWY2GUDRJvcPZFkOea/2suEV57jW+napqNo
 lyBtrn02w1lhbnrlPzYCGjc/NTWpcoo/QBMI1yfGrdNG258x6IJQAPdqw/2PpWkR1c6d5EqsZ/p
 AW/eRKqDVhEIoTaXyGgx4ZtQU
X-Received: by 2002:a05:6402:26d3:: with SMTP id
 x19mr7209194edd.291.1634204017717; 
 Thu, 14 Oct 2021 02:33:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7MSURCxOPkKwvOo5kN+vRvhSn3bfJNdQoM7O2vNnzKZ4pe0EdSxkj+IgJUCdS0zoiEpLTBg==
X-Received: by 2002:a05:6402:26d3:: with SMTP id
 x19mr7209183edd.291.1634204017549; 
 Thu, 14 Oct 2021 02:33:37 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id p10sm1508944ejf.45.2021.10.14.02.33.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Oct 2021 02:33:37 -0700 (PDT)
Date: Thu, 14 Oct 2021 11:33:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 15/22] KVM: arm64: pkvm: Drop AArch32-specific registers
Message-ID: <20211014093335.puukcvmhts5t4jmh@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211013120346.2926621-5-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, Oct 13, 2021 at 01:03:39PM +0100, Marc Zyngier wrote:
> All the SYS_*32_EL2 registers are AArch32-specific. Since we forbid
> AArch32, there is no need to handle those in any way.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 042a1c0be7e0..e2b3a9e167da 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -452,10 +452,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>  	HOST_HANDLED(SYS_CNTP_CVAL_EL0),
>  
>  	/* Performance Monitoring Registers are restricted. */
> -
> -	HOST_HANDLED(SYS_DACR32_EL2),
> -	HOST_HANDLED(SYS_IFSR32_EL2),
> -	HOST_HANDLED(SYS_FPEXC32_EL2),
>  };
>  
>  /*
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
