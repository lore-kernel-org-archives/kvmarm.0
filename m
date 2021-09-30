Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F81C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:19:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6807E61A0B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:19:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6807E61A0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BA44B0D0;
	Thu, 30 Sep 2021 17:19:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0F4K3S83vqKA; Thu, 30 Sep 2021 17:19:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C78B4B08A;
	Thu, 30 Sep 2021 17:19:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6CB74A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:19:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZNjr8HvCIahm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 17:19:21 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABFC54A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:19:21 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id n2so4912926plk.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gsPJp6nywuIUGRL9wTTnUa2vydmRNYrvFxZGIzkhV+A=;
 b=J9xCjEqIH6BGsP72TtweSlq+uJYAp9hG5KQCUPFPbspycFHSs4Lsc6oYt//4e6lDBS
 ayT1JY+20Y9MYOCVyAtzlgHTpf6OJOIXieKjZteN40pzNcXrVdXMagupLd1Yn6dEL/N3
 ha81XbJFBVhrQ9B4tZmvTAM0XXNEqGrVMdoTZWD/++V5FK6SWw7z+Xf8sYZFHWE4Iub/
 S3ADOafRDiDYqSYll37tqVRpnWVln4cahERMNS8SzmNupRDOLbjm+0PIRtIzJsGOEOdV
 NPcSc5W9N+O19ZhttqKU+d0cTIjpEc+LVMQNb5elZmgWp6QLANC6o4cjQRJg1Kx2Ymh/
 i/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gsPJp6nywuIUGRL9wTTnUa2vydmRNYrvFxZGIzkhV+A=;
 b=jHtw/UbuRRljSnqtMWiYCetgNmtv91Aj17JTqeUL/Yh3MSYr/dfzzwACV8TZPZtrwV
 rLK0o5QaTEc28jBkM5lG0ZsWmdij4U5cz7CUSvVm9haJFmTUkAIE9RFU/uGciiru8gwo
 V8t7mUecjrIvAC6wLdy+qAatRpAf7YVEBAAYUUY+ZFXpPZKzAUEmhp5taoIVvb1AOH4a
 TGdGsqyI9HZdK6CRQoy7p8WFJiteQ/+ffQ6Z0qK6CqGbTLWp/6rYuKXGS2h2fyZrBQr8
 NMaFDqtqPedKm/91W3FvaaxdKTwvHPR+kwLP0BKkkjwUhEJxihUdo3PPqnw5CNOuviaQ
 uajg==
X-Gm-Message-State: AOAM533K5NQcvQtaLD8J4i4tcJ/39GXUT0VrJiby1P7KvGe1pQ/gVwZZ
 d1JzQKPNrP2epnaF0pq65Ct7rw==
X-Google-Smtp-Source: ABdhPJzk8BjwQeVCWpAv95Os14ZqKXwc6O/38qXjPwSrMgWbFGfkCrIkEUnvcxCi7OrzgfN9aTUPog==
X-Received: by 2002:a17:90b:1e4d:: with SMTP id
 pi13mr15532660pjb.96.1633036760458; 
 Thu, 30 Sep 2021 14:19:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id k12sm4006534pfp.25.2021.09.30.14.19.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 14:19:19 -0700 (PDT)
Date: Thu, 30 Sep 2021 14:19:16 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
Message-ID: <YVYp1E7bqIFttXF+@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
 <YVTX1L8u8NMxHAyE@google.com>
 <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 30, 2021 at 09:02:12AM +0200, Eric Auger wrote:
> Hi,
> 
> On 9/29/21 11:17 PM, Ricardo Koller wrote:
> > On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
> >> Hi Ricardo,
> >>
> >> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> >>> Add the new vgic_check_iorange helper that checks that an iorange is
> >>> sane: the start address and size have valid alignments, the range is
> >>> within the addressable PA range, start+size doesn't overflow, and the
> >>> start wasn't already defined.
> >>>
> >>> No functional change.
> >>>
> >>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >>> ---
> >>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
> >>>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
> >>>  2 files changed, 26 insertions(+)
> >>>
> >>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> >>> index 7740995de982..f714aded67b2 100644
> >>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> >>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> >>> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >>>  	return 0;
> >>>  }
> >>>  
> >>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> >>> +		       phys_addr_t addr, phys_addr_t alignment,
> >>> +		       phys_addr_t size)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
> >> nit: not related to this patch but I am just wondering why we are
> >> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
> >>
> >> vgic_check_iorange()? This must be a leftover of some old code?
> >>
> > It's used to check that the base of a region is not already set.
> > kvm_vgic_addr() uses it to make that check;
> > vgic_v3_alloc_redist_region() does not:
> >
> >   rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
> >   ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> Yes but I meant why a pointer?

I can't think of any good reason. It must be some leftover as you said.

> 
> Eric
> >
> > Thanks,
> > Ricardo
> >
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	if (!IS_ALIGNED(size, alignment))
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (addr + size < addr)
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (addr + size > kvm_phys_size(kvm))
> >>> +		return -E2BIG;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>>  static int vgic_check_type(struct kvm *kvm, int type_needed)
> >>>  {
> >>>  	if (kvm->arch.vgic.vgic_model != type_needed)
> >>> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> >>> index 14a9218641f5..c4df4dcef31f 100644
> >>> --- a/arch/arm64/kvm/vgic/vgic.h
> >>> +++ b/arch/arm64/kvm/vgic/vgic.h
> >>> @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
> >>>  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >>>  		      phys_addr_t addr, phys_addr_t alignment);
> >>>  
> >>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> >>> +		       phys_addr_t addr, phys_addr_t alignment,
> >>> +		       phys_addr_t size);
> >>> +
> >>>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
> >>>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
> >>>  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
> >> Besides
> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >> Eric
> >>
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
