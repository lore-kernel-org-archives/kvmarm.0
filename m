Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A11221554
	for <kvmarm@lists.linux.dev>; Sun,  7 Sep 2025 09:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757237840; cv=none; b=rtUaQ+nSLTsquwTY3Y8nwN/byPe8hwKeKiGEaDkZhWIAWrHuiIxG73NxGNgl/F5pE1xxLR90tPBCdo2kMPXh4tOdy8BGV6/qZZNixELzKWDmH1KWBqmLIlQY0Qv/HT58qbq7aVRzfHZm88sL7bbi2lNF44+6vawuig5U5ZI+wYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757237840; c=relaxed/simple;
	bh=0Xrg991TS+oaAJX9WvbcTEwohOrOg/V5EHbqh5DH5xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlUj2miXuAms2IhgtWNYEMYQXu8cPfjkVxHjiPzKBz0ysPp2lDK7g1/uB0GoiyFj+aL1uI47YGe+U69hubnDM8MonBAguvItPXLUd9yW/nPHa23a43pK1O0RbeVLhRnhvFBkVdDPtNeaeis841KfjEHQv++1v6wxmzYz2zwR6qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=IiPh75Ix; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="IiPh75Ix"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-323267b98a4so3154485a91.1
        for <kvmarm@lists.linux.dev>; Sun, 07 Sep 2025 02:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1757237836; x=1757842636; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=70zvkE3bB7cmZPuDeaKwadOTmazE00TZ9JEFPyMgvYg=;
        b=IiPh75IxQeK8ExZ5HhlMct6w4vY1GxfqqFTeogfpjwUDRtpqfAwpEqjaFaqvhgUvUd
         lfI4DRjpZ1bDO29padUtQeoRH1LJd2BlohB3e+x2wU6c7vEwywnu08plSMfznvec802S
         ZpA7ivUE+TGT1+HCWb9SpwwPw2Lj6v3gNWMH3/DzP4vlISK/RtaUmtgpq/1RU74Xkxiz
         wO+f38Uqh8pdm/iNAaNGGMDOW3knQ6ft/36N6+1oTYyymcsntuvLr1eLYL3X5WOGSiy2
         FNpYxpudpG3BSTO0z9ESfgucJ3DcSy05xxZpeCNzpHjwtlg4bRMsSmlwff5bBLtupecA
         VR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757237836; x=1757842636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70zvkE3bB7cmZPuDeaKwadOTmazE00TZ9JEFPyMgvYg=;
        b=jv8JhrvkOedEYU9sOJkCWQ6wj/1+/3hhPpEPQ3vbeY1KgRTy+LHph+KYwzrEYI+rMT
         qsTDEJ/dtvLci7c2hce776GLxZHjezdnoUraqvbZbX6fLsmfEkA5UY2LgBJ1lBT+NM+K
         9Z7yAITxo8Qx0jZo/CZ6B7/00YwOAOS1/nNd3c90/QMFNfc9TKjkuDBFBGxz34H7n5kF
         cPt3yY1N3KmyYc/DPwifHpumDMfztrEy0jVehTW7I7sn4xdGYbi26BGFBKIbkU7nQlLW
         xmFRGIZxDJaIom2xSfZwTxbPjCxBLrRlsczZnDmDQ5/4MrI0X6eymNEAnPjJqk2F9RMD
         GBMg==
X-Forwarded-Encrypted: i=1; AJvYcCX7wV3nmK/bFV0XGgWtplSlxKQrPF80tvFPmh9oRXOPXcomHl+1a4UkxgO7HlzXdK3I4q0b/tw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5tjSAVcFi2mHNjLb20mNayw4TUERsiTH/q6GV9y34y+ktT8QZ
	JDN5aIkKT2cS2KXZlyfzR8P2J1KcLtt+BgHzTyGspKp9E0sj55cexkqRx+a/ynzd1kJTyKDh3iC
	n6YKHxr1lJ+rQwg1B+/QCEOzRUAaeaPYrSxTLV4io0EZgUGCXip4=
