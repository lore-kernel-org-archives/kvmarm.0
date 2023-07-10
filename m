Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0D1156CD
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 22:13:33 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c6ab0d1b1dcso5193137276.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 15:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689027212; x=1691619212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VhyuhUu7ArHYZFjkYslfHWi7GXr3zNNFUwoXSJr15Gs=;
        b=STVcaaR6HH1MmFncFyTKauvrHE7UvRNbNSVW/i5IKGtGvhl2UQnGE0vFR8gJ66Uk2c
         pWD9/7AWt0Iqe8hrimzxYspFm62Tpuf0XaR47UwByAWC2rQ0T6kPQCe8oLGEGk2MMwkv
         rBmWDcKgO+1vIm/903NAi1T6/+F83sjnYUCBHkfmOJZxODUEirpiNccdSuOM2hW0217K
         OlU7wM3kxncMAm2W+HP6uuGbfTIlJjhGRCFIXTnESPbtqbxag+pdinbQYT2Zj96mVyvK
         gugeJt7F2/3TjWMxVge86PJm6T+A3+F3MQhVXNhtRqdv1t9Vs+Kv55CAEUsXVZc2WS7i
         fOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689027212; x=1691619212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VhyuhUu7ArHYZFjkYslfHWi7GXr3zNNFUwoXSJr15Gs=;
        b=iWEuRuzs7lvgnngrICCdWu5RvDJqjmoLMCmS+RsuqX4XOigIQnIG171C266ad7BPSk
         dEeNhsJrkQGmpzF1feO51Pi2ivmNxUYjyokjTyHkaUAqjMx/1iosHqF7dYLv15++BZH+
         K8b2zSH3Ry3PlNTe+mrQpH1n6OnAcETNgO1x5m1cUJdtT+6MztmtqNRvr/OgYgxI0zU9
         FGmEb5jmquc4MazqnZ7PdRX+Hf0WhSCGMu5ahs9ey2G5LdV9N7GIkI+otJd3fKSZzE3e
         jJPbdtXA9nFQrbnieioag/BcG//S+lvi5vmhEB25oQfbas3cH5JATSqk1guSLOJRxtMo
         LfYg==
X-Gm-Message-State: ABy/qLZ+Zq6MGbpZzojW2ClnHi2xr9B+8jJfqsbYzqG5bn9vl+ogCzRO
	0GTzNklBlgipDOqvRUvxlTs/sduHSB4=
X-Google-Smtp-Source: APBJJlGicNB3k+jdZ6LQfesOWoW0KcNW9IGPTA9A/vbsEkgluZUxiXkGaHoqNIMT3Y4Zm0AQCJca26jhABo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c05:0:b0:c70:d138:51b1 with SMTP id
 5-20020a250c05000000b00c70d13851b1mr42859ybm.12.1689027212157; Mon, 10 Jul
 2023 15:13:32 -0700 (PDT)
Date: Mon, 10 Jul 2023 15:13:30 -0700
In-Reply-To: <ZKxL09AW1s2uL28x@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230703163548.1498943-1-maz@kernel.org> <ZKxIGOAcQbknIcBL@google.com>
 <ZKxL09AW1s2uL28x@linux.dev>
Message-ID: <ZKyCimgRJThIR0pw@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com, pbonzini@redhat.com, 
	Kristina Martsenko <kristina.martsenko@arm.com>, stable@vger.kernek.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 10, 2023, Oliver Upton wrote:
> On Mon, Jul 10, 2023 at 11:04:08AM -0700, Sean Christopherson wrote:
> > On Mon, Jul 03, 2023, Marc Zyngier wrote:
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index aaeae1145359..a28c4ffe4932 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1894,8 +1894,17 @@ static void _kvm_arch_hardware_enable(void *discard)
> > >  
> > >  int kvm_arch_hardware_enable(void)
> > >  {
> > > -	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> > > +	int was_enabled;
> > >  
> > > +	/*
> > > +	 * Most calls to this function are made with migration
> > > +	 * disabled, but not with preemption disabled. The former is
> > > +	 * enough to ensure correctness, but most of the helpers
> > > +	 * expect the later and will throw a tantrum otherwise.
> > > +	 */
> > > +	preempt_disable();
> > > +
> > > +	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> > 
> > IMO, this_cpu_has_cap() is at fault.
> 
> Who ever said otherwise?

Sorry, should have phrased that as "should be fixed".
 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 7d7128c65161..b862477de2ce 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -3193,7 +3193,9 @@ static void __init setup_boot_cpu_capabilities(void)
> >  
> >  bool this_cpu_has_cap(unsigned int n)
> >  {
> > -       if (!WARN_ON(preemptible()) && n < ARM64_NCAPS) {
> > +       __this_cpu_preempt_check("has_cap");
> > +
> > +       if (n < ARM64_NCAPS) {
> 
> This is likely sufficient, but to Marc's point we have !preemptible()
> checks littered about, it just so happens that this_cpu_has_cap() is the
> first to get called. We need to make sure there aren't any other checks
> that'd break under hotplug.

Ah, "we" is all of arm64.  E.g. this pattern in arch/arm64/kernel/cpu_errata.c
is splattered all over the place.

  WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());

AFAICT, the only issue in KVM proper is the BUG_ON() in kvm_vgic_init_cpu_hardware().

Sadly, a hack-a-fix for stable probably does make sense :-(
