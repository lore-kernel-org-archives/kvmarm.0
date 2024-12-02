Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4121FC0F1
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 10:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733135172; cv=none; b=mFgARZh0NyQkKN1kOFqeC5JoI+getx4zkoR0zv0KVZaWNO8QATBBhqDp82leV/PUo/GzYoF8bQkLLoxUiZCe87++iExiMe7ihH+eJLJodhQLPqVQ6l17f6ujLElPru58MUaGQYOMI9ghxSKxlK+wJ/lO2cAO5lFbaHr6nI2NUEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733135172; c=relaxed/simple;
	bh=GTRL3tOv9yI/uR8jT7fLuQFXPP2jKrEetAktEreE0S8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSTrnHjJzdivlIVtKfOilKaorKB1MYzEtv319ucAm2QqeKbFmqlfFEgvUZXjNEIEmlukoYVd7isN4ILeVLKJ0WwMnIxtZvxCLaBJXwdPC+P/RX0ZzM1MucVBbPqcOZzM/IcmuONDL7hKUm+ObhzYKk/hjnNGUPi3Qxrol/DbZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cXnpQ8z8; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cXnpQ8z8"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4349fd77b33so32426275e9.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 02:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733135169; x=1733739969; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l5aWGXl+Mmlx1+Ly+ZtHQ3BQuMifP5arQ43M6MMtklc=;
        b=cXnpQ8z8gGugyeWyt8s7oZlF5gVHp69uALC74IjpJEutFkmlY1Q+YKSkLJF5B9zjsP
         PDct3VTzbRH8Pw5yTD3LLjXBh/xllIa7I8s0HqLnZTgmsHIAqeNUofo1A+wUJKovdumc
         CF7bCGxrLdZy0EOHaKAjQLUDYrbYhogwcIgj+OSRHmkdKVRVsAvlf29i1WCnOkySjyZr
         hLQcnDFZ62UTujyRB7pKLinw0X3WpL0DiSj/fGtYD2+7hDQBrQNf294o1oVFg8pK8UUR
         DwXHcTmdu7FqhwQBS8EkMOpuwxTcgEh+hEE73sbqXkxpG6RZt+dsqssezLJ/srBpKSkz
         vZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733135169; x=1733739969;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5aWGXl+Mmlx1+Ly+ZtHQ3BQuMifP5arQ43M6MMtklc=;
        b=jsCIyD14B3swPlO+u/7mwUVJwJj95DHE3rleVlus/El/6Pm5wKmj+/lCfxiD7ocdgK
         aqCYapIEpvE62Z2wnF9Nvm9PE9yma0vE3KoSfdfJv+MjhvN2fq574tqjIRU25ofZEQEC
         gLTaPNvOhuvvM2Rn/9HPjt+z1ZDe2S1ykRBiGPLz2vbE0bfF7m0htbAxvWak4EwatoK3
         O74zWPzk5BEk4ZvkGamCtmHNZ2Bs0/DnS6RNynOmkabzvt9phi8qOGib8KZak7Th/HWo
         Tfnl/HIAamCkOo0UiMntDgN7r7sQfXdxqyGU9qZFr5NZBpNO6Ir/uwwC+mOJpHYy6meW
         36DA==
X-Forwarded-Encrypted: i=1; AJvYcCWnv6IUSIw8TOPTI/1pMRxCKI6eYfGxTHUjt8rcVuQ9BZjCvqDI6pwGraqEpKY7NfH46YLtvPQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw25c+OyP2SdrPSM0MrZWhL0JophDLolVS3ytSq36wH7E+/MgCv
	eS35MnhG0wq4dyeVNGjBqjbscXrJEbP7Y+b5Rp2W8h7QsefVDbmfSmEOyCv17Co=
X-Gm-Gg: ASbGncszqtgQtx1rJpNGqeHmHJL26OUHMnAOAZGe3O79+tN8L8PX7vsmUvbMG5m3AFT
	iBl6wgE04h+RWahRLZj69+OwTk4hrQondB3nPwX9F+J0URdpj7xchfiwQKZTsYylfB3w+2gBtx7
	W2m/hcBhvehnMma0maB53uN1A90UhlGW9YxWI4u/4EGvsUlxNTL0dgMjjW+41655HbMxMkPholb
	LPqsLvi5H+pJPynTPFt3bTllbKRHlTm+W6ROpE4W17m/qlr
