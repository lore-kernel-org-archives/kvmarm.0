Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB74B7B
	for <kvmarm@lists.linux.dev>; Sat,  3 Dec 2022 08:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFC9C433C1;
	Sat,  3 Dec 2022 08:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670055917;
	bh=Wqok4FHLhgxXM4mLQpg+789IGSwx4hU/a/ecXqnHTBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YqWdmKNF+vpsB+YsEkhgH/PO0OaRRLBj2l3oLf8sO6z39YFmsmJay//cLXdFIvZFj
	 yAbdt53DoMgC9u6UdIQiNovfKNwJGTMKRsVKut60ZYMXTmHCJaXlwpuouCPrc3pI7E
	 Bf4r4FkPpRdK3PWR4AvmHvU4an8DkeE/4OYMuXQM9FGKX+gl0Y7+cFiFKLVkoqdW+K
	 I/XgtWTonvCo0y7zH6539eNPLQp21YJUQnJFJK+2D0UmaFzXbz6pDvF+CBi0Ow/Ew7
	 TkwxggSGaIU9eSAM5FxEGBl7lbfvF5efY/mquBvPq0PpLYXDNPW8KvPxiWVO7evmQ9
	 MZPCi8+cYdUVA==
Date: Sat, 3 Dec 2022 09:25:10 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 00/14] arm64/nmi: Support for FEAT_NMI
Message-ID: <Y4sH5qX5bK9xfEBp@lpieralisi>
References: <20221112151708.175147-1-broonie@kernel.org>
 <87edthtzoz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edthtzoz.wl-maz@kernel.org>

On Fri, Dec 02, 2022 at 06:42:20PM +0000, Marc Zyngier wrote:
> On Sat, 12 Nov 2022 15:16:54 +0000,
> Mark Brown <broonie@kernel.org> wrote:
> > 
> > This series enables the architecture and GIC support for the arm64
> > FEAT_NMI and FEAT_GICv3_NMI extensions in host kernels. These introduce
> > support for a new category of interrupts in the architecture code which
> > we can use to provide NMI like functionality, though the interrupts are
> > in fact maskable as the name would not imply. The GIC support was done
> > by Loreozo Pieralisi.
> 
> FWIW, I have stashed a rework of my 2 year old vgic NMI series at
> [1]. It hasn't broken non-NMI behaviour in my early testing, but my
> FVP is out of commission for the time being.

Thanks Marc, I will test the changes and update the ones I made
already accordingly, I should be able to do that next week I have
been sick but things are on the mend.

Lorenzo

> 
> What could possibly go wrong?
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=arm64/nmi
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
