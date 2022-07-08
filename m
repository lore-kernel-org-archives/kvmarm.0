Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD355CCA47B
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 09:43:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E3804BB84;
	Mon, 11 Jul 2022 05:43:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TayW2wrBIs31; Mon, 11 Jul 2022 05:42:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B284BB34;
	Mon, 11 Jul 2022 05:42:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB04E4B569
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 15:33:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BxoEvDPcdXjb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 15:33:56 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C85264B531
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 15:33:56 -0400 (EDT)
Date: Fri, 8 Jul 2022 12:33:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657308835;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UvsXJEG9CqDhZlAkduXKwdOpQV4TuAtiKD98aN6QoR4=;
 b=MOIeH5Qx8XM9bKH7gcUX6UVc0q9d9VoT4qCEl+P/TkisvUkENUSmfb0ItDEnLaAeBzvdCv
 hTtvWEHy/DPDX/iPBJ3eDLJtOpQsuuCvTjAIjkKlmOvEVTep+M6iBb9cxI9rZlRAm0vAQx
 Qz7ZhcPUnCWYSu8Jyzv2V7DQrA4t8N0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 05/19] KVM: arm64: Consolidate sysreg userspace accesses
Message-ID: <YsiGnbQpWU1cl0bl@google.com>
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220706164304.1582687-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Mon, 11 Jul 2022 05:42:55 -0400
Cc: kvm@vger.kernel.org, kernel-team@android.com, Schspa Shi <schspa@gmail.com>,
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

Hi Marc,

On Wed, Jul 06, 2022 at 05:42:50PM +0100, Marc Zyngier wrote:
> Until now, the .set_user and .get_user callbacks have to implement
> (directly or not) the userspace memory accesses. Although this gives
> us maximem flexibility, this is also a maintenance burden, making it

typo: maximum

> hard to audit, and I'd feel much better if it was all located in
> a single place.
> 
> So let's do just that, simplifying most of the function signatures
> in the process (the callbacks are now only concerned with the
> data itself, and not with userspace).

Much cleaner!

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
