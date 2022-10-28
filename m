Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39551C38A02
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 12:54:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A795E40431;
	Fri, 28 Oct 2022 08:54:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZmeCfjxVHekc; Fri, 28 Oct 2022 08:54:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB3F4141A;
	Fri, 28 Oct 2022 08:54:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55CCA405C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 08:54:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V1EmBCoc9MVL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 08:54:21 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE1BD40431
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 08:54:21 -0400 (EDT)
Date: Fri, 28 Oct 2022 14:54:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666961660;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=faBEUID8ecAxojrzIEDsR5vvjyAZdIaTRru7O3n6MSA=;
 b=HzQId8h+ivqZDyADgQ+r39KPBFNZme6jQ4lv3E/pippXUK9I/6TnboHl9U/bux6+UPHkDM
 K4YpxCCM/vvqXNZvl++r0upMO4ITfbA18qUZlMKBXK1Rleiymof6s7YZdvuKhhPknLselO
 O2Q8QINKo8V4n8hprlLlht7ma1NUeoI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Message-ID: <20221028125419.6cfeokgtm7ycifpt@kamzik>
References: <20221025160730.40846-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221025160730.40846-1-cohuck@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Oct 25, 2022 at 06:07:30PM +0200, Cornelia Huck wrote:
> KVM/arm64 development is moving to a new mailing list (see
> https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
> kvm-unit-tests should advertise the new list as well.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90ead214a75d..649de509a511 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -67,7 +67,8 @@ ARM
>  M: Andrew Jones <andrew.jones@linux.dev>
>  S: Supported
>  L: kvm@vger.kernel.org
> -L: kvmarm@lists.cs.columbia.edu
> +L: kvmarm@lists.linux.dev
> +L: kvmarm@lists.cs.columbia.edu (deprecated)
>  F: arm/
>  F: lib/arm/
>  F: lib/arm64/
> -- 
> 2.37.3
>

Pushed, thanks!

drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
