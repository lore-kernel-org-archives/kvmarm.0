Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223813;
	b=fMT9EpGxJ4Y1Yox4QKYFPIXcVHTUM8KmrirIBU6ndyj9A3Fx8ADk3hNke4BJRe1ZUEAS
	 umuOTmlrdex95tuF876pawa5Hh2W0zpsAGPx/ROATkauwRqsRz2Na2NhdjUbfxXiEHgau
	 7pKPrrWfGFiZJO8lLVHzSPGiyP+knXQJDaCja9azr6qq311RQWr3+/Q/8NUgLUzNTdvdS
	 BFEN1uJF6bccpMorgR4ZdWIBvXsUrtuoE/IRHRcAoYB1fSRyhvHZHGccBlRiaJ4JFgma8
	 bfPkX158LE7rvEifJ4khtyGjCxCXRq1Zi/3ZWigBZZFH1sfwyBKRAGQUHX0KpXxRyrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223813;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=OCgYpXH58qINyNwsYRskFASB4t/CiniG84M2T/tv7W8=;
	b=ZWXfL9MOoZf693wDtxm5D3las2/GEtj1Vy9ZlxpRZcTsJOu3JG/MG+SGqxJ1e4dkzEuJ
	 7VcmAbJtcTKF6n4/y4uAYCkf3KenDY6/MZRNpWpX9V15Qdsh/q3RjVB2zrkkK1+8B6gwO
	 MMYQ/+SspWJOW8XswsUvAHsr5OTWKGnntGFDijmzFYsrehoW554VoXSz/7wEpGcBFi62R
	 ha6/EhpgY1+XMGKhEAFms9VeQMfSDFG/IXyBY1WcipxDolz4uecwFd/w7z2nM1pmFpMyR
	 KMipddsWcLetRJkj+zz5i/uz3vIHVZv1nttmrZhFMxC8DfrU1zDV0H2UnFFklu4z/yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NjRidnRb;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AEF606A335
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 11:30:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27AEF606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NjRidnRb
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso30515e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 03:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794223811; x=1794828611; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OCgYpXH58qINyNwsYRskFASB4t/CiniG84M2T/tv7W8=;
        b=NjRidnRb8X9XgX/33qA2B+lmiIH4TzJ/2I+SM61HjFzCp/+z/Kam6Ue1rQ1+FkaXFa
         oqWgqTPk0PhM45l1TDPuF8TLtT9itTfwoNjzuQw5HY0WgYtLGzTBYzCampCEFZMZ/exf
         qnBEtHNNU/g1wFJmfiKamrt49ThdhyiBx7i8uI2Nlx3mjHWtfHEKpEtO8Vuc26VESw6O
         vO6yijADaWHM+3DjoO9Q73wHOVbQmOSsZ120f5LdfbE/qCnP/X8op7tfd3G0PkOTJ/YW
         emnbShFxgjrODqNiZ+VrV5LFL/wcYBF+xBtv2r9ExWbDiyQ65n6d7QTk8mNTkUU5mxX6
         7YyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794223811; x=1794828611;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OCgYpXH58qINyNwsYRskFASB4t/CiniG84M2T/tv7W8=;
        b=N0CXKSlPnGwFILR8go+ekY1zlOzj0KVfCeu6bnUyANAD1Kf3X1GDruk5Z5zQUhX1sg
         /gqT3G+TbM9pPyDm+WFkR0Kc3akcDYnRJteHefCOwZAZlwOFAZN5SIdjgQ37aQ48hwz5
         iOWTtVi0jnaEwK5YrCOEgBtw8EBIg8XCW/vxV8aqx81cOjdL+oMu6QE38Xp8Y4u28wAM
         Ze7GDtX6mX+TOaRK6CUY40v0dxxO6lK/JBgFz3GB7cvmFkkjw4CBtWNoIhIJiWBHbSu9
         ZPZJVpy+g3n1sxtoi9UQLb+U8j8lo1+QlD0IsVMPjZc5sH/WQ0AMr1Oluvjva9MX4bte
         vflw==
X-Forwarded-Encrypted: i=1; AL+hErFRKhNE9H1BKMzstoSFkC9RmKz2ugCupkjPSldiog/Mlz8U7/VzAa2iW+OJwkEh9C6woNjZ7cY=@lists.linux.dev
X-Gm-Message-State: APuU4Z+RTP7VpnkQ3w1V6zrY22pXtUpMipS/XfzyQObxxSW8iQWRDfDT
	y/1NL9q14DZKkzSy9CYNkoRraDFpdf7F6auPfrVevc3h+FYXtOr9NBFRmAatMmknWg==
