Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E19647F3B9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790203374; cv=none; b=XirivaYQ4lbIDBgG60yL+t7Sg37/a8kJmkU842K3M94yiJdnmCj6llAY39VLjMeRXzvm9+6dQeiOEUhWQlPnX64J+F0L6z7080fCuQnmbzwIVWX+tcb0yp7GSowM+Czq2aa3kT9KidnOELc0qVzAOSVjQ0UpWWPSHJjclcdlCIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790203374; c=relaxed/simple;
	bh=XC0GtZzu0BD86oQ6ghzNMhSkH0mMeg+u7BsmzLp0cIw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FSqRlU4ksBBjBiotznDgo+OZRK7WXDC1U5n7xM5aRWR6FCAYKiqnOLA9OAXPc3Ddmmo0PcYGWK7goUsbmz2XN/ed2XTcnIKBg32Al5QmFtktOGBpzuk24JU/yLdpoRqiqi0qb+4xnInd0YImHR20vWAogHkvbILjun5cBKd6O4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sBqMFvkR; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sBqMFvkR"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39deb05ef51so1468541a91.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 15:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790203373; x=1790808173; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c4ROB5gmPay6sdQJPjpG61DXTR2zRREmvWIvdqy7Ui4=;
        b=sBqMFvkRA37HrnNq8h2fpHv3da+MinbKcJC8lurwzycyrz0603ZCzuGl+8m8bKkncU
         R2TOGg+5jyh+ZCGso77rtmewz79bPN0DubMhynf+q5c59Gi2snd81KiU5y6REAjBFhzZ
         xZ8EqUfH9NPb/ZFxDvorI7hqc3dcmq8xBA+yUH5Vgt515I6pG4EzAmshYwjcSsswUBQy
         vNGUoN5plSWYhAGnBt0EJmK4DeC1GhwhVy1flwXuJT7O5sWotrH3T4H5C6fs13Ps9v/5
         Xnvw+XVuCWejHlX5RwfsjXl5MnSwfBvbHdG7sgsSqAHCJLDlqLzO56D5lDsFsu6KVCPc
         yAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790203373; x=1790808173;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c4ROB5gmPay6sdQJPjpG61DXTR2zRREmvWIvdqy7Ui4=;
        b=X17XtCwb82j1Lo0cIAg0ZU6pCpLABxlJpr19TDhA/aUlusj5oq1v8IneEb8M2zIzui
         OL3zX9eshQgPuzxKvRFmNccxssayadjzxQzgrmeRJMCuG7b55Sk6pxBrww4e9fT8PojS
         E46wZ+AXFugsQ06C6eA96Mz8NWo0imakFGBr3FWqhcW3j8ikkb9wwSdJMLl4i9+9UGrs
         A1Uvog4fqazE7tTnlfZrmcGZH+PBD/nGyVDa7yH6bHgy81E3xbdqyhW1N6q+D4P+LyBp
         3PT/MtwN5SyGhT8oZZ0pRodm5CmEOsg+pjlGU9qcZyfSOn6Y9SkPcY01vD89MHRJ9Qn7
         b0EA==
X-Forwarded-Encrypted: i=1; AKwUvBxRDgcZAZlKtIsnYIcG37VksRBEvewNa2kFzaL5LCZ0Rold0va0Tm8Eov4I35gy5yg9261jD3w=@lists.linux.dev
X-Gm-Message-State: AFuF++mUKAtZuLFb/Im6FTG/JpVXRqV3saISYm5oy+K63HAlDfNoX4E/
	x9QSS9IZsEjwHnD+VWIWqx2sByWCHQo8Dlb3gNU3f95bRKY/u7g62K0C+rM4g7aD0/luzSislpe
	9A63ihg==
X-Received: from pjbbh7.prod.google.com ([2002:a17:90b:487:b0:3a0:8315:fa7b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f87:b0:398:a486:81ec
 with SMTP id 98e67ed59e1d1-3a0985b8f01mr435176a91.11.1790203372353; Wed, 23
 Sep 2026 15:42:52 -0700 (PDT)
Date: Wed, 23 Sep 2026 15:42:51 -0700
In-Reply-To: <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com> <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Message-ID: <arRV6y-d1rkRV2Fa@google.com>
Subject: Re: [PATCH v7 06/10] vfio: selftests: Allow drivers to specify
 required region size
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Leon Romanovsky <leon@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Mark Bloch <mbloch@nvidia.com>, 
	netdev@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 21, 2026, Jason Gunthorpe wrote:
> Add a region_size field to struct vfio_pci_driver_ops so drivers can
> declare how much DMA-mapped region they need. The mlx5 driver will need
> ~18MB for firmware pages. Existing drivers pass in the sizeof their state
> struct. Since drivers all use only their declared state we can use the
> value directly and remove the SZ_2M hard coding.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

The KVM test still runs, and in David I trust:

Acked-by: Sean Christopherson <seanjc@google.com>
