Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5E7C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:22:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF17E61278
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 13:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF17E61278
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671CA4B0DF;
	Thu, 30 Sep 2021 09:22:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gC2ydJVwu33K; Thu, 30 Sep 2021 09:22:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 815D54B0CC;
	Thu, 30 Sep 2021 09:22:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F67B4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:22:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DzA43qi053tD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 09:22:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C692049DE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 09:22:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633008131;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6ckZ1pppA29wAm+9rfiJ1n/Mo/PrqlcBv4nOphRPsTU=;
 b=bgoUezSBdcbSFe8dYmIp32yOXQf+Np7LDWovTfzFQU0JjDDqNvDaYT8cGhtWwClCIPKaVC
 LJYjznrBXdfZ000QEQzcKWpaTAp+E0YcXvluR4dRteAiwthjEan2wEyOyR+FMJ3VjLTICj
 5hIih4E1JDgvw1q2Ma46o+WCz4bPuWc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-BTX9GaDFNg2oG4hndA7dyQ-1; Thu, 30 Sep 2021 09:22:08 -0400
X-MC-Unique: BTX9GaDFNg2oG4hndA7dyQ-1
Received: by mail-qk1-f199.google.com with SMTP id
 t2-20020a05620a450200b0045e34e4f9c7so13265400qkp.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 06:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6ckZ1pppA29wAm+9rfiJ1n/Mo/PrqlcBv4nOphRPsTU=;
 b=elmrpyOKL65wkgOqG3SOyvBK/BJ6a0UUwXabJcJKinX2xTSUc6z5OSrFuwt3u6CQjc
 4oKlA+7pqMkVAwKpJXONlXFdTcJI1A5UQjed+SF8kQHXrItuCn13ulPaIbNZRuVjpV91
 AU0w7bDn7EbP8hFws4j1Y4BXWxpsM20OSLCV37NrXIv4FeKGzhd6FoaL0nJq5dkXm3rr
 INXXa/yS7NdMwWGguLN5MuEqjCEW5A5khqdzsWdI8z9kK0x0LxZzVckqahqgD5j2mRm8
 vVdHL/X3DU8gMh1MWqco04JUkZZ0A1/E5HM30+AxFOQe5sKet8cMu1haB3BDAZRyYdf9
 JZUQ==
X-Gm-Message-State: AOAM530DeE8or1fixwPo1wVm+Q8yuVuj3UmQE0+cI45tw+acDiPW4uUT
 QGylf0T2Ix6Xfqb/j3gtIguBgSfZ5l3hBGy+pb9lHkJ4VZzgrhahlJkAMFPLdbVygl5NUasJoUQ
 ArXkKoPggc2Ye49qWjoq2ycmc
X-Received: by 2002:a37:d82:: with SMTP id 124mr4751622qkn.299.1633008128508; 
 Thu, 30 Sep 2021 06:22:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygLLhtXJjxjuaO0dACez2L3lInr7k748BHulrSq78dll6LEjGrJO1fGfBl8yf2p3YtMw287A==
X-Received: by 2002:a37:d82:: with SMTP id 124mr4751602qkn.299.1633008128329; 
 Thu, 30 Sep 2021 06:22:08 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id h4sm1586843qtb.67.2021.09.30.06.22.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 06:22:07 -0700 (PDT)
Date: Thu, 30 Sep 2021 15:22:04 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Return early from read_id_reg() if
 register is RAZ
Message-ID: <20210930132204.m7l4tdzzenllnr6h@gator>
References: <20210927124911.191729-1-alexandru.elisei@arm.com>
 <20210927124911.191729-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210927124911.191729-2-alexandru.elisei@arm.com>
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

On Mon, Sep 27, 2021 at 01:49:10PM +0100, Alexandru Elisei wrote:
> If read_id_reg() is called for an ID register which is Read-As-Zero
> (RAZ), it initializes the return value to zero, then goes through a list
> of registers which require special handling.
> 
> By not returning as soon as it tests if the register is RAZ, it creates
> the opportunity for bugs, if a patch changes a register to RAZ (like has
> happened with PMSWINC_EL0 in commit 11663111cd49), but doesn't remove the
> special handling from read_id_reg(); or if a register is RAZ in certain
> situations, and readable in others.
> 
> Return early as to make it impossible for a RAZ register to be anything
> other than zero.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1d46e185f31e..4adda8bf3168 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1064,7 +1064,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
>  {
>  	u32 id = reg_to_encoding(r);
> -	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> +	u64 val;
> +
> +	if (raz)
> +		return 0;
> +
> +	val = read_sanitised_ftr_reg(id);
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> -- 
> 2.33.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
