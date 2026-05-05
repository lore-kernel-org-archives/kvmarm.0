Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039A743E9F5;
	Tue,  5 May 2026 11:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777978998; cv=none; b=BhROOR5Bmv0elFBUg03Rx53IKn2ympg2a2em9ROTvT+B9SzB/rNb8IORC29e2SavSxatf/dVkQkcapk3dFs3/dGx+a3+gfSTaIue5n3H4PkCtVpLrtgk0MCvP4O3G5AReNsuU6FqMZrygHMwmW8qeBQyhJHblD0yK3A1BD3kc9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777978998; c=relaxed/simple;
	bh=PGCQed9Oxq3MqN8uLcSU6BNGwjhEPHA36l4Uy6rY/dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Ef10z+0egJ8t2rWA8e+JcYrIPd/VROmD1ObUzCnmzTNqKV1nDM4stnwDb7NpeVSpUcR1tmfh2GKOC6vA8wTdraIRPGO4A9Hy8ZEsAkPgzw+1fMyaTaLwWsFb5/oyLGc9CGkabDbmoktmRz20W62h9McUXo2EPykTATBpD/Nb7BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T4ABxL/9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T4ABxL/9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DF0128FA;
	Tue,  5 May 2026 04:03:11 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBF673F836;
	Tue,  5 May 2026 04:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777978996; bh=PGCQed9Oxq3MqN8uLcSU6BNGwjhEPHA36l4Uy6rY/dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4ABxL/9VRAvQ0bFdU+Lqt1Okw9qI1CggU+Z/Ixt2UOvrkyMXWMrsvB8ol+djB0P8
	 nyvo12tZo8tJeOr+cjHTqX6dYzYRTqW4Zl/MuYz5q1B6S347T546TH2J1v5vOw2RqX
	 FvW/8/TPYfTVJHWq/qahpqV5T7pzOKJ0nWCVhkVw=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kees Cook <kees@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v1 04/12] arm64/sysreg: Add HACDBS consumer and base registers
Date: Tue,  5 May 2026 12:03:03 +0100
Message-ID: <afnOZwB51YLz5e9N@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <afaehWCHVIN7EXNB@sirena.co.uk>
References: <20260430111424.3479613-2-leo.bras@arm.com> <20260430111424.3479613-6-leo.bras@arm.com> <afaehWCHVIN7EXNB@sirena.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, May 03, 2026 at 10:01:57AM +0900, Mark Brown wrote:
> On Thu, Apr 30, 2026 at 12:14:08PM +0100, Leonardo Bras wrote:
> > They will be used on a later commit to make use of the FEAT_HACDBS
> > mechanism if available.
> 
> Checked against DDI0601 2026-03:
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>

Thanks Mark!

