Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60915400986;
	Mon, 21 Sep 2026 11:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789990949; cv=none; b=fzpQ1PEVLsIIwro0e5hjtM1gewSA4Pn1Rg0OE0TnQSOzt0GiMIXK0w9JTKN0KVyEIrVEx82PonI8o1l1FFgIA7XNgVI/Yj7acSChGSTRyRGQ8Kwv0jinO4QlJ/B2W7eXP3e/tVegFNQbYASliCuC/M2N7p6OYLYyNX55h3J8qpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789990949; c=relaxed/simple;
	bh=KHVh8f+CDiS52n2nqmGCKgqcZPhJmTUHAloQj6QXyZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyL95jRbc5oHP77cupoZnMQsdwsdlMChPbDN4rgLz06jr6Q0yiX1Kr4w5epc+XohGqq5cxVk9q1e+s7bNClHS4sVLFY2rB1WD5MoyirSkGDQ0DHxw5BB0e6c4gUqYPo3vZJFrW5i574+kp+u6IO0hd8w9SSe430qFiXzM8cu6go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTnV8Sbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTnV8Sbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D0F1F000FF;
	Mon, 21 Sep 2026 11:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789990948;
	bh=KHVh8f+CDiS52n2nqmGCKgqcZPhJmTUHAloQj6QXyZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YTnV8SbqTR/BakhRDkRQmybmJEwfKh9yeygyfrBF1/qxOzvFaK2suFVsN191DgMZJ
	 +X6BOChoAvJtOJyUehk26jNgxpD1uG9vLhU6eh0wEpTJkxlhVtDO1z00JMCJu6wHcE
	 TjmCy4wOAfMSN/A0wkRMY/5Md2QfRdY9QYLTpmy2IKKzRhfbUKj5w5Nf5Es3OBdV7r
	 FbSY6kdl/7qqi2ZHeSN8sNiEw6+MfLmhEA8Xoi1j3CEO4Sd4sstfAXDOtxzQd0glzP
	 XDetAxSsy0Ia54FdPWm2Qx9sHCeqAab8YVsAxP6M9D+7nQ9urPEyBqb6FNF4Mgw8YD
	 ZVe56C9QpGADg==
Date: Mon, 21 Sep 2026 12:42:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Jack Thomson <jackabt@amazon.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Restore the VM's feature bitmap when
 kvm_setup_vcpu() fails
Message-ID: <arEWo3yDYkWp55sF@gremlin>
References: <20260921063718.1604533-1-fuad.tabba@linux.dev>
 <arDYHSlFHm_XzGvN@kernel.org>
 <CA+EHjTz0-qS8RRhdT8XjAgWqKhgjjzbRsZ_jwTBVqM-8pXk7Vw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz0-qS8RRhdT8XjAgWqKhgjjzbRsZ_jwTBVqM-8pXk7Vw@mail.gmail.com>

On Mon, Sep 21, 2026 at 08:24:56AM +0100, Fuad Tabba wrote:
> Hi Oliver,
>
> On Mon, 21 Sep 2026 00:09:17 -0700, Oliver Upton <oupton@kernel.org> wrote:
> [...]
> > > Nothing in the tree loads a vCPU whose init failed, so this is latent.
> > > The upcoming series that enables KVM_PRE_FAULT_MEMORY for arm64 exposes
> > > it: the generic kvm_vcpu_pre_fault_memory() calls vcpu_load() whether
> > > or not the vCPU has been initialised.
> >
> > That's a bug, not a feature. We should require an initialized vcpu for
> > the ioctl.
>
> That one is for Lorenzo then :) I'll reword the message so the stale
> bitmap comes first and the pre-fault crash is just how it showed up.

Let me dig into this.

--
Cheers, Lorenzo
