Return-Path: <SRS0=pEf/=D2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CB8C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 09:25:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31D3022200
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 09:25:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itjxMV7y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31D3022200
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5C34B560;
	Mon, 19 Oct 2020 05:25:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XKNCpjwj5omc; Mon, 19 Oct 2020 05:25:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 417834B56F;
	Mon, 19 Oct 2020 05:25:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47C9B4B560
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 05:25:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hHUm-Bkdki56 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2020 05:25:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35CFE4B54B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 05:25:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603099533;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=S8Vq1Ap8SBigkU/8LGMXA2a9BrKy83dFwogd18gdHco=;
 b=itjxMV7yghLgIRICKcso5SEst/X51s5AlXHYACEswT438Dl8164UK4CpGsoS5Jpy/HTVk6
 2Dik1H8Q06QNmy7WKWo+14c/ZFf1SFW0Fw2GhdC1RA4SzswmnFfn9ezrnd/xXPKUmhnGjo
 2chJyyIKRgLspgqPMA64gvLMqe/RTCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-2BZvLv5HObiGgA1Gim2UDA-1; Mon, 19 Oct 2020 05:25:32 -0400
X-MC-Unique: 2BZvLv5HObiGgA1Gim2UDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F888800462;
 Mon, 19 Oct 2020 09:25:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.206])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F4C86EF46;
 Mon, 19 Oct 2020 09:25:28 +0000 (UTC)
Date: Mon, 19 Oct 2020 11:25:25 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: Kernel patch cases qemu live migration failed.
Message-ID: <20201019092525.ekvgbcwwtm63pueu@kamzik.brq.redhat.com>
References: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
 <7fecfc67da4caab1d677a8b4cd5386b3@kernel.org>
 <20201015133505.ubxvbrt6xyvl4362@kamzik.brq.redhat.com>
 <16400df4bdf79b8b22e824eb1a20e2b4@kernel.org>
 <20201015144104.ytwzpxjlsgyun3ob@kamzik.brq.redhat.com>
 <CAFEAcA-LBmbjp-Teb35f=O-1QtMLd8bAuq5XaCz9URdQZ1jxow@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-LBmbjp-Teb35f=O-1QtMLd8bAuq5XaCz9URdQZ1jxow@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, xu910121@sina.com,
 qemu-devel <qemu-devel@nongnu.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Dave.Martin" <dave.martin@arm.com>
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

On Thu, Oct 15, 2020 at 03:57:02PM +0100, Peter Maydell wrote:
> On Thu, 15 Oct 2020 at 15:41, Andrew Jones <drjones@redhat.com> wrote:
> > The reporter states neither the source nor destination hardware supports
> > SVE. My guess is that what's happening is the reserved ID register
> > ID_UNALLOCATED(4,4) was showing up in the KVM_GET_REG_LIST count on
> > the old kernel, but the new kernel filters it out. Maybe it is a
> > bug to filter it out of the count, as it's a reserved ID register and
> > I suppose the other reserved ID registers are still showing up?
> 
> Yeah, RES0 ID registers should show up in the list, because otherwise
> userspace has to annoyingly special case them when the architecture
> eventually defines behaviour for them.
> 
> Dave's comment in the kernel commit message
> # ID_AA64ZFR0_EL1 is RO-RAZ for MRS/MSR when SVE is disabled for the
> # guest, but for compatibility with non-SVE aware KVM implementations
> # the register should not be enumerated at all for KVM_GET_REG_LIST
> # in this case.
> seems wrong to me -- for compatibility the register should remain
> present and behave as RAZ/WI if SVE is disabled in the guest,
> the same way it was before the kernel/KVM knew about SVE at all.

Yup, I agree with you and I'll try writing a patch for this.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
