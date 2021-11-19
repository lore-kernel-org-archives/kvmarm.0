Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA0CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 11:26:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B90B61A52
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 11:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8B90B61A52
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ED154B11B;
	Fri, 19 Nov 2021 06:26:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dVtAEj21dB83; Fri, 19 Nov 2021 06:26:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D32A4B116;
	Fri, 19 Nov 2021 06:26:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73CE44B10D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 06:26:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W1JtoKlLEDrG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 06:26:33 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81A3F4B093
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 06:26:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637321193;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ur6jyg8LpW6xWlgk/Y4mQFrqjPeSvFG+Pwu0kvvPhXs=;
 b=O3NezYC4KDFxmdPO0R7vOeynTu7b2QObuPWv07plrdhWinHi/AM4wUNw95FAuXU7my7NHk
 Il0YNz6mm7/ssH7NxnEgX22V0+JjfABRBs/EpuUY1XcODpvSEW+XTOWxcSi1D2d5TqEefS
 kX5U6hxnjBXzM+6NiU0Ij7iS4+63uDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-CDXegAY1OE6UozhJaY8iTA-1; Fri, 19 Nov 2021 06:26:30 -0500
X-MC-Unique: CDXegAY1OE6UozhJaY8iTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86E8410247A6;
 Fri, 19 Nov 2021 11:26:28 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F37DF5C3E0;
 Fri, 19 Nov 2021 11:26:27 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id 65F894172ED4; Fri, 19 Nov 2021 08:26:24 -0300 (-03)
Date: Fri, 19 Nov 2021 08:26:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: [RFC PATCH 1/2] arm64/tracing: add cntvct based trace clock
Message-ID: <20211119112624.GA51423@fuller.cnet>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
 <20211119102117.22304-2-nsaenzju@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211119102117.22304-2-nsaenzju@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: will@kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, mingo@redhat.com, catalin.marinas@arm.com,
 nilal@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Nov 19, 2021 at 11:21:17AM +0100, Nicolas Saenz Julienne wrote:
> Add a new arm64-specific trace clock using the cntvct register, similar
> to x64-tsc. This gives us:
>  - A clock that is relatively fast (1GHz on armv8.6, 1-50MHz otherwise),
>    monotonic, and resilient to low power modes.
>  - It can be used to correlate events across cpus as well as across
>    hypervisor and guests.
> 
> By using arch_timer_read_counter() we make sure that armv8.6 cpus use
> the less expensive CNTVCTSS_EL0, which cannot be accessed speculatively.

Can this register be read by userspace ? (otherwise it won't be possible
to correlate userspace events).

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
