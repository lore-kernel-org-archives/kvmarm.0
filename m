Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DBD276049;
	Mon, 29 Jun 2026 17:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782753735; cv=none; b=HlC28yNYkJAiuHA6//WOC6LmBleBXhcpdaurEkW5SitM2vHqQwc4ZVxDRPZf55Ts6rnrxEjwl129cuRLSMatatH7iBi+P6l8ckHSq4nFFOIbrFGJ8zafjOSOrUfaWHQPRufUDHk2pdHAVUDeDXybwEDD92ZJ0P5iW1e8OhPzxGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782753735; c=relaxed/simple;
	bh=M0DeJ2sFGocMw0PyGSHvELWdraexiP68myqBLJQNHFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m16Th1tTagZCDQpNLCtohoDhbTlbgLeRFLajAKsnmJM+K3FvpPctcLkgFIimFb1ceA2msOPQ3RkesWeQU5l9U4/Q38/8Q9SJavQEzwXtIOA2SlZzhwJCGTU7IHTgLZ3jgLPT8wr2RJ7gR/eOFoSmQ8FLTPYi1uoMJbV68hswb0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gbqz5hrO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gbqz5hrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089DE1F000E9;
	Mon, 29 Jun 2026 17:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782753734;
	bh=MJcyRBCuDpTSk1/d5SQB/+Lx7UTikZcZTrFMFGtoOvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gbqz5hrO7fBgXQ2j8893haOH/rdMwMKj41c+b2V2Z0Uo3rrpysIT0kZCrTydl+GhZ
	 145+yOuR91ka9e4QPcbrDM+idcikLa659R1gY+j1y1uS1dDmSNW8dXSuWr1B6lJkLL
	 kAVrQppzIlhrGfDSiz2YNzptozjTEwWYYr7/tGdGPBs/fxoBW7Z+Ez2QfbLbdgFA9J
	 ZykRMu6xyVfadkTOBtnK2AY5uTFemwfRyG7jHE0ykI9P7deLIn4g7Y8h2uLHtledv/
	 lYvsaYxpKEGUe1vN5bOzExuP7k+IByZyCirBWzi7Zgz/NYHbLJhuUP/9cojUeTzoae
	 wQB/XIUGPvRiQ==
Date: Mon, 29 Jun 2026 10:22:12 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Kees Cook <kees@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>, Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>, Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/13] KVM: arm64: Detect (via ACPI) and initialize
 HACDBSIRQ
Message-ID: <akKpxDulRN7zDrgM@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-6-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629111820.1873540-6-leo.bras@arm.com>

On Mon, Jun 29, 2026 at 12:17:53PM +0100, Leonardo Bras wrote:
> Find via ACPI [1] the Id for HACDBSIRQ, initialize it as a per-cpu IRQ
> and make sure any cpu able to run virtualization has it active.
> 
> Introduce a per-cpu structure used by the HACDBSIRQ handler to keep track
> of entries size and the status of HACDBS. Size is used to detect end of
> processing in case the number of entries being processed is different of
> the supported entries size.
> 
> Status may look easily replaceable by checking HACDBS registers now, but
> will make the OFF/IDLE detection easier in next patches.
> 
> Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> 
> [1] https://github.com/tianocore/edk2/issues/12409

Reference the ACPI specification instead please. Any link you want to
include in a changelog should use the Link: footer, the linkage to the
inline citation will be obvious.

If we need to initialize the IRQ I'd really like to see device tree
bindings for HACDBSIRQ as well. Pretty much any system us plebs can get
our hands on is gonna be DT anyway.

> +static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
> +{
> +	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
> +	unsigned long err = FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons);
> +
> +	switch (err) {
> +	case HACDBSCONS_EL2_ERR_REASON_NOF:
> +		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> +		break;
> +	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
> +		/* When size not a power of two >= 4k, exit with reserved TTLW */
> +		int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
> +
> +		if (index >= this_cpu_read(hacdbs_pcp.size)) {
> +			this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> +			break;
> +		}
> +		fallthrough;
> +	case HACDBSCONS_EL2_ERR_REASON_STRUCTF:
> +	case HACDBSCONS_EL2_ERR_REASON_IPAF:
> +		this_cpu_write(hacdbs_pcp.status, HACDBS_ERROR);
> +		break;
> +	}
> +
> +	return IRQ_HANDLED;
> +}

I have a pretty extreme distaste for creating a state machine between
the callsite and the IRQ handler. The callsite should poll HACDBS for
completion. The thread has nothing better to do anyway.

Thanks,
Oliver
