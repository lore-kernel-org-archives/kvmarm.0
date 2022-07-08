Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D23FC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 09:42:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1DC74B9AD;
	Mon, 11 Jul 2022 05:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mkC5rjoq0AF7; Mon, 11 Jul 2022 05:42:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B754B921;
	Mon, 11 Jul 2022 05:42:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 878904B604
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 14:59:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bk-djpNyoY+P for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 14:59:15 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 530334B603
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 14:59:15 -0400 (EDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657306753;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wj7N+bil9RLaGeoY6bi4vc0yDBSE8E8Ymrs5hXbP3dY=;
 b=HhzsD2NgWV3j8Wtf8ZDSilmZWsR+DtLpQ2OtYlu2x65RfE/gLbg0Uy/ztiFaz0YKdc8wf1
 bLh/h4AihQFihDmoX3wOoTkPxXW+oiUckLGusELd5BSoa/YU0WeeG3izkrfjLPbzt6EaIt
 TMsovi9sPGKqUl2eRdFCDmZPNXdjaWU=
Date: Fri, 08 Jul 2022 18:59:12 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: oliver.upton@linux.dev
Message-ID: <dd74ef488fc56512b65039329643b72e@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Use the bitmap API to allocate bitmaps
To: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>, "Marc Zyngier"
 <maz@kernel.org>, "James Morse" <james.morse@arm.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon"
 <will@kernel.org>
In-Reply-To: <a93d3e94be2003922c7e9652b57e96261cc47641.1656961792.git.christophe.jaillet@wanadoo.fr>
References: <a93d3e94be2003922c7e9652b57e96261cc47641.1656961792.git.christophe.jaillet@wanadoo.fr>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Mon, 11 Jul 2022 05:42:55 -0400
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

July 4, 2022 12:10 PM, "Christophe JAILLET" <christophe.jaillet@wanadoo.fr> wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> While at it, turn a bitmap_clear() into an equivalent bitmap_zero(). It is
> also less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
