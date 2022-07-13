Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D206DC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jul 2022 05:51:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA894C004;
	Wed, 13 Jul 2022 01:51:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qyLHE022k1Bo; Wed, 13 Jul 2022 01:51:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8054BFE8;
	Wed, 13 Jul 2022 01:51:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 016954BFE4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 01:51:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8SmBoBtqVQuS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2022 01:51:41 -0400 (EDT)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com
 [209.85.217.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0ACC4BFA6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 01:51:41 -0400 (EDT)
Received: by mail-vs1-f47.google.com with SMTP id l190so9849406vsc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 22:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=V6DsLVB1Os/T467zl8XHHfVTC79R6u1QIg76nXthRf0=;
 b=X07y/aH0bERy3yMTWnhLUJfEU4C3NSMDvTZ2dqjIhvWFXrV5dn+isPnxxXf6wkY9EW
 Be45usNE+fO2CyTyVnM+8YL9iTkWOuR1dUeJ7u9M645jE4fgcP3ezP75uR+Jp9LaJ9xv
 P9fQjwoC69dhtrVRWBJHuki2xt6YhU0mQlaeruRXko32UKJfOY7GbC++VP9rhJZ8HMjI
 9ZHlNheUJu5x92W2EPuum6PxktoSelq/+SKK2NHiDoPsW/MmpM00ePiXQQUsAAmwOwjO
 FuEhU454w2bVLRbpT28sMpGXdmHOR6JAJhrltMOraKg+W41dIRomFpqqpjo8Aanh7z6R
 jK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=V6DsLVB1Os/T467zl8XHHfVTC79R6u1QIg76nXthRf0=;
 b=Uj5YZzj+XqDLq30EhosfNy3asA8jj2mhZHEevCjTHrJ4n7ZQeyMkfx0vrOiJp7EcBE
 XeHFt8d7LZEGu9yq1SldRTcAQivRVmUJAWY4/yE1PWdJ1P6Klv1u1JtT6b5t9nZyueZ7
 gZRoL3zrZScygwYcWo1l37CY6TsAuXEFhlO7HcDIjQc2VM/jyFVw8DqQjL28+RpmArSq
 SjozmM1ACZ/ICddukNhMKP4Yt4CANOOMFtL7K29WuZru5iNtBY/Rr22+ve9NyJJZBsR0
 ht8tZ2opXUrZqBGpgGYAHHhRMENdsW/Zh1KtlGzsdnrIMtwZw4vXrBRNOJEZn1Oy4lxG
 5VZg==
X-Gm-Message-State: AJIora8qqa2V+kmQDqgjV4WKar8XK+V/7qRkf6pHqLrhR03wXBtk7vEx
 tmOgjfveKfMaVIW5V9mfIgce75Pl5KpheSH5jmU1TA==
X-Google-Smtp-Source: AGRyM1vmw3DqET09DU69NtxLbHGCoiebSBcuxxz9079JWzLSn2pteanGKVgXbkE8PBhG6kBPfsnDc2/g7nxtlqiayyY=
X-Received: by 2002:a67:5c41:0:b0:356:20ab:2f29 with SMTP id
 q62-20020a675c41000000b0035620ab2f29mr502511vsb.63.1657691501271; Tue, 12 Jul
 2022 22:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-11-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-11-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 12 Jul 2022 22:51:25 -0700
Message-ID: <CAAeT=FwrHpyhHD3spc_e70uQCHoHwc-n80iMY30ypymgFEQ7QA@mail.gmail.com>
Subject: Re: [PATCH 10/19] KVM: arm64: vgic-v3: Convert userspace accessors
 over to FIELD_GET/FIELD_PREP
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
> The GICv3 userspace accessors are all about dealing with conversion
> between fields from architectural registers and internal representations.
>
> However, and owing to the age of this code, the accessors use
> a combination of shift/mask that is hard to read. It is nonetheless
> easy to make it better by using the FIELD_{GET,PREP} macros that solely
> rely on a mask.
>
> This results in somewhat nicer looking code, and is probably easier
> to maintain.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
