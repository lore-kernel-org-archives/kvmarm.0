Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2927AD50F
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:21:21 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id mv18so265437pjb.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oOrPD6CB7rqzyj1SaEV3kuD/IhDMhOZPI51nCiB/NGg=;
        b=ZRW2ZUTv1n147KoQiZQIoZW74j4A7EtjIYOcRFO0rF0DPUCmy6VUy2g0JuJ1nS/0PG
         bPSRbTqLAdAfhndt51DMfOPkb6sHyNfjGeyL8kdbar+k+xIpBX4SiQnfKVs3jxbhY30i
         fE+0B93J3f1zH3nafXrLqY7rdRuq0maSuVI9QpeW8enceqQk351ZWU6NHH/BazdCHb+E
         L5o+TvbdnPsX9MioomkdsvtUqYHZQq6KqAvnuPAuThxGPwZ++G4eWoki6stkyg4QcWza
         6l0SCQXCBclmuJYQ9VytxAYkOvwHCR0J4TrW1rGbFwPNrD/IzVnCsAgUxIa0vHOndA6A
         NTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOrPD6CB7rqzyj1SaEV3kuD/IhDMhOZPI51nCiB/NGg=;
        b=21xBxk3H2q5Ur8QkO/i6kWYPRZFS3viVmtjD/FZCgQPo15LI6nRl228wy/NHvWF9/V
         cx+c3BNFgYH8kGLNOvAXk0em39Mmm1oYgOTc8MoTBnGNcz9TJmbJGTdGTadv2DrY5tkS
         jPFuM8P8wGdasJJr9AzC70Snu7qibMolCaUDYYJharq7/uJPkSmna4xmT0M0Ww1DEKos
         or5dRqd6cJE07H0/QtKM4rlq3EeFYEiW4wuGr47RVS3ANPVhr5l8l2L7HP06ANfJApWz
         QXp+VohG6lt3W5/GwDDmtwYYH2D1suLxuyEvGIHhR7byuOR6/l6Q1fqr+zzomFoIFwc+
         73Zw==
X-Gm-Message-State: ANoB5plSkYCdykkswsu5dQrwP5y1NsI6rXYqM1mCvBPxFhkKFRGUp33k
	pl6wO0zoHttcrLPUBn2uYqIyag==
X-Google-Smtp-Source: AA0mqf7MFNPbEgt6osld/lAYA9wa6vF/JYI716/qDYMZhDxdPiOnFjxOBihEjXxstiNyC9WOq9G0Fg==
X-Received: by 2002:a17:90a:d24e:b0:218:b478:f44f with SMTP id o14-20020a17090ad24e00b00218b478f44fmr46173649pjw.232.1669850480496;
        Wed, 30 Nov 2022 15:21:20 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id o13-20020a17090a0a0d00b0021896fa945asm3637054pjo.15.2022.11.30.15.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 15:21:20 -0800 (PST)
Date: Wed, 30 Nov 2022 15:21:16 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4flbAiRyGgpDvnJ@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com>
 <Y4Z2aWVEnluy+d3+@google.com>
 <Y4awiKLuKORZmU2z@google.com>
 <87pmd4ua2q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmd4ua2q.wl-maz@kernel.org>
Message-ID: <20221130232116.vQ0cTC1Eedr0dIJulolHuCYMQjSJces55a_L6UA_7OQ@z>

On Wed, Nov 30, 2022 at 08:21:17AM +0000, Marc Zyngier wrote:
> On Wed, 30 Nov 2022 01:23:20 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Tue, Nov 29, 2022 at 09:15:21PM +0000, Oliver Upton wrote:
> > > Hi Ricardo,
> > > 
> > > Thanks for having a look.
> > > 
> > > On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> > > > On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> > > 
> > > [...]
> > > 
> > > > > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > > > > +				       &pte, NULL, 0);
> > > > > +	if (!ret)
> > > > > +		dsb(ishst);
> > > > 
> > > > At the moment, the only reason for stage2_update_leaf_attrs() to not
> > > > update the PTE is if it's not valid:
> > > > 
> > > > 	if (!kvm_pte_valid(pte))
> > > > 			return 0;
> > > > 
> > > > I guess you could check that as well:
> > > > 
> > > > +	if (!ret || kvm_pte_valid(pte))
> > > > +		dsb(ishst);
> > > 
> > > Thanks for catching this.
> > > 
> > > Instead of pivoting on the returned PTE value, how about we return
> > > -EAGAIN from the early return in stage2_attr_walker()? It would better
> > > match the pattern used elsewhere in the pgtable code.
> > 
> > That works, although I would use another return code (e.g., EINVAL)? as
> > that's not exactly a "try again" type of error.
> 
> EINVAL usually is an indication of something that went horribly wrong.
> 
> But is that really a failure mode? Here, failing to update the PTE
> should not be considered a failure, but just a benign race: access
> fault being taken on a CPU and the page being evicted on another (not
> unlikely, as the page was marked old before).

I see, I agree, what you describe not look like a failure.

> 
> And if I'm correct above, this is definitely a "try again" situation:
> you probably won't take the same type of fault the second time though.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
