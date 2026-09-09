Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982865437F4
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953342; cv=none; b=pk0oeBWMICAwqVZC/e7dxmqX/boq1a9ZMbbVOyzt3paV0FZnZbrtiaEHKJ1+gFwIM26/BZk77p4THJBc+3vRr63oFY1oMXgc1zGcv2oOIjWBCui8oMmh+JEco5ypLJ0U/765d1w9B1BEMuYj8xBfbS7eI8UjfGerhSWvI9nQBXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953342; c=relaxed/simple;
	bh=3K+cGIQpWKO1Yr5hRTXgQHb8/73OGKtddJAzidJdgJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xrq2P0+/TiIAzx5i0phg18iNg90d8PJ1WOLReFNe1s2fnujIJ+/UGJzWQePN1+8EbKPQEzXnlxwIWJUi2fF8Qsm/wh0pk4tnsYL0v8iABjeh8hLnn1TcuSUBp7f2ugKJBS1EQ6XJsM/g5Wa8oAgJQMbuQxIwUVxwcLsu7reAUqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iryyCpTd; arc=none smtp.client-ip=91.218.175.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iryyCpTd"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3K+cGIQpWKO1Yr5hRTXgQHb8/73OGKtddJAzidJdgJk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788953337; v=1; x=1789558137;
 b=iryyCpTdGJzmqAHXWTohRtB3hYyOpTOruRmXRuYhQd+mayeTKu/NSKEx2TFI1YTku3wW8qsc
 B+x3MnXp5hPnQRUqZy6odsT7PYPMAhrXz7ZLVzfConEJvLWSUGrtH2z88Ma5kJalUEawQcvdhT7
 Du6wsksnzMKFBWTI/yPPJjEA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cbe74d1ccc204b67;
	Wed, 09 Sep 2026 11:28:57 +0000
X-Mizu-Trace-ID: cbe74d1ccc204b67
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so5934e87.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 04:28:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz1os5M3qUeiqqwkwHaL5z5ZVQzuUp2l9IV5vDmznyReRj29Esa8NgxuADzVR1LJ1NmoPOBr+U=@lists.linux.dev
X-Gm-Message-State: AFuF++nAj9O6YcIq7YN+f7setQSutSsvKM9vmjfK2veIOL5f1gEujSX+
	AG2fkuGZPwmIcIMYEra3RcfTo4yMvhbQBq5eAjhnBSYcUKX4n+TpNpuiVDFOBo+bsmzG7YrLbjm
	rB1x2iahJuw8fopt7MFDzne7f4eLgKDQquoPw3txG
X-Received: by 2002:a05:6512:288:b0:5b7:78bc:ec07 with SMTP id
 2adb3069b0e04-5b778bcee15mr40479e87.14.1788953335800; Wed, 09 Sep 2026
 04:28:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908162223.1683432-1-suzuki.poulose@arm.com> <20260908162223.1683432-4-suzuki.poulose@arm.com>
In-Reply-To: <20260908162223.1683432-4-suzuki.poulose@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 9 Sep 2026 12:28:19 +0100
X-Gmail-Original-Message-ID: <CA+EHjTybMZ1TORs25En0eb7_41FBcB=BK1ygYPy5cOHUnQO84A@mail.gmail.com>
X-Gm-Features: AcwNN1XnVfoUpkUpC2kOrZN-6IIczUYCQWaTNJXNhIJk8ffOOnhKQ4oEGT6SciA
Message-ID: <CA+EHjTybMZ1TORs25En0eb7_41FBcB=BK1ygYPy5cOHUnQO84A@mail.gmail.com>
Subject: Re: [PATCH v17 03/20] KVM: arm64: Track the type of VM in kvm_arch
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

On Tue, 8 Sept 2026 at 17:23, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> KVM arm64 has different types of VMs with all the different modes in which the
> hypervisor code can be run. e.g., VHE, nVHE, PKVM etc. Then there is protected
> VM and normal VMs with PKVM. We might soon add other types, e.g., Arm CCA Realm.
> So in an effort to make the handling of these different types of VMs a bit more
> friendlier to the eyes, add a VM flavor to the kvm_arch and we could then add

nit: "friendlier"

> handlers for different operations based on the VM type.
>
> Keep the flavor initialisation at the beginning to allow for the detection
> early enough and fail out on any unsupported requests. (e.g., protected on !PKVM)

In the commit msg and later in the code (not in the enum though), can
you please spell pKVM with a lower-case p?

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
