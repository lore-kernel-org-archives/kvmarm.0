Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59051C43466
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 13:44:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C69CD20C09
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 13:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PBzsm4Ck"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C69CD20C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A634B58D;
	Mon, 21 Sep 2020 09:44:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MP9LRyxDP4iI; Mon, 21 Sep 2020 09:44:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEAE74B514;
	Mon, 21 Sep 2020 09:44:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 122844B500
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 09:44:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GUsL26mmysBb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 09:43:59 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1C5E4B38B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 09:43:58 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id e16so12847875wrm.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 06:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PKSAlhSQ9Eh6fSSb1EiKiqDta1PeLzDdGDQlo2aRDw4=;
 b=PBzsm4CksVIWOwAwH9jC9VQ6MVHjGCDUXFV+y2ttxej8Xuexc6+aKCDyieHrP+XQ6r
 YXLZHVgtFM8leGT+Gsel61/uWf0Zz/wLwz3EmVcnWB/uk9xw8cvoNZaosyrBcTp6czSn
 /b4Kqxzo8vqQjA0Gd0WuUt4yNtDcFnoQJXKIHUnGTRPNaWBYlmiRZZkRM40+F6e2Kd1O
 Oxp/yRU5neltD3kropbYH+zuooXNi8ijWFjVPt38BkmsMGO6oVGBF6Y9lsgGrSZvGwyz
 8KC52eHwemtmteuByjnIXT6hLwiRh0KKiS6+e8vHDDy7qRkjVf0IOiYsgsfzk2x+eQys
 xQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PKSAlhSQ9Eh6fSSb1EiKiqDta1PeLzDdGDQlo2aRDw4=;
 b=DPptoOvGc65h5Vf3VehpCVgdDFAr3FUwwKU4uoQTZCv5gn06Of5eBrhHdEwUNem8Ci
 kl9Wy/qcE0bw13Y+d4Rb2iSTCpU2N5GKv94NW6aZhtV0RaGFw8RuAxrgWoVA3Jcui+yi
 D4GbrMCvKebBsyKa2S05w/+XSzhtSpepY/A8jqLo0m691BgOhG3DtkmdgPXQuIVdFVyO
 6aZmDi3pXricOnWtA9oVmk+ouMALYBpYNyhTV9ISvM0LQl8RQY+adsQSrtvJrEzJpzEd
 izKbuCBi5gQK+MYdYrn8HB9OmafQUm9yAtlLIgIAdZctVr99gN2veOmrTTeD7q+nPfmz
 kBVw==
X-Gm-Message-State: AOAM530Xn0yrK1xZhwE7V2e0Es46J6lOI+9n6n0Vzl87LDLwT17976bg
 2TgUfGAfK/rVNAtHfDwiyEE/1g==
X-Google-Smtp-Source: ABdhPJz+M60dQM2XcDdmSU16x2fFPZSTR+TQAMTpZYcbvWrpRI6wunJ1bR4T+xWDSV5N+1CvR8M6oA==
X-Received: by 2002:adf:cf01:: with SMTP id o1mr53523006wrj.421.1600695837833; 
 Mon, 21 Sep 2020 06:43:57 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:e5b6:fa6a:5f89:97d3])
 by smtp.gmail.com with ESMTPSA id q4sm20497820wru.65.2020.09.21.06.43.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 21 Sep 2020 06:43:57 -0700 (PDT)
Date: Mon, 21 Sep 2020 14:43:55 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 04/11] kvm: arm64: Remove __hyp_this_cpu_read
Message-ID: <20200921134355.5lzma3qzyiexxepd@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-5-dbrazdil@google.com>
 <20200918090029.GC30834@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200918090029.GC30834@willie-the-truck>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

Hi Will,

> > +static inline unsigned long __hyp_my_cpu_offset(void)
> > +{
> > +	unsigned long off;
> > +
> > +	/*
> > +	 * We want to allow caching the value, so avoid using volatile and
> > +	 * instead use a fake stack read to hazard against barrier().
> > +	 */
> 
> I don't think we need to copy/paste the comment...
> 
> > +	asm("mrs %0, tpidr_el2" : "=r" (off) :
> > +		"Q" (*(const unsigned long *)current_stack_pointer));
> 
> ... especially given that we're not preemptible at EL2 with nVHE, maybe
> we don't need to play this trick at all because we're always going to be
> on the same CPU. So we could actually just do:
> 
> 	return read_sysreg(tpidr_el2);
> 
> which is much better, and the comment should say something to that effect.

I must be misinterpreting the comment. I understood that it enables the compiler
optimizing multiple reads of TPIDR by avoiding 'asm volatile' (signaling that
the value does not change between reads). So what exactly does it do?

read_sysreg expands to 'asm volatile' but I have no problem with priotizing
readability over a micro-optimization.

> > +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> > +#define __my_cpu_offset __hyp_my_cpu_offset()
> 
> Why would VHE code need to use this? Especially in light of my preemption
> comments above, shouldn't it now be using __kern_my_cpu_offset()?

During v2 review Andrew Scull pointed out we can avoid alternatives on VHE code
by using __hyp_my_cpu_offset for it as well. Obviously if __hyp_my_cpu_offset
becomes nVHE-specific, we can always move VHE back to __kern. This was just
about saving a few cycles during boot.

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
