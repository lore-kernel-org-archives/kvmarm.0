Return-Path: <SRS0=T6xz=FI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B95C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 09:54:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 403FD22838
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 09:54:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 403FD22838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 732F84B2D8;
	Fri,  4 Dec 2020 04:54:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4tganqw34L-x; Fri,  4 Dec 2020 04:54:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC5A4B2C3;
	Fri,  4 Dec 2020 04:54:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A19C54B2B1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 04:54:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QhvBhaEFLD2u for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2020 04:53:59 -0500 (EST)
Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com
 [209.85.218.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6720D4B2AF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 04:53:59 -0500 (EST)
Received: by mail-ej1-f66.google.com with SMTP id d17so7772458ejy.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Dec 2020 01:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Uv2efItsQUhEgfX7SeOo28N5gNOKYGwcTRvbk7tp5sk=;
 b=Y+yQmo30CQFiR5TTzDwrmyJatxpqtANqRpaIncgY2A8s2nWuzGUeyn1tlf4gOxugd2
 hh8E3nHhmj4zo93RilCZjKplbsTkCbNxNPF8uYID9W5PuMKVGbJigGgWD9afGHl880zK
 58XjKXOHPeMO/smMTfgANFsLPDLJ7SGTQmRGvK5+9rVbt5ynuxcXqQInlbHiTr3T4N4V
 w8Wu7TpMV552x6QPPvqgAlSK6lmA7BRml4jRWHiI63XOeYUq0EO1/mbxl22WqthPcaDm
 nfWp3DFvC6vgW0kGiJ+NqG+v0vXx7/6/rIRANPewGZH1nMCdkpAXWjUQbYAPRfIXi/R1
 CaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Uv2efItsQUhEgfX7SeOo28N5gNOKYGwcTRvbk7tp5sk=;
 b=cPN345zidXWpLRO3lWlDgftNxpu0E6KF+U6Wm+f2rbnXcvProsNLx1i24JXmXWhTat
 GV+meGMhFkJRfCFS4jA8VjN8XzfYyTaLxQzJpmZAOaIBrSNQ2JNHFTsDNu7NGmWCH37P
 fhdSMxBS/LuIAC6nVqmgRW9uBRKYfLDHYfD/PNh2+2pjcrZNzlwto/MON5dz+MkwpK+k
 GWvjdK4V2CbXQQO1OTEtCm/+MZw57QE9Qmhl93oDHDVTQ0952NN1NyJeuT9VHXdp2qwh
 duRd0WkILB9XZ0uBo9bGOpZlypZlBFR12Yw+BixO5L06pDgR9f88LkrGa1LsvRf2FUof
 PKtg==
X-Gm-Message-State: AOAM533sVdYaOVlu7h6QULQ3nc6P8UhDAlq6oWco5QCMjm/5kzSaF75N
 NUr4DngB+USjnsMzpxyqUTxfTQ==
X-Google-Smtp-Source: ABdhPJwXvl8nLosqnGM8eU8JP87XsB+l9fv0jbHDns3+jJMfPKJqM1nwHazVtadoe4qIEMJGSczwsg==
X-Received: by 2002:a17:906:81ca:: with SMTP id
 e10mr6195735ejx.449.1607075638385; 
 Fri, 04 Dec 2020 01:53:58 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
 by smtp.gmail.com with ESMTPSA id k2sm2690147ejp.6.2020.12.04.01.53.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Dec 2020 01:53:57 -0800 (PST)
Date: Fri, 4 Dec 2020 10:53:38 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Message-ID: <20201204095338.GA1912466@myrica>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
Cc: Xieyingtai <xieyingtai@huawei.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 wangxingang <wangxingang5@huawei.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "maz@kernel.org" <maz@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 qubingbing <qubingbing@hisilicon.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>
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

Hi Shameer,

On Thu, Dec 03, 2020 at 06:42:57PM +0000, Shameerali Kolothum Thodi wrote:
> Hi Jean/zhangfei,
> Is it possible to have a branch with minimum required SVA/UACCE related patches
> that are already public and can be a "stable" candidate for future respin of Eric's series?
> Please share your thoughts.

By "stable" you mean a fixed branch with the latest SVA/UACCE patches
based on mainline?  The uacce-devel branches from
https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
(they track the latest sva/zip-devel branch
https://jpbrucker.net/git/linux/ which is roughly based on mainline.)

Thanks,
Jean

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
