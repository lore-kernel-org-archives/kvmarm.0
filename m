Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B92AB54
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 19:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdY+FI6r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697485650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIrxwAD379HWttBABnirV+Sle9T8jRy9iSXJzz/TC4U=;
	b=QdY+FI6r7C5FVetDCc8Gi4cbVJONdtCMfbnN/o7rnz6cJNSMXb5Q+AozZ816b9wzapOy3q
	LnDXsZepkKu9tZmqDGwv1L9NvgTBAQ9ckkjIoEfFAWemGLRIgNfczmB/ZqeECSoYvANPPL
	OfppXmyeN7lGPgsZ1f+7GUZfI1tteFM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-cGL60g8-PPOAGUUKAChzLQ-1; Mon, 16 Oct 2023 15:47:29 -0400
X-MC-Unique: cGL60g8-PPOAGUUKAChzLQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7770bfcbdc6so605478785a.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 12:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697485648; x=1698090448;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIrxwAD379HWttBABnirV+Sle9T8jRy9iSXJzz/TC4U=;
        b=HuPdeOGXFYfnUS6G/lzzPndCID+WWhFkGBveNBzEMqdP6qDO/u+BYAV9KKqlQ1zZXm
         bSVfnTGwZuxo2xiCLNb1jYCXaOX1ONwqaYI6sTHearituhPmzRBogre6Leng0LAzgEKa
         fdEQN01rGFtryoLjsA1JjXsEAUiYvCEpThxuyZx6yZZtvPkLggAuZVJNfeX1BhQelO/l
         mhA+2JBWmFXegXQT91f910O/98yYF2IpVAPJa0DXFJqSgeCF2S7nb7CVbSYMEX6jRdoS
         xdTyR4pCSL+/v5k+azErdIOLthJCVUU+C4524pBEahtbGljmLbEZQOAxJPFmuPEY1EAH
         AKSA==
X-Gm-Message-State: AOJu0YyxQypzFLnX282nmRF8M3KsEo6xP85clHaB1z2dU5KMz/fOHPSQ
	ed54wZ3CV0JUVLmsCFMBPToPSVeh82wr0KQMyMmgan7B8+5NAWGWvtvl6bziWsACnhxS2YRVFyR
	xHQiWZL8Lv5ElM3jf
X-Received: by 2002:a05:620a:25ce:b0:777:7240:8de with SMTP id y14-20020a05620a25ce00b00777724008demr147002qko.8.1697485648710;
        Mon, 16 Oct 2023 12:47:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3u6I00hayIaOImQeZghUxCl82gdoyvt4Nd2uprPCzUlhJB397PjkrSk4Pvd5jxnjH++cZDQ==
X-Received: by 2002:a05:620a:25ce:b0:777:7240:8de with SMTP id y14-20020a05620a25ce00b00777724008demr146985qko.8.1697485648421;
        Mon, 16 Oct 2023 12:47:28 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id k27-20020a05620a143b00b007742c6823a3sm3226478qkj.108.2023.10.16.12.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 12:47:27 -0700 (PDT)
Message-ID: <20bdc913-57d2-abe9-d222-d77647281b43@redhat.com>
Date: Mon, 16 Oct 2023 21:47:21 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 04/12] KVM: arm64: PMU: Don't define the sysreg reset()
 for PM{USERENR,CCFILTR}_EL0
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-5-rananta@google.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-5-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> The default reset function for PMU registers (defined by PMU_SYS_REG)
> now simply clears a specified register. Use the default one for
> PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
> registers on vCPU reset (NOTE: All non-RES0 fields of those
> registers have UNKNOWN reset values, and the same fields of
> their AArch32 registers have 0 reset values).
> 
> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3dbb7d276b0e..08af7824e9d8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2180,7 +2180,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	 * in 32bit mode. Here we choose to reset it as zero for consistency.
>  	 */
>  	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
> -	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
> +	  .reg = PMUSERENR_EL0, },
>  	{ PMU_SYS_REG(PMOVSSET_EL0),
>  	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
>  
> @@ -2338,7 +2338,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	 * in 32bit mode. Here we choose to reset it as zero for consistency.
>  	 */
>  	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
> -	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
> +	  .reg = PMCCFILTR_EL0, },
>  
>  	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
>  	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