X-Gm-Gg: AYBFou0d0YLoFBJN2TbK5P2vQhoHHjPgvYif3BCDFScQrXS0yWc9NGSZRYY/ccHtQgy
	41u3ArSAp5msQ3d7Q3RuVE96Xx7hAT/8ciwTjkaWpKZux7WKzoe/wp5yadH6w7uZnvLhXtwvBeO
	UCQe8azFltAhX6POYUbr4q3i2na4cLNdLKBp84wD9Hpr2kJrEnhygvMxAth9GOTO2biZVKIjvD8
	ewKdVHsneNsTOxNE37W3kp2s04FDeOfOUNIT6RWisQYFrcBNUqrJowVhgkBhEuHK5c0ybmlBLqF
	l5rBT2zQSFRiTtVT993lsVBPyKY8ereqVumtyA5IMOb/N9c4yDt8b3ciWeYFlCnZ5M7UwHukAiV
	qCNGwju9WKPgeiqLSUxmbB9rwEMDXhTxHZ2dL6zs8TqiaTveNn99mkoDUiuHk/eMHHovdtp/6ow
	YgWpR07Ib5Sxs7xdPYg6+u9oO8LbulgyUZAUc1Qf6M5KgGihVJ4opjEIjGO4Ng9nZP7UIrAZjb6
	ZMncn2ej4sc7lrgBQt78ttolf8qEEUP/xRePvdcomQzMTExaI6NYJ8Xyq5TX3jhHmonNcnqWdpb
	oZ2mmZFjaImOj3FTQSp8/cL/fq9suaJptrTL3pckXpFI7xwiKjDYzJo=
X-Received: by 2002:a05:600c:a599:b0:4a1:9c54:1853 with SMTP id 5b1f17b1804b1-4b8190fb89fmr1464795e9.5.1794223811041;
        Mon, 09 Nov 2026 03:30:11 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-495974660bdsm8966088f8f.37.2026.11.09.03.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:30:10 -0800 (PST)
Date: Mon, 9 Nov 2026 11:30:05 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
Message-ID: <avGuvQ8uiYRGitkj@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-15-smostafa@google.com>
 <au0XJPD81XkBgpyF@nvidia.com>
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
In-Reply-To: <au0XJPD81XkBgpyF@nvidia.com>

On Thu, Nov 05, 2026 at 03:54:12PM -0800, Nicolin Chen wrote:
> On Thu, Oct 15, 2026 at 08:08:45PM +0000, Mostafa Saleh wrote:
> > At boot, allocate a command queue per SMMU which is used as a shadow
> > by the hypervisor.
> > 
> > The command queue size is 64K which is more than enough, as the
> > hypervisor would consume all the entries per a command queue prod
> > write, which means it can handle up to 4096 at a time.
> > 
> > Then, the host command queue needs to be pinned in a shared state, so
> > it can't be donated to VMs, and avoid tricking the hypervisor into
> > accessing them. This is done each time the command queue is enabled,
> > and undone each time the command queue is disabled.
> > The hypervisor won't access the host command queue when it is disabled
> > from the host.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> With some nits:
> 
> > @@ -23,6 +25,15 @@ static size_t kvm_arm_smmu_cur;
> >  static void __init kvm_arm_smmu_array_free(void)
> >  {
> >  	int order;
> > +	int i;
> > +
> > +	for (i = 0 ; i < kvm_arm_smmu_cur ; ++i) {
> 
> s/ ;/;/g

Will do.

> 
> > @@ -158,6 +268,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  		break;
> >  	/* Passthrough the register access for bisectability, handled later */
> >  	case ARM_SMMU_CMDQ_BASE:
> > +		if (is_write) {
> > +			/* Not allowed by the architecture */
> > +			if (is_cmdq_enabled(smmu))
> > +				break;
> 
> Sashiko reported the same WARN_ON issue. You might want to confirm.
> 

I replied to sashiko about that, this is by design as I also mentioned
in patch #13.

> > @@ -170,9 +288,16 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  			break;
> >  
> >  		if (is_write) {
> > +			bool last_cmdq_en = is_cmdq_enabled(smmu);
> 
> Maybe cmdq_was_enabled (local) and cmdq_is_enabled (helper)

Sure.

Thanks,
Mostafa


> > 
> Nicolin
