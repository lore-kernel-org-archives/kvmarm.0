Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D742C3244
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 09:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722910; cv=none; b=p+fC1twe9oZNl1Bv1YHINkgqn4uCWcnRKG/A0Gv3ktKd06V6rZ+9aWQQDduTwY1ISWlfBJ5sXTnPjc7sxUi18BASY5lO7kvqr62BR3op+lJYcxo0Vz0qsZ6ybGnJGrqCmvuXlasT6L3cS8DCCZxtqjgEIVvxIc8vwz1JOs4XX8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722910; c=relaxed/simple;
	bh=D0PKzZhQRsxn3gOcYMwqRGpkhs/bU2h6lOLFmUyfZXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sqLsO7nvkzgrAFR2DMYFCUQIytj7lehgS/UNVEvszwnbK6kToD+yvMJzPEiInYKDqoCuApylSTu+qMXk5GGCPKwQJlSj22SdiCmOnMCrptVL1TNXhBcYcyzDwEELgLi1GXJcXDOzeWoMJ7+/tsf27SVPvd4nq1K1m4nRvWpYC3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IT7X68xt; arc=none smtp.client-ip=91.218.175.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IT7X68xt"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=D0PKzZhQRsxn3gOcYMwqRGpkhs/bU2h6lOLFmUyfZXg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789722906; v=1; x=1790327706;
 b=IT7X68xthK4cHyMcGAcZoJqVS18jbHnD2WuQORe8IWt3yZ8kvyqcGhouZoZC9od/rNTYZW+0
 jZieaJ7ZGhqqHCOi3Xm6owEGfG8F3Jiu8yNZiY/l2Z0nmcgcIvMwAW6aC8awOFq+XdSv09KbHRr
 g6yiLfJz2ULfwC1F9wwRvuiA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 407aae97b72d4b37;
	Fri, 18 Sep 2026 09:15:06 +0000
X-Mizu-Trace-ID: 407aae97b72d4b37
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b8c42da963so966e87.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 02:15:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzBOnrs34wsczNooSQolZuXf+ur5yww1O8+s/UimDnAVCcUIuOkGABt/jrBwkUhuXW5j6Oc4tM=@lists.linux.dev
X-Gm-Message-State: AFuF++lq8JYEt+z6VDMfy8FGPfpQVPXhFV9Zk0vVSLjU+K/SXuOuvrlH
	a3vBC88lJxigt+HZKVKeVIEpXPh5j2517VK/nY7uPcxGXc2ZMA0bSWgAq4+9fX1G67YTC6ygDJG
	YhIqGsuy/jjwUOMMXjYy9EOIm896h1KFXCKe7RE0g
X-Received: by 2002:a05:6512:a96:b0:5b4:9dba:7401 with SMTP id
 2adb3069b0e04-5b8c17f53eemr77720e87.11.1789722900983; Fri, 18 Sep 2026
 02:15:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-6-suzuki.poulose@arm.com> <CA+EHjTz65G0MM=tOrzmk=jMweBX1us6FqfrmSkQs4KSyAEoxhg@mail.gmail.com>
 <e26cbb4e-84e2-4fcc-9eb0-93bfd4aff4a7@arm.com>
In-Reply-To: <e26cbb4e-84e2-4fcc-9eb0-93bfd4aff4a7@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 18 Sep 2026 10:14:24 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw6TOSEs1GtUcUy9WACpGRJBA9yTn9Ro_+tiD=XkeHr4g@mail.gmail.com>
X-Gm-Features: AcwNN1WAyYZFMS1tYTqzPWruuztc5hWFyoH3hZA9fEYOfU0jxVOmsQMTpwP1D70
Message-ID: <CA+EHjTw6TOSEs1GtUcUy9WACpGRJBA9yTn9Ro_+tiD=XkeHr4g@mail.gmail.com>
Subject: Re: [PATCH v18 05/23] KVM: arm64: Track the type of VM in kvm_arch
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On <date>, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
[...]
> +       if (WARN_ON_ONCE(!kvm))
> +               return false;
> +
> +       /* Cover both pKVM host and Realm VMs */
> +       if (!kvm_vm_hyp_is_distrusting(kvm))
> +               return true;

I'd drop the WARN_ON_ONCE. And this early return needs the `>=` from
patch 13, or non-protected pKVM VMs skip the filter.

> I resorted to is_protected_kvm_enabled() to make it faster than using
> the vm_flavor checks. I could rever those anyways.

Agreed it's the faster test. I'd just call it by name at the three
sites rather than through a macro.

> Do you mean something like :
>
>         if (kvm_vm_is_protected_pkvm(host_kvm))
>                 hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
>         else
>                 hyp_vm->kvm.arch.vm_flavor = VM_PKVM;

Yes, exactly that.

> Do we additionally need to WARN_ON() if we encounter a VM_REALM ?

No, the host shouldn't be able to trigger a WARN at EL2.

> Apologies, I thought this one didn't change, but later patches changes
> them, which is why I kept this.

No worries. With those two in, please keep the tag.

Cheers,
/fuad
