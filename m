Return-Path: <SRS0=FDwM=5C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DDEC1975A
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 22:27:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2EAC206EC
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 22:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuSZmRfj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2EAC206EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FC734A51E;
	Tue, 17 Mar 2020 18:27:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id urAJFmFGaB4t; Tue, 17 Mar 2020 18:27:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B374B080;
	Tue, 17 Mar 2020 18:27:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 403084A51E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 18:27:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cvG9R2YDulon for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2020 18:27:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 708DF4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 18:27:02 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9F310206EC;
 Tue, 17 Mar 2020 22:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584484021;
 bh=feXoVNdYfrV4TFKhykYHVASYD8nshaCB8LWcN1l/eP0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=OuSZmRfjKjT3bppoNPLTNL8hxyiP67j2pV1bJszZfFXsz6kepBPj0ffTfi3CAMdhX
 PT18tvPVppBBRLf9c8jRrZiCyLQShrtjUtDVfD3YSbrLvSbOX73h0e1ecdX6fk7g8Q
 jLcEb8O5V34blCKFSXRQG03gPImfHhSwjEX+lfPM=
Date: Tue, 17 Mar 2020 22:26:56 +0000
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Subject: Re: [PATCH] arm64: move kimage_vaddr to .rodata
Message-ID: <20200317222656.GE20788@willie-the-truck>
References: <20200312094002.153302-1-remi@remlab.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200312094002.153302-1-remi@remlab.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Mar 12, 2020 at 11:40:02AM +0200, R=E9mi Denis-Courmont wrote:
> From: Remi Denis-Courmont <remi.denis.courmont@huawei.com>
> =

> This datum is not referenced from .idmap.text: it does not need to be
> mapped in idmap. Lets move it to .rodata as it is never written to after
> early boot of the primary CPU.
> (Maybe .data.ro_after_init would be cleaner though?)
> =

> Signed-off-by: R=E9mi Denis-Courmont <remi@remlab.net>
> ---
>  arch/arm64/kernel/head.S | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> =

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 6e08ee2b4d55..8e5c0e0040e4 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -457,17 +457,19 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>  	b	start_kernel
>  SYM_FUNC_END(__primary_switched)
>  =

> +	.pushsection ".rodata", "a"
> +SYM_DATA_START(kimage_vaddr)
> +	.quad		_text - TEXT_OFFSET
> +SYM_DATA_END(kimage_vaddr)
> +EXPORT_SYMBOL(kimage_vaddr)
> +	.popsection
> +
>  /*
>   * end early head section, begin head code that is also used for
>   * hotplug and needs to have the same protections as the text region
>   */
>  	.section ".idmap.text","awx"
>  =

> -SYM_DATA_START(kimage_vaddr)
> -	.quad		_text - TEXT_OFFSET
> -SYM_DATA_END(kimage_vaddr)
> -EXPORT_SYMBOL(kimage_vaddr)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
