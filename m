Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0972DE704
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762796509; cv=none; b=m8Jw3a2oZs07GwqbljkWWwLvMaYO5a4SNkrFV3Ijfv7slGtBEhf3/oG2D1vAc6C3x0DGFzMBb/ZkC7IuFDOCqEHByfYgz/8CkaGsZoNPTUaCFb/4eBglZWXanb5cZhP/ZYnKoj7jmUhDkASLbV5ydE6sNCeYu0vb0SmuZN4Jhqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762796509; c=relaxed/simple;
	bh=01dlGr5yNF89ID01yy7JEyF1mqdeq7pHF47t5S9oyvw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JE9kz//5PdI7P9EHH4o1yQKEip1z/6BsyC9xCOd5gEonN95wNJA96Q7kf//V8AvGGYKXL8A29HI4OwYn+Mkytb7yapqUTCxSynEz913SUQUx59QMVtTFZlesqdwlLd0e7lvxNA25LCChcTORVbX4YYJkgX6/8yxDqgc2eLv7fNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oens8N4I; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oens8N4I"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-431d824c8cbso439565ab.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 09:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762796507; x=1763401307; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCN02yrRrm29VoLhm6qdIaJ6qOTD6tpswHT/4wW9b3I=;
        b=Oens8N4I/hnt/UXj62kAH2A+ozEn5ahcFmXvAK5R048f8xjyDlzoNpxhWkljMgWk7H
         M/yF4WjkVR0NI2qV4hEYyiMKmf5GrGYZJWHwj0k8Fb2QeR9YOVzGfCy7xpc1DHXhmgIG
         rUfoc9Pn+gLv1qDRklI3lEk7vzuUQzmqA+ytwZatI/exSGs565HuozWj/VStvJEKfVaP
         GOVzTFaXm9kYLcQaccL7XNxeYDyB2ZGGJ2ypDEG4x+wb51Z5m8e3McfcDWi95mJwYyDh
         Klfw6gMF8fBe4tfvMkdxrCLcx4+hIYqGzZ64+22yPjxUK7GPgwc5vxQtlP8hs458GtuU
         HilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762796507; x=1763401307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uCN02yrRrm29VoLhm6qdIaJ6qOTD6tpswHT/4wW9b3I=;
        b=g/LPDs7CoI5LxqHOp4CzypDc13+gKaHgGPVnIJTmMlC2CoP1/j0MRS7mSV4VtgCZHB
         dOtx0R50BnDMcs/qQ6r570ezepkIxUaqgKioZa9GPurf2FjCXYFOlP5pKACsSdPMv5Ra
         or/6TfOQmwUsEJjLqrxsOEoA+nuVVmPsdNIGOS0rFChA/rLJizgRYMUieMZrtodgsF0H
         JZ0zUzn3KuSCzO2n3nfMLWWmPiCNo1X+OL0k3lwVJhpua24wsopqUSqKqkivcjJ/BGSw
         vDUs9UBtxxPHiAIcX3STeE5DNOf8tvz5l7NGKnMgBdWX0ZsWtVa83pDcrgYg2qSsixbu
         c3IA==
X-Forwarded-Encrypted: i=1; AJvYcCX0KpLHG8P+iE1Y/JaQ7mPKiIEr4fgE925H2/eHsHPaU1bkQbycjnqaOKAXAm4GyOHvK04Hzgw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMJk1nXVZVioZJOkM7kbGDUFn7F5XbEN5rpLn9iNwq27yA4/Y1
	p8s64Y4rcM+UOgKy0pVCaaUvkD6TvpKHtty5H5MkDBvXYQN+MGVe1ViZ+F7X69awju4KPmTTgvw
	QPVR7J5QzpFiXgfRxTv3fpKudUjN6f3OicYyUeTwn
X-Gm-Gg: ASbGnctETg0mXtKMNDGv5jAry/dqCC4/Rd3Ngat/JxtzRAcbGRqZm+fvK/azOdHkkSt
	a1pFc6GvXvYP30zq0OH/Wv9LS8Ycrq88aDduVx/4vDAVsZnPuPfhVkQIALWS4X6HdLY3OMDIgFL
	PCLqfjoJQtKdrgMm2hySz3gA/ZotH1E1fSc9Rdm2OyJ77VOw5XnGDr1B1pC2F1FwwlLkcR0LpuO
	Yln5qgfRaUP+7zrp2r9dakBt5XYbBdKfm/EEcy8Qw1p45Sokg7MV2dTVIJKF7J5/vM5foT6ZpUa
	7qXtJ/AvGTaXvpgQIqboxSWpq9E=
