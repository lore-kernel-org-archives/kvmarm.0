Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB5728EC
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 14:40:16 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 533C61FB;
	Mon, 12 Dec 2022 06:40:56 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.40.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4615D3F71E;
	Mon, 12 Dec 2022 06:40:14 -0800 (PST)
Date: Mon, 12 Dec 2022 14:40:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
Message-ID: <Y5c9SLeJacLYHmP7@FVFF77S0Q05N>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112151708.175147-11-broonie@kernel.org>

On Sat, Nov 12, 2022 at 03:17:04PM +0000, Mark Brown wrote:
> As we do for pseudo NMIs add code to our DAIF management which keeps
> superpriority interrupts unmasked when we have asynchronous exceptions
> enabled.

Please, no. NAK to pretending this is part of DAIF.

The existing hacks to bodge pseudo-NMI into the DAIF management code are
convoluted, difficult to maintain, and they have known cases where they
*cannot* do the right thing. Those existing hacks have proved to be more
trouble than they're worth, and continuing down that path makes things worse.

We must clean up the existing approach *before* we add the real NMI support.

As mentioned elsewhere, I think this means reworking the way we manage
exception masks, and at least:

(a) Adding entry-specific helpers to manipulate abstract exception masks
    covering DAIF + PMR + ALLINT. Those need unmask-at-entry and mask-at-exit
    behaviour, and today only need to manage DAIF + PMR.

    It should be possible to do this ahead of ALLINT / NMI support.

(b) Adding new "logical exception mask" helpers that treat DAIF + PMR + ALLINT
    as separate elements.

    This way we can always save+track all elements if we need to (e.g. for
    irqflag tracking), but we never have to fake up a DAIF element.

Thanks,
Mark.
