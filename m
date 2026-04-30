Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345642E3B15;
	Thu, 30 Apr 2026 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777563361; cv=none; b=LkosrFUpHtrzqGQnOiV+7kw/8vTDNzebcXqb3srjZJDFsJKL0kuacDWS7UDLlkik5sDkbrISacv1jF0pEZ5rReKrp89YBv5bmWYXiJ5grHXV42n7pWODvyRnNPrFNuzWxH9BlBhrWYoIq2TkBtCttTu7MAH47c0LkXQa86nElRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777563361; c=relaxed/simple;
	bh=gzTlnjHw8z8mwv/xrWX3uCr8DWsCDpEaX9cnmlYIzL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=n0mUb5mZkIKUZv2kZ9uElRLGuZjz7HfNzCecwIOgdVOTKOXa3/mtOVkHTg4CHlFyrkv8DNSFsUYN3VTsXKeC8l1YJlB8PZAlu0cXhOVqmqofgBxLAvHxEG/ODApcxb27AI70pVdt6/USw7DMR+Rzt/5nFyvpCuYpYUGlHPHrnzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rxVLEs6U; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rxVLEs6U"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D4A332D1;
	Thu, 30 Apr 2026 08:35:54 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 212283F763;
	Thu, 30 Apr 2026 08:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777563359; bh=gzTlnjHw8z8mwv/xrWX3uCr8DWsCDpEaX9cnmlYIzL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxVLEs6Uu9YtFHgDKWpqFThQucat2oz2BVkAKJuDquKK56IPfzpBNZYTsMFNEbVp1
	 pemTxhelUalIb7Qi82U6Rxdc/+UMhQAMRDNwKfIkadkFtpiJHVDXyWH9iIQJcPlhY+
	 k6wBIDO5CwXuT6qTDMLK+lOqFVOyJml4tIhzFcX0=
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
Date: Thu, 30 Apr 2026 16:35:52 +0100
Message-ID: <afN21w6J4Awg3gV3@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <86a4ukzel3.wl-maz@kernel.org>
References: <20260430111424.3479613-2-leo.bras@arm.com> <86bjf0zj2p.wl-maz@kernel.org> <afNZQKIiKmHPD5My@devkitleo> <86a4ukzel3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Apr 30, 2026 at 03:51:20PM +0100, Marc Zyngier wrote:
> On Thu, 30 Apr 2026 14:29:37 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > On Thu, Apr 30, 2026 at 02:14:22PM +0100, Marc Zyngier wrote:
> > > On Thu, 30 Apr 2026 12:14:04 +0100,
> > > Leonardo Bras <leo.bras@arm.com> wrote:
> > > 
> > > > d - In __kvm_arch_dirty_log_clear() there is no way to predict how long
> > > >     should be the buffer, so I used 1x PAGE_SIZE, and when it gets full
> > > >     it's cleaned and reused. Should I let users configure that over a
> > > >     parameter, or is it overthinking?
> > > 
> > > How long is a piece of string? We can't know that. A single page feels
> > > very small in the 4kB case, and letting userspace define the size of
> > > that buffer seems a likely requirement.
> > > 
> > 
> > Ok, as a KVM parameter, or as a compile-time option?
> 
> Noticed the "userspace" word in there? It *has* to be controlled by
> userspace one way or another. So not as a kernel parameter, and
> *never* as a compile option.

Okay, I would suggest that a module parameter could be set by userspace, 
but I remember now that it is usually built in the kernel instead. Also, it 
could be bad having this set for the whole system, instead of per-VM.

How do you suggest letting userspace control that?
(All I could think was using an ioctl / API of any sorts, which would 
require changing the VMMs as well.)

> 
> > > > Kernel v7.0.0 + this patchset builds properly, passing both kvm selftests
> > > > for dirty-bit tracking[2], on HW HACDBS enabled or disabled.
> > > 
> > > I have absolutely no trust in these tests.
> > > 
> > > Have you enabled a VMM to make use of these APIs, and actively
> > > migrated running guests? That's the level of testing I'd like to see,
> > > as the selftests are not what people run in production...
> > > 
> > 
> > There is no enablement needed on VMM side.
> > Yes, I have created a VM on upstream qemu with --enable-kvm and migrated it 
> > on the same host. (Inside a model)
> > 
> > That was the first test I used, but then I found out that kvm selftests 
> > stress up multiple scenarios in an easier way.
> 
> Except when they don't. In my experience, the selftests are only there
> to give the CI people the fuzzy feeling that they are doing something
> useful.

LOL

> I have a collection of examples indicating that what these
> things test is not representative of the bugs we have in KVM.
> 

Fair enough... it was tested in qemu live migration, and it works properly 
(migrated from 2 instances of qemu in the same host, emulated by model).

> > Do you prefer me to test on any specific scenario, or does whatever qemu
> > uses as a default parameter work well enough?
> 
> I want to hear about testing at a scale that make sense for production
> VMs, including live migrating between hosts while under memory
> pressure (swapping out).

I agree that's a more interesting test.

> 
> I'm also interested in efficiency: how much better is HACDBS compared
> to the current page faulting? 

The terms are indeed confusing, but HACDBS is just the cleaning accelerator 
for dirty-bit. It means it will only affect how long it takes to transverse 
the page table making pages in the array writable-dirty -> writable-clean.

That being said, it regards to efficiency:
Well, as I only have the model to test that, I am limmited to those 
results, which may not reflect reality.

As an example, on dirty_log_perf_test, the cleaning process took much 
longer (8x) compared to software cleaning, even when faced with no error, 
and entries that fit the array (4k page above). If it took that long even 
in this ideal scenario, it means the HACDBS mechanism implemented in the 
model takes much longer than software, which is counter-intuitive.

> Just having patches for a feature is not
> enough to decide adoption of that feature. Show me the benefits in a
> quantitative way (within the limits of the model, of course).

Sure, I will try measuring migration between 2 instances of the model, and 
see how qemu live migration time is affected, then post the results in this 
thread for us to compare.

Thanks!
Leo

