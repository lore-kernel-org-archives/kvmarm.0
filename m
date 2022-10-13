Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1792F5E
	for <kvmarm@lists.linux.dev>; Thu, 13 Oct 2022 13:33:44 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso3267527wma.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Oct 2022 06:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=RQu8e4wFyGZjfApRTgX4DWoDJHufI8pF8UFAv9WCPh/E0gxKMIsFW3iP1VWxaXIc9w
         SQIOHWGOD084U1vzUuKU3UNxCdEWf/Im8S4SWjmFSIvCtF4I/mzsMD0BAVdfBQIUk7ww
         SkmvcsVeGCbpzSOtN9NwuDJYILdc8r7GqszQO5eGOpK7RCXH2Btg8fTGfe8vEVHL6msD
         FiA2iwfybx+yLemMyQpVyDN5g2r8XujEEZsy8N5FwAuiuNJM7jvN0sy1LykeMF2ixn/8
         x1l3qFuxtdlAQreSKW/rejMo78tt74ch3Ba6tk6yAm8+CkDsMvBxgXUnkgivq1tbrYbN
         wpag==
X-Gm-Message-State: ACrzQf3c7O0rFs4LQ7ijQ12UmfUAnGG7mZlbGnEp/lNao+cTdbwBLqyY
	/+vqvJDC9p83EvmmoMSsdI8mJw==
X-Google-Smtp-Source: AMsMyM5Xvso38gZmW1inlKkLOIsDEX7FDM5OiRgLE55NcJDVGJPiW+JGoOffZ4yRYyETMAV8Z8Ms2g==
X-Received: by 2002:a7b:c341:0:b0:3c4:552d:2ea7 with SMTP id l1-20020a7bc341000000b003c4552d2ea7mr6699736wmj.82.1665668023180;
        Thu, 13 Oct 2022 06:33:43 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id r205-20020a1c44d6000000b003c3a1d8c8e6sm4582858wma.19.2022.10.13.06.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 06:33:42 -0700 (PDT)
Date: Thu, 13 Oct 2022 14:33:38 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
Message-ID: <Y0gTshQFSTwh+Eqf@google.com>
References: <20221011165400.1241729-1-maz@kernel.org>
 <Y0W6hxc68wi4FO/o@google.com>
 <87pmeygjrl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmeygjrl.wl-maz@kernel.org>
Message-ID: <20221013133338.cubPqxsltFmSoC3j7ll5YeDSXVW9uXxhxXTyoyYxWOQ@z>

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
