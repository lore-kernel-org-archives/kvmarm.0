Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D791C49EA6
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82E56613FB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 14:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82E56613FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 059994B12E;
	Thu, 24 Jun 2021 10:03:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ne4MMrwJ2GEu; Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F1C24B18A;
	Thu, 24 Jun 2021 10:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F064B183
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 04:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id COd1QEta6U8q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 04:58:07 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FCC44B176
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 04:58:07 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id q192so4592606pfc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 01:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=tKGKGI76BKfQVO8CY1clLxpyySv3vaB3aNh7NWcPhFU=;
 b=hr3gPiWSs1kzsoT0RN4D0/9u1oAQb1rzWVWLp59xVCkmpZThGbP8ZZHdbz3ZoRByYE
 Q+bBx6g9vlzubm3xmDqrFRZB2+oF9y38fRVeD/lgeXJbzeuitriXAAYQ0N8Gc/HydmS9
 h/5/U9gCncS2FPi6hlzNOXRrtw9yomYF3Wegfa7y5BMTxxqMjVRS/4Rtc+vsfYrwyiXs
 LyEAUsbj+aFGjgwEVS9b0hjW6sOv/s+/X+xMkec2Brf1nwlIC4mUivbzM9KBmc/1CmOo
 TCEnNnCh1Rmp7Wm6gBzXbz6S+8yTRr+T+rSaRDpuwEYfFxSOn4uIuwntNiH62vmZwJdo
 +iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=tKGKGI76BKfQVO8CY1clLxpyySv3vaB3aNh7NWcPhFU=;
 b=W9AoFW07jQo5iUdluN3rfoJgNjQmEXw13IS0M+EvNnls9CEz8j8vOpOPjSfo8Ji4ZI
 +QLZDDl7VWbLWAjR5s2IHE1BjUOx6+UZwt5rE/Pq+mnPreQ3pviJh4Ihx4PdXwWlhJHz
 LArbt49t4wBQ825yL9cElDjTyGChCFsMToscKgKG9EGCbLmvlwsE9IJ13al8mN9kfqow
 6NKCqQK5TRgwA6a3fu7+5Ni4khaP6r4WttUhAlNgjIsnu/mQRbxOcLnAGwdfgYo2Fqzq
 e+czmfJzvAXUQJcgVujp2cI+HBv2HJdWPLO/ibmmjoWYfoX92mwtBE6Qp23bhJgreEzj
 Xwyw==
X-Gm-Message-State: AOAM533Qkto/OwnC4p5pze6ylSixJ4KKRGs7Gvc1NsXPdvxTcWhiN4ad
 6ao7afTl/rHnA+RBbFLWL6Y=
X-Google-Smtp-Source: ABdhPJw6tjizzTpMBwm3ffTzeTydtLNTRDVWzEX8o5A/u6n7JmgIJ0z9ctLYNOtrV24IDSrsfT+37Q==
X-Received: by 2002:a63:4e4c:: with SMTP id o12mr3895360pgl.95.1624525086186; 
 Thu, 24 Jun 2021 01:58:06 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id u12sm2003479pjc.0.2021.06.24.01.58.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 01:58:05 -0700 (PDT)
Date: Thu, 24 Jun 2021 18:58:00 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: avoid struct page in MMU
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Huacai Chen
 <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>, Paul Mackerras
 <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>, David Stevens
 <stevensd@chromium.org>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-4-stevensd@google.com>
In-Reply-To: <20210624035749.4054934-4-stevensd@google.com>
MIME-Version: 1.0
Message-Id: <1624524744.2sr7o7ix86.astroid@bobo.none>
X-Mailman-Approved-At: Thu, 24 Jun 2021 10:03:53 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 kvm-ppc@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> From: David Stevens <stevensd@chromium.org>
>  out_unlock:
>  	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
>  		read_unlock(&vcpu->kvm->mmu_lock);
>  	else
>  		write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(pfn);
> +	if (pfnpg.page)
> +		put_page(pfnpg.page);
>  	return r;
>  }

How about

  kvm_release_pfn_page_clean(pfnpg);

Thanks,
Nick
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
