Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E10BC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 05:46:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B626A4B0CE;
	Mon,  4 Apr 2022 01:46:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XIxMgAfSK957; Mon,  4 Apr 2022 01:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D724B0F1;
	Mon,  4 Apr 2022 01:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E0CD4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 01:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTucZcD4YNf2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 01:46:44 -0400 (EDT)
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com
 [209.85.166.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 133274A193
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 01:46:43 -0400 (EDT)
Received: by mail-il1-f171.google.com with SMTP id k15so1459700ils.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2022 22:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2PyI5wE/9y9aF+w53ak3NL4bdwUIasxuc/+R7nGVlkM=;
 b=PxHyTiTYyZKrMuWxWAtFUKNTUBv0DkB5ESh3olcmowfb91vjP4mIB7ltmXbb2EO4Ie
 Hn0GeRK0D5M7MuTpjuO0c0ZlZ8iZQ/XmZtXmlP99/R0r96jXGsRC9Rg2Z7tyOjohujoK
 Exx+VXoicxCd8wiN4wdqkV57XoUl5gQK7+e9WVsQlGV/2nNKh7iP2ODGiWqdf17NlQWw
 O6YzGl8E4RjpQY1S3mcUEN4b2S/wkpOiqXJVrRFQGo55cLTpbOF4Kvj+c74BP58sbdSr
 CVSYMWo6Z1criwdhMT2FOZSupAaTY8VHQ4PyFm6dsg4GnoiusW8Ooh80FsqNa2CLMHh9
 04qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2PyI5wE/9y9aF+w53ak3NL4bdwUIasxuc/+R7nGVlkM=;
 b=S4ohqO/O2jtaZSrT+jt8SqTrQzCok6WofDQP61Aezb7Y2HUkJI75FwbRZg3ZWKlKd3
 Ebg5Zb7Q/56tpB3obJk6s34u47/NKL0mjqE7stzVwrCQPRRUfH8eNm+crEco6zFFwr7Z
 tKnPFr2/H4143pZccd9fePD1oCP3Abesh+n1TyipaUuSeVlXwtRv0u+SoCwLnQAeJbmq
 iDCON16P5FJ9ob/dI4MyYYb7BdvJ+CDWcbrLh5sey+/VYHiF2sWpBzk+2udPPY5l47lJ
 +e8lqszhwvwVWOufe2MaNfgOuP7RuhnDBH8kHeXsLkHJeR9N+JYp/CsWw5dN/bS23+R+
 hCAg==
X-Gm-Message-State: AOAM5315Wm5EmBj54ntujZd9m8pwsIfQEys7XmE71FopQ4BdmpRBYwO+
 qalPV7ccWPyVx4FKfqn8a5NlMw==
X-Google-Smtp-Source: ABdhPJwk+57GkB2Zn+ajUSVOFh+5njhU0KQCOdF0/4uXoez1/cNjCep9/bJs6lDeVvXeVItIol/I2g==
X-Received: by 2002:a05:6e02:20c4:b0:2c9:a514:6a99 with SMTP id
 4-20020a056e0220c400b002c9a5146a99mr5023931ilq.50.1649051203223; 
 Sun, 03 Apr 2022 22:46:43 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 h24-20020a6bfb18000000b006497692016bsm5828288iog.15.2022.04.03.22.46.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 03 Apr 2022 22:46:42 -0700 (PDT)
Date: Mon, 4 Apr 2022 05:46:39 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32
 bit guests
Message-ID: <YkqGP/OaKK7LpKF2@google.com>
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-4-oupton@google.com>
 <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fz4cB_SoZCMkOp9cEuMbY+M+ieQ6PTBcvCOQRwGkGv9pA@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

On Sun, Apr 03, 2022 at 09:45:15PM -0700, Reiji Watanabe wrote:
> On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
> >
> > To date KVM has not trapped ID register accesses from AArch32, meaning
> > that guests get an unconstrained view of what hardware supports. This
> > can be a serious problem because we try to base the guest's feature
> > registers on values that are safe system-wide. Furthermore, KVM does not
> > implement the latest ISA in the PMU and Debug architecture, so we
> > constrain these fields to supported values.
> >
> > Since KVM now correctly handles CP15 and CP10 register traps, we no
> > longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
> > emulate reads with their safe values.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> 
> BTW, due to this, on a system that supports PMUv3, ID_DFR0_E1 value will
> become 0 for the aarch32 guest without PMUv3. This is the correct behavior,
> but it affects migration.  I'm not sure how much we should care about
> migration of the aarch32 guest though (and it will be resolved once ID
> registers become configurable anyway).

I believe userspace has been accessing the sanitised values of these
feature registers the entire time, so we should be OK on the UAPI side.

From the guest's perspective, I don't believe there is a meaningful
change. Even if the guest were to believe the value it sees in
ID_DFR0.PerfMon, it'll crash and burn on the first attempt to poke a PMU
register as we synthesize an UNDEF, right? At least now we cover our
tracks and ensure the vCPU correctly identifies itself to the guest.

This is, of course, unless I missed something painfully obvious :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
