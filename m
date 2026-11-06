Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991209;
	b=uTGJf/fmKz4vxMuL+VbuD/fV7VyBP4iDR/UFA8bhwB/TAceR3kkD7zObw8UFWH+BJVcl
	 iCFD7p0GjiZAroxcuTesF94dime/O2nkUOtAgF34vcWdQLov1qm4xEViMTpCTPXtUIA9w
	 VCCqsTzloGitOxjMRxk1WAtqlcB+ctoEmlAORM/v5suuX4C5NgYXtPwi7gfYggaccIljV
	 3pndVksi6w6BX/DAlEF924P9Ehb4IEZCjE0UUys141IgCi/+v/VJSz1enUDeh0gpZcrbC
	 ytPG1vpEm7ICRo65uUuegF700e3fB6WhVO30ASVe+BOFOzEaCGR/+ZN38amng8L5Rqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991209;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=3owYrI/0Z3GKKaUgbIZQvjxUR9mSehq81egiU0Y2vio=;
	b=QLx2Aa0tdkkeWj83MPxM1mk7EFjrnmNNks3tTbcVpimfzZRFJxuZ48xYo5edySeo4+Mn
	 59kKcTnAXCHUKePwInFDGeiu5wBE4zUnZlFTY/JjIToIuvsnNsVCeDNchQFWQfCI9Ta73
	 A8zOXd2RkwbqdeepYwOdvDh+4h+YW17QQH7zwH9Qjs/Dpax79PfWcSV3RliVlqBHtmypy
	 XFzrprFExuHPF91GK84iHk3O28XnSFSnBocJyZXso2vZv+UYuNqiLClNF3tb2pYfOVFxi
	 Kxsyi5SffwA2iXd2p+P2KRPRCgQNHLtpJXaODlUjplgWJmCI74H8Znz2rC8o3//07vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ULizpemV;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0CA606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A0CA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ULizpemV
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso9268775e9.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 10:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793991208; x=1794596008; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3owYrI/0Z3GKKaUgbIZQvjxUR9mSehq81egiU0Y2vio=;
        b=ULizpemVu0G8RjzOdA94a2v7k+N7GcHEhMRXTscuvwVfmMs32uD1xXVWKBNcoVZosB
         eMkDZeElIaDhOOnguYXF1hJu25jyGl4wXAqHj8ZH9jdU/zdtv4/t84zAd0cA6uqqDMGo
         owvAP4IR38EYyYy4fqUowx2y0inif9RQKWFamLPDnHchS5xedsuyOZnGc2F83k9drPU8
         PlVVesHCR6ISB1fvCB9GOcFd4esaPh+ejfM/+1O4u7OQ2cYQTFr0D1atJTDmWKgc5d4H
         X+bJQ5vj/RMEAyNknT3pa4ISjl4Tt3iYbOriiGBCP2jJrbsLfYh8J1V+zL3VUb7bffwU
         dj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793991208; x=1794596008;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3owYrI/0Z3GKKaUgbIZQvjxUR9mSehq81egiU0Y2vio=;
        b=CXFzlVsCIEW/SqA+G472lmSzYE9S/xYf2QwAmXhBFPafA89XiInqiUb2+ynSzmiHQd
         NW2Dlj55SIF/LJVvnvYSRTGtDa6GHD7rKECQiDhQI4JmppxOG+8q75GqKRdSUuzoQOVH
         TQivX41kxF7n9W8a09D7cLxrynkYntp6jzpYiBONtEKrZo8O8+QPXkS2HHBU3SXsOPrg
         Mpm92fxoTM7fH97xAHt8dijLc7zk5sLd4JNR2s21PtEws6WDRds8ejRvW0a7C66pW8US
         APGei6RdmGlt5XsD/kOsA5MQds41gqtgMDxlKZQ0xgMXebXDvFSUukWUPSjosbf8EqIC
         heHg==
X-Forwarded-Encrypted: i=1; AKwUvBxW5Xj/+AR/6Tcq/ekbbsSzsYX+k2AvaITHm7VYKCaruxoSFF8JA8XCINJhMeHdreY5Ab6ur9A=@lists.linux.dev
X-Gm-Message-State: APuU4Z/LWPT8dHYdIRhUFSsIFslPwWqMwlSDXYeO15yIEC3PdrCKlDdH
	lQ3Rth8WG77o+2d4NpYlqf3trpGuWeqYq15dBncZNpqhSt43vBB4arEaygiqlDBd/Q==
