Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810563112B2
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734468; cv=none; b=HqeDYgYb3vTgXMySMW0Th7rl7Dn2ltbk67MNSxH6Xnp0QAWht1BQvx6Nte8zcqz/4noyY9XVaWp/uNGWaY+l/jGTgPhUEwI5BVOyzUxeEXMhZhmfuQyMEyfco2a/LF1Iquji/OPk9FdRb7juewm4bn48dA82Z16rNoohULYnAds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734468; c=relaxed/simple;
	bh=bl/YMALd3mQ/g2M3kVKZpJBRcUl71G7E1PaFpoMCpTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0OHXXHJfR1LHEBzuaPG5hOIy81J4SpmHOLwjvqK11JnUjjQTm4nYsn+ebXjkCMwVtLWBuDQLqxTzO7SiNWohpQTDqbxvo6q1jawmqB1Vpmicld//KpdTwjZbkG5JLXh8b4FLunPHV/DlPlkO1D3PoMGO6eayCSvIMwVoFEqCCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cjrrCq/1; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cjrrCq/1"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-499b1409a75so31845e9.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 01:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787734465; x=1788339265; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GC7HaV6ubG2A4QN/tpZz7iru0oh8bNIqfpSQwQL8lBA=;
        b=cjrrCq/1gv5qb12Q1ZbNheE6ZXpqGoeLEQ9yM/KkbLGadNg+v9fUb1o0m5cLz3is0p
         L64ALlb3YPWdlGM7hjBWOO0KLuKWnBD0motqHy6TnE3XQKUvM6Q1Hs5GioMrwLpIHV5m
         q3Q+5q6bzkSlwi7QiqckViIiTv3PvS5tZ3cOm5WQIVW8vewGJitm76sxTGB0XR7jEh58
         KFLwx34AQLlYrCHisM3nwaIt46JQIndx+gc6j8//NZTq8uuqnjBzzB09m2owgtn9w6Ak
         v38lMqEiD/u3j096FUTAqWS+hFlKDDCCvzbuwTC3hi9sJ+02jN8FbAvyGC5BVv68x9FN
         N5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787734465; x=1788339265;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GC7HaV6ubG2A4QN/tpZz7iru0oh8bNIqfpSQwQL8lBA=;
        b=AhrfWrfHEm1neLdK44jsqDE6rcgLSe93qFlCV6XFbBEYIpEGraNzydwjTGDUl+z/wF
         UwZoz7ByDD7gbfo+NFofA0yRQHykJSdSoPCyNziBKqWE4+2bzx87hZSBnfMWvVkN5YKE
         Vn+2Zow9jULj6Dfy65lMMh8/2g5Zs2R5chImgB10fmP54hTAvrp9/DE8H48CWRYew/rb
         MDxWavxDfmEUaPEvqGBoebAtdNYme2R/Pyz2fdNFG32oSswGv9gIszWy+N70injvubbR
         mvh3NLqMtwqJvLek/PspHx/clCFbDOhhva8YV5x41Iw8pnu8vYoEDyI656Gfg6HrFol3
         qCZg==
X-Forwarded-Encrypted: i=1; AHgh+Rp6XrdcGv2eIDm8grcQ0C9o3Q/8y2Ly/Mpsmh2nlbqEVENdt3QiasZXozedf51DEis8U3cdLa0=@lists.linux.dev
X-Gm-Message-State: AFuF++kvtKwdK96Z/VnYJB3qsO/vSQh4L+K7J8uwzCOAbEg69/iOCbc2
	5nI1+qW47IMQIP9dpc7GDZeDzE5F7Bs3CHAe109XD7/ijG1P+5/s0azCCiyPOwMX2Q==
X-Gm-Gg: AR+sD11lThe2THc15nF2w+d08EqqOF87+lHkqahG6K/6vAZ2quhuo0m9iwQY8w3Svj/
	cJ9ZrJGbeMKuhx7KCko6Uqtz+uJAxWP5FZjh8z2agFBJECP4KObNlD7cwoDZVd4lxUT+2cU+C5w
	hC014cmIwp+KlDEgZ2InjWU1KLvUk353dMKgyZgUQMD2py79Ot1MpfhJAIY5f0Wjbk7ATvDVfth
	d2R1KgQoDoqmr0cVy4Eb29Ahouev+SYY4vLlQa68xfHNxBvI2fQxH/4ZbyzMeZP2lOAgq9vpUF/
	5zRl52T9pDnn7p5KW46OsIfMbDZntzSqK1zVogaNfxPZowpefg7mpMt3hj4xJMBDQxFHkKtbUbT
	rKAiWg43y9Q0mz8N0mNRdbswMAy5vSdCx5nk3b0DDPl+mpW+wQxZ0ooKU4kMJmtSEZURY9NOgGk
	oKdolSHq/oBYG6pl0zB2zZYtv/gjiggFoHKKtUII/8HmKr8cg1MbRiRuZuAxQilDl9cGxLLp7IN
	Uo9nId6vMHG3B2uQNTTJ/3cs8mNmHClix2qWQ/6
