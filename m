Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F960C432BE
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:13:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8215560F70
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8215560F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE4E140874;
	Mon, 26 Jul 2021 09:13:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NeZlAasnM9Eb; Mon, 26 Jul 2021 09:13:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF4A549FA6;
	Mon, 26 Jul 2021 09:13:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB36340874
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:13:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cr6nJsHW1ZdG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 09:13:10 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89D4A40808
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:13:10 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id
 l11-20020a7bcf0b0000b0290253545c2997so3258wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 06:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZtU7fvZEyyOLQgnySOlDvGY7f3ikYJEH6+mfO2JIeiw=;
 b=YFyKwtLN1bSSFHloIhy0fW6Dhxolu5g2e/6SEkdyGH1aiDKhpgyhOGUJHd1xSooBXA
 UpvvIqh+avoVzy3OYPWTNNy5ahUcREJDczLQ01VVwk3UKTyvHawERdAeLrXAEa0Jj+k+
 adbZCEMgpl2zRM89TwupWHr68qDbMaFItJ+MTlezkUjQSwzdN1HIBhE2/bqOxmbv3wz7
 Wi/T620Hs0l757Y8lVpPETU0D1YKKVdWNKKRcEeBGAUCnENLQ5LFdNONRT2I1Re/VAdB
 xXsmlyhQtfVry/uGikW3+jSh0sfhWnOqAu/I7Wclztk+OLiUdmTEBfWCQXpB2xvd3ju9
 GyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZtU7fvZEyyOLQgnySOlDvGY7f3ikYJEH6+mfO2JIeiw=;
 b=Ky6TV72RT1S+LHrFAwsdkV0KwBbN4Q0W38MQ1bh5JAEsl+fzNhfJQASPSku/IB7SGj
 yyWyuCccllC5gzsnlZ4x0Aw3RlwPprYuF9dMIRIv2gOCt2aRlRdxOj5e72nyWc1V+mo3
 QeRi3nGoarNRmigZnhq8I9rltwPTJgJSXnunjmPx+BnqdY/P4bVtRtMsJQKefwzBj3ve
 TZ39VUA4TEK0iDc7VHtXx4vpLjFcUYjbm+5ur6p2FvqkL8yTGjFrx36aU3yVqCmnpMtQ
 LjHafk93AXRwgicN0oOZNT9spZZg62LkdnlohyDSIznOjHQXwewOv4rFLHJZYG5+wAMs
 CZYw==
X-Gm-Message-State: AOAM531xUf2MgoKN2JQjX7j2QpqAsAv1omQLF4GcvVlngXqVU+iO4Jk+
 vp7EJrXthwRC2g5qt6A1g4m5pQ==
X-Google-Smtp-Source: ABdhPJw3iV0iD0VNKcKvIFGEO/4SIbrCzeF0z8XajY3jrjx5HJnK1HWQwzfNfl/GjgZNs2EuDMsB/A==
X-Received: by 2002:a1c:3886:: with SMTP id f128mr1889070wma.85.1627305189353; 
 Mon, 26 Jul 2021 06:13:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:c468:e033:fa2b:3a6])
 by smtp.gmail.com with ESMTPSA id x8sm42479052wrt.93.2021.07.26.06.13.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Jul 2021 06:13:09 -0700 (PDT)
Date: Mon, 26 Jul 2021 14:13:06 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 04/16] KVM: arm64: Optimize host memory aborts
Message-ID: <YP604j6B1pkhAnT1@google.com>
References: <20210726092905.2198501-1-qperret@google.com>
 <20210726092905.2198501-5-qperret@google.com>
 <87pmv5e529.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87pmv5e529.wl-maz@kernel.org>
Cc: kernel-team@android.com, qwandor@google.com, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
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

On Monday 26 Jul 2021 at 11:35:10 (+0100), Marc Zyngier wrote:
> On Mon, 26 Jul 2021 10:28:53 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > +static int host_stage2_find_range(u64 addr, struct kvm_mem_range *range)
> 
> nit: I find 'find_range' a bit odd. We already have found a
> range. We're just trying to narrow it down to something that fits in a
> single block mapping. How about 'host_stage2_adjust_range'?

Ack.

> > +{
> > +	u64 granule, start, end;
> > +	kvm_pte_t pte;
> > +	u32 level;
> > +	int ret;
> > +
> > +	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, &level);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (kvm_pte_valid(pte))
> > +		return -EAGAIN;
> > +
> > +	if (pte)
> > +		return -EPERM;
> > +
> > +	do {
> > +		granule = kvm_granule_size(level);
> > +		start = ALIGN_DOWN(addr, granule);
> > +		end = start + granule;
> > +		level++;
> > +	} while ((level < KVM_PGTABLE_MAX_LEVELS) &&
> > +			(!kvm_level_supports_block_mapping(level) ||
> > +			 start < range->start || range->end < end));
> > +
> 
> This expression does my head in. You are trying to find the largest
> block mapping that entirely fits in range, right? Can we just express
> that directly (with a global negation for the purpose of the loop)?
> 
> 	do {
> 		[...]
> 	} while (level < KVM_PGTABLE_MAX_LEVELS &&
> 		 !(kvm_level_supports_block_mapping(level) &&
> 		   start >= range->start &&
> 		   end <= range->end));
> 
> I personally find this much more readable, because it expresses the
> condition we are looking for rather than a lot of conditions forcing
> us to continue.
> 
> You could also use a kvm_mem_range for the iteration, and add a helper
> that checks for the inclusion.

Something like this (untested)?

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 75273166d2c5..07d228163090 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -234,9 +234,15 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
                __ret;                                                  \
         })

+static inline bool range_included(struct kvm_mem_range *child,
+                                 struct kvm_mem_range *parent)
+{
+       return parent->start <= child->start && child->end <= parent->end;
+}
+
 static int host_stage2_find_range(u64 addr, struct kvm_mem_range *range)
 {
-       u64 granule, start, end;
+       struct kvm_mem_range cur;
        kvm_pte_t pte;
        u32 level;
        int ret;
@@ -252,16 +258,15 @@ static int host_stage2_find_range(u64 addr, struct kvm_mem_range *range)
                return -EPERM;

        do {
-               granule = kvm_granule_size(level);
-               start = ALIGN_DOWN(addr, granule);
-               end = start + granule;
+               u64 granule = kvm_granule_size(level);
+               cur.start = ALIGN_DOWN(addr, granule);
+               cur.end = cur.start + granule;
                level++;
        } while ((level < KVM_PGTABLE_MAX_LEVELS) &&
-                       (!kvm_level_supports_block_mapping(level) ||
-                        start < range->start || range->end < end));
+                       !(kvm_level_supports_block_mapping(level) &&
+                         range_included(&cur, parent)));

-       range->start = start;
-       range->end = end;
+       *range = cur;

        return 0;
 }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
