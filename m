Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FD8C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 20:30:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FD374B162;
	Thu, 25 Nov 2021 15:30:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tAlRZsx+y1eq; Thu, 25 Nov 2021 15:30:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA304B129;
	Thu, 25 Nov 2021 15:30:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 386F24B15C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 15:30:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m19Xg0CrzHLe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Nov 2021 15:30:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6864F4B15A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 15:30:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637872241;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2ShhUEy+E07PE6bTnG2bcJwf8K2GrtR8GlOvuCWDf3g=;
 b=N6DrpoWKxZV1Ofg2+KXPchcnyvdfBEc2qRphVMTWWdzExXD6U7kwz6XBL0+RJIZr+WXQyc
 UU66NuZw+no3+mWbHPYFNLQF2ou4rONw8jpIrU5jqyUZgnrMbYcBec0KY1FznoTiyQ/XtC
 c6wgu7LZWoNqkLbL4P7CrCbC6HzCQd8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-gviWlHmEOi6svctWQgpY-g-1; Thu, 25 Nov 2021 15:30:40 -0500
X-MC-Unique: gviWlHmEOi6svctWQgpY-g-1
Received: by mail-wm1-f71.google.com with SMTP id
 g11-20020a1c200b000000b003320d092d08so3752040wmg.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 12:30:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2ShhUEy+E07PE6bTnG2bcJwf8K2GrtR8GlOvuCWDf3g=;
 b=qEHL5TjfraBHJQyMHFqILAyBeU83oPoHBEqK7XLA/TZB4+HGedlDOkhL6zyAwF81lx
 J3C3+OovunL5PtUjSCp1fXJKzVKe7jZXUxyaj6T5nXvA1nhbuVQd8os+hAipCcHQ70LP
 S7vuebT63E65cpXQC034qQkE8HmMCjtkc6JAo/TtKa41nrYWI2LTOH5mjal2lB3uRYuN
 5jxXmXf5fT9QO0IZ3mhK8lBIZ4MJaBz27oPI9fMMxPSI5/2dxehk73tCe0by1NsjnWeY
 pj85FAN4otW/00YD8qCSn3tAX7HVTB1ghKqSD3bMK6b+WJX1Ed6nL0ayQ1SttrehHSaz
 6qrA==
X-Gm-Message-State: AOAM531yTj7j1GXG72z7lB0N0dWl+ckucUZoRmjwCei/9nCOJYxu98gq
 xXYNFOzNveDeK8OFnuF8oNYTszzSvwF07wYnKAiuCm8SpoI4lplZqSgDM9ONbNvcrtzFRSnBpbP
 eTkCvRRRC8zQY6FcVZIuyMVGz
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr9806985wrm.60.1637872238937; 
 Thu, 25 Nov 2021 12:30:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxoQfLwsVNStdvgHx055e1d9E4GwQpVIsWLlaEilliddpDqSQaqHalFf+ziOP3Fem0ERY7sCw==
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr9806937wrm.60.1637872238693; 
 Thu, 25 Nov 2021 12:30:38 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d8sm3719945wrm.76.2021.11.25.12.30.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Nov 2021 12:30:38 -0800 (PST)
Subject: Re: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
To: Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-13-reijiw@google.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
Date: Thu, 25 Nov 2021 21:30:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-13-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
> by userspace.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index fbd335ac5e6b..dda7001959f6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
>  	.get_reset_val = get_reset_id_dfr0_el1,
>  };
>  
> +static struct id_reg_info id_dfr1_el1_info = {
> +	.sys_reg = SYS_ID_DFR1_EL1,
> +	.ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
what about the 0xF value which indicates the MTPMU is not implemented?

Eric
> +};
> +
>  /*
>   * An ID register that needs special handling to control the value for the
>   * guest must have its own id_reg_info in id_reg_info_table.
> @@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
>  #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
>  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
>  	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
> +	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
