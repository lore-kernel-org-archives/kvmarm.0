Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3FC41A91E
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819351; cv=none; b=t9wXdDZP9dlPkscXKUmS2ofbzdPgSV0mVb2oFsEUgOrSS6ft3xtkl97dVLIBbibQh+T48oBh5m89zusPBFobMtSIpqA4sbv1Kryq/MpScgDW8XuUpIAYZLyeK6Oj6VjktRSNpKCm8I+GRtFGqHjOAa1BC8ATg4n2rpbuacdVeyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819351; c=relaxed/simple;
	bh=efw0zkldOCiZuk8MV01/HhWeuzRFAtq1W72SXKLdoXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAj5MXVV/sPzl2KP5jI1A8nV2EHsUUquJzjFlpBwUwaYteOPHRAUeidzFaVTCAVtXLNkYrYFhC2/elaoxik6J/KtxrpS6REg6Hf5ySG6HFGl5A9nFxOfw+6ikVE2W/YVeijBX2OBoJ26zHUa87+Ng+JRkFG+KG/zXt9StXfJkwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y769Ml8k; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y769Ml8k"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so8451805e9.2
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 08:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784819348; x=1785424148; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aFVBl33WZjlrrClLf2eJDasfH3PHHFJ/uyhHT7PEFdQ=;
        b=Y769Ml8kkKJwtgZgFPTc9RcTZ/N9kyfVaXPFh210yn1htclxwJKdeUEGWxd2Cm2qDT
         Drere9OWcRuQNZLPeHn+eeGHAqWI0pPJsztB56Mkg2eZFNzGx1LyISyjyhmiuV4g4RLw
         cG9Veh7Z02ZG7GuaO5oTzNfx9+POWxDusuGvN5lbHHzmI/kDyeT+BdCgTmZy/9BPbulK
         R5ZGg9ZWZCfxhN4ul4r2umnUJ9K5+pNc+KrcNNmIWYFzGTWf8B0j9J9NfJIfThGPymU0
         D0tWbPf2dkHU4E27WdZFpinSabhPv7u9PfIHshODhjefUdFqf70h7jUk8KvUU1iGUv2B
         eX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784819348; x=1785424148;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aFVBl33WZjlrrClLf2eJDasfH3PHHFJ/uyhHT7PEFdQ=;
        b=qO/VxIIvnFNbzIGUGNd36+TxYQ31UXOJMh92yBfwwREDVSk0MY1Cy7PAri0uQRW7w3
         YFToUvk8WykcPYBABr07fmRAdPr49HCE4rQdw/MY4gKgZ0adIlYnIFFLzfbHUPAc6+Qx
         k6pWDJW4hWvBND652Iy1h/PuYRceLfbsufGZTrSCieC5BLhsnoItlnFkvZNbuz6CKc4E
         MgB17kNv4rNC0iUpmYd86qEjZk5iTdzNR4BEQgAGKyA7UGDH8cF+liP3wmWTwZgyFpMB
         l30Ivf+HUNHDyeRJ2t183tBmCyJf1+5H0xq2/0l7iI1q3e/5gu+0LGnZgW4F9d54RrsX
         pm9Q==
X-Forwarded-Encrypted: i=1; AHgh+RqxMxi+PgPSa8n4Gk+O33SVbUGIkrVDK8T+pV835omraXvi1c5GM9HE2J75txxFXbwvuKAk5Es=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwYOlSS/Ztm19hGkHJyIOGeiioFAEMKvco6aZf221tfTNY9QCx
	fkkbu/RQ0QD4rHQDA6TJVpDD6B0ivSvINqXzlCsPwOhZkGOrQxAtBL8nZDR+kqpJZg==
X-Gm-Gg: AR+sD12OfCgc/X5ziYIfP4tcUe8snWWtZlbQ85awriNNfBGUTF+a3QPry2ddCe958Fv
	3U2Ai8ltCpOgjZWMqiJoUJBJwlD3ACGccapeFS2Pd5rkXzP1tCt4sEwXF7tAxLxD/ISfquK8rnN
	NGuLtHoBxOP2cpVDzHELKl+rrOHQx6k1W8IlSPEHCZIvie8qJGmArKP9zEFYe7n0S8pGo4zljvR
	qteGKpAwXebrooBFYxxD26kMHoXZUYYOP2YD6Kx6Uz2evkYBr2sWC4VUQikVdqMskqEZbt6Fc5o
	ks3Yuu2inNMgH+2LxhGPeHO9tGL3jmFo0WbahlqDMTSQivahTE0AjCb8Djrzcq22B6xbvcRoDjr
	juAvA7WCUh+McRGEA/CANXo7tzjVp3RsO0qj2lJhSs92eQpi/wwJA2LRHmZ6FemRR8aHZUy9128
	AkXxDzlSLpt6kmjL2ZRjKyZQMUOdmdazLyCyuG+gKPdro4eA==
X-Received: by 2002:a05:600c:35c4:b0:493:c337:db0e with SMTP id 5b1f17b1804b1-49573cffaf5mr42992395e9.18.1784819347016;
        Thu, 23 Jul 2026 08:09:07 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956b043727sm100788465e9.4.2026.07.23.08.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:09:04 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:08:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v3 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap
 allocator
Message-ID: <amIuh8OZk_xuk6_k@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-14-vdonnefort@google.com>
 <CA+EHjTw7t6KHuQwktNN5_dJgZCxeWejcoQMz3pe6wUuS=R+QtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw7t6KHuQwktNN5_dJgZCxeWejcoQMz3pe6wUuS=R+QtQ@mail.gmail.com>

On Thu, Jul 23, 2026 at 01:14:10PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Mon, 20 Jul 2026 at 18:15, Vincent Donnefort <vdonnefort@google.com> wrote:
> ...
> 
> > +static void errno_to_smccc(int ret, struct kvm_cpu_context *host_ctxt)
> > +{
> > +       struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
> > +
> > +       switch (ret) {
> > +       case -ENOMEM:
> > +               req.type = PKVM_HYP_REQ_HYP_ALLOC;
> > +               req.mem.nr_pages = hyp_alloc_topup_needed();
> > +               break;
> > +       }
> 
> Sashiko raised this in a different patch. This turns any -ENOMEM into
> a top-up request, but hyp_allocator_map() also returns -ENOMEM from
> the pkvm_map_private_va_range() failure path without setting
> topup_needed, so nr_pages can be 0. The host then handles a 0-page
> top-up and the while (!__ret) loop in pkvm_call_hyp_req() just
> re-issues the same failing hypercall.
> 
> This might not be reachable today, but could you make it so that
> errno_to_smccc() raises the request only when nr_pages is non-zero,
> and let -ENOMEM propagate otherwise?

I could also introduce a HYP_ALLOC specific ENOMEM? 

Otherwise, yes checking on hyp_alloc_topup_needed() sounds alright.

> 
> Cheers,
> /fuad
