Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82EF531AF9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 14:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173968; cv=none; b=Efr4fIv6/l8Z2gxaCc+7fs1CYUQsIKmWll14V+5M/c5hmueFAWqYRG6sHb4D5Jog+RBaCfNx7KGZsPie1mDUSMPKsBGc62fQtinm3EMcvdymI1G8FUH9Ir5a3POVy46zM/cADjdNgDUw+dXsAdR5oD756F/C3Ewfr8lXQtXMePA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173968; c=relaxed/simple;
	bh=S7rAkPuZSZMbYQIfkDVKURs4Ono2lI5WQLQVCr5CGDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxbxLWA8wNrjdzU5mhH4nrbeTq7BDMzeY44+rXgdtJ3Lhb8tk2xDwBhNPk5ZZdm0kXPExkGzDLzeg0ZxTOp1AcouhjHPJjRKIFWiiESjJUVCnWLPl46THcft0zsdJrJQjCw1UQXqgOgqbGPv/V6eAmcitMUxEeoucKUK5BtVJvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lo90lvrx; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lo90lvrx"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39b5b07ec78so571391a91.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 07:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1790173966; x=1790778766; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7rhO8zdKOr8jmD+SfzN1wHrIhUden50az9FhzT+ZY8k=;
        b=lo90lvrxCDZsiMQsdk2e3j4WWLuWyGrLDc2sVpOKphV04WLX7Xp4XnJ8DtZLzxy5Op
         zZbJRYdET1WB9J79NHJbFYd4SkK3SD0lC3Jtw4/wkwIJZKdpwX0zL1OfzkhHuEA4NsK8
         7joADV3MS021FicsPtynqpsQ7pIPBWowYojyNJIuXHyOGqobus20nwZqg0B63zqgqDF9
         sNMRmOF6w6p3jBfFjxqRmBTAQq8y0UWEUp525LE21wZNtp5aXYWv5ldNeKPBDcpWG34I
         MYOZz/poQhB71zewNLjP5H66CYQMoPWbO2ADECrNVugYhZJK27n8xYseJJ3KOvpSluW8
         yuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790173966; x=1790778766;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7rhO8zdKOr8jmD+SfzN1wHrIhUden50az9FhzT+ZY8k=;
        b=d1lpZB5Uik/VTpcd2fUx8+0NMm4F9UF39CdNV52BP1QM4tTCQZpAUtGJ1YxJpO0Q67
         lK45qMKOYdK98pEWVxm9qidnBWVAvCkIyDWiEhsPIQN2QRDySOB8kiJ7mcaCX/Yqxehk
         WhQRW5IPadOITFY29xNKEnbbks35lf8ihxqXljN952debCh3TZ6rlRVMtRN3XBbwCmE/
         OIx0MuGuMy0tk2Pi2PeXkUoAGtaWxrbxjzXu28CdFP5RMB+JcuD9dLmM4TNyCxW0IcmI
         4bP1O7kkynN4nd4mvu58g1Ssl0i8h5fwktO5W3ED0vHKuOhp4UFXfX+YW8R+xuGHKpoR
         1oiw==
X-Forwarded-Encrypted: i=1; AKwUvBzODXxVHevfF6OpYHev6m1VR/OIktoOx8en8YLGCZmUoBPmwdfYKFLG0Go6EFGODSyt66dAqE0=@lists.linux.dev
X-Gm-Message-State: AFuF++m04QGy2SvQvv4ycR9T266yZpc8T1Y1+Jvl7vbuOtfo/FgfRA0v
	Am7C/uciCM1D0KenwY68MbI0utc5O0MulcW1dy4rLW9WhnBz+FggTFgXsehGgnMoYiM=
