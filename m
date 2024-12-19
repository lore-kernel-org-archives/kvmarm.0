Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE29223330
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734605929; cv=none; b=LFmvBLxcHkVlkVQgGxtDaCz+wFPQL2b1RF/R8xD4Z62iAqBQXGFZA2VS7zPU9rEfU5pFcQ/Erix4w/JC76cdbTsk7N1x+/ED5IyVe4uBbw9qRoujrMi2xjhxFUQGWJM7mfX9rdf8te3XdP5br5JObRSc/G5JlVrxX23D/hs/D10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734605929; c=relaxed/simple;
	bh=G5kcT4WxhFuzMY1pRCiYzc4K//k/tyl+NmgIcVDYP9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3kBYg0TaxmVEWAjpWtlvu58lZpHNBxNeXJ1BIk9TXRih9ONXPBnLwJQ5CFA3W3XGupiBjduRp7ATzgKi16jexCKbH5Tgaui0+gNMR8rrE1uXU+ORmM8ugmt3O03t1kUyWhA6FwFU2cey3PD7rXyf07pWM2hHi7SQKNNlJuzubY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 1A80172C8CC;
	Thu, 19 Dec 2024 13:49:23 +0300 (MSK)
Received: from pony.office.basealt.ru (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id 1026E36D0193;
	Thu, 19 Dec 2024 13:49:23 +0300 (MSK)
Received: by pony.office.basealt.ru (Postfix, from userid 500)
	id DB1BF360CB20; Thu, 19 Dec 2024 13:49:22 +0300 (MSK)
Date: Thu, 19 Dec 2024 13:49:22 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, gshan@redhat.com, james.morse@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Jing Zhang <jingzhangos@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 6.6 v1] KVM: arm64: Disable MPAM visibility by default
 and ignore VMM writes
Message-ID: <fqmjpadvbc7hoakm5qsmaxbgr7jomuehxjm3axo3sbpl4nzqvg@innog6dkmwqd>
References: <20241212151406.1436382-1-joey.gouly@arm.com>
 <2024121528-refurbish-plausibly-31c7@gregkh>
 <20241217104058.GA2151333@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217104058.GA2151333@e124191.cambridge.arm.com>

Marc, Joey,

On Tue, Dec 17, 2024 at 10:40:58AM GMT, Joey Gouly wrote:
> On Sun, Dec 15, 2024 at 10:22:53AM +0100, Greg KH wrote:
> > On Thu, Dec 12, 2024 at 03:14:06PM +0000, Joey Gouly wrote:
> > > From: James Morse <james.morse@arm.com>
> > > 
> > > commit 6685f5d572c22e1003e7c0d089afe1c64340ab1f upstream.
> > > 
> > > commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> > > ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> > > but didn't add trap handling. A previous patch supplied the missing trap
> > > handling.
> > > 
> > > Existing VMs that have the MPAM field of ID_AA64PFR0_EL1 set need to
> > > be migratable, but there is little point enabling the MPAM CPU
> > > interface on new VMs until there is something a guest can do with it.
> > > 
> > > Clear the MPAM field from the guest's ID_AA64PFR0_EL1 and on hardware
> > > that supports MPAM, politely ignore the VMMs attempts to set this bit.
> > > 
> > > Guests exposed to this bug have the sanitised value of the MPAM field,
> > > so only the correct value needs to be ignored. This means the field
> > > can continue to be used to block migration to incompatible hardware
> > > (between MPAM=1 and MPAM=5), and the VMM can't rely on the field
> > > being ignored.
> > > 
> > > Signed-off-by: James Morse <james.morse@arm.com>
> > > Co-developed-by: Joey Gouly <joey.gouly@arm.com>
> > > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Reviewed-by: Marc Zyngier <maz@kernel.org>
> > > Link: https://lore.kernel.org/r/20241030160317.2528209-7-joey.gouly@arm.com
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > [ joey: fixed up merge conflict, no ID_FILTERED macro in 6.6 ]
> > > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > > Cc: stable@vger.kernel.org # 6.6.x
> > > Cc: Vitaly Chikunov <vt@altlinux.org>
> > > Link: https://lore.kernel.org/linux-arm-kernel/20241202045830.e4yy3nkvxtzaybxk@altlinux.org/
> > > ---
> > > 
> > > This fixes an issue seen when using KVM with a 6.6 host kernel, and
> > > newer (6.13+) kernels in the guest.
> > > 
> > > Tested with a stripped down version of set_id_regs from the original
> > > patch series.
> > 
> > What about 6.12.y?  You can't just skip a stable tree, otherwise you
> > will get a regression when you upgrade to 6.12.y, right?
> 
> I did have it ported/tested locally, but I wasn't sure of the stable process,
> so just sent out one!  Next time I will send all the backports at the same
> time.
> 
> Thanks Marc Z for sending it out!

Thank you for backporting this, and thanks to everyone involved in the fix.

Vitaly,

> 
> Joey
