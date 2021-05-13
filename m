Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B3FC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 07:35:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 34687613E9
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 07:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34687613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1694B516;
	Thu, 13 May 2021 03:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ANCn4tWQLK8C; Thu, 13 May 2021 03:35:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7F24B48F;
	Thu, 13 May 2021 03:35:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69F654B48F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 03:35:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HGDgf3wZQWvm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 03:35:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9769A4B477
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 03:35:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620891340;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zTEQQXsAJQxZUo5zOYVOBC+x54vGh0Ue0rC0kRz9wp8=;
 b=GvSFwA75ZZAscu9I2FhpmKHWO7Pfd89FeMGYOBB44QeNYuynOIOfa678ylPJ1iwgJaz7N7
 PBz+5apFDXmo2fqdpHQw5GMghCUCBkKsSYs55uJoKh1hVWqE7Gn1jCmxv/G0Hh1qKnwvcE
 tke0lcaujWEFhQcUgn4juyJKl6pmi6E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-H1VdOz66MtuCircf1OnlCg-1; Thu, 13 May 2021 03:35:38 -0400
X-MC-Unique: H1VdOz66MtuCircf1OnlCg-1
Received: by mail-ed1-f70.google.com with SMTP id
 y17-20020a0564023591b02903886c26ada4so14206118edc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 00:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zTEQQXsAJQxZUo5zOYVOBC+x54vGh0Ue0rC0kRz9wp8=;
 b=UHZ6qG9F1+WjTf9sL5OuC8mVUt81CPtc2f4xnjmb0NyB2F8b5y/Xtc/VdcGQnVm+kF
 UXqhvWMnk4yf/PPPHzKE4RcWHVd4t+Ri5KyDme/dXk/+xSvew/0GquxbSrGbrd/ZaAFW
 p6EBllzPnihYZy4cVkyDxp+rnWEwLkhaQoDgC+X5CTx+TEreYU8obzl1jfw+AIGwxej2
 grSimpMGDuQebTS1pEV45+ajBk8iLhc8KFNOWtAKge/C6OFmF/QYUy/qveKlIR3NcV+r
 XtFsdyoI4xRr5ilXV4+i9IYGolng2kvaJuHTdcoKDL9QmM1aUKTiMImfy9G7QT7n0IFX
 KpTQ==
X-Gm-Message-State: AOAM533Fl+/hg705QL1uNMf4emv+ZxgHJA/bEaeuNHbmKklOk2filOgS
 6f6J3gSSMDxZs3NVGHJXjCKxbI+3j8CbljdL+mij/G10+w9nBQ8Vghk7lPS1GlJvq0YfC83IoWo
 tHTHZ57E9CABLTqE9dtE4R3p3
X-Received: by 2002:a05:6402:1547:: with SMTP id
 p7mr48873035edx.319.1620891337823; 
 Thu, 13 May 2021 00:35:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4fQrV1jLbyyYnaAc4rghuBIVhv9b9kqKDT7Ao5odjIT9s+5ushZxRP+CITFR79rGJjFXT+w==
X-Received: by 2002:a05:6402:1547:: with SMTP id
 p7mr48873016edx.319.1620891337666; 
 Thu, 13 May 2021 00:35:37 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id da25sm1869559edb.38.2021.05.13.00.35.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 13 May 2021 00:35:37 -0700 (PDT)
Date: Thu, 13 May 2021 09:35:30 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils
 header
Message-ID: <20210513073530.ajehgqt55o4faxul@gator>
References: <20210513002802.3671838-1-ricarkol@google.com>
 <20210513002802.3671838-4-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210513002802.3671838-4-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
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

On Wed, May 12, 2021 at 05:28:00PM -0700, Ricardo Koller wrote:
> Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
> architectures and tests to use. Also modify __GUEST_ASSERT so it can be
> reused to implement GUEST_ASSERT_EQ.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 22 ++++++++++---------
>  .../selftests/kvm/x86_64/tsc_msrs_test.c      |  9 --------
>  2 files changed, 12 insertions(+), 19 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
