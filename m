Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DACC54EE9
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 21:02:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D0740B90;
	Thu, 22 Sep 2022 17:02:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZGFWulkNbo3A; Thu, 22 Sep 2022 17:02:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B96844B2B4;
	Thu, 22 Sep 2022 17:02:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 532CF49EDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:02:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t2cB5pAat0sH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 17:02:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EAA840B90
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:02:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663880525;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NrC2ybEc8JLdF17QEo6DYU80wCTIo9mOjzD9ZgdBMrA=;
 b=DKA/b2BALNJgIlR2Sv5Z04dY7oc/3nD5Z/9Bu97gEXt4uwbZg4Su6a+iafxVPYjSIZszwt
 RcXMuYKmb/AbIPtH+u0ktycB6qA3cfe8jnfpEmtaVaw10q4JGRnTvAQLGwUrKkswecq/m8
 yS3fTyKU7S3BMDOctnKUX25ioP9qnC0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-641-69rgULIfMY6Anku2EgbfBw-1; Thu, 22 Sep 2022 17:02:03 -0400
X-MC-Unique: 69rgULIfMY6Anku2EgbfBw-1
Received: by mail-qv1-f69.google.com with SMTP id
 oj15-20020a056214440f00b004ac6db57cacso7265551qvb.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=NrC2ybEc8JLdF17QEo6DYU80wCTIo9mOjzD9ZgdBMrA=;
 b=fDQzyJZCAEP9WLhtG+yL0IKgNkEtxou6puPGH5+oGst2FJ/aoqZ3yEcnucqPx/1ihd
 ltBtqAE4te3BfzZNM80bhqhukPr8TZBEZpgZ7rjXyFEocqWvI2DgFl/lOKi+DE0yWsek
 xgxPOYXejkQ3RjVV0Es6PCwSGoZYlhzbTqqgP0ncgBujP1W55F8G3TjeZfGU4M93Ui2t
 Z6me80djiSBIUVUtVTQBlfEz9YCSP0gcfU47fsWTnQMNgN1A8uFEL+9O7EGvVlTGRi40
 NtKOY+zcv2Sgn/VAPUpFUzum3JWM8OalqAJDoH8p/cfQEY1u1s9EoCtx6qcg5ZZaT6vi
 fqpw==
X-Gm-Message-State: ACrzQf2Jw9DUUoSMJ7RZ1nmArGpZdsTVdN5IPj/hqQD+B3opIcZJDQw/
 x6jCkluFFxPcbyScPh9p8sasmvT6cPZozIwy97kAX4+W0TN+c5CH3XHvdqigZTT8wyVWpP/RkT6
 OjBStzorVFZdDTn7FQ9035IDiI6Cfe6O/PzT4IFqq
X-Received: by 2002:a05:622a:1a02:b0:35b:bb29:fb86 with SMTP id
 f2-20020a05622a1a0200b0035bbb29fb86mr4456044qtb.456.1663880522920; 
 Thu, 22 Sep 2022 14:02:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5+1iThcdKlBWRMN91eVYVdq5u8pl0QboZdJPJJcUB5kQOeMbl+s3pRZ+jdrGDTGMyG59r4Mby7gltxhspCalI=
X-Received: by 2002:a05:622a:1a02:b0:35b:bb29:fb86 with SMTP id
 f2-20020a05622a1a0200b0035bbb29fb86mr4456007qtb.456.1663880522662; Thu, 22
 Sep 2022 14:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220919171843.2605597-1-maz@kernel.org>
In-Reply-To: <20220919171843.2605597-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 22 Sep 2022 23:01:51 +0200
Message-ID: <CABgObfYgUSQNa-4i6iP1Ai7Bs7YiBBsEni3vxQ1=r-okeNfkNQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.0, take #2
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

Pulled, thanks.

Paolo

On Mon, Sep 19, 2022 at 7:19 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's the last KVM/arm64 pull request for this cycle, with
> a small fix for pKVM and kmemleak.
>
> Please pull,
>
>         M.
>
> The following changes since commit 1c23f9e627a7b412978b4e852793c5e3c3efc555:
>
>   Linux 6.0-rc2 (2022-08-21 17:32:54 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-2
>
> for you to fetch changes up to 522c9a64c7049f50c7b1299741c13fac3f231cd4:
>
>   KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base (2022-09-19 17:59:48 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.0, take #2
>
> - Fix kmemleak usage in Protected KVM (again)
>
> ----------------------------------------------------------------
> Zenghui Yu (1):
>       KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base
>
>  arch/arm64/kvm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
