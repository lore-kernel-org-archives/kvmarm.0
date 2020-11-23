Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7384C2D0E4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:06:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F201D20782
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="g1MeLxRc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F201D20782
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BB844B73D;
	Mon, 23 Nov 2020 09:06:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KT7xAjyah+xI; Mon, 23 Nov 2020 09:06:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 600974B876;
	Mon, 23 Nov 2020 09:06:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 403714B73D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:06:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uryZiIljYDSP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 09:06:31 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AA544B876
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:06:31 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id 23so18680941wrc.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 06:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=IxKEwJIDkWFWdLOduLQqDMMWI7xU0QNpLG1mKFM02rs=;
 b=g1MeLxRcCLz0WGoi9c0wXjonCBJEJvpXP/SuuinED277DcmBiGSo2ylfvxgPK3Orb+
 IYbF3XUU1Ry9h065YjZh92o2p7ljYo7nRpGMl0NkF6iNLrOo4dNp7jFtk7+h1KYROio6
 dAxhhpaqX/xzThbEqRueM08mFje9M58Ra+GSHt65xzOt0bMHVh7G6P31qfA2PxqShp9b
 zSw6PaOQOTFPpyu3AqjyDhx68FUUk9vKOIWqA3xeHxHo6E4dgNZ0AHmDyBjYJYGmepqa
 wYx8HgdyBTzgzR766Br+hcqgXXDJPuosGuOfGsLkwPI8cC/s6Y4oOTMeBqv0VSEOgnNE
 LGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=IxKEwJIDkWFWdLOduLQqDMMWI7xU0QNpLG1mKFM02rs=;
 b=VqEqmnqdkz/0mH8U1KRFuGd6dj4J5fKqsFJ0PcRVXil9A7DC4X5hhZrb5D7MrGWGYB
 QBmiTFRvFPiDXXXH1nvr9z3uBC4Wlmx4WvnkbDPidGeYgKh1wqO1dFraRd/+AURq3fTl
 kZ+UdrCfollAKQc2N7YT+eDYz6pgzuQ+FPRy/XnehCAljc8Byf7jWPxHBtzMhZUP0Esw
 JEozjDb9FbpVzBoUmT7ATlJqOzqIcEN0qbM6K6u8XL7SHqzuEFB0e20r1YKREDvJ+Qzc
 vomzG11wEgMQw6TjNhLDS67bN5zK2or2HR0mLuc5sMt3tn4yOx1Szvjs79IWWqoHYKiz
 EwxQ==
X-Gm-Message-State: AOAM533/cJ5JQgKbNvWhptZZLyyAVJ6I1ih1P/fiRDg0tGigEg8m0VuN
 JturioQeWBXu5HOKY6uUPkauug==
X-Google-Smtp-Source: ABdhPJyw1pQaZQIURVIYntzJptazAHx7LZxvhh9s3DKAS6T2mBaDh+IRdAi2bZY6JoIkWxVe9MjV5w==
X-Received: by 2002:a05:6000:1292:: with SMTP id
 f18mr30790889wrx.196.1606140390020; 
 Mon, 23 Nov 2020 06:06:30 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id l14sm12976982wmi.33.2020.11.23.06.06.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 06:06:29 -0800 (PST)
Date: Mon, 23 Nov 2020 14:06:25 +0000
From: Quentin Perret <qperret@google.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [RFC PATCH 02/27] KVM: arm64: Link position-independent string
 routines into .hyp.text
Message-ID: <20201123140625.GC490744@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-3-qperret@google.com>
 <20201123123425.uzfuk3pmwgzuijwn@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201123123425.uzfuk3pmwgzuijwn@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Monday 23 Nov 2020 at 12:34:25 (+0000), David Brazdil wrote:
> On Tue, Nov 17, 2020 at 06:15:42PM +0000, 'Quentin Perret' via kernel-team wrote:
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 8539f34d7538..dd8ccc9efb6a 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -105,6 +105,17 @@ KVM_NVHE_ALIAS(__stop___kvm_ex_table);
> >  /* Array containing bases of nVHE per-CPU memory regions. */
> >  KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
> >  
> > +/* Position-independent library routines */
> > +__kvm_nvhe_clear_page			= __kvm_nvhe___pi_clear_page;
> > +__kvm_nvhe_copy_page			= __kvm_nvhe___pi_copy_page;
> > +__kvm_nvhe_memcpy			= __kvm_nvhe___pi_memcpy;
> > +__kvm_nvhe_memset			= __kvm_nvhe___pi_memset;
> > +
> > +#ifdef CONFIG_KASAN
> > +__kvm_nvhe___memcpy			= __kvm_nvhe___pi_memcpy;
> > +__kvm_nvhe___memset			= __kvm_nvhe___pi_memset;
> > +#endif
> > +
> >  #endif /* CONFIG_KVM */
> 
> Nit: Would be good to use the kvm_nvhe_sym() helper for the namespacing.
> And feel free to define something like KVM_NVHE_ALIAS for PI in hyp-image.h.

Ack, that'd be much nicer, I'll fix it up for v2.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
