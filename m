Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F177C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 00:18:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2764B827;
	Fri, 11 Nov 2022 19:18:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SAIOzVSMkI+H; Fri, 11 Nov 2022 19:18:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8425B4B7FC;
	Fri, 11 Nov 2022 19:18:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6DC84B7DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 19:18:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hK7zDiczflmK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2022 19:18:30 -0500 (EST)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38CD14B7D8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 19:18:30 -0500 (EST)
Received: by mail-pj1-f47.google.com with SMTP id
 r61-20020a17090a43c300b00212f4e9cccdso9033669pjg.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 16:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=BltPvPAmHtl7utKNnS+hSG3e7Q2hwDLmN28Mis71BjM=;
 b=ihXl+Lit+9X0nRxA2Gtm5l/WGvA/aJA5XkvSKznBo5ioJqPewp8RSDbyREb7Z6EjUM
 gm3DJytEHoymvvMqjQpASz4pZdZm7DuH4C1B6M9fm9ih1EoW6wUYkbKpVub1U7NWqDBj
 KR+UvYumaY6yzG5WyBQq4r4aUCFqxz1mctCqNdCeOzoMAdLsOgSPeMVPSM1cNJobtO41
 OIRW+JnvltDxaxcya/6HiFANJKhAoJEh36OfQsAfElBchbkYuVHwNuTerkmjBDdrWQZN
 6Nn53XoOrt/Fm5UcFwn5Em2pFIxOiYsJGVsfQXCT8RBqN1A3VDHFNP9qu4I52aAekLKT
 /znA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=BltPvPAmHtl7utKNnS+hSG3e7Q2hwDLmN28Mis71BjM=;
 b=msSJ3kLqinIEpP5vV3EcBe3cASxbX3Fxi7ds8AOaKeFTJXhK6liSoy8PPnbkhchY6B
 m/GEOf0qLBDDpACK/v1a2GHMOLJZNVIQ0M+UJN3KNIlBNb5OtE7mnaIyEZPxclu6gMVn
 AF5CKLofWd3Ac63hVgJYBrfCnTTYC/Pb4+6ursIG5KZfrJK8qqUJJF50if/5W6Tjm0vJ
 ovYXo2+RkKltCRsoWjGvMuB0TcA9qBLM8sYxHPHn2qwb6sUMfNcFO80ggMAlrfZpULhD
 gU8N1kh7CqnmBhI00bWqrrEVtfEggfpnU4Ov93DRw7JiUsD2yo8TkXjcQ2K6+GvHiv1X
 SYcw==
X-Gm-Message-State: ANoB5plhSB2QKeh+ANbJ1oAD9QcrY9w01A6J1bwXO1zaWvRznw2NSzs8
 icJQ0ighu33fQFdXbgmhTUredA==
X-Google-Smtp-Source: AA0mqf6Rv6a4Qx8bNbK/7DZ5vdIuU2Id03hLVAf075VLC9gKFaG+y2jRfMKKMSCm2B3eTNiHsnrjKQ==
X-Received: by 2002:a17:902:e8c8:b0:188:7675:ff9b with SMTP id
 v8-20020a170902e8c800b001887675ff9bmr4453723plg.45.1668212308974; 
 Fri, 11 Nov 2022 16:18:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 b7-20020a170902d50700b00186e34524e3sm2317428plg.136.2022.11.11.16.18.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 11 Nov 2022 16:18:28 -0800 (PST)
Date: Sat, 12 Nov 2022 00:18:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y27mUerBVW5+loCf@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com>
 <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
 <Y27T+1Y8w0U6j63k@google.com>
 <c95c9912-0ca9-88e5-8b51-0c6826cf49b9@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c95c9912-0ca9-88e5-8b51-0c6826cf49b9@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Sat, Nov 12, 2022, Gavin Shan wrote:
> Hi Sean,
> 
> On 11/12/22 7:00 AM, Sean Christopherson wrote:
> > On Sat, Nov 12, 2022, Gavin Shan wrote:
> > > On 11/11/22 11:19 PM, Marc Zyngier wrote:
> > > > On Thu, 10 Nov 2022 23:47:41 +0000,
> > > > Gavin Shan <gshan@redhat.com> wrote:
> > > > But that I don't get. Or rather, I don't get the commit message that
> > > > matches this hunk. Do we want to catch the case where all of the
> > > > following are true:
> > > > 
> > > > - we don't have a vcpu,
> > > > - we're allowed to log non-vcpu dirtying
> > > > - we *only* have the ring?
> > 
> > As written, no, because the resulting WARN will be user-triggerable.  As mentioned
> > earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
> > logging is enabled with a bitmap, then this code can WARN.
> > 
> 
> I assume you're saying to reject the command when dirty ring is enabled
> __without__ a bitmap. vgic/its is the upper layer of dirty dirty.

I was stating that that is an option.  I was not opining anything, I truly don't
care whether or not KVM_DEV_ARM_ITS_SAVE_TABLES is rejected.

> To me, it's a bad idea for the upper layer needs to worry too much about the
> lower layer.

That ship sailed when we added kvm_arch_allow_write_without_running_vcpu().
Arguably, it sailed when the dirty ring was added, which solidified the requirement
that writing guest memory "must" be done with a running vCPU.

> > > > If so, can we please capture that in the commit message?
> > > > 
> > > 
> > > Nice catch! This particular case needs to be warned explicitly. Without
> > > the patch, kernel crash is triggered. With this patch applied, the error
> > > or warning is dropped silently. We either check memslot->dirty_bitmap
> > > in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
> > > I personally the later one. Let me post a formal patch on top of your
> > > 'next' branch where the commit log will be improved accordingly.
> > 
> > As above, a full WARN is not a viable option unless ARM commits to rejecting
> > KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
> > or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
> > that they shot themselves in the foot after the fact seems rather pointless if
> > KVM could have prevented the self-inflicted wound in the first place.
> > 
> > [*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
> > 
> 
> Without a message printed by WARN, kernel crash or pr_warn_ratelimited(), it
> will be hard for userspace to know what's going on, because the dirty bits
> have been dropped silently.I think we still survive since we have WARN
> message for other known cases where no running vcpu context exists.

That WARN is to catch KVM bugs.  No KVM bugs, no WARN.  WARNs must not be user
triggerable in the absence of kernel bugs.  This is a kernel rule, not a KVM thing,
e.g. see panic_on_warn.

printk() is useless for running at any kind of scale as userspace can't take action
on "failure", e.g. unless userspace has a priori knowledge of the _exact_ error
message then human intervention is required (there are other issues as well).

A ratelimited printk() makes things even worse because then a failing VM may not
get its "failure" logged, i.e. the printk() is even less actionable.

And user triggerable printks() need to be ratelimited to prevent a malicious or
broken userspace from flooding the kernel log.  Thus, this "failure" would need
to be ratelimited, making it all but useless for anyone but developers.

> So if I'm correct, what we need to do is to improve the commit message to
> address Marc's concerns here? :)

Yes, Marc is saying that it's not strictly wrong for userspace to not dirty log
the ITS save, so rejecting KVM_DEV_ARM_ITS_SAVE_TABLES is a bad option. 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
