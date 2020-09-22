Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95F3C2D0E2
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 18:07:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C00E23787
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 18:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="CRd63rpN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C00E23787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4836B4B36C;
	Tue, 22 Sep 2020 14:07:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NwWA3Hi7JK9i; Tue, 22 Sep 2020 14:07:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 207B54B39F;
	Tue, 22 Sep 2020 14:07:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 992774B38D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 14:07:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1hwBrGJ4bZa1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 14:07:48 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9875A4B36C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 14:07:48 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id x14so18082878wrl.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 11:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=6y72uZ7YdWD1XXfQ+XTc3NqqPVXw5bQyVkymr14fQGQ=;
 b=CRd63rpNjyrzDcmAXaGmKY+nIczGjjMJGpL77E2ju9oloTgn2/h43kyf7RWLd6TSb1
 drxGmpeR76PV5D4kIrtMak0BTXiG5QqFMzjzRfQlbfXHW05r/mynwAVi8WOU7EzJz668
 1OQ4vm0VTMoo+qE1KCxXK/ZC2MaA+0D0xpWJECvrWvULe4ay+hp8jpleCDlSQl6ynXDm
 hdn5fKFjis/9QrlFTJZ65bXGTQnbSyH4tgejSXC753c+nYjHnfeoxaGtt5vIr7zmYhnN
 eQl+KORPu/uRAmRcXz71wLELsQ70yI9fMXN5m2dnfT3ZLENatNSfDyQyWqxnCJ+hp3Lj
 Jh9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6y72uZ7YdWD1XXfQ+XTc3NqqPVXw5bQyVkymr14fQGQ=;
 b=ipUvHx+1us4fxmfEk8IIJpNd2z1VARpjXFaLcFqnsDgXFB3Nj9q91QkCtGNuztw6DY
 +EElfVi/OP4FAxIyQ1p9OB+NKMI9O4MQ+OCyWjo3U3XZdK+9uuonnNdZhsaYV/slo8Kr
 ssIkiFhCnrTxq5kq94/nEH2Wik5SxBYfQFEc+1dxOYshU+A4+hFYypbu3pLFf1vCYJcL
 Rc3YMKvP2GSmnmcVNSuo22vFEceBVOpLXq2x7SvKbEftPalUxrq89uAwYQ75iTpQWDcv
 Gw3tlaXhLcd8vahilsR4e6brsNkWOS1l9WOTXeUG1mVXUQTM7NTyaFMQReiOzaTBpw9Y
 FWFg==
X-Gm-Message-State: AOAM533Gvw1rHMnIyLDB5fVygIkBrDgqWXy1LJ64JLW3QaG+PJdi3dm4
 M/bk4KzdQQFoa3jaV8wzgDhkHw==
X-Google-Smtp-Source: ABdhPJwZPTozi74qAG3/aClHpnw3RnRnKS0i65Quxl7eR1kjuVfhlagjStYPlzzSrntMUCfignnPpQ==
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr6822937wrs.107.1600798067242; 
 Tue, 22 Sep 2020 11:07:47 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:55c2:2cdf:ff31:96a3])
 by smtp.gmail.com with ESMTPSA id e1sm28558820wrp.49.2020.09.22.11.07.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Sep 2020 11:07:46 -0700 (PDT)
Date: Tue, 22 Sep 2020 19:07:45 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 07/11] kvm: arm64: Duplicate
 arm64_ssbd_callback_required for nVHE hyp
Message-ID: <20200922180745.m6bjgjzz6cwercgf@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-8-dbrazdil@google.com>
 <20200918115911.GB31096@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200918115911.GB31096@willie-the-truck>
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

> >  		u64 *ptr;
> >  
> > -		ptr = per_cpu_ptr(&arm64_ssbd_callback_required, cpu);
> > +		ptr = per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu);
> >  		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
> >  		if (err)
> >  			return err;
> > +
> > +		/* Copy value from kernel to hyp. */
> > +		*ptr = per_cpu(arm64_ssbd_callback_required, cpu);
> 
> Hmm. Is this correct for late arriving CPUs, where we don't know whether
> a callback is required at the point we do the copy?
> 
> That sounds fiddly to resolve, but this _might_ all be moot because I'm
> about to post a series that allows us to remove the hyp mapping of this
> variable entirely. So leave this for now, but maybe stick a comment in
> that it doesn't work for late cpus.

Ah, good point. I'll move the value copy at the end of cpu_init_hyp_mode().
It must be known at that point. And if your series gets rid of this completely,
even better.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
