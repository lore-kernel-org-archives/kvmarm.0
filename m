Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B1E423A81;
	Thu, 30 Apr 2026 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555790; cv=none; b=kS64K5aXBnem7Yz76jZ0htwcvZgoWHp5OWKUaCsI8c/aa8v6Qb5JC2dMJfQKXulqZ8eRH/a9g6hQVqAJC3HJ/ZsNvqio5E+iygwqU7jvxLJkvRbon2P2w+Cfnk4XqI14SS2CmPTbRfyBJCOGZ/f0Tcrlmi0eLpVafirY9iE0xLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555790; c=relaxed/simple;
	bh=/W1GRuxZq0cC6A7wpquemE4YB2GQRO11YgKNzJgpAzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=CJUgm2bCqU2MevY6xPmnzO7FqYNwcbg7H71WFvBueUFfZgzCnIZxKTXJmsbUxisqoYiJSFFAB7414cwGh04KrrzYLwSuIKS5u8UC2AwVr9WMfpNYjPRQey94ZcX7HRsW6u+rgO03p0ut+2hurLC4563VP6+izLgvQsdpV3M9Yrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MIV0wfnW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MIV0wfnW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBE341AED;
	Thu, 30 Apr 2026 06:29:42 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D026C3F7B4;
	Thu, 30 Apr 2026 06:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777555788; bh=/W1GRuxZq0cC6A7wpquemE4YB2GQRO11YgKNzJgpAzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIV0wfnWvMpN+DWDEs3DC7LO+ywU67ncAAqeBECPc/hmIVJgitsfq1OPtKUbFTwdg
	 nvOWGEn5C1XToufUlAVzncZQtaq2SSb2kSiSyexB5Rb+sxsNKCvPTOvEJa/YsvsNmT
	 E6Ci7q2Kk9ABl0De8i+eB010YSc/82PNfDsg8rYA=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
	Mark Brown <broonie@kernel.org>,
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
Subject: Re: [PATCH v1 00/12] KVM Dirty-bit cleaning accelerator (HACDBS)
Date: Thu, 30 Apr 2026 14:29:37 +0100
Message-ID: <afNZQKIiKmHPD5My@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <86bjf0zj2p.wl-maz@kernel.org>
References: <20260430111424.3479613-2-leo.bras@arm.com> <86bjf0zj2p.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Apr 30, 2026 at 02:14:22PM +0100, Marc Zyngier wrote:
> On Thu, 30 Apr 2026 12:14:04 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> 
> [...]
> 
> I haven't had a chance to look at any of this yet, but just on these
> points:
> 
> > b - checkpatch.pl keeps bothering me to add an entry in MAINTAINERS file,
> >     and I like the idea of maintaining this. Is there any rule or
> >     common sense on this? Should I add this entry, or should I leave it
> >     in the arch/arm64/kvm/ general rule?
> 
> No specific entry in MAINTAINERS required (or wanted). This falls into
> the normal KVM/arm64 maintenance. And don't worry, we know where to
> find you when it will come to fixing this stuff.
> 

Got it

> > c - There are some trace_prink() I have left in the code, as they could
> >     be helpful to check when HACDBS is not performing as well as it
> >     should. Should I introduce a tracepoint instead? or just ignore it?
> >     (it's triggered on HACDBS error, but as it falls back to software in
> >     that case, it should not impact correctness, only performance).
> 
> Debug infrastructure should be preferably *removed* altogether.
> trace_printk() is definitely a big no-no.
> 

Will remove it then

> > d - In __kvm_arch_dirty_log_clear() there is no way to predict how long
> >     should be the buffer, so I used 1x PAGE_SIZE, and when it gets full
> >     it's cleaned and reused. Should I let users configure that over a
> >     parameter, or is it overthinking?
> 
> How long is a piece of string? We can't know that. A single page feels
> very small in the 4kB case, and letting userspace define the size of
> that buffer seems a likely requirement.
> 

Ok, as a KVM parameter, or as a compile-time option?

> > 
> > Kernel v7.0.0 + this patchset builds properly, passing both kvm selftests
> > for dirty-bit tracking[2], on HW HACDBS enabled or disabled.
> 
> I have absolutely no trust in these tests.
> 
> Have you enabled a VMM to make use of these APIs, and actively
> migrated running guests? That's the level of testing I'd like to see,
> as the selftests are not what people run in production...
> 

There is no enablement needed on VMM side.
Yes, I have created a VM on upstream qemu with --enable-kvm and migrated it 
on the same host. (Inside a model)

That was the first test I used, but then I found out that kvm selftests 
stress up multiple scenarios in an easier way.

Do you prefer me to test on any specific scenario, or does whatever qemu 
uses as a default parameter work well enough?

Thanks!
Leo
