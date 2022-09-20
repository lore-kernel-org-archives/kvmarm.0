Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA24DC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 08:20:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60F5E4B642;
	Tue, 20 Sep 2022 04:20:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g1JH4LVEDNTn; Tue, 20 Sep 2022 04:20:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AE904B632;
	Tue, 20 Sep 2022 04:20:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FA04B62B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:20:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XzJIYLO8YZiu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 04:20:26 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 463114B601
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:20:26 -0400 (EDT)
Date: Tue, 20 Sep 2022 10:20:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663662025;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Z+D/+XqPkHPpeUPcy8FHBpV6Iy+MSnvu8mZYQhUXgXw=;
 b=hS3i/5/nKeFMwqqAkVMDwys7TeNml4OZeQ5IUT4tKLWPcQgSqaINr78QoqWAYLgjrtSIkx
 S8zUqjH1p05fi9agLYWv8FsdEc0eq/6DUev1Ih+vpR+Xiv9FHqDLOFbhusndXp+bK4BU42
 /VLv3OriAy/dEQDXBSZfpxy5YUM42ig=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 02/19] lib/alloc_phys: Initialize
 align_min
Message-ID: <20220920082023.76ckpfqox4s76vw4@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-3-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Aug 09, 2022 at 10:15:41AM +0100, Alexandru Elisei wrote:
> Commit 11c4715fbf87 ("alloc: implement free") changed align_min from a
> static variable to a field for the alloc_ops struct and carried over the
> initializer value of DEFAULT_MINIMUM_ALIGNMENT.
> 
> Commit 7e3e823b78c0 ("lib/alloc.h: remove align_min from struct
> alloc_ops") removed the align_min field and changed it back to a static
> variable, but missed initializing it.
> 
> Initialize align_min to DEFAULT_MINIMUM_ALIGNMENT, as it was intended.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_phys.c | 7 +++----
>  lib/alloc_phys.h | 2 --
>  2 files changed, 3 insertions(+), 6 deletions(-)

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
