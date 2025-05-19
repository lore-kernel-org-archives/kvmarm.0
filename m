Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516C32690F9;
	Mon, 19 May 2025 11:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747655859; cv=none; b=pgA1K6b3+sgRQU3cdYdka8ElLAyY55UWdHvnw9IRTolXHyjcl6F+aEvSASjxBIUThBgYuxhB6em4So7HBfhDw6qvyq/Y7iG5JXk1GlBe+/Jh77PSnJuKpD6f7HImWV14f55AM8tVyXZoAqQ6S8d7xcoemlC4aTqdez7+n0MQ6xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747655859; c=relaxed/simple;
	bh=n4TMc1TjZswiMa7WKerU3X857XR5hZINxfXi4bLAwAk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uuwfjQ7eJB5zYqXKKJYo2cB46oRNpwymXNUMWkGIfOKRjp4W3QdpvgYg4W195V1eb+rsmXkg1BY7RwnPJJk+wONzjoxhHaupwD/vvbh1qV3QuWH3fPef6gAQCHItRr9rT/RCoPKKoe9ky1S7h7vzGWLnlcp9gGQM5jPQQuyg/VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgBn5VcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgBn5VcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CFC4CEE4;
	Mon, 19 May 2025 11:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747655858;
	bh=n4TMc1TjZswiMa7WKerU3X857XR5hZINxfXi4bLAwAk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OgBn5VcVyZ8E+hHyTq89VzmkV+ZpyOAx9Uw+PWWpK0W3iuMCBMlvpT4dg/8kKdB4i
	 KhSFRKoxfqQEJmyUBUc22jBAoPKier0+/NYaIJZMcQadFnyKBOY80pVUXpGZvd89fe
	 IT+MxPUg0kJTNOXUFN89cVSC/RnKNlbZP4xjkKfSzc34b+FJx/KRGK+kiymhmkdgFj
	 DnrCqT/JMt0qYmY6/hJ/DNLr9QsB3iRZt33ydGiG3lE/LcuA+hYNUDjAz48oYlB/Wc
	 TIbjlou8TcIBkorw3Lzh8hi+2+Fzp0ovzGE1Is2nXIjTahFzNI1/WIYcBbqC7w79qC
	 QejpcNuHa7KfA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uGz7g-00GDWO-6a;
	Mon, 19 May 2025 12:57:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@linaro.org>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: Re: [PATCH v4] arm64: errata: Work around AmpereOne's erratum AC04_CPU_23
Date: Mon, 19 May 2025 12:57:33 +0100
Message-Id: <174765584507.3054461.1827773057173102898.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250513184514.2678288-1-scott@os.amperecomputing.com>
References: <20250513184514.2678288-1-scott@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, james.clark@linaro.org, james.morse@arm.com, joey.gouly@arm.com, kevin.brodsky@arm.com, broonie@kernel.org, mark.rutland@arm.com, oliver.upton@linux.dev, robh@kernel.org, shameerali.kolothum.thodi@huawei.com, shiqiliu@hust.edu.cn, will@kernel.org, yangyicong@hisilicon.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 13 May 2025 11:45:14 -0700, D Scott Phillips wrote:
> On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
> translations for data addresses initiated by load/store instructions.
> Only instruction initiated translations are vulnerable, not translations
> from prefetches for example. A DSB before the store to HCR_EL2 is
> sufficient to prevent older instructions from hitting the window for
> corruption, and an ISB after is sufficient to prevent younger
> instructions from hitting the window for corruption.
> 
> [...]

Applied to next, thanks!

[1/1] arm64: errata: Work around AmpereOne's erratum AC04_CPU_23
      commit: fed55f49fad181be9dfb93c06efc4ab2b71a72a9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


