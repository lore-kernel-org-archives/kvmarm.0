Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2309B4F3906;
	Mon, 28 Sep 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615112; cv=none; b=pPSzFoKVQs7dHaIhb7O3IagmBbETuC5+th+ppjkkd3GufOkdeiU9BWhzXfKB0JsikVLmn1ddtmcLb2d5H5lAsVFSmdBLal5j0jbZMK5O2AJ06WkC5MCBrQdF+3ktBYZj3Jx+Pw8B8I33zaEKu00ZgGHplBcEU6qlVkfhWEWthXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615112; c=relaxed/simple;
	bh=yoXTXqPzTE35yeLLUFkb8ceBe47d/S/Yap+eGL4p4bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DvZ5n4Tcil9kS9iOUBruFDIuLFLHr4PuyaHYWJdMShiDoaJqsAOgJ1l4bkLGQqDqfYu11Sjz+7DpmJBBYVxsBSYCAU66cahXj2Z08zBwP+9OOqu5Qxe4svjBp4abHuBoPZ1kg66wy2Zh56R12JgHlXt1t62W5A9rK1IrcfLBlKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdQwx718; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdQwx718"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C955C1F00893;
	Mon, 28 Sep 2026 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790615111;
	bh=yoXTXqPzTE35yeLLUFkb8ceBe47d/S/Yap+eGL4p4bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QdQwx718ik84L+Mq45KEayXLdVMUAcnmUhtWIQfGQXGH9vNemnBJYzTv7sICCtRE+
	 39+4B+n3qedPT1V8sl+2ygYB09kLPI75LxEkCv+ptk3g6uZl3mI84+2geK26zblJVE
	 dU3VPa+mYT9RQGE2FWVdw4TEfsCGJJTAjLV9ro+gbqN5ctgqWbX0iNcdk7KDcxbZTS
	 9OSzG3RytUq0zqCEU4v7C/uqLpG35ZMCaMpPw3ZhQXrShg9Xi0z7w/ReikxlR0bMJF
	 +xQJVbH2q5IZtgeGlH69O9wfIiwUTppVz0/Msyj/Uyt34iWlg7pBcpkIunSyMvzIR/
	 2wBtg1LjB0MIA==
Date: Mon, 28 Sep 2026 10:05:09 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>, Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: arm64: Don't WARN on an unsupported TLBI OS
 from vEL1
Message-ID: <arqeRSIoEwurSrya@kernel.org>
References: <20260928064643.3265087-1-fuad.tabba@linux.dev>
 <20260928064643.3265087-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928064643.3265087-2-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Sep 28, 2026 at 07:46:40AM +0100, Fuad Tabba wrote:
> KVM hides TLBI OS from a guest whose ID registers don't advertise it by
> trapping the instructions: through the fine-grained traps on a CPU with
> FGT, and through HCR_EL2.TTLBOS on one with FEAT_EVT2. With FGT,
> triage_sysreg_trap() makes a trapped TLBI OS UNDEFINED. Without it, the
> instruction reaches handle_tlbi_el1(), which assumes an EL1 TLBI only
> traps from a guest at vEL2 and WARNs before checking whether the guest
> supports it. The guest still gets its UNDEF after the WARN. A VMM can
> trigger the WARN by hiding TLBI OS and having the guest execute one.

So the FGUs don't actually require any hardware support, they're just a
representation of our UNDEF emulation that can be applied even on
non-FGT. That's actually the way we had them wired before the whole
config.c rewrite.

Can you look into reinstating the FGUs?

Thanks,
Oliver
