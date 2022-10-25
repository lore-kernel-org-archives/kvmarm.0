Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F08A7B
	for <kvmarm@lists.linux.dev>; Tue, 25 Oct 2022 00:08:35 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso8071160pjc.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Oct 2022 17:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=oZrzgtcFIgxPR0Uzx1o57pgLPezuvDFDh+gBd4aCsyBmkPWGexHobK+Ljy9kgtI5S1
         yNXZAQ/qIzevBwHBNbghP3dtc1U+eqarZNy0sHE8+XO1azL//f6r/dsZnyxHWeH8eqsh
         0P4BoaS4Vu+uQx2r+dsUjqSCd6+wV2GYZv+z8nV+a15r+AhSyRMFd41cUWAymUWKELP4
         gNtyHaIJSkLrUArSId1nnXN9sY1RyD/CPiz8uIfMDpAjTG+RfcU4xWyVMHcEDhmVVQFU
         a3r+um2qV1jTi/XEAFp3okSnWWwGqbZW+eYb6EZaW1UpwT4tFYFZggbVzAOMqURE9FH5
         iXAw==
X-Gm-Message-State: ACrzQf3WE1BHZzuN0h8uMsHjN0jWGFfFofgTc89r+BNC75xKKiaYBpUz
	HAJcWLYEfDzXOG42mETd2fmEBA==
X-Google-Smtp-Source: AMsMyM5Mijhq5j98jv3SqoErPAzXEHj8QwmSNXJTOqlBp3h07Iz6139AjvUK6+BQyfJFiQUqGqrsxQ==
X-Received: by 2002:a17:903:189:b0:183:7473:57f1 with SMTP id z9-20020a170903018900b00183747357f1mr34218440plg.28.1666656514962;
        Mon, 24 Oct 2022 17:08:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f54c00b00179f370dbfasm271215plf.26.2022.10.24.17.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 17:08:34 -0700 (PDT)
Date: Tue, 25 Oct 2022 00:08:31 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
	bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
	dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
	james.morse@arm.com, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, oliver.upton@linux.dev,
	shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1co/8GnSU7C+M0n@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1ckxYst3tc0LCqb@google.com>
Message-ID: <20221025000831.6GZKDCr3uTekDGGP9DLLOniLcelPaYx6top-C1u7Z30@z>

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