X-Received: by 2002:a05:600c:c0d3:b0:499:cfeb:4f17 with SMTP id 5b1f17b1804b1-499dda22aedmr502865e9.5.1787734464271;
        Wed, 26 Aug 2026 01:54:24 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dcad2532sm19052725e9.11.2026.08.26.01.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 01:54:23 -0700 (PDT)
Date: Wed, 26 Aug 2026 08:54:19 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 23/24] iommu/arm-smmu-v3-kvm: Enable nesting
Message-ID: <ao6puxVSNsLC8aql@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-24-smostafa@google.com>
 <178769159057.3356902.13161185498161727294.b4-review@b4>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178769159057.3356902.13161185498161727294.b4-review@b4>

On Tue, Aug 25, 2026 at 05:59:50PM -0300, Jason Gunthorpe wrote:
> > [ ... 129 lines skipped ... ]
> > +	ret = smmu_attach_stage_2(&target);
> > +	if (ret)
> > +		return ret;
> > +	hyp_spin_lock(&smmu->hw_lock);
> > +	cur_valid = FIELD_GET(STRTAB_STE_0_V, le64_to_cpu(hyp_ste_ptr->data[0]));
> > +	target_cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target.data[0]));
> > +	target_valid = FIELD_GET(STRTAB_STE_0_V, le64_to_cpu(target.data[0]));
> > +	if ((cur_valid && !target_valid) ||
> > +	    (target_cfg == STRTAB_STE_0_CFG_ABORT)) {
> > +		WRITE_ONCE(hyp_ste_ptr->data[0], target.data[0]);
> > +		WARN_ON(smmu_send_cmd(smmu, &cfgi_cmd));
> > +		for (i = 1; i < STRTAB_STE_DWORDS; i++)
> > +			WRITE_ONCE(hyp_ste_ptr->data[i], target.data[i]);
> > +	} else {
> > +		for (i = 1; i < STRTAB_STE_DWORDS; i++)
> > +			WRITE_ONCE(hyp_ste_ptr->data[i], target.data[i]);
> > +		WARN_ON(smmu_send_cmd(smmu, &cfgi_cmd));
> > +		WRITE_ONCE(hyp_ste_ptr->data[0], target.data[0]);
> > +	}
> 
> This doesn't look good enough, a driver can't safe writely to a valid
> STE in any order like this, and it can't make it non-valid or risk
> breaking guests. We had this bug in linux already, the hitless STE
> update in the hypervisor is mandatory for linux guests using PASID.

This piggy-backs on the kernel algorithm, as described in the comment
in this patch:
+       /*
+        * Summary of each host emulated state vs real HW.
+        * |    Host    |       HW      |
+        * ==============================
+        * |    V=0     |       V=0     |
+        * |    Abort   |       Abort   |
+        * |    Bypass  |       S2      |
+        * |    S1      |       S1+S2   |
+        *
+        * For the host, any V=0 transition is not hitless, all other permutations of
+        * (abort, bypass, S1) transitions are hitless.
+        * For the HW state, any V=0 transition is not hitless, as all the S2 config is
+        * always the same (ttbr, vtcr...), all other transitions should be hitless too.
+        * However, the host is not trusted, which means that any V=0 <=> V=1 transitions
+        * or any transition to an abort STE we need to enforce writing order of the STE
+        * dword 0 and add CFGI.
+        * Otherwise, we write the STE in the opposite order to cover cases from abort
+        * to S2 or nested.
+        */

So this way, the hypervisor doesn't break the STE and keeps the host
STE transitions hitless.

Or there is an example that I missed and is broken by this?

Thanks,
Mostafa

> 
> You should use the STE programmer logic from the main driver which
> gets this right for every scenario a linux guest can trigger. I don't
> think there is anything about it that would be difficult for pkvm.
> 
> -- 
> Jason
