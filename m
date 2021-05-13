Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79120C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 08:05:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4AE76143C
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 08:05:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4AE76143C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1174B3CF;
	Thu, 13 May 2021 04:05:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yfpL38+LBZbC; Thu, 13 May 2021 04:05:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542E54B768;
	Thu, 13 May 2021 04:05:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 892B74B765
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 04:05:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FoNBYE3Qr5Rl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 04:05:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88D484B388
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 04:05:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620893150;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=VDqpVG5nZvDDm4obyS6Icgk8AYhvJi0sT/Vy0U5YIZs=;
 b=f+P+KQhJR6nV1iYXPYfGXy9IBgFOYhotXf9uVkNwN8t6iSkYQOg4zLXyCckIfbwEmxu3OZ
 4vA4rJxTkQW92mzrFPdwpZ0EjPxBeK5ZNceJ5HFmgIfthI0Gq16sR3wBKOS2jiZEXPNqJ+
 9XUkrN+y9T/JAkRg2mGBFJE9bbThbzQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-R8pz_6p2M_-V8HGetuL63w-1; Thu, 13 May 2021 04:05:48 -0400
X-MC-Unique: R8pz_6p2M_-V8HGetuL63w-1
Received: by mail-ed1-f71.google.com with SMTP id
 g19-20020a0564021813b029038811907178so14195257edy.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 01:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VDqpVG5nZvDDm4obyS6Icgk8AYhvJi0sT/Vy0U5YIZs=;
 b=T8mkpLM/qOFOKetmI7h0ikLPPr09KG+0fcA5cxaiJOVRIUQQbFE3R85WCq3qTbBr1G
 7egnPx+k9PVVj8HB5aD5zuB96Dpld85aU3V+J1nQoY51TwgUkdUdPYClJm5WdOCxKf7j
 UfhBSzjanGY1ZVhtO7YS7UcJvv1zSMYu9uEwIyuKDUfnnRtTgEiaY46N0sLZyeC/sI3M
 BwNxwSSKAsTo/U1LRWQsmbNjfZBtTh+QaWixXSxMdZX9S/8Y7cUmcUOsvJyq7CCM7KM6
 FP2Niir2bQMgeyvtkmtolIXT3LqFMvbmTsIdRsNhGngqosCCxg4U1Fg7ZcsuEf5kvTna
 87DA==
X-Gm-Message-State: AOAM532T8ldOOgP/U3maHp6NbhJhvP3ib02hnn6qb7lHfvNB2pM1sIcO
 YedErNT2ISqi9gxmfto5/GwTLld4DQae6WPQ8mrCFMOnnxBOlGMDchT7vpzZwPyATVOf7oAk5Q4
 mBLdprEyNLfWqWDgDYYS4XbDE
X-Received: by 2002:a17:907:ea6:: with SMTP id
 ho38mr7937145ejc.357.1620893147399; 
 Thu, 13 May 2021 01:05:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOCHK0tMO9+mnC0XSGsxFUlqtyPsrTEwy2/rOnVkz5KReRdAulhVI/0zOM/TLdCxoXrucHhQ==
X-Received: by 2002:a17:907:ea6:: with SMTP id
 ho38mr7937128ejc.357.1620893147226; 
 Thu, 13 May 2021 01:05:47 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id c9sm1848819edv.24.2021.05.13.01.05.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 13 May 2021 01:05:46 -0700 (PDT)
Date: Thu, 13 May 2021 10:05:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <20210513080539.iruamqsbiykqig3w@gator>
References: <20210513002802.3671838-1-ricarkol@google.com>
 <20210513002802.3671838-5-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210513002802.3671838-5-ricarkol@google.com>
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

On Wed, May 12, 2021 at 05:28:01PM -0700, Ricardo Koller wrote:
> Add the infrastructure needed to enable exception handling in aarch64
> selftests. The exception handling defaults to an unhandled-exception
> handler which aborts the test, just like x86. These handlers can be
> overridden by calling vm_install_vector_handler(vector) or
> vm_install_exception_handler(vector, ec). The unhandled exception
> reporting from the guest is done using the ucall type introduced in a
> previous commit, UCALL_UNHANDLED.
> 
> The exception handling code is heavily inspired on kvm-unit-tests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/include/aarch64/processor.h |  63 +++++++++
>  .../selftests/kvm/lib/aarch64/handlers.S      | 124 +++++++++++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     | 131 ++++++++++++++++++
>  4 files changed, 319 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
