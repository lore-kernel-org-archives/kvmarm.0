Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2BCC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:47:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D84956115B
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D84956115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 521D44B173;
	Thu,  9 Sep 2021 12:47:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZEWbfkpGxd30; Thu,  9 Sep 2021 12:47:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B814B160;
	Thu,  9 Sep 2021 12:47:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7C834B15E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:47:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EyzIEdT1z6YH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 12:47:18 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2C4549E93
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:47:18 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id j1so1790875pjv.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 09:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=aqDJdy/bngbKNH/GkT/KKhZxJC8IlkHUa3ohSA9/WQU=;
 b=ONNwLK04smMPzA1dePLbmmudjm0amUNmRtiYHvgryjFJBCMqEiKgQrX5RF1aC1XJJ0
 hWGXF3y+GFritFMHREj/UVar2x+rdaZm0irWxNMv+LtAXnbin8UzvYLQtWYlJG4F3H6G
 w4q9CvLy8UuQA9ibUg+Pkv3NyXGvwD3mDu/SSzCtu6vrwXboszDnNf6rjxv2eQomVE6U
 t2ouvCIt+0W6zIj5Xr5K8DrtFc82Oeihv6JsJwCJ/bb42U3enEoCHMyXy6qgXkAtUxP6
 p3suq2NUa6JIXQWTT0wXjsyD6l0MDq0FsI9i121Xi63gKbdiTks1E+Jh+xMeDaWxf5zP
 1Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=aqDJdy/bngbKNH/GkT/KKhZxJC8IlkHUa3ohSA9/WQU=;
 b=3VpKdg0L4QtTEDhwseubkStM6tUmye89qbi2VRui7SJn3RguqTpNZZeUKptT7ymnl6
 ctU8VZdA8EKjiXGZrIQakaV7MilcEMu25vpQvoQHJJF6ujVLAO6cbASkgHsKn8sqX0Kj
 vkPS5D/dXlvtw4oimYKACW+8lHURMlW5C0cUvXH+UWj3CF6nvSbEak61ioeY+jdJD5r5
 NN3qxl6iorvTr70Re8weUu6A5E2H08bkrqtBe7OtkMz8tmcitSVS9kmvYbEOi5AJeA/d
 hWQ8NbS0qIU+YJmX8EA+1J0mH36t5K8LGsncbeIMuvDmX/8ZoSMlaXGfcA2Hh+XdPXI6
 0vgw==
X-Gm-Message-State: AOAM531P9W8VGyjb7u78cQOv9RHGG0vPqH8btBFoig0E+LqJang6dds5
 I4VEspQ1xmk5tcqoJIk3suwDlA==
X-Google-Smtp-Source: ABdhPJyoRFIZmAkN7ZrnaHVghWbLzbIeUZ5Eg97bAH4sMRYbkFXJcKwlS1ZMLW/kE1H7gibUsCPBMg==
X-Received: by 2002:a17:902:c401:b0:138:e450:1ec4 with SMTP id
 k1-20020a170902c40100b00138e4501ec4mr3508456plk.56.1631206037420; 
 Thu, 09 Sep 2021 09:47:17 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id s9sm2622619pfu.129.2021.09.09.09.47.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 09:47:16 -0700 (PDT)
Date: Thu, 9 Sep 2021 09:47:13 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTo6kX7jGeR3XvPg@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org,
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

On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
> Hi Ricardo,
> 
> On 9/8/21 10:03 PM, Ricardo Koller wrote:
> > Extend vgic_v3_check_base() to verify that the redistributor regions
> > don't go above the VM-specified IPA size (phys_size). This can happen
> > when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> >
> >   base + size > phys_size AND base < phys_size
> >
> > vgic_v3_check_base() is used to check the redist regions bases when
> > setting them (with the vcpus added so far) and when attempting the first
> > vcpu-run.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..5afd9f6f68f6 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> 
> Looks to me like this same check (and the overflow one before it) is done when
> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
> kvm_vgic_addr() handles both ways of setting the Redistributor address.
> 
> Without this patch, did you manage to set a base address such that base + size >
> kvm_phys_size()?
> 

Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest way
to get to this situation is with the selftest in patch 2.  I then tried
an extra experiment: map the first redistributor, run the first vcpu,
and access the redist from inside the guest. KVM didn't complain in any
of these steps.

Thanks,
Ricardo

> Thanks,
> 
> Alex
> 
> >  	}
> >  
> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
