Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48CEC43214
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 10:16:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F17960F02
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 10:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5F17960F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9654B17D;
	Fri, 23 Jul 2021 06:16:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UpVgJJtYctrb; Fri, 23 Jul 2021 06:16:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD944B180;
	Fri, 23 Jul 2021 06:16:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1BFB4B180
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 06:16:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aa8h9W8yZoyp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jul 2021 06:16:53 -0400 (EDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FD6E4B17D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 06:16:53 -0400 (EDT)
Received: by mail-wm1-f43.google.com with SMTP id
 x14-20020a7bc20e0000b0290249f2904453so3931669wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 03:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QO4j2IzOM4wXld1oT8EabRjAV6YqFAKfUcj8YzHBVaI=;
 b=p4cx62NpsnLzf2m+W/3JJq7BI22oWbvFv0i1JckRLSteAer4gZOuRH15gI/fN+lg9w
 siVxMEdqDosI3aqGGl9F6jnZHnetBuNBnSOem3WOdiUGAbldFFYf8ZssKFnvBDLp0RmS
 3gn6RnAHQRVq8oJ/fgyOTBg0dO5t/3UaGWuOhKn1C9AVTXq6HOqPeiYtXBBZhgMuXzv1
 mZ++vZrTNqqnqGbbaJTUK5ct3SLLBA3pCzneAjbKfInzuveVP9XdaZMHWxkKSeNCS3rp
 FLE94xYozdI0j4m4CdozhSUBM55Yt7y2y2xXVT+7nPx6aMKsta55M6MB6/snld9AMeTX
 5mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QO4j2IzOM4wXld1oT8EabRjAV6YqFAKfUcj8YzHBVaI=;
 b=LaJwWLBIDyfIvBl4WnESUasXAUnOnFlXSgKmuocbZAC/No6m5jC4p+A0pPc2HW8ki3
 g1X/mt0nx8qBZTFKWHQuMLCn74Opej985CyyB/OK9LxOMfRqv85zr5+H6L8QqgahWljW
 glUlDSBydp2fGYjQ7uHIpKNFl3TejNnUxSa86mZXcW0AzrIXQIbBcSByNkQt0HUlQI73
 CaTtfS24owWwbk+LWw22W+zuCpOqvS6EKyZaiqJr9bYLauWTHwvBwA1qnen2V8GJzzGU
 ZdtMLicaxQk6m8ayA2BLQNmk/5ihuEls6QL3wsHqlDPlbNkHSmUrYA5PSVaPnIu/YQ9D
 4mrQ==
X-Gm-Message-State: AOAM533GOpJ/JwBBvmeOmntZfjHAWRSVXWhuWHWZB0e7HLvoLccIX/TR
 /z7JGF7ad2U6Fxjc2ZrEl3XUCg==
X-Google-Smtp-Source: ABdhPJwcozbpoFVBs05Zwspcd461WuCRshxtkqBNwhnzq02piQroC4Xf8Z0bCbz4m8KGE6IV7yRefw==
X-Received: by 2002:a1c:7410:: with SMTP id p16mr12979418wmc.6.1627035412079; 
 Fri, 23 Jul 2021 03:16:52 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:a74:efb2:dddd:7915])
 by smtp.gmail.com with ESMTPSA id f7sm32325442wru.11.2021.07.23.03.16.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Jul 2021 03:16:51 -0700 (PDT)
Date: Fri, 23 Jul 2021 11:16:45 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YPqXDeRMZOX8bmNh@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <YPav0Hye5Dat/yoL@google.com> <87wnpl86sz.wl-maz@kernel.org>
 <YPbwmVk1YD9+y7tr@google.com> <87wnpi1ayc.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87wnpi1ayc.wl-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
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

On Thursday 22 Jul 2021 at 19:04:59 (+0100), Marc Zyngier wrote:
> So FWIW, I've now pushed out an updated series for the THP changes[1],
> and you will find a similar patch at the base of the branch. Please
> have a look and let me know what you think!

I Like the look of it! I'll pull this patch in my series and rebase on
top -- that should introduce three new users or so, and allow a few nice
cleanups.

Thanks!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
