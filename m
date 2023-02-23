Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711793205
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 22:34:21 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id y6-20020a056602120600b0074c87f954bfso5519630iot.4
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 14:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f5G8pOd3SsfHOvb383fp62P/cWOAfsSg8HgIFePsLTI=;
        b=Qts9DQIFDgpqPqkY2OB27ix9hDXO1g3+ptGVYA1Iak34y4N1HJjFRKpLPGhtgJBV0g
         2k0YDKTOX564NphkIu58VRqd6vDYuFiIB86gEWhsUurO5VrtrgCHt4JcOVZ7Q4dYbOEE
         /udVuJxucJpD3gnT/ALck3wSRWXavzAHIR9SfqDkKK4ooPA6HAlXQ44/cnuG20rqr25j
         eFrEAJLrP1tLlGzm+0lPHKozvjct25Ntr3XXP9bpFvZza+jZEtz9SuJ1aQwPEFMdCJ/4
         PJ9s1SuANSRqZQQ38Jl5sKU8n+9HghXjLKphcYQ70P3HX4M5ctZ5+Sh4mYdxQxS3yXLR
         liBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f5G8pOd3SsfHOvb383fp62P/cWOAfsSg8HgIFePsLTI=;
        b=GxGFVjv1GCbcS+llXN+W42xek/UnTnlNP172yR1PZSt2X0WcMH/KgPzlBAY51ydVtK
         wMLmEJsjAGtymSRySKpxp8qN5EmSAkv4QYxHu8uZJZS5O+CrHjBer5dFQbquwfGGdlIO
         lOjYrurWCV8APhqDG1mAa9eMSY8dyNAXy1So4Mkj+gBNyRJS4doA0p9RGeWhAO8R4PSd
         1CTIZonL6UT69J1LgkHOd0o83jgKC3Xfr+9wYTsYBXs5tA10VG5O4oUzHwS8w23ASdQl
         F7SADjNn2BgFpiFwN8WFl1bUv6tkJD1AEItcLRM9SduYqPc0nMiXYEkff1udiuAUjAkf
         nRsQ==
X-Gm-Message-State: AO0yUKXIbDfCes14wbLBKIhQp55QqRvGLhReJbnXMA96J3Z0z38pD7JS
	b7thrQwbBDxjLpPuSbjKnBQ8vCiE00AP4xjzdQ==
X-Google-Smtp-Source: AK7set8TaSIyth8jADCSw+x57VUjquM5K/QIekc64rxEpvlrEXEvHiHLNvBm/FfKB1f11iiuNTja2L3YSW+/JELC6Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:10f5:b0:3b7:9d19:fec7 with
 SMTP id g21-20020a05663810f500b003b79d19fec7mr5136649jae.0.1677191660511;
 Thu, 23 Feb 2023 14:34:20 -0800 (PST)
Date: Thu, 23 Feb 2023 22:34:19 +0000
In-Reply-To: <20230216142123.2638675-7-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:13 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntzg948104.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 06/16] KVM: arm64: timers: Use CNTPOFF_EL2 to offset the
 physical timer
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes


CNTPOFF_EL2 should probably be added to the vcpu_sysreg enum in
kvm_host.h for this patch. This seemed like the most relevant commit.

Marc Zyngier <maz@kernel.org> writes:

> +static bool has_cntpoff(void)
> +{
> +	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
> +}
> +

This being used to guard the register in set_cntpoff seems to say that
we can only write CNTPOFF in VHE mode. Since it's possible the
underlying hardware could still support CNTPOFF even if KVM is running
in nVHE mode, should there be a way to set CNTPOFF in nVHE mode? Is that
possible?

This caused some confusion for me on my implementation as some teammates
thought so but I could not get an implementation working for nVHE mode.

> @@ -84,7 +89,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)

>   static u64 timer_get_offset(struct arch_timer_context *ctxt)
>   {
> -	if (ctxt->offset.vm_offset)
> +	if (ctxt && ctxt->offset.vm_offset)
>   		return *ctxt->offset.vm_offset;

>   	return 0;

nit: this change should be in the previous commit

> @@ -480,6 +491,7 @@ static void timer_save_state(struct  
> arch_timer_context *ctx)
>   		write_sysreg_el0(0, SYS_CNTP_CTL);
>   		isb();

> +		set_cntpoff(0);
>   		break;
>   	case NR_KVM_TIMERS:
>   		BUG();

This seems to say CNTPOFF will be reset to 0 every time a vcpu
switches out. What if the host originally had some value other than 0?
Is KVM responsible for that context?