X-Gm-Gg: AYBFou3XSBICIT3AckygksRK4O4u3BlItyyV0O2ymX9Aa6W2W8mWptRoFzJdT3Dm2lB
	407MuRFDp4XuAC5oNZyb1antmc3IbX+tniM+ZPV6r0YRf4qgeaQs4SWOAFKZrgYZKmOMy5ZoeFY
	JzL1fnMIIQ6P2bZRiX+CcMSE9x0blkQO8OTBTo+eh3SshYfmuP/jzYSnvnA8LPJhwdHeqISL5TC
	eyiLbnForInHTGsPrOVe0niVSaNtL201rIPEFpsosrOve/Px3OTv9ITO9pWK84YgwCXKojJR5Wk
	Htj0J6izmQCHR1pIn+sJDeK7X2U9PcAO3aXRiUfyzXmz8SGJ1dcOaODhyPrSn1tCiHK+U2l2BOG
	iQzBQyuvoZiJVCqH22p7oTdMMSiUURjm4ak/Ovyj+PjGdlb020k/3Vx2q6kI4OMF5vtSqde+DWZ
	qjyAbhNR1m698aml8Y3/zC7ARfYaAlf0QMtnyytMNvJ+AycGbtO7eD8Nao0pwr3nMhJJJ8cCcCr
	xU2DvBjre9qBHgP8yhjHuqelHK6FuKZzaJMjopV87+QW3SkJgPVRDnrOu2WeOTi5PHiqSiCO5Zy
	JBf2A5sjdCk9rNGu+BX0SsMWVWdAF86tgAoV4h62B5V1a1hu2xUEwlGXOwemZP/hyQ+FJnId1DM
	q8l4304Er3Q==
X-Received: by 2002:a05:600c:1914:b0:4a4:7a8d:c436 with SMTP id 5b1f17b1804b1-4b6de788f5bmr58350415e9.11.1793991207222;
        Fri, 06 Nov 2026 10:53:27 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7da62ecc1sm626645e9.2.2026.11.06.10.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 10:53:26 -0800 (PST)
Date: Fri, 6 Nov 2026 18:53:21 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Xuheng Li <xuheng@cs.columbia.edu>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: arm64: Don't replace a valid hyp block
 mapping with a table
Message-ID: <au4iIai1DiXaPQiD@google.com>
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu>
 <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>
 <CAPOPQMB6eU0MYNewcq8HKsEMchwY-X3aT0Km9uULBappFWZcjQ@mail.gmail.com>
 <CA+EHjTz-R016BwhcptZ3xVQe+a8C7au6ZL8jwZANdTf=cXRZHQ@mail.gmail.com>
 <CAPOPQMCQfYWRDRvo4PPFW0RAyqNmns6TqS+QYE3-5SM_NFRMQQ@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPOPQMCQfYWRDRvo4PPFW0RAyqNmns6TqS+QYE3-5SM_NFRMQQ@mail.gmail.com>

On Fri, Nov 06, 2026 at 05:17:54PM +0000, Xuheng Li wrote:
> Hi Fuad, Vincent,
> 
> On Fri, Nov 06, 2026 at 02:34:55PM +0000, Fuad Tabba wrote:
> > Actually, like Vincent pointed out, why the WARN_ON(). The caller can
> > just handle the error.
> 
> Makes sense, I'll drop the WARN_ON() and just return -EEXIST.
> 
> One thing I noticed: the kernel-doc of kvm_pgtable_hyp_map() says that
> a mapping over an existing one is "rejected with an error and a
> WARN()", and the leaf case in hyp_map_walker_try_leaf() still warns.
> Without the WARN_ON(), the comment would no longer match this case.
> By the same reasoning, should the leaf case's WARN_ON() go too, in a
> separate patch, with the comment reduced to "rejected with an error"?
> 
> Thanks,
> Xuheng

You're going to make me regret my suggestion about removing the WARN_ON() :-) 

Indeed we should probably align the behaviour.

We can indeed drop the WARN_ON() from hyp_map_walker_try_leaf(). The if
(kvm_pte_valid()) you've added should catch this case anyway. 

We can keep the WARN_ON(ctx->level == KVM_PGTABLE_LAST_LEVEL). If hit, that is
an internal error...

I don't know if that warrant a different patch to be honnest... none of that is
fixing any existing bug. But no strong opinion.

-- 
Vincent
