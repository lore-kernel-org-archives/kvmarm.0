Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CF0C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 26 Oct 2022 10:02:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABE7E40BD9;
	Wed, 26 Oct 2022 06:02:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U64OFJspcmxF; Wed, 26 Oct 2022 06:02:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F12D40801;
	Wed, 26 Oct 2022 06:02:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D4214079D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2022 06:02:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tQdPtX9Hux9z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Oct 2022 06:02:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D2F4012A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2022 06:02:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 101F923A;
 Wed, 26 Oct 2022 03:02:10 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA7133F792;
 Wed, 26 Oct 2022 03:02:02 -0700 (PDT)
Date: Wed, 26 Oct 2022 11:03:11 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Message-ID: <Y1kFzXzSBOurVnYM@monolith.localdoman>
References: <20221025160730.40846-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221025160730.40846-1-cohuck@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>
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

Hi,

On Tue, Oct 25, 2022 at 06:07:30PM +0200, Cornelia Huck wrote:
> KVM/arm64 development is moving to a new mailing list (see
> https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
> kvm-unit-tests should advertise the new list as well.

Indeed, this change is present in Linux since commit ac107abef197 ("KVM:
arm64: Advertise new kvmarm mailing list"):

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
