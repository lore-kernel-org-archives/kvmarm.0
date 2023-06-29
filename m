Received: from out-28.mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250FD1365
	for <kvmarm@lists.linux.dev>; Thu, 29 Jun 2023 02:58:09 +0000 (UTC)
Date: Wed, 28 Jun 2023 19:58:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1688007488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ku97PG1qRvaGCuQlVk18WtOgPx7IcGnNgc8umUn7b1Q=;
	b=fWPZ1HgCNXFsRPSAtlf581pdakb1JuTu8jS798wrWFmkvP4mRAc44Ahq8oM/bm/0GNaV5l
	ycKqeANV69Frci7cQ3MPtNRW0tvYHx6cEjH+o+Mnl7IwUivTxfs2UF/wNMvxJbSp7LuJgy
	HSQ1WcrSL1MZSt4Ba5cPVoJsZ6ylRY0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Jitindar Singh, Suraj" <surajjs@amazon.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"maz@kernel.org" <maz@kernel.org>,
	"jingzhangos@google.com" <jingzhangos@google.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"reijiw@google.com" <reijiw@google.com>
Subject: Re: [PATCH] KVM: arm64: Reject attempts to set invalid debug arch
 version
Message-ID: <ZJzzP7h0+yyx4odI@thinky-boi>
References: <20230623205232.2837077-1-oliver.upton@linux.dev>
 <363ed7f4e5e7b7f19af764f1ee5a5e367f4e6339.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <363ed7f4e5e7b7f19af764f1ee5a5e367f4e6339.camel@amazon.com>
X-Migadu-Flow: FLOW_OUT

Hi Suraj

On Thu, Jun 29, 2023 at 01:12:31AM +0000, Jitindar Singh, Suraj wrote:
> > @@ -1501,6 +1502,13 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >         if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> >                 val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> >  
> > +       /*
> > +        * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields
> > with a
> > +        * nonzero minimum safe value.
> > +        */
> > +       if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
> > +               return -EINVAL;
> > +
> 
> AA64DFR0_EL1_DebugVer has feature type FTR_EXACT so the guest value
> must exactly match the host value. So I don't believe this check is
> required.

I got waaaay ahead of myself and sent this out of context. As I had said
to Marc, the fixes is utter crap on this patch since we don't permit
changes to this field.

What I was actually looking at is raising the limit for the debug
architecture on KVM and permitting safe values less than that of the
host. So in isolation this is pointless, but will be useful for a
functional change.

> >         return set_id_reg(vcpu, rd, val);
> >  }
> >  
> > @@ -1522,6 +1530,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >                            u64 val)
> >  {
> >         u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
> > +       u8 copdbg = SYS_FIELD_GET(ID_DFR0_EL1, CopDbg, val);
> >  
> >         if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
> >                 val &= ~ID_DFR0_EL1_PerfMon_MASK;
> > @@ -1537,6 +1546,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >         if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
> >                 return -EINVAL;
> >  
> > +       if (copdbg < ID_DFR0_EL1_CopDbg_Armv8)
> > +               return -EINVAL;
> > +
> 
> This one has type FTR_LOWER_SAFE and so the check is required.

Same goes for this field -- any changes are forbidden since it is not in
the writable mask.

Thanks for having a look, apologies for the confusion.

--
Thanks,
Oliver
