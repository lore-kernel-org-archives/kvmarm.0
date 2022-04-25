Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA9CC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 16:53:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ABB64B285;
	Mon, 25 Apr 2022 12:53:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b31MH07juu73; Mon, 25 Apr 2022 12:53:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 547D54B262;
	Mon, 25 Apr 2022 12:53:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DDAD4B1F0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 12:53:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Flaaph-YIeyU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 12:53:33 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 459704B1E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 12:53:33 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id t25so27275969lfg.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 09:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=lFX89zd3C09/F/da+MWhhY/H7yp7bOfk0UUh8vYzbDA=;
 b=h3X062wr4reZNOSNqsPwBEA4pU1JtqQic1Pt+nu09PtSC3yZTlVycPw8uy6r2U/cF3
 RRUFxFfVe7Jw0whY9XTZ+PNcOBDgNu0LT/Dd/Fkr59rQHxDXX28IurmgMb9NK5E6bM2r
 4uodDhWSaI1ssO5e4Bv8EeF/h9u4Z7cy/cvXq8UyrSmpRQYo46OQxVynhXXIltvGjeCS
 Y2m78X7EQh24TvV73BrOpLWttDP1CB2UAVxi9/B65zAJqNNgV42vaKgYZrFwG3XlXvnM
 TbQSoyIOlip1PQAiSbwvhS3y/EigIi49W6S131QZWG4gKw3x0EPShexhX9hnOb3fJ2q8
 UxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lFX89zd3C09/F/da+MWhhY/H7yp7bOfk0UUh8vYzbDA=;
 b=gzjJlwX1dofJO4V0InR4i1ELUU9E5t7krNdrKSR4Jw2dOONw/cR7IyfFg/f0kJlOb3
 quGc+2jRZx7SXD8oq7k7NjpMLNsU34BDdv8ElsIkU62DFC+SifWrPCgHmBEu2Px1YK01
 V4DS9qUPlnKaUpFiF50zcsb2hL1qtGPYf2xIQYuhrkeK105klK5U+/UyJJYdy4XVeXsV
 lfozpyP71noedjC5sTsb0/OGGagi2jUsK/CtI7aUZR91G+wwxC0zScnM/8uP7ucOsbpP
 D8YehKI5sz3lR79sIaGuRLkgoxMWTDWmjfTQGBiepzTSFHtUfEXMMFHQbdbarENrrFjk
 Blxg==
X-Gm-Message-State: AOAM531Hyt7YaQdl6oPgYp05n27KvnkX64Wr2Cv0YS4IEYS8RrFKLhZ3
 3B6iIzTSxKaWmxZeygCUhyQmkR+GtT11kTW5gdijWQ==
X-Google-Smtp-Source: ABdhPJxm0hhBPf1OejlR39+65w6wi69xjDsU+RXUC7QhOXAMerhUh52wj0ODeBwvmUu+3x+HKLKmoPD+gqYXCSdbxjU=
X-Received: by 2002:a05:6512:131b:b0:44b:75d:e3d0 with SMTP id
 x27-20020a056512131b00b0044b075de3d0mr13469528lfu.685.1650905611670; Mon, 25
 Apr 2022 09:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
 <Yma6fEoRstvmu6sd@google.com>
In-Reply-To: <Yma6fEoRstvmu6sd@google.com>
From: Oliver Upton <oupton@google.com>
Date: Mon, 25 Apr 2022 09:53:20 -0700
Message-ID: <CAOQ_QshYttK+e9PQdp+vZo2w7NN8oGVAQm8LC+DBP5gs+5fLwA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Mon, Apr 25, 2022 at 8:13 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 15, 2022, Oliver Upton wrote:
> > The ARM architecture requires that software use the 'break-before-make'
> > sequence whenever memory is being remapped.
>
> What does "remapped" mean here?  Changing the pfn?  Promoting/demoting to/from a
> huge page?

Both, but in the case of this series it is mostly concerned with
promotion/demotion. I'll make this language a bit more precise next
time around.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
