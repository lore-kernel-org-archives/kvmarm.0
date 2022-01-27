Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828D1C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 07:34:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC1044A0FE;
	Thu, 27 Jan 2022 02:34:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qkETiPCLM7PF; Thu, 27 Jan 2022 02:34:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9792B4A014;
	Thu, 27 Jan 2022 02:34:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4B14A014
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:34:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4vqRfR7BgTLd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 02:34:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0EF49F5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:34:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643268882;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rZtyNWVIJ5YOp9jbjrOdT7tvYwsl2Y7lnfgiw1GSFeM=;
 b=U88hv5hdhFtseJ9+eVHQeNEJclU4Mkc4Xn8/zzprqS4j8dUUw+3ZWl7fGSfkO9gZ7qOcMJ
 gInr7T2HBb3xbmXYoBxEWBYyCUEz6M3Gb5QhAJhOV22npBkRTZoIBeu5JxW+PVSSXkl22Y
 EKt/4mHwxMr3N72fO3+knuikJ+5cEcM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-kO3WZSfhNxGoMozkHWPyLw-1; Thu, 27 Jan 2022 02:34:38 -0500
X-MC-Unique: kO3WZSfhNxGoMozkHWPyLw-1
Received: by mail-ed1-f71.google.com with SMTP id
 a18-20020aa7d752000000b00403d18712beso946290eds.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 23:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rZtyNWVIJ5YOp9jbjrOdT7tvYwsl2Y7lnfgiw1GSFeM=;
 b=t8kyqZ7C0bSAotNPpMlFGS5GOkmYzCdQD0nWKb1/Sr1zqPfMW56Z9BQVSmdW/ALnS3
 GT70Lkzh7/ozISY+dxu/oy/VivUrIlcLIsCdhO8lQHLcsN05zPJ7R5F7biHCSGzD4FsN
 kEjVshBif9N8TMJFbi2sexsdoZfhS+5HXPcGTaBF6xfkMogv4HwjyEh6JXV1akSx4gv3
 wElrtUS7dhAwvZt3iNWtUb/B6eDBySICLY8M3XZ7AitpRFKOmJuC9Q2iIzKTJG5Mesd1
 6D1xCGfLupgQoK+t9s9rZw8IyRShQqsZ55MCjWmvPSB+qNVzjbKrSbFB5L5Q0vWAcALF
 fvuQ==
X-Gm-Message-State: AOAM531Xmqr+REfseh2LMAGEmX39r9UvYb0n+bqSkgKqtKejfurFQGjJ
 psPTLU9fo8cqpp6dzvykCzPCN7cb++LyjiHl3S6YQqLMU27oEsrgVotEfmTh8BwC+CwmLDb8Eo3
 0x52w007Pa+S15RPE/6RqyF/8
X-Received: by 2002:a17:906:3656:: with SMTP id
 r22mr1928253ejb.329.1643268877734; 
 Wed, 26 Jan 2022 23:34:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJLhumx8C9wQK88l4ogwUYtf8FjiIGnNJTylnn3U7wYd9tsoL3ojKCLIabRhgnbZMTq8uEQQ==
X-Received: by 2002:a17:906:3656:: with SMTP id
 r22mr1928237ejb.329.1643268877580; 
 Wed, 26 Jan 2022 23:34:37 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id j26sm3046934edt.65.2022.01.26.23.34.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 23:34:37 -0800 (PST)
Date: Thu, 27 Jan 2022 08:34:35 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 1/5] kvm: selftests: aarch64: fix assert in
 gicv3_access_reg
Message-ID: <20220127073435.dmqskodccsiqj7oi@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-2-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20220127030858.3269036-2-ricarkol@google.com>
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

On Wed, Jan 26, 2022 at 07:08:54PM -0800, Ricardo Koller wrote:
> The val argument in gicv3_access_reg can have any value when used for a
> read, not necessarily 0.  Fix the assert by checking val only for
> writes.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>

Commit message said my r-b would be here, but it doesn't appear to be.
Here it is again

Reviewed-by: Andrew Jones <drjones@redhat.com>

> ---
>  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> index 00f613c0583c..e4945fe66620 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> @@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
>  	uint32_t cpu_or_dist;
>  
>  	GUEST_ASSERT(bits_per_field <= reg_bits);
> -	GUEST_ASSERT(*val < (1U << bits_per_field));
> +	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
>  	/* Some registers like IROUTER are 64 bit long. Those are currently not
>  	 * supported by readl nor writel, so just asserting here until then.
>  	 */
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
