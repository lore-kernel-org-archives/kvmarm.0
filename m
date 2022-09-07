Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F59ECAAD5
	for <kvmarm@archiver.kernel.org>; Thu,  8 Sep 2022 08:34:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A09C54CD05;
	Thu,  8 Sep 2022 04:34:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id faoe6kgWHtMG; Thu,  8 Sep 2022 04:34:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BF9C4CCFA;
	Thu,  8 Sep 2022 04:34:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F15F4CB21
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 16:57:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfpMFEajl48X for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2022 16:57:25 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A37984CB1E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 16:57:25 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id fv3so9609617pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Sep 2022 13:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=D3RjQ0ycHa7B/7TKXUqNYyCf5lxoaaHEC6kuhsk3puQ=;
 b=idXPP15TJ7IS7iOdTlcgO/fcRqVHkI5cBChgxzLuZESpPUM6XsRZaDDRlyZt5BL5jA
 NnDWTztN/R3V3J5Z1YZuFWvgmRdivTwGx7C0YTX8U3GFYFDSyYNpSXVfEvPcf6DA88z9
 8kLgdpa7Q4m7CU2vRCW6SLTrKfYckFsVNWOY2H42ZOxS7KeLUcJ7gnpWeG5GGIX+7+U1
 TFWxa2aATU45JtkYWSOrYquLa9hMQdzhjn7oTetBNz+hF31OaKxN3BgxaWlaxzW2WqmT
 wPPWvIoyABeiowfiSdUX1HROmgtTeBq4Kjy6fIipWcmDCYtgsG9s9yt5yytaexuEMaX1
 PSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=D3RjQ0ycHa7B/7TKXUqNYyCf5lxoaaHEC6kuhsk3puQ=;
 b=mZI7lGWOHsU8eKdgUjIv4MAM0hqch5AV0UMNW1LnbkuBui9cDTsmOi3eNCRO8Vdo2m
 B6+oUu8xtj/xFppnkWEYR8hDNg81GvnxCbjphAo7nGHY41D8F7pD5NptfQB/RtCh6kzl
 jjijubkIWmY95yWv9VVoFm5Cwr6donfEoNDvRBTbi2AI6oPGvwPQI/wChNTwJJ4RlfTw
 5Tbg5Q7qXwuRHkIEfeHWrMlSAGSY1ioTYGupf0nGxD7xC4BGOLlmqiCnFv2WAbnk/KyP
 7RwdRHflWe+ndgkECm4TRI4QBWP+rzy+n9lj4EIxDInDE4a58p+3ONyKJ+kp3KH/nriY
 8smw==
X-Gm-Message-State: ACgBeo1CeBX/BE5Qui4yen8Be/BNh5VwGJrVCHZtB1k6kGu+vR0Km1zM
 2+UML9damJbcB397Obd1bNCZFg==
X-Google-Smtp-Source: AA6agR4y0YI6Do787IPnCmL86e80gRfI6CK4dTypbO17kG+PMFuHSAWq0jEGksDH17TMqhJ3tnUYKg==
X-Received: by 2002:a17:90b:33c9:b0:200:a0ca:e6c8 with SMTP id
 lk9-20020a17090b33c900b00200a0cae6c8mr357636pjb.147.1662584244248; 
 Wed, 07 Sep 2022 13:57:24 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 v6-20020a1709029a0600b00176a47e5840sm8258330plp.298.2022.09.07.13.57.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Sep 2022 13:57:22 -0700 (PDT)
Date: Wed, 7 Sep 2022 13:57:17 -0700
From: David Matlack <dmatlack@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 02/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <YxkFrSmSKdBFEoZp@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-3-oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 08 Sep 2022 04:34:28 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Aug 30, 2022 at 07:41:20PM +0000, Oliver Upton wrote:
[...]
>  
> +static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +				struct stage2_map_data *data);
> +
>  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  				     kvm_pte_t *ptep,
>  				     struct stage2_map_data *data)
>  {
> -	if (data->anchor)

Should @anchor and @childp be removed from struct stage2_map_data? This
commit removes the only remaining references to them.

> -		return 0;
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	kvm_pte_t *childp = kvm_pte_follow(*ptep, mm_ops);
> +	struct kvm_pgtable *pgt = data->mmu->pgt;
> +	int ret;
>  
>  	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
>  		return 0;
>  
> -	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
>  	kvm_clear_pte(ptep);
>  
>  	/*
[...]
>  static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  			     enum kvm_pgtable_walk_flags flag, void * const arg)
> @@ -883,11 +849,9 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
>  	case KVM_PGTABLE_WALK_LEAF:
>  		return stage2_map_walk_leaf(addr, end, level, ptep, data);
> -	case KVM_PGTABLE_WALK_TABLE_POST:
> -		return stage2_map_walk_table_post(addr, end, level, ptep, data);

kvm_pgtable_stage2_set_owner() still uses stage2_map_walker() with
KVM_PGTABLE_WALK_TABLE_POST.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
