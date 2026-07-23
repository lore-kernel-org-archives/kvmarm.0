Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E35E484237;
	Thu, 23 Jul 2026 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823084; cv=none; b=b5ssLcCE6IByh/CpPvRRDTBqhcw7ABuwGV4IcNoAsndkobe4BkiunbGEg2eFRWhxcp+O+ZMHzNbX5UGwe02UmKIMlWsQal7IAxXzuiRxZ296SK5o9J+ks4Oy8iaeVlSnelB2vdKjjZuN6eR8HnzdmaESVgqO1JTuSegQsF3u/6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823084; c=relaxed/simple;
	bh=/3z+q+N+IfcfDOs3bpZYmWCLTsKKcE7iWQ+YKaFnUlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+Z+RGHJ7y9vKo0dHa+5iHe7F68lk3Q0XoPSrc5jTxraldEQoevaYfFKAEhQbokZMZyjxnUetZxSeNZ1o1wcwTWq/oGYFdGIytEdWQjgH3U1Ebtzpia5m7QQhA+NqNdatznUzpnFwTwG8WNT50D8x8wmtuFs6aUCLDqE3hRmvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FC71F000E9;
	Thu, 23 Jul 2026 16:11:22 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmw0p-0000000872K-2Boh;
	Thu, 23 Jul 2026 16:11:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Update Fuad Tabba's email address
Date: Thu, 23 Jul 2026 17:11:04 +0100
Message-ID: <178482303769.3351010.1300036776625625622.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260719163257.3156529-1-fuad.tabba@linux.dev>
References: <20260719163257.3156529-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 19 Jul 2026 17:32:57 +0100, Fuad Tabba wrote:
> Switch my KVM/arm64 reviewer entry to fuad.tabba@linux.dev, my canonical
> address for kernel work, and add a .mailmap entry so the existing
> tabba@google.com commits map onto it.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Update Fuad Tabba's email address
      commit: 5aab4d46278df6e9e94bd0a92df9a135a5fe16ad

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