X-Google-Smtp-Source: AGHT+IG8bGb9k6ogXkDyTn1lVDUam0rrds2nfPCjABZzTJXZMxXF7ulluPar4hnOqOBRYveY9u3LOQ==
X-Received: by 2002:a05:600c:1d18:b0:426:8884:2c58 with SMTP id 5b1f17b1804b1-434a9dbbcc7mr211036535e9.4.1733135169207;
        Mon, 02 Dec 2024 02:26:09 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385e4a54b71sm6444957f8f.79.2024.12.02.02.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 02:26:08 -0800 (PST)
Date: Mon, 2 Dec 2024 10:26:32 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: Itaru Kitayama <itaru.kitayama@linux.dev>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v5 00/43] arm64: Support for Arm CCA in KVM
Message-ID: <20241202102632.GB1704077@myrica>
References: <20241004152804.72508-1-steven.price@arm.com>
 <Z01BYOgsLXV5yULk@vm3>
 <01205247-ffcd-439f-b00f-d8e70720d049@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01205247-ffcd-439f-b00f-d8e70720d049@arm.com>

On Mon, Dec 02, 2024 at 08:54:11AM +0000, Steven Price wrote:
> Hi Itaru,
> 
> On 02/12/2024 05:10, Itaru Kitayama wrote:
> > On Fri, Oct 04, 2024 at 04:27:21PM +0100, Steven Price wrote:
> >> This series adds support for running protected VMs using KVM under the
> >> Arm Confidential Compute Architecture (CCA).
> ...
> > 
> > On FVP, the v5+v7 kernel is unable to execute virt-manager:
> > 
> > Starting install...
> > Allocating 'test9.qcow2'                                    |    0 B  00:00 ...
> > Removing disk 'test9.qcow2'                                 |    0 B  00:00
> > ERROR    internal error: process exited while connecting to monitor: 2024-12-04T18:56:11.646168Z qemu-system-aarch64: -accel kvm: ioctl(KVM_CREATE_VM) failed: Invalid argument
> > 2024-12-04T18:56:11.646520Z qemu-system-aarch64: -accel kvm: failed to initialize kvm: Invalid argument
> > Domain installation does not appear to have been successful.
> 
> Can you check that the kernel has detected the RMM being available, you
> should have a message like below when the host kernel is booting:
> 
> kvm [1]: RMI ABI version 1.0
> 
> My guess is that you've got mismatched versions of the RMM and TF-A. The
> interface between those two components isn't stable and there were
> breaking changes fairly recently. And obviously if the RMM hasn't
> initialised successfully then confidential VMs won't be available.
> 
> > Below is my virt-manager options:
> > 
> > virt-install --machine=virt --arch=aarch64 --name=test9 --memory=2048 --vcpu=1 --nographic --check all=off --features acpi=off --virt-type kvm --boot kernel=Image-cca,initrd=rootfs.cpio,kernel_args='earlycon console=ttyAMA0 rdinit=/sbin/init rw root=/dev/vda acpi=off' --qemu-commandline='-M virt,confidential-guest-support=rme0,gic-version=3 -cpu host -object rme-guest,id=rme0 -nodefaults' --disk size=4 --import --osinfo detect=on,require=off
> > 
> > Userland is Ubuntu 24.10, the VMM is Linaro's cca/2024-11-20:
> > 
> > https://git.codelinaro.org/linaro/dcap/qemu/-/tree/cca/2024-11-20?ref_type=heads

Indeed, QEMU branch 2024-11-20 has to be used with an older version of the
KVM patch and older RMM. For KVM v5+v7 you need the most recent QEMU
branch, confusingly called cca/v3 (because it's the third patch series).

Thanks,
Jean

> 
> I don't think this is the latest QEMU tree, Jean-Philippe posted an
> update last week:
> 
> https://lore.kernel.org/qemu-devel/20241125195626.856992-2-jean-philippe@linaro.org/
> 
> I'm not sure if there were any important updates there, but there are
> detailed instructions that might help.
> 
> Regards,
> Steve
> 
