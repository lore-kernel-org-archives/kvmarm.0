Return-Path: <SRS0=evlJ=6L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2A0C54FD0
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 07:28:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4DF32051A
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 07:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QM/66+JX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4DF32051A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B88B4B12C;
	Mon, 27 Apr 2020 03:28:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GjWOoKdyJhYt; Mon, 27 Apr 2020 03:28:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 197404B11B;
	Mon, 27 Apr 2020 03:28:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5194B11D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 03:28:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id puSOSsEJYOfS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2020 03:28:36 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 507334B11B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 03:28:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587972516;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fhbDo34NJp8lf0z2mD+gxz78VWyhT6vzLSI7DIn5U0k=;
 b=QM/66+JXXbkP5SECyuyUPGIREMTF9itLCIoqLm/iEeYJugk3Nda9iocJdQR1eKaGNfBxts
 mhx0exD3qILJM4n8AaMvRatvnENmr53orpoK2EoJq95LLF3ui+FjDfmn5D5us2i9TLOqQq
 O/466iCtsy0a8eqQoq6En5rtKpl9VaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-xE9ys-BJNemCctbaqWDaxQ-1; Mon, 27 Apr 2020 03:28:33 -0400
X-MC-Unique: xE9ys-BJNemCctbaqWDaxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73EC11895A28;
 Mon, 27 Apr 2020 07:28:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.184])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D76A95C1D4;
 Mon, 27 Apr 2020 07:28:28 +0000 (UTC)
Date: Mon, 27 Apr 2020 09:28:25 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Save/restore sp_el0 as part of __guest_enter
Message-ID: <20200427072825.ekcekll6f23bt2um@kamzik.brq.redhat.com>
References: <20200425094321.162752-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200425094321.162752-1-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Sat, Apr 25, 2020 at 10:43:21AM +0100, Marc Zyngier wrote:
> We currently save/restore sp_el0 in C code. This is a bit unsafe,
> as a lot of the C code expects 'current' to be accessible from
> there (and the opportunity to run kernel code in HYP is specially
> great with VHE).
> 
> Instead, let's move the save/restore of sp_el0 to the assembly
> code (in __guest_enter), making sure that sp_el0 is correct
> very early on when we exit the guest, and is preserved as long
> as possible to its host value when we enter the guest.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/entry.S     | 23 +++++++++++++++++++++++
>  arch/arm64/kvm/hyp/sysreg-sr.c | 17 +++--------------
>  2 files changed, 26 insertions(+), 14 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
