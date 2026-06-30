Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F0043CEC3;
	Tue, 30 Jun 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782831031; cv=none; b=dL7cDu8PUrUncH2fKs7/6/5iYcDwHkYK61GqukyIShdnU5zLlYix8TNYSYHPGtcutfzbVfhIJ2oh9QadO/MYbSqzLyXcZfqQB0diI/IbrRt+m8nD+2bi3rGBv2Rv/+/SVD1IzvaEt3PWq0py1Gukpxl0Ec4yH4hRwqa8ZFZ8fhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782831031; c=relaxed/simple;
	bh=FmGcRpgqVH1Jyet3amoELywEs1aHDjFjiXmR4Ai9K98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=H4CTvetPQoNjJYqq4UwmYT3NKdt0p2KOQr5XIIGJSVP9Vze2TdxMlfnv7QK1FXL0FBL+mzJcUCNMbNdsMTxaq3c7Gr7fR+GWMnxf4Lu/Sq0eTU0wsOPdpAAUnoJY2N6IhHKqqyGzphfrX0p44RN3lL1LJLT9VfyCI+8EQWxtjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DEus4bOr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DEus4bOr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44C282ED2;
	Tue, 30 Jun 2026 07:50:24 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A158A3F85F;
	Tue, 30 Jun 2026 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782831028; bh=FmGcRpgqVH1Jyet3amoELywEs1aHDjFjiXmR4Ai9K98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEus4bOrMtPLgrSAGt0EtnVJSrPt183sUxeCw5swqIK7G/W+bDiUNlIa/ENsn1q9S
	 Ix+mwplKNj5DpeBcrAHKKzV8K/1MCOx6g4fV2IBjAXx7Kuo0F4lJTHOlnrbbqtsCKY
	 2dyl9M0CURgvFIFZVqY/6Inv2dcOymDf4jQSKr4o=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Kees Cook <kees@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/13] KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ
Date: Tue, 30 Jun 2026 15:50:17 +0100
Message-ID: <akPXqZQBKET1SyvN@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <akKpxDulRN7zDrgM@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-6-leo.bras@arm.com> <akKpxDulRN7zDrgM@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 10:22:12AM -0700, Oliver Upton wrote:
> On Mon, Jun 29, 2026 at 12:17:53PM +0100, Leonardo Bras wrote:
> > Find via ACPI [1] the Id for HACDBSIRQ, initialize it as a per-cpu IRQ
> > and make sure any cpu able to run virtualization has it active.
> > 
> > Introduce a per-cpu structure used by the HACDBSIRQ handler to keep track
> > of entries size and the status of HACDBS. Size is used to detect end of
> > processing in case the number of entries being processed is different of
> > the supported entries size.
> > 
> > Status may look easily replaceable by checking HACDBS registers now, but
> > will make the OFF/IDLE detection easier in next patches.
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > 
> > [1] https://github.com/tianocore/edk2/issues/12409
> 
> Reference the ACPI specification instead please.

It's not accepted yet, unfortunately. I commented that into the cover 
letter, but forgot to add it here.

> Any link you want to
> include in a changelog should use the Link: footer, the linkage to the
> inline citation will be obvious.

Sure, will remember that in the future.

> 
> If we need to initialize the IRQ I'd really like to see device tree
> bindings for HACDBSIRQ as well. Pretty much any system us plebs can get
> our hands on is gonna be DT anyway.

Agree. I started out with ACPI because that's what the main target is, as 
dirty-logging is focused in Live Migration, which is usually more 
appreciated in the server space, which generally uses ACPI.

I spoke to some people, and I could not hear of anyone releasing a product 
based in DT that would implement this yet, so I postponed the DT 
enablement.

> 
> > +static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
> > +{
> > +	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
> > +	unsigned long err = FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons);
> > +
> > +	switch (err) {
> > +	case HACDBSCONS_EL2_ERR_REASON_NOF:
> > +		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> > +		break;
> > +	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
> > +		/* When size not a power of two >= 4k, exit with reserved TTLW */
> > +		int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
> > +
> > +		if (index >= this_cpu_read(hacdbs_pcp.size)) {
> > +			this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> > +			break;
> > +		}
> > +		fallthrough;
> > +	case HACDBSCONS_EL2_ERR_REASON_STRUCTF:
> > +	case HACDBSCONS_EL2_ERR_REASON_IPAF:
> > +		this_cpu_write(hacdbs_pcp.status, HACDBS_ERROR);
> > +		break;
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> I have a pretty extreme distaste for creating a state machine between
> the callsite and the IRQ handler. The callsite should poll HACDBS for
> completion. The thread has nothing better to do anyway.

Well, there is one argument it could just wait and save some energy, but I 
agree it is not relevant in server space. The main reason I did this is 
because I am planning on later doing an improved version of this that would 
clean the dirty-bit *while* running the guest, and having the IRQ is needed 
for exiting guest so we can notify userspace the cleaning is done. So I 
laid the HACDBSIRQ infra here so we don't have both polling and IRQ options 
happening. 

That idea would require us to add new API (a return value for 'cleaned'), 
and also a new flag for the clean ioctl. We also need the VMM to 
implement that, but then we get a proper cpu usage of cleaning time.

I wanted to start with a backwards compatible version, and do the above 
idea once I put my hands in hardware that implements HACDBS, so I can 
properly measure how much performance we get on above strategy.

What do you think?

Thanks!
Leo

  
