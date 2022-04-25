Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37996C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 18:17:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3D3F49E32;
	Mon, 25 Apr 2022 14:17:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VtoOY+eGITtl; Mon, 25 Apr 2022 14:16:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 804D249F3C;
	Mon, 25 Apr 2022 14:16:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7FF240CDE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:16:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3NzSq+FDJXHi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 14:16:57 -0400 (EDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6C2640C58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:16:57 -0400 (EDT)
Received: by mail-pj1-f46.google.com with SMTP id iq10so2610200pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cJX4NOJxx8yt8bifaIIJHW1REW326f1qVXuNvHoJSGg=;
 b=F3Hg1J94deTs8D8c5x1mAeV7ldoQpgW1s6cQYtX1nmsV/vMU5VmvD2P9H4jtGsz0n6
 HCRfrqmumUVIyK1j9wk+b+Hh7JxDlXVj5WXa39ZQqtlC8foiC7DcT9y4skTjKIFHv4vw
 8YCxCAeVfEmEgrqwzi7pLiiRLvrQf922iJo52BUjCvD7FIZmvWyGa8FOzPJz/6EgGI6v
 XyYd8VT3Qx82VijPLex/NBTEXRxnpS1jZLs2wulPpuMipuqsAczB115q6JB87jO5kRRS
 dGB80hWg50jdhiHePj195LJTjAdj0elbPPMHjXkh5hzfETrtqojnaowF7veZzPtIy0DG
 gipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cJX4NOJxx8yt8bifaIIJHW1REW326f1qVXuNvHoJSGg=;
 b=Gx7P4kA6VUb2vjUUH7Vfepf7QPY3g/AHl4Yf18V3yOLxGM+OjK/gBZfiNgGVeOBBBo
 QVrWZeAZ15OFjeOHDEA9LUC8goCxaKviwNAsyOLFQ+W4dy6nlxMwzTmL0znAhT5sZmFm
 lwqUJ2We0pHnrovuB0JO6idBOdjDvdvSbCK08RNoVCXS4ouid0D7K+6iGCnXfw5lC2S6
 Ze0eZ0JMpOnoOxaEor5MzuIy7M5Je6drb7p9XsZ/sVa7Bh07QfQDLKE5RyUveVHWoe3B
 rGZJw9Q6H1OSFMLbCyLf5A/M6xPr8pRxgORnRkLQjBADclCsSy4VBrXEmMAnxuXYfvis
 zUgg==
X-Gm-Message-State: AOAM530632hB5kMoFqXsnXB6Gyd9exZei71sCp2Clux9qaIph730hGoN
 nCMi1BYoBr+dHh/MPJdt2VhtPA==
X-Google-Smtp-Source: ABdhPJxV/XUGUnp8Y08gGA8YCbm1IrFT95czI8pjByDzfirwYlhZgziSfr3Rg2N60hRkRbJm5fHa3A==
X-Received: by 2002:a17:902:b596:b0:158:f23a:c789 with SMTP id
 a22-20020a170902b59600b00158f23ac789mr19031923pls.57.1650910616632; 
 Mon, 25 Apr 2022 11:16:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 f16-20020aa78b10000000b0050a81508653sm12251481pfd.198.2022.04.25.11.16.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Apr 2022 11:16:56 -0700 (PDT)
Date: Mon, 25 Apr 2022 18:16:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
Message-ID: <YmbllLTbP0TGDemE@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
 <Yma6fEoRstvmu6sd@google.com>
 <CAOQ_QshYttK+e9PQdp+vZo2w7NN8oGVAQm8LC+DBP5gs+5fLwA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ_QshYttK+e9PQdp+vZo2w7NN8oGVAQm8LC+DBP5gs+5fLwA@mail.gmail.com>
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

On Mon, Apr 25, 2022, Oliver Upton wrote:
> On Mon, Apr 25, 2022 at 8:13 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Apr 15, 2022, Oliver Upton wrote:
> > > The ARM architecture requires that software use the 'break-before-make'
> > > sequence whenever memory is being remapped.
> >
> > What does "remapped" mean here?  Changing the pfn?  Promoting/demoting to/from a
> > huge page?
> 
> Both, but in the case of this series it is mostly concerned with
> promotion/demotion. I'll make this language a bit more precise next
> time around.

Please be very precise :-)  It matters because it should be impossible for KVM to
actually change a PFN in a valid PTE.  Callers of mmu_notifier_change_pte() are
required to bookend it with mmu_notifier_invalidate_range_start/end(), i.e. KVM
should have zapped all PTEs and should not establish new PTEs.  I'd actually like
to drop mmu_notifier_change_pte() altogether, because for all intents and purposes,
it's dead code.  But convincing "everyone" that dropping it instead of trying to
salvage it for KSM is too much work :-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
