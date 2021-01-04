Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97630C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 19:06:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10E48206A4
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 19:06:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10E48206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8024B1CB;
	Mon,  4 Jan 2021 14:06:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nZD2unbQCNEB; Mon,  4 Jan 2021 14:06:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 628544B1D5;
	Mon,  4 Jan 2021 14:06:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58DE34B109
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 13:42:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfYBbGP-f7fB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 13:42:37 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 847D24B104
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 13:42:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1609785757;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DKmL21N+iyKhBf8N6rygtnRxpR6MVevdbYR2ogpgY9U=;
 b=iar9VlfAnTfiRmOmWb5jv5Sj/U7+qxjSiEngPMaEm0k5VlSytmW0E4rqySvh+NzTLFAM3B
 QxZqawP8CvHlZV8MrSnl/TMs268MNDZGwURQLW67+xurO2+2CryBXg5i5j0jC5cfTajgZp
 1oDl5AQWGUUt3qDa9ZI7CUHna5ei0HQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-0a-1fElvMayIVmgyVXnKvA-1; Mon, 04 Jan 2021 13:42:35 -0500
X-MC-Unique: 0a-1fElvMayIVmgyVXnKvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09817107ACF8;
 Mon,  4 Jan 2021 18:42:33 +0000 (UTC)
Received: from ovpn-66-203.rdu2.redhat.com (unknown [10.10.67.203])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3052B5D751;
 Mon,  4 Jan 2021 18:42:32 +0000 (UTC)
Message-ID: <22cd2b3e8b8b278f110a3540755583efee7189fd.camel@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
From: Qian Cai <qcai@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Date: Mon, 04 Jan 2021 13:42:31 -0500
In-Reply-To: <f7b97771ed29c7630f678a8939a591dd@kernel.org>
References: <20201210083059.1277162-1-maz@kernel.org>
 <703e1b5f2db1631e8f9c55619909fe66eb069f25.camel@redhat.com>
 <579c839a0016107af66e704f147f9814@kernel.org>
 <f4300d00b9d2540bf90a6b1baadf030a2e4c92ed.camel@redhat.com>
 <bd725a533e4754b0d5634574bcab4b0d@kernel.org>
 <a0fcd5a4a595deddd990a6327568c82a1e94948a.camel@redhat.com>
 <f7b97771ed29c7630f678a8939a591dd@kernel.org>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:06:19 -0500
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>, kernel-team@android.com,
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

On Mon, 2021-01-04 at 18:26 +0000, Marc Zyngier wrote:
> What I'm suggesting is this [1], which is to get rid of KVM_ARM_PMU
> completely. At least, the kernel configuration will be consistent.
> 

Do you have a patch for CONFIG_KVM to select HW_PERF_EVENTS then? I could cook
one if not.

> Overall, I think there is an issue with KVM exposing more than it
> should to userspace when no PMU is defined, but I don't think that's
> the problem you are seeing.
> 
>          M.
> 
> [1] https://lore.kernel.org/r/20210104172723.2014324-1-maz@kernel.org

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
