Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2BA43D4EF;
	Tue, 30 Jun 2026 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782831166; cv=none; b=jZvIuO5xj6ZB+lbSpg4WXM/hu+qnspiSN4dTRl54KhwJ7cdQUeGUKJ37r/ld3es+2ymdNVdcTD3JTFUXm0BCspvKp3xM1S7TbJwwnZbzV9dvxQRHH0XFMRXUMMSap3ONyGqGrDQTO3cxL7iFX/9/JhdGq1Lqdpgo5UjeDFQSFtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782831166; c=relaxed/simple;
	bh=R2m2wkxAHKJmBaJqAUn0cb0UfYgrhUeIdOnjx/m/q14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=H4Nxo/SUQdAPeiJNF+sOltFfRoYUmO/vQBPckZosO8Fm774hzyO15DXXwpovGlnOnvqMX3yrR6pGTW7+sSsB+WADl4lyclerjBciJXnbtFBj47dLguOUxo3qMN0vRlD4N0PbJ1CFIjDCF4DBjKrvFiYOWOhN/AFdOFu4uTNfStk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZBK9WxED; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZBK9WxED"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C03112F27;
	Tue, 30 Jun 2026 07:52:37 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D7203F85F;
	Tue, 30 Jun 2026 07:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782831162; bh=R2m2wkxAHKJmBaJqAUn0cb0UfYgrhUeIdOnjx/m/q14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBK9WxEDWF6JYOiYZ+s6rYt4uMOqdHSmkj2m6dg+1njq4VkQ4hpvNik7HZouZE2n3
	 PWffD2rBuCtsHwFFEZbtaX3fR71yudO1jCcfR4VBMwVg4koYmdsj+2K/Y/xpu+vzjP
	 TdlnyVBqr5t6HuXSBb1a3XQD0aWFOcoY5bGrmB18=
From: Leonardo Bras <leo.bras@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	sashiko-reviews@lists.linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/13] KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ
Date: Tue, 30 Jun 2026 15:52:39 +0100
Message-ID: <akPYN3bXxIia5obQ@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <b8e90340-ee2a-4024-bc77-a00b139ea7ee@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-6-leo.bras@arm.com> <20260629113242.9142A1F000E9@smtp.kernel.org> <akKSoZkYWDTE07hi@LeoBrasDK> <b8e90340-ee2a-4024-bc77-a00b139ea7ee@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 05:52:45PM +0100, Vladimir Murzin wrote:
> Hi,
> 
> On 6/29/26 16:43, Leonardo Bras wrote:
> >>> +	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
> >>> +		/* When size not a power of two >= 4k, exit with reserved TTLW */
> >>> +		int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
> >> [Severity: Low]
> >> Does this variable declaration cause a build failure?
> > No
> > 
> >> Under standard C rules,
> >> a label can only be attached to a statement, and a declaration is not a
> >> statement.
> > That's not a label.
> 
> I think Sashiko is right
> 
> arch/arm64/kvm/dirty_bit.c: In function 'hacdbsirq_handler':
> arch/arm64/kvm/dirty_bit.c:336:3: error: a label can only be part of a statement and a declaration is not a statement
>   336 |   int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
>       |   ^~~
> make[4]: *** [scripts/Makefile.build:289: arch/arm64/kvm/dirty_bit.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
> 
> Based on other threads you might need GCC<=10.5.0 to hit that.
> 
> Obvious fix-up would be to wrap the case into curly braces :)
> 
> Cheers
> Vladimir

Right!
I could finally understand what it meant on a next patch, where it 
explained the issue in a different way. Will add curly braces (or declare 
the variable before, honestly), and this should go.

Thanks!
Leo
