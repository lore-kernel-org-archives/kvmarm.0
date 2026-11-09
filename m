Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246909;
	b=RvQtX2qAItgh9Uds5suZf0vOOn/hNG4IPPX8r+t1VJNvIpnEoxvUgjioYyYQk3sWEBPZ
	 nhZZPFN1hlU3I/CqdArTKmQ0TG5yHwwAwyuizx1fOGkjr31wREzfRC5IhFKBM7Ith144y
	 tkJoEsXXg4NDpl3BJt52Y6MIPehdmUoc1tF6PqH0jxybaT8r0i6eq+Qf/0W+RKGZYSNn3
	 JHhIgsUUPUI/MdO7vyX4bFEkHw6aQniMLklLWx5ZRXaPUo5RtTv/DiuVuaXVLrJzDVIyI
	 m2hIriam9qhBwtR9mgXSKC9Mu7IZ4fc3hmOHazFGPZhjlH6t8QY/0N9Yo7D/Gu6dwgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246909;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=11RwpAZYJzurasS+fKAO94FekstS9vjJMnTCvuVMOaQ=;
	b=BWUEGwSnYIZY2yQ3DX2kbsHnzszVkUmylVxOAjRMdQzE1uJZkWSc97dbVrc2axlt7UqQ
	 gQDOcn3n38P/zkBrU6drk9WyeQxUbyF92HSZJzlVDoMwjppJVHMkovVhuUOQEENL7If+0
	 hRcmm+VP1vyufMH0WMO6zGBq4eV4yiqaUlkypp4/FgB7yYVy7d6asvboml9LVwCY2vO00
	 t+vzPQRfvn4pIUTkd++2QjVm1kki7bw8cIkjDTllUUVugnkAnna85LkB9QBW6LzftOiFk
	 rHtzAJ8m7tHZb59zIpsRWHS/hKEhwMzVwzjwp3ZT9ici6Lc+s/tCPBrVcYbL3Fm+5Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qdxtKsot;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A954B606A31C
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 17:55:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A954B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qdxtKsot
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8CC31476;
	Mon,  9 Nov 2026 09:55:04 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41C663F673;
	Mon,  9 Nov 2026 09:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794246907; bh=0GMmn7UJMXQFZPaeSU5PYk8MQyWUFZy+AlN4LNHq+jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdxtKsotnhIrOLdovee5Ji0hbo8gTPSG3VUG7ZR7x4hOfPC0eDkaSo0SZ/aaJ2UMI
	 AIZoaju5IUHl3hqCKYqfTbqW2f1kCdDJwJWur3HrydFJtTX0xKhCNVCqnma0RbLcNE
	 TlQ1ms62j/RmiJw8PWSRE5qPnd97wmji+pyr75d0=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 6/8] KVM: arm64: Add sys_reg_descs for remaining MTE CMO instructions
Date: Mon,  9 Nov 2026 17:55:03 +0000
Message-ID: <avII94Pr7Cm0UPvF@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <avIHZW07QmWnl4m9@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org> <20261104192124.3932743-7-oupton@kernel.org> <avICtPQtRH108ILM@LeoBrasDK> <avIHZW07QmWnl4m9@kernel.org>
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
Content-Transfer-Encoding: 8bit

On Mon, Nov 09, 2026 at 09:48:21AM -0800, Oliver Upton wrote:
> On Mon, Nov 09, 2026 at 05:28:20PM +0000, Leonardo Bras wrote:
> > On Wed, Nov 04, 2026 at 11:21:22AM -0800, Oliver Upton wrote:
> > > Filtering unsupported cache maintenance instructions from a guest relies
> > > on either having a suitable FGU bit for the feature or a descriptor with
> > > a visibility() hook.
> > > 
> > > MTE CMO instructions can be trapped by HCR_EL2.TPCP and lack a suitable
> > > FGU. Add descriptors for the CMO instructions that UNDEF if MTE isn't
> > > implemented for the VM.
> > > 
> > 
> > I think I get the idea of using MTE_CMO_INSN(): having the visibility test 
> > for MTE defined in the previous patch, which makes sense with the above 
> > commit message: if !mte -> hidden, then on access it injects undefined.
> > 
> > Please help me understand the other way: if we have mte, then it calls the 
> > 'access' callback, which is bad_cmo_trap(), which also inject undefined. 
> > What is the goal here?
> 
> This is consistent with how we handle other unexpected traps, such as
> registers that redirect into the VNCR. If we take a trap for one of
> these instructions then either we UNDEF it early in triage or redirect
> the trap to the L1 hypervisor.
> 
> Under no circumstance do we expect to handle the trap locally, i.e.
> reach the ->access() function.
> 
> Thanks,
> Oliver
>  

Ah, I see your point there :)

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
