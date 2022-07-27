Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48E3C04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 16:01:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4814C91C;
	Wed, 27 Jul 2022 12:01:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FUMoaT4KEO4e; Wed, 27 Jul 2022 12:01:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDAF94C90E;
	Wed, 27 Jul 2022 12:01:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 684D14C90E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 12:01:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UhHrfyRkIXzM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 12:01:42 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBFF94C90D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 12:01:42 -0400 (EDT)
Date: Wed, 27 Jul 2022 16:01:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658937701;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=MIVHqmVT6XDFh0scJsMUAJJN5QiOkyZcHL6zatK40GI=;
 b=pf/jpd6W/zgUqZ06ofNtfuD9HllnMfiRTormw96GjNDkX8MLvy4eJcvM8Y4ku1aua8lnO4
 iwhIu9WoGeJfUXN/v2RTQGVLgabWVUnlsDf+fhkcFiJp5cNv22CZIG3FBbQteS3NCtAXIa
 BB7xDgLzFurRCGkyTWkMnIC+rZ74rqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/6] KVM: arm64: nVHE stack unwinder rework
Message-ID: <YuFhWu78i7EpcG/a@google.com>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, kvmarm@lists.cs.columbia.edu,
 madvenka@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, elver@google.com, broonie@kernel.org,
 andreyknvl@gmail.com, mhiramat@kernel.org
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

On Wed, Jul 27, 2022 at 03:29:00PM +0100, Marc Zyngier wrote:
> Hi all,
> 
> As Kalesh's series[1] already went through quite a few rounds and that
> it has proved to be an extremely useful debugging help, I'd like to
> queue it for 5.20.
> 
> However, there is a couple of nits that I'd like to address:
> 
> - the code is extremely hard to follow, due to the include maze and
>   the various levels of inline functions that have forward
>   declarations...
> 
> - there is a subtle bug in the way the kernel on_accessible_stack()
>   helper has been rewritten
> 
> - the config symbol for the protected unwinder is oddly placed
> 
> Instead of going for another round and missing the merge window, I
> propose to stash the following patches on top, which IMHO result in
> something much more readable.
> 
> This series directly applies on top of Kalesh's.
> 
> [1] https://lore.kernel.org/r/20220726073750.3219117-1-kaleshsingh@google.com

For the series (besides my own patch of course):

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
