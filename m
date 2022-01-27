Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB52C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 07:49:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DD149F1F;
	Thu, 27 Jan 2022 02:49:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g67hLVvLStjt; Thu, 27 Jan 2022 02:49:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C1E49F32;
	Thu, 27 Jan 2022 02:49:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682A049F20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:49:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6vTQWHZ112Li for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 02:49:28 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 261A749F1F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:49:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643269767;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=2M1Y5J7ea57QbWGURJTWHJUwASXNiDDATsh/06s16sw=;
 b=BaRzcKuPbXszwOEP0MKkG6XdCuFD5SL5fsXjJ5nC8v0KeTAWrFOyPljTl7O4FvN3dvTzQr
 2WHaGI4YMQtjgACefweQ80eu7hBbXYddO5j6QaN5CrTj+mNqg4TZGvEDq6XazxBhjRnOTA
 E5UtMy8Derw4Bukd8PYMiCjiEaWNBQk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-DJR1trOLPnqhcXhbYheAmA-1; Thu, 27 Jan 2022 02:49:26 -0500
X-MC-Unique: DJR1trOLPnqhcXhbYheAmA-1
Received: by mail-ed1-f71.google.com with SMTP id
 bc24-20020a056402205800b00407cf07b2e0so980891edb.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 23:49:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2M1Y5J7ea57QbWGURJTWHJUwASXNiDDATsh/06s16sw=;
 b=YhsgJU3+8qZS9cwT9BQW07Kym1Z4cWREc4a/Ihxk1Er9/7sFdtCpdwol3FKktBsQsy
 y9JSgZ3ZIyLRmizXnb4bBKnIkVKEiqfwdD0PaYVuCfCMsAcgW7xCyBma2PbE7p3TWIbF
 oW9unN3027DJmOd2m2WkohDeWwwcmWUjs6hh4uJK/Pjbd/IA7/JDkMRwIEXFBDxdoho8
 H6gg7ojzlE2tUvot6CdTz/0Cecf7YayRSjbci6XjSs9F5bttZUtN8ytqColuAoL+AA6I
 3N2EZHw8iw5dzm9LhLTO2nxJ3DzYTot5PUN34acox15HFSHpuNnL4wcojR3nR0MfjrKD
 /SRg==
X-Gm-Message-State: AOAM530n8eUmZZwKxCFxgFDOJVXi0CEdxkjPwCRoMI5RJLPD3PWDMsPu
 27CvDQbkqrMDba40sIPG4/S67fwaHjld2BQ0bQumJU2ld9bvAe/aLtJwVf/aLxHLG66GyAXKAbW
 iWfpZ4TERSGve4GpikUsNW1Zl
X-Received: by 2002:a17:906:ae8a:: with SMTP id
 md10mr2063860ejb.726.1643269765279; 
 Wed, 26 Jan 2022 23:49:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGpL/2ZnX3mqkVZZyZhokQnWV5oIL1rIszy/xyBe7GJ6tdoLJQ4LSjT//1ZdrpZ5AQtUJTRA==
X-Received: by 2002:a17:906:ae8a:: with SMTP id
 md10mr2063849ejb.726.1643269765087; 
 Wed, 26 Jan 2022 23:49:25 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id gu2sm8295149ejb.221.2022.01.26.23.49.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 23:49:24 -0800 (PST)
Date: Thu, 27 Jan 2022 08:49:22 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 4/5] kvm: selftests: aarch64: fix some vgic related
 comments
Message-ID: <20220127074922.6m53vckomn7lacog@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-5-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20220127030858.3269036-5-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Jan 26, 2022 at 07:08:57PM -0800, Ricardo Koller wrote:
> Fix the formatting of some comments and the wording of one of them (in
> gicv3_access_reg).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>

I didn't give my r-b to this patch before, but you can keep it, because
here's another one

Reviewed-by: Andrew Jones <drjones@redhat.com>

> ---
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
>  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 10 ++++++----
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index 0106fc464afe..f0230711fbe9 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
>  	uint32_t prio, intid, ap1r;
>  	int i;
>  
> -	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> +	/*
> +	 * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
>  	 * in descending order, so intid+1 can preempt intid.
>  	 */
>  	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
> @@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
>  		gic_set_priority(intid, prio);
>  	}
>  
> -	/* In a real migration, KVM would restore all GIC state before running
> +	/*
> +	 * In a real migration, KVM would restore all GIC state before running
>  	 * guest code.
>  	 */
>  	for (i = 0; i < num; i++) {
> @@ -503,7 +505,8 @@ static void guest_code(struct test_args *args)
>  		test_injection_failure(args, f);
>  	}
>  
> -	/* Restore the active state of IRQs. This would happen when live
> +	/*
> +	 * Restore the active state of IRQs. This would happen when live
>  	 * migrating IRQs in the middle of being handled.
>  	 */
>  	for_each_supported_activate_fn(args, set_active_fns, f)
> @@ -840,7 +843,8 @@ int main(int argc, char **argv)
>  		}
>  	}
>  
> -	/* If the user just specified nr_irqs and/or gic_version, then run all
> +	/*
> +	 * If the user just specified nr_irqs and/or gic_version, then run all
>  	 * combinations.
>  	 */
>  	if (default_args) {
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> index e4945fe66620..263bf3ed8fd5 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> @@ -19,7 +19,7 @@ struct gicv3_data {
>  	unsigned int nr_spis;
>  };
>  
> -#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
> +#define sgi_base_from_redist(redist_base)	(redist_base + SZ_64K)
>  #define DIST_BIT				(1U << 31)
>  
>  enum gicv3_intid_range {
> @@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
>  {
>  	uint32_t val;
>  
> -	/* All other fields are read-only, so no need to read CTLR first. In
> +	/*
> +	 * All other fields are read-only, so no need to read CTLR first. In
>  	 * fact, the kernel does the same.
>  	 */
>  	val = split ? (1U << 1) : 0;
> @@ -160,8 +161,9 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
>  
>  	GUEST_ASSERT(bits_per_field <= reg_bits);
>  	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
> -	/* Some registers like IROUTER are 64 bit long. Those are currently not
> -	 * supported by readl nor writel, so just asserting here until then.
> +	/*
> +	 * This function does not support 64 bit accesses. Just asserting here
> +	 * until we implement readq/writeq.
>  	 */
>  	GUEST_ASSERT(reg_bits == 32);
>  
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index b3a0fca0d780..79864b941617 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
>  		attr += SZ_64K;
>  	}
>  
> -	/* All calls will succeed, even with invalid intid's, as long as the
> +	/*
> +	 * All calls will succeed, even with invalid intid's, as long as the
>  	 * addr part of the attr is within 32 bits (checked above). An invalid
>  	 * intid will just make the read/writes point to above the intended
>  	 * register space (i.e., ICPENDR after ISPENDR).
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
