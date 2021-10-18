Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EDBC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 10:36:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD4B1610A6
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 10:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD4B1610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D1C74B28B;
	Mon, 18 Oct 2021 06:36:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gPeqCcLzO4FM; Mon, 18 Oct 2021 06:36:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9AE54B1E7;
	Mon, 18 Oct 2021 06:36:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 897004B1DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 06:36:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zFO0ZwITHgJc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 06:36:52 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B6264B1DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 06:36:52 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id r10so40389305wra.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 03:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=CnEGvS5JHOdGgOAvyH9jWqTEdXWkoZtVd5ySMVIlc2M=;
 b=nUS9Jfmev2YDtluONWMHfsBhtGgQYYBu4Q+Kf28SCNr2s4YgglFqRJbpMOyOPYX5NX
 hxK9nJ+XQRFqHBXeMsZLop/QPwqALP23LtbQCiDXWRQ7SvxACThuih4FVcXfPZ3+x+yF
 XBOd9FpimNbU1VCXYo96LQJatqe/VGCp+d0Q6so4WLmKclqpFBso6AK5FpvHGN1neGFF
 UrZCMHy513Ugk620ZjW8lwUg6GF1YiMUkwvGuls2BU7O/mH5Kux/gA4VpWO9oQWq3MD2
 AW4sWYa6lA9qBl5b0u+FO6760LXpWUKJ2/UCVUm+ExmdfbjZkZkisT78hyTtvs2A1UFc
 lvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CnEGvS5JHOdGgOAvyH9jWqTEdXWkoZtVd5ySMVIlc2M=;
 b=DVvUklmUqZuzQJyHZ43GeoTLgVJfg62gW3SgAtiZpaRDmnm+2Y8ey1Iew8Gm6jKNav
 lrk1zI8Ih4QxjgzO8v8/9Knan0Bim9Cf9R/kCjcUa0Ha9YqnzF3NjhGHrA6Y7FCLOphR
 U2zG/dhOTD7nS8yLwPAQv1Ao9mZ9cX+PjgfkgJhfhA8KJV4NfFdEGuZ6fkhYyjqvINa6
 9UPJFbbQRNUeQNzx0B/BsxnwYrs0/yTVgy6/h4hM5LUKh4TRnTuumN1pPsTe4lnCAaz4
 6qCvOCE8ffE2AW7BPMn1bnGrHDJAAcCJnMgrL9z0eNUha48oVEGzs5EsyqGMpC1KYrP7
 3zdg==
X-Gm-Message-State: AOAM533rsxnOpJZdcVvW7BBKs1Vyg5Frb8qz2BAdktjHhV+OFHBobway
 3SoUcA3PW4LCUPpGT3lI6N/jEQ==
X-Google-Smtp-Source: ABdhPJxwV62HytYs4AsqvTvUlMdNokRzwgb0hYlxd00yfiJ21uyA1k1ex6RbulURH1wBC10+z0Zn1w==
X-Received: by 2002:a05:6000:184b:: with SMTP id
 c11mr34504451wri.29.1634553411421; 
 Mon, 18 Oct 2021 03:36:51 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:ba81:6f1b:ab2e:f120])
 by smtp.gmail.com with ESMTPSA id c7sm15162725wmq.13.2021.10.18.03.36.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Oct 2021 03:36:51 -0700 (PDT)
Date: Mon, 18 Oct 2021 11:36:48 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/16] KVM: arm64: Avoid remapping the SVE state in the
 hyp stage-1
Message-ID: <YW1OQNuq5Gdd9jpQ@google.com>
References: <20211013155831.943476-1-qperret@google.com>
 <20211013155831.943476-4-qperret@google.com>
 <87ilxxut74.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ilxxut74.wl-maz@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Saturday 16 Oct 2021 at 12:04:15 (+0100), Marc Zyngier wrote:
> I actually ended-up implementing a similar patch as part of my 'first
> run' series[1], though I moved the mapping to the point where we
> finalise the vcpu as that's where the allocation takes place.
> 
> Do you see any potential issue with that approach?

Nope, and in fact I think your patch should allow to simplify a bit
kvm_arm_vcpu_destroy() for me, as checking arch.sve_state != NULL would
now be sufficient to know if the sve state has been shared -- checking
arch.has_run_once is no longer needed.

I'll base v2 on this.

Thanks!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
