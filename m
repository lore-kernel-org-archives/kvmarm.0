Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B06C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:39:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E59361248
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5E59361248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1FE14B27B;
	Mon,  4 Oct 2021 05:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3nSwqEsGARbx; Mon,  4 Oct 2021 05:39:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B52494B1F2;
	Mon,  4 Oct 2021 05:39:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C05A64B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:39:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C5IM+3pD5RnF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 05:39:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A608F4B1E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:39:32 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 875C861248;
 Mon,  4 Oct 2021 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633340371;
 bh=ACHTWCiGRKZUussKStZLPz6zNs0ZnZlfOvpnSP7UEz0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZBuKwEx/5jekVA5HNDujvF+MpORB7ZNTwtrv6fNgQzbzm0pXDORAXXfledrfHQJXe
 aPqWYxuc8z5oDR704QfsCoTS5lM+q5fzkTWG6kttorq7k8R7DkNIn37H9Nf6dMSZL5
 jRou0a+c2SJ1h9Akgs0/TsNLeVdEpXqNWFjMFxdHEJCLHJ35GIMZa4TtT/jjMoRNxF
 Tx8auSM4QwLCyAm74JEnxYZ0+Pmrd//qa/aIyRTA4dz+3zQ5VVyv2Um5JW9bpOPOR/
 AgJumuMbuok5f6GqmITJykhmX9NTDCamwN/vsKHxQUAq6/f7LmlZ1KqE9tUwLXRlrc
 kjLjglefYoaog==
Date: Mon, 4 Oct 2021 10:39:26 +0100
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 0/2] A couple of EL2 refcounts fixes
Message-ID: <20211004093925.GA27173@willie-the-truck>
References: <20211004090328.540941-1-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211004090328.540941-1-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

On Mon, Oct 04, 2021 at 10:03:12AM +0100, Quentin Perret wrote:
> This addresses a couple of issues Will has found with the refcounting of
> page-tables at EL2. Patch 01 fixes a nasty bug, and probably wants to go
> in -stable. Patch 02 fixes a small inconsistency which made it harder to
> find refcount-related bugs at EL2.
> 
> Feedback welcome !

For both patches:

Acked-by: Will Deacon <will@kernel.org>

Thanks!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
