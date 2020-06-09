Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEB6C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10ABD204EA
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="rwanDsZd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10ABD204EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 820664B2DE;
	Wed, 10 Jun 2020 07:20:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XDM46TWlQkdc; Wed, 10 Jun 2020 07:20:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0702D4B2D6;
	Wed, 10 Jun 2020 07:20:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 466714B1BA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 19:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S6hNNd69rMp7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 19:03:52 -0400 (EDT)
Received: from mail-vk1-f194.google.com (mail-vk1-f194.google.com
 [209.85.221.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57D864B142
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 19:03:52 -0400 (EDT)
Received: by mail-vk1-f194.google.com with SMTP id u15so113283vkk.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Jun 2020 16:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QPEA53MpdF9ON3exFjCberFh9r4WY/+iX04WGFZFtXU=;
 b=rwanDsZdo86Rv+vzZDRG+0C9QrHIbGQgfj2nwO+GiGBNVyLSExN93DGrkptklgs9I1
 AC0cy3+rivR0wtaNSSV9u8U2CqWzAr9cwayr0OtE6O+jC2+BtUr9VjUb8UFNbXJkVAi1
 WfJhopss4dvT37wHibefpDeELAXyANGodPwrJTtsn9yIlJTNlMVMXjXyhR/cP5akWDCP
 mjbboyehlJjrEud3b556BAnXu9H3ea7lZqMAdBWMg65r0d3SNuuwYPZvv8rUlGOJMmVx
 1rAQzDRF0wybOVz5i+mnG2dV7tbBHX6NxTZfN6sP+E0p5F7rIRZGBiMOtY3RefHOaxGa
 MGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QPEA53MpdF9ON3exFjCberFh9r4WY/+iX04WGFZFtXU=;
 b=qzRmKXCIhRCZwIgkHWX5y+rStGX64rojC3mxBZ1K8P+/litrWllsq2L0a/otPPy2J4
 xgcM5N/3SLp9hL8QelIguIq9/iitZBcdiJeROBTHFO0gGxG77FTVIvQNdRYLB0AYHzjZ
 umIRSSnPGDLPdup2QpRhQf6qGNm+En7WZrQGtXSdtpXhtn4MwDgywbhV937mkBDfIW5X
 hL0SxR8ZOec1JxybY1fhWTbEXhU2TKBGqbDtLBECcqvL5WVBfTEDyQTgyciUhihVuc7n
 m00AMKzQ+e/PQ8EDtxpPGlbZnC7Vsc0Rx5yDZ5xQ3nkEFRNycnLkUSWPC1G6O6G/v1l6
 rVeg==
X-Gm-Message-State: AOAM531UrfNUMamkfnC6FUlfH8OwAYtTnLMJRLvWqiLdpR8QxDuQT86G
 ntSNzXPO7AKm4yT+CtTGJkzlhVIAVILwm5GYLVuEnA==
X-Google-Smtp-Source: ABdhPJwvz0K9ugkUS0zUu2sV6SC9xdH2ngcwyFlRhaY+EjhyMbUztSqGBkZnAcJGtcUe/roomwm1IuKpnHfl3gWMyfI=
X-Received: by 2002:a1f:974d:: with SMTP id z74mr401275vkd.40.1591743831579;
 Tue, 09 Jun 2020 16:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-7-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-7-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Tue, 9 Jun 2020 16:03:40 -0700
Message-ID: <CANgfPd9Y9P+-got9HmtrvChmwZBe-XOA0zSSLMsPCUKcuBv4aQ@mail.gmail.com>
Subject: Re: [PATCH 06/21] KVM: x86/mmu: Move fast_page_fault() call above
 mmu_topup_memory_caches()
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 10 Jun 2020 07:20:46 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Avoid refilling the memory caches and potentially slow reclaim/swap when
> handling a fast page fault, which does not need to allocate any new
> objects.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5e773564ab20..4b4c3234d623 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4095,6 +4095,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (page_fault_handle_page_track(vcpu, error_code, gfn))
>                 return RET_PF_EMULATE;
>
> +       if (fast_page_fault(vcpu, gpa, error_code))
> +               return RET_PF_RETRY;
> +
>         r = mmu_topup_memory_caches(vcpu);
>         if (r)
>                 return r;
> @@ -4102,9 +4105,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (lpage_disallowed)
>                 max_level = PG_LEVEL_4K;
>
> -       if (fast_page_fault(vcpu, gpa, error_code))
> -               return RET_PF_RETRY;
> -
>         mmu_seq = vcpu->kvm->mmu_notifier_seq;
>         smp_rmb();
>
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