X-Gm-Gg: ASbGncvIdOMo5RzoInpvq38h8+VI/7Jzk74fbtOoIcdix3dEyxVSyorWnVCk4PQ1OAP
	xKhLc86hemw+WZ08V2GJ9w//vvlWNgJd8T2enISd9D/kbJaRcpgyk/T/BGsLCOeMjesLxaDbDk5
	WMJJ1gsX6/2a7R4pkBIgsH5H0016+HtQ5vRPCzbsnNI5/ojcwzvp6UmfmUUO+TTXVaEPC42AHjx
	5ROi+qhTPtMUhMOWyGAPpHYaqFvLo0aRj/lukFoeb0GlzGiGEEMfjbFWA4gAVje+Ci5J+BzRjpR
	6Dy32fhhH0M0En11He2CduOQAF8VjikKrwYuKeIxgB6wfFen0CKGqCXEdFitH1/a+BTRdkEXC+I
	VGRwHZKEnvUghSO6CA2pwOnj7qKsivqfiuDCcp9YNYl9OVBbVvQMGSN2wqzmxiAgH7xyj
X-Google-Smtp-Source: AGHT+IFt1zERczq0Nc2LpsPzQKax8feeqQIGI16X5GC5DFj+Af0FRNlixEjUAXqLaAAS2kFETPcSkQ==
X-Received: by 2002:a17:90b:1802:b0:32b:6820:6509 with SMTP id 98e67ed59e1d1-32d43f070e2mr5859703a91.9.1757237836296;
        Sun, 07 Sep 2025 02:37:16 -0700 (PDT)
Received: from zenbook (36-228-15-28.dynamic-ip.hinet.net. [36.228.15.28])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm27768393a91.18.2025.09.07.02.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 02:37:15 -0700 (PDT)
Date: Sun, 7 Sep 2025 17:39:53 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: nv: Allow shadow stage 2 read fault
Message-ID: <hzif6tde7p5q3fyrmu5got25rwuiuea5pzbf2ubbqdfc5uof4y@7waunf3d65fo>
References: <20250822031853.2007437-1-r09922117@csie.ntu.edu.tw>
 <87a53rk83s.wl-maz@kernel.org>
 <djypsyratk63ovzv3flzb2tmunqtcoryzserwhsaaq5nuogsrx@u3uuwynnafbj>
 <864itme8k1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864itme8k1.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Sep 01, 2025 at 12:06:22PM +0100, Marc Zyngier wrote:
> On Tue, 26 Aug 2025 14:49:27 +0100,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > Hi Marc,
> > 
> > On Fri, Aug 22, 2025 at 10:40:07AM +0100, Marc Zyngier wrote:
> > >
> > > This would imply taking the guest's S2 permission at face value, and
> > > only drop W permission when the memslot is RO -- you'd then need to
> > > keep track of the original W bit somewhere. And that's where things
> > > become much harder, because KVM can decide to remap arbitrary ranges
> > > of IPA space as RO, which implies we should track the W bit at all
> > > times, most likely as one of the SW bits in the PTE.
> > 
> > But sorry, I struggle to understand this paragraph after reading it many
> > times, probably my experience with the code isn't enough for me to make
> > the connection. Why are we talking about the W bit suddenly?
> > If you don't mind, can you reword what's discussed here?
> > I only very vaguely get that there will be 2 W bits, one from what L1 set,
> > and one from the L0 memslot, if I didn't completely miss the point..
> 
> Sorry, I quickly drifted into something related.
> 
> My take on this category of problems is that we're better off always
> using the permissions that the guest gives us. This is the scheme that
> we have adopted with VNCR. It means we wouldn't have to rewalk the
> guest S2 on permission fault, since we'd be guaranteed to have the
> latest update.

Ah yes I get it now! Make the shadow S2 more TLB-like and use it to
dictate our actions instead of looking for info in the guest S2 by
rewalking it.

> 
> However, S2 management implies that a S2 mapping can be made read-only
> at any point (dirty log, for example). Which means that on a
> permission fault, you'd need to find out whether the page is R/O
> because the guest said so, or because the host decided to make it so.
> 
> Which means that somehow you need to work out why you have taken a
> permission fault. You can either
> 
> - rewalk the guest S2 as if you missed in the TLB
> - or keep a copy of the W bit in the shadow SW
> 

Makes sense. Yes with this we'll have to distinguish the reason of the fault.

> > > We'll need exactly that if we ever want to implement the
> > > Hardware-managed Dirty Bit, but I have the feeling we need an actual
> > > design for this, and not a quick hack. Your approach is therefore the
> > > correct one for the time being.
> 
> And that's why I brought this up: to support HD in the guest S2, we
> need to mark the full shadow S2 as R/O, and update the guest S2 on the
> back of that fault.

Got it! Thanks for helping me understand this!

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
