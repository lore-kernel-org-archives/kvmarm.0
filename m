Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33785C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 16:55:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F66049EEE;
	Wed, 20 Apr 2022 12:55:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SiImbzMHTp0T; Wed, 20 Apr 2022 12:55:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6286049E3F;
	Wed, 20 Apr 2022 12:55:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5D2449E16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 12:55:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M2FmG7GS-xh1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 12:55:47 -0400 (EDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96E5E49B07
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 12:55:47 -0400 (EDT)
Received: by mail-ed1-f41.google.com with SMTP id c6so3098071edn.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 09:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vUTv+50MNanSPxQdcGK+5r6sVmuK08fgNGG0Mf/jqBI=;
 b=iaqM1FoiEMcdthoIscB4EGxWnfhv/7xjyGKn4gIYpZHRrZPFYv2bhDYEqwxTUUPq3f
 MBxFAQIxeQGYEDY3oK29YT38KSDuW3cHq8JkOpdd4sAuedKILI1Ug1iJ1a1kl9I8P6mD
 Y5dRhiHuMdLNpXQOZFC1pxLJVGLOjllNv/t/zpRTHgqsu+YKyZnrtZesTx4Lnhup2nbU
 5VNDjtGqnI7R/JkhaEOkFnXoIkSP9OXMsnNzUJQ3KKLbePthP8+NBRw3HM3upPsJn1aI
 Fc7SnEGGItiNTvVn+7JEsg1baMxX5uzfKSee2UM61YtwsD/ll2+J5Jk1RFF1JsnIsliO
 ruYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vUTv+50MNanSPxQdcGK+5r6sVmuK08fgNGG0Mf/jqBI=;
 b=uthdXX0l070Lc22Raabg/qwUTRBlYflBat9eyoSffhqq6wOOYLHdGuY8lm0ElFL1rA
 02jMowxarOvXSVq+iqKE1+4al6QylplUXmmfvzOvGOz6Kkx6+/b83vuy4bCeKmt9iUc0
 7oBmVqsNc7Lh7r5BChklNOwXpbs0W7Tf1dFLPJvC5KREG30anDEKcCpy2dYj2ZW7YxJ+
 pkwbL0PvONH0Ecme8Aa8snWj+s6pmWLtu07uV0HCdoHIN4cA77dgJNmv0wWN/uheLoBR
 8eW3OOJtI/eovNMkLgAUhkKPj2VmSnAfySts0bFJgE68tAIE4AQXnEv0m32x1Rqj/m9h
 0oxA==
X-Gm-Message-State: AOAM531Hg80ygrqW0RQEn1iyfIhg1TpGKH0C0YKirMPGVxtAATRApMhW
 FvmzNzYcoSY//yfCJLXJBs9oRA==
X-Google-Smtp-Source: ABdhPJwZN16RiJ3cGzzLbJpClyclGhaHPFmT1JB/AMEONy3NRQjyx8rtnJoF85sLehdmloUKBwbWAw==
X-Received: by 2002:a05:6402:2711:b0:423:ef0d:aa86 with SMTP id
 y17-20020a056402271100b00423ef0daa86mr15314652edd.262.1650473746365; 
 Wed, 20 Apr 2022 09:55:46 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com.
 [34.91.171.30]) by smtp.gmail.com with ESMTPSA id
 s20-20020a056402015400b00418f9574a36sm10182331edu.73.2022.04.20.09.55.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Apr 2022 09:55:46 -0700 (PDT)
Date: Wed, 20 Apr 2022 16:55:43 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
Message-ID: <YmA7D7DyY7MDfli4@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-7-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Friday 15 Apr 2022 at 21:58:50 (+0000), Oliver Upton wrote:
> +/*
> + * Used to indicate a pte for which a 'make-before-break' sequence is in

'break-before-make' presumably :-) ?

<snip>
> +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_mm_ops *mm_ops)
> +{
> +	/* Yikes! We really shouldn't install to an entry we don't own. */
> +	WARN_ON(!stage2_pte_is_locked(*ptep));
> +
> +	if (stage2_pte_is_counted(new))
> +		mm_ops->get_page(ptep);
> +
> +	if (kvm_pte_valid(new)) {
> +		WRITE_ONCE(*ptep, new);
> +		dsb(ishst);
> +	} else {
> +		smp_store_release(ptep, new);
> +	}
> +}

I'm struggling a bit to understand this pattern. We currently use
smp_store_release() to install valid mappings, which this patch seems
to change. Is the behaviour change intentional? If so, could you please
share some details about the reasoning that applies here?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
