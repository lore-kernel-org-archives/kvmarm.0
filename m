Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED96C433C1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 11:38:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 135506023F
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 11:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 135506023F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kroah.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 697574B419;
	Thu, 25 Mar 2021 07:38:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kroah.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@messagingengine.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s6yq1sT-mJfE; Thu, 25 Mar 2021 07:38:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D604B42C;
	Thu, 25 Mar 2021 07:38:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0977F4B341
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 07:38:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rsH5BgB6Q5CY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 07:38:22 -0400 (EDT)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
 [66.111.4.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0A4F4B336
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 07:38:22 -0400 (EDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.nyi.internal (Postfix) with ESMTP id 313605C0102;
 Thu, 25 Mar 2021 07:38:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute4.internal (MEProxy); Thu, 25 Mar 2021 07:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
 date:from:to:cc:subject:message-id:references:mime-version
 :content-type:in-reply-to; s=fm3; bh=7H0SHcq+0HpXs2hgxPtbyNTeFPB
 nE8Pv5n7RPfEE5wg=; b=YHVSeJ3UGRdAcFX0OfsvBKa1jcb0rGmcSJSqdE+yXWF
 ALibxajusMmVGP+1CLBUHptv2gMm3S22yYpZAUcSzQNgx2fFJxIpDoF25KvIQT20
 bWtgC1ujSf1xurZNefPP6vfu14vcI3HKQpLRqbqa4v72sfQRYCMxMtkp2n1p3S7n
 6mktHradA+Pq0qJBQtMMkaMorRmxJWPqrn9/Up012WLCStcrjZZEw+tSeRkgkKBV
 jBzX05QtwYMt3Ku06129HQoyalm67tiHk/hZGlK8/6c02ylAhNwQdqG2qvWyMzDE
 Wm/t90k8TUj8birapdtnC3rtL+ID/7T+WvjJ6WgGtGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:content-type:date:from:in-reply-to
 :message-id:mime-version:references:subject:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7H0SHc
 q+0HpXs2hgxPtbyNTeFPBnE8Pv5n7RPfEE5wg=; b=pJ+biWFxlsOs+6oe8JY2Ox
 aCc8upIo/gqHlE+G3APthXbqfjZ2Z8b7KPYkeTkPu6Q5h+VTtbl4jycVHUvsySJs
 +Uz7Ez19hm5iueVc7dpjWrJ5br4Gmq0mbNqW+lmu7FXZvXDFSyFvyzSGKMZ6UwWY
 1kEYzOZ0puxN3C5wl3LXomgJ7QME8Gv1K9W1jhU2IkIYNmNjSq5eGV5ZDBbrPXA9
 MHXjGJfhiBkNIAb6uIDzYvWr7LMN1qbV9zMCarFLObx8H9P5EhsMwC9swKGobUmR
 G7OwsHry62mx5zooWi1uQChHiRzNc0TXbF7AGWvUZNaT+g/OwFuCNNX8a0KFKeVQ
 ==
X-ME-Sender: <xms:K3ZcYNqOCAnFEVCNyxIvSylxy3HWVuBjmBjEdhN5umDr9T43l6DyeQ>
 <xme:K3ZcYPrK6o0PZWYg7P5XN2UzuIEZv6iTjIjAtP3D4AoDQ7JYgFCeWaJA5XP1sPU7v
 77zIly_i9KhDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehtddgfedtucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
 mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
 fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
 rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
 hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:K3ZcYKNgLUGbKBRlvVvUEZa9DCLjeqQ9FQ5TDfkwQelxTb63ODFLJA>
 <xmx:K3ZcYI4DTDoUUFnmI61FE8Xd9iXZktUOTKR0aVS6uQZRXsG3HFV5JQ>
 <xmx:K3ZcYM7busSac96FsEJPw5dX74WPbU5fFZqLwEiBS7y_YhJwRIv3Zg>
 <xmx:LHZcYGR_F7wXNyJPyBAthm8EIaKVapIq3WpivB_qfm0481Yt2CSR8w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
 by mail.messagingengine.com (Postfix) with ESMTPA id E50BF24005D;
 Thu, 25 Mar 2021 07:38:18 -0400 (EDT)
Date: Thu, 25 Mar 2021 12:38:17 +0100
From: Greg KH <greg@kroah.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
 wrongly advertising GICv2-on-v3 compatibility
Message-ID: <YFx2KcQyZxyR6xSZ@kroah.com>
References: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
 <20210325091424.26348-3-shameerali.kolothum.thodi@huawei.com>
 <9850fc39c1c80840ea77eba60ee5e663@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9850fc39c1c80840ea77eba60ee5e663@kernel.org>
Cc: kvm@vger.kernel.org, linuxarm@huawei.com, stable@vger.kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Mar 25, 2021 at 09:33:17AM +0000, Marc Zyngier wrote:
> On 2021-03-25 09:14, Shameer Kolothum wrote:
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > commit 9739f6ef053f104a997165701c6e15582c4307ee upstream.
> > 
> > It looks like we have broken firmware out there that wrongly advertises
> > a GICv2 compatibility interface, despite the CPUs not being able to deal
> > with it.
> > 
> > To work around this, check that the CPU initialising KVM is actually
> > able
> > to switch to MMIO instead of system registers, and use that as a
> > precondition to enable GICv2 compatibility in KVM.
> > 
> > Note that the detection happens on a single CPU. If the firmware is
> > lying *and* that the CPUs are asymetric, all hope is lost anyway.
> > 
> > Cc: stable@vger.kernel.org #5.10
> > Reported-by: Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Message-Id: <20210305185254.3730990-8-maz@kernel.org>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> Please hold on on that.
> 
> This patch causes a regression, and needs a fix that is currently queued
> for 5.12 [1]. Once this hits upstream, please add the fix to the series
> and post it as a whole.

Both patches now dropped from my queue, thanks.

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
