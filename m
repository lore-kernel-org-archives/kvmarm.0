Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920F47C;
	Mon, 23 Jan 2023 20:27:55 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674505668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ptopzaIr3YmZ/jpKKhYwyqWy8pmjYpRDY1paJTvdAEU=;
	b=fQrKEQXy3DMKiZgO6ZL0sDHVPNIuNZI/BwkvJwLVjzk2lq64ILx2tN+7QLtT8fumdDmjlM
	sJPXYvqMUqAe55xZY4AYbRHpNxQvBum/428M1wdSXjd4um0SI6cdZBt2d2QEG96r5qFhCv
	Cy9H7UoP50tYu31MYig/bjWPiCp+osE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Hector Martin <marcan@marcan.st>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Will Deacon <will@kernel.org>,
	Sven Peter <sven@svenpeter.dev>,
	James Morse <james.morse@arm.com>,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	asahi@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: (subset) [PATCH 0/3] KVM: arm64: M2 vgic maintenance interrupt rework pre-NV
Date: Mon, 23 Jan 2023 20:27:33 +0000
Message-Id: <167450413533.2570626.8104319764447216703.b4-ty@linux.dev>
In-Reply-To: <20230103095022.3230946-1-maz@kernel.org>
References: <20230103095022.3230946-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 3 Jan 2023 09:50:19 +0000, Marc Zyngier wrote:
> I've spent the holiday break reviving the Nested Virt KVM/arm64
> implementation[1] and allowing it to work on the Apple M2 SoC. The
> amusing part is that it actually works!
> 
> However, the way the vgic is implemented on this HW is still at odds
> with the rest of the architecture, and requires some hacks, some of
> which are independent of the actual NV code. This is what this series
> is about.
> 
> [...]

Applied to kvmarm/next, thanks!

[2/3] KVM: arm64: vgic: Allow registration of a non-maskable maintenance interrupt
      https://git.kernel.org/kvmarm/kvmarm/c/43c5c868bddc
[3/3] irqchip/apple-aic: Register vgic maintenance interrupt with KVM
      https://git.kernel.org/kvmarm/kvmarm/c/13aad0c00bb1

--
Best,
Oliver
