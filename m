Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6FBC67871
	for <kvmarm@archiver.kernel.org>; Tue, 25 Oct 2022 00:08:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AB024B658;
	Mon, 24 Oct 2022 20:08:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QNXthNsB4i4K; Mon, 24 Oct 2022 20:08:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E2054B636;
	Mon, 24 Oct 2022 20:08:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 425884B199
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 20:08:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P-UwytafZJNW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Oct 2022 20:08:36 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C2464B0AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 20:08:35 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id c24so9799318pls.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 17:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=zz/BZ8N7gBJCXtTyLz8hkK9A2LBqOfEuEbnt41CX/DI=;
 b=tdFfG/N89ItBUway03bB+0x26d36PbThzPpfehyOgLe5nKcmbVXHl76egRTvntYvSD
 lo1RrrkptseBZ9q3Q0bXuqpP7rqL28hiRFW3iqUntjVQHVKMuPl5iEVaeMOLUqCanIso
 Ix+3+iN/7KuSjeKpBMiaehfiyx6Wol3mTz0mx8PmeaZr793jxI5zBFoKiDqvuWNHTko8
 dwECAAwcgC7iVcOYUMfPC0KRYoftv3YX8HA7Mmx+vfLRodMLiVIJzDHh9vwDzGR128dn
 F/iz4N1fdnozp2SB2okHNC4Wb+TDd7CqtnKyIdvITzHgJJ0RAPqWrKTf1CyCqrIC1Xig
 +opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zz/BZ8N7gBJCXtTyLz8hkK9A2LBqOfEuEbnt41CX/DI=;
 b=WyIOBw/kJghDT7cEZb9oe5mnSCdOoT+DcRURHZtRSXL0covjwFG6rv3a2x3BlF1ouA
 IkWhh4uVx8s5hsvIkkSaiHzjp27VeRh+LdOwo9bEbTQ4JHGNouPtt5+zcUpLI4Z0HN0F
 pmPsVeaglcTQTOJ3CrdoBqcc6qLcwbqlHucvkGlCXzwy4ubpDu/SbmCOBmvuSnUDnFJF
 KByzoW4Ph/S/FabOyceMQNcoYF+pzy1cTDZLZH6D/pumcfPxiEjht1hr/ZGZzrVcug/V
 TYlodB3sQHgKrGN4H9EYOwYw2RoKjLoxszkX1nX4Aso5JBm4b24nPIdCCLUcTcVLwFjO
 RvbQ==
X-Gm-Message-State: ACrzQf3cVnM3cCeb8uiBmffzhcr0N2IYTJj7jDflMqaHMcHcKZbnEyoL
 snSD1WelHKs1jFf6ZCJT9cbQjQ==
X-Google-Smtp-Source: AMsMyM5Mijhq5j98jv3SqoErPAzXEHj8QwmSNXJTOqlBp3h07Iz6139AjvUK6+BQyfJFiQUqGqrsxQ==
X-Received: by 2002:a17:903:189:b0:183:7473:57f1 with SMTP id
 z9-20020a170903018900b00183747357f1mr34218440plg.28.1666656514962; 
 Mon, 24 Oct 2022 17:08:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 h12-20020a170902f54c00b00179f370dbfasm271215plf.26.2022.10.24.17.08.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 24 Oct 2022 17:08:34 -0700 (PDT)
Date: Tue, 25 Oct 2022 00:08:31 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1co/8GnSU7C+M0n@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com> <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y1ckxYst3tc0LCqb@google.com>
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Oct 24, 2022, Sean Christopherson wrote:
> On Sat, Oct 22, 2022, Marc Zyngier wrote:
> > On Fri, 21 Oct 2022 17:05:26 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Fri, Oct 21, 2022, Marc Zyngier wrote:
> > > > Because dirtying memory outside of a vcpu context makes it
> > > > incredibly awkward to handle a "ring full" condition?
> > > 
> > > Kicking all vCPUs with the soft-full request isn't _that_ awkward.
> > > It's certainly sub-optimal, but if inserting into the per-VM ring is
> > > relatively rare, then in practice it's unlikely to impact guest
> > > performance.
> > 
> > But there is *nothing* to kick here. The kernel is dirtying pages,
> > devices are dirtying pages (DMA), and there is no context associated
> > with that. Which is why a finite ring is the wrong abstraction.
> 
> I don't follow.  If there's a VM, KVM can always kick all vCPUs.  Again, might
> be far from optimal, but it's an option.  If there's literally no VM, then KVM
> isn't involved at all and there's no "ring vs. bitmap" decision.

Finally caught up in the other part of the thread that calls out that the devices
can't be stalled.

https://lore.kernel.org/all/87czakgmc0.wl-maz@kernel.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
