Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3BEC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:29:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 113B7615A2
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:29:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 113B7615A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8620149DE3;
	Thu, 30 Sep 2021 09:29:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id stQbh2xLx+Uh; Thu, 30 Sep 2021 09:29:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 601A64B0BA;
	Thu, 30 Sep 2021 09:29:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA614B090
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:29:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w7KOZYPGaStd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 09:29:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2343A4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:29:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633008561;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Isl/b69bzCC4NRdxJvMAiKAJHzi4T9gPXKhGDEYhYsE=;
 b=beO732YWXoy1rvk8gy6FYYzc7WYRIDAz/WQbCxq5wAImq3xWm18SasVTASTmGprxp+SPTQ
 EyWIkcNjh38liKGF/qgd3HdbDXcFZctD8r6QW3zOIz/o2KQdays3vJAQHUf0JEC/chYvkl
 Xo9zFcX0LfWrzJH2H0zVLjFSl1KEgWM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-nmcU0wZ4OSmpZ3a7j5GzNA-1; Thu, 30 Sep 2021 09:29:19 -0400
X-MC-Unique: nmcU0wZ4OSmpZ3a7j5GzNA-1
Received: by mail-qt1-f198.google.com with SMTP id
 b20-20020ac87fd4000000b002a69ee90efbso11780530qtk.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 06:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Isl/b69bzCC4NRdxJvMAiKAJHzi4T9gPXKhGDEYhYsE=;
 b=N2pUeuRZvQIrAmwkPSrKCft2FIbkOWssWvg/0t1/s0Lt8ZeXIOmzm4J4ZOxw94t4xI
 2gw6LPgXqwNa8RKSirDhshu3FyAJdm5Wfqz7AOyo+gwjwXvxHGCTSPeyW/Aaw+TRk6Lo
 UOujpRAGIkn0Y+DXAfslhzmpsjh1QJwdoNv25Mt+6cTmra3skX62jrg/W8fbfB/xLFEd
 LdoeRMpvoUrdNFAlO1v/f8w15yqINMen0Y417N34Z/L/AySf8yxecPB0NAUD2WA6qmtE
 6ur0GrBnqvunkFLXqb4+8Q0dNmQO38C/L/H2tvKPqbCrDeQ8QQ4pzU+ITs95CoLxJpMX
 /VyA==
X-Gm-Message-State: AOAM530JaFbl9FERd++kd7020IGzFfxxKf0b9wSFepTIYbxE6cCGQxsv
 TZZDzgaWb5stVJyPNJFBwnXYexlynNh2EiIGXEPpmXyaK8iJGXuHfl+aB8sdULxgyarm5yLxy4P
 IuMF8T1CV0FnBYDphOFkFb/Je
X-Received: by 2002:a05:6214:393:: with SMTP id
 l19mr5390440qvy.8.1633008559122; 
 Thu, 30 Sep 2021 06:29:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFnirPv4PoNfVoyAlW5rSeeodnWwuclzJETP5skeYr77i7Uavc83v1bilffS7/xWhNPosu5g==
X-Received: by 2002:a05:6214:393:: with SMTP id
 l19mr5390424qvy.8.1633008558909; 
 Thu, 30 Sep 2021 06:29:18 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id w11sm1627246qts.9.2021.09.30.06.29.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 06:29:18 -0700 (PDT)
Date: Thu, 30 Sep 2021 15:29:15 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Use get_raz_reg() for userspace reads of
 PMSWINC_EL0
Message-ID: <20210930132915.cpfzxdlws2zlou47@gator>
References: <20210927124911.191729-1-alexandru.elisei@arm.com>
 <20210927124911.191729-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210927124911.191729-3-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Sep 27, 2021 at 01:49:11PM +0100, Alexandru Elisei wrote:
> PMSWINC_EL0 is a write-only register and was initially part of the VCPU
> register state, but was later removed in commit 7a3ba3095a32 ("KVM:
> arm64: Remove PMSWINC_EL0 shadow register"). To prevent regressions, the
> register was kept accessible from userspace as Read-As-Zero (RAZ).
> 
> The read function that is used to handle userspace reads of this
> register is get_raz_id_reg(), which, while technically correct, as it
> returns 0, it is not semantically correct, as PMSWINC_EL0 is not an ID
> register as the function name suggests.
> 
> Add a new function, get_raz_reg(), to use it as the accessor for
> PMSWINC_EL0, as to not conflate get_raz_id_reg() to handle other types
> of registers.
> 
> No functional change intended.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4adda8bf3168..1be827740f87 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1285,6 +1285,15 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	return __set_id_reg(vcpu, rd, uaddr, true);
>  }
>  
> +static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		       const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	const u64 id = sys_reg_to_index(rd);
> +	const u64 val = 0;
> +
> +	return reg_to_user(uaddr, &val, id);
> +}
> +
>  static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		      const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> @@ -1647,7 +1656,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	 * previously (and pointlessly) advertised in the past...
>  	 */
>  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
> -	  .get_user = get_raz_id_reg, .set_user = set_wi_reg,
> +	  .get_user = get_raz_reg, .set_user = set_wi_reg,
>  	  .access = access_pmswinc, .reset = NULL },
>  	{ PMU_SYS_REG(SYS_PMSELR_EL0),
>  	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
> -- 
> 2.33.0
>

What about replacing get_raz_id_reg() with this new function? Do really need
both?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
