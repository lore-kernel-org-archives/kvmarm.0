Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37D5C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 02:40:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E2266113B
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 02:40:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E2266113B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A3F4A3A5;
	Wed,  3 Nov 2021 22:40:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8ax09WLx-dRS; Wed,  3 Nov 2021 22:40:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0794A4B089;
	Wed,  3 Nov 2021 22:40:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B205F4A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 22:40:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i7N0GMdrAnSd for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 22:40:42 -0400 (EDT)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com
 [209.85.215.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33DD749FB7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 22:40:42 -0400 (EDT)
Received: by mail-pg1-f179.google.com with SMTP id s136so4126053pgs.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 19:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=l1LBkVxSub6LJ5OnLwtZ2Go/f73Tx/9aZenvySQfHeI=;
 b=ZW8TrfFoTH/tYASAAkeV0eDaMdGL/LctDxidEfV+xRUTyZ7KwSxyi9DKFFPXnB2FlC
 A8nkvWWExDP3moWXZOmtv0Mzi0B2KKbU/alkNtxkfSWl53CI7HNkvCgVfPJGPT1jq/7k
 uK3TOZvwYLbnPkDd5WYsiH4a0TYXOrk7JONuOJO8yCBh316ScLDOZ7sxmEeg7I9/wKYs
 /7xZtZbZ41/h8OweuhfMUXyXw074W/J06ZCLcVTR/XMjTFFRPaW63EkLQcFMrJwnziyh
 FseFp37H5yPIjowS70gHcwa0IocAqPcfoJvJvhG+kyIma5tVLbiwGbWe/qRFC1KJoyHt
 XMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=l1LBkVxSub6LJ5OnLwtZ2Go/f73Tx/9aZenvySQfHeI=;
 b=O6drVLsiUeitefseuTNGmI7yyQ+qvCoiIscPzSn90muyU887JFTl7M04xF1AzVh3Rr
 yYq8hG+/Py0dbPqPoR2OucxrB3dtXzJ4MyyYGwQQAhb5K6EG8+w0FrqlK6iUD6fly1Jx
 TyYNFPtl4UTERSXbT0DD19yDLz8kW3P1jjNsUX+5vyNn9eN0KmqvxfYGAWGWqqYT1wmQ
 ygTkdKqUeCN3YEL36A6qdEEuUU+tBHXM17DhZXpB+iR17ypKvi43/UK/SKtjchBMW3Jl
 ZrFPblMiDt5+9hotfiH0uMmGgvdDQ2VXeFDK+nuOvRKbBpsCFGLVFdQXEm9KW9/86Wg9
 4Q1w==
X-Gm-Message-State: AOAM531gqMNOXaHTTHo+pBk99r71ntYYeymcM+LvVwGST041+MZ4sfjL
 mwXNKbzFsiLWupQS4llU+vKq9/wrDi0LHa874Lr1kezUPnmujC7U
X-Google-Smtp-Source: ABdhPJzAFkFqwjuIjHc0h9oKGkvOHRgsFxGKfJBRuHvvwWYY2QLB2+GCOWAkaMHse2lngZcp/lkw0B+Edbhnyr1mOCI=
X-Received: by 2002:a63:c158:: with SMTP id p24mr5456974pgi.53.1635993641104; 
 Wed, 03 Nov 2021 19:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-2-oupton@google.com>
In-Reply-To: <20211102094651.2071532-2-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 3 Nov 2021 19:40:25 -0700
Message-ID: <CAAeT=FwDep0irwYauX8kyRKfOOtdpqm_CAntDu_COYa6zJAvDg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as
 undefined
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
>
> Any valid implementation of the architecture should generate an
> undefined exception for writes to a read-only register, such as
> OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> behavior.
>
> Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> write ever traps to EL2, inject an undef into the guest and print a
> warning.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
