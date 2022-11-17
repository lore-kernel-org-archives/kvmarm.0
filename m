Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76924C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 07:08:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE4E4B7A7;
	Thu, 17 Nov 2022 02:08:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 81bE+EyTiJ0Z; Thu, 17 Nov 2022 02:08:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D00204B808;
	Thu, 17 Nov 2022 02:08:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E440E4B7A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 02:08:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nPQ8XaddNG90 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 02:08:11 -0500 (EST)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A457D4B823
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 02:08:11 -0500 (EST)
Received: by mail-pg1-f178.google.com with SMTP id v3so1212775pgh.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 23:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=UAu7Qq9urA/2CACA9Hh+1UR/gyDzRKpeK8exN8pGRGc=;
 b=tPom7jgm4aEV3UcuTrtkJ9WXPYx1xLs3GpHHDkKphwOmPBFKz+yATUKMk1dUX4Czj4
 9m5Z41vo7tXTj7X4CpnPP4xffZ3+eD1hoPOupmGXTUhfpccza0/QJojWLXRBN+MxesBW
 KZEcXnv6FIphs/mg4YlCNzY7DHdrlS6QVeSkGZLMgoDsYR++Us4LGtpvqaXaj5+hqdNN
 2LA9sydaeL6d283yzEM9HnUJWbNrbdbNUZkXH08AuHtpCWvJHy7hE6HSL3aJJbCpXFwI
 UD0QHIiRDU2+sHuipLJUXt8zTOxvp7n2MWM0ecdjFJKRG+6u2eNgX+75bjq4NKrmPGEK
 wCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=UAu7Qq9urA/2CACA9Hh+1UR/gyDzRKpeK8exN8pGRGc=;
 b=YNVvWpP+LIeZWKVGDXmVbpLuRpvbqA2FHI6c+eQc4oJA4IdUkEhETXIHaOwc7QBioB
 sbNyUNKG+5sOnVuy5PhiBEEx8DTEtfbi/gxgD+s9ilU0F/mPybQu6/h/jnTQ38Etu1OQ
 NeRb3TOefssOZTvJTdDD2FZmNqtSCRbONGGJljRHwEXoua2zSn6tX6aRxSek+p+oo+pY
 7DLV1o0c2I+yBulstsxNy5uhc8a5sNbj5AYTRogZnyQFgfafuF9iZKeEtb5W3C9Ytpj7
 Hn7qI0SUedIVH5/Wktk437mA0sr/UddhxNL/9q2ylr8uvAAOLujE9bQE9xOf+NflK9n0
 EG8g==
X-Gm-Message-State: ANoB5pkDtYRmiBSrrXMz2Vy4lpc2ywhHgBGSwqjX7KV03MFu46obQx0J
 6i0qv9WUUSGP8xiQDsMJIPwTTsaHMoipa31lrxs/TA==
X-Google-Smtp-Source: AA0mqf6FeRrcOYfgd5QoCZHb7tiY6I/edy2aB82zFoI+g9lRRZuamw4/hvEK8BIr963Kkgm7Yq/eSFkC85iYBhQeVzw=
X-Received: by 2002:aa7:80d8:0:b0:56d:98e3:4df8 with SMTP id
 a24-20020aa780d8000000b0056d98e34df8mr1695579pfn.37.1668668890570; Wed, 16
 Nov 2022 23:08:10 -0800 (PST)
MIME-Version: 1.0
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
In-Reply-To: <20221117002350.2178351-3-seanjc@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 23:07:53 -0800
Message-ID: <CAAeT=FyKq8oeer7b0McUkGRbvmUPH4+hLnWPKZmGQ3uWgkUNcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Wed, Nov 16, 2022 at 4:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Automatically disable single-step when the guest reaches the end of the
> verified section instead of using an explicit ucall() to ask userspace to
> disable single-step.  An upcoming change to implement a pool-based scheme
> for ucall() will add an atomic operation (bit test and set) in the guest
> ucall code, and if the compiler generate "old school" atomics, e.g.
>
>   40e57c:       c85f7c20        ldxr    x0, [x1]
>   40e580:       aa100011        orr     x17, x0, x16
>   40e584:       c80ffc31        stlxr   w15, x17, [x1]
>   40e588:       35ffffaf        cbnz    w15, 40e57c <__aarch64_ldset8_sync+0x1c>
>
> the guest will hang as the local exclusive monitor is reset by eret,
> i.e. the stlxr will always fail due to the VM-Exit for the debug
> exception.
>
> Link: https://lore.kernel.org/all/20221006003409.649993-8-seanjc@google.com
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
