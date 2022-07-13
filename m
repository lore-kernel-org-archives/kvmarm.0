Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A261C43334
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jul 2022 06:46:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 870CB4BDFC;
	Wed, 13 Jul 2022 02:46:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gb-T9MWWBNM6; Wed, 13 Jul 2022 02:46:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6913D4BE10;
	Wed, 13 Jul 2022 02:46:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 075FA4BDF1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 02:46:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ae1LI5JuNkPS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2022 02:46:08 -0400 (EDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com
 [209.85.217.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08F7C4BDF0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 02:46:07 -0400 (EDT)
Received: by mail-vs1-f45.google.com with SMTP id k2so9907980vsc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 23:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=eVhC/3eC5T+uVY5zCPqJvEHAiZQx991cN+OGRmvdPJ4=;
 b=R2tlFJo7b92QRtPKgzqkJ7RZkVZ64HxIrmYSKOcn98ummWgwZOep3MNQ0ANWNxgsX4
 CLmUFuc8SccnfpSjG2SJKnWsNnr+se/++AM4yV37ysq65KpqkBSFtELhmuw4rX0tC8ka
 HSOX8qtjeirynX7RSruFMax3bZARnKRfpATEDI6W7DTENR7y8mb+lIuh13N8/j59Ip09
 VvxTSs18jQhoGAcQY5F3N9Sp4gMQLx8d6EzCfLg0JE2brKOUhMFa3I9G6kuIUz2rX69N
 DMPBxWfgxvGBXL8fbBZnLw9tmjGp+PPM+ReRly+sBKcwoRmqWs3b5Uy5fuCYCtHYD9ne
 8PoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=eVhC/3eC5T+uVY5zCPqJvEHAiZQx991cN+OGRmvdPJ4=;
 b=qOi+QTie9gXiJpZbxSE64S2whf3ddpIfHCWIvOjOe+ohbGHMOTug7D+UfqhWelxXJg
 9VAexzXOv361al6qJ4AWYiC0hnee0McanX7deRlxMTTZCjzWwJUj/0L/IaN+e4+zdWMR
 d5SiDPYkdEDb3YUKugW3SBYU3xFmYpP4wvKU0Bd9PN46ecLy68XEbcWRSRHmDvcaFiOL
 fVzhiJj0kjrTmj+A3amT8lJWRethq4YoY37xj4utNO08QvXNfOQ24N1ILLIGy5A0NGQj
 MGbE5SAvIad1x0GPjCZoYFz4OiU2x/zX2z3yHlPeG6+yhLt0kLsafZ2VaXqk1cRgnL0N
 SHAA==
X-Gm-Message-State: AJIora9Zh2F+ZZBE0Or0fzwzSAT0jVx2LhgekdgQNOxZ/dMOE6pHXEWZ
 5yVHH+L6VzrJzVZIep1GCE/8PhXOfMVvdqQk+cOAMA==
X-Google-Smtp-Source: AGRyM1vAIc+192gcPmhZ/OUxmzIY9hA9We6tz01rgpw9y2ihdWpQBLwpMt1VyVjBA74EqAPZkTaTemOlXd0RKxVwCxk=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr522722vsh.9.1657694767428; Tue, 12 Jul
 2022 23:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-12-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-12-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 12 Jul 2022 23:45:51 -0700
Message-ID: <CAAeT=FwQtdDY6RAnjx=gJjghvZwF8ud_dCu+ymcKiHD6fm2-Sg@mail.gmail.com>
Subject: Re: [PATCH 11/19] KVM: arm64: vgic-v3: Use u32 to manage the line
 level from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Despite the userspace ABI clearly defining the bits dealt with by
> KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO as a __u32, the kernel uses a u64.
>
> Use a u32 to match the userspace ABI, which will subsequently lead
> to some simplifications.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
