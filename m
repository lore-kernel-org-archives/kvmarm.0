Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F337E0
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 01:23:24 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id y17so7284051plp.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Nov 2022 17:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ewUKpCuoaPzAR2fmrr+FD3H80AnrDry9LxbpWXLNvF4=;
        b=fb6DDgCaO06aAL+G5/T2sy0zhAJSlkluomnYowvIHNfrJbn2iaW5lHshIKewz5bOza
         ZaVgBpSB1cf2gMMANnU8K3AmjeUTIEKMNAbICy4G4jI4J2CpMNUvY/Js2ymp2Vkdcrpc
         I/d8R9iBlPs25vU0P4/h91XTk5DY/HLFSeS9bfgUuz+/VqMoOnk6kDmp8yWPVrf6tnND
         gTm4F2hpkbVA2broOTWoHcFoZM+TXUmFgKcJTGxHhtdYC50vDAMDfxB23yxt9I+Qq5xa
         Efw8DrsJ1oUnwHKABaYjsxPhyqo6wl960Zc0CTDg/x5TzQW5EkrrtjjLH6tEdMXomJIo
         QP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ewUKpCuoaPzAR2fmrr+FD3H80AnrDry9LxbpWXLNvF4=;
        b=bDQUHPQXasJqhRy84xtgiReqo9ldiFs9GSd9IU1l8JOc24cnfxOIP3QT/plSDlWfwt
         RYrEv0yYu6vV5ARkU2x9RF88+10OkStt+fADV/um45A06i5MJSRqgcY3VQvAvRZux7tU
         TZJvRJees0VDbV/CZo+IZKvSi0MkGnKRO0cJUsZ3AqHeVsObJdSDbg3DrN14g1dCrJrH
         wbWT6cAvSU2KK1hUMWX3VE85RC1y899RygsNRNTlkaJ1kKx0GkrtEp8773WtHi4zs3K2
         9+hMP++OFCySO1DXu8WexLw6Zb4bI6qy2upbocDn4jNckmtB7oeXc3RwvOWXzpIB744p
         xtwQ==
X-Gm-Message-State: ANoB5pkGO4ceGrbaBdyy18p+dSjhEhLtYwWdmzU2DsSwRdCZCp3dAxzl
	m4qykL+iVd1ee8UB6WOzlY5voA==
X-Google-Smtp-Source: AA0mqf7fkXBzPKsGf+r09kMkzskIdRv4AjvbWaWxjMbW/TRWAGLM3zhTZlBXjYYEDVoWL3AUhcc9xA==
X-Received: by 2002:a17:902:db07:b0:189:9ee0:cca4 with SMTP id m7-20020a170902db0700b001899ee0cca4mr4412610plx.74.1669771404345;
        Tue, 29 Nov 2022 17:23:24 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id z3-20020aa79903000000b0056da63c8515sm119230pff.91.2022.11.29.17.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 17:23:23 -0800 (PST)
Date: Tue, 29 Nov 2022 17:23:20 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4awiKLuKORZmU2z@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com>
 <Y4Z2aWVEnluy+d3+@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Z2aWVEnluy+d3+@google.com>
Message-ID: <20221130012320._f6ouaTNlWjf0vS3VPdbCuBXOVQef89LOvTwBjHV_Hk@z>

On Tue, Nov 29, 2022 at 09:15:21PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> Thanks for having a look.
> 
> On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> > On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > > +				       &pte, NULL, 0);
> > > +	if (!ret)
> > > +		dsb(ishst);
> > 
> > At the moment, the only reason for stage2_update_leaf_attrs() to not
> > update the PTE is if it's not valid:
> > 
> > 	if (!kvm_pte_valid(pte))
> > 			return 0;
> > 
> > I guess you could check that as well:
> > 
> > +	if (!ret || kvm_pte_valid(pte))
> > +		dsb(ishst);
> 
> Thanks for catching this.
> 
> Instead of pivoting on the returned PTE value, how about we return
> -EAGAIN from the early return in stage2_attr_walker()? It would better
> match the pattern used elsewhere in the pgtable code.

That works, although I would use another return code (e.g., EINVAL)? as
that's not exactly a "try again" type of error.

> 
> --
> Thanks,
> Oliver
