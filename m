Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849B221578F
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 09:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748597261; cv=none; b=nVGbNEDWqTKqBNHTLsmMcnW6aHA9i6cRexp2cx7ET0EyJC/ztYLzDtExN4QYaZ0zvwxFkrCRnnway/1ZB/whz91F/zpcNtey2S9JVl8j4ikrMyiEph8Rhz/9M4jEexscrJs0y/IeArOxYopoM1/QSaSrmzGuL2muo1PSLY4L6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748597261; c=relaxed/simple;
	bh=O7HuuN8Org6gDfEfq/4OR9K7pQjFejpZLqAvhjIpqtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gxH0dQ6mBPLzjP6W7c27ZWD0b8XOOmEre87WB8HZKWQcKr5yhNdKVmW2e0OWk8a6vz/PBQM3DOeQCKNRy+BAUaEbXTxpT/g3QZ9G1U1gQHwDTE06ULo8Oc6leTJOR7HjwoyFWoKbi2H/5rWXqAYQQ1rwBYRh7rRFs7ZIHmeIMpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zk31K/aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zk31K/aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EB2C4CEEB;
	Fri, 30 May 2025 09:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748597261;
	bh=O7HuuN8Org6gDfEfq/4OR9K7pQjFejpZLqAvhjIpqtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zk31K/aUVlp5izQOtwtyGuQ4UdU+JymFJuHoAj1/EJkk+5o9p2P/sOph/QWhMy/8A
	 +l8qcLP5GioyOk6pWFjxEgY6JLhamlGC2FfM3EX7MOJV3KwTPeowxpmaQieNil44Pp
	 2O7BXuNerlJkeUQsAemULPxK2aByxojYsg/g9cB1MQB8aoXT4p7w756uBW2AgUqJLu
	 3N4xbZJlrdbQzd5lBR94EavjmWTIg1lrGg2KypmgRAtnMDwraH1iNPcWo9mqhvzeXl
	 fv0uu8khfyX3wx7i/fPgMHa2eLWiZcargp7P00b2hv1M1oG8k/IXckBjIOJIatCwtc
	 LI9+W6njeIk9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uKw1a-001oIO-LR;
	Fri, 30 May 2025 10:27:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: sysreg: Drag linux/kconfig.h to work around vdso build issue
Date: Fri, 30 May 2025 10:27:34 +0100
Message-Id: <174859721248.1152851.3335877797680496583.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250523170208.530818-1-maz@kernel.org>
References: <20250523170208.530818-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, maz@kernel.org, broonie@kernel.org, scott@os.amperecomputing.com, catalin.marinas@arm.com, oliver.upton@linux.dev, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 23 May 2025 18:02:08 +0100, Marc Zyngier wrote:
> Broonie reports that fed55f49fad18 ("arm64: errata: Work around
> AmpereOne's erratum AC04_CPU_23") breaks one of the vdso selftests
> (vdso_test_chacha) as it indirectly drags asm/sysreg.h.
> 
> It is rather unfortunate (and worrying) that userspace gets built
> with non-UAPI headers. In any case, paper over the issue by dragging
> linux/kconfig.h in asm/sysreg.h. It is the right thing to do, at
> least from the kernel perspective.
> 
> [...]

Applied to next, thanks!

[1/1] arm64: sysreg: Drag linux/kconfig.h to work around vdso build issue
      commit: 94d889713d8b8e3bb78e19a1bbe76e36e34e8113

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