X-Google-Smtp-Source: AGHT+IHBszWXqdmegF9jDz3JdqQDbm8MYTV0aj0bqa37sU1cyBKp/p7V6BTPvfRkJX2omWXmFuxPpOdX1NkrpUUy3u8=
X-Received: by 2002:a05:622a:1981:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4edc9d77fa9mr1301871cf.2.1762796506738; Mon, 10 Nov 2025
 09:41:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <20251020144646.GT316284@nvidia.com>
In-Reply-To: <20251020144646.GT316284@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 10 Nov 2025 09:41:33 -0800
X-Gm-Features: AWmQ_bn8laNbI6x-97h0sYyX9fmwMMmvt4fgKNBEt3tvZG9iGI46wWrBFKgKfqM
Message-ID: <CACw3F528D6odL3MJWb28Y4HVOLo56tMQXBpvti5nhczdpMxOdQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com, vsethi@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 7:46=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Mon, Oct 13, 2025 at 06:59:00PM +0000, Jiaqi Yan wrote:
> > Problem
> > =3D=3D=3D=3D=3D=3D=3D
> >
> > When host APEI is unable to claim a synchronous external abort (SEA)
> > during guest abort, today KVM directly injects an asynchronous SError
> > into the VCPU then resumes it. The injected SError usually results in
> > unpleasant guest kernel panic.
> >
> > One of the major situation of guest SEA is when VCPU consumes recoverab=
le
> > uncorrected memory error (UER), which is not uncommon at all in modern
> > datacenter servers with large amounts of physical memory. Although SErr=
or
> > and guest panic is sufficient to stop the propagation of corrupted memo=
ry,
> > there is room to recover from an UER in a more graceful manner.
> >
> > Proposed Solution
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The idea is, we can replay the SEA to the faulting VCPU. If the memory
> > error consumption or the fault that cause SEA is not from guest kernel,
> > the blast radius can be limited to the poison-consuming guest process,
> > while the VM can keep running.
> >
> > In addition, instead of doing under the hood without involving userspac=
e,
> > there are benefits to redirect the SEA to VMM:
> >
> > - VM customers care about the disruptions caused by memory errors, and
> >   VMM usually has the responsibility to start the process of notifying
> >   the customers of memory error events in their VMs. For example some
> >   cloud provider emits a critical log in their observability UI [1], an=
d
> >   provides a playbook for customers on how to mitigate disruptions to
> >   their workloads.
> >
> > - VMM can protect future memory error consumption by unmapping the pois=
oned
> >   pages from stage-2 page table with KVM userfault [2], or by splitting=
 the
> >   memslot that contains the poisoned pages.
> >
> > - VMM can keep track of SEA events in the VM. When VMM thinks the statu=
s
> >   on the host or the VM is bad enough, e.g. number of distinct SEAs
> >   exceeds a threshold, it can restart the VM on another healthy host.
> >
> > - Behavior parity with x86 architecture. When machine check exception
> >   (MCE) is caused by VCPU, kernel or KVM signals userspace SIGBUS to
> >   let VMM either recover from the MCE, or terminate itself with VM.
> >   The prior RFC proposes to implement SIGBUS on arm64 as well, but
> >   Marc preferred KVM exit over signal [3]. However, implementation
> >   aside, returning SEA to VMM is on par with returning MCE to VMM.
> >
> > Once SEA is redirected to VMM, among other actions, VMM is encouraged
> > to inject external aborts into the faulting VCPU.
>
> I don't know much about the KVM details but this explanation makes
> sense to me and we also have use cases for all of what is written
> here.
>
> Thanks,
> Jason

Thanks for your feedback Jason. And thanks for the comments from Jose,
Randy, and Marc.

Just wondering if there are any concerns or comments on the API and
implementation? If no, I will fix the typos in 1/3 and 3/3 then send
out v5.

Thanks,
Jiaqi
