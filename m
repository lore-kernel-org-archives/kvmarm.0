Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73C53B8120;
	Wed, 27 May 2026 07:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779865379; cv=none; b=bI7ETaK6rdquyFeOGNG/cqFHCpoJf9sXlC3T2srPHX4t15/6gxyUMfAR2ge/nj0K7b19ZrMLUXxhotHr2sHKNf+3zKwHPbYZ12H1b4bxO7vbNyafIuipnpkxWaEiCPyLE49K8z1EZ6D6Z6pLj51o0QLE64XQ3rvgB4ODfPS++lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779865379; c=relaxed/simple;
	bh=c/lbAz2GJRu43euWEDcR4+A2SmeBVLc7f/3LVau6Tls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+Z2PYRI+eMv/QMk5Zljx3oVtT9Bm4pZzygcQsj/YJ3FQ7484HTCLZ8lFOwAEXL0iHCYW8JbunHFuOz6JlGub4k6sM21kzOdWwF6xTjcjJ8hrQo+WkebBcQGFU35DciTkYIh+aq6r6sDiwJfkR+04xKLoEc1HLyAjnPFyrp1RSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Hnk/R+/Z; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=/NbW3KnZ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Hnk/R+/Z";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/NbW3KnZ"
Date: Wed, 27 May 2026 09:02:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779865377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3dqGqOon+2GOM07qx5SG6uKHFRuQAxL2ViprI4rMtWQ=;
	b=Hnk/R+/ZClHgNmd1YPb6Lb9VBGimLRgYBD6oWgi7qSDNR/c6G8l/LVF8NpTy4ZEC4hVKmb
	C5gM7am27PfnMT+ufNOuA2+6yqYsZedWKgxQ+q2Dd6fAw/3IRRrGNo4gp1g/PdJZTejvlr
	ZHIXzSql6WTr1ZpuI4ApB4D5ynBUx+X+bvROXp+mL2fvO1Wv9Zl5VM+Yq9itInF6klEYiR
	0ioy2gOa77qg9Wzsa4jNepNGuWH4q1Nb+yjDfbh812uON6OevhQISWGbh92oC+QUEPc0pO
	FOVYshW1NyuLanSU5JtlFfp7NRY7NCIBLSGlk5maQKrWRTPzIA8V/p2uZo14hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779865377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3dqGqOon+2GOM07qx5SG6uKHFRuQAxL2ViprI4rMtWQ=;
	b=/NbW3KnZg6qdzSIP+6SipMcxG0WvjzysBlXDKgbJUQ4DINIQoFUQ/bv0mvnuy4hOM8Typ9
	jHsMrTDqNd+Sg0Bw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Miroslav Lichvar <mlichvar@redhat.com>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Arthur Kiyanovski <akiyano@amazon.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Rodolfo Giometti <giometti@enneenne.com>, Oliver Upton <oupton@kernel.org>, 
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Peter Hilber <peter.hilber@oss.qualcomm.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, linux-wireless@vger.kernel.org, 
	linux-sound@vger.kernel.org
Subject: Re: [patch 05/24] KVM: arm64: Use ktime_get_snapshot_id() to
 retrieve CLOCK_BOOTTIME
Message-ID: <20260527090236-93aa6356-c51b-4445-9d64-4022dd2126e1@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171223.070087856@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260526171223.070087856@kernel.org>

On Tue, May 26, 2026 at 07:13:53PM +0200, Thomas Gleixner wrote:
> ktime_get_snapshot() is replaced by ktime_get_snapshot_id() which allows to
> request a particular CLOCK ID to be captured along with the clocksource
> counter.
> 
> Convert the tracing mechanism over and use the new
> system_time_snapshot::sys field, which holds the system timestamp selected
> by the CLOCK ID argument.
> 
> No functional change intended.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Vincent Donnefort <vdonnefort@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: kvmarm@lists.linux.dev

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
