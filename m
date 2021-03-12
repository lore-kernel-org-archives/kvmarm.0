Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E27C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 09:15:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 529E464FDD
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 09:15:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 529E464FDD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B91EC4B502;
	Fri, 12 Mar 2021 04:15:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NEr4nvambAk4; Fri, 12 Mar 2021 04:15:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C9284B518;
	Fri, 12 Mar 2021 04:15:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF8594B505
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 04:15:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uf1cHqwI1zwB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 04:15:34 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9258F4B53C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 04:15:34 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id
 n11-20020a05600c4f8bb029010e5cf86347so4189167wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 01:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8hyTObTnA8b0Pah5w5x3EX45G+4aGq3Qg+uSFkSPcCo=;
 b=jVs4+SZBOncaHTNZfrQPmfUwVYzNZgKm+iL7UkFzH2hi1esIn3UON4srQWsKqCTzIQ
 v8JzJSmZb/Dt5o4ziJlrUAEwS2Rozm3WkV8g21rcbXUuZHVDSd9g6MygPJfvd2G8gKRX
 3xEtqIHBTd95yzydjWyupkUBpp0DkDmseSBNQCM/Y3SQORaEXSfQuWSVT+Wi/qtY403j
 YJ3N/tL9sTiVdHVw4vpjyxqiknFYfbN3qfQSohG7eu56ZkuMaenkzlbqQRqucppZa6wJ
 nURlMd0nasN1vXl7gtLFx739nu6Zg3c9ItV3TJWROADQH4DX2TjRm0RCnbCQlLC6+RnZ
 apjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8hyTObTnA8b0Pah5w5x3EX45G+4aGq3Qg+uSFkSPcCo=;
 b=jIS7/paK1ohKnAK6acK4zLOFjAOBjZ6ZJ3KfIR4lzhkwEvO73wti7SqMLNQ7B0TWJQ
 3fhmdYuzrlQoNkPmUp/5ftTfH6rmtG3KjdY8XsbwIi+ZWvrUuLfFhSm5xPcklbZrtp8L
 hmqkbVcCKPqkap8HyhXCm1n0dx/dAm5AOrsBU7mzcb4EF04iz3VMlCitMSzPr9ksOCj+
 CerXWKL6VZFxZ+hP5mEyfkRMsmedvm6SfB7IZuODtW4AbCDzLxDa9mvZj06P5TmM7PW6
 4i/knP/mmD+Np26qmVqAdBiRLO4Gxm0j2aEQB+MSi5i/O/lbGv8+mMJ7jLg982CGEVr1
 S9dg==
X-Gm-Message-State: AOAM532bkzoJoF9FfZj0xvrfNP+coROzv5VSfPXBXYehenIKiiD4P39L
 XKks++AlDrkUeXzUJBfWmlOEYA==
X-Google-Smtp-Source: ABdhPJyo6oi+MSsftqzukHAyRgFvWhaTOLTqQm++oJ1mRSO/qD8ZSQ8ap6nF6e9hdN/8C+ctlvX1pg==
X-Received: by 2002:a1c:8041:: with SMTP id b62mr12506853wmd.0.1615540533351; 
 Fri, 12 Mar 2021 01:15:33 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id j203sm1510033wmj.40.2021.03.12.01.15.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Mar 2021 01:15:33 -0800 (PST)
Date: Fri, 12 Mar 2021 09:15:30 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 27/34] KVM: arm64: Always zero invalid PTEs
Message-ID: <YEsxMgNncoVLdkjo@google.com>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-28-qperret@google.com>
 <20210311173338.GB31378@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210311173338.GB31378@willie-the-truck>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Thursday 11 Mar 2021 at 17:33:38 (+0000), Will Deacon wrote:
> On Wed, Mar 10, 2021 at 05:57:44PM +0000, Quentin Perret wrote:
> > kvm_set_invalid_pte() currently only clears bit 0 from a PTE because
> > stage2_map_walk_table_post() needs to be able to follow the anchor. In
> > preparation for re-using bits 63-02 from invalid PTEs, make sure to zero
> 
> Why do you exclude bit 1 from this range?

Hmm, no good reason really. I wanted to play games with invalid table
mappings at some point, but dropped the idea and forgot to update the
commit message. My bad, I'll fix it up.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
