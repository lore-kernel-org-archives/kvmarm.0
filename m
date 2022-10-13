Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB949C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 13 Oct 2022 13:33:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 254E84B25E;
	Thu, 13 Oct 2022 09:33:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mRjAn2Sssfac; Thu, 13 Oct 2022 09:33:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2641149EED;
	Thu, 13 Oct 2022 09:33:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4358940E06
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 09:33:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pEnwm3NRGfg9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Oct 2022 09:33:44 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CC6440177
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 09:33:44 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id
 az22-20020a05600c601600b003c6b72797fdso1436059wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 06:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=wtCloI9hskeDNVZ254m/WnfVkbDM6sWRXNrTkKvw5FY=;
 b=YW8z6aczP59ni0skunR8oi0MaOYp45DzXHwhcdK7CWpUnP5B39YJhV5ewCDGDKUgfb
 XODKvI1+dXZXPs/gz2ycYE0tw/6n+1eOUS4Vz1+uKTt87A312Z3T0sxaIQCm6Dc5+GVx
 3DpQL6CfPKCU/LA0HFGxJ2Se2t33vLI8UrQNVl5MrDvlvSe3UYx4CRMrDgZ2I2/NjkoS
 82b54oP5rxZdq+DNZWVJ/iH3KL9O9sEqFbtskumqU4lFdhmPqp9WdIPau4TvKcT2jL1A
 ZGFNJdKvht+9AQVirDse/nkU60mohW71olHTsNkVHZFgUUITm2dtLCwJLVQN6jN6Hv6l
 10RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=wtCloI9hskeDNVZ254m/WnfVkbDM6sWRXNrTkKvw5FY=;
 b=DtA3wpRTKsEAONYZXev2Bl/d1GcYOOe/Cc13ucOOMn8Xi/7axZ4oOZstWdjdxvm4y4
 vOK/RlOaUulpFrtvEcE9COi834vbbXsapXq4iQs+AHsoyyZMS+LJ3N6e8QLOYKrz5Cdp
 uPfZBmMH+sAu1APbXhPsiZa2vRxoR9OSIh+yl/WhOGIp8vHR7R652T5rJ5m2pzslUAnN
 GsosnGW0V2gaKiOO4+Aicb/93WszrkDFdobFnmXs3U4hkP1dsa+7Pe8C1ylhcFh9vqNu
 vGg4gJPVo5EvRdwQkn9aRwisz+36xk+9NTN6GJYnM669Av9Fe/ZCnNFsyQ/MLvv6e0gD
 sLag==
X-Gm-Message-State: ACrzQf3L/3HeyRYurPEYFHvaqLoo/a8TJt+dvkLL4S4WYHsN0K8gjV0Q
 8dfr+PKuxo+LQbDsHYepX0CXag==
X-Google-Smtp-Source: AMsMyM5Xvso38gZmW1inlKkLOIsDEX7FDM5OiRgLE55NcJDVGJPiW+JGoOffZ4yRYyETMAV8Z8Ms2g==
X-Received: by 2002:a7b:c341:0:b0:3c4:552d:2ea7 with SMTP id
 l1-20020a7bc341000000b003c4552d2ea7mr6699736wmj.82.1665668023180; 
 Thu, 13 Oct 2022 06:33:43 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
 by smtp.gmail.com with ESMTPSA id
 r205-20020a1c44d6000000b003c3a1d8c8e6sm4582858wma.19.2022.10.13.06.33.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 13 Oct 2022 06:33:42 -0700 (PDT)
Date: Thu, 13 Oct 2022 14:33:38 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
Message-ID: <Y0gTshQFSTwh+Eqf@google.com>
References: <20221011165400.1241729-1-maz@kernel.org>
 <Y0W6hxc68wi4FO/o@google.com> <87pmeygjrl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87pmeygjrl.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
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

On Tue, Oct 11, 2022 at 09:58:22PM +0100, Marc Zyngier wrote:
> On Tue, 11 Oct 2022 19:48:39 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Tue, Oct 11, 2022 at 05:54:00PM +0100, Marc Zyngier wrote:
> > > The kernel has an awfully complicated boot sequence in order to cope
> > > with the various EL2 configurations, including those that "enhanced"
> > > the architecture. We go from EL2 to EL1, then back to EL2, staying
> > > at EL2 if VHE capable and otherwise go back to EL1.
> > > 
> > > Here's a paracetamol tablet for you.
> > 
> > Heh, still have a bit of a headache from this :)
> > 
> > I'm having a hard time following where we skip the EL2 promotion based
> > on __boot_cpu_mode.
> > 
> > On the cpu_resume() path it looks like we take the return of
> > init_kernel_el() and pass that along to finalise_el2(). As we are in EL1
> > at this point, it seems like we'd go init_kernel_el() -> init_el1().
> > 
> > What am I missing?
> 
> That I'm an idiot.
> 
> This is only necessary on pre-6.0, before 005e12676af0 ("arm64: head:
> record CPU boot mode after enabling the MMU"), as this code-path
> *used* to reload the boot mode from memory. Now, this is directly
> passed as a parameter, making this patch useless.

On a 5.10 though, the suprious HVCs are gone and I have not observed any
regression.

Thanks!

For a stable fix:

Tested-by: Vincent Donnefort <vdonnefort@google.com>

> 
> The joys of looking at too many code bases at the same time... I'll
> see how we can add it to 5.19.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
