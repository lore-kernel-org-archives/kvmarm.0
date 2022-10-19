Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972532F47
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 13:35:10 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id r14so25298658edc.7
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 06:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jGDuBvVBWtQQhTh15f+xlFUiPdaWSbx11jMCTBh0luA=;
        b=PxTuqiFHKGLs6Q04zg2G4eSd00jK6zzgrt4HdFyWkirB8aCwSWFmJDbb4XEBPbs84b
         XjeLDlepBSGLM9yuvsYFtIMpaA2nrkP9RseT+JMyFrkJmTtNG6S7IBl+ZFb+Z7EU964K
         51qHIrDOsh043I6Y6V8E1g4XMUP9UGgmtMVCorWtgXXr8Ez+6KCd5ZzkSfC1vBvU0cH1
         djCo4kPBwtzeKGV/O9N2hFeEJoYjXLSvmvYEL25wdP7p2Tf7hgW6O1nT+5fEjsm/qMk2
         LLG+qdTEOncIhwY/g1cG4Fb+GhzkkvlzTi4NT6ZkssFxxTJuSnyH4YRDTPFp3De08sQ/
         Humg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGDuBvVBWtQQhTh15f+xlFUiPdaWSbx11jMCTBh0luA=;
        b=meepmRzL6LawfTtFUeBRRIs+wR1hxkxxeafTpiFnYXUQ3BS0zHHmXSXStfiNItBw+P
         mtjh/lS/J9lXusSRI5WKUGTjLia8EMe4suYtNRm3oWXwPIiri2iY/Ht3s7CaLE0NwaHn
         T8nY3srsHVFPMI++dBSToib9xWP0PqGyQnNvRk+oMltdgwhYw8c3+O6+NbdZ9Ieb05Od
         n0FQDA8GHlPDq/2GcnFfFDltbvQnBXREPaHNIMqqIswBSvanYjker0pYnw+Vmd9+YfrB
         DYzZKWnuIRk6pG49hMU1uUj21QuWbQN7rUugIdNH/kIejojc5EFS1a6Suh09HJgmp1c/
         qgkQ==
X-Gm-Message-State: ACrzQf3Q54TGaNPKh/HLTxPvIA6iUG8S6tG615tHCAiL7+VfJEoofTdz
	Pv8cdwvEm+NAhPr4vM8grjhmPQ==
X-Google-Smtp-Source: AMsMyM5/lmcijk1PTC/MIbN3EcbOaf5vqEsarZQ2QfOuX/8iQ6m+Bp7SwPos1MPS6rC1Qfj/aMnvQg==
X-Received: by 2002:a05:6402:5ca:b0:445:c80a:3c2 with SMTP id n10-20020a05640205ca00b00445c80a03c2mr7515578edx.247.1666186508675;
        Wed, 19 Oct 2022 06:35:08 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id d7-20020aa7d687000000b004580296bb0bsm10538281edr.83.2022.10.19.06.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 06:35:08 -0700 (PDT)
Date: Wed, 19 Oct 2022 13:35:05 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y0/9CZHSMLLnmWU9@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07VaRwVf3McX27a@google.com>
 <20221019115723.GA4067@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019115723.GA4067@willie-the-truck>

On Wednesday 19 Oct 2022 at 12:57:24 (+0100), Will Deacon wrote:
> On Tue, Oct 18, 2022 at 04:33:45PM +0000, Quentin Perret wrote:
> > On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > > +void pkvm_hyp_vm_table_init(void *tbl)
> > > +{
> > > +	WARN_ON(vm_table);
> > > +	vm_table = tbl;
> > > +}
> > 
> > Uh, why does this one need to be exposed outside pkvm.c ?
> 
> We need to initialise the table using the memory donated by the host
> on the __pkvm_init path. That's all private to nvhe/setup.c, so rather
> than expose the raw pointers (of either the table or the donated memory),
> we've got this initialisation function instead which is invoked by
> __pkvm_init_finalise() on the deprivilege path.
> 
> Happy to repaint it if you have a patch?

I don't, I just got confused, maybe because in an older version of this
(possibly quite old) the table was statically allocated? Anyways, it's
all fine as-is, thanks for the reply.
