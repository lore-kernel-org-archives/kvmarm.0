Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27971C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 15:15:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7EBEB64DE3
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 15:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EBEB64DE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F28094B391;
	Mon,  1 Feb 2021 10:15:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R+QSxbJjs7vh; Mon,  1 Feb 2021 10:15:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9234B3A8;
	Mon,  1 Feb 2021 10:15:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521C64B391
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 10:15:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eALf6ynuBupd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 10:15:50 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C79C4B305
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 10:15:50 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id m2so12956598wmm.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2021 07:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=iCud/oZ0jp00VRdDLSDWa/VPzMcKe48VJwPVpyKJcE8=;
 b=bljmv40viwV5v57+TtBOFwGAaz54F5a9tDXB2PSZe5+LMS1pOd9d8QiRNcEEtmVfmT
 pdNUcTuIXIUH3CaAc+wpyhYC5hKvmCSEj3iNLAZHozaqd/vHgd82MB0cpAg+LE90lF16
 4P26uy+BK3EEMlaZGLfJlDisoXkiQ0huHLkrVAmKcmxDHmxRD8LzSGmdL2Cr3wzW5T7M
 zg97INgmlfCsvWBOEZA+9NcyNVwamwDVUFyds+AxAL8QQh5KBvfc3PUTwvICN//HHTDZ
 qkNaJJ1NQUcUnxMsjuP69oEL1TAKNDjTmwV8/PCUe7VrMoqb6akq/NuC0JNy5Wkan48Y
 G81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=iCud/oZ0jp00VRdDLSDWa/VPzMcKe48VJwPVpyKJcE8=;
 b=rXxZi8XeK0bw0j4SoQFKUbxVUsBkQTVUdzclteqqkOaenoKS4cxk4lOx0weTicGjPZ
 9QcY5775kXYlUX2L/b/1bIyocG/5yoQf6FAQHoKorahKI9iJ9OtUIdJRM4aNSoRAkEDt
 PeoSgkWyOcvF9KdGqSZWN1MN0iSHDPrb5bTHKJnW31k3bzmevVGt2DWWy//3NXYbG89/
 g/9gqoXI5eohIzCzRHAJqz8CQK9ejDG4PjvCmzhLc31HTInKs5sCfJn0X94lgueJOC60
 Lx6gavYa1j5PCNqISbTX1FSaNuEFfLjme7wVQk52xbXEZ8E03f544ClE0Mm7dCX6Yglk
 2wvQ==
X-Gm-Message-State: AOAM533ikx6iZrYsHvMabpT5SEsqVQBvHBrxKPP+mCh2Nrayg4LyjMtZ
 NYWMHx4dRh81to8XJSaOYJY2Bg==
X-Google-Smtp-Source: ABdhPJxyP1BG+oDXc31HY7CW5MYwKqTaLbVBSjGD3rpSrDcbzKlD5YRXlGtJCbFbmp87GaK0VAFutQ==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr15569794wml.110.1612192549227; 
 Mon, 01 Feb 2021 07:15:49 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
 by smtp.gmail.com with ESMTPSA id y11sm26855292wrh.16.2021.02.01.07.15.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 01 Feb 2021 07:15:48 -0800 (PST)
Date: Mon, 1 Feb 2021 16:15:29 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v13 03/15] iommu/arm-smmu-v3: Maintain a SID->device
 structure
Message-ID: <YBgbESEyReLV124Z@myrica>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-4-eric.auger@redhat.com>
 <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com>
Cc: jacob.jun.pan@linux.intel.com, alex.williamson@redhat.com,
 kvm@vger.kernel.org, vivek.gautam@arm.com, maz@kernel.org, joro@8bytes.org,
 linux-kernel@vger.kernel.org, nicoleotsuka@gmail.com,
 iommu@lists.linux-foundation.org, yi.l.liu@intel.com, zhangfei.gao@linaro.org,
 robin.murphy@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

On Mon, Feb 01, 2021 at 08:26:41PM +0800, Keqian Zhu wrote:
> > +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
> > +				  struct arm_smmu_master *master)
> > +{
> > +	int i;
> > +	int ret = 0;
> > +	struct arm_smmu_stream *new_stream, *cur_stream;
> > +	struct rb_node **new_node, *parent_node = NULL;
> > +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
> > +
> > +	master->streams = kcalloc(fwspec->num_ids,
> > +				  sizeof(struct arm_smmu_stream), GFP_KERNEL);
> > +	if (!master->streams)
> > +		return -ENOMEM;
> > +	master->num_streams = fwspec->num_ids;
> This is not roll-backed when fail.

No need, the caller frees master

> > +
> > +	mutex_lock(&smmu->streams_mutex);
> > +	for (i = 0; i < fwspec->num_ids && !ret; i++) {
> Check ret at here, makes it hard to decide the start index of rollback.
> 
> If we fail at here, then start index is (i-2).
> If we fail in the loop, then start index is (i-1).
> 
[...]
> > +	if (ret) {
> > +		for (; i > 0; i--)
> should be (i >= 0)?
> And the start index seems not correct.

Indeed, this whole bit is wrong. I'll fix it while resending the IOPF
series.

Thanks,
Jean

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
