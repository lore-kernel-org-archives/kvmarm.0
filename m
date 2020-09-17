Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E4FC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 08:34:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DD9420770
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 08:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OqIh71Za"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DD9420770
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82DAA4B717;
	Thu, 17 Sep 2020 04:34:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5YLUTat2IutU; Thu, 17 Sep 2020 04:34:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FE934B60B;
	Thu, 17 Sep 2020 04:34:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A644B59A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 04:34:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UHEEcDw9sqKN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 04:34:33 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F4C24B574
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 04:34:33 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id z1so1100737wrt.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 01:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Pk1ggKwYhiZFij3cWsXPx/AsObXSSswRVDTN18QPE2I=;
 b=OqIh71Za/Sfud+/Ld2OIcnclZx0GScK1SioXnMYhhN+wJMXNO+nPqZVsSowByH13lC
 IA6VorWMqWg30MkyELqC6xs0OUIYHEpQ1N2DayLyrSn6ouvhsIfCAuKYtjiTW+wd3ouU
 jb3YvRKbbD2HnPJAhGCH53RJMDZ6i/Jg/pj2l3dAbI5yyfqfzyqgHU8awtuhdEs/sEHb
 J5gH3ixTa90rSdfYZcFrvEw9cFofCjgTDONXYlmxjKFrqpT2OyF+JPKkg7+0luusumjR
 ZI8i1Pjyu6ykougSn/5jMLvYtGPzAD6CVr/1WKJDk5qo6HFoWi/zZ+Ua9z+YFBgCzakv
 8CUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Pk1ggKwYhiZFij3cWsXPx/AsObXSSswRVDTN18QPE2I=;
 b=sD0ic/TNOnJgEC8/b/d7Gg7EmEAmpkrMM+frx+2jizfpFUNlm6pYJ8V3v/ZOPEWWBX
 RGtALPiZT0H1dW0yxXDbY/Frb6+61aKr9EQ40lBx9VIJrySOm2m08hFIVi/HRA53tSfI
 GYXMQo8LG79Fg7gClUxA7XEA3/Yp6PZk4OGGr7nnsW+J8KE/AiLG+iCOwwiQahQqKOES
 cl9LFlqWwYpBzTwAI0CKk6yOBwkrb2kNw2MUSBS8HsuaX/iqroDZDagK0EQU0IGQ6OhW
 rpMLPdm2673MzZe0Rou9e8oSZ5FU1z0Be92Fqo5a+0Ax/10QT17q0MWAkjo5+cV92nbq
 ZE6A==
X-Gm-Message-State: AOAM533Vx50T4fnf/3CSP0+N0hgglzT+Ocbyp9ZW75CaNG+kaWONHEWM
 k+HyyZc2RUllEtxXCjku/UmWNQ==
X-Google-Smtp-Source: ABdhPJx4CDiIDgawZUzofKbr1/03K2/UnXYclUCZ/yVoEIhOqk5tUiGj9MxMh78vMqiYe0X3zEL3rw==
X-Received: by 2002:a5d:4645:: with SMTP id j5mr30654727wrs.230.1600331672159; 
 Thu, 17 Sep 2020 01:34:32 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:1155:1c40:3244:2fc2])
 by smtp.gmail.com with ESMTPSA id s17sm39708604wrr.40.2020.09.17.01.34.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Sep 2020 01:34:31 -0700 (PDT)
Date: Thu, 17 Sep 2020 09:34:30 +0100
From: David Brazdil <dbrazdil@google.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 03/10] kvm: arm64: Remove __hyp_this_cpu_read
Message-ID: <20200917083430.sxe4rpwp2lrdu3hq@google.com>
References: <20200903091712.46456-1-dbrazdil@google.com>
 <20200903091712.46456-4-dbrazdil@google.com>
 <20200910111225.GC93664@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200910111225.GC93664@google.com>
Cc: linux-arch@vger.kernel.org, kernel-team@android.com,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hey Andrew,

> > +#ifdef __KVM_NVHE_HYPERVISOR__
> > +#define __my_cpu_offset __hyp_my_cpu_offset()
> 
> Is there a benefit to this being used for __KVM_VHE_HYPERVISOR__ too
> since that is "hyp" too and doesn't need the alternative since it will
> always pick EL2?

Minor time and space savings, but you're right, makes sense to treat them
equally. Updated in v3.

> > +/* Redefine macros for nVHE hyp under DEBUG_PREEMPT to avoid its dependencies. */
> > +#if defined(__KVM_NVHE_HYPERVISOR__) && defined(CONFIG_DEBUG_PREEMPT)
> > +#undef	this_cpu_ptr
> > +#define	this_cpu_ptr		raw_cpu_ptr
> > +#undef	__this_cpu_read
> > +#define	__this_cpu_read		raw_cpu_read
> > +#undef	__this_cpu_write
> > +#define	__this_cpu_write	raw_cpu_write
> > +#endif
> 
> This is an incomplete cherry-picked list of macros that are redefined to
> remove the call to __this_cpu_preempt_check that would result in a
> linker failure since that symbol is not defined for nVHE hyp.
> 
> I remember there being some dislike of truely defining that symbol with
> an nVHE hyp implementation but I can't see why. Yes, nVHE hyp is always
> has preemption disabled so the implementation is just an empty function
> but why is is preferrable to redefine some of these macros instead?

That was my initial implementation and we could probably sway others in that
direction, too. That said, I just tried it on 5.9-rc5 and there are two more
dependencies. No idea what changed sinced the last time I tried, maybe I simply
messed up back then.

Basically, this_cpu_ptr translates to:
  __this_cpu_preempt_check(); per_cpu_ptr(sym, debug_smp_processor_id())

__this_cpu_preempt_check: should be empty for hyp
per_cpu_ptr: needs mapping of the array of bases in hyp, otherwise easy
debug_smp_processor_id: needs a clone of 'cpu_number' percpu variable

Neither of these is particularly difficult to implement, and two will even be
useful going forward, but it still feels too fiddly for posting this late in
the 5.10 cycle. So I suggest we stick to the macro redefines for now and I'll
post those patches for 5.11. WDYT?

You can find the patches on branch 'topic/percpu-v3-debug-preempt' of
https://android-kvm.googlesource.com/linux.

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
