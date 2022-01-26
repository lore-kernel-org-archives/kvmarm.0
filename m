Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C97BC2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:17:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38D1440DCB;
	Wed, 26 Jan 2022 10:17:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S0Tn25atFAbZ; Wed, 26 Jan 2022 10:17:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF0D49AF7;
	Wed, 26 Jan 2022 10:17:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB8B40E0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:17:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gUE49kAqgFPg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:17:30 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F9940DCB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:17:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643210250;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=enco3IhisiiJCqxipp6ORBzLiXPjBMV853tTPBlB3V0=;
 b=HG8vi/CIbQM+tDwzZYrvl/9DEEiPgjfAKeF+fssKJmsNq2nJXcTuk5Wb/6G5A5bvroH2f5
 jXQg7q3h38kpyRmx0etax3WtmwDCCWcNQ40AYWQs2bWa5XBX+r3kR1LLhohBvxQA3bIpYk
 tHwdErrgSnAhrq6ZuRVaP7qGCLTfH1M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-hX0N3CZEMp-Ujv1CdfM_Mw-1; Wed, 26 Jan 2022 10:17:26 -0500
X-MC-Unique: hX0N3CZEMp-Ujv1CdfM_Mw-1
Received: by mail-ed1-f69.google.com with SMTP id
 el8-20020a056402360800b00403bbdcef64so16819196edb.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 07:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=enco3IhisiiJCqxipp6ORBzLiXPjBMV853tTPBlB3V0=;
 b=7pdsoFG6aOdPmoG97CriHXneFZUDoJVoYVT3Azo6k3d2oq23bchkCQK3RQNlx7jNA5
 jvX2fY+lOUe+R/FyIBZ/kSvL+ahL5Y0yrgJCgxW6uusrXmYciHsDmrJZ+1acZw+yX4n+
 i0MayWthc3gCt94/ZqxMOv+FI4fbfTyuQyOT27HHsoA3ZOBKKJKsHddHHV7cC0FH8qca
 U1RGsYj14vke64Aow3mQ/wxGWHtv280nJsnNMlxcYq+WGNkOufzrODTG9/mjVhDYHSoM
 NRmHdxO+XkqN4l59pc77Olp7lzOSDePyJZe5HdOKn5dms2oLFiANzGG+lnkVYhNkXsym
 aa2A==
X-Gm-Message-State: AOAM531+0hLztEwMsuMA7xASVZgLIWSOJoWawyvIILjOEJiHaZtDd7Iz
 d9zxRricybdBbqVYFdQlgOn5Aqor08Zj8v1XRQCnrqv2P3T/uzNLPLv5kRH6XJLXfMXEFOOlav2
 3sUNVe3fvK6Q3y6HS+DdynN+V
X-Received: by 2002:a05:6402:42d0:: with SMTP id
 i16mr25601054edc.143.1643210245866; 
 Wed, 26 Jan 2022 07:17:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXMv3eA9lQHhc4IcU2U+Yip2mSW1MIOrMol37/92RnG0VGlb0ODLVMG1k0h0PbwSGsD36zSQ==
X-Received: by 2002:a05:6402:42d0:: with SMTP id
 i16mr25601041edc.143.1643210245721; 
 Wed, 26 Jan 2022 07:17:25 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id h15sm7636317ejg.144.2022.01.26.07.17.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 07:17:25 -0800 (PST)
Date: Wed, 26 Jan 2022 16:17:23 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 1/2] kvm: selftests: aarch64: fix assert in
 gicv3_access_reg
Message-ID: <20220126151723.xcpa5rdgxmcdv22c@gator>
References: <20220120173905.1047015-1-ricarkol@google.com>
 <20220120173905.1047015-2-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20220120173905.1047015-2-ricarkol@google.com>
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

On Thu, Jan 20, 2022 at 09:39:04AM -0800, Ricardo Koller wrote:
> The val argument in gicv3_access_reg can have any value when used for a
> read, not necessarily 0.  Fix the assert by checking val only for
> writes.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
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

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
