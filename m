Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1A2C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 00:32:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D11A24B8B9;
	Tue,  8 Nov 2022 19:32:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qLVMa595oRD0; Tue,  8 Nov 2022 19:32:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A08E74B895;
	Tue,  8 Nov 2022 19:32:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 814C54B886
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:32:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pWp4gv2aqhCv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 19:32:23 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48D484B836
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:32:23 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id
 m14-20020a17090a3f8e00b00212dab39bcdso419346pjc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Nov 2022 16:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=RQ1jZB3m3JNgwDhXjvr6dpP648h3M6Z1s+n2GIXxEIo=;
 b=CRbqjBhRSNWKJ3gP6OhmCaglk6IoBDsubUDFV3xuv6NJpkfqtcN9cbk64wS63YwRkL
 RYJuhevVxMdwp6TpG2m6ovEqDuDi1rwnzTwbi5q6x6UW9LIRkegtLbQR6q5gkS9ZH0d4
 DlS9gO7IoPlW72kRJL68GlEhrzpniTOQ5j1auw/oqGpfNgGSlMSLVMCso9wiLUH0rjJK
 Ss723yFE+QJqxvL0FnZFGbqdioM536DIOSQ4ubJ6BvOmnJ4OXZokz2QYGvXy3+supDzP
 oyn6hCR3gkiZRzEElNgifAkcXPS+BZTIV1sfwb1ZkpZYjc64KOAyHnn3iNgBtCeNBj77
 byfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RQ1jZB3m3JNgwDhXjvr6dpP648h3M6Z1s+n2GIXxEIo=;
 b=J7asYRQExdUNE/SpMC3BTwUTWV9n9R4gXlke14veKtW0k4DanTS2PMtntd+43oZgd/
 SI/IbCIxpQvK4eo4jWqwgiEoYUboOW0MrUfN4PWFTGuI38K06Wk5aCSNk75EuVJPVAV5
 2RHCM06wK80Y1WyazNgNYpPTTGmbvytIMxtNPUk46E5Kiv3IwGRg9FwC2R9QLFZLZN5B
 +p/FFUz5FGUmdHeH+Ix2V4aLQeQ3v7l3/6hgC6Hhrtghwui3imNkXir3PiBYZHoZFXal
 Vc//5Gpyo8kT5EsKmu7ei0rUmozYkISLvpJjTJnnSV6XxMoq678KFiy8/Gm3FEu6e9Ti
 mcCQ==
X-Gm-Message-State: ANoB5pnLx0mMzwvGjo0Mf8gJ5oq5cYCf3IgzwMXkUkEzAf2QaNGAMowS
 TY0rr9gBoPYi2da//LwXPUNdZQ==
X-Google-Smtp-Source: AA0mqf47wfHd+WN4Dx8uEDBo8ewcqOBktb14YxfpMVMVZOcUCSxxNuC8Mn5JxqjFHWRaslv52qtr7A==
X-Received: by 2002:a17:90b:1e10:b0:217:4fd0:acbd with SMTP id
 pg16-20020a17090b1e1000b002174fd0acbdmr25583534pjb.235.1667953942140; 
 Tue, 08 Nov 2022 16:32:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 s5-20020a17090a440500b0020b7de675a4sm6612962pjg.41.2022.11.08.16.32.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Nov 2022 16:32:21 -0800 (PST)
Date: Wed, 9 Nov 2022 00:32:18 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2r1ErahBE3+Dsv8@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
 <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
 <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
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

On Wed, Nov 09, 2022, Gavin Shan wrote:
> Hi Sean,
> 
> On 11/9/22 8:05 AM, Sean Christopherson wrote:
> > On Wed, Nov 09, 2022, Gavin Shan wrote:
> > > On 11/9/22 12:25 AM, Sean Christopherson wrote:
> > > > I have no objection to disallowing userspace from disabling the combo, but I
> > > > think it's worth requiring cap->args[0] to be '0' just in case we change our minds
> > > > in the future.
> > > > 
> > > 
> > > I assume you're suggesting to have non-zero value in cap->args[0] to enable the
> > > capability.
> > > 
> > >      if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > >          !kvm->dirty_ring_size || !cap->args[0])
> > >          return r;
> > 
> > I was actually thinking of taking the lazy route and requiring userspace to zero
> > the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
> > forget that `cap->flags` exists.
> > 
> > Just this?
> > 
> > 	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > 	    !kvm->dirty_ring_size || cap->flags)
> > 		return r;
> > 
> > It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
> > that's seems quite unlikely and not the end of the world if it does happen.  And
> > on the other hand, requiring '0' is less weird and less annoying for userspace
> > _now_.
> > 
> 
> I don't quiet understand the term "lazy route".

"lazy" in that requiring a non-zero value would mean adding another #define,
otherwise the extensibility is limited to two values.  Again, unlikely to matter,
but it wouldn't make sense to go through the effort to provide some extensibility
and then only allow for one possible extension.  If KVM is "lazy" and just requires
flags to be '0', then there's no need for more #defines, and userspace doesn't
have to pass more values in its enabling.

> So you're still thinking of the possibility to allow disabling the capability
> in future?

Yes, or more likely, tweaking the behavior of ring+bitmap.  As is, the behavior
is purely a fallback for a single case where KVM can't push to the dirty ring due
to not having a running vCPU.  It's possible someone might come up with a use case
where they want KVM to do something different, e.g. fallback to the bitmap if the
ring is full.

In other words, it's mostly to hedge against futures we haven't thought of.  Reserving
cap->flags is cheap and easy for both KVM and userspace, so there's no real reason
not to do so.

> If so, cap->flags or cap->args[0] can be used. For now, we just
> need a binding between cap->flags/args[0] with the operation of enabling the
> capability. For example, "cap->flags == 0x0" means to enable the capability
> for now, and "cap->flags != 0x0" to disable the capability in future.
> 
> The suggested changes look good to me in either way. Sean, can I grab your
> reviewed-by with your comments addressed?

I'll look at v10, I don't like providing reviews that are conditional on changes
that are more than nits.

That said, there're no remaining issues that can't be sorted out on top, so don't
hold up v10 if I don't look at it in a timely manner for whatever reason.  I agree
with Marc that it'd be good to get this in -next sooner than later.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
