Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294FFC433B4
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:37:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC25B6113E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:37:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC25B6113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 537BA4B30B;
	Fri,  2 Apr 2021 13:37:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DsMNwuveCNAT; Fri,  2 Apr 2021 13:37:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8E44B376;
	Fri,  2 Apr 2021 13:37:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCEF84B297
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 10:59:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DZG1F1BIDYrm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 10:59:48 -0400 (EDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E90974B28D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 10:59:47 -0400 (EDT)
Received: by mail-pj1-f46.google.com with SMTP id
 f2-20020a17090a4a82b02900c67bf8dc69so4724032pjh.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 07:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XauO+Tpx/QqvLfsNf0EieVcjgezYHlrLlZApCjoCcwc=;
 b=Tzgme0UQBGKuB+zSlD0xeHc77Hy6oWyrRyYiRZQFSKSope2ZlQuprlNPAFIGno9HCF
 19mRDkj5ZlfoNjs328k6GhD8eNbfCsQBcei3BTgXY+lndiulxllK9urmRZpNbnawPSHF
 1VntLWcNLRE/v2TUKfmWJP3RUU9JLl2aM0LmT3koOB9K6//ZWjl40DmwLdcbMuXOftRy
 vY7bpTZFLIxlRDiIvxlrah94VXX6FYPLZOMp+MPalyOIzbjG3+pDcx1vJhHFGSEmzlRs
 VifckWbHZsxI2muXBZVeIADxXGgNHUOjgsjNw0sHYg1S4nsynZoWCREOXUk86kfL7DYo
 Pc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XauO+Tpx/QqvLfsNf0EieVcjgezYHlrLlZApCjoCcwc=;
 b=c5EhAxZ+ObjediPdrMTdnX6Dy+b9rmKx7lMruNKmkwlFVEkTNMawLe30kUzs3BDZs6
 HrB2RKXL1uGzV61lfwoyYrVbeHiS9hL/MUpeNNkZFIE8Y1aGIoBSqzJqiabCY/IHCCdo
 3ZzGh764VSdw6q5PjcMWNOtMpc8YljTk85LL+948tmVDsh0338BmRR3c1lPs7PfNVm5h
 EnbSH3MKqCYO4eSvenhx5YGwTmGRAdYAEllA5cmUejq4izrz+SkxXsvatu0lO5U1FuD7
 XWMfdsDfghfVgF6pCQZNy/qvQi4jfQIoyXC41j8GLa2fzCQCAFzDlc7olJxGbBKbM9yD
 QI6w==
X-Gm-Message-State: AOAM533MnqEIoCCXS0HCKb+wk5IML5jUA6LfpN5AtM0wuWHxF2++yc72
 vQwzmOs20lsPCK3MAZ3WEH7I0A==
X-Google-Smtp-Source: ABdhPJxioQlQNRTARxdEppiGDcKbsI4noyv87TJnoDznkG+oVESSh/n5TV8EGFMcsMJo2RSOZZ0Vdg==
X-Received: by 2002:a17:90a:b889:: with SMTP id
 o9mr14181347pjr.97.1617375586898; 
 Fri, 02 Apr 2021 07:59:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id n24sm8673883pgl.27.2021.04.02.07.59.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Apr 2021 07:59:46 -0700 (PDT)
Date: Fri, 2 Apr 2021 14:59:42 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 07/10] KVM: Move MMU notifier's mmu_lock acquisition
 into common helper
Message-ID: <YGcxXvrluFJ+7o9X@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-8-seanjc@google.com>
 <a30f556a-40b2-f703-f0ee-b985989ee4b7@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a30f556a-40b2-f703-f0ee-b985989ee4b7@redhat.com>
X-Mailman-Approved-At: Fri, 02 Apr 2021 13:37:03 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Fri, Apr 02, 2021, Paolo Bonzini wrote:
> On 02/04/21 02:56, Sean Christopherson wrote:
> > +		.handler	= (void *)kvm_null_fn,
> > +		.on_lock	= kvm_dec_notifier_count,
> > +		.flush_on_ret	= true,
> 
> Doesn't really matter since the handler is null, but I think it's cleaner to
> have false here.

Agreed.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