X-Gm-Gg: AYBFou2Ht1ds6OVWWKKrZHJbRsPqO7pr6iuhRYSDU7eG4/NamnZQAked99zEO2euMfh
	bK3z/+uVU86SScAWT4DQznXF2GD7TpNeEKodUIH7a7h24u2v05DOyTKd4RLwTdW33VOYjJr+H27
	wVpvG5qECkLVNYvQb7RvAk4Xf+Ynz8CvTkAjRsw9zOHlT8iLR0f/ajKh+hDEcHTvZVTWBj5W4LU
	hUD0IMuqB1BOB8CtF8W4QjBNpKsxJnh+8ukI9ZkgATg5XhIsNuDSbxCsBwJLO7B3hSHrUyMwwP+
	AGzpCqCeQCrdj25moCewtb87dGGmflQRL4Pk6qPC4N6mxI9OFE8RC4h9KfxFepKxHNpYzpGMYAN
	KDDQntCWzOGwwJmCfd+CBBqYUbOoM60RwemXvwUg3k/wxV5RoXF9NDzkx0DhzG3DbbKcKE6qDJ7
	DswuRtrOO1dHzyJpmFIJOKMWho67pfh5/cAhLc1TuGWrPLqX40EmvEwD5ipj8LAWQwSw9vBpU5p
	U672BUTUA==
X-Received: by 2002:a17:90b:2552:b0:398:9c39:520f with SMTP id 98e67ed59e1d1-3a07e51cf1fmr2382544a91.15.1790173965946;
        Wed, 23 Sep 2026 07:32:45 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:b4a:dc6a:68e:2592])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07db882a5sm5446811a91.1.2026.09.23.07.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 07:32:45 -0700 (PDT)
Date: Wed, 23 Sep 2026 08:32:41 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	oupton@kernel.org, gshan@redhat.com, joey.gouly@arm.com,
	tabba@google.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18 00/23] KVM: arm64: CCA: Add basic plumbing for Realms
Message-ID: <arPjCZL2IfvTKMml@p14s>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <aqrsmUTxDVbKJn8k@p14s>
 <yq5aecel3aj3.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aecel3aj3.fsf@kernel.org>

On Tue, Sep 22, 2026 at 02:52:56PM +0530, Aneesh Kumar K.V wrote:
> Mathieu Poirier <mathieu.poirier@linaro.org> writes:
> 
> > Hi Suzuki,
> >
> > On Tue, Sep 15, 2026 at 05:01:18PM +0100, Suzuki K Poulose wrote:
> 
>  [ ... 42 lines skipped ... ] 
> 
> >> 
> >> [0] Arm CCA KVM Support v16 : https://lore.kernel.org/all/20260803134403.80630-1-steven.price@arm.com
> >> [1] Linux firmware RMI https://lore.kernel.org/all/20260912083611.2513845-1-suzuki.poulose@arm.com
> >> [2] Linux GPF Host https://lore.kernel.org/all/20260913070459.2547407-1-suzuki.poulose@arm.com
> >> [3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm-v18/integration
> >> [4] https://support.arm.com/documentation/den0137/2-0bet3/
> >
> > When testing on the FVP model with the above baselines, I get the following
> > error messagaes in a loop, preventing the system from reaching the command line:
> >
> > [    3.112577] Freeing unused kernel memory: 3520K
> > [    3.115398] Run /sbin/init as init process
> > [    3.142926] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.150111] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.177190] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.197194] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.217188] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.237194] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.257181] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.277189] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.297193] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    3.317188] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> > total 512 (slots), used 511 (slots)
> > [    8.157185] swiotlb_tbl_map_single: 241 callbacks suppressed
> >
> > I get the same result with v17.  Have you seen this before?  Perhaps a kernel
> > option that needs to be adjusted?
> >
> 
> This is due to a change in the swiotlb setup.
> 
> https://lore.kernel.org/all/yq5azeyxyfol.fsf@kernel.org
> 
> You can increase the swiotlb size using the swiotlb= kernel command-line

What size do you recommend setting it at?

> option. I also have a patch series in progress to address this issue:
> 
> https://lore.kernel.org/all/20260921063628.362078-1-aneesh.kumar@kernel.org
> 
> -aneesh
> 
