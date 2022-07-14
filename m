Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE6DC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 05:09:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BB654BF45;
	Thu, 14 Jul 2022 01:09:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HGjpfMRlZoWh; Thu, 14 Jul 2022 01:09:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49AC74C532;
	Thu, 14 Jul 2022 01:09:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AD7D4BF45
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 01:09:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LxxWtWdmH+9C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 01:09:48 -0400 (EDT)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com
 [209.85.221.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 667754C45C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 01:09:48 -0400 (EDT)
Received: by mail-vk1-f173.google.com with SMTP id 7so354677vkq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 22:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Fsrr+gGbZwzMH7jOD09M+zhp8VpQAXoxnBERZRz043w=;
 b=R9QMloUW97dlMzqvqBMdu5BzycJJfAIi9YfpP/b6Xrr8QjFxwTF/8HB0KqeOo6v04R
 w7HO9IK80OAqJ+Q5pPo0QMrSHC4DGIOVBmy3+0Xe4jV0O8pZ1X+7iFiA9gX7BF7zQ5og
 fGJPxiEhqa9woCVvbKKVbF9qbDBeRaHsXiwnwInY7TJUD3IYbal4L4sqLZOwfSKzV4JF
 g23WQ80aySnRAhT4tjwwPkHoX6eZagczZnI6qVJeHUnEFBqbi0gZl6ORyRwwxDvWkaBQ
 87NlW2Ct3I3zqnr1LTxpiTICcbGtS5MWazvYSqryx2v3PZL0fKH8qoBySFjHEMvtMODR
 +3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Fsrr+gGbZwzMH7jOD09M+zhp8VpQAXoxnBERZRz043w=;
 b=QR4accJ5Vi4ZSHwCZ9gUuYbhe6MRPm3F7hCxV5drR9ObrKa1bx0VaMTj3pWGebuHAD
 ZfjnH1BPo3znk32ipYfrAwtdxBoqHti3wgkV6NzONdxoEEG13Qt3t/U1pEB2TEiptS8y
 torBh+CZSVcFRzfxC6+VIQFxddijkUi4g1ZttKMUiqKY9dMsYNXSIZSuCkVfCK3p5xET
 IBMzULNVYQkwrZbQzcGYVUIzvdKVSkc50m8kWNeljQXQXC8rBunG2nkOq84H9iJeniIa
 Hk9ZNesVemoaMYkEi1Jz0uEO8c++st96HsA0xXAQVonP+s1hdAzauFOVwQeN+9GKMN2q
 wNOA==
X-Gm-Message-State: AJIora/0QFPlJ5lV0W7Ddxdj6Q5Y3+RvP8SXPq/0n9ivnsYDkkSdREcM
 GCZNMuEBoHK89HNcauEKu3vGSFwyz7zc6NXTRcqHmg==
X-Google-Smtp-Source: AGRyM1ujr+x3P8BbldksoSQM5WjDbOY9ekZm+G5kDa0z8Iat+dMt+QF297TxCTU1laSAmRRP9Z+DkyVxudLubmdxBfY=
X-Received: by 2002:a1f:4941:0:b0:373:fffa:730b with SMTP id
 w62-20020a1f4941000000b00373fffa730bmr2819925vka.7.1657775387870; Wed, 13 Jul
 2022 22:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-15-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-15-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 13 Jul 2022 22:09:32 -0700
Message-ID: <CAAeT=Fxar0wfaD-ye958qZy7=vON1R_zhef0RSPH_1VwO6gWPg@mail.gmail.com>
Subject: Re: [PATCH 14/19] KVM: arm64: vgic: Use {get,
 put}_user() instead of copy_{from.to}_user
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
> Tidy-up vgic_get_common_attr() and vgic_set_common_attr() to use
> {get,put}_user() instead of the more complex (and less type-safe)
> copy_{from,to}_user().
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
